module Playground.Server.Compile where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Argonaut.Core (Json, stringify)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)

import Playground.Server.Ide as Ide
import Playground.Session
  ( CellRange
  , CompileError(..)
  , CompileResponse(..)
  , compileErrorCodec
  , compileResponseCodec
  , nullableStringCodec
  )

-- | Runs spago build + bundle against the runtime workspace after
-- | writing the synthesised sources. Returns an intermediate record
-- | the caller (compileSources) decorates with types + cellLines.
foreign import _buildAndBundle :: String -> String -> Effect (Promise Json)

type BuildResult =
  { js :: Maybe String
  , warnings :: Array CompileError
  , errors :: Array CompileError
  , cellIds :: Array String
  }

buildResultCodec :: CA.JsonCodec BuildResult
buildResultCodec = CAR.object "BuildResult"
  { js: nullableStringCodec
  , warnings: CA.array compileErrorCodec
  , errors: CA.array compileErrorCodec
  , cellIds: CA.array CA.string
  }

mkTransportError :: String -> CompileError
mkTransportError msg = CompileError
  { code: "Transport"
  , filename: Nothing
  , position: Nothing
  , message: msg
  }

-- | Orchestrates a full /session/compile: writes the sources, spago
-- | compiles, bundles (if clean), asks Ide for cell types, returns the
-- | final CompileResponse as a JSON string.
compileSources
  :: { userSource :: String
     , mainSource :: String
     , cellLines :: Array CellRange
     }
  -> Aff String
compileSources s = do
  raw <- toAffE (_buildAndBundle s.userSource s.mainSource)
  case CA.decode buildResultCodec raw of
    Left e ->
      pure $ encodeResponse $ CompileResponse
        { js: Nothing
        , warnings: []
        , errors: [ mkTransportError ("buildResult decode: " <> CA.printJsonDecodeError e) ]
        , types: []
        , cellLines: s.cellLines
        }
    Right r -> do
      types <- case r.js of
        -- Only query types when the compile actually succeeded. On
        -- failed compiles the externs are stale and the types would
        -- mis-attribute anyway.
        Just _ -> Ide.queryCellTypes r.cellIds
        Nothing -> pure []
      pure $ encodeResponse $ CompileResponse
        { js: r.js
        , warnings: r.warnings
        , errors: r.errors
        , types
        , cellLines: s.cellLines
        }
  where
  encodeResponse = stringify <<< CA.encode compileResponseCodec
