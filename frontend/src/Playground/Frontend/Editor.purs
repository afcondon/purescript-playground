module Playground.Frontend.Editor
  ( component
  , Input
  , Output(..)
  , Query(..)
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Subscription as HS
import Web.HTML.HTMLElement (toElement)

import Playground.Frontend.CodeMirror (EditorView)
import Playground.Frontend.CodeMirror as CM

type Input = { initialDoc :: String, tag :: String }

-- | The editor raises this on every document change. Parents debounce.
data Output = Changed String

-- | Replace the editor's content programmatically. Unused for MVP but
-- | cheap to leave in place.
data Query a = ReplaceContent String a

data Action = Initialise | Finalise | HandleChange String

type State =
  { input :: Input
  , view :: Maybe EditorView
  }

containerRef :: H.RefLabel
containerRef = H.RefLabel "cm-host"

component :: forall m. MonadAff m => H.Component Query Input Output m
component = H.mkComponent
  { initialState: \input -> { input, view: Nothing }
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , handleQuery = handleQuery
      , initialize = Just Initialise
      , finalize = Just Finalise
      }
  }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div
    [ HP.ref containerRef
    , HP.class_ (H.ClassName ("cm-host cm-host-" <> state.input.tag))
    ]
    []

handleAction
  :: forall m
   . MonadAff m
  => Action
  -> H.HalogenM State Action () Output m Unit
handleAction = case _ of
  Initialise -> do
    state <- H.get
    mEl <- H.getHTMLElementRef containerRef
    case mEl of
      Nothing -> pure unit
      Just htmlEl -> do
        let el = toElement htmlEl
        { emitter, listener } <- liftEffect HS.create
        _ <- H.subscribe (HandleChange <$> emitter)
        view <- liftEffect $
          CM.createEditor el state.input.initialDoc (HS.notify listener)
        H.modify_ _ { view = Just view }
  Finalise -> do
    state <- H.get
    case state.view of
      Just view -> liftEffect (CM.destroy view)
      Nothing -> pure unit
  HandleChange content -> H.raise (Changed content)

handleQuery
  :: forall m a
   . MonadAff m
  => Query a
  -> H.HalogenM State Action () Output m (Maybe a)
handleQuery = case _ of
  ReplaceContent content next -> do
    state <- H.get
    case state.view of
      Just view -> do
        liftEffect (CM.setContent view content)
        pure (Just next)
      Nothing -> pure (Just next)
