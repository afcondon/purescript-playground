module Playground.Frontend.Config
  ( backendUrl
  , nowMs
  ) where

import Effect (Effect)

-- | The backend's origin, resolved from `window.location.hostname` so
-- | the same bundle works locally (`localhost`) and across Tailscale
-- | (an MacOS host's tailnet hostname or 100.x.y.z address). Port is
-- | still 3050.
foreign import backendUrl :: String

-- | ms since epoch. Used as a timestamp on the user's last edit so
-- | the polling loop doesn't clobber live typing.
foreign import nowMs :: Effect Number
