-module(data_string_unsafe@ps).
-export([charAt/0, char/0]).
-compile(no_auto_import).
charAt() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_unsafe@foreign:charAt(V, V@1)
      end
  end.

char() ->
  fun
    (V) ->
      data_string_unsafe@foreign:char(V)
  end.

