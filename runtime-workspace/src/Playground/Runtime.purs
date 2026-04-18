module Playground.Runtime
  ( class ToPlaygroundValue
  , toPlaygroundValue
  , PlaygroundValue(..)
  , emit
  ) where

import Prelude

import Data.Argonaut.Core (Json, fromArray, fromBoolean, fromNumber, fromObject, fromString, jsonNull, stringify)
import Data.Either (Either(..))
import Data.Int (toNumber) as Int
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (singleton) as String
import Data.Traversable (traverse)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Foreign.Object as Object

-- | The structured shape a cell's result takes on the wire. Richer
-- | than `show` output: the frontend can render each constructor with
-- | typographic care (arrays laid out, Maybe/Either tagged, nested
-- | records navigable later). Non-structural types fall through to
-- | `PVRaw` via the `Show` instance at the bottom of the chain.
data PlaygroundValue
  = PVNull
  | PVBool Boolean
  | PVNumber Number
  | PVString String
  | PVArray (Array PlaygroundValue)
  | PVCtor String (Array PlaygroundValue)  -- e.g. Just/Nothing/Left/Right/Tuple
  | PVRaw String                            -- fallback from show

-- | Serialise to JSON for transport over the Worker emit channel.
-- | Wire form mirrors the ADT: scalars round-trip as themselves,
-- | arrays as JSON arrays, constructors and raw strings as tagged
-- | objects with `$ctor`/`$raw` keys.
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
  PVRaw s -> fromObject (Object.singleton "$raw" (fromString s))

-- | Dispatch point for rendering a cell's value. The instance chain
-- | below maps PureScript types to rich structural representations.
class ToPlaygroundValue a where
  toPlaygroundValue :: a -> Effect PlaygroundValue

-- Effectful wrapper — always goes first so Effect a doesn't get caught
-- by the Show fallback.
instance toPlaygroundValueEffect :: ToPlaygroundValue a => ToPlaygroundValue (Effect a) where
  toPlaygroundValue eff = eff >>= toPlaygroundValue

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

-- Fallback: anything that has Show renders as raw show-output.
else instance toPlaygroundValueShow :: Show a => ToPlaygroundValue a where
  toPlaygroundValue a = pure (PVRaw (show a))

-- | Emit a cell's value to the host (Worker for the browser adapter).
-- | JSON-encodes via `encode` and calls through to the foreign hook.
emit :: String -> PlaygroundValue -> Effect Unit
emit id value = _emit id (stringify (encode value))

foreign import _emit :: String -> String -> Effect Unit
