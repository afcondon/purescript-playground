module Playground.Server.Compile
  ( compileSources
  ) where

import Prelude

import Data.Argonaut.Core (stringify)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)

import Playground.Server.Adapter (Adapter)
import Playground.Server.Ide as Ide
import Playground.Session
  ( CellEmit
  , CellRange
  , CompileError(..)
  , CompileResponse(..)
  , cellEmitCodec
  , compileErrorCodec
  , compileResponseCodec
  , nullableStringCodec
  )

-- | Intermediate record an Adapter returns over the FFI.
type BuildResult =
  { js :: Maybe String
  , warnings :: Array CompileError
  , errors :: Array CompileError
  , cellIds :: Array String
  , emits :: Array CellEmit
  }

buildResultCodec :: CA.JsonCodec BuildResult
buildResultCodec = CAR.object "BuildResult"
  { js: nullableStringCodec
  , warnings: CA.array compileErrorCodec
  , errors: CA.array compileErrorCodec
  , cellIds: CA.array CA.string
  , emits: CA.array cellEmitCodec
  }

mkTransportError :: String -> CompileError
mkTransportError msg = CompileError
  { code: "Transport"
  , filename: Nothing
  , position: Nothing
  , message: msg
  }

-- | Orchestrates a full /session/compile: asks the adapter for a build
-- | outcome, queries Ide for cell types on success, assembles and
-- | encodes the final CompileResponse.
compileSources
  :: Adapter
  -> { userSource :: String
     , mainSource :: String
     , cellLines :: Array CellRange
     }
  -> Aff String
compileSources adapter s = do
  raw <- adapter.bundle s.userSource s.mainSource
  case CA.decode buildResultCodec raw of
    Left e ->
      pure $ encodeResponse $ CompileResponse
        { js: Nothing
        , warnings: []
        , errors:
            [ mkTransportError
                ("adapter " <> adapter.name <> " returned undecodable BuildResult: " <> CA.printJsonDecodeError e)
            ]
        , types: []
        , cellLines: s.cellLines
        , emits: []
        , runtime: adapter.name
        }
    Right r -> do
      types <-
        -- Purerl compiles to a different output dir (its own workspace)
        -- than the purs ide sidecar watches, so the lookup would miss
        -- the cell_<id> bindings. Skip types for Purerl; a second
        -- sidecar pointed at runtime-workspace-purerl/output could
        -- populate them later.
        if adapter.name == "purerl" then pure []
        else case r.js of
          Just _ -> Ide.queryCellTypes r.cellIds
          Nothing ->
            if not (null r.errors) then pure []
            else Ide.queryCellTypes r.cellIds
      pure $ encodeResponse $ CompileResponse
        { js: r.js
        , warnings: r.warnings
        , errors: r.errors
        , types
        , cellLines: s.cellLines
        , emits: r.emits
        , runtime: adapter.name
        }
  where
  encodeResponse = stringify <<< CA.encode compileResponseCodec
  null xs = case xs of
    [] -> true
    _ -> false
