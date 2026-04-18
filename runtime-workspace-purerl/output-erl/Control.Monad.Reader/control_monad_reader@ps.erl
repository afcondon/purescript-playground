-module(control_monad_reader@ps).
-export([ withReader/0
        , runReader/0
        , runReader/2
        , mapReader/0
        , mapReader/3
        , withReader/3
        ]).
-compile(no_auto_import).
withReader() ->
  control_monad_reader_trans@ps:withReaderT().

runReader() ->
  fun
    (V) ->
      fun
        (X) ->
          runReader(V, X)
      end
  end.

runReader(V, X) ->
  V(X).

mapReader() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (X) ->
              mapReader(F, V, X)
          end
      end
  end.

mapReader(F, V, X) ->
  F(V(X)).

withReader(V, V@1, V@2) ->
  control_monad_reader_trans@ps:withReaderT(V, V@1, V@2).

