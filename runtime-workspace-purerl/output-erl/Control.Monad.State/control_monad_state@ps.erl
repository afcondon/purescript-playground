-module(control_monad_state@ps).
-export([ withState/0
        , runState/0
        , runState/2
        , mapState/0
        , mapState/3
        , execState/0
        , execState/2
        , evalState/0
        , evalState/2
        , withState/3
        ]).
-compile(no_auto_import).
withState() ->
  control_monad_state_trans@ps:withStateT().

runState() ->
  fun
    (V) ->
      fun
        (X) ->
          runState(V, X)
      end
  end.

runState(V, X) ->
  V(X).

mapState() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (X) ->
              mapState(F, V, X)
          end
      end
  end.

mapState(F, V, X) ->
  F(V(X)).

execState() ->
  fun
    (V) ->
      fun
        (S) ->
          execState(V, S)
      end
  end.

execState(V, S) ->
  erlang:element(3, V(S)).

evalState() ->
  fun
    (V) ->
      fun
        (S) ->
          evalState(V, S)
      end
  end.

evalState(V, S) ->
  erlang:element(2, V(S)).

withState(V, V@1, V@2) ->
  control_monad_state_trans@ps:withStateT(V, V@1, V@2).

