-module(control_monad_trans_class@ps).
-export([lift/0, lift/1]).
-compile(no_auto_import).
lift() ->
  fun
    (Dict) ->
      lift(Dict)
  end.

lift(#{ lift := Dict }) ->
  Dict.

