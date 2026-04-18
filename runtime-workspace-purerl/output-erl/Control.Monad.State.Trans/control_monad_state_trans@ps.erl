-module(control_monad_state_trans@ps).
-export([ 'StateT'/0
        , 'StateT'/1
        , withStateT/0
        , withStateT/3
        , runStateT/0
        , runStateT/1
        , newtypeStateT/0
        , monadTransStateT/0
        , mapStateT/0
        , mapStateT/3
        , lazyStateT/0
        , functorStateT/0
        , functorStateT/1
        , execStateT/0
        , execStateT/3
        , evalStateT/0
        , evalStateT/3
        , monadStateT/0
        , monadStateT/1
        , bindStateT/0
        , bindStateT/1
        , applyStateT/0
        , applyStateT/1
        , applicativeStateT/0
        , applicativeStateT/1
        , semigroupStateT/0
        , semigroupStateT/1
        , monadAskStateT/0
        , monadAskStateT/1
        , monadReaderStateT/0
        , monadReaderStateT/1
        , monadContStateT/0
        , monadContStateT/1
        , monadEffectState/0
        , monadEffectState/1
        , monadRecStateT/0
        , monadRecStateT/1
        , monadStateStateT/0
        , monadStateStateT/1
        , monadTellStateT/0
        , monadTellStateT/1
        , monadWriterStateT/0
        , monadWriterStateT/1
        , monadThrowStateT/0
        , monadThrowStateT/1
        , monadErrorStateT/0
        , monadErrorStateT/1
        , monoidStateT/0
        , monoidStateT/1
        , altStateT/0
        , altStateT/2
        , plusStateT/0
        , plusStateT/2
        , alternativeStateT/0
        , alternativeStateT/1
        , monadPlusStateT/0
        , monadPlusStateT/1
        , monadZeroStateT/0
        , monadZeroStateT/1
        ]).
-compile(no_auto_import).
'StateT'() ->
  fun
    (X) ->
      'StateT'(X)
  end.

'StateT'(X) ->
  X.

withStateT() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (X) ->
              withStateT(F, V, X)
          end
      end
  end.

withStateT(F, V, X) ->
  V(F(X)).

runStateT() ->
  fun
    (V) ->
      runStateT(V)
  end.

runStateT(V) ->
  V.

newtypeStateT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monadTransStateT() ->
  #{ lift =>
     fun
       (#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
         fun
           (M) ->
             fun
               (S) ->
                 ((erlang:map_get(bind, DictMonad@1(undefined)))(M))
                 (fun
                   (X) ->
                     (erlang:map_get(pure, DictMonad(undefined)))({tuple, X, S})
                 end)
             end
         end
     end
   }.

mapStateT() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (X) ->
              mapStateT(F, V, X)
          end
      end
  end.

mapStateT(F, V, X) ->
  F(V(X)).

lazyStateT() ->
  #{ defer =>
     fun
       (F) ->
         fun
           (S) ->
             (F(unit))(S)
         end
     end
   }.

functorStateT() ->
  fun
    (DictFunctor) ->
      functorStateT(DictFunctor)
  end.

functorStateT(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (S) ->
                 (DictFunctor(fun
                    (V1) ->
                      {tuple, F(erlang:element(2, V1)), erlang:element(3, V1)}
                  end))
                 (V(S))
             end
         end
     end
   }.

execStateT() ->
  fun
    (DictFunctor) ->
      fun
        (V) ->
          fun
            (S) ->
              execStateT(DictFunctor, V, S)
          end
      end
  end.

execStateT(#{ map := DictFunctor }, V, S) ->
  (DictFunctor(data_tuple@ps:snd()))(V(S)).

evalStateT() ->
  fun
    (DictFunctor) ->
      fun
        (V) ->
          fun
            (S) ->
              evalStateT(DictFunctor, V, S)
          end
      end
  end.

evalStateT(#{ map := DictFunctor }, V, S) ->
  (DictFunctor(data_tuple@ps:fst()))(V(S)).

monadStateT() ->
  fun
    (DictMonad) ->
      monadStateT(DictMonad)
  end.

monadStateT(DictMonad) ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeStateT(DictMonad)
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindStateT(DictMonad)
     end
   }.

bindStateT() ->
  fun
    (DictMonad) ->
      bindStateT(DictMonad)
  end.

bindStateT(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  #{ bind =>
     fun
       (V) ->
         fun
           (F) ->
             fun
               (S) ->
                 ((erlang:map_get(bind, DictMonad@1(undefined)))(V(S)))
                 (fun
                   (V1) ->
                     (F(erlang:element(2, V1)))(erlang:element(3, V1))
                 end)
             end
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyStateT(DictMonad)
     end
   }.

applyStateT() ->
  fun
    (DictMonad) ->
      applyStateT(DictMonad)
  end.

applyStateT(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    #{ map := V } =
      (erlang:map_get(
         'Functor0',
         (erlang:map_get('Apply0', DictMonad@1(undefined)))(undefined)
       ))
      (undefined),
    FunctorStateT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 fun
                   (S) ->
                     (V(fun
                        (V1) ->
                          { tuple
                          , F(erlang:element(2, V1))
                          , erlang:element(3, V1)
                          }
                      end))
                     (V@1(S))
                 end
             end
         end
       },
    #{ apply =>
       begin
         #{ bind := V@1 } = bindStateT(DictMonad),
         fun
           (F) ->
             fun
               (A) ->
                 (V@1(F))
                 (fun
                   (F_) ->
                     (V@1(A))
                     (fun
                       (A_) ->
                         (erlang:map_get(pure, applicativeStateT(DictMonad)))
                         (F_(A_))
                     end)
                 end)
             end
         end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorStateT1
       end
     }
  end.

applicativeStateT() ->
  fun
    (DictMonad) ->
      applicativeStateT(DictMonad)
  end.

applicativeStateT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  #{ pure =>
     fun
       (A) ->
         fun
           (S) ->
             (erlang:map_get(pure, DictMonad@1(undefined)))({tuple, A, S})
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyStateT(DictMonad)
     end
   }.

semigroupStateT() ->
  fun
    (DictMonad) ->
      semigroupStateT(DictMonad)
  end.

semigroupStateT(DictMonad) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = applyStateT(DictMonad),
    fun
      (#{ append := DictSemigroup }) ->
        #{ append =>
           fun
             (A) ->
               fun
                 (B) ->
                   (V@1(((erlang:map_get(map, V(undefined)))(DictSemigroup))(A)))
                   (B)
               end
           end
         }
    end
  end.

monadAskStateT() ->
  fun
    (DictMonadAsk) ->
      monadAskStateT(DictMonadAsk)
  end.

monadAskStateT(#{ 'Monad0' := DictMonadAsk, ask := DictMonadAsk@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadAsk(undefined),
    MonadStateT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeStateT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindStateT(Monad0)
         end
       },
    #{ ask =>
       fun
         (S) ->
           ((erlang:map_get(bind, Monad0@2(undefined)))(DictMonadAsk@1))
           (fun
             (X) ->
               (erlang:map_get(pure, Monad0@1(undefined)))({tuple, X, S})
           end)
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadStateT1
       end
     }
  end.

monadReaderStateT() ->
  fun
    (DictMonadReader) ->
      monadReaderStateT(DictMonadReader)
  end.

monadReaderStateT(#{ 'MonadAsk0' := DictMonadReader
                   , local := DictMonadReader@1
                   }) ->
  begin
    MonadAskStateT1 = monadAskStateT(DictMonadReader(undefined)),
    #{ local =>
       fun
         (X) ->
           begin
             V = DictMonadReader@1(X),
             fun
               (V@1) ->
                 fun
                   (X@1) ->
                     V(V@1(X@1))
                 end
             end
           end
       end
     , 'MonadAsk0' =>
       fun
         (_) ->
           MonadAskStateT1
       end
     }
  end.

monadContStateT() ->
  fun
    (DictMonadCont) ->
      monadContStateT(DictMonadCont)
  end.

monadContStateT(#{ 'Monad0' := DictMonadCont, callCC := DictMonadCont@1 }) ->
  begin
    V = DictMonadCont(undefined),
    MonadStateT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeStateT(V)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindStateT(V)
         end
       },
    #{ callCC =>
       fun
         (F) ->
           fun
             (S) ->
               DictMonadCont@1(fun
                 (C) ->
                   (F(fun
                      (A) ->
                        fun
                          (S_) ->
                            C({tuple, A, S_})
                        end
                    end))
                   (S)
               end)
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadStateT1
       end
     }
  end.

monadEffectState() ->
  fun
    (DictMonadEffect) ->
      monadEffectState(DictMonadEffect)
  end.

monadEffectState(#{ 'Monad0' := DictMonadEffect
                  , liftEffect := DictMonadEffect@1
                  }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadEffect(undefined),
    MonadStateT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeStateT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindStateT(Monad0)
         end
       },
    #{ liftEffect =>
       fun
         (X) ->
           begin
             V = DictMonadEffect@1(X),
             fun
               (S) ->
                 ((erlang:map_get(bind, Monad0@2(undefined)))(V))
                 (fun
                   (X@1) ->
                     (erlang:map_get(pure, Monad0@1(undefined)))
                     ({tuple, X@1, S})
                 end)
             end
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadStateT1
       end
     }
  end.

monadRecStateT() ->
  fun
    (DictMonadRec) ->
      monadRecStateT(DictMonadRec)
  end.

monadRecStateT(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadRec(undefined),
    MonadStateT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeStateT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindStateT(Monad0)
         end
       },
    #{ tailRecM =>
       fun
         (F) ->
           fun
             (A) ->
               fun
                 (S) ->
                   (DictMonadRec@1(fun
                      (V) ->
                        ((erlang:map_get(bind, Monad0@2(undefined)))
                         ((F(erlang:element(2, V)))(erlang:element(3, V))))
                        (fun
                          (V2) ->
                            (erlang:map_get(pure, Monad0@1(undefined)))
                            (case erlang:element(2, V2) of
                              {loop, _} ->
                                { loop
                                , { tuple
                                  , erlang:element(2, erlang:element(2, V2))
                                  , erlang:element(3, V2)
                                  }
                                };
                              {done, _} ->
                                { done
                                , { tuple
                                  , erlang:element(2, erlang:element(2, V2))
                                  , erlang:element(3, V2)
                                  }
                                };
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end)
                        end)
                    end))
                   ({tuple, A, S})
               end
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadStateT1
       end
     }
  end.

monadStateStateT() ->
  fun
    (DictMonad) ->
      monadStateStateT(DictMonad)
  end.

monadStateStateT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    MonadStateT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeStateT(DictMonad)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindStateT(DictMonad)
         end
       },
    #{ state =>
       fun
         (F) ->
           fun
             (X) ->
               (erlang:map_get(pure, DictMonad@1(undefined)))(F(X))
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadStateT1
       end
     }
  end.

monadTellStateT() ->
  fun
    (DictMonadTell) ->
      monadTellStateT(DictMonadTell)
  end.

monadTellStateT(#{ 'Monad1' := DictMonadTell
                 , 'Semigroup0' := DictMonadTell@1
                 , tell := DictMonadTell@2
                 }) ->
  begin
    Monad1 = #{ 'Applicative0' := Monad1@1, 'Bind1' := Monad1@2 } =
      DictMonadTell(undefined),
    Semigroup0 = DictMonadTell@1(undefined),
    MonadStateT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeStateT(Monad1)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindStateT(Monad1)
         end
       },
    #{ tell =>
       fun
         (X) ->
           begin
             V = DictMonadTell@2(X),
             fun
               (S) ->
                 ((erlang:map_get(bind, Monad1@2(undefined)))(V))
                 (fun
                   (X@1) ->
                     (erlang:map_get(pure, Monad1@1(undefined)))
                     ({tuple, X@1, S})
                 end)
             end
           end
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           Semigroup0
       end
     , 'Monad1' =>
       fun
         (_) ->
           MonadStateT1
       end
     }
  end.

monadWriterStateT() ->
  fun
    (DictMonadWriter) ->
      monadWriterStateT(DictMonadWriter)
  end.

monadWriterStateT(#{ 'MonadTell1' := DictMonadWriter
                   , 'Monoid0' := DictMonadWriter@1
                   , listen := DictMonadWriter@2
                   , pass := DictMonadWriter@3
                   }) ->
  begin
    MonadTell1 = #{ 'Monad1' := MonadTell1@1 } = DictMonadWriter(undefined),
    #{ 'Applicative0' := Monad1, 'Bind1' := Monad1@1 } = MonadTell1@1(undefined),
    #{ bind := V } = Monad1@1(undefined),
    #{ pure := V@1 } = Monad1(undefined),
    Monoid0 = DictMonadWriter@1(undefined),
    MonadTellStateT1 = monadTellStateT(MonadTell1),
    #{ listen =>
       fun
         (M) ->
           fun
             (S) ->
               (V(DictMonadWriter@2(M(S))))
               (fun
                 (V@2) ->
                   V@1({ tuple
                       , { tuple
                         , erlang:element(2, erlang:element(2, V@2))
                         , erlang:element(3, V@2)
                         }
                       , erlang:element(3, erlang:element(2, V@2))
                       })
               end)
           end
       end
     , pass =>
       fun
         (M) ->
           fun
             (S) ->
               DictMonadWriter@3((V(M(S)))
                                 (fun
                                   (V@2) ->
                                     V@1({ tuple
                                         , { tuple
                                           , erlang:element(
                                               2,
                                               erlang:element(2, V@2)
                                             )
                                           , erlang:element(3, V@2)
                                           }
                                         , erlang:element(
                                             3,
                                             erlang:element(2, V@2)
                                           )
                                         })
                                 end))
           end
       end
     , 'Monoid0' =>
       fun
         (_) ->
           Monoid0
       end
     , 'MonadTell1' =>
       fun
         (_) ->
           MonadTellStateT1
       end
     }
  end.

monadThrowStateT() ->
  fun
    (DictMonadThrow) ->
      monadThrowStateT(DictMonadThrow)
  end.

monadThrowStateT(#{ 'Monad0' := DictMonadThrow, throwError := DictMonadThrow@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadThrow(undefined),
    MonadStateT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeStateT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindStateT(Monad0)
         end
       },
    #{ throwError =>
       fun
         (E) ->
           begin
             V = DictMonadThrow@1(E),
             fun
               (S) ->
                 ((erlang:map_get(bind, Monad0@2(undefined)))(V))
                 (fun
                   (X) ->
                     (erlang:map_get(pure, Monad0@1(undefined)))({tuple, X, S})
                 end)
             end
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadStateT1
       end
     }
  end.

monadErrorStateT() ->
  fun
    (DictMonadError) ->
      monadErrorStateT(DictMonadError)
  end.

monadErrorStateT(#{ 'MonadThrow0' := DictMonadError
                  , catchError := DictMonadError@1
                  }) ->
  begin
    MonadThrowStateT1 = monadThrowStateT(DictMonadError(undefined)),
    #{ catchError =>
       fun
         (V) ->
           fun
             (H) ->
               fun
                 (S) ->
                   (DictMonadError@1(V(S)))
                   (fun
                     (E) ->
                       (H(E))(S)
                   end)
               end
           end
       end
     , 'MonadThrow0' =>
       fun
         (_) ->
           MonadThrowStateT1
       end
     }
  end.

monoidStateT() ->
  fun
    (DictMonad) ->
      monoidStateT(DictMonad)
  end.

monoidStateT(DictMonad) ->
  begin
    SemigroupStateT1 = semigroupStateT(DictMonad),
    fun
      (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
        begin
          SemigroupStateT2 = SemigroupStateT1(DictMonoid(undefined)),
          #{ mempty =>
             (erlang:map_get(pure, applicativeStateT(DictMonad)))(DictMonoid@1)
           , 'Semigroup0' =>
             fun
               (_) ->
                 SemigroupStateT2
             end
           }
        end
    end
  end.

altStateT() ->
  fun
    (DictMonad) ->
      fun
        (DictAlt) ->
          altStateT(DictMonad, DictAlt)
      end
  end.

altStateT(_, #{ 'Functor0' := DictAlt, alt := DictAlt@1 }) ->
  begin
    #{ map := V } = DictAlt(undefined),
    FunctorStateT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 fun
                   (S) ->
                     (V(fun
                        (V1) ->
                          { tuple
                          , F(erlang:element(2, V1))
                          , erlang:element(3, V1)
                          }
                      end))
                     (V@1(S))
                 end
             end
         end
       },
    #{ alt =>
       fun
         (V@1) ->
           fun
             (V1) ->
               fun
                 (S) ->
                   (DictAlt@1(V@1(S)))(V1(S))
               end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorStateT1
       end
     }
  end.

plusStateT() ->
  fun
    (DictMonad) ->
      fun
        (DictPlus) ->
          plusStateT(DictMonad, DictPlus)
      end
  end.

plusStateT(_, #{ 'Alt0' := DictPlus, empty := DictPlus@1 }) ->
  begin
    #{ 'Functor0' := V, alt := V@1 } = DictPlus(undefined),
    #{ map := V@2 } = V(undefined),
    AltStateT2 =
      begin
        FunctorStateT1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@3) ->
                     fun
                       (S) ->
                         (V@2(fun
                            (V1) ->
                              { tuple
                              , F(erlang:element(2, V1))
                              , erlang:element(3, V1)
                              }
                          end))
                         (V@3(S))
                     end
                 end
             end
           },
        #{ alt =>
           fun
             (V@3) ->
               fun
                 (V1) ->
                   fun
                     (S) ->
                       (V@1(V@3(S)))(V1(S))
                   end
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorStateT1
           end
         }
      end,
    #{ empty =>
       fun
         (_) ->
           DictPlus@1
       end
     , 'Alt0' =>
       fun
         (_) ->
           AltStateT2
       end
     }
  end.

alternativeStateT() ->
  fun
    (DictMonad) ->
      alternativeStateT(DictMonad)
  end.

alternativeStateT(DictMonad) ->
  begin
    ApplicativeStateT1 = applicativeStateT(DictMonad),
    fun
      (#{ 'Plus1' := DictAlternative }) ->
        begin
          #{ 'Alt0' := V, empty := V@1 } = DictAlternative(undefined),
          PlusStateT2 =
            begin
              #{ 'Functor0' := V@2, alt := V@3 } = V(undefined),
              #{ map := V@4 } = V@2(undefined),
              FunctorStateT1 =
                #{ map =>
                   fun
                     (F) ->
                       fun
                         (V@5) ->
                           fun
                             (S) ->
                               (V@4(fun
                                  (V1) ->
                                    { tuple
                                    , F(erlang:element(2, V1))
                                    , erlang:element(3, V1)
                                    }
                                end))
                               (V@5(S))
                           end
                       end
                   end
                 },
              AltStateT2 =
                #{ alt =>
                   fun
                     (V@5) ->
                       fun
                         (V1) ->
                           fun
                             (S) ->
                               (V@3(V@5(S)))(V1(S))
                           end
                       end
                   end
                 , 'Functor0' =>
                   fun
                     (_) ->
                       FunctorStateT1
                   end
                 },
              #{ empty =>
                 fun
                   (_) ->
                     V@1
                 end
               , 'Alt0' =>
                 fun
                   (_) ->
                     AltStateT2
                 end
               }
            end,
          #{ 'Applicative0' =>
             fun
               (_) ->
                 ApplicativeStateT1
             end
           , 'Plus1' =>
             fun
               (_) ->
                 PlusStateT2
             end
           }
        end
    end
  end.

monadPlusStateT() ->
  fun
    (DictMonadPlus) ->
      monadPlusStateT(DictMonadPlus)
  end.

monadPlusStateT(#{ 'Alternative1' := DictMonadPlus
                 , 'Monad0' := DictMonadPlus@1
                 }) ->
  begin
    Monad0 = DictMonadPlus@1(undefined),
    MonadStateT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeStateT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindStateT(Monad0)
         end
       },
    AlternativeStateT1 = (alternativeStateT(Monad0))(DictMonadPlus(undefined)),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadStateT1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeStateT1
       end
     }
  end.

monadZeroStateT() ->
  fun
    (DictMonadZero) ->
      monadZeroStateT(DictMonadZero)
  end.

monadZeroStateT(#{ 'Alternative1' := DictMonadZero
                 , 'Monad0' := DictMonadZero@1
                 }) ->
  begin
    Monad0 = DictMonadZero@1(undefined),
    MonadStateT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeStateT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindStateT(Monad0)
         end
       },
    AlternativeStateT1 = (alternativeStateT(Monad0))(DictMonadZero(undefined)),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadStateT1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeStateT1
       end
     , 'MonadZeroIsDeprecated2' =>
       fun
         (_) ->
           undefined
       end
     }
  end.

