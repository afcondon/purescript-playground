-module(control_comonad_store_class@ps).
-export([ pos/0
        , pos/1
        , peek/0
        , peek/1
        , peeks/0
        , peeks/3
        , seeks/0
        , seeks/1
        , seek/0
        , seek/1
        , experiment/0
        , experiment/4
        , comonadStoreTracedT/0
        , comonadStoreTracedT/1
        , comonadStoreStoreT/0
        , comonadStoreStoreT/1
        , comonadStoreEnvT/0
        , comonadStoreEnvT/1
        ]).
-compile(no_auto_import).
pos() ->
  fun
    (Dict) ->
      pos(Dict)
  end.

pos(#{ pos := Dict }) ->
  Dict.

peek() ->
  fun
    (Dict) ->
      peek(Dict)
  end.

peek(#{ peek := Dict }) ->
  Dict.

peeks() ->
  fun
    (DictComonadStore) ->
      fun
        (F) ->
          fun
            (X) ->
              peeks(DictComonadStore, F, X)
          end
      end
  end.

peeks(#{ peek := DictComonadStore, pos := DictComonadStore@1 }, F, X) ->
  (DictComonadStore(F(DictComonadStore@1(X))))(X).

seeks() ->
  fun
    (DictComonadStore) ->
      seeks(DictComonadStore)
  end.

seeks(#{ 'Comonad0' := DictComonadStore
       , peek := DictComonadStore@1
       , pos := DictComonadStore@2
       }) ->
  begin
    Duplicate =
      (erlang:map_get(
         extend,
         (erlang:map_get('Extend0', DictComonadStore(undefined)))(undefined)
       ))
      (control_extend@ps:identity()),
    fun
      (F) ->
        fun
          (X) ->
            begin
              V = Duplicate(X),
              (DictComonadStore@1(F(DictComonadStore@2(V))))(V)
            end
        end
    end
  end.

seek() ->
  fun
    (DictComonadStore) ->
      seek(DictComonadStore)
  end.

seek(#{ 'Comonad0' := DictComonadStore, peek := DictComonadStore@1 }) ->
  begin
    Duplicate =
      (erlang:map_get(
         extend,
         (erlang:map_get('Extend0', DictComonadStore(undefined)))(undefined)
       ))
      (control_extend@ps:identity()),
    fun
      (S) ->
        begin
          V = DictComonadStore@1(S),
          fun
            (X) ->
              V(Duplicate(X))
          end
        end
    end
  end.

experiment() ->
  fun
    (DictComonadStore) ->
      fun
        (DictFunctor) ->
          fun
            (F) ->
              fun
                (X) ->
                  experiment(DictComonadStore, DictFunctor, F, X)
              end
          end
      end
  end.

experiment( #{ peek := DictComonadStore, pos := DictComonadStore@1 }
          , #{ map := DictFunctor }
          , F
          , X
          ) ->
  (DictFunctor(fun
     (A) ->
       (DictComonadStore(A))(X)
   end))
  (F(DictComonadStore@1(X))).

comonadStoreTracedT() ->
  fun
    (DictComonadStore) ->
      comonadStoreTracedT(DictComonadStore)
  end.

comonadStoreTracedT(#{ 'Comonad0' := DictComonadStore
                     , peek := DictComonadStore@1
                     , pos := DictComonadStore@2
                     }) ->
  begin
    Comonad0 = #{ 'Extend0' := Comonad0@1 } = DictComonadStore(undefined),
    ComonadTracedT = control_comonad_traced_trans@ps:comonadTracedT(Comonad0),
    fun
      (DictMonoid = #{ mempty := DictMonoid@1 }) ->
        begin
          Lower1 =
            fun
              (V) ->
                ((erlang:map_get(
                    map,
                    (erlang:map_get('Functor0', Comonad0@1(undefined)))
                    (undefined)
                  ))
                 (fun
                   (F) ->
                     F(DictMonoid@1)
                 end))
                (V)
            end,
          ComonadTracedT1 = ComonadTracedT(DictMonoid),
          #{ pos =>
             fun
               (X) ->
                 DictComonadStore@2(Lower1(X))
             end
           , peek =>
             fun
               (S) ->
                 begin
                   V = DictComonadStore@1(S),
                   fun
                     (X) ->
                       V(Lower1(X))
                   end
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

comonadStoreStoreT() ->
  fun
    (DictComonad) ->
      comonadStoreStoreT(DictComonad)
  end.

comonadStoreStoreT(DictComonad = #{ extract := DictComonad@1 }) ->
  begin
    ComonadStoreT = control_comonad_store_trans@ps:comonadStoreT(DictComonad),
    #{ pos =>
       fun
         (V) ->
           erlang:element(3, V)
       end
     , peek =>
       fun
         (S) ->
           fun
             (V) ->
               (DictComonad@1(erlang:element(2, V)))(S)
           end
       end
     , 'Comonad0' =>
       fun
         (_) ->
           ComonadStoreT
       end
     }
  end.

comonadStoreEnvT() ->
  fun
    (DictComonadStore) ->
      comonadStoreEnvT(DictComonadStore)
  end.

comonadStoreEnvT(#{ 'Comonad0' := DictComonadStore
                  , peek := DictComonadStore@1
                  , pos := DictComonadStore@2
                  }) ->
  begin
    ComonadEnvT =
      control_comonad_env_trans@ps:comonadEnvT(DictComonadStore(undefined)),
    #{ pos =>
       fun
         (X) ->
           DictComonadStore@2(erlang:element(3, X))
       end
     , peek =>
       fun
         (S) ->
           begin
             V = DictComonadStore@1(S),
             fun
               (X) ->
                 V(erlang:element(3, X))
             end
           end
       end
     , 'Comonad0' =>
       fun
         (_) ->
           ComonadEnvT
       end
     }
  end.

