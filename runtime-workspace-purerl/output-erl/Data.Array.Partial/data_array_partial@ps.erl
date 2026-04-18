-module(data_array_partial@ps).
-export([tail/0, tail/2, last/0, last/2, init/0, init/2, head/0, head/2]).
-compile(no_auto_import).
tail() ->
  fun
    (V) ->
      fun
        (Xs) ->
          tail(V, Xs)
      end
  end.

tail(_, Xs) ->
  data_array@foreign:slice(1, array:size(Xs), Xs).

last() ->
  fun
    (V) ->
      fun
        (Xs) ->
          last(V, Xs)
      end
  end.

last(_, Xs) ->
  array:get((array:size(Xs)) - 1, Xs).

init() ->
  fun
    (V) ->
      fun
        (Xs) ->
          init(V, Xs)
      end
  end.

init(_, Xs) ->
  data_array@foreign:slice(0, (array:size(Xs)) - 1, Xs).

head() ->
  fun
    (V) ->
      fun
        (Xs) ->
          head(V, Xs)
      end
  end.

head(_, Xs) ->
  array:get(0, Xs).

