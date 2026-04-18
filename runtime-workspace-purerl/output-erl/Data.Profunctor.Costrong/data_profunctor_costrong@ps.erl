-module(data_profunctor_costrong@ps).
-export([unsecond/0, unsecond/1, unfirst/0, unfirst/1]).
-compile(no_auto_import).
unsecond() ->
  fun
    (Dict) ->
      unsecond(Dict)
  end.

unsecond(#{ unsecond := Dict }) ->
  Dict.

unfirst() ->
  fun
    (Dict) ->
      unfirst(Dict)
  end.

unfirst(#{ unfirst := Dict }) ->
  Dict.

