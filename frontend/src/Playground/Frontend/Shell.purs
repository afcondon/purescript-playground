module Playground.Frontend.Shell where

import Prelude

import Affjax.RequestBody as RB
import Affjax.ResponseFormat as RF
import Affjax.Web as AX
import Data.Codec.Argonaut as CA
import Data.Either (Either(..))
import Data.HTTP.Method (Method(..))
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

import Playground.Session (CompileResponse(..), compileResponseCodec)

-- | Shell state. For M1 we don't edit the module or the cells — we POST a
-- | fixed payload and render whatever the backend returns.
type State =
  { compiling :: Boolean
  , js :: Maybe String
  , errors :: Array String
  , transportError :: Maybe String
  }

data Action = Compile

initialState :: forall i. i -> State
initialState _ =
  { compiling: false, js: Nothing, errors: [], transportError: Nothing }

component :: forall q i o m. MonadAff m => H.Component q i o m
component = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction }
  }

handleAction
  :: forall o m
   . MonadAff m
  => Action
  -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  Compile -> do
    H.modify_ _ { compiling = true, transportError = Nothing }
    result <- H.liftAff $ AX.request $ AX.defaultRequest
      { method = Left POST
      , url = "http://localhost:3050/session/compile"
      , responseFormat = RF.json
      , content = Just (RB.string "{}")
      , headers = [ ]
      }
    case result of
      Left err ->
        H.modify_ _ { compiling = false, transportError = Just (AX.printError err) }
      Right { body } ->
        case CA.decode compileResponseCodec body of
          Left decodeErr ->
            H.modify_ _
              { compiling = false
              , transportError = Just ("decode: " <> CA.printJsonDecodeError decodeErr)
              }
          Right (CompileResponse r) ->
            H.modify_ _
              { compiling = false
              , js = r.js
              , errors = r.errors
              }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div [ HP.class_ (H.ClassName "playground-shell") ]
    [ HH.header [ HP.class_ (H.ClassName "playground-header") ]
        [ HH.div [ HP.class_ (H.ClassName "title-group") ]
            [ HH.h1_ [ HH.text "PureScript Playground" ]
            , HH.p [ HP.class_ (H.ClassName "subtitle") ]
                [ HH.text "M1: fixed payload → /session/compile → render bundled JS." ]
            ]
        , HH.button
            [ HP.class_ (H.ClassName "compile-btn")
            , HP.disabled state.compiling
            , HE.onClick \_ -> Compile
            ]
            [ HH.text (if state.compiling then "Compiling…" else "Compile") ]
        ]
    , HH.main [ HP.class_ (H.ClassName "columns") ]
        [ paneStub "module" "Module" "User module editor — lands in M2."
        , paneStub "playground" "Cells" "Playground cells — land in M2."
        , outputPane state
        ]
    ]
  where
  paneStub cls title body =
    HH.section [ HP.class_ (H.ClassName ("pane pane-" <> cls)) ]
      [ HH.h2_ [ HH.text title ]
      , HH.p_ [ HH.text body ]
      ]

outputPane :: forall m. State -> H.ComponentHTML Action () m
outputPane state =
  HH.section [ HP.class_ (H.ClassName "pane pane-output") ]
    [ HH.h2_ [ HH.text "Compiled JS" ]
    , renderBody
    ]
  where
  renderBody = case state.transportError of
    Just err ->
      HH.pre [ HP.class_ (H.ClassName "transport-error") ] [ HH.text err ]
    Nothing ->
      case state.errors of
        [] -> case state.js of
          Just js ->
            HH.pre [ HP.class_ (H.ClassName "js-output") ] [ HH.text js ]
          Nothing ->
            HH.p [ HP.class_ (H.ClassName "muted") ]
              [ HH.text "Press Compile to send the fixed payload." ]
        errs ->
          HH.div [ HP.class_ (H.ClassName "compile-errors") ]
            ( map
                ( \e ->
                    HH.pre [ HP.class_ (H.ClassName "compile-error") ]
                      [ HH.text e ]
                )
                errs
            )
