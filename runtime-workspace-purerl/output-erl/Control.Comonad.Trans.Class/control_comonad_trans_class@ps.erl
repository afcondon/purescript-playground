-module(control_comonad_trans_class@ps).
-export([lower/0, lower/1]).
-compile(no_auto_import).
lower() ->
  fun
    (Dict) ->
      lower(Dict)
  end.

lower(#{ lower := Dict }) ->
  Dict.

