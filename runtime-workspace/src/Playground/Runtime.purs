module Playground.Runtime
  ( class ToPlaygroundValue
  , toPlaygroundValue
  , class RecordToPlaygroundValue
  , recordToPlaygroundValue
  , PlaygroundValue(..)
  , emit
  , done
  ) where

import Prelude

import Data.Argonaut.Core (Json, fromArray, fromBoolean, fromNumber, fromObject, fromString, jsonNull, stringify)
import Data.Char (toCharCode)
import Data.Either (Either(..))
import Data.Int (toNumber) as Int
import Data.Maybe (Maybe(..))
import Data.String (contains) as Str
import Data.String.CodeUnits (charAt, singleton) as String
import Data.String.Pattern (Pattern(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Data.Traversable (traverse)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Foreign.Object as Object
import Prim.Row as Row
import Prim.RowList as RL
import Record (get) as Record
import Type.Proxy (Proxy(..))

-- | The structured shape a cell's result takes on the wire. Richer
-- | than `show` output: the frontend can render each constructor with
-- | typographic care. Non-structural types fall through to `PVRaw`
-- | via the `Show` instance at the bottom of the chain.
data PlaygroundValue
  = PVNull
  | PVBool Boolean
  | PVNumber Number
  | PVString String
  | PVArray (Array PlaygroundValue)
  | PVCtor String (Array PlaygroundValue)
  | PVRecord (Array (Tuple String PlaygroundValue))
  | PVRaw String

-- | Serialise to JSON for transport over the Worker emit channel.
encode :: PlaygroundValue -> Json
encode = case _ of
  PVNull -> jsonNull
  PVBool b -> fromBoolean b
  PVNumber n -> fromNumber n
  PVString s -> fromString s
  PVArray xs -> fromArray (map encode xs)
  PVCtor name args -> fromObject $ Object.fromFoldable
    [ Tuple "$ctor" (fromString name)
    , Tuple "args" (fromArray (map encode args))
    ]
  PVRecord fields -> fromObject $ Object.singleton "$record"
    (fromObject (Object.fromFoldable (map (\(Tuple k v) -> Tuple k (encode v)) fields)))
  PVRaw s -> fromObject (Object.singleton "$raw" (fromString s))

-- | Dispatch point for rendering a cell's value. We work in `Aff` so
-- | the chain can transparently await `Aff a` cells (network calls,
-- | timers, long-running effects). Synchronous `Effect a` is lifted in
-- | via the first instance below; scalars and containers are immediate
-- | (wrapped in `pure`).
class ToPlaygroundValue a where
  toPlaygroundValue :: a -> Aff PlaygroundValue

-- Asynchronous/effectful wrappers — first in the chain so they don't
-- fall through to Show (which would fail — no Show for Aff/Effect).
instance toPlaygroundValueAff :: ToPlaygroundValue a => ToPlaygroundValue (Aff a) where
  toPlaygroundValue aff = aff >>= toPlaygroundValue
else instance toPlaygroundValueEffect :: ToPlaygroundValue a => ToPlaygroundValue (Effect a) where
  toPlaygroundValue eff = liftEffect eff >>= toPlaygroundValue

-- Scalars
else instance toPlaygroundValueUnit :: ToPlaygroundValue Unit where
  toPlaygroundValue _ = pure PVNull
else instance toPlaygroundValueBoolean :: ToPlaygroundValue Boolean where
  toPlaygroundValue b = pure (PVBool b)
else instance toPlaygroundValueInt :: ToPlaygroundValue Int where
  toPlaygroundValue n = pure (PVNumber (Int.toNumber n))
else instance toPlaygroundValueNumber :: ToPlaygroundValue Number where
  toPlaygroundValue n = pure (PVNumber n)
else instance toPlaygroundValueString :: ToPlaygroundValue String where
  toPlaygroundValue s = pure (PVString s)
else instance toPlaygroundValueChar :: ToPlaygroundValue Char where
  toPlaygroundValue c = pure (PVString (String.singleton c))

-- Containers
else instance toPlaygroundValueArray :: ToPlaygroundValue a => ToPlaygroundValue (Array a) where
  toPlaygroundValue xs = PVArray <$> traverse toPlaygroundValue xs
else instance toPlaygroundValueMaybe :: ToPlaygroundValue a => ToPlaygroundValue (Maybe a) where
  toPlaygroundValue = case _ of
    Just a -> do
      v <- toPlaygroundValue a
      pure (PVCtor "Just" [ v ])
    Nothing -> pure (PVCtor "Nothing" [])
else instance toPlaygroundValueEither ::
  (ToPlaygroundValue a, ToPlaygroundValue b) => ToPlaygroundValue (Either a b) where
  toPlaygroundValue = case _ of
    Left a -> do
      v <- toPlaygroundValue a
      pure (PVCtor "Left" [ v ])
    Right b -> do
      v <- toPlaygroundValue b
      pure (PVCtor "Right" [ v ])
else instance toPlaygroundValueTuple ::
  (ToPlaygroundValue a, ToPlaygroundValue b) => ToPlaygroundValue (Tuple a b) where
  toPlaygroundValue (Tuple a b) = do
    va <- toPlaygroundValue a
    vb <- toPlaygroundValue b
    pure (PVCtor "Tuple" [ va, vb ])

-- Records: walk the row structurally via RowToList. This means a
-- cell returning `{ avgDensity :: Number, name :: String }` comes back
-- on the wire as a structured object, not `$raw` surface-syntax.
else instance toPlaygroundValueRecord ::
  ( RL.RowToList row list
  , RecordToPlaygroundValue list row
  ) => ToPlaygroundValue (Record row) where
  toPlaygroundValue rec = do
    fields <- recordToPlaygroundValue (Proxy :: Proxy list) rec
    pure (PVRecord fields)

-- Fallback: anything that has Show renders from show-output. A bare
-- uppercase identifier (Africa, LT, Nothing) is treated as a nullary
-- constructor so it round-trips as PVCtor — matches the structured
-- treatment Just, Left, Tuple get from their hand-written instances.
else instance toPlaygroundValueShow :: Show a => ToPlaygroundValue a where
  toPlaygroundValue a = pure (classifyShow (show a))

-- Helper class for walking a record row into [(String, PlaygroundValue)].
class RecordToPlaygroundValue (list :: RL.RowList Type) (row :: Row Type) where
  recordToPlaygroundValue
    :: Proxy list
    -> Record row
    -> Aff (Array (Tuple String PlaygroundValue))

instance recordToPlaygroundValueNil :: RecordToPlaygroundValue RL.Nil row where
  recordToPlaygroundValue _ _ = pure []

instance recordToPlaygroundValueCons ::
  ( IsSymbol name
  , ToPlaygroundValue a
  , Row.Cons name a tail row
  , RecordToPlaygroundValue restList row
  ) => RecordToPlaygroundValue (RL.Cons name a restList) row where
  recordToPlaygroundValue _ rec = do
    let nameProxy = Proxy :: Proxy name
    pv <- toPlaygroundValue (Record.get nameProxy rec)
    rest <- recordToPlaygroundValue (Proxy :: Proxy restList) rec
    pure ([ Tuple (reflectSymbol nameProxy) pv ] <> rest)

-- If `show a` produced a bare constructor identifier, emit it as a
-- structured nullary ctor; otherwise keep the raw surface syntax.
classifyShow :: String -> PlaygroundValue
classifyShow s =
  if isBareCtorIdent s then PVCtor s [] else PVRaw s

isBareCtorIdent :: String -> Boolean
isBareCtorIdent s = case String.charAt 0 s of
  Nothing -> false
  Just c ->
    let n = toCharCode c
        hasSpecial = Str.contains (Pattern " ") s
          || Str.contains (Pattern "(") s
          || Str.contains (Pattern "{") s
          || Str.contains (Pattern "[") s
          || Str.contains (Pattern "\"") s
          || Str.contains (Pattern ",") s
    in n >= 65 && n <= 90 && not hasSpecial

-- | Emit a cell's value to the host. Runs in Effect (synchronous hook)
-- | even though we arrive at the value asynchronously via Aff.
emit :: String -> PlaygroundValue -> Effect Unit
emit id value = _emit id (stringify (encode value))

foreign import _emit :: String -> String -> Effect Unit

-- | Signal the host that all Aff-driven emissions have been
-- | delivered. Called at the end of `runAff_`'s callback in the
-- | synthesised main so the browser Worker / Node child knows it's
-- | safe to close. Without this, a Worker running an Aff cell would
-- | be terminated before its `delay` settles.
foreign import done :: Effect Unit
