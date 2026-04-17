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
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Time.Duration (Milliseconds(..))
import Effect.Aff (delay)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Type.Proxy (Proxy(..))

import Playground.Frontend.Editor as Editor
import Playground.Session
  ( Cell(..)
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
  , js :: Maybe String
  , errors :: Array String
  , transportError :: Maybe String
  , pendingCompile :: Maybe H.ForkId
  }

type Slots =
  ( moduleEditor :: H.Slot Editor.Query Editor.Output Unit
  , cellEditor :: H.Slot Editor.Query Editor.Output String
  )

_moduleEditor :: Proxy "moduleEditor"
_moduleEditor = Proxy

_cellEditor :: Proxy "cellEditor"
_cellEditor = Proxy

data Action
  = Compile          -- user-triggered (button); compiles immediately
  | ScheduleCompile  -- debounced — fires after edits settle
  | ModuleChanged String
  | CellChanged String String
  | AddCell
  | RemoveCell String

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
  , js: Nothing
  , errors: []
  , transportError: Nothing
  , pendingCompile: Nothing
  }

debounceMs :: Milliseconds
debounceMs = Milliseconds 400.0

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
    H.modify_ \s -> s { cells = filter (_.id >>> (_ /= id)) s.cells }
    handleAction ScheduleCompile
  ScheduleCompile -> do
    s <- H.get
    -- Cancel any previously-scheduled compile.
    case s.pendingCompile of
      Just fid -> H.kill fid
      Nothing -> pure unit
    fid <- H.fork do
      H.liftAff (delay debounceMs)
      handleAction Compile
    H.modify_ _ { pendingCompile = Just fid }
  Compile -> do
    H.modify_ _ { compiling = true, transportError = Nothing, pendingCompile = Nothing }
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
        Right (CompileResponse r) ->
          H.modify_ _
            { compiling = false, js = r.js, errors = r.errors }
  where
  mkCell c = Cell { id: c.id, kind: c.kind, source: c.source }
  updateCell id src cells =
    fromMaybe cells do
      idx <- findIndex (_.id >>> (_ == id)) cells
      modifyAt idx (_ { source = src }) cells

render :: forall m. MonadAff m => State -> H.ComponentHTML Action Slots m
render state =
  HH.div [ HP.class_ (H.ClassName "playground-shell") ]
    [ renderHeader state
    , HH.main [ HP.class_ (H.ClassName "columns") ]
        [ renderModuleColumn state
        , renderCellsColumn state
        , renderOutputColumn state
        ]
    ]

renderHeader :: forall m. State -> H.ComponentHTML Action Slots m
renderHeader state =
  HH.header [ HP.class_ (H.ClassName "playground-header") ]
    [ HH.div [ HP.class_ (H.ClassName "title-group") ]
        [ HH.h1_ [ HH.text "PureScript Playground" ]
        , HH.p [ HP.class_ (H.ClassName "subtitle") ]
            [ HH.text "M2: edit the module and the cells; Compile posts and renders the bundle." ]
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
        <> map (renderCellRow) state.cells
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

renderOutputColumn :: forall m. State -> H.ComponentHTML Action Slots m
renderOutputColumn state =
  HH.section [ HP.class_ (H.ClassName "pane pane-output") ]
    [ HH.h2_ [ HH.text "Compiled JS" ]
    , case state.transportError of
        Just err ->
          HH.pre [ HP.class_ (H.ClassName "transport-error") ] [ HH.text err ]
        Nothing -> case state.errors of
          [] -> case state.js of
            Just js ->
              HH.pre [ HP.class_ (H.ClassName "js-output") ] [ HH.text js ]
            Nothing ->
              HH.p [ HP.class_ (H.ClassName "muted") ]
                [ HH.text "Press Compile to send the module + cells and render the bundle." ]
          errs ->
            HH.div [ HP.class_ (H.ClassName "compile-errors") ]
              ( map
                  ( \e ->
                      HH.pre [ HP.class_ (H.ClassName "compile-error") ]
                        [ HH.text e ]
                  )
                  errs
              )
    ]
