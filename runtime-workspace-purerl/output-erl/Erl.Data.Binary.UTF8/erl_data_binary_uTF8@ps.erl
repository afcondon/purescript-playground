-module(erl_data_binary_uTF8@ps).
-export([toBinary/0]).
-compile(no_auto_import).
toBinary() ->
  fun
    (V) ->
      erl_data_binary_uTF8@foreign:toBinary(V)
  end.

