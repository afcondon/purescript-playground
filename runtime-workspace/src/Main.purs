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
cell_c2 = do
  a <- divSafe 100 5
  b <- divSafe 200 a
  pure (a + b)
cell_c3 = divSafe 100 5 >>= \a ->
  divSafe 200 a >>= \b ->
    pure (a + b)
cell_c4 = do
  x <- [1, 2, 3]
  y <- [10, 20]
  pure (x + y)
cell_c5 = do
  x <- (Right 10 :: Either String Int)
  y <- Right 20
  pure (x + y)

main :: Effect Unit
main = runAff_ (\_ -> done) do
  v_c1 <- toPlaygroundValue cell_c1
  liftEffect (emit "c1" v_c1)
  v_c2 <- toPlaygroundValue cell_c2
  liftEffect (emit "c2" v_c2)
  v_c3 <- toPlaygroundValue cell_c3
  liftEffect (emit "c3" v_c3)
  v_c4 <- toPlaygroundValue cell_c4
  liftEffect (emit "c4" v_c4)
  v_c5 <- toPlaygroundValue cell_c5
  liftEffect (emit "c5" v_c5)
