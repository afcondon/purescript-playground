module Playground.Frontend.Config
  ( backendUrl
  ) where

-- | The backend's origin, resolved from `window.location.hostname` so
-- | the same bundle works locally (`localhost`) and across Tailscale
-- | (an MacOS host's tailnet hostname or 100.x.y.z address). Port is
-- | still 3050.
foreign import backendUrl :: String
