module Playground.User where

import Prelude

import Data.Maybe (Maybe(..))

-- Safe division: Nothing on divide-by-zero, Just q otherwise.
divSafe :: Int -> Int -> Maybe Int
divSafe _ 0 = Nothing
divSafe n d = Just (n / d)
