module Playground.Server.Main where

import Prelude

import Data.Argonaut.Core (stringify)
import Data.Argonaut.Parser (jsonParser)
import Data.Codec.Argonaut as CA
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (liftAff)
import HTTPurple (Method(..), ServerM, ok', serve, toString)
import HTTPurple.Headers (headers)
import Routing.Duplex (RouteDuplex', root)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

import Playground.Server.Compile as Compile
import Playground.Server.Synthesize (synthesize)
import Playground.Session
  ( CompileError(..)
  , CompileResponse(..)
  , compileRequestCodec
  , compileResponseCodec
  )

data Route = Health | SessionCompile

derive instance Generic Route _

route :: RouteDuplex' Route
route = root $ sum
  { "Health": "health" / noArgs
  , "SessionCompile": "session" / "compile" / noArgs
  }

errorJson :: String -> String -> String
errorJson code msg =
  stringify $ CA.encode compileResponseCodec $
    CompileResponse
      { js: Nothing
      , warnings: []
      , errors:
          [ CompileError
              { code, filename: Nothing, position: Nothing, message: msg }
          ]
      , types: []
      , cellLines: []
      }

main :: ServerM
main = serve { port: 3050, hostname: "localhost" }
  { route
  , router: \{ route: r, method, body } ->
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
            bodyStr <- toString body
            case jsonParser bodyStr of
              Left parseErr ->
                ok' jsonCors (errorJson "BadJSON" parseErr)
              Right json -> case CA.decode compileRequestCodec json of
                Left decodeErr ->
                  ok' jsonCors
                    (errorJson "BadRequest" (CA.printJsonDecodeError decodeErr))
                Right req -> do
                  let synth = synthesize req
                  out <- liftAff $ Compile.compileSources synth
                  ok' jsonCors out
  }
