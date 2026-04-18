-module(control_comonad_store@ps).
-export([store/0, store/2, runStore/0, runStore/1]).
-compile(no_auto_import).
store() ->
  fun
    (F) ->
      fun
        (X) ->
          store(F, X)
      end
  end.

store(F, X) ->
  {tuple, F, X}.

runStore() ->
  fun
    (V) ->
      runStore(V)
  end.

runStore(V) ->
  {tuple, erlang:element(2, V), erlang:element(3, V)}.

