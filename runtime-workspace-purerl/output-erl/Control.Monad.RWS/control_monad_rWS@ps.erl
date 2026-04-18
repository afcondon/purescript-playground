-module(control_monad_rWS@ps).
-export([ withRWS/0
        , rws/0
        , rws/3
        , runRWS/0
        , runRWS/3
        , mapRWS/0
        , mapRWS/4
        , execRWS/0
        , execRWS/3
        , evalRWS/0
        , evalRWS/3
        , withRWS/4
        ]).
-compile(no_auto_import).
withRWS() ->
  control_monad_rWS_trans@ps:withRWST().

rws() ->
  fun
    (F) ->
      fun
        (R) ->
          fun
            (S) ->
              rws(F, R, S)
          end
      end
  end.

rws(F, R, S) ->
  (F(R))(S).

runRWS() ->
  fun
    (M) ->
      fun
        (R) ->
          fun
            (S) ->
              runRWS(M, R, S)
          end
      end
  end.

runRWS(M, R, S) ->
  (M(R))(S).

mapRWS() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (R) ->
              fun
                (S) ->
                  mapRWS(F, V, R, S)
              end
          end
      end
  end.

mapRWS(F, V, R, S) ->
  F((V(R))(S)).

execRWS() ->
  fun
    (M) ->
      fun
        (R) ->
          fun
            (S) ->
              execRWS(M, R, S)
          end
      end
  end.

execRWS(M, R, S) ->
  begin
    V = (M(R))(S),
    {tuple, erlang:element(2, V), erlang:element(4, V)}
  end.

evalRWS() ->
  fun
    (M) ->
      fun
        (R) ->
          fun
            (S) ->
              evalRWS(M, R, S)
          end
      end
  end.

evalRWS(M, R, S) ->
  begin
    V = (M(R))(S),
    {tuple, erlang:element(3, V), erlang:element(4, V)}
  end.

withRWS(V, V@1, V@2, V@3) ->
  control_monad_rWS_trans@ps:withRWST(V, V@1, V@2, V@3).

