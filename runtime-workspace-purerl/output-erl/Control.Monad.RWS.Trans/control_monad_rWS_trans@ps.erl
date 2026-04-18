-module(control_monad_rWS_trans@ps).
-export([ 'RWSResult'/0
        , 'RWST'/0
        , 'RWST'/1
        , withRWST/0
        , withRWST/4
        , runRWST/0
        , runRWST/1
        , newtypeRWST/0
        , monadTransRWST/0
        , monadTransRWST/1
        , mapRWST/0
        , mapRWST/4
        , lazyRWST/0
        , functorRWST/0
        , functorRWST/1
        , execRWST/0
        , execRWST/4
        , evalRWST/0
        , evalRWST/4
        , applyRWST/0
        , applyRWST/1
        , bindRWST/0
        , bindRWST/1
        , semigroupRWST/0
        , semigroupRWST/1
        , applicativeRWST/0
        , applicativeRWST/1
        , monadRWST/0
        , monadRWST/1
        , monadAskRWST/0
        , monadAskRWST/1
        , monadReaderRWST/0
        , monadReaderRWST/1
        , monadEffectRWS/0
        , monadEffectRWS/1
        , monadRecRWST/0
        , monadRecRWST/1
        , monadStateRWST/0
        , monadStateRWST/1
        , monadTellRWST/0
        , monadTellRWST/1
        , monadWriterRWST/0
        , monadWriterRWST/1
        , monadThrowRWST/0
        , monadThrowRWST/1
        , monadErrorRWST/0
        , monadErrorRWST/1
        , monoidRWST/0
        , monoidRWST/1
        , altRWST/0
        , altRWST/1
        , plusRWST/0
        , plusRWST/1
        , alternativeRWST/0
        , alternativeRWST/2
        ]).
-compile(no_auto_import).
'RWSResult'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              {rWSResult, Value0, Value1, Value2}
          end
      end
  end.

'RWST'() ->
  fun
    (X) ->
      'RWST'(X)
  end.

'RWST'(X) ->
  X.

withRWST() ->
  fun
    (F) ->
      fun
        (M) ->
          fun
            (R) ->
              fun
                (S) ->
                  withRWST(F, M, R, S)
              end
          end
      end
  end.

withRWST(F, M, R, S) ->
  begin
    V = (F(R))(S),
    (M(erlang:element(2, V)))(erlang:element(3, V))
  end.

runRWST() ->
  fun
    (V) ->
      runRWST(V)
  end.

runRWST(V) ->
  V.

newtypeRWST() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monadTransRWST() ->
  fun
    (DictMonoid) ->
      monadTransRWST(DictMonoid)
  end.

monadTransRWST(#{ mempty := DictMonoid }) ->
  #{ lift =>
     fun
       (#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
         fun
           (M) ->
             fun
               (_) ->
                 fun
                   (S) ->
                     ((erlang:map_get(bind, DictMonad@1(undefined)))(M))
                     (fun
                       (A) ->
                         (erlang:map_get(pure, DictMonad(undefined)))
                         ({rWSResult, S, A, DictMonoid})
                     end)
                 end
             end
         end
     end
   }.

mapRWST() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (R) ->
              fun
                (S) ->
                  mapRWST(F, V, R, S)
              end
          end
      end
  end.

mapRWST(F, V, R, S) ->
  F((V(R))(S)).

lazyRWST() ->
  #{ defer =>
     fun
       (F) ->
         fun
           (R) ->
             fun
               (S) ->
                 ((F(unit))(R))(S)
             end
         end
     end
   }.

functorRWST() ->
  fun
    (DictFunctor) ->
      functorRWST(DictFunctor)
  end.

functorRWST(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (R) ->
                 fun
                   (S) ->
                     (DictFunctor(fun
                        (V1) ->
                          { rWSResult
                          , erlang:element(2, V1)
                          , F(erlang:element(3, V1))
                          , erlang:element(4, V1)
                          }
                      end))
                     ((V(R))(S))
                 end
             end
         end
     end
   }.

execRWST() ->
  fun
    (DictMonad) ->
      fun
        (V) ->
          fun
            (R) ->
              fun
                (S) ->
                  execRWST(DictMonad, V, R, S)
              end
          end
      end
  end.

execRWST(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }, V, R, S) ->
  ((erlang:map_get(bind, DictMonad@1(undefined)))((V(R))(S)))
  (fun
    (V1) ->
      (erlang:map_get(pure, DictMonad(undefined)))
      ({tuple, erlang:element(2, V1), erlang:element(4, V1)})
  end).

evalRWST() ->
  fun
    (DictMonad) ->
      fun
        (V) ->
          fun
            (R) ->
              fun
                (S) ->
                  evalRWST(DictMonad, V, R, S)
              end
          end
      end
  end.

evalRWST(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }, V, R, S) ->
  ((erlang:map_get(bind, DictMonad@1(undefined)))((V(R))(S)))
  (fun
    (V1) ->
      (erlang:map_get(pure, DictMonad(undefined)))
      ({tuple, erlang:element(3, V1), erlang:element(4, V1)})
  end).

applyRWST() ->
  fun
    (DictBind) ->
      applyRWST(DictBind)
  end.

applyRWST(#{ 'Apply0' := DictBind, bind := DictBind@1 }) ->
  begin
    #{ map := Functor0 } =
      (erlang:map_get('Functor0', DictBind(undefined)))(undefined),
    FunctorRWST1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V) ->
                 fun
                   (R) ->
                     fun
                       (S) ->
                         (Functor0(fun
                            (V1) ->
                              { rWSResult
                              , erlang:element(2, V1)
                              , F(erlang:element(3, V1))
                              , erlang:element(4, V1)
                              }
                          end))
                         ((V(R))(S))
                     end
                 end
             end
         end
       },
    fun
      (#{ 'Semigroup0' := DictMonoid }) ->
        #{ apply =>
           fun
             (V) ->
               fun
                 (V1) ->
                   fun
                     (R) ->
                       fun
                         (S) ->
                           (DictBind@1((V(R))(S)))
                           (fun
                             (V2) ->
                               begin
                                 V@1 = erlang:element(4, V2),
                                 (Functor0(fun
                                    (V3) ->
                                      { rWSResult
                                      , erlang:element(2, V3)
                                      , (erlang:element(3, V2))
                                        (erlang:element(3, V3))
                                      , ((erlang:map_get(
                                            append,
                                            DictMonoid(undefined)
                                          ))
                                         (V@1))
                                        (erlang:element(4, V3))
                                      }
                                  end))
                                 ((V1(R))(erlang:element(2, V2)))
                               end
                           end)
                       end
                   end
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorRWST1
           end
         }
    end
  end.

bindRWST() ->
  fun
    (DictBind) ->
      bindRWST(DictBind)
  end.

bindRWST(DictBind = #{ 'Apply0' := DictBind@1, bind := DictBind@2 }) ->
  begin
    #{ map := V } =
      (erlang:map_get('Functor0', DictBind@1(undefined)))(undefined),
    ApplyRWST1 = applyRWST(DictBind),
    fun
      (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
        begin
          ApplyRWST2 = ApplyRWST1(DictMonoid),
          #{ bind =>
             fun
               (V@1) ->
                 fun
                   (F) ->
                     fun
                       (R) ->
                         fun
                           (S) ->
                             (DictBind@2((V@1(R))(S)))
                             (fun
                               (V1) ->
                                 begin
                                   V@2 = erlang:element(4, V1),
                                   (V(fun
                                      (V3) ->
                                        { rWSResult
                                        , erlang:element(2, V3)
                                        , erlang:element(3, V3)
                                        , ((erlang:map_get(
                                              append,
                                              DictMonoid@1(undefined)
                                            ))
                                           (V@2))
                                          (erlang:element(4, V3))
                                        }
                                    end))
                                   (((F(erlang:element(3, V1)))(R))
                                    (erlang:element(2, V1)))
                                 end
                             end)
                         end
                     end
                 end
             end
           , 'Apply0' =>
             fun
               (_) ->
                 ApplyRWST2
             end
           }
        end
    end
  end.

semigroupRWST() ->
  fun
    (DictBind) ->
      semigroupRWST(DictBind)
  end.

semigroupRWST(DictBind) ->
  begin
    ApplyRWST1 = applyRWST(DictBind),
    fun
      (DictMonoid) ->
        begin
          #{ 'Functor0' := V, apply := V@1 } = ApplyRWST1(DictMonoid),
          fun
            (#{ append := DictSemigroup }) ->
              #{ append =>
                 fun
                   (A) ->
                     fun
                       (B) ->
                         (V@1(((erlang:map_get(map, V(undefined)))
                               (DictSemigroup))
                              (A)))
                         (B)
                     end
                 end
               }
          end
        end
    end
  end.

applicativeRWST() ->
  fun
    (DictMonad) ->
      applicativeRWST(DictMonad)
  end.

applicativeRWST(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
  begin
    ApplyRWST1 = applyRWST(DictMonad@1(undefined)),
    fun
      (DictMonoid = #{ mempty := DictMonoid@1 }) ->
        begin
          ApplyRWST2 = ApplyRWST1(DictMonoid),
          #{ pure =>
             fun
               (A) ->
                 fun
                   (_) ->
                     fun
                       (S) ->
                         (erlang:map_get(pure, DictMonad(undefined)))
                         ({rWSResult, S, A, DictMonoid@1})
                     end
                 end
             end
           , 'Apply0' =>
             fun
               (_) ->
                 ApplyRWST2
             end
           }
        end
    end
  end.

monadRWST() ->
  fun
    (DictMonad) ->
      monadRWST(DictMonad)
  end.

monadRWST(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    ApplicativeRWST1 = applicativeRWST(DictMonad),
    BindRWST1 = bindRWST(DictMonad@1(undefined)),
    fun
      (DictMonoid) ->
        begin
          ApplicativeRWST2 = ApplicativeRWST1(DictMonoid),
          BindRWST2 = BindRWST1(DictMonoid),
          #{ 'Applicative0' =>
             fun
               (_) ->
                 ApplicativeRWST2
             end
           , 'Bind1' =>
             fun
               (_) ->
                 BindRWST2
             end
           }
        end
    end
  end.

monadAskRWST() ->
  fun
    (DictMonad) ->
      monadAskRWST(DictMonad)
  end.

monadAskRWST(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    MonadRWST1 = monadRWST(DictMonad),
    fun
      (DictMonoid = #{ mempty := DictMonoid@1 }) ->
        begin
          MonadRWST2 = MonadRWST1(DictMonoid),
          #{ ask =>
             fun
               (R) ->
                 fun
                   (S) ->
                     (erlang:map_get(pure, DictMonad@1(undefined)))
                     ({rWSResult, S, R, DictMonoid@1})
                 end
             end
           , 'Monad0' =>
             fun
               (_) ->
                 MonadRWST2
             end
           }
        end
    end
  end.

monadReaderRWST() ->
  fun
    (DictMonad) ->
      monadReaderRWST(DictMonad)
  end.

monadReaderRWST(DictMonad) ->
  begin
    MonadAskRWST1 = monadAskRWST(DictMonad),
    fun
      (DictMonoid) ->
        begin
          MonadAskRWST2 = MonadAskRWST1(DictMonoid),
          #{ local =>
             fun
               (F) ->
                 fun
                   (M) ->
                     fun
                       (R) ->
                         fun
                           (S) ->
                             (M(F(R)))(S)
                         end
                     end
                 end
             end
           , 'MonadAsk0' =>
             fun
               (_) ->
                 MonadAskRWST2
             end
           }
        end
    end
  end.

monadEffectRWS() ->
  fun
    (DictMonoid) ->
      monadEffectRWS(DictMonoid)
  end.

monadEffectRWS(DictMonoid = #{ mempty := DictMonoid@1 }) ->
  fun
    (#{ 'Monad0' := DictMonadEffect, liftEffect := DictMonadEffect@1 }) ->
      begin
        Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
          DictMonadEffect(undefined),
        MonadRWST1 = (monadRWST(Monad0))(DictMonoid),
        #{ liftEffect =>
           fun
             (X) ->
               begin
                 V = DictMonadEffect@1(X),
                 fun
                   (_) ->
                     fun
                       (S) ->
                         ((erlang:map_get(bind, Monad0@2(undefined)))(V))
                         (fun
                           (A) ->
                             (erlang:map_get(pure, Monad0@1(undefined)))
                             ({rWSResult, S, A, DictMonoid@1})
                         end)
                     end
                 end
               end
           end
         , 'Monad0' =>
           fun
             (_) ->
               MonadRWST1
           end
         }
      end
  end.

monadRecRWST() ->
  fun
    (DictMonadRec) ->
      monadRecRWST(DictMonadRec)
  end.

monadRecRWST(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadRec(undefined),
    MonadRWST1 = monadRWST(Monad0),
    fun
      (DictMonoid = #{ 'Semigroup0' := DictMonoid@1, mempty := DictMonoid@2 }) ->
        begin
          #{ append := V } = DictMonoid@1(undefined),
          MonadRWST2 = MonadRWST1(DictMonoid),
          #{ tailRecM =>
             fun
               (K) ->
                 fun
                   (A) ->
                     fun
                       (R) ->
                         fun
                           (S) ->
                             (DictMonadRec@1(fun
                                (V@1) ->
                                  begin
                                    V@2 = erlang:element(4, V@1),
                                    ((erlang:map_get(bind, Monad0@2(undefined)))
                                     (((K(erlang:element(3, V@1)))(R))
                                      (erlang:element(2, V@1))))
                                    (fun
                                      (V2) ->
                                        (erlang:map_get(
                                           pure,
                                           Monad0@1(undefined)
                                         ))
                                        (case erlang:element(3, V2) of
                                          {loop, _} ->
                                            { loop
                                            , { rWSResult
                                              , erlang:element(2, V2)
                                              , erlang:element(
                                                  2,
                                                  erlang:element(3, V2)
                                                )
                                              , (V(V@2))(erlang:element(4, V2))
                                              }
                                            };
                                          {done, _} ->
                                            { done
                                            , { rWSResult
                                              , erlang:element(2, V2)
                                              , erlang:element(
                                                  2,
                                                  erlang:element(3, V2)
                                                )
                                              , (V(V@2))(erlang:element(4, V2))
                                              }
                                            };
                                          _ ->
                                            erlang:error({ fail
                                                         , <<
                                                             "Failed pattern match"
                                                           >>
                                                         })
                                        end)
                                    end)
                                  end
                              end))
                             ({rWSResult, S, A, DictMonoid@2})
                         end
                     end
                 end
             end
           , 'Monad0' =>
             fun
               (_) ->
                 MonadRWST2
             end
           }
        end
    end
  end.

monadStateRWST() ->
  fun
    (DictMonad) ->
      monadStateRWST(DictMonad)
  end.

monadStateRWST(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    MonadRWST1 = monadRWST(DictMonad),
    fun
      (DictMonoid = #{ mempty := DictMonoid@1 }) ->
        begin
          MonadRWST2 = MonadRWST1(DictMonoid),
          #{ state =>
             fun
               (F) ->
                 fun
                   (_) ->
                     fun
                       (S) ->
                         begin
                           V1 = F(S),
                           (erlang:map_get(pure, DictMonad@1(undefined)))
                           ({ rWSResult
                            , erlang:element(3, V1)
                            , erlang:element(2, V1)
                            , DictMonoid@1
                            })
                         end
                     end
                 end
             end
           , 'Monad0' =>
             fun
               (_) ->
                 MonadRWST2
             end
           }
        end
    end
  end.

monadTellRWST() ->
  fun
    (DictMonad) ->
      monadTellRWST(DictMonad)
  end.

monadTellRWST(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    MonadRWST1 = monadRWST(DictMonad),
    fun
      (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
        begin
          Semigroup0 = DictMonoid@1(undefined),
          MonadRWST2 = MonadRWST1(DictMonoid),
          #{ tell =>
             fun
               (W) ->
                 fun
                   (_) ->
                     fun
                       (S) ->
                         (erlang:map_get(pure, DictMonad@1(undefined)))
                         ({rWSResult, S, unit, W})
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
                 MonadRWST2
             end
           }
        end
    end
  end.

monadWriterRWST() ->
  fun
    (DictMonad) ->
      monadWriterRWST(DictMonad)
  end.

monadWriterRWST(DictMonad = #{ 'Applicative0' := DictMonad@1
                             , 'Bind1' := DictMonad@2
                             }) ->
  begin
    #{ bind := V } = DictMonad@2(undefined),
    #{ pure := V@1 } = DictMonad@1(undefined),
    MonadTellRWST1 = monadTellRWST(DictMonad),
    fun
      (DictMonoid) ->
        begin
          MonadTellRWST2 = MonadTellRWST1(DictMonoid),
          #{ listen =>
             fun
               (M) ->
                 fun
                   (R) ->
                     fun
                       (S) ->
                         (V((M(R))(S)))
                         (fun
                           (V@2) ->
                             V@1({ rWSResult
                                 , erlang:element(2, V@2)
                                 , { tuple
                                   , erlang:element(3, V@2)
                                   , erlang:element(4, V@2)
                                   }
                                 , erlang:element(4, V@2)
                                 })
                         end)
                     end
                 end
             end
           , pass =>
             fun
               (M) ->
                 fun
                   (R) ->
                     fun
                       (S) ->
                         (V((M(R))(S)))
                         (fun
                           (V@2) ->
                             V@1({ rWSResult
                                 , erlang:element(2, V@2)
                                 , erlang:element(2, erlang:element(3, V@2))
                                 , (erlang:element(3, erlang:element(3, V@2)))
                                   (erlang:element(4, V@2))
                                 })
                         end)
                     end
                 end
             end
           , 'Monoid0' =>
             fun
               (_) ->
                 DictMonoid
             end
           , 'MonadTell1' =>
             fun
               (_) ->
                 MonadTellRWST2
             end
           }
        end
    end
  end.

monadThrowRWST() ->
  fun
    (DictMonadThrow) ->
      monadThrowRWST(DictMonadThrow)
  end.

monadThrowRWST(#{ 'Monad0' := DictMonadThrow, throwError := DictMonadThrow@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadThrow(undefined),
    MonadRWST1 = monadRWST(Monad0),
    fun
      (DictMonoid = #{ mempty := DictMonoid@1 }) ->
        begin
          MonadRWST2 = MonadRWST1(DictMonoid),
          #{ throwError =>
             fun
               (E) ->
                 begin
                   V = DictMonadThrow@1(E),
                   fun
                     (_) ->
                       fun
                         (S) ->
                           ((erlang:map_get(bind, Monad0@2(undefined)))(V))
                           (fun
                             (A) ->
                               (erlang:map_get(pure, Monad0@1(undefined)))
                               ({rWSResult, S, A, DictMonoid@1})
                           end)
                       end
                   end
                 end
             end
           , 'Monad0' =>
             fun
               (_) ->
                 MonadRWST2
             end
           }
        end
    end
  end.

monadErrorRWST() ->
  fun
    (DictMonadError) ->
      monadErrorRWST(DictMonadError)
  end.

monadErrorRWST(#{ 'MonadThrow0' := DictMonadError
                , catchError := DictMonadError@1
                }) ->
  begin
    MonadThrowRWST1 = monadThrowRWST(DictMonadError(undefined)),
    fun
      (DictMonoid) ->
        begin
          MonadThrowRWST2 = MonadThrowRWST1(DictMonoid),
          #{ catchError =>
             fun
               (M) ->
                 fun
                   (H) ->
                     fun
                       (R) ->
                         fun
                           (S) ->
                             (DictMonadError@1((M(R))(S)))
                             (fun
                               (E) ->
                                 ((H(E))(R))(S)
                             end)
                         end
                     end
                 end
             end
           , 'MonadThrow0' =>
             fun
               (_) ->
                 MonadThrowRWST2
             end
           }
        end
    end
  end.

monoidRWST() ->
  fun
    (DictMonad) ->
      monoidRWST(DictMonad)
  end.

monoidRWST(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    ApplicativeRWST1 = applicativeRWST(DictMonad),
    SemigroupRWST1 = semigroupRWST(DictMonad@1(undefined)),
    fun
      (DictMonoid) ->
        begin
          SemigroupRWST2 = SemigroupRWST1(DictMonoid),
          fun
            (#{ 'Semigroup0' := DictMonoid1, mempty := DictMonoid1@1 }) ->
              begin
                SemigroupRWST3 = SemigroupRWST2(DictMonoid1(undefined)),
                #{ mempty =>
                   (erlang:map_get(pure, ApplicativeRWST1(DictMonoid)))
                   (DictMonoid1@1)
                 , 'Semigroup0' =>
                   fun
                     (_) ->
                       SemigroupRWST3
                   end
                 }
              end
          end
        end
    end
  end.

altRWST() ->
  fun
    (DictAlt) ->
      altRWST(DictAlt)
  end.

altRWST(#{ 'Functor0' := DictAlt, alt := DictAlt@1 }) ->
  begin
    #{ map := V } = DictAlt(undefined),
    FunctorRWST1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 fun
                   (R) ->
                     fun
                       (S) ->
                         (V(fun
                            (V1) ->
                              { rWSResult
                              , erlang:element(2, V1)
                              , F(erlang:element(3, V1))
                              , erlang:element(4, V1)
                              }
                          end))
                         ((V@1(R))(S))
                     end
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
                 (R) ->
                   fun
                     (S) ->
                       (DictAlt@1((V@1(R))(S)))((V1(R))(S))
                   end
               end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorRWST1
       end
     }
  end.

plusRWST() ->
  fun
    (DictPlus) ->
      plusRWST(DictPlus)
  end.

plusRWST(#{ 'Alt0' := DictPlus, empty := DictPlus@1 }) ->
  begin
    #{ 'Functor0' := V, alt := V@1 } = DictPlus(undefined),
    #{ map := V@2 } = V(undefined),
    AltRWST1 =
      begin
        FunctorRWST1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@3) ->
                     fun
                       (R) ->
                         fun
                           (S) ->
                             (V@2(fun
                                (V1) ->
                                  { rWSResult
                                  , erlang:element(2, V1)
                                  , F(erlang:element(3, V1))
                                  , erlang:element(4, V1)
                                  }
                              end))
                             ((V@3(R))(S))
                         end
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
                     (R) ->
                       fun
                         (S) ->
                           (V@1((V@3(R))(S)))((V1(R))(S))
                       end
                   end
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorRWST1
           end
         }
      end,
    #{ empty =>
       fun
         (_) ->
           fun
             (_) ->
               DictPlus@1
           end
       end
     , 'Alt0' =>
       fun
         (_) ->
           AltRWST1
       end
     }
  end.

alternativeRWST() ->
  fun
    (DictMonoid) ->
      fun
        (DictAlternative) ->
          alternativeRWST(DictMonoid, DictAlternative)
      end
  end.

alternativeRWST(DictMonoid, #{ 'Plus1' := DictAlternative }) ->
  begin
    #{ 'Alt0' := V, empty := V@1 } = DictAlternative(undefined),
    PlusRWST1 =
      begin
        #{ 'Functor0' := V@2, alt := V@3 } = V(undefined),
        #{ map := V@4 } = V@2(undefined),
        FunctorRWST1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@5) ->
                     fun
                       (R) ->
                         fun
                           (S) ->
                             (V@4(fun
                                (V1) ->
                                  { rWSResult
                                  , erlang:element(2, V1)
                                  , F(erlang:element(3, V1))
                                  , erlang:element(4, V1)
                                  }
                              end))
                             ((V@5(R))(S))
                         end
                     end
                 end
             end
           },
        AltRWST1 =
          #{ alt =>
             fun
               (V@5) ->
                 fun
                   (V1) ->
                     fun
                       (R) ->
                         fun
                           (S) ->
                             (V@3((V@5(R))(S)))((V1(R))(S))
                         end
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorRWST1
             end
           },
        #{ empty =>
           fun
             (_) ->
               fun
                 (_) ->
                   V@1
               end
           end
         , 'Alt0' =>
           fun
             (_) ->
               AltRWST1
           end
         }
      end,
    fun
      (DictMonad) ->
        begin
          ApplicativeRWST1 = (applicativeRWST(DictMonad))(DictMonoid),
          #{ 'Applicative0' =>
             fun
               (_) ->
                 ApplicativeRWST1
             end
           , 'Plus1' =>
             fun
               (_) ->
                 PlusRWST1
             end
           }
        end
    end
  end.

