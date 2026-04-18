module Playground.Frontend.Shell where

import Prelude

import Affjax.RequestBody as RB
import Affjax.ResponseFormat as RF
import Affjax.Web as AX
import Data.Argonaut.Core (stringify)
import Data.Array (filter, findIndex, mapWithIndex, modifyAt, snoc)
import Data.Array as Array
import Data.String as Str
import Data.Codec.Argonaut as CA
import Data.Either (Either(..))
import Data.HTTP.Method (Method(..))
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(..))
import Data.Time.Duration (Milliseconds(..))
import Effect.Aff (delay)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Subscription as HS
import Type.Proxy (Proxy(..))

import Data.Foldable (for_)

import Playground.Frontend.CodeMirror (ErrorSpan)
import Playground.Frontend.Config (backendUrl, nowMs)
import Playground.Frontend.Editor as Editor
import Playground.Frontend.InScope as InScope
import Playground.Frontend.SigilView as SigilView
import Playground.Frontend.Starter (Starter, compatFor, starters)
import Playground.Frontend.Starter as Starter
import Playground.Frontend.Value (PlaygroundValue)
import Playground.Frontend.Value as Value
import Playground.Frontend.ValueView as ValueView
import Playground.Frontend.Worker (Worker, WorkerMessage(..))
import Playground.Frontend.Worker as Worker
import Playground.Session
  ( Cell(..)
  , CellEmit(..)
  , CellRange(..)
  , CellType(..)
  , CompileError(..)
  , CompileRequest(..)
  , CompileResponse(..)
  , Position(..)
  , UserModule(..)
  , compileRequestCodec
  , compileResponseCodec
  )

type CellRec = { id :: String, kind :: String, source :: String }

type State =
  { moduleSource :: String
  , cells :: Array CellRec
  , nextCellId :: Int
  , runtime :: String             -- "browser" | "node" | "purerl"
  , starterKey :: String          -- key of the currently-loaded starter
  , starterMenuOpen :: Boolean
  , inScopeOpen :: Boolean
  , lastUserEditAt :: Number      -- ms since epoch; used to guard the
                                   -- server-pull poll against clobbering
                                   -- live typing.
  , compiling :: Boolean
  , errors :: Array CompileError
  , warnings :: Array CompileError
  , cellRanges :: Array CellRange
  , transportError :: Maybe String
  , runtimeError :: Maybe String
  , cellResults :: Map String PlaygroundValue
  , cellTypes :: Map String String
  , pendingCompile :: Maybe H.ForkId
  , worker :: Maybe Worker
  , workerSub :: Maybe H.SubscriptionId
  , workerTimeout :: Maybe H.ForkId
  }

type Slots =
  ( moduleEditor :: H.Slot Editor.Query Editor.Output Unit
  , cellEditor :: H.Slot Editor.Query Editor.Output String
  , sigil :: forall q. H.Slot q Void String
  )

_moduleEditor :: Proxy "moduleEditor"
_moduleEditor = Proxy

_cellEditor :: Proxy "cellEditor"
_cellEditor = Proxy

_sigil :: Proxy "sigil"
_sigil = Proxy

data Action
  = Compile
  | ScheduleCompile
  | ModuleChanged String
  | CellChanged String String
  | AddCell
  | RemoveCell String
  | ToggleCellKind String
  | SetRuntime String
  | ToggleStarterMenu
  | LoadStarter String
  | ToggleInScope
  | HandleWorkerMessage WorkerMessage
  | WorkerTimeout
  | PollServer              -- 2s tick — pull remote snapshot, apply
                            -- if the user isn't actively typing
  | Startup                 -- runs once on init: compile + start poll loop

initialState :: forall i. i -> State
initialState _ =
  let s = Starter.defaultStarter
  in { moduleSource: s.moduleSource
     , cells: s.cells
     , nextCellId: nextIdAfter s.cells
     , runtime: "browser"
     , starterKey: s.key
     , starterMenuOpen: false
     , inScopeOpen: false
     , lastUserEditAt: 0.0
     , compiling: false
     , errors: []
     , warnings: []
     , cellRanges: []
     , transportError: Nothing
     , runtimeError: Nothing
     , cellResults: Map.empty
     , cellTypes: Map.empty
     , pendingCompile: Nothing
     , worker: Nothing
     , workerSub: Nothing
     , workerTimeout: Nothing
     }
  where
  -- Cell ids are "c1", "c2", …; pick an int strictly above the
  -- highest used so new cells don't collide.
  nextIdAfter cs = Array.length cs + 1

debounceMs :: Milliseconds
debounceMs = Milliseconds 400.0

workerTimeoutMs :: Milliseconds
workerTimeoutMs = Milliseconds 3000.0

component :: forall q i o m. MonadAff m => H.Component q i o m
component = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , initialize = Just Startup
      }
  }

handleAction
  :: forall o m
   . MonadAff m
  => Action
  -> H.HalogenM State Action Slots o m Unit
handleAction = case _ of
  Startup -> do
    handleAction Compile
    schedulePoll
  ModuleChanged src -> do
    stampEdit
    H.modify_ _ { moduleSource = src }
    handleAction ScheduleCompile
  CellChanged id src -> do
    stampEdit
    H.modify_ \s -> s { cells = updateCell id src s.cells }
    handleAction ScheduleCompile
  AddCell -> do
    H.modify_ \s ->
      let newId = "c" <> show s.nextCellId
          newCell = { id: newId, kind: "expr", source: "" }
      in s { cells = snoc s.cells newCell, nextCellId = s.nextCellId + 1 }
    handleAction ScheduleCompile
  RemoveCell id -> do
    H.modify_ \s -> s
      { cells = filter (_.id >>> (_ /= id)) s.cells
      , cellResults = Map.delete id s.cellResults
      }
    handleAction ScheduleCompile
  ToggleCellKind id -> do
    H.modify_ \s -> s
      { cells = map (\c -> if c.id == id then c { kind = flipKind c.kind } else c) s.cells
      -- Let-cells never emit; drop any stale result so the gutter
      -- doesn't render against the wrong kind.
      , cellResults = Map.delete id s.cellResults
      , cellTypes = Map.delete id s.cellTypes
      }
    handleAction ScheduleCompile
  SetRuntime r -> do
    s0 <- H.get
    when (s0.runtime /= r) do
      H.modify_ _ { runtime = r, cellResults = Map.empty }
      handleAction ScheduleCompile
  ToggleStarterMenu -> H.modify_ \s -> s { starterMenuOpen = not s.starterMenuOpen }
  LoadStarter k -> case Starter.findByKey k of
    Nothing -> pure unit
    Just starter -> do
      H.modify_ \s -> s
        { moduleSource = starter.moduleSource
        , cells = starter.cells
        , nextCellId = Array.length starter.cells + 1
        , starterKey = starter.key
        , starterMenuOpen = false
        , cellResults = Map.empty
        , cellTypes = Map.empty
        }
      handleAction ScheduleCompile
  ToggleInScope -> H.modify_ \s -> s { inScopeOpen = not s.inScopeOpen }
  ScheduleCompile -> do
    s <- H.get
    case s.pendingCompile of
      Just fid -> H.kill fid
      Nothing -> pure unit
    fid <- H.fork do
      H.liftAff (delay debounceMs)
      handleAction Compile
    H.modify_ _ { pendingCompile = Just fid }
  Compile -> do
    H.modify_ _
      { compiling = true
      , transportError = Nothing
      , runtimeError = Nothing
      , pendingCompile = Nothing
      }
    s <- H.get
    let
      req = CompileRequest
        { "module": UserModule { source: s.moduleSource }
        , cells: map mkCell s.cells
        , runtime: s.runtime
        }
      bodyJson = stringify (CA.encode compileRequestCodec req)
    result <- H.liftAff $ AX.request $ AX.defaultRequest
      { method = Left POST
      , url = backendUrl <> "/session/compile"
      , responseFormat = RF.json
      , content = Just (RB.string bodyJson)
      }
    case result of
      Left err ->
        H.modify_ _
          { compiling = false, transportError = Just (AX.printError err) }
      Right { body } -> case CA.decode compileResponseCodec body of
        Left decodeErr ->
          H.modify_ _
            { compiling = false
            , transportError = Just ("decode: " <> CA.printJsonDecodeError decodeErr)
            }
        Right (CompileResponse r) -> do
          let typesMap = Map.fromFoldable
                ( map (\(CellType ct) -> Tuple ct.id ct.signature) r.types )
          H.modify_ _
            { compiling = false
            , errors = r.errors
            , warnings = r.warnings
            , cellRanges = r.cellLines
            , cellTypes = typesMap
            }
          decorateErrors r.errors r.cellLines
          -- Dispatch on which adapter produced the response:
          --   - Node / server-side: emits are already populated;
          --     fold them into cellResults directly, no Worker.
          --   - Browser / client-side: we get JS, run it in a Worker.
          if not (Array.null r.emits) then do
            teardownExecution
            H.modify_ \s ->
              let decoded = Map.fromFoldable
                    ( map (\(CellEmit e) -> Tuple e.id (Value.parse e.value)) r.emits )
              in s { cellResults = decoded }
          else case r.js of
            Nothing -> teardownExecution
            Just js -> startExecution js
  HandleWorkerMessage msg -> case msg of
    Emit id value ->
      H.modify_ \s -> s { cellResults = Map.insert id (Value.parse value) s.cellResults }
    Done -> teardownExecution
    WorkerError err -> do
      H.modify_ _ { runtimeError = Just err }
      teardownExecution
    Unknown tag ->
      H.modify_ _ { runtimeError = Just ("worker: unknown message " <> tag) }
  WorkerTimeout -> do
    H.modify_ _ { runtimeError = Just ("timeout after " <> show workerTimeoutMs) }
    teardownExecution
  PollServer -> do
    pollRemote
    schedulePoll
  where
  mkCell c = Cell { id: c.id, kind: c.kind, source: c.source }
  updateCell id src cells =
    fromMaybe cells do
      idx <- findIndex (_.id >>> (_ == id)) cells
      modifyAt idx (_ { source = src }) cells
  flipKind = case _ of
    "let" -> "expr"
    _ -> "let"

-- | Bump the last-user-edit timestamp so the poll loop knows to
-- | hold off for a couple seconds (don't clobber live typing).
stampEdit
  :: forall o m
   . MonadAff m
  => H.HalogenM State Action Slots o m Unit
stampEdit = do
  t <- H.liftEffect nowMs
  H.modify_ _ { lastUserEditAt = t }

-- | Schedule the next poll tick. PollServer self-schedules so this
-- | is called once from Startup and then continuously by each tick.
schedulePoll
  :: forall o m
   . MonadAff m
  => H.HalogenM State Action Slots o m Unit
schedulePoll = void $ H.fork do
  H.liftAff (delay (Milliseconds 2000.0))
  handleAction PollServer

-- | One poll tick: GET /session, compare to local state, apply if
-- | input fields differ AND the user's been idle for at least 2s.
-- | The idle check protects active typing; without it, the remote's
-- | stale-by-one-keystroke state would fight the user every 2s.
pollRemote
  :: forall o m
   . MonadAff m
  => H.HalogenM State Action Slots o m Unit
pollRemote = do
  s <- H.get
  now <- H.liftEffect nowMs
  when (now - s.lastUserEditAt > 2000.0) do
    result <- H.liftAff $ AX.request $ AX.defaultRequest
      { method = Left GET
      , url = backendUrl <> "/session"
      , responseFormat = RF.json
      , content = Nothing
      }
    case result of
      Left _ -> pure unit
      Right { body } -> case CA.decode compileResponseCodec body of
        Left _ -> pure unit
        Right (CompileResponse r) ->
          when (remoteDiffers s r) (applyRemote r)

-- | Does the remote snapshot differ from what the frontend is
-- | currently showing, in a way that merits overwriting? We compare
-- | only input state (module, cells, runtime) — derived fields
-- | change on every compile even when nothing semantically differs.
remoteDiffers
  :: forall r
   . State
  -> { "module" :: UserModule
     , cells :: Array Cell
     , runtime :: String
     | r }
  -> Boolean
remoteDiffers s r =
  let UserModule rm = r."module"
      sameModule = rm.source == s.moduleSource
      sameRuntime = r.runtime == s.runtime
      sameCells = cellsMatch s.cells r.cells
  in not (sameModule && sameRuntime && sameCells)
  where
  cellsMatch local remote =
    Array.length local == Array.length remote
      && Array.all identity
           (Array.zipWith cellEq local remote)
  cellEq local (Cell remote) =
    local.id == remote.id
      && local.kind == remote.kind
      && local.source == remote.source

-- | Take a remote snapshot and overwrite local display state with it.
-- | Bumps lastUserEditAt so we don't immediately re-apply.
applyRemote
  :: forall o m r
   . MonadAff m
  => { "module" :: UserModule
     , cells :: Array Cell
     , runtime :: String
     , types :: Array CellType
     , cellLines :: Array CellRange
     , errors :: Array CompileError
     , warnings :: Array CompileError
     , emits :: Array CellEmit
     | r }
  -> H.HalogenM State Action Slots o m Unit
applyRemote r = do
  let UserModule rm = r."module"
      typesMap = Map.fromFoldable
        ( map (\(CellType ct) -> Tuple ct.id ct.signature) r.types )
      cellRecs = map (\(Cell c) -> { id: c.id, kind: c.kind, source: c.source }) r.cells
      resultsMap = Map.fromFoldable
        ( map (\(CellEmit e) -> Tuple e.id (Value.parse e.value)) r.emits )
  H.modify_ _
    { moduleSource = rm.source
    , cells = cellRecs
    , runtime = r.runtime
    , cellTypes = typesMap
    , cellResults = resultsMap
    , cellRanges = r.cellLines
    , errors = r.errors
    , warnings = r.warnings
    }
  decorateErrors r.errors r.cellLines

-- | Push inline error decorations to each editor. `errs` are the
-- | raw CompileErrors from the response; we partition by filename
-- | (Playground/User.purs → module, Main.purs → cells, via
-- | `cellRanges`) and tell each editor slot its per-editor spans.
-- | Editors that have no errors still get told `[]` so stale
-- | squiggles from a previous compile go away.
decorateErrors
  :: forall o m
   . MonadAff m
  => Array CompileError
  -> Array CellRange
  -> H.HalogenM State Action Slots o m Unit
decorateErrors errs cellRanges = do
  s <- H.get
  let partition = partitionErrorsByEditor errs cellRanges
  H.tell _moduleEditor unit (Editor.SetErrors partition.moduleSpans)
  for_ s.cells \c -> do
    let spans = fromMaybe [] (Map.lookup c.id partition.cellSpans)
    H.tell _cellEditor c.id (Editor.SetErrors spans)

type ErrorPartition =
  { moduleSpans :: Array ErrorSpan
  , cellSpans :: Map String (Array ErrorSpan)
  }

partitionErrorsByEditor
  :: Array CompileError
  -> Array CellRange
  -> ErrorPartition
partitionErrorsByEditor errs cellRanges =
  Array.foldl classify { moduleSpans: [], cellSpans: Map.empty } errs
  where
  classify acc (CompileError e) = case e.position, e.filename of
    Just (Position p), Just file
      | endsWith "Playground/User.purs" file ->
          acc
            { moduleSpans =
                Array.snoc acc.moduleSpans
                  (makeSpan p.startLine p.startColumn p.endLine p.endColumn e.message)
            }
      | endsWith "Main.purs" file ->
          case findCellAt cellRanges p.startLine of
            Nothing -> acc
            Just (CellRange cr) ->
              let
                span =
                  makeSpan
                    (p.startLine - cr.startLine + 1)
                    p.startColumn
                    (p.endLine - cr.startLine + 1)
                    p.endColumn
                    e.message
                existing = fromMaybe [] (Map.lookup cr.id acc.cellSpans)
              in
                acc { cellSpans = Map.insert cr.id (Array.snoc existing span) acc.cellSpans }
    _, _ -> acc
  makeSpan sl sc el ec msg =
    { startLine: sl, startColumn: sc, endLine: el, endColumn: ec, message: msg }
  findCellAt ranges line =
    Array.find (\(CellRange cr) -> line >= cr.startLine && line <= cr.endLine) ranges
  endsWith suffix str =
    case Str.length str - Str.length suffix of
      n | n >= 0 ->
          Str.take (Str.length suffix) (Str.drop n str) == suffix
      _ -> false

-- | Tears down any live worker, its subscription, and its timeout fiber.
teardownExecution
  :: forall o m
   . MonadAff m
  => H.HalogenM State Action Slots o m Unit
teardownExecution = do
  s <- H.get
  case s.worker of
    Just w -> H.liftEffect (Worker.terminate w)
    Nothing -> pure unit
  case s.workerSub of
    Just sid -> H.unsubscribe sid
    Nothing -> pure unit
  case s.workerTimeout of
    Just fid -> H.kill fid
    Nothing -> pure unit
  H.modify_ _
    { worker = Nothing
    , workerSub = Nothing
    , workerTimeout = Nothing
    }

-- | Tears down any previous run, then spawns a fresh worker, posts the
-- | bundle JS, subscribes to worker messages, and schedules a timeout.
startExecution
  :: forall o m
   . MonadAff m
  => String
  -> H.HalogenM State Action Slots o m Unit
startExecution js = do
  teardownExecution
  H.modify_ _ { cellResults = Map.empty }
  { emitter, listener } <- H.liftEffect HS.create
  subId <- H.subscribe (HandleWorkerMessage <$> emitter)
  worker <- H.liftEffect $ Worker.spawnWorker (HS.notify listener)
  H.liftEffect $ Worker.postJs worker js
  timeoutId <- H.fork do
    H.liftAff (delay workerTimeoutMs)
    handleAction WorkerTimeout
  H.modify_ _
    { worker = Just worker
    , workerSub = Just subId
    , workerTimeout = Just timeoutId
    }

render :: forall m. MonadAff m => State -> H.ComponentHTML Action Slots m
render state =
  HH.div
    [ HP.class_
        ( H.ClassName
            ( "playground-shell"
                <> (if state.compiling then " is-compiling" else "")
            )
        )
    ]
    [ renderHeader state
    , if state.inScopeOpen then renderInScopePanel state else HH.text ""
    , HH.main [ HP.class_ (H.ClassName "columns") ]
        [ renderModuleColumn state
        , renderCellsColumn state
        , renderGutterColumn state
        ]
    , renderErrorPanel state
    ]

renderInScopePanel :: forall m. State -> H.ComponentHTML Action Slots m
renderInScopePanel state =
  let sc = InScope.forRuntime state.runtime
  in HH.section [ HP.class_ (H.ClassName "in-scope-panel") ]
    [ HH.h2_
        [ HH.text "In scope — "
        , HH.span [ HP.class_ (H.ClassName "runtime-label") ]
            [ HH.text sc.runtimeLabel ]
        ]
    , HH.div [ HP.class_ (H.ClassName "in-scope-grid") ]
        [ renderList "Auto-imported (cells see these)" sc.autoImports
        , renderList "Highlighted packages" sc.highlightedPackages
        ]
    , if Array.null sc.notes then HH.text ""
      else HH.ul [ HP.class_ (H.ClassName "in-scope-notes") ]
        (map (\n -> HH.li_ [ HH.text n ]) sc.notes)
    ]
  where
  renderList title items =
    HH.div [ HP.class_ (H.ClassName "in-scope-section") ]
      [ HH.h3_ [ HH.text title ]
      , HH.ul_ (map (\x -> HH.li_ [ HH.text x ]) items)
      ]

renderHeader :: forall m. State -> H.ComponentHTML Action Slots m
renderHeader state =
  HH.header [ HP.class_ (H.ClassName "playground-header") ]
    [ HH.div [ HP.class_ (H.ClassName "title-group") ]
        [ HH.h1_ [ HH.text "PureScript Playground" ]
        , HH.p [ HP.class_ (H.ClassName "subtitle") ]
            [ HH.text
                "Edit the module and the cells; auto-compiles 400ms after you stop typing."
            ]
        ]
    , renderStarterDropdown state
    , HH.div [ HP.class_ (H.ClassName "runtime-toggle") ]
        [ runtimeButton state "browser" "Browser"
        , runtimeButton state "node" "Node"
        , runtimeButton state "purerl" "Purerl"
        ]
    , HH.button
        [ HP.class_
            ( H.ClassName
                ( "in-scope-btn"
                    <> (if state.inScopeOpen then " active" else "")
                )
            )
        , HP.title "Show what's in scope for the current runtime"
        , HE.onClick \_ -> ToggleInScope
        ]
        [ HH.text "ⓘ In scope" ]
    , HH.button
        [ HP.class_ (H.ClassName "compile-btn")
        , HP.disabled state.compiling
        , HE.onClick \_ -> Compile
        ]
        [ HH.text (if state.compiling then "Compiling…" else "Compile") ]
    ]

renderStarterDropdown :: forall m. State -> H.ComponentHTML Action Slots m
renderStarterDropdown state =
  HH.div [ HP.class_ (H.ClassName "starter-dropdown") ]
    [ HH.button
        [ HP.class_ (H.ClassName "starter-btn")
        , HE.onClick \_ -> ToggleStarterMenu
        ]
        [ HH.text (currentLabel <> " ▾") ]
    , if state.starterMenuOpen
        then HH.div [ HP.class_ (H.ClassName "starter-menu") ]
          (map (renderStarterOption state) starters)
        else HH.text ""
    ]
  where
  currentLabel = case Starter.findByKey state.starterKey of
    Just s -> s.label
    Nothing -> "Starter ▾"

renderStarterOption :: forall m. State -> Starter -> H.ComponentHTML Action Slots m
renderStarterOption state s =
  HH.button
    [ HP.class_
        ( H.ClassName
            ( "starter-option"
                <> (if state.starterKey == s.key then " current" else "")
            )
        )
    , HE.onClick \_ -> LoadStarter s.key
    ]
    [ HH.div [ HP.class_ (H.ClassName "starter-label") ] [ HH.text s.label ]
    , HH.div [ HP.class_ (H.ClassName "starter-desc") ] [ HH.text s.description ]
    , HH.div [ HP.class_ (H.ClassName "starter-compat") ]
        [ compatBadge state.runtime "browser" s.compat.browser
        , compatBadge state.runtime "node" s.compat.node
        , compatBadge state.runtime "purerl" s.compat.purerl
        ]
    ]

compatBadge
  :: forall m
   . String
  -> String
  -> Boolean
  -> H.ComponentHTML Action Slots m
compatBadge currentRuntime label ok =
  HH.span
    [ HP.class_
        ( H.ClassName
            ( "compat-badge compat-"
                <> (if ok then "yes" else "no")
                <> (if currentRuntime == label then " compat-current" else "")
            )
        )
    ]
    [ HH.text ((if ok then "✓ " else "✗ ") <> label) ]

runtimeButton :: forall m. State -> String -> String -> H.ComponentHTML Action Slots m
runtimeButton state value label =
  HH.button
    [ HP.class_
        ( H.ClassName
            ( "runtime-btn"
                <> (if state.runtime == value then " runtime-active" else "")
            )
        )
    , HE.onClick \_ -> SetRuntime value
    ]
    [ HH.text label ]

renderModuleColumn :: forall m. MonadAff m => State -> H.ComponentHTML Action Slots m
renderModuleColumn state =
  HH.section [ HP.class_ (H.ClassName "pane pane-module") ]
    [ HH.h2_ [ HH.text "Module" ]
    , HH.slot _moduleEditor unit Editor.component
        { initialDoc: state.moduleSource, tag: "module" }
        (\(Editor.Changed src) -> ModuleChanged src)
    ]

renderCellsColumn :: forall m. MonadAff m => State -> H.ComponentHTML Action Slots m
renderCellsColumn state =
  HH.section [ HP.class_ (H.ClassName "pane pane-cells") ]
    ( [ HH.h2_ [ HH.text "Cells" ] ]
        <> mapWithIndex renderCellRow state.cells
        <>
          [ HH.button
              [ HP.class_ (H.ClassName "add-cell-btn")
              , HE.onClick \_ -> AddCell
              ]
              [ HH.text "+ add cell" ]
          ]
    )

-- | Position-based color class (cycles every 8 cells). The same
-- | class is also applied to the matching gutter row, so a cell and
-- | its value/type entry visibly share an accent across the page.
cellColorClass :: Int -> String
cellColorClass idx = "cell-color-" <> show (idx `mod` 8)

renderCellRow :: forall m. MonadAff m => Int -> CellRec -> H.ComponentHTML Action Slots m
renderCellRow idx c =
  HH.div
    [ HP.class_
        ( H.ClassName
            ( "cell-row "
                <> cellColorClass idx
                <> (if c.kind == "let" then " cell-row-let" else " cell-row-expr")
            )
        )
    ]
    [ HH.div [ HP.class_ (H.ClassName "cell-meta") ]
        [ HH.span [ HP.class_ (H.ClassName "cell-id") ] [ HH.text c.id ]
        , HH.button
            [ HP.class_ (H.ClassName ("cell-kind-btn cell-kind-" <> c.kind))
            , HE.onClick \_ -> ToggleCellKind c.id
            , HP.title
                ( if c.kind == "let"
                    then "let-cell (splices verbatim; no gutter output). Click to switch to expr."
                    else "expr-cell (evaluated; shown in gutter). Click to switch to let."
                )
            ]
            [ HH.text c.kind ]
        , HH.button
            [ HP.class_ (H.ClassName "remove-cell-btn")
            , HE.onClick \_ -> RemoveCell c.id
            , HP.title "Remove cell"
            ]
            [ HH.text "×" ]
        ]
    , HH.slot _cellEditor c.id Editor.component
        { initialDoc: c.source, tag: "cell" }
        (\(Editor.Changed src) -> CellChanged c.id src)
    ]

-- | Gutter always shows the last-known values + types. On a failed
-- | compile the previous values stay put; errors are surfaced in the
-- | bottom panel. While a new compile is pending, CSS fades this column.
renderGutterColumn :: forall m. MonadAff m => State -> H.ComponentHTML Action Slots m
renderGutterColumn state =
  HH.section [ HP.class_ (H.ClassName "pane pane-gutter") ]
    [ HH.h2_ [ HH.text "Values" ]
    , renderResults state
    ]

renderResults :: forall m. MonadAff m => State -> H.ComponentHTML Action Slots m
renderResults state =
  HH.div [ HP.class_ (H.ClassName "gutter-rows") ]
    ( Array.catMaybes (mapWithIndex maybeRow state.cells)
        <> renderRuntimeError state.runtimeError
    )
  where
  -- Preserve the original cell index for colour consistency; just
  -- drop let-cells from the gutter so it only shows evaluated values.
  maybeRow idx c =
    if c.kind == "expr" then Just (renderCellResult state idx c) else Nothing

renderCellResult :: forall m. MonadAff m => State -> Int -> CellRec -> H.ComponentHTML Action Slots m
renderCellResult state idx c =
  HH.div [ HP.class_ (H.ClassName ("gutter-row " <> cellColorClass idx)) ]
    [ HH.span [ HP.class_ (H.ClassName "gutter-cell-id") ] [ HH.text c.id ]
    , HH.div [ HP.class_ (H.ClassName "gutter-body") ]
        [ renderType state c
        , renderValue state c
        ]
    ]
  where
  renderType st cell = case Map.lookup cell.id st.cellTypes of
    Just sig ->
      HH.div [ HP.class_ (H.ClassName "gutter-type") ]
        [ HH.slot_ _sigil cell.id SigilView.component { typeString: sig } ]
    Nothing ->
      HH.span [ HP.class_ (H.ClassName "muted gutter-type") ] [ HH.text "—" ]
  renderValue st cell = case Map.lookup cell.id st.cellResults of
    Just v ->
      HH.div [ HP.class_ (H.ClassName "gutter-value") ]
        [ ValueView.render v ]
    Nothing ->
      HH.span [ HP.class_ (H.ClassName "muted") ] [ HH.text "—" ]

renderRuntimeError :: forall m. Maybe String -> Array (H.ComponentHTML Action Slots m)
renderRuntimeError = case _ of
  Nothing -> []
  Just err ->
    [ HH.pre [ HP.class_ (H.ClassName "runtime-error") ]
        [ HH.text ("runtime: " <> err) ]
    ]

-- | Bottom panel: absent when clean. Each structured compile error is
-- | attributed to an originating surface (cell <id>, module, or just
-- | "runtime") and rendered with an error code + message.
renderErrorPanel :: forall m. State -> H.ComponentHTML Action Slots m
renderErrorPanel state =
  let
    transportRow = case state.transportError of
      Just err ->
        [ row { kind: "transport", target: "network", message: err, code: "" } ]
      Nothing -> []
    compileRows = map (attributedRow state "compile") state.errors
    warningRows = map (attributedRow state "warning") state.warnings
    rows = transportRow <> compileRows <> warningRows
  in
    case rows of
      [] -> HH.text ""
      _ ->
        HH.section [ HP.class_ (H.ClassName "error-panel") ]
          ( [ HH.h2_ [ HH.text "Errors" ] ] <> rows )
  where
  row r =
    HH.div
      [ HP.class_ (H.ClassName ("error-row error-" <> r.kind)) ]
      [ HH.div [ HP.class_ (H.ClassName "error-head") ]
          [ HH.span [ HP.class_ (H.ClassName "error-kind") ] [ HH.text r.kind ]
          , HH.span [ HP.class_ (H.ClassName "error-target") ] [ HH.text r.target ]
          , if r.code == "" then HH.text ""
            else HH.span [ HP.class_ (H.ClassName "error-code") ] [ HH.text r.code ]
          ]
      , HH.pre [ HP.class_ (H.ClassName "error-msg") ] [ HH.text r.message ]
      ]

attributedRow
  :: forall m
   . State
  -> String
  -> CompileError
  -> H.ComponentHTML Action Slots m
attributedRow state kind (CompileError e) =
  HH.div
    [ HP.class_ (H.ClassName ("error-row error-" <> kind)) ]
    [ HH.div [ HP.class_ (H.ClassName "error-head") ]
        [ HH.span [ HP.class_ (H.ClassName "error-kind") ] [ HH.text kind ]
        , HH.span [ HP.class_ (H.ClassName "error-target") ]
            [ HH.text (attribute state e) ]
        , HH.span [ HP.class_ (H.ClassName "error-code") ] [ HH.text e.code ]
        ]
    , HH.pre [ HP.class_ (H.ClassName "error-msg") ] [ HH.text e.message ]
    ]

-- | Given an error's filename + position, produce a human-readable
-- | "target" string: "cell c2 ▸ line 3" if it falls in a cell's range in
-- | Main.purs; "module ▸ line 5" if it's in Playground/User.purs;
-- | "runtime" otherwise (our own Transport errors, synthesis lines
-- | outside any cell).
attribute
  :: State
  -> { code :: String
     , filename :: Maybe String
     , position :: Maybe Position
     , message :: String
     }
  -> String
attribute state e =
  case e.filename, e.position of
    Just file, Just (Position p) ->
      if endsWith "Playground/User.purs" file then
        "module ▸ line " <> show p.startLine
      else if endsWith "Main.purs" file then
        case findCellAt state.cellRanges p.startLine of
          Just (CellRange cr) ->
            "cell " <> cr.id
              <> " ▸ line "
              <> show (p.startLine - cr.startLine + 1)
          Nothing -> "synthesis ▸ Main.purs line " <> show p.startLine
      else file
    _, _ -> "—"
  where
  findCellAt ranges line =
    Array.find (\(CellRange cr) -> line >= cr.startLine && line <= cr.endLine) ranges
  endsWith suffix s =
    case Str.length s - Str.length suffix of
      n | n >= 0 ->
          Str.take (Str.length suffix) (Str.drop n s) == suffix
      _ -> false
