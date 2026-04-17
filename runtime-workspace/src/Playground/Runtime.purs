module Playground.Runtime
  ( class ToPlaygroundValue
  , toPlaygroundValue
  , emit
  ) where

import Prelude

import Effect (Effect)

-- | Dispatch point for rendering a cell's value. The instance chain below
-- | lets an `Effect a` cell auto-run (HfM-style) and lets plain values fall
-- | through to `show`. Phase 2 will extend this with richer instances for
-- | records, arrays of records, Maybe/Either, etc., rendered via Sigil.
class ToPlaygroundValue a where
  toPlaygroundValue :: a -> Effect String

instance toPlaygroundValueEffect :: ToPlaygroundValue a => ToPlaygroundValue (Effect a) where
  toPlaygroundValue eff = eff >>= toPlaygroundValue
else instance toPlaygroundValueShow :: Show a => ToPlaygroundValue a where
  toPlaygroundValue = pure <<< show

-- | Pushes a (cellId, renderedValue) pair back to the Web Worker host.
-- | The host installs a `__playground_emit` function on `globalThis`
-- | before running the bundle; if it isn't present (e.g. during CLI
-- | testing) this is a no-op.
foreign import emit :: String -> String -> Effect Unit
