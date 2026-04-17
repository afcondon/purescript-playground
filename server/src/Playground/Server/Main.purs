module Playground.Server.Main where

import Prelude

import Data.Generic.Rep (class Generic)
import Effect.Aff.Class (liftAff)
import HTTPurple (Method(..), ServerM, ok', serve)
import HTTPurple.Headers (headers)
import Routing.Duplex (RouteDuplex', root)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

import Playground.Server.Compile as Compile

data Route = Health | SessionCompile

derive instance Generic Route _

route :: RouteDuplex' Route
route = root $ sum
  { "Health": "health" / noArgs
  , "SessionCompile": "session" / "compile" / noArgs
  }

-- For M1 we ignore the request body and always compile a fixed Main.purs.
-- Synthesis from (module + cells) arrives in M2.
fixedMainSource :: String
fixedMainSource =
  "module Main where\n\n\
  \import Prelude\n\n\
  \import Effect (Effect)\n\
  \import Effect.Console (log)\n\
  \import Data.Array (length, range)\n\n\
  \main :: Effect Unit\n\
  \main = log (\"range 1..10 has length \" <> show (length (range 1 10)))\n"

main :: ServerM
main = serve { port: 3050, hostname: "localhost" }
  { route
  , router: \{ route: r, method } ->
      let plainCors = headers
            { "Access-Control-Allow-Origin": "*"
            , "Access-Control-Allow-Methods": "GET, POST, OPTIONS"
            , "Access-Control-Allow-Headers": "Content-Type"
            }
          jsonCors = headers
            { "Content-Type": "application/json"
            , "Access-Control-Allow-Origin": "*"
            , "Access-Control-Allow-Methods": "GET, POST, OPTIONS"
            , "Access-Control-Allow-Headers": "Content-Type"
            }
      in case method of
        Options -> ok' plainCors ""
        _ -> case r of
          Health -> ok' plainCors "ok"
          SessionCompile -> do
            body <- liftAff $ Compile.compileMain fixedMainSource
            ok' jsonCors body
  }
