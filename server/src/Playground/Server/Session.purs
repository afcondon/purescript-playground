module Playground.Server.Session
  ( SessionStore
  , newStore
  , get
  , compileAndStore
  , replaceAll
  , updateModule
  , appendCell
  , updateCell
  , removeCell
  , setRuntime
  ) where

import Prelude

import Data.Array (filter, findIndex, modifyAt, snoc)
import Data.Array as Array
import Data.Int (fromString) as Int
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as Str
import Data.String.Pattern (Pattern(..))
import Effect (Effect)
import Effect.AVar (AVar)
import Effect.AVar as EffAVar
import Effect.Aff (Aff)
import Effect.Aff.AVar as AVar
import Effect.Class (liftEffect)
import Effect.Ref (Ref)
import Effect.Ref as Ref

import Playground.Server.Adapter.BrowserWorker (browserWorker)
import Playground.Server.Adapter.NodeProcess (nodeProcess)
import Playground.Server.Adapter.PurerlBEAM (purerlBEAM)
import Playground.Server.Compile as Compile
import Playground.Server.Synthesize (synthesize)
import Playground.Session
  ( Cell(..)
  , CompileRequest(..)
  , CompileResponse(..)
  , UserModule(..)
  )

-- | Live session state: the human's (or Claude's) last-submitted
-- | inputs plus the most recent compile's derived outputs. A single
-- | AVar serialises writes — any update goes take → apply → recompile
-- | → put.
newtype SessionStore = SessionStore
  { lock :: AVar Unit
  , state :: Ref SessionState
  }

type SessionState =
  { runtime :: String
  , "module" :: UserModule
  , cells :: Array Cell
  , nextCellId :: Int
  , lastResponse :: Maybe CompileResponse
  }

initialState :: SessionState
initialState =
  { runtime: "browser"
  , "module": UserModule { source: "module Scratch where\n\nimport Prelude\n" }
  , cells: []
  , nextCellId: 1
  , lastResponse: Nothing
  }

newStore :: Effect SessionStore
newStore = do
  ref <- Ref.new initialState
  -- AVar used as a mutex: initially "full" (contains unit); take
  -- claims the lock, put releases it.
  lock <- EffAVar.new unit
  pure (SessionStore { lock, state: ref })

-- | Read the current session snapshot as a CompileResponse (for
-- | `GET /session`). Falls back to an empty-ish response when no
-- | compile has happened yet — callers just get back the input state
-- | alongside empty derived fields.
get :: SessionStore -> Effect CompileResponse
get (SessionStore { state }) = do
  s <- Ref.read state
  pure $ case s.lastResponse of
    Just (CompileResponse r) -> CompileResponse r
      { runtime = s.runtime
      , "module" = s."module"
      , cells = s.cells
      }
    Nothing -> emptyResponse s

emptyResponse :: SessionState -> CompileResponse
emptyResponse s = CompileResponse
  { js: Nothing
  , warnings: []
  , errors: []
  , types: []
  , cellLines: []
  , emits: []
  , runtime: s.runtime
  , "module": s."module"
  , cells: s.cells
  }

pickAdapter :: String -> _
pickAdapter = case _ of
  "node" -> nodeProcess
  "purerl" -> purerlBEAM
  _ -> browserWorker

-- | Apply a state update under the lock, then recompile against the
-- | new state, cache + return the snapshot.
withUpdate
  :: SessionStore
  -> (SessionState -> SessionState)
  -> Aff CompileResponse
withUpdate (SessionStore { lock, state }) f = do
  _ <- AVar.take lock
  s0 <- liftEffect (Ref.read state)
  let s1 = f s0
  liftEffect (Ref.write s1 state)
  resp <- compileNow s1
  liftEffect $ Ref.modify_ (_ { lastResponse = Just resp }) state
  AVar.put unit lock
  pure resp

compileNow :: SessionState -> Aff CompileResponse
compileNow s =
  let
    req = CompileRequest
      { "module": s."module"
      , cells: s.cells
      , runtime: s.runtime
      }
    synth = synthesize { purerl: s.runtime == "purerl" } req
    adapter = pickAdapter s.runtime
  in
    Compile.compile adapter
      { userSource: synth.userSource
      , mainSource: synth.mainSource
      , cellLines: synth.cellLines
      , "module": s."module"
      , cells: s.cells
      }

-- | Public: force a recompile with the current state.
compileAndStore :: SessionStore -> Aff CompileResponse
compileAndStore store = withUpdate store identity

-- | Replace the full input state (module + cells + runtime) from a
-- | CompileRequest and compile. Used by POST /session/compile when
-- | the client supplies a body (matches the pre-session-store
-- | behaviour the frontend still relies on). nextCellId is bumped
-- | past the incoming ids so later server-side appends don't collide.
replaceAll :: SessionStore -> CompileRequest -> Aff CompileResponse
replaceAll store (CompileRequest r) = withUpdate store \s -> s
  { runtime = r.runtime
  , "module" = r."module"
  , cells = r.cells
  , nextCellId = nextIdAfter r.cells
  }
  where
  nextIdAfter cs =
    let maxId = Array.foldl
                  (\acc (Cell c) -> max acc (parseCellNumber c.id))
                  0 cs
    in maxId + 1
  parseCellNumber s = case Str.stripPrefix (Pattern "c") s of
    Just rest -> case Int.fromString rest of
      Just n -> n
      Nothing -> 0
    Nothing -> 0

updateModule :: SessionStore -> UserModule -> Aff CompileResponse
updateModule store m = withUpdate store _ { "module" = m }

appendCell :: SessionStore -> { source :: String, kind :: String } -> Aff CompileResponse
appendCell store { source, kind } = withUpdate store \s ->
  let newId = "c" <> show s.nextCellId
      newCell = Cell { id: newId, kind, source }
  in s { cells = snoc s.cells newCell, nextCellId = s.nextCellId + 1 }

updateCell
  :: SessionStore
  -> String
  -> { source :: Maybe String, kind :: Maybe String }
  -> Aff CompileResponse
updateCell store cellId patch = withUpdate store \s ->
  s { cells = applyPatch s.cells }
  where
  applyPatch cells = fromMaybe cells do
    idx <- findIndex (\(Cell c) -> c.id == cellId) cells
    modifyAt idx (patchCell patch) cells
  patchCell p (Cell c) = Cell
    { id: c.id
    , source: fromMaybe c.source p.source
    , kind: fromMaybe c.kind p.kind
    }

removeCell :: SessionStore -> String -> Aff CompileResponse
removeCell store cellId = withUpdate store \s ->
  s { cells = filter (\(Cell c) -> c.id /= cellId) s.cells }

setRuntime :: SessionStore -> String -> Aff CompileResponse
setRuntime store runtime = withUpdate store _ { runtime = runtime }
