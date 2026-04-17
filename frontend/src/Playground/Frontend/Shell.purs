module Playground.Frontend.Shell where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

-- | Root shell. For M0 this is just the three-column layout with stubs
-- | in each pane. Editors, submission, and result rendering arrive in
-- | subsequent milestones.

component :: forall q i o m. H.Component q i o m
component = H.mkComponent
  { initialState: \_ -> unit
  , render
  , eval: H.mkEval H.defaultEval
  }

render :: forall m. Unit -> H.ComponentHTML Unit () m
render _ =
  HH.div [ HP.class_ (H.ClassName "playground-shell") ]
    [ HH.header [ HP.class_ (H.ClassName "playground-header") ]
        [ HH.h1_ [ HH.text "PureScript Playground" ]
        , HH.p [ HP.class_ (H.ClassName "subtitle") ]
            [ HH.text "A scratchpad with live re-evaluation — scaffolding only." ]
        ]
    , HH.main [ HP.class_ (H.ClassName "columns") ]
        [ paneStub "module"     "Module"    "User module goes here."
        , paneStub "playground" "Cells"     "Playground cells go here."
        , paneStub "gutter"     "Gutter"    "Values and types will render here."
        ]
    ]
  where
  paneStub cls title body =
    HH.section
      [ HP.class_ (H.ClassName $ "pane pane-" <> cls) ]
      [ HH.h2_ [ HH.text title ]
      , HH.p_ [ HH.text body ]
      ]
