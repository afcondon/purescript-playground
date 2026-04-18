module Playground.User where

import Prelude

import Data.Maybe (Maybe(..))

divSafe :: Int -> Int -> Maybe Int
divSafe _ 0 = Nothing
divSafe n d = Just (n / d)
