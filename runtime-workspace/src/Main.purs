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

import Effect (Effect)
import Effect.Class (liftEffect)
import Erl.Process (Process, ProcessM, receive, self, spawn, unsafeRunProcessM, (!))


-- let-cells (spliced verbatim)

-- expr-cells (top-level bindings)
cell_c1 = roundTrip
cell_c2 = runCounter

main :: Effect Unit
main = runAff_ (\_ -> done) do
  v_c1 <- toPlaygroundValue cell_c1
  liftEffect (emit "c1" v_c1)
  v_c2 <- toPlaygroundValue cell_c2
  liftEffect (emit "c2" v_c2)
