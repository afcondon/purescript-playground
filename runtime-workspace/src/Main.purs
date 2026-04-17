module Main where

import Prelude
import Effect (Effect)
import Playground.Runtime (class ToPlaygroundValue, emit, toPlaygroundValue)
import Playground.User

-- let-cells (spliced verbatim)

-- expr-cells (top-level bindings)
cell_c1 = doubbble 21

main :: Effect Unit
main = do
  emit "c1" =<< toPlaygroundValue cell_c1
