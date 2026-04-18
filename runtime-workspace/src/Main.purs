module Main where

import Prelude
import Data.Array as Array
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Playground.Runtime (class ToPlaygroundValue, emit, toPlaygroundValue)
import Playground.User

-- let-cells (spliced verbatim)

-- expr-cells (top-level bindings)
cell_c1 = double 21
cell_c2 = Just 42
cell_c3 = [Tuple "a" 1, Tuple "b" 2]

main :: Effect Unit
main = do
  emit "c1" =<< toPlaygroundValue cell_c1
  emit "c2" =<< toPlaygroundValue cell_c2
  emit "c3" =<< toPlaygroundValue cell_c3
