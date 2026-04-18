-module(data_function@ps).
-export([ on/0
        , on/4
        , flip/0
        , flip/3
        , const/0
        , const/2
        , applyN/0
        , applyN/1
        , applyFlipped/0
        , applyFlipped/2
        , apply/0
        , apply/2
        ]).
-compile(no_auto_import).
on() ->
  fun
    (F) ->
      fun
        (G) ->
          fun
            (X) ->
              fun
                (Y) ->
                  on(F, G, X, Y)
              end
          end
      end
  end.

on(F, G, X, Y) ->
  (F(G(X)))(G(Y)).

flip() ->
  fun
    (F) ->
      fun
        (B) ->
          fun
            (A) ->
              flip(F, B, A)
          end
      end
  end.

flip(F, B, A) ->
  (F(A))(B).

const() ->
  fun
    (A) ->
      fun
        (V) ->
          const(A, V)
      end
  end.

const(A, _) ->
  A.

applyN() ->
  fun
    (F) ->
      applyN(F)
  end.

applyN(F) ->
  begin
    Go =
      fun
        Go (N, Acc) ->
          if
            N =< 0 ->
              Acc;
            true ->
              begin
                N@1 = N - 1,
                Acc@1 = F(Acc),
                Go(N@1, Acc@1)
              end
          end
      end,
    fun
      (N) ->
        fun
          (Acc) ->
            Go(N, Acc)
        end
    end
  end.

applyFlipped() ->
  fun
    (X) ->
      fun
        (F) ->
          applyFlipped(X, F)
      end
  end.

applyFlipped(X, F) ->
  F(X).

apply() ->
  fun
    (F) ->
      fun
        (X) ->
          apply(F, X)
      end
  end.

apply(F, X) ->
  F(X).

