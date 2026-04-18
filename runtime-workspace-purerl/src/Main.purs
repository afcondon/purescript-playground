module Main where

import Prelude

import Effect (Effect)
import Playground.Runtime (PlaygroundValue(..), done, emit, toPlaygroundValue)

-- Placeholder. The Purerl adapter overwrites this on each compile.
main :: Effect Unit
main = do
  v1 <- toPlaygroundValue 42
  emit "c1" v1
  done
