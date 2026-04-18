-module(control_monad_reader_trans@ps).
-export([ 'ReaderT'/0
        , 'ReaderT'/1
        , withReaderT/0
        , withReaderT/3
        , runReaderT/0
        , runReaderT/1
        , newtypeReaderT/0
        , monadTransReaderT/0
        , mapReaderT/0
        , mapReaderT/3
        , functorReaderT/0
        , functorReaderT/1
        , distributiveReaderT/0
        , distributiveReaderT/1
        , applyReaderT/0
        , applyReaderT/1
        , bindReaderT/0
        , bindReaderT/1
        , semigroupReaderT/0
        , semigroupReaderT/1
        , applicativeReaderT/0
        , applicativeReaderT/1
        , monadReaderT/0
        , monadReaderT/1
        , monadAskReaderT/0
        , monadAskReaderT/1
        , monadReaderReaderT/0
        , monadReaderReaderT/1
        , monadContReaderT/0
        , monadContReaderT/1
        , monadEffectReader/0
        , monadEffectReader/1
        , monadRecReaderT/0
        , monadRecReaderT/1
        , monadStateReaderT/0
        , monadStateReaderT/1
        , monadTellReaderT/0
        , monadTellReaderT/1
        , monadWriterReaderT/0
        , monadWriterReaderT/1
        , monadThrowReaderT/0
        , monadThrowReaderT/1
        , monadErrorReaderT/0
        , monadErrorReaderT/1
        , monoidReaderT/0
        , monoidReaderT/1
        , altReaderT/0
        , altReaderT/1
        , plusReaderT/0
        , plusReaderT/1
        , alternativeReaderT/0
        , alternativeReaderT/1
        , monadPlusReaderT/0
        , monadPlusReaderT/1
        , monadZeroReaderT/0
        , monadZeroReaderT/1
        ]).
-compile(no_auto_import).
'ReaderT'() ->
  fun
    (X) ->
      'ReaderT'(X)
  end.

'ReaderT'(X) ->
  X.

withReaderT() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (X) ->
              withReaderT(F, V, X)
          end
      end
  end.

withReaderT(F, V, X) ->
  V(F(X)).

runReaderT() ->
  fun
    (V) ->
      runReaderT(V)
  end.

runReaderT(V) ->
  V.

newtypeReaderT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monadTransReaderT() ->
  #{ lift =>
     fun
       (_) ->
         fun
           (X) ->
             fun
               (_) ->
                 X
             end
         end
     end
   }.

mapReaderT() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (X) ->
              mapReaderT(F, V, X)
          end
      end
  end.

mapReaderT(F, V, X) ->
  F(V(X)).

functorReaderT() ->
  fun
    (DictFunctor) ->
      functorReaderT(DictFunctor)
  end.

functorReaderT(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (X) ->
         begin
           V = DictFunctor(X),
           fun
             (V@1) ->
               fun
                 (X@1) ->
                   V(V@1(X@1))
               end
           end
         end
     end
   }.

distributiveReaderT() ->
  fun
    (DictDistributive) ->
      distributiveReaderT(DictDistributive)
  end.

distributiveReaderT(DictDistributive = #{ 'Functor0' := DictDistributive@1
                                        , collect := DictDistributive@2
                                        }) ->
  begin
    #{ map := V } = DictDistributive@1(undefined),
    FunctorReaderT1 =
      #{ map =>
         fun
           (X) ->
             begin
               V@1 = V(X),
               fun
                 (V@2) ->
                   fun
                     (X@1) ->
                       V@1(V@2(X@1))
                   end
               end
             end
         end
       },
    #{ distribute =>
       fun
         (DictFunctor) ->
           begin
             Collect1 = DictDistributive@2(DictFunctor),
             fun
               (A) ->
                 fun
                   (E) ->
                     (Collect1(fun
                        (R) ->
                          R(E)
                      end))
                     (A)
                 end
             end
           end
       end
     , collect =>
       fun
         (DictFunctor = #{ map := DictFunctor@1 }) ->
           fun
             (F) ->
               begin
                 V@1 =
                   (erlang:map_get(
                      distribute,
                      distributiveReaderT(DictDistributive)
                    ))
                   (DictFunctor),
                 V@2 = DictFunctor@1(F),
                 fun
                   (X) ->
                     V@1(V@2(X))
                 end
               end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorReaderT1
       end
     }
  end.

applyReaderT() ->
  fun
    (DictApply) ->
      applyReaderT(DictApply)
  end.

applyReaderT(#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
  begin
    #{ map := V } = DictApply(undefined),
    FunctorReaderT1 =
      #{ map =>
         fun
           (X) ->
             begin
               V@1 = V(X),
               fun
                 (V@2) ->
                   fun
                     (X@1) ->
                       V@1(V@2(X@1))
                   end
               end
             end
         end
       },
    #{ apply =>
       fun
         (V@1) ->
           fun
             (V1) ->
               fun
                 (R) ->
                   (DictApply@1(V@1(R)))(V1(R))
               end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorReaderT1
       end
     }
  end.

bindReaderT() ->
  fun
    (DictBind) ->
      bindReaderT(DictBind)
  end.

bindReaderT(#{ 'Apply0' := DictBind, bind := DictBind@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictBind(undefined),
    #{ map := V@2 } = V(undefined),
    ApplyReaderT1 =
      begin
        FunctorReaderT1 =
          #{ map =>
             fun
               (X) ->
                 begin
                   V@3 = V@2(X),
                   fun
                     (V@4) ->
                       fun
                         (X@1) ->
                           V@3(V@4(X@1))
                       end
                   end
                 end
             end
           },
        #{ apply =>
           fun
             (V@3) ->
               fun
                 (V1) ->
                   fun
                     (R) ->
                       (V@1(V@3(R)))(V1(R))
                   end
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorReaderT1
           end
         }
      end,
    #{ bind =>
       fun
         (V@3) ->
           fun
             (K) ->
               fun
                 (R) ->
                   (DictBind@1(V@3(R)))
                   (fun
                     (A) ->
                       (K(A))(R)
                   end)
               end
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyReaderT1
       end
     }
  end.

semigroupReaderT() ->
  fun
    (DictApply) ->
      semigroupReaderT(DictApply)
  end.

semigroupReaderT(#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
  begin
    #{ map := V } = DictApply(undefined),
    fun
      (#{ append := DictSemigroup }) ->
        #{ append =>
           fun
             (A) ->
               fun
                 (B) ->
                   begin
                     V@1 = V(DictSemigroup),
                     fun
                       (R) ->
                         (DictApply@1(V@1(A(R))))(B(R))
                     end
                   end
               end
           end
         }
    end
  end.

applicativeReaderT() ->
  fun
    (DictApplicative) ->
      applicativeReaderT(DictApplicative)
  end.

applicativeReaderT(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    #{ map := V@2 } = V(undefined),
    FunctorReaderT1 =
      #{ map =>
         fun
           (X) ->
             begin
               V@3 = V@2(X),
               fun
                 (V@4) ->
                   fun
                     (X@1) ->
                       V@3(V@4(X@1))
                   end
               end
             end
         end
       },
    ApplyReaderT1 =
      #{ apply =>
         fun
           (V@3) ->
             fun
               (V1) ->
                 fun
                   (R) ->
                     (V@1(V@3(R)))(V1(R))
                 end
             end
         end
       , 'Functor0' =>
         fun
           (_) ->
             FunctorReaderT1
         end
       },
    #{ pure =>
       fun
         (X) ->
           begin
             V@3 = DictApplicative@1(X),
             fun
               (_) ->
                 V@3
             end
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyReaderT1
       end
     }
  end.

monadReaderT() ->
  fun
    (DictMonad) ->
      monadReaderT(DictMonad)
  end.

monadReaderT(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
  begin
    #{ 'Apply0' := V, pure := V@1 } = DictMonad(undefined),
    #{ 'Functor0' := V@2, apply := V@3 } = V(undefined),
    ApplicativeReaderT1 =
      begin
        #{ map := V@4 } = V@2(undefined),
        FunctorReaderT1 =
          #{ map =>
             fun
               (X) ->
                 begin
                   V@5 = V@4(X),
                   fun
                     (V@6) ->
                       fun
                         (X@1) ->
                           V@5(V@6(X@1))
                       end
                   end
                 end
             end
           },
        ApplyReaderT1 =
          #{ apply =>
             fun
               (V@5) ->
                 fun
                   (V1) ->
                     fun
                       (R) ->
                         (V@3(V@5(R)))(V1(R))
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorReaderT1
             end
           },
        #{ pure =>
           fun
             (X) ->
               begin
                 V@5 = V@1(X),
                 fun
                   (_) ->
                     V@5
                 end
               end
           end
         , 'Apply0' =>
           fun
             (_) ->
               ApplyReaderT1
           end
         }
      end,
    BindReaderT1 = bindReaderT(DictMonad@1(undefined)),
    #{ 'Applicative0' =>
       fun
         (_) ->
           ApplicativeReaderT1
       end
     , 'Bind1' =>
       fun
         (_) ->
           BindReaderT1
       end
     }
  end.

monadAskReaderT() ->
  fun
    (DictMonad) ->
      monadAskReaderT(DictMonad)
  end.

monadAskReaderT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    MonadReaderT1 = monadReaderT(DictMonad),
    #{ ask => erlang:map_get(pure, DictMonad@1(undefined))
     , 'Monad0' =>
       fun
         (_) ->
           MonadReaderT1
       end
     }
  end.

monadReaderReaderT() ->
  fun
    (DictMonad) ->
      monadReaderReaderT(DictMonad)
  end.

monadReaderReaderT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    MonadReaderT1 = monadReaderT(DictMonad),
    MonadAskReaderT1 =
      #{ ask => erlang:map_get(pure, DictMonad@1(undefined))
       , 'Monad0' =>
         fun
           (_) ->
             MonadReaderT1
         end
       },
    #{ local => withReaderT()
     , 'MonadAsk0' =>
       fun
         (_) ->
           MonadAskReaderT1
       end
     }
  end.

monadContReaderT() ->
  fun
    (DictMonadCont) ->
      monadContReaderT(DictMonadCont)
  end.

monadContReaderT(#{ 'Monad0' := DictMonadCont, callCC := DictMonadCont@1 }) ->
  begin
    MonadReaderT1 = monadReaderT(DictMonadCont(undefined)),
    #{ callCC =>
       fun
         (F) ->
           fun
             (R) ->
               DictMonadCont@1(fun
                 (C) ->
                   (F(fun
                      (X) ->
                        begin
                          V = C(X),
                          fun
                            (_) ->
                              V
                          end
                        end
                    end))
                   (R)
               end)
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadReaderT1
       end
     }
  end.

monadEffectReader() ->
  fun
    (DictMonadEffect) ->
      monadEffectReader(DictMonadEffect)
  end.

monadEffectReader(#{ 'Monad0' := DictMonadEffect
                   , liftEffect := DictMonadEffect@1
                   }) ->
  begin
    MonadReaderT1 = monadReaderT(DictMonadEffect(undefined)),
    #{ liftEffect =>
       fun
         (X) ->
           begin
             V = DictMonadEffect@1(X),
             fun
               (_) ->
                 V
             end
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadReaderT1
       end
     }
  end.

monadRecReaderT() ->
  fun
    (DictMonadRec) ->
      monadRecReaderT(DictMonadRec)
  end.

monadRecReaderT(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadRec(undefined),
    #{ bind := V } = Monad0@2(undefined),
    Pure = erlang:map_get(pure, Monad0@1(undefined)),
    MonadReaderT1 = monadReaderT(Monad0),
    #{ tailRecM =>
       fun
         (K) ->
           fun
             (A) ->
               fun
                 (R) ->
                   (DictMonadRec@1(fun
                      (A_) ->
                        (V((K(A_))(R)))(Pure)
                    end))
                   (A)
               end
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadReaderT1
       end
     }
  end.

monadStateReaderT() ->
  fun
    (DictMonadState) ->
      monadStateReaderT(DictMonadState)
  end.

monadStateReaderT(#{ 'Monad0' := DictMonadState, state := DictMonadState@1 }) ->
  begin
    MonadReaderT1 = monadReaderT(DictMonadState(undefined)),
    #{ state =>
       fun
         (X) ->
           begin
             V = DictMonadState@1(X),
             fun
               (_) ->
                 V
             end
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadReaderT1
       end
     }
  end.

monadTellReaderT() ->
  fun
    (DictMonadTell) ->
      monadTellReaderT(DictMonadTell)
  end.

monadTellReaderT(#{ 'Monad1' := DictMonadTell
                  , 'Semigroup0' := DictMonadTell@1
                  , tell := DictMonadTell@2
                  }) ->
  begin
    Semigroup0 = DictMonadTell@1(undefined),
    MonadReaderT1 = monadReaderT(DictMonadTell(undefined)),
    #{ tell =>
       fun
         (X) ->
           begin
             V = DictMonadTell@2(X),
             fun
               (_) ->
                 V
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
           MonadReaderT1
       end
     }
  end.

monadWriterReaderT() ->
  fun
    (DictMonadWriter) ->
      monadWriterReaderT(DictMonadWriter)
  end.

monadWriterReaderT(#{ 'MonadTell1' := DictMonadWriter
                    , 'Monoid0' := DictMonadWriter@1
                    , listen := DictMonadWriter@2
                    , pass := DictMonadWriter@3
                    }) ->
  begin
    Monoid0 = DictMonadWriter@1(undefined),
    MonadTellReaderT1 = monadTellReaderT(DictMonadWriter(undefined)),
    #{ listen =>
       fun
         (V) ->
           fun
             (X) ->
               DictMonadWriter@2(V(X))
           end
       end
     , pass =>
       fun
         (V) ->
           fun
             (X) ->
               DictMonadWriter@3(V(X))
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
           MonadTellReaderT1
       end
     }
  end.

monadThrowReaderT() ->
  fun
    (DictMonadThrow) ->
      monadThrowReaderT(DictMonadThrow)
  end.

monadThrowReaderT(#{ 'Monad0' := DictMonadThrow
                   , throwError := DictMonadThrow@1
                   }) ->
  begin
    MonadReaderT1 = monadReaderT(DictMonadThrow(undefined)),
    #{ throwError =>
       fun
         (X) ->
           begin
             V = DictMonadThrow@1(X),
             fun
               (_) ->
                 V
             end
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadReaderT1
       end
     }
  end.

monadErrorReaderT() ->
  fun
    (DictMonadError) ->
      monadErrorReaderT(DictMonadError)
  end.

monadErrorReaderT(#{ 'MonadThrow0' := DictMonadError
                   , catchError := DictMonadError@1
                   }) ->
  begin
    MonadThrowReaderT1 = monadThrowReaderT(DictMonadError(undefined)),
    #{ catchError =>
       fun
         (V) ->
           fun
             (H) ->
               fun
                 (R) ->
                   (DictMonadError@1(V(R)))
                   (fun
                     (E) ->
                       (H(E))(R)
                   end)
               end
           end
       end
     , 'MonadThrow0' =>
       fun
         (_) ->
           MonadThrowReaderT1
       end
     }
  end.

monoidReaderT() ->
  fun
    (DictApplicative) ->
      monoidReaderT(DictApplicative)
  end.

monoidReaderT(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    #{ map := V@2 } = V(undefined),
    fun
      (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
        begin
          SemigroupReaderT2 =
            #{ append =>
               begin
                 V@3 = erlang:map_get(append, DictMonoid(undefined)),
                 fun
                   (A) ->
                     fun
                       (B) ->
                         begin
                           V@4 = V@2(V@3),
                           fun
                             (R) ->
                               (V@1(V@4(A(R))))(B(R))
                           end
                         end
                     end
                 end
               end
             },
          #{ mempty =>
             begin
               V@4 = DictApplicative@1(DictMonoid@1),
               fun
                 (_) ->
                   V@4
               end
             end
           , 'Semigroup0' =>
             fun
               (_) ->
                 SemigroupReaderT2
             end
           }
        end
    end
  end.

altReaderT() ->
  fun
    (DictAlt) ->
      altReaderT(DictAlt)
  end.

altReaderT(#{ 'Functor0' := DictAlt, alt := DictAlt@1 }) ->
  begin
    #{ map := V } = DictAlt(undefined),
    FunctorReaderT1 =
      #{ map =>
         fun
           (X) ->
             begin
               V@1 = V(X),
               fun
                 (V@2) ->
                   fun
                     (X@1) ->
                       V@1(V@2(X@1))
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
                   (DictAlt@1(V@1(R)))(V1(R))
               end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorReaderT1
       end
     }
  end.

plusReaderT() ->
  fun
    (DictPlus) ->
      plusReaderT(DictPlus)
  end.

plusReaderT(#{ 'Alt0' := DictPlus, empty := DictPlus@1 }) ->
  begin
    #{ 'Functor0' := V, alt := V@1 } = DictPlus(undefined),
    #{ map := V@2 } = V(undefined),
    AltReaderT1 =
      begin
        FunctorReaderT1 =
          #{ map =>
             fun
               (X) ->
                 begin
                   V@3 = V@2(X),
                   fun
                     (V@4) ->
                       fun
                         (X@1) ->
                           V@3(V@4(X@1))
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
                       (V@1(V@3(R)))(V1(R))
                   end
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorReaderT1
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
           AltReaderT1
       end
     }
  end.

alternativeReaderT() ->
  fun
    (DictAlternative) ->
      alternativeReaderT(DictAlternative)
  end.

alternativeReaderT(#{ 'Applicative0' := DictAlternative
                    , 'Plus1' := DictAlternative@1
                    }) ->
  begin
    #{ 'Apply0' := V, pure := V@1 } = DictAlternative(undefined),
    #{ 'Functor0' := V@2, apply := V@3 } = V(undefined),
    ApplicativeReaderT1 =
      begin
        #{ map := V@4 } = V@2(undefined),
        FunctorReaderT1 =
          #{ map =>
             fun
               (X) ->
                 begin
                   V@5 = V@4(X),
                   fun
                     (V@6) ->
                       fun
                         (X@1) ->
                           V@5(V@6(X@1))
                       end
                   end
                 end
             end
           },
        ApplyReaderT1 =
          #{ apply =>
             fun
               (V@5) ->
                 fun
                   (V1) ->
                     fun
                       (R) ->
                         (V@3(V@5(R)))(V1(R))
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorReaderT1
             end
           },
        #{ pure =>
           fun
             (X) ->
               begin
                 V@5 = V@1(X),
                 fun
                   (_) ->
                     V@5
                 end
               end
           end
         , 'Apply0' =>
           fun
             (_) ->
               ApplyReaderT1
           end
         }
      end,
    #{ 'Alt0' := V@5, empty := V@6 } = DictAlternative@1(undefined),
    #{ 'Functor0' := V@7, alt := V@8 } = V@5(undefined),
    PlusReaderT1 =
      begin
        #{ map := V@9 } = V@7(undefined),
        FunctorReaderT1@1 =
          #{ map =>
             fun
               (X) ->
                 begin
                   V@10 = V@9(X),
                   fun
                     (V@11) ->
                       fun
                         (X@1) ->
                           V@10(V@11(X@1))
                       end
                   end
                 end
             end
           },
        AltReaderT1 =
          #{ alt =>
             fun
               (V@10) ->
                 fun
                   (V1) ->
                     fun
                       (R) ->
                         (V@8(V@10(R)))(V1(R))
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorReaderT1@1
             end
           },
        #{ empty =>
           fun
             (_) ->
               V@6
           end
         , 'Alt0' =>
           fun
             (_) ->
               AltReaderT1
           end
         }
      end,
    #{ 'Applicative0' =>
       fun
         (_) ->
           ApplicativeReaderT1
       end
     , 'Plus1' =>
       fun
         (_) ->
           PlusReaderT1
       end
     }
  end.

monadPlusReaderT() ->
  fun
    (DictMonadPlus) ->
      monadPlusReaderT(DictMonadPlus)
  end.

monadPlusReaderT(#{ 'Alternative1' := DictMonadPlus
                  , 'Monad0' := DictMonadPlus@1
                  }) ->
  begin
    MonadReaderT1 = monadReaderT(DictMonadPlus@1(undefined)),
    AlternativeReaderT1 = alternativeReaderT(DictMonadPlus(undefined)),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadReaderT1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeReaderT1
       end
     }
  end.

monadZeroReaderT() ->
  fun
    (DictMonadZero) ->
      monadZeroReaderT(DictMonadZero)
  end.

monadZeroReaderT(#{ 'Alternative1' := DictMonadZero
                  , 'Monad0' := DictMonadZero@1
                  }) ->
  begin
    MonadReaderT1 = monadReaderT(DictMonadZero@1(undefined)),
    AlternativeReaderT1 = alternativeReaderT(DictMonadZero(undefined)),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadReaderT1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeReaderT1
       end
     , 'MonadZeroIsDeprecated2' =>
       fun
         (_) ->
           undefined
       end
     }
  end.

