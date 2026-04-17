module Playground.Session where

import Prelude

import Data.Argonaut.Core as AJ
import Data.Codec.Argonaut (JsonCodec)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))

-- | A user module — a PureScript source fragment edited in the LHS panel.
-- | The backend rewrites the module header to `module Playground.User where`
-- | before forwarding to trypurescript, so the user's `module Foo where`
-- | line is for their eyes only.
newtype UserModule = UserModule { source :: String }

userModuleCodec :: JsonCodec UserModule
userModuleCodec = CA.prismaticCodec "UserModule" (Just <<< UserModule) un $
  CAR.object "UserModule" { source: CA.string }
  where un (UserModule r) = r

-- | A single playground cell.
-- |
-- | `id` is assigned by the frontend and is stable across edits — the backend
-- | uses it as the synthesised top-level binding name (prefixed `cell_`).
-- |
-- | `kind` is `"expr"` for a cell whose value is shown, or `"let"` for a cell
-- | that binds a name visible to later cells but is not itself displayed.
newtype Cell = Cell
  { id :: String
  , kind :: String
  , source :: String
  }

cellCodec :: JsonCodec Cell
cellCodec = CA.prismaticCodec "Cell" (Just <<< Cell) un $
  CAR.object "Cell"
    { id: CA.string
    , kind: CA.string
    , source: CA.string
    }
  where un (Cell r) = r

-- | What the frontend submits on each compile.
newtype CompileRequest = CompileRequest
  { "module" :: UserModule
  , cells :: Array Cell
  }

compileRequestCodec :: JsonCodec CompileRequest
compileRequestCodec = CA.prismaticCodec "CompileRequest" (Just <<< CompileRequest) un $
  CAR.object "CompileRequest"
    { "module": userModuleCodec
    , cells: CA.array cellCodec
    }
  where un (CompileRequest r) = r

-- | What the backend returns on each compile.
-- |
-- | For MVP: `js` present on success, `errors` present on failure. Types
-- | are present once the `purs ide` sidecar is wired up (M4).
newtype CompileResponse = CompileResponse
  { js :: Maybe String
  , warnings :: Array String
  , errors :: Array String
  , types :: Array CellType
  }

newtype CellType = CellType { id :: String, signature :: String }

cellTypeCodec :: JsonCodec CellType
cellTypeCodec = CA.prismaticCodec "CellType" (Just <<< CellType) un $
  CAR.object "CellType" { id: CA.string, signature: CA.string }
  where un (CellType r) = r

compileResponseCodec :: JsonCodec CompileResponse
compileResponseCodec = CA.prismaticCodec "CompileResponse" (Just <<< CompileResponse) un $
  CAR.object "CompileResponse"
    { js: nullableStringCodec
    , warnings: CA.array CA.string
    , errors: CA.array CA.string
    , types: CA.array cellTypeCodec
    }
  where un (CompileResponse r) = r

-- | `Maybe String` with a plain `null | string` wire representation,
-- | matching how our backend serialises the `js` field. The standard
-- | `Data.Codec.Argonaut.Common.maybe` uses a tagged-object form
-- | (`{"tag":"Just","value":…}`), which isn't what we want here.
nullableStringCodec :: JsonCodec (Maybe String)
nullableStringCodec = CA.codec' decode encode
  where
  decode json
    | AJ.isNull json = Right Nothing
    | otherwise = case AJ.toString json of
        Just s -> Right (Just s)
        Nothing -> Left (CA.TypeMismatch "string or null")
  encode = case _ of
    Nothing -> AJ.jsonNull
    Just s -> AJ.fromString s
