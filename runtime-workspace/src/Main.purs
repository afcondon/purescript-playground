module Main where

import Prelude
import Effect (Effect)
import Playground.Runtime (class ToPlaygroundValue, emit, toPlaygroundValue)
import Playground.User

-- let-cells (spliced verbatim)

-- expr-cells (top-level bindings)
cell_c1 = double 21
cell_c2 = map double [1, 2, 3, 4, 5]
cell_c3 = double 21 + double 21

main :: Effect Unit
main = do
  emit "c1" =<< toPlaygroundValue cell_c1
  emit "c2" =<< toPlaygroundValue cell_c2
  emit "c3" =<< toPlaygroundValue cell_c3
