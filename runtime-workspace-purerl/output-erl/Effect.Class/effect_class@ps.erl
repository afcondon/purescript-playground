-module(effect_class@ps).
-export([monadEffectEffect/0, liftEffect/0, liftEffect/1]).
-compile(no_auto_import).
monadEffectEffect() ->
  #{ liftEffect =>
     fun
       (X) ->
         X
     end
   , 'Monad0' =>
     fun
       (_) ->
         effect@ps:monadEffect()
     end
   }.

liftEffect() ->
  fun
    (Dict) ->
      liftEffect(Dict)
  end.

liftEffect(#{ liftEffect := Dict }) ->
  Dict.

