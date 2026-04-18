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

import Data.Char (toCharCode)
import Data.Either (Either(..))
import Data.Int (round, toNumber) as Int
import Data.Maybe (Maybe(..))
import Data.String (contains) as Str
import Data.String.CodeUnits (charAt, singleton) as String
import Data.String.Common (joinWith, replaceAll) as Str
import Data.String.Pattern (Pattern(..), Replacement(..))
import Data.Symbol (class IsSymbol, reflectSymbol)
import Data.Traversable (traverse)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Prim.Row as Row
import Prim.RowList as RL
import Record (get) as Record
import Type.Proxy (Proxy(..))

-- | Same wire format as the JS runtime; hand-rolled JSON encoder
-- | because the Purerl package set doesn't ship argonaut.
data PlaygroundValue
  = PVNull
  | PVBool Boolean
  | PVNumber Number
  | PVString String
  | PVArray (Array PlaygroundValue)
  | PVCtor String (Array PlaygroundValue)
  | PVRecord (Array (Tuple String PlaygroundValue))
  | PVRaw String

encode :: PlaygroundValue -> String
encode = case _ of
  PVNull -> "null"
  PVBool b -> if b then "true" else "false"
  PVNumber n -> showNumber n
  PVString s -> jsonString s
  PVArray xs -> "[" <> Str.joinWith "," (map encode xs) <> "]"
  PVCtor name args ->
    "{\"$ctor\":" <> jsonString name
      <> ",\"args\":[" <> Str.joinWith "," (map encode args) <> "]}"
  PVRecord fields ->
    "{\"$record\":{"
      <> Str.joinWith "," (map encodeField fields)
      <> "}}"
    where encodeField (Tuple k v) = jsonString k <> ":" <> encode v
  PVRaw s -> "{\"$raw\":" <> jsonString s <> "}"

showNumber :: Number -> String
showNumber n =
  let asInt = Int.round n
  in if Int.toNumber asInt == n
     then show asInt
     else _formatFloat n

-- Erlang's default Show for Number gives scientific notation
-- (4.2e+01) — unreadable in JSON. We format via float_to_binary with
-- compact + 12-digit precision.
foreign import _formatFloat :: Number -> String

jsonString :: String -> String
jsonString s = "\"" <> escape s <> "\""
  where
  escape =
    Str.replaceAll (Pattern "\\") (Replacement "\\\\")
      >>> Str.replaceAll (Pattern "\"") (Replacement "\\\"")
      >>> Str.replaceAll (Pattern "\n") (Replacement "\\n")
      >>> Str.replaceAll (Pattern "\r") (Replacement "\\r")
      >>> Str.replaceAll (Pattern "\t") (Replacement "\\t")

-- | Purerl's `toPlaygroundValue` returns `Effect` — no `Aff` in the
-- | Purerl package set (concurrency goes through erl-process). Aff-
-- | typed cells will fail to compile here, which is the honest signal
-- | (you can't `Aff` on BEAM, you model it as a process).
class ToPlaygroundValue a where
  toPlaygroundValue :: a -> Effect PlaygroundValue

instance toPlaygroundValueEffect :: ToPlaygroundValue a => ToPlaygroundValue (Effect a) where
  toPlaygroundValue eff = eff >>= toPlaygroundValue

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

else instance toPlaygroundValueRecord ::
  ( RL.RowToList row list
  , RecordToPlaygroundValue list row
  ) => ToPlaygroundValue (Record row) where
  toPlaygroundValue rec = do
    fields <- recordToPlaygroundValue (Proxy :: Proxy list) rec
    pure (PVRecord fields)

else instance toPlaygroundValueShow :: Show a => ToPlaygroundValue a where
  toPlaygroundValue a = pure (classifyShow (show a))

class RecordToPlaygroundValue (list :: RL.RowList Type) (row :: Row Type) where
  recordToPlaygroundValue
    :: Proxy list
    -> Record row
    -> Effect (Array (Tuple String PlaygroundValue))

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

emit :: String -> PlaygroundValue -> Effect Unit
emit id value =
  -- Match the other adapters' wire shape: the envelope's `value`
  -- field is a JSON *string* containing the PlaygroundValue's JSON,
  -- not the JSON value inline. Lets the frontend use one decoder.
  let line =
        "{\"type\":\"emit\",\"id\":" <> jsonString id
          <> ",\"value\":" <> jsonString (encode value) <> "}"
  in _emitLine line

foreign import _emitLine :: String -> Effect Unit

foreign import done :: Effect Unit
