module Playground.Frontend.Shell where

import Prelude

import Affjax.RequestBody as RB
import Affjax.ResponseFormat as RF
import Affjax.Web as AX
import Data.Argonaut.Core (stringify)
import Data.Array (filter, findIndex, modifyAt, snoc)
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

import Playground.Frontend.Editor as Editor
import Playground.Frontend.SigilView as SigilView
import Playground.Frontend.Worker (Worker, WorkerMessage(..))
import Playground.Frontend.Worker as Worker
import Playground.Session
  ( Cell(..)
  , CellType(..)
  , CompileRequest(..)
  , CompileResponse(..)
  , UserModule(..)
  , compileRequestCodec
  , compileResponseCodec
  )

type CellRec = { id :: String, kind :: String, source :: String }

type State =
  { moduleSource :: String
  , cells :: Array CellRec
  , nextCellId :: Int
  , compiling :: Boolean
  , errors :: Array String
  , transportError :: Maybe String
  , runtimeError :: Maybe String
  , cellResults :: Map String String
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
  | HandleWorkerMessage WorkerMessage
  | WorkerTimeout

starterModule :: String
starterModule =
  "module Scratch where\n\n\
  \import Prelude\n\n\
  \double :: Int -> Int\n\
  \double x = x * 2\n"

starterCells :: Array CellRec
starterCells =
  [ { id: "c1", kind: "expr", source: "double 21" }
  , { id: "c2", kind: "expr", source: "map double [1, 2, 3, 4, 5]" }
  , { id: "c3", kind: "expr", source: "double 21 + double 21" }
  ]

initialState :: forall i. i -> State
initialState _ =
  { moduleSource: starterModule
  , cells: starterCells
  , nextCellId: 4
  , compiling: false
  , errors: []
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
        }
      bodyJson = stringify (CA.encode compileRequestCodec req)
    result <- H.liftAff $ AX.request $ AX.defaultRequest
      { method = Left POST
      , url = "http://localhost:3050/session/compile"
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
          H.modify_ _ { compiling = false, errors = r.errors, cellTypes = typesMap }
          case r.js of
            Nothing -> teardownExecution
            Just js -> startExecution js
  HandleWorkerMessage msg -> case msg of
    Emit id value ->
      H.modify_ \s -> s { cellResults = Map.insert id value s.cellResults }
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
    , HH.button
        [ HP.class_ (H.ClassName "compile-btn")
        , HP.disabled state.compiling
        , HE.onClick \_ -> Compile
        ]
        [ HH.text (if state.compiling then "Compiling…" else "Compile") ]
    ]

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
        <> map renderCellRow state.cells
        <>
          [ HH.button
              [ HP.class_ (H.ClassName "add-cell-btn")
              , HE.onClick \_ -> AddCell
              ]
              [ HH.text "+ add cell" ]
          ]
    )

renderCellRow :: forall m. MonadAff m => CellRec -> H.ComponentHTML Action Slots m
renderCellRow c =
  HH.div [ HP.class_ (H.ClassName "cell-row") ]
    [ HH.div [ HP.class_ (H.ClassName "cell-meta") ]
        [ HH.span [ HP.class_ (H.ClassName "cell-id") ] [ HH.text c.id ]
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
    ( map (renderCellResult state) state.cells
        <> renderRuntimeError state.runtimeError
    )

renderCellResult :: forall m. MonadAff m => State -> CellRec -> H.ComponentHTML Action Slots m
renderCellResult state c =
  HH.div [ HP.class_ (H.ClassName "gutter-row") ]
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
      HH.pre [ HP.class_ (H.ClassName "gutter-value") ] [ HH.text v ]
    Nothing ->
      HH.span [ HP.class_ (H.ClassName "muted") ] [ HH.text "—" ]

renderRuntimeError :: forall m. Maybe String -> Array (H.ComponentHTML Action Slots m)
renderRuntimeError = case _ of
  Nothing -> []
  Just err ->
    [ HH.pre [ HP.class_ (H.ClassName "runtime-error") ]
        [ HH.text ("runtime: " <> err) ]
    ]

-- | Bottom panel: absent when clean, shows transport + compile errors
-- | when there's something to say. The gutter column keeps rendering
-- | the last-good values + types regardless.
renderErrorPanel :: forall m. State -> H.ComponentHTML Action Slots m
renderErrorPanel state =
  let
    transportRow = case state.transportError of
      Just err -> [ errorRow "transport" err ]
      Nothing -> []
    compileRows = map (errorRow "compile") state.errors
    rows = transportRow <> compileRows
  in
    case rows of
      [] -> HH.text ""
      _ ->
        HH.section [ HP.class_ (H.ClassName "error-panel") ]
          ( [ HH.h2_ [ HH.text "Errors" ] ] <> rows )
  where
  errorRow kind msg =
    HH.div [ HP.class_ (H.ClassName ("error-row error-" <> kind)) ]
      [ HH.span [ HP.class_ (H.ClassName "error-kind") ] [ HH.text kind ]
      , HH.pre [ HP.class_ (H.ClassName "error-msg") ] [ HH.text msg ]
      ]
