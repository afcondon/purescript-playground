-module(control_comonad_traced@ps).
-export([traced/0, traced/1, runTraced/0, runTraced/1]).
-compile(no_auto_import).
traced() ->
  fun
    (X) ->
      traced(X)
  end.

traced(X) ->
  X.

runTraced() ->
  fun
    (V) ->
      runTraced(V)
  end.

runTraced(V) ->
  V.

