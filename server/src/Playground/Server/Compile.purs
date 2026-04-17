module Playground.Server.Compile where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff)

-- Drives `spago bundle` against runtime-workspace/ after rewriting both
-- `src/Playground/User.purs` and `src/Main.purs` with the supplied
-- synthesised sources. The returned string is already JSON-encoded:
-- `{ js, warnings, errors, types }` with `js` nullable and `types`
-- always `[]` until M4.
foreign import _compileSourcesPromise
  :: String -> String -> Effect (Promise String)

compileSources :: { userSource :: String, mainSource :: String } -> Aff String
compileSources s = toAffE (_compileSourcesPromise s.userSource s.mainSource)
