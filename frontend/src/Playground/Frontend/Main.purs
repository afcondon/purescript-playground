module Playground.Frontend.Main where

import Prelude

import Effect (Effect)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

import Playground.Frontend.Shell as Shell

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI Shell.component unit body
