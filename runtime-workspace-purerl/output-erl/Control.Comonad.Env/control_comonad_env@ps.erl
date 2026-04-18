-module(control_comonad_env@ps).
-export([ withEnv/0
        , runEnv/0
        , runEnv/1
        , mapEnv/0
        , mapEnv/2
        , env/0
        , env/2
        , withEnv/2
        ]).
-compile(no_auto_import).
withEnv() ->
  control_comonad_env_trans@ps:withEnvT().

runEnv() ->
  fun
    (V) ->
      runEnv(V)
  end.

runEnv(V) ->
  {tuple, erlang:element(2, V), erlang:element(3, V)}.

mapEnv() ->
  fun
    (F) ->
      fun
        (V) ->
          mapEnv(F, V)
      end
  end.

mapEnv(F, V) ->
  {tuple, erlang:element(2, V), F(erlang:element(3, V))}.

env() ->
  fun
    (E) ->
      fun
        (A) ->
          env(E, A)
      end
  end.

env(E, A) ->
  {tuple, E, A}.

withEnv(V, V@1) ->
  control_comonad_env_trans@ps:withEnvT(V, V@1).

