-module(control_comonad@ps).
-export([extract/0, extract/1]).
-compile(no_auto_import).
extract() ->
  fun
    (Dict) ->
      extract(Dict)
  end.

extract(#{ extract := Dict }) ->
  Dict.

