module Playground.Server.Compile where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Argonaut.Core (stringify)
import Data.Codec.Argonaut as CA
import Effect (Effect)
import Effect.Aff (Aff)

import Playground.Session (CellRange, cellRangeCodec)

-- Drives `spago bundle` against runtime-workspace/ after rewriting both
-- `src/Playground/User.purs` and `src/Main.purs` with the supplied
-- synthesised sources. The returned string is already JSON-encoded:
-- `{ js, warnings, errors, types, cellLines }` — `js` nullable, `types`
-- always `[]` until M4 (now populated), `cellLines` carries the per-cell
-- line ranges in Main.purs so the frontend can attribute errors.
foreign import _compileSourcesPromise
  :: String -> String -> String -> Effect (Promise String)

compileSources
  :: { userSource :: String
     , mainSource :: String
     , cellLines :: Array CellRange
     }
  -> Aff String
compileSources s =
  let cellLinesJson = stringify (CA.encode (CA.array cellRangeCodec) s.cellLines)
  in toAffE (_compileSourcesPromise s.userSource s.mainSource cellLinesJson)
