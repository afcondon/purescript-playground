module Playground.Frontend.SigilView
  ( component
  , Input
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Web.DOM.Element (Element)
import Web.HTML.HTMLElement (toElement)

import Sigil.Html (renderSiglet)
import Sigil.Parse (parseToRenderType)

type Input = { typeString :: String }

type State = Input

data Action = Render | SetInput Input

foreign import _setInnerHTML :: Element -> String -> Effect Unit

containerRef :: H.RefLabel
containerRef = H.RefLabel "sigil-view"

component :: forall q o m. MonadAff m => H.Component q Input o m
component = H.mkComponent
  { initialState: identity
  , render
  , eval: H.mkEval H.defaultEval
      { handleAction = handleAction
      , initialize = Just Render
      , receive = \input -> Just (SetInput input)
      }
  }
  where
  -- No children — Halogen's VDom won't touch content we set via
  -- innerHTML in handleAction. The container is pure imperatively-
  -- managed territory.
  render _ =
    HH.span
      [ HP.ref containerRef
      , HP.class_ (H.ClassName "sigil-view")
      ]
      []

  handleAction = case _ of
    SetInput input -> do
      H.put input
      handleAction Render
    Render -> do
      state <- H.get
      mEl <- H.getHTMLElementRef containerRef
      case mEl of
        Nothing -> pure unit
        Just htmlEl -> do
          let el = toElement htmlEl
              html = case parseToRenderType state.typeString of
                Just ast -> renderSiglet { ast }
                -- If Sigil can't parse it, leave the Halogen-rendered
                -- text content in place by not touching innerHTML.
                Nothing -> state.typeString
          liftEffect (_setInnerHTML el html)
