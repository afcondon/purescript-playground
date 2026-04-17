module Playground.Server.Main where

import Prelude

import Data.Generic.Rep (class Generic)
import Effect (Effect)
import Effect.Console (log)
import HTTPurple (ServerM, ok, serve)
import Routing.Duplex (RouteDuplex', root)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

data Route = Health | SessionCompile

derive instance Generic Route _

route :: RouteDuplex' Route
route = root $ sum
  { "Health": "health" / noArgs
  , "SessionCompile": "session" / "compile" / noArgs
  }

main :: ServerM
main = serve { port: 3050, hostname: "localhost" }
  { route
  , router: \{ route: r } -> case r of
      Health -> ok "ok"
      SessionCompile -> ok "{\"stub\":true}"
  }
