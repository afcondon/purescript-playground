-module(erl_data_binary_uTF16@ps).
-export([fromString/0, toString/0, toBinary/0]).
-compile(no_auto_import).
fromString() ->
  fun
    (V) ->
      erl_data_binary_uTF16@foreign:fromString(V)
  end.

toString() ->
  fun
    (V) ->
      erl_data_binary_uTF16@foreign:toString(V)
  end.

toBinary() ->
  fun
    (V) ->
      erl_data_binary_uTF16@foreign:toBinary(V)
  end.

