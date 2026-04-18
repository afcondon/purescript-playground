module Playground.User where

import Prelude

import Effect (Effect)
import Effect.Class (liftEffect)
import Erl.Process (Process, ProcessM, receive, self, spawn, unsafeRunProcessM, (!))

-- Echoes whatever it receives back to its spawner.
echoActor :: Process Int -> ProcessM Int Unit
echoActor parent = do
  msg <- receive
  liftEffect (parent ! msg)

-- Spawn echoActor, send it 42, wait for the reply.
roundTrip :: Effect Int
roundTrip = unsafeRunProcessM do
  me <- self
  child <- liftEffect (spawn (echoActor me))
  liftEffect (child ! 42)
  receive

-- Stateful counter actor: Add / Subtract / Query.
data Msg = Add Int | Subtract Int | Query (Process Int)

counter :: Int -> ProcessM Msg Unit
counter n = receive >>= case _ of
  Add m -> counter (n + m)
  Subtract m -> counter (n - m)
  Query reply -> liftEffect (reply ! n)

runCounter :: Effect Int
runCounter = unsafeRunProcessM do
  me <- self
  c <- liftEffect (spawn (counter 0))
  liftEffect do
    c ! Add 10
    c ! Add 5
    c ! Subtract 3
    c ! Query me
  receive
