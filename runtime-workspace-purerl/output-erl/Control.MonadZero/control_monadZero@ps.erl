-module(control_monadZero@ps).
-export([monadZeroIsDeprecated/0, monadZeroIsDeprecated/1, monadZeroArray/0]).
-compile(no_auto_import).
monadZeroIsDeprecated() ->
  fun
    (V) ->
      monadZeroIsDeprecated(V)
  end.

monadZeroIsDeprecated(_) ->
  #{}.

monadZeroArray() ->
  #{ 'Monad0' =>
     fun
       (_) ->
         control_monad@ps:monadArray()
     end
   , 'Alternative1' =>
     fun
       (_) ->
         control_alternative@ps:alternativeArray()
     end
   , 'MonadZeroIsDeprecated2' =>
     fun
       (_) ->
         undefined
     end
   }.

