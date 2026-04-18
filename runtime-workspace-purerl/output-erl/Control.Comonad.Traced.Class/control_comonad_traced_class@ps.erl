-module(control_comonad_traced_class@ps).
-export([ track/0
        , track/1
        , tracks/0
        , tracks/3
        , listens/0
        , listens/3
        , listen/0
        , listen/2
        , comonadTracedTracedT/0
        , comonadTracedTracedT/1
        , censor/0
        , censor/3
        ]).
-compile(no_auto_import).
track() ->
  fun
    (Dict) ->
      track(Dict)
  end.

track(#{ track := Dict }) ->
  Dict.

tracks() ->
  fun
    (DictComonadTraced) ->
      fun
        (F) ->
          fun
            (W) ->
              tracks(DictComonadTraced, F, W)
          end
      end
  end.

tracks(#{ 'Comonad0' := DictComonadTraced, track := DictComonadTraced@1 }, F, W) ->
  (DictComonadTraced@1(F((erlang:map_get(extract, DictComonadTraced(undefined)))
                         (W))))
  (W).

listens() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (V) ->
              listens(DictFunctor, F, V)
          end
      end
  end.

listens(#{ map := DictFunctor }, F, V) ->
  (DictFunctor(fun
     (G) ->
       fun
         (T) ->
           {tuple, G(T), F(T)}
       end
   end))
  (V).

listen() ->
  fun
    (DictFunctor) ->
      fun
        (V) ->
          listen(DictFunctor, V)
      end
  end.

listen(#{ map := DictFunctor }, V) ->
  (DictFunctor(fun
     (F) ->
       fun
         (T) ->
           {tuple, F(T), T}
       end
   end))
  (V).

comonadTracedTracedT() ->
  fun
    (DictComonad) ->
      comonadTracedTracedT(DictComonad)
  end.

comonadTracedTracedT(DictComonad = #{ extract := DictComonad@1 }) ->
  begin
    ComonadTracedT = control_comonad_traced_trans@ps:comonadTracedT(DictComonad),
    fun
      (DictMonoid) ->
        begin
          ComonadTracedT1 = ComonadTracedT(DictMonoid),
          #{ track =>
             fun
               (T) ->
                 fun
                   (V) ->
                     (DictComonad@1(V))(T)
                 end
             end
           , 'Comonad0' =>
             fun
               (_) ->
                 ComonadTracedT1
             end
           }
        end
    end
  end.

censor() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (V) ->
              censor(DictFunctor, F, V)
          end
      end
  end.

censor(#{ map := DictFunctor }, F, V) ->
  (DictFunctor(fun
     (V1) ->
       fun
         (X) ->
           V1(F(X))
       end
   end))
  (V).

