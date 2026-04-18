-module(safe_coerce@ps).
-export([coerce/0, coerce/1]).
-compile(no_auto_import).
coerce() ->
  fun
    (V) ->
      coerce(V)
  end.

coerce(_) ->
  unsafe_coerce@ps:unsafeCoerce().

