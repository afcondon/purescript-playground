module Playground.Server.Main where

import Prelude

import Data.Argonaut.Core (stringify, toObject)
import Data.Argonaut.Core as AJ
import Data.Argonaut.Parser (jsonParser)
import Data.Codec.Argonaut (JsonCodec)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR
import Data.Either (Either(..))
import Foreign.Object as Object
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Effect.Aff (Aff)
import Effect.Aff.Class (liftAff)
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import HTTPurple
  ( Method(..)
  , Request
  , ResponseM
  , ResponseOrUpgrade(..)
  , ServerM
  , conflict'
  , ok'
  , serveWithHandle
  , toString
  )
import HTTPurple.Headers (ResponseHeaders, headers)
import HTTPurple.Lookup ((!!))
import HTTPurple.WebSocket
  ( Message(..)
  , ServerSocket
  , sendText
  , wsHandler
  )
import HTTPurple.WebSocket.Types (WsHandler)
import Routing.Duplex (RouteDuplex', flag, root, segment)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/), (?))

import Data.Int as Int
import Playground.Server.Conch (ConchStore, RequestResult(..))
import Playground.Server.Conch as Conch
import Playground.Server.Ide as Ide
import Playground.Server.Session (ModulePatch(..), SessionStore)
import Playground.Server.Session as Session
import Playground.Server.Subscribers (Subscribers)
import Playground.Server.Subscribers as Subscribers
import Data.String as String
import Playground.Conch
  ( Broadcast(..)
  , SubscriberId(..)
  , broadcastCodec
  , clientMsgCodec
  , conchHeldBodyCodec
  )
import Playground.Conch as PConch
import Playground.Session
  ( Cell
  , CellType
  , CompileError(..)
  , CompileRequest(..)
  , CompileResponse(..)
  , IdeHit
  , IdeQuery(..)
  , IdeResponse(..)
  , UserModule(..)
  , cellTypeCodec
  , compileRequestCodec
  , compileResponseCodec
  , ideQueryCodec
  , ideResponseCodec
  )

data Route
  = Health
  | SessionGet
  | SessionWs
  | SessionCompile
  | SessionModule { preview :: Boolean }
  | SessionCellAppend { preview :: Boolean }
  | SessionCellAt String { preview :: Boolean }
  | SessionRuntime
  | SessionTypes
  | SessionExport
  | SessionImport
  | IdeType
  | IdeComplete
  | IdeSearch

derive instance Generic Route _

route :: RouteDuplex' Route
route = root $ sum
  { "Health": "health" / noArgs
  , "SessionGet": "session" / noArgs
  , "SessionWs": "session" / "ws" / noArgs
  , "SessionCompile": "session" / "compile" / noArgs
  , "SessionModule": "session" / "module" ? { preview: flag }
  , "SessionCellAppend": "session" / "cells" ? { preview: flag }
  , "SessionCellAt": "session" / "cells" / segment ? { preview: flag }
  , "SessionRuntime": "session" / "runtime" / noArgs
  , "SessionTypes": "session" / "types" / noArgs
  , "SessionExport": "session" / "export" / noArgs
  , "SessionImport": "session" / "import" / noArgs
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
parseCellPatch :: String -> Either String { source :: Maybe String, kind :: Maybe String, form :: Maybe Boolean }
parseCellPatch raw = case jsonParser raw of
  Left e -> Left ("bad JSON: " <> e)
  Right j -> case toObject j of
    Nothing -> Left "bad request: expected a JSON object"
    Just o -> do
      source <- pickStr "source" o
      kind <- pickStr "kind" o
      form <- pickBool "form" o
      pure { source, kind, form }
  where
  pickStr key o = case Object.lookup key o of
    Nothing -> Right Nothing
    Just v -> case AJ.toString v of
      Just s -> Right (Just s)
      Nothing -> Left ("bad request: " <> key <> " must be a string")
  pickBool key o = case Object.lookup key o of
    Nothing -> Right Nothing
    Just v -> case AJ.toBoolean v of
      Just b -> Right (Just b)
      Nothing -> Left ("bad request: " <> key <> " must be a boolean")

runtimeBodyCodec :: JsonCodec { runtime :: String }
runtimeBodyCodec = CAR.object "RuntimeBody" { runtime: CA.string }

-- | PATCH /session/module body decoder. Body must be a JSON object
-- | containing exactly one of:
-- |   {"addImport": "Data.Array"}
-- |   {"addImport": {"module": "Data.Array", "alias": "Array",
-- |                  "names": ["length", "take"]}} (alias + names optional)
-- |   {"appendBody": "...source..."}
-- |   {"replaceRange": {"startLine": N, "endLine": M, "text": "..."}}
parseModulePatch :: String -> Either String ModulePatch
parseModulePatch raw = case jsonParser raw of
  Left e -> Left ("bad JSON: " <> e)
  Right j -> case toObject j of
    Nothing -> Left "bad request: expected a JSON object"
    Just o ->
      case Object.lookup "addImport" o, Object.lookup "appendBody" o, Object.lookup "replaceRange" o of
        Just v, Nothing, Nothing -> AddImport <$> parseImportSpec v
        Nothing, Just v, Nothing -> case AJ.toString v of
          Just s -> Right (AppendBody s)
          Nothing -> Left "appendBody must be a string"
        Nothing, Nothing, Just v -> parseReplaceRange v
        Nothing, Nothing, Nothing ->
          Left "expected one of: addImport, appendBody, replaceRange"
        _, _, _ ->
          Left "expected exactly one of: addImport, appendBody, replaceRange"
  where
  parseImportSpec v = case AJ.toString v of
    Just s -> Right { "module": s, alias: Nothing, names: Nothing }
    Nothing -> case toObject v of
      Nothing -> Left "addImport must be a string or {module, alias?, names?} object"
      Just o -> do
        m <- pickStr "module" o
        a <- pickOptStr "alias" o
        ns <- pickOptStrArray "names" o
        pure { "module": m, alias: a, names: ns }
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
  pickOptStr key o = case Object.lookup key o of
    Nothing -> Right Nothing
    Just v -> case AJ.toString v of
      Just s -> Right (Just s)
      Nothing -> Left (key <> " must be a string when present")
  pickOptStrArray key o = case Object.lookup key o of
    Nothing -> Right Nothing
    Just v -> case AJ.toArray v of
      Nothing -> Left (key <> " must be an array when present")
      Just arr -> do
        strs <- traverse (asString key) arr
        pure (Just strs)
  asString key v = case AJ.toString v of
    Just s -> Right s
    Nothing -> Left (key <> " entries must be strings")

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

-- | Narrow "types only" response for `GET /session/types`. Wraps
-- | the existing `cellTypeCodec` array in an object so the shape is
-- | stable regardless of whether we later need to add sibling
-- | fields (e.g. module-level declarations).
typesResponseJson :: Array CellType -> String
typesResponseJson types =
  stringify (CA.encode (CAR.object "TypesResponse" { types: CA.array cellTypeCodec }) { types })

-- | Serialise just the *input* slice of the session state as a
-- | CompileRequest — the portable shape that `POST /session/import`
-- | accepts. Derived fields (errors, warnings, js, emits) are
-- | recomputable and intentionally absent from the exported shape.
compileRequestJson :: UserModule -> Array Cell -> String -> String
compileRequestJson m cs r =
  stringify (CA.encode compileRequestCodec
    (CompileRequest { "module": m, cells: cs, runtime: r }))

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
-- App context + authorisation
-- ============================================================

type AppCtx =
  { store :: SessionStore
  , subs :: Subscribers
  , conchStore :: ConchStore
  }

-- | Before any mutating HTTP endpoint runs its work, the caller must
-- | prove they hold the conch via the `X-Atelier-Subscriber-Id`
-- | header. Missing header / mismatched id / nobody-holds-it all yield
-- | a 409 with the current conch state in the body so the client can
-- | decide whether to `RequestConch` or `ForceConch`.
-- |
-- | Returns the caller's `SubscriberId` on success so the writer can
-- | heartbeat the conch after the write lands.
requireConch
  :: AppCtx
  -> Request Route
  -> Aff (Either ResponseOrUpgrade SubscriberId)
requireConch ctx req = do
  conch <- liftEffect $ Conch.getState ctx.conchStore
  let deny = do
        let body =
              { error: "conch-held"
              , holder: conch.holder
              , lastActivityAt: conch.lastActivityAt
              }
            json = stringify (CA.encode conchHeldBodyCodec body)
        r <- conflict' jsonCors json
        pure (Left r)
  case req.headers !! "X-Atelier-Subscriber-Id" of
    Nothing -> deny
    Just raw ->
      let sid = SubscriberId raw
      in case conch.holder of
          Just h | h == sid -> pure (Right sid)
          _ -> deny

-- | Per-response header profiles pulled up to the module level so the
-- | auth helper + mkRouter share them.
plainCors :: ResponseHeaders
plainCors = headers
  { "Access-Control-Allow-Origin": "*"
  , "Access-Control-Allow-Methods": "GET, POST, PATCH, DELETE, OPTIONS"
  , "Access-Control-Allow-Headers": "Content-Type, X-Atelier-Subscriber-Id"
  }

jsonCors :: ResponseHeaders
jsonCors = headers
  { "Content-Type": "application/json"
  , "Access-Control-Allow-Origin": "*"
  , "Access-Control-Allow-Methods": "GET, POST, PATCH, DELETE, OPTIONS"
  , "Access-Control-Allow-Headers": "Content-Type, X-Atelier-Subscriber-Id"
  }

-- ============================================================
-- WebSocket dispatch
-- ============================================================

-- | WS handler wired up inside `serveWithHandle`. Every connected
-- | subscriber flows through this one set of callbacks; identity is
-- | looked up via `Subscribers.idFor sock` on each message.
makeWsHandler :: AppCtx -> WsHandler
makeWsHandler ctx = wsHandler
  { onOpen: \sock -> do
      sid <- liftEffect $ Subscribers.register ctx.subs sock
      conch <- liftEffect $ Conch.getState ctx.conchStore
      snap <- liftEffect $ Session.get ctx.store
      let welcome = Welcome { yourId: sid, conch, snapshot: snap }
      sendText sock (stringify (CA.encode broadcastCodec welcome))
  , onMessage: \sock msg -> case msg of
      TextMessage raw -> handleClientMsg ctx sock raw
      _ -> pure unit
  , onClose: \sock _ -> do
      maybeSid <- liftEffect $ Subscribers.idFor ctx.subs sock
      liftEffect $ Subscribers.unregister ctx.subs sock
      case maybeSid of
        Nothing -> pure unit
        Just sid -> do
          r <- liftEffect $ Conch.onDisconnect ctx.conchStore sid
          handleConchResult ctx r
  , onError: \_ _ -> pure unit
  }

handleClientMsg :: AppCtx -> ServerSocket -> String -> Aff Unit
handleClientMsg ctx sock raw = case jsonParser raw of
  Left e -> liftEffect $ Console.error ("WS client msg JSON parse: " <> e)
  Right j -> case CA.decode clientMsgCodec j of
    Left e -> liftEffect $ Console.error ("WS client msg decode: " <> CA.printJsonDecodeError e)
    Right cm -> do
      maybeSid <- liftEffect $ Subscribers.idFor ctx.subs sock
      case maybeSid of
        Nothing -> pure unit
        Just sid -> dispatchClientMsg ctx sid cm

dispatchClientMsg :: AppCtx -> SubscriberId -> PConch.ClientMsg -> Aff Unit
dispatchClientMsg ctx sid = case _ of
  PConch.RequestConch -> do
    r <- liftEffect $ Conch.request ctx.conchStore sid
    handleConchResult ctx r
  PConch.YieldConch -> do
    r <- liftEffect $ Conch.yield ctx.conchStore sid
    handleConchResult ctx r
  PConch.ForceConch -> do
    r <- liftEffect $ Conch.force ctx.conchStore sid
    handleConchResult ctx r
  PConch.Heartbeat -> liftEffect $ Conch.heartbeat ctx.conchStore sid

handleConchResult :: AppCtx -> RequestResult -> Aff Unit
handleConchResult ctx = case _ of
  Granted cs -> do
    let msg = ConchUpdate { conch: cs }
        encoded = stringify (CA.encode broadcastCodec msg)
    Subscribers.broadcast ctx.subs Nothing (TextMessage encoded)
  Unchanged -> pure unit

-- ============================================================
-- main
-- ============================================================

main :: ServerM
main = serveWithHandle { port: 3050, hostname: "0.0.0.0" } \handle -> do
  subs <- Subscribers.newSubscribers
  conchStore <- Conch.newStore
  handle.registerChannel (Subscribers.closeAll subs)
  let broadcastSnapshot resp = do
        conch <- liftEffect $ Conch.getState conchStore
        let msg = Snapshot { conch, snapshot: resp }
            encoded = stringify (CA.encode broadcastCodec msg)
        Subscribers.broadcast subs conch.holder (TextMessage encoded)
  -- Default "main" workspace. Lives at <repo>/runtime-workspace/workspaces/main.
  -- `server/run.js` is launched from the repo root, so a cwd-relative path
  -- resolves correctly without needing to know this module's location.
  store <- Session.newStore "runtime-workspace/workspaces/main" broadcastSnapshot
  let ctx = { store, subs, conchStore }
  pure
    { route
    , router: mkRouter ctx
    }

mkRouter
  :: AppCtx
  -> Request Route
  -> ResponseM
mkRouter ctx req@{ route: r, method, body } =
  case method of
    Options -> ok' plainCors ""
    _ -> case r of
      Health -> ok' plainCors "ok"

      SessionGet -> do
        resp <- liftEffect (Session.get ctx.store)
        ok' jsonCors (snapshotJson resp)

      SessionWs -> pure (WsUpgrade (makeWsHandler ctx))

      SessionCompile -> do
        -- With body: set state from the CompileRequest, then compile.
        -- This is the shape the frontend POSTs today.
        -- Without body (empty string): recompile current state.
        -- Either way, mutates — requires the conch.
        authResult <- requireConch ctx req
        case authResult of
          Left r' -> pure r'
          Right sid -> do
            bodyStr <- toString body
            resp <- if String.null bodyStr || bodyStr == "{}"
              then liftAff (Session.compileAndStore ctx.store)
              else case parseBody compileRequestCodec bodyStr of
                Left _ -> liftAff (Session.compileAndStore ctx.store)
                Right rq -> liftAff (Session.replaceAll ctx.store rq)
            liftEffect $ Conch.heartbeat ctx.conchStore sid
            ok' jsonCors (snapshotJson resp)

      SessionModule { preview } -> case method of
        Post -> do
          bodyStr <- toString body
          case parseBody moduleBodyCodec bodyStr of
            Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
            Right { source } ->
              if preview
                then do
                  resp <- liftAff (Session.previewUpdateModule ctx.store (UserModule { source }))
                  ok' jsonCors (snapshotJson resp)
                else do
                  authResult <- requireConch ctx req
                  case authResult of
                    Left r' -> pure r'
                    Right sid -> do
                      resp <- liftAff (Session.updateModule ctx.store (UserModule { source }))
                      liftEffect $ Conch.heartbeat ctx.conchStore sid
                      ok' jsonCors (snapshotJson resp)
        Patch -> do
          bodyStr <- toString body
          case parseModulePatch bodyStr of
            Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
            Right patch ->
              if preview
                then do
                  result <- liftAff (Session.previewModulePatch ctx.store patch)
                  case result of
                    Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
                    Right resp -> ok' jsonCors (snapshotJson resp)
                else do
                  authResult <- requireConch ctx req
                  case authResult of
                    Left r' -> pure r'
                    Right sid -> do
                      result <- liftAff (Session.patchModule ctx.store patch)
                      case result of
                        Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
                        Right resp -> do
                          liftEffect $ Conch.heartbeat ctx.conchStore sid
                          ok' jsonCors (snapshotJson resp)
        _ -> ok' jsonCors (errorSnapshotJson "MethodNotAllowed" "module endpoint accepts POST or PATCH")

      SessionCellAppend { preview } -> do
        bodyStr <- toString body
        case parseBody cellAppendBodyCodec bodyStr of
          Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
          Right rq ->
            if preview
              then do
                resp <- liftAff (Session.previewAppendCell ctx.store rq)
                ok' jsonCors (snapshotJson resp)
              else do
                authResult <- requireConch ctx req
                case authResult of
                  Left r' -> pure r'
                  Right sid -> do
                    resp <- liftAff (Session.appendCell ctx.store rq)
                    liftEffect $ Conch.heartbeat ctx.conchStore sid
                    ok' jsonCors (snapshotJson resp)

      SessionCellAt cellId { preview } -> case method of
        Delete ->
          if preview
            then do
              resp <- liftAff (Session.previewRemoveCell ctx.store cellId)
              ok' jsonCors (snapshotJson resp)
            else do
              authResult <- requireConch ctx req
              case authResult of
                Left r' -> pure r'
                Right sid -> do
                  resp <- liftAff (Session.removeCell ctx.store cellId)
                  liftEffect $ Conch.heartbeat ctx.conchStore sid
                  ok' jsonCors (snapshotJson resp)
        Patch -> do
          bodyStr <- toString body
          case parseCellPatch bodyStr of
            Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
            Right patch ->
              if preview
                then do
                  resp <- liftAff (Session.previewUpdateCell ctx.store cellId patch)
                  ok' jsonCors (snapshotJson resp)
                else do
                  authResult <- requireConch ctx req
                  case authResult of
                    Left r' -> pure r'
                    Right sid -> do
                      resp <- liftAff (Session.updateCell ctx.store cellId patch)
                      liftEffect $ Conch.heartbeat ctx.conchStore sid
                      ok' jsonCors (snapshotJson resp)
        _ -> ok' jsonCors (errorSnapshotJson "MethodNotAllowed" "cell endpoint accepts PATCH or DELETE")

      SessionRuntime -> do
        authResult <- requireConch ctx req
        case authResult of
          Left r' -> pure r'
          Right sid -> do
            bodyStr <- toString body
            case parseBody runtimeBodyCodec bodyStr of
              Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
              Right { runtime } -> do
                resp <- liftAff (Session.setRuntime ctx.store runtime)
                liftEffect $ Conch.heartbeat ctx.conchStore sid
                ok' jsonCors (snapshotJson resp)

      SessionTypes -> do
        CompileResponse rr <- liftEffect (Session.get ctx.store)
        ok' jsonCors (typesResponseJson rr.types)

      SessionExport -> do
        CompileResponse rr <- liftEffect (Session.get ctx.store)
        ok' jsonCors (compileRequestJson rr."module" rr.cells rr.runtime)

      SessionImport -> do
        authResult <- requireConch ctx req
        case authResult of
          Left r' -> pure r'
          Right sid -> do
            bodyStr <- toString body
            case parseBody compileRequestCodec bodyStr of
              Left msg -> ok' jsonCors (errorSnapshotJson "BadRequest" msg)
              Right rq -> do
                resp <- liftAff (Session.replaceAll ctx.store rq)
                liftEffect $ Conch.heartbeat ctx.conchStore sid
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
