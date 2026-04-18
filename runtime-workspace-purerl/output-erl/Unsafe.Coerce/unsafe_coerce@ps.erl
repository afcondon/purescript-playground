-module(unsafe_coerce@ps).
-export([unsafeCoerce/0]).
-compile(no_auto_import).
unsafeCoerce() ->
  fun
    (V) ->
      unsafe_coerce@foreign:unsafeCoerce(V)
  end.

