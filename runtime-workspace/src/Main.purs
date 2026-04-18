module Main where

import Prelude
import Data.Array as Array
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (runAff_)
import Effect.Class (liftEffect)
import Playground.Runtime (class ToPlaygroundValue, done, emit, toPlaygroundValue)
import Playground.User

import Data.Maybe (Maybe(..))


-- let-cells (spliced verbatim)

-- expr-cells (top-level bindings)
cell_c1 = divSafe 100 5
cell_c2 = divSafe 100 0

main :: Effect Unit
main = runAff_ (\_ -> done) do
  v_c1 <- toPlaygroundValue cell_c1
  liftEffect (emit "c1" v_c1)
  v_c2 <- toPlaygroundValue cell_c2
  liftEffect (emit "c2" v_c2)
