-module(control_monad_writer@ps).
-export([ writer/0
        , writer/1
        , runWriter/0
        , runWriter/1
        , mapWriter/0
        , mapWriter/2
        , execWriter/0
        , execWriter/1
        ]).
-compile(no_auto_import).
writer() ->
  fun
    (X) ->
      writer(X)
  end.

writer(X) ->
  X.

runWriter() ->
  fun
    (X) ->
      runWriter(X)
  end.

runWriter(X) ->
  X.

mapWriter() ->
  fun
    (F) ->
      fun
        (V) ->
          mapWriter(F, V)
      end
  end.

mapWriter(F, V) ->
  F(V).

execWriter() ->
  fun
    (M) ->
      execWriter(M)
  end.

execWriter(M) ->
  erlang:element(3, M).

