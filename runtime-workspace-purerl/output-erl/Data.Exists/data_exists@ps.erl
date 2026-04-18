-module(data_exists@ps).
-export([runExists/0, mkExists/0, runExists/1, mkExists/1]).
-compile(no_auto_import).
runExists() ->
  unsafe_coerce@ps:unsafeCoerce().

mkExists() ->
  unsafe_coerce@ps:unsafeCoerce().

runExists(V) ->
  V.

mkExists(V) ->
  V.

