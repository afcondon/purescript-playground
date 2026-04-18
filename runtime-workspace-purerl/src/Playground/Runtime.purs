module Playground.Runtime
  ( class ToPlaygroundValue
  , toPlaygroundValue
  , PlaygroundValue(..)
  , emit
  , done
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Int (round, toNumber) as Int
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (singleton) as String
import Data.String.Common (joinWith, replaceAll) as Str
import Data.String.Pattern (Pattern(..), Replacement(..))
import Data.Traversable (traverse)
import Data.Tuple (Tuple(..))
import Effect (Effect)

-- | Same wire format as the JS runtime; hand-rolled JSON encoder
-- | because the Purerl package set doesn't ship argonaut.
data PlaygroundValue
  = PVNull
  | PVBool Boolean
  | PVNumber Number
  | PVString String
  | PVArray (Array PlaygroundValue)
  | PVCtor String (Array PlaygroundValue)
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

else instance toPlaygroundValueShow :: Show a => ToPlaygroundValue a where
  toPlaygroundValue a = pure (PVRaw (show a))

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
