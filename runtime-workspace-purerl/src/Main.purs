module Main where

import Prelude

import Effect (Effect)
import Playground.Runtime (PlaygroundValue(..), done, emit, toPlaygroundValue)

-- Placeholder. The Purerl adapter overwrites this on each compile.
-- Smoke test: emit a handful of values covering scalars, arrays,
-- ctors, then signal done.
main :: Effect Unit
main = do
  v1 <- toPlaygroundValue 42
  emit "c1" v1
  v2 <- toPlaygroundValue [ 1, 2, 3 ]
  emit "c2" v2
  emit "c3" (PVCtor "Just" [ PVNumber 42.0 ])
  done
