-module(erl_atom_symbol@ps).
-export([toAtom/0, toAtom/1, atom/0, atom/1]).
-compile(no_auto_import).
toAtom() ->
  fun
    (DictIsSymbol) ->
      toAtom(DictIsSymbol)
  end.

toAtom(_) ->
  unsafe_coerce@ps:unsafeCoerce().

atom() ->
  fun
    (DictIsSymbol) ->
      atom(DictIsSymbol)
  end.

atom(#{ reflectSymbol := DictIsSymbol }) ->
  erlang:binary_to_atom(DictIsSymbol({sProxy})).

