-module(erl_data_bitstring_type@ps).
-export([bitstringEq/0, eq_/0]).
-compile(no_auto_import).
bitstringEq() ->
  #{ eq => eq_() }.

eq_() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_bitstring_type@foreign:eq_(V, V@1)
      end
  end.

