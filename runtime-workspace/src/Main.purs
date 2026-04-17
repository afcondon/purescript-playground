module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Data.Array (length, range)

main :: Effect Unit
main = log ("range 1..10 has length " <> show (length (range 1 10)))
