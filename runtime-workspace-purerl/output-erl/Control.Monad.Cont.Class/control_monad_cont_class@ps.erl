-module(control_monad_cont_class@ps).
-export([callCC/0, callCC/1]).
-compile(no_auto_import).
callCC() ->
  fun
    (Dict) ->
      callCC(Dict)
  end.

callCC(#{ callCC := Dict }) ->
  Dict.

