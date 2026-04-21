module Main where

import Prelude
import Data.Array as Array
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (runAff_)
import Effect.Class (liftEffect)
import Playground.Runtime
import Playground.User

import Data.Array as Array
import Data.Foldable (foldl)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.Number.Format (toString) as Num
import Data.Tuple (Tuple(..))
import DataViz.Layout.Hierarchy.Pack (HierarchyData(..), PackNode(..), defaultPackConfig, hierarchy, pack)
import Data.Number (sqrt)
import Data.Int (toNumber)
import Data.FoldableWithIndex (foldlWithIndex)


-- let-cells (spliced verbatim)

-- expr-cells (top-level bindings)
cell_c1 = Array.length countries
cell_c2 = continentTotals
cell_c3 = bubbleSvg
cell_c4 = bubbleSvg2
cell_c5 = Array.take 5 (Array.sortBy (\a b -> compare (b.population / b.areaKm2) (a.population / a.areaKm2)) countries)
cell_c6 = 5 + 4

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
  v_c6 <- toPlaygroundValue cell_c6
  liftEffect (emit "c6" v_c6)
