module Playground.Server.Main where

import Prelude

import Data.Argonaut.Core (Json, stringify, toObject)
import Data.Argonaut.Core as AJ
import Data.Argonaut.Parser (jsonParser)
import Data.Codec.Argonaut (JsonCodec)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR
import Data.Either (Either(..))
import Foreign.Object as Object
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import HTTPurple (Method(..), Request, ResponseM, ServerM, ok', serve, toString)
import HTTPurple.Headers (headers)
import Routing.Duplex (RouteDuplex', root, segment)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

import Data.Int as Int
import Playground.Server.Ide as Ide
import Playground.Server.Session (ModulePatch(..), SessionStore)
import Playground.Server.Session as Session
import Data.String as String
import Playground.Session
  ( CompileError(..)
  , CompileResponse(..)
  , IdeHit
  , IdeQuery(..)
  , IdeResponse(..)
  , UserModule(..)
  , compileRequestCodec
  , compileResponseCodec
  , ideQueryCodec
  , ideResponseCodec
  )

data Route
  = Health
  | SessionGet
  | SessionCompile
  | SessionModule
  | SessionCellAppend
  | SessionCellAt String
  | SessionRuntime
  | IdeType
  | IdeComplete
  | IdeSearch

derive instance Generic Route _

route :: RouteDuplex' Route
route = root $ sum
  { "Health": "health" / noArgs
  , "SessionGet": "session" / noArgs
  , "SessionCompile": "session" / "compile" / noArgs
  , "SessionModule": "session" / "module" / noArgs
  , "SessionCellAppend": "session" / "cells" / noArgs
  , "SessionCellAt": "session" / "cells" / segment
  , "SessionRuntime": "session" / "runtime" / noArgs
  , "IdeType": "ide" / "type" / noArgs
  , "IdeComplete": "ide" / "complete" / noArgs
  , "IdeSearch": "ide" / "search" / noArgs
  }

-- ============================================================
-- Body codecs (ad-hoc for each endpoint's expected shape)
-- ============================================================

moduleBodyCodec :: JsonCodec { source :: String }
moduleBodyCodec = CAR.object "ModuleBody" { source: CA.string }

cellAppendBodyCodec :: JsonCodec { source :: String, kind :: String }
cellAppendBodyCodec = CAR.object "CellAppendBody"
  { source: CA.string
  , kind: CA.string
  }

-- | PATCH-body decoder: fields are genuinely optional (missing key
-- | means "don't change"). We don't use a codec here because
-- | codec-argonaut's `maybe` combinator expects a tagged-object wire
-- | form for `Maybe`, not the missing-vs-present convention HTTP
-- | clients will naturally use.
parseCellPatch :: String -> Either String { source :: Maybe String, kind :: Maybe String }
parseCellPatch raw = case jsonParser raw of
  Left e -> Left ("bad JSON: " <> e)
  Right j -> case toObject j of
    Nothing -> Left "bad request: expected a JSON object"
    Just o -> do
      source <- pickStr "source" o
      kind <- pickStr "kind" o
      pure { source, kind }
  where
  pickStr key o = case Object.lookup key o of
    Nothing -> Right Nothing
    Just v -> case AJ.toString v of
      Just s -> Right (Just s)
      Nothing -> Left ("bad request: " <> key <> " must be a string")

runtimeBodyCodec :: JsonCodec { runtime :: String }
runtimeBodyCodec = CAR.object "RuntimeBody" { runtime: CA.string }

-- | PATCH /session/module body decoder. Body must be a JSON object
-- | containing exactly one of:
-- |   {"addImport": "Data.Array"}
-- |   {"appendBody": "...source..."}
-- |   {"replaceRange": {"startLine": N, "endLine": M, "text": "..."}}
parseModulePatch :: String -> Either String ModulePatch
parseModulePatch raw = case jsonParser raw of
  Left e -> Left ("bad JSON: " <> e)
  Right j -> case toObject j of
    Nothing -> Left "bad request: expected a JSON object"
    Just o ->
      case Object.lookup "addImport" o, Object.lookup "appendBody" o, Object.lookup "replaceRange" o of
        Just v, Nothing, Nothing -> case AJ.toString v of
          Just s -> Right (AddImport s)
          Nothing -> Left "addImport must be a string"
        Nothing, Just v, Nothing -> case AJ.toString v of
          Just s -> Right (AppendBody s)
          Nothing -> Left "appendBody must be a string"
        Nothing, Nothing, Just v -> parseReplaceRange v
        Nothing, Nothing, Nothing ->
          Left "expected one of: addImport, appendBody, replaceRange"
        _, _, _ ->
          Left "expected exactly one of: addImport, appendBody, replaceRange"
  where
  parseReplaceRange v = case toObject v of
    Nothing -> Left "replaceRange must be an object"
    Just o -> do
      sl <- pickInt "startLine" o
      el <- pickInt "endLine" o
      tx <- pickStr "text" o
      pure (ReplaceRange { startLine: sl, endLine: el, text: tx })
  pickInt key o = case Object.lookup key o of
    Nothing -> Left ("missing field: " <> key)
    Just v -> case AJ.toNumber v of
      Nothing -> Left (key <> " must be a number")
      Just n -> case Int.fromNumber n of
        Just i -> Right i
        Nothing -> Left (key <> " must be a non-fractional number")
  pickStr key o = case Object.lookup key o of
    Nothing -> Left ("missing field: " <> key)
    Just v -> case AJ.toString v of
      Just s -> Right s
      Nothing -> Left (key <> " must be a string")

-- ============================================================
-- Response assembly
-- ============================================================

snapshotJson :: CompileResponse -> String
snapshotJson = stringify <<< CA.encode compileResponseCodec

errorSnapshotJson :: String -> String -> String
errorSnapshotJson code msg =
  stringify $ CA.encode compileResponseCodec $
    CompileResponse
      { js: Nothing
      , warnings: []
      , errors:
          [ CompileError { code, filename: Nothing, position: Nothing, message: msg } ]
      , types: []
      , cellLines: []
      , emits: []
      , runtime: "browser"
      , "module": UserModule { source: "" }
      , cells: []
      }

ideResponseJson :: Array IdeHit -> String
ideResponseJson hits =
  stringify (CA.encode ideResponseCodec (IdeResponse { hits }))

parseBody
  :: forall a
   . JsonCodec a
  -> String
  -> Either String a
parseBody codec s = case jsonParser s of
  Left e -> Left ("bad JSON: " <> e)
  Right j -> case CA.decode codec j of
    Left e -> Left ("bad request: " <> CA.printJsonDecodeError e)
    Right a -> Right a

-- ============================================================
-- main
-- ============================================================

main :: ServerM
main = do
  store <- Session.newStore
  serve { port: 3050, hostname: "0.0.0.0" }
    { route
    , router: mkRouter store
    }

mkRouter
  :: SessionStore
  -> Request Route
  -> ResponseM
mkRouter store { route: r, method, body } =
  let plainCors = headers
        { "Access-Control-Allow-Origin": "*"
        , "Access-Control-Allow-Methods": "GET, POST, PATCH, DELETE, OPTIONS"
        , "Access-Control-Allow-Headers": "Content-Type"
        }
      jsonCors = headers
        { "Content-Type": "application/json"
        , "Access-Control-Allow-Origin": "*"
        , "Access-Control-Allow-Methods": "GET, POST, PATCH, DELETE, OPTIONS"
        , "Access-Control-Allow-Headers": "Content-Type"
        }
  in case method of
    Options -> ok' plainCors ""
    _ -> case r of
      Health -> ok' plainCors "ok"

      SessionGet -> do
        resp <- liftEffect (Session.get store)
        ok' jsonCors (snapshotJson resp)

      SessionCompile -> do
        -- With body: set state from the CompileRequest, then compile.
        -- This is the shape the frontend POSTs today.
        -- Without body (empty string): recompile current state.
        bodyStr <- toString body
        resp <- if String.null bodyStr || bodyStr == "{}"
          then liftAff (Session.compileAndStore store)
          else case parseBody compileRequestCodec bodyStr of
            Left _ -> liftAff (Session.compileAndStore store)
            Right req -> liftAff (Session.replaceAll store req)
        ok' jsonCors (snapshotJson resp)

      SessionModule -> case method of
        Post -> do
          bodyStr <- toString body
          case parseBody moduleBodyCodec bodyStr of
            Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
            Right { source } -> do
              resp <- liftAff (Session.updateModule store (UserModule { source }))
              ok' jsonCors (snapshotJson resp)
        Patch -> do
          bodyStr <- toString body
          case parseModulePatch bodyStr of
            Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
            Right patch -> do
              result <- liftAff (Session.patchModule store patch)
              case result of
                Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
                Right resp -> ok' jsonCors (snapshotJson resp)
        _ -> ok' jsonCors (errorSnapshotJson "MethodNotAllowed" "module endpoint accepts POST or PATCH")

      SessionCellAppend -> do
        bodyStr <- toString body
        case parseBody cellAppendBodyCodec bodyStr of
          Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
          Right req -> do
            resp <- liftAff (Session.appendCell store req)
            ok' jsonCors (snapshotJson resp)

      SessionCellAt cellId -> case method of
        Delete -> do
          resp <- liftAff (Session.removeCell store cellId)
          ok' jsonCors (snapshotJson resp)
        Patch -> do
          bodyStr <- toString body
          case parseCellPatch bodyStr of
            Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
            Right patch -> do
              resp <- liftAff (Session.updateCell store cellId patch)
              ok' jsonCors (snapshotJson resp)
        _ -> ok' jsonCors (errorSnapshotJson "MethodNotAllowed" "cell endpoint accepts PATCH or DELETE")

      SessionRuntime -> do
        bodyStr <- toString body
        case parseBody runtimeBodyCodec bodyStr of
          Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
          Right { runtime } -> do
            resp <- liftAff (Session.setRuntime store runtime)
            ok' jsonCors (snapshotJson resp)

      IdeType -> do
        bodyStr <- toString body
        case parseBody ideQueryCodec bodyStr of
          Left _ -> ok' jsonCors (ideResponseJson [])
          Right (IdeQuery { query }) -> do
            hits <- liftAff (Ide.queryType query)
            ok' jsonCors (ideResponseJson hits)

      IdeComplete -> do
        bodyStr <- toString body
        case parseBody ideQueryCodec bodyStr of
          Left _ -> ok' jsonCors (ideResponseJson [])
          Right (IdeQuery { query }) -> do
            hits <- liftAff (Ide.queryComplete query)
            ok' jsonCors (ideResponseJson hits)

      IdeSearch -> do
        bodyStr <- toString body
        case parseBody ideQueryCodec bodyStr of
          Left _ -> ok' jsonCors (ideResponseJson [])
          Right (IdeQuery { query }) -> do
            hits <- liftAff (Ide.querySearch query)
            ok' jsonCors (ideResponseJson hits)
