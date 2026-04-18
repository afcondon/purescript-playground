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
-- | `js` present on success, absent on failure. `errors` carries
-- | structured compiler errors (via `purs --json-errors`), including a
-- | position where available, so the frontend can attribute each error
-- | back to the originating cell via `cellLines`.
newtype CompileResponse = CompileResponse
  { js :: Maybe String
  , warnings :: Array CompileError
  , errors :: Array CompileError
  , types :: Array CellType
  , cellLines :: Array CellRange
  }

-- | A single compiler error or warning. `filename` and `position` are
-- | optional because backend-internal errors (e.g. a file-write failure)
-- | don't have a compiler position.
newtype CompileError = CompileError
  { code :: String          -- e.g. "UnknownName", or "Transport" / "ParseRequest" for our own
  , filename :: Maybe String
  , position :: Maybe Position
  , message :: String
  }

newtype Position = Position
  { startLine :: Int
  , startColumn :: Int
  , endLine :: Int
  , endColumn :: Int
  }

positionCodec :: JsonCodec Position
positionCodec = CA.prismaticCodec "Position" (Just <<< Position) un $
  CAR.object "Position"
    { startLine: CA.int
    , startColumn: CA.int
    , endLine: CA.int
    , endColumn: CA.int
    }
  where un (Position r) = r

compileErrorCodec :: JsonCodec CompileError
compileErrorCodec = CA.prismaticCodec "CompileError" (Just <<< CompileError) un $
  CAR.object "CompileError"
    { code: CA.string
    , filename: nullableStringCodec
    , position: nullablePositionCodec
    , message: CA.string
    }
  where
  un (CompileError r) = r
  nullablePositionCodec :: JsonCodec (Maybe Position)
  nullablePositionCodec = CA.codec' decode encode
    where
    decode json
      | AJ.isNull json = Right Nothing
      | otherwise = Just <$> CA.decode positionCodec json
    encode = case _ of
      Nothing -> AJ.jsonNull
      Just p -> CA.encode positionCodec p

newtype CellType = CellType { id :: String, signature :: String }

cellTypeCodec :: JsonCodec CellType
cellTypeCodec = CA.prismaticCodec "CellType" (Just <<< CellType) un $
  CAR.object "CellType" { id: CA.string, signature: CA.string }
  where un (CellType r) = r

newtype CellRange = CellRange
  { id :: String
  , startLine :: Int
  , endLine :: Int
  }

cellRangeCodec :: JsonCodec CellRange
cellRangeCodec = CA.prismaticCodec "CellRange" (Just <<< CellRange) un $
  CAR.object "CellRange"
    { id: CA.string
    , startLine: CA.int
    , endLine: CA.int
    }
  where un (CellRange r) = r

compileResponseCodec :: JsonCodec CompileResponse
compileResponseCodec = CA.prismaticCodec "CompileResponse" (Just <<< CompileResponse) un $
  CAR.object "CompileResponse"
    { js: nullableStringCodec
    , warnings: CA.array compileErrorCodec
    , errors: CA.array compileErrorCodec
    , types: CA.array cellTypeCodec
    , cellLines: CA.array cellRangeCodec
    }
  where un (CompileResponse r) = r

-- ============================================================
-- /ide/* — hover types, completion, type-directed search
-- ============================================================

-- | A request body for /ide/type and /ide/complete.
newtype IdeQuery = IdeQuery { query :: String }

ideQueryCodec :: JsonCodec IdeQuery
ideQueryCodec = CA.prismaticCodec "IdeQuery" (Just <<< IdeQuery) un $
  CAR.object "IdeQuery" { query: CA.string }
  where un (IdeQuery r) = r

-- | A single match returned by `purs ide`. `typeSignature` is the
-- | inferred type (`type` is a PS keyword, so we rename it on the wire).
newtype IdeHit = IdeHit
  { identifier :: String
  , moduleName :: String
  , typeSignature :: String
  }

ideHitCodec :: JsonCodec IdeHit
ideHitCodec = CA.prismaticCodec "IdeHit" (Just <<< IdeHit) un $
  CAR.object "IdeHit"
    { identifier: CA.string
    , moduleName: CA.string
    , typeSignature: CA.string
    }
  where un (IdeHit r) = r

newtype IdeResponse = IdeResponse { hits :: Array IdeHit }

ideResponseCodec :: JsonCodec IdeResponse
ideResponseCodec = CA.prismaticCodec "IdeResponse" (Just <<< IdeResponse) un $
  CAR.object "IdeResponse" { hits: CA.array ideHitCodec }
  where un (IdeResponse r) = r

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
