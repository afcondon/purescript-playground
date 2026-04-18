-module(data_profunctor_cochoice@ps).
-export([unright/0, unright/1, unleft/0, unleft/1]).
-compile(no_auto_import).
unright() ->
  fun
    (Dict) ->
      unright(Dict)
  end.

unright(#{ unright := Dict }) ->
  Dict.

unleft() ->
  fun
    (Dict) ->
      unleft(Dict)
  end.

unleft(#{ unleft := Dict }) ->
  Dict.

