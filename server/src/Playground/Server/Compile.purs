module Playground.Server.Compile where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff)

-- Drives `spago bundle` against runtime-workspace/ after rewriting its
-- `src/Main.purs` with the supplied PureScript source. The returned string
-- is already JSON-encoded: `{ js, warnings, errors }` with `js` nullable.
--
-- We return the JSON verbatim so the router can hand it to `ok` without
-- a round-trip through a PureScript ADT for M1. Phase 2 will decode it
-- into structured results once we start using the warnings/errors fields.
foreign import _compileMainPromise :: String -> Effect (Promise String)

compileMain :: String -> Aff String
compileMain src = toAffE (_compileMainPromise src)
