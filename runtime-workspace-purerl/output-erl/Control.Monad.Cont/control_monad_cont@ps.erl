-module(control_monad_cont@ps).
-export([ withCont/0
        , withCont/3
        , runCont/0
        , runCont/2
        , mapCont/0
        , mapCont/3
        , cont/0
        , cont/2
        ]).
-compile(no_auto_import).
withCont() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (K) ->
              withCont(F, V, K)
          end
      end
  end.

withCont(F, V, K) ->
  V(F(fun
      (X) ->
        K(X)
    end)).

runCont() ->
  fun
    (Cc) ->
      fun
        (K) ->
          runCont(Cc, K)
      end
  end.

runCont(Cc, K) ->
  Cc(fun
    (X) ->
      K(X)
  end).

mapCont() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (K) ->
              mapCont(F, V, K)
          end
      end
  end.

mapCont(F, V, K) ->
  F(V(K)).

cont() ->
  fun
    (F) ->
      fun
        (C) ->
          cont(F, C)
      end
  end.

cont(F, C) ->
  F(fun
    (X) ->
      C(X)
  end).

