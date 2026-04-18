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

import Playground.Frontend.Config (backendUrl)
import Playground.Frontend.Editor as Editor
import Playground.Frontend.SigilView as SigilView
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
  , runtime :: String             -- "browser" | "node" — which adapter to use
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
  | HandleWorkerMessage WorkerMessage
  | WorkerTimeout

starterModule :: String
starterModule =
  "module Scratch where\n\n\
  \import Prelude\n\n\
  \-- Cells automatically have these in scope; you only need to\n\
  \-- import the ones you also want to reference *in this module*:\n\
  \--\n\
  \--   Prelude\n\
  \--   Data.Array as Array\n\
  \--   Data.Either (Either(..))\n\
  \--   Data.Maybe (Maybe(..))\n\
  \--   Data.Tuple (Tuple(..))\n\
  \--   Effect (Effect)\n\
  \--   Effect.Aff (launchAff_)\n\
  \--   Effect.Class (liftEffect)\n\
  \--   Playground.Runtime (class ToPlaygroundValue, emit, toPlaygroundValue)\n\
  \--\n\
  \-- The full runtime-workspace package set is available to import:\n\
  \-- argonaut, affjax, parsing, transformers, etc.\n\n\
  \import Data.Maybe (Maybe(..))\n\
  \import Data.Time.Duration (Milliseconds(..))\n\
  \import Effect.Aff (Aff, delay)\n\n\
  \-- Safe division: Nothing on divide-by-zero, Just q otherwise.\n\
  \divSafe :: Int -> Int -> Maybe Int\n\
  \divSafe _ 0 = Nothing\n\
  \divSafe n d = Just (n / d)\n\n\
  \-- Async: pause 25ms then yield 100. Runs the same way under the\n\
  \-- browser Worker and a Node child-process — flip the runtime\n\
  \-- toggle and watch c6 produce the same value.\n\
  \timedSum :: Aff Int\n\
  \timedSum = do\n\
  \  delay (Milliseconds 25.0)\n\
  \  pure 100\n"

-- | Starter cells laid out as three short lessons:
-- |
-- |   c1            Just 20      — Maybe is "uncertainty made explicit"
-- |   c2  do-block   Just 30     ┐ same computation, two notations
-- |   c3  >>= form   Just 30     ┘ (do is sugar for chained bind)
-- |
-- |   c4  Array      [...]       ┐ same do-shape, three different
-- |   c5  Either     Right 30    │ Monad instances — uncertainty,
-- |   c1 above       Just 20     ┘ non-determinism, error-or-result
-- |
-- |   c6  Aff        200          — same do-shape again, this time
-- |                                 async. Works identically under
-- |                                 the Browser Worker and Node
-- |                                 child-process runtimes.
-- |
-- | The "click" moments: c2/c3 produce identical values (do is sugar
-- | for >>=), and c1/c4/c5/c6 are the same do-shape over Maybe /
-- | Array / Either / Aff, demonstrating the abstracted pattern. The
-- | *types* column tells the structural story; the values column
-- | shows the behavioural consequence.
starterCells :: Array CellRec
starterCells =
  [ { id: "c1"
    , kind: "expr"
    , source: "divSafe 100 5"
    }
  , { id: "c2"
    , kind: "expr"
    , source:
        "do\n\
        \  a <- divSafe 100 5\n\
        \  b <- divSafe 200 a\n\
        \  pure (a + b)"
    }
  , { id: "c3"
    , kind: "expr"
    , source:
        "divSafe 100 5 >>= \\a ->\n\
        \  divSafe 200 a >>= \\b ->\n\
        \    pure (a + b)"
    }
  , { id: "c4"
    , kind: "expr"
    , source:
        "do\n\
        \  x <- [1, 2, 3]\n\
        \  y <- [10, 20]\n\
        \  pure (x + y)"
    }
  , { id: "c5"
    , kind: "expr"
    , source:
        "do\n\
        \  x <- (Right 10 :: Either String Int)\n\
        \  y <- Right 20\n\
        \  pure (x + y)"
    }
  , { id: "c6"
    , kind: "expr"
    , source:
        "do\n\
        \  a <- timedSum\n\
        \  b <- timedSum\n\
        \  pure (a + b)"
    }
  ]

initialState :: forall i. i -> State
initialState _ =
  { moduleSource: starterModule
  , cells: starterCells
  , nextCellId: 7
  , runtime: "browser"
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
      , initialize = Just Compile
      }
  }

handleAction
  :: forall o m
   . MonadAff m
  => Action
  -> H.HalogenM State Action Slots o m Unit
handleAction = case _ of
  ModuleChanged src -> do
    H.modify_ _ { moduleSource = src }
    handleAction ScheduleCompile
  CellChanged id src -> do
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
  where
  mkCell c = Cell { id: c.id, kind: c.kind, source: c.source }
  updateCell id src cells =
    fromMaybe cells do
      idx <- findIndex (_.id >>> (_ == id)) cells
      modifyAt idx (_ { source = src }) cells
  flipKind = case _ of
    "let" -> "expr"
    _ -> "let"

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
    , HH.main [ HP.class_ (H.ClassName "columns") ]
        [ renderModuleColumn state
        , renderCellsColumn state
        , renderGutterColumn state
        ]
    , renderErrorPanel state
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
    , HH.div [ HP.class_ (H.ClassName "runtime-toggle") ]
        [ runtimeButton state "browser" "Browser"
        , runtimeButton state "node" "Node"
        ]
    , HH.button
        [ HP.class_ (H.ClassName "compile-btn")
        , HP.disabled state.compiling
        , HE.onClick \_ -> Compile
        ]
        [ HH.text (if state.compiling then "Compiling…" else "Compile") ]
    ]

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
