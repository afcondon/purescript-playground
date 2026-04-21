module Playground.Frontend.Config
  ( backendUrl
  , wsBackendUrl
  , nowMs
  ) where

import Effect (Effect)

-- | The backend's origin, resolved from `window.location.hostname` so
-- | the same bundle works locally (`localhost`) and across Tailscale
-- | (an MacOS host's tailnet hostname or 100.x.y.z address). Port is
-- | still 3050.
foreign import backendUrl :: String

-- | The WS origin, mirroring `backendUrl` but with `ws://` / `wss://`
-- | per page protocol. Subscribers open `<wsBackendUrl>/session/ws`.
foreign import wsBackendUrl :: String

-- | ms since epoch.
foreign import nowMs :: Effect Number
