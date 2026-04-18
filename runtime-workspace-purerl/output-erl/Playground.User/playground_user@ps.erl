-module(playground_user@ps).
-export([divSafe/0, divSafe/2]).
-compile(no_auto_import).
divSafe() ->
  fun
    (V) ->
      fun
        (V1) ->
          divSafe(V, V1)
      end
  end.

divSafe(V, V1) ->
  if
    V1 =:= 0 ->
      {nothing};
    true ->
      {just, V div V1}
  end.

