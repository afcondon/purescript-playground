-module(data_void@ps).
-export([absurd/0, absurd/1, showVoid/0]).
-compile(no_auto_import).
absurd() ->
  fun
    (A) ->
      absurd(A)
  end.

absurd(A) ->
  begin
    Spin =
      fun
        Spin (V) ->
          Spin(V)
      end,
    Spin(A)
  end.

showVoid() ->
  #{ show => absurd() }.

