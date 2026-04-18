-module(data_char@ps).
-export([toCharCode/0, fromCharCode/0, toCharCode/1, fromCharCode/1]).
-compile(no_auto_import).
toCharCode() ->
  data_enum@ps:toCharCode().

fromCharCode() ->
  data_enum@ps:charToEnum().

toCharCode(V) ->
  data_enum@foreign:toCharCode(V).

fromCharCode(V) ->
  data_enum@ps:charToEnum(V).

