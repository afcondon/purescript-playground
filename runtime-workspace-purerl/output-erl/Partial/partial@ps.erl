-module(partial@ps).
-export([crashWith/0, crashWith/1, crash/0, crash/1, '_crashWith'/0]).
-compile(no_auto_import).
crashWith() ->
  fun
    (V) ->
      crashWith(V)
  end.

crashWith(_) ->
  '_crashWith'().

crash() ->
  fun
    (V) ->
      crash(V)
  end.

crash(_) ->
  erlang:error(<<"Partial.crash: partial function">>).

'_crashWith'() ->
  fun
    (V) ->
      partial@foreign:'_crashWith'(V)
  end.

