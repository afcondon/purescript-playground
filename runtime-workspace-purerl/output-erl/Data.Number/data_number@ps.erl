-module(data_number@ps).
-export([fromString/0, fromString/1, isFinite/0, fromStringImpl/0]).
-compile(no_auto_import).
fromString() ->
  fun
    (Str) ->
      fromString(Str)
  end.

fromString(Str) ->
  (data_number@foreign:fromStringImpl())
  (
    Str,
    isFinite(),
    data_maybe@ps:'Just'(),
    {nothing}
  ).

isFinite() ->
  fun
    (V) ->
      data_number@foreign:isFinite(V)
  end.

fromStringImpl() ->
  data_number@foreign:fromStringImpl().

