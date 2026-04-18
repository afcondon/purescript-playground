-module(control_monad_writer_trans@ps).
-export([ 'WriterT'/0
        , 'WriterT'/1
        , runWriterT/0
        , runWriterT/1
        , newtypeWriterT/0
        , monadTransWriterT/0
        , monadTransWriterT/1
        , mapWriterT/0
        , mapWriterT/2
        , functorWriterT/0
        , functorWriterT/1
        , execWriterT/0
        , execWriterT/2
        , applyWriterT/0
        , applyWriterT/2
        , bindWriterT/0
        , bindWriterT/2
        , semigroupWriterT/0
        , semigroupWriterT/2
        , applicativeWriterT/0
        , applicativeWriterT/1
        , monadWriterT/0
        , monadWriterT/1
        , monadAskWriterT/0
        , monadAskWriterT/1
        , monadReaderWriterT/0
        , monadReaderWriterT/1
        , monadContWriterT/0
        , monadContWriterT/1
        , monadEffectWriter/0
        , monadEffectWriter/1
        , monadRecWriterT/0
        , monadRecWriterT/1
        , monadStateWriterT/0
        , monadStateWriterT/1
        , monadTellWriterT/0
        , monadTellWriterT/1
        , monadWriterWriterT/0
        , monadWriterWriterT/1
        , monadThrowWriterT/0
        , monadThrowWriterT/1
        , monadErrorWriterT/0
        , monadErrorWriterT/1
        , monoidWriterT/0
        , monoidWriterT/1
        , altWriterT/0
        , altWriterT/1
        , plusWriterT/0
        , plusWriterT/1
        , alternativeWriterT/0
        , alternativeWriterT/1
        , monadPlusWriterT/0
        , monadPlusWriterT/1
        , monadZeroWriterT/0
        , monadZeroWriterT/1
        ]).
-compile(no_auto_import).
'WriterT'() ->
  fun
    (X) ->
      'WriterT'(X)
  end.

'WriterT'(X) ->
  X.

runWriterT() ->
  fun
    (V) ->
      runWriterT(V)
  end.

runWriterT(V) ->
  V.

newtypeWriterT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monadTransWriterT() ->
  fun
    (DictMonoid) ->
      monadTransWriterT(DictMonoid)
  end.

monadTransWriterT(#{ mempty := DictMonoid }) ->
  #{ lift =>
     fun
       (#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
         fun
           (M) ->
             ((erlang:map_get(bind, DictMonad@1(undefined)))(M))
             (fun
               (A) ->
                 (erlang:map_get(pure, DictMonad(undefined)))
                 ({tuple, A, DictMonoid})
             end)
         end
     end
   }.

mapWriterT() ->
  fun
    (F) ->
      fun
        (V) ->
          mapWriterT(F, V)
      end
  end.

mapWriterT(F, V) ->
  F(V).

functorWriterT() ->
  fun
    (DictFunctor) ->
      functorWriterT(DictFunctor)
  end.

functorWriterT(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         DictFunctor(fun
           (V) ->
             {tuple, F(erlang:element(2, V)), erlang:element(3, V)}
         end)
     end
   }.

execWriterT() ->
  fun
    (DictFunctor) ->
      fun
        (V) ->
          execWriterT(DictFunctor, V)
      end
  end.

execWriterT(#{ map := DictFunctor }, V) ->
  (DictFunctor(data_tuple@ps:snd()))(V).

applyWriterT() ->
  fun
    (DictSemigroup) ->
      fun
        (DictApply) ->
          applyWriterT(DictSemigroup, DictApply)
      end
  end.

applyWriterT( #{ append := DictSemigroup }
            , #{ 'Functor0' := DictApply, apply := DictApply@1 }
            ) ->
  begin
    #{ map := Functor0 } = DictApply(undefined),
    FunctorWriterT1 =
      #{ map =>
         fun
           (F) ->
             Functor0(fun
               (V) ->
                 {tuple, F(erlang:element(2, V)), erlang:element(3, V)}
             end)
         end
       },
    #{ apply =>
       fun
         (V) ->
           fun
             (V1) ->
               (DictApply@1((Functor0(fun
                               (V3) ->
                                 fun
                                   (V4) ->
                                     { tuple
                                     , (erlang:element(2, V3))
                                       (erlang:element(2, V4))
                                     , (DictSemigroup(erlang:element(3, V3)))
                                       (erlang:element(3, V4))
                                     }
                                 end
                             end))
                            (V)))
               (V1)
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorWriterT1
       end
     }
  end.

bindWriterT() ->
  fun
    (DictSemigroup) ->
      fun
        (DictBind) ->
          bindWriterT(DictSemigroup, DictBind)
      end
  end.

bindWriterT( #{ append := DictSemigroup }
           , #{ 'Apply0' := DictBind, bind := DictBind@1 }
           ) ->
  begin
    #{ 'Functor0' := Apply0, apply := Apply0@1 } = DictBind(undefined),
    #{ map := Functor0 } = Apply0(undefined),
    FunctorWriterT1 =
      #{ map =>
         fun
           (F) ->
             Functor0(fun
               (V) ->
                 {tuple, F(erlang:element(2, V)), erlang:element(3, V)}
             end)
         end
       },
    ApplyWriterT2 =
      #{ apply =>
         fun
           (V) ->
             fun
               (V1) ->
                 (Apply0@1((Functor0(fun
                              (V3) ->
                                fun
                                  (V4) ->
                                    { tuple
                                    , (erlang:element(2, V3))
                                      (erlang:element(2, V4))
                                    , (DictSemigroup(erlang:element(3, V3)))
                                      (erlang:element(3, V4))
                                    }
                                end
                            end))
                           (V)))
                 (V1)
             end
         end
       , 'Functor0' =>
         fun
           (_) ->
             FunctorWriterT1
         end
       },
    #{ bind =>
       fun
         (V) ->
           fun
             (K) ->
               (DictBind@1(V))
               (fun
                 (V1) ->
                   begin
                     V@1 = erlang:element(3, V1),
                     ((erlang:map_get(map, Apply0(undefined)))
                      (fun
                        (V3) ->
                          { tuple
                          , erlang:element(2, V3)
                          , (DictSemigroup(V@1))(erlang:element(3, V3))
                          }
                      end))
                     (K(erlang:element(2, V1)))
                   end
               end)
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyWriterT2
       end
     }
  end.

semigroupWriterT() ->
  fun
    (DictApply) ->
      fun
        (DictSemigroup) ->
          semigroupWriterT(DictApply, DictSemigroup)
      end
  end.

semigroupWriterT( #{ 'Functor0' := DictApply, apply := DictApply@1 }
                , #{ append := DictSemigroup }
                ) ->
  begin
    #{ map := Functor0 } = DictApply(undefined),
    fun
      (#{ append := DictSemigroup1 }) ->
        #{ append =>
           fun
             (A) ->
               fun
                 (B) ->
                   (DictApply@1((Functor0(fun
                                   (V3) ->
                                     fun
                                       (V4) ->
                                         { tuple
                                         , (erlang:element(2, V3))
                                           (erlang:element(2, V4))
                                         , (DictSemigroup(erlang:element(3, V3)))
                                           (erlang:element(3, V4))
                                         }
                                     end
                                 end))
                                ((Functor0(fun
                                    (V) ->
                                      { tuple
                                      , DictSemigroup1(erlang:element(2, V))
                                      , erlang:element(3, V)
                                      }
                                  end))
                                 (A))))
                   (B)
               end
           end
         }
    end
  end.

applicativeWriterT() ->
  fun
    (DictMonoid) ->
      applicativeWriterT(DictMonoid)
  end.

applicativeWriterT(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    fun
      (#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
        begin
          #{ 'Functor0' := V@1, apply := V@2 } = DictApplicative(undefined),
          #{ map := Functor0 } = V@1(undefined),
          ApplyWriterT2 =
            begin
              FunctorWriterT1 =
                #{ map =>
                   fun
                     (F) ->
                       Functor0(fun
                         (V@3) ->
                           { tuple
                           , F(erlang:element(2, V@3))
                           , erlang:element(3, V@3)
                           }
                       end)
                   end
                 },
              #{ apply =>
                 fun
                   (V@3) ->
                     fun
                       (V1) ->
                         (V@2((Functor0(fun
                                 (V3) ->
                                   fun
                                     (V4) ->
                                       { tuple
                                       , (erlang:element(2, V3))
                                         (erlang:element(2, V4))
                                       , (V(erlang:element(3, V3)))
                                         (erlang:element(3, V4))
                                       }
                                   end
                               end))
                              (V@3)))
                         (V1)
                     end
                 end
               , 'Functor0' =>
                 fun
                   (_) ->
                     FunctorWriterT1
                 end
               }
            end,
          #{ pure =>
             fun
               (A) ->
                 DictApplicative@1({tuple, A, DictMonoid@1})
             end
           , 'Apply0' =>
             fun
               (_) ->
                 ApplyWriterT2
             end
           }
        end
    end
  end.

monadWriterT() ->
  fun
    (DictMonoid) ->
      monadWriterT(DictMonoid)
  end.

monadWriterT(DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
  begin
    ApplicativeWriterT1 = applicativeWriterT(DictMonoid),
    BindWriterT1 = (bindWriterT())(DictMonoid@1(undefined)),
    fun
      (#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
        begin
          ApplicativeWriterT2 = ApplicativeWriterT1(DictMonad(undefined)),
          BindWriterT2 = BindWriterT1(DictMonad@1(undefined)),
          #{ 'Applicative0' =>
             fun
               (_) ->
                 ApplicativeWriterT2
             end
           , 'Bind1' =>
             fun
               (_) ->
                 BindWriterT2
             end
           }
        end
    end
  end.

monadAskWriterT() ->
  fun
    (DictMonoid) ->
      monadAskWriterT(DictMonoid)
  end.

monadAskWriterT(DictMonoid = #{ mempty := DictMonoid@1 }) ->
  begin
    MonadWriterT1 = monadWriterT(DictMonoid),
    fun
      (#{ 'Monad0' := DictMonadAsk, ask := DictMonadAsk@1 }) ->
        begin
          Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
            DictMonadAsk(undefined),
          MonadWriterT2 = MonadWriterT1(Monad0),
          #{ ask =>
             ((erlang:map_get(bind, Monad0@2(undefined)))(DictMonadAsk@1))
             (fun
               (A) ->
                 (erlang:map_get(pure, Monad0@1(undefined)))
                 ({tuple, A, DictMonoid@1})
             end)
           , 'Monad0' =>
             fun
               (_) ->
                 MonadWriterT2
             end
           }
        end
    end
  end.

monadReaderWriterT() ->
  fun
    (DictMonoid) ->
      monadReaderWriterT(DictMonoid)
  end.

monadReaderWriterT(DictMonoid) ->
  begin
    MonadAskWriterT1 = monadAskWriterT(DictMonoid),
    fun
      (#{ 'MonadAsk0' := DictMonadReader, local := DictMonadReader@1 }) ->
        begin
          MonadAskWriterT2 = MonadAskWriterT1(DictMonadReader(undefined)),
          #{ local =>
             fun
               (F) ->
                 DictMonadReader@1(F)
             end
           , 'MonadAsk0' =>
             fun
               (_) ->
                 MonadAskWriterT2
             end
           }
        end
    end
  end.

monadContWriterT() ->
  fun
    (DictMonoid) ->
      monadContWriterT(DictMonoid)
  end.

monadContWriterT(DictMonoid = #{ mempty := DictMonoid@1 }) ->
  begin
    MonadWriterT1 = monadWriterT(DictMonoid),
    fun
      (#{ 'Monad0' := DictMonadCont, callCC := DictMonadCont@1 }) ->
        begin
          MonadWriterT2 = MonadWriterT1(DictMonadCont(undefined)),
          #{ callCC =>
             fun
               (F) ->
                 DictMonadCont@1(fun
                   (C) ->
                     F(fun
                       (A) ->
                         C({tuple, A, DictMonoid@1})
                     end)
                 end)
             end
           , 'Monad0' =>
             fun
               (_) ->
                 MonadWriterT2
             end
           }
        end
    end
  end.

monadEffectWriter() ->
  fun
    (DictMonoid) ->
      monadEffectWriter(DictMonoid)
  end.

monadEffectWriter(DictMonoid = #{ mempty := DictMonoid@1 }) ->
  begin
    MonadWriterT1 = monadWriterT(DictMonoid),
    fun
      (#{ 'Monad0' := DictMonadEffect, liftEffect := DictMonadEffect@1 }) ->
        begin
          Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
            DictMonadEffect(undefined),
          MonadWriterT2 = MonadWriterT1(Monad0),
          #{ liftEffect =>
             fun
               (X) ->
                 ((erlang:map_get(bind, Monad0@2(undefined)))
                  (DictMonadEffect@1(X)))
                 (fun
                   (A) ->
                     (erlang:map_get(pure, Monad0@1(undefined)))
                     ({tuple, A, DictMonoid@1})
                 end)
             end
           , 'Monad0' =>
             fun
               (_) ->
                 MonadWriterT2
             end
           }
        end
    end
  end.

monadRecWriterT() ->
  fun
    (DictMonoid) ->
      monadRecWriterT(DictMonoid)
  end.

monadRecWriterT(DictMonoid = #{ 'Semigroup0' := DictMonoid@1
                              , mempty := DictMonoid@2
                              }) ->
  begin
    #{ append := V } = DictMonoid@1(undefined),
    MonadWriterT1 = monadWriterT(DictMonoid),
    fun
      (#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
        begin
          Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
            DictMonadRec(undefined),
          MonadWriterT2 = MonadWriterT1(Monad0),
          #{ tailRecM =>
             fun
               (F) ->
                 fun
                   (A) ->
                     (DictMonadRec@1(fun
                        (V@1) ->
                          begin
                            V@2 = erlang:element(3, V@1),
                            ((erlang:map_get(bind, Monad0@2(undefined)))
                             (F(erlang:element(2, V@1))))
                            (fun
                              (V2) ->
                                (erlang:map_get(pure, Monad0@1(undefined)))
                                (case erlang:element(2, V2) of
                                  {loop, _} ->
                                    { loop
                                    , { tuple
                                      , erlang:element(2, erlang:element(2, V2))
                                      , (V(V@2))(erlang:element(3, V2))
                                      }
                                    };
                                  {done, _} ->
                                    { done
                                    , { tuple
                                      , erlang:element(2, erlang:element(2, V2))
                                      , (V(V@2))(erlang:element(3, V2))
                                      }
                                    };
                                  _ ->
                                    erlang:error({ fail
                                                 , <<"Failed pattern match">>
                                                 })
                                end)
                            end)
                          end
                      end))
                     ({tuple, A, DictMonoid@2})
                 end
             end
           , 'Monad0' =>
             fun
               (_) ->
                 MonadWriterT2
             end
           }
        end
    end
  end.

monadStateWriterT() ->
  fun
    (DictMonoid) ->
      monadStateWriterT(DictMonoid)
  end.

monadStateWriterT(DictMonoid = #{ mempty := DictMonoid@1 }) ->
  begin
    MonadWriterT1 = monadWriterT(DictMonoid),
    fun
      (#{ 'Monad0' := DictMonadState, state := DictMonadState@1 }) ->
        begin
          Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
            DictMonadState(undefined),
          MonadWriterT2 = MonadWriterT1(Monad0),
          #{ state =>
             fun
               (F) ->
                 ((erlang:map_get(bind, Monad0@2(undefined)))
                  (DictMonadState@1(F)))
                 (fun
                   (A) ->
                     (erlang:map_get(pure, Monad0@1(undefined)))
                     ({tuple, A, DictMonoid@1})
                 end)
             end
           , 'Monad0' =>
             fun
               (_) ->
                 MonadWriterT2
             end
           }
        end
    end
  end.

monadTellWriterT() ->
  fun
    (DictMonoid) ->
      monadTellWriterT(DictMonoid)
  end.

monadTellWriterT(DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
  begin
    Semigroup0 = DictMonoid@1(undefined),
    MonadWriterT1 = monadWriterT(DictMonoid),
    fun
      (DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
        begin
          MonadWriterT2 = MonadWriterT1(DictMonad),
          #{ tell =>
             begin
               V = (data_tuple@ps:'Tuple'())(unit),
               fun
                 (X) ->
                   (erlang:map_get(pure, DictMonad@1(undefined)))(V(X))
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
                 MonadWriterT2
             end
           }
        end
    end
  end.

monadWriterWriterT() ->
  fun
    (DictMonoid) ->
      monadWriterWriterT(DictMonoid)
  end.

monadWriterWriterT(DictMonoid) ->
  begin
    MonadTellWriterT1 = monadTellWriterT(DictMonoid),
    fun
      (DictMonad = #{ 'Applicative0' := DictMonad@1, 'Bind1' := DictMonad@2 }) ->
        begin
          #{ bind := V } = DictMonad@2(undefined),
          #{ pure := V@1 } = DictMonad@1(undefined),
          MonadTellWriterT2 = MonadTellWriterT1(DictMonad),
          #{ listen =>
             fun
               (V@2) ->
                 (V(V@2))
                 (fun
                   (V1) ->
                     V@1({ tuple
                         , {tuple, erlang:element(2, V1), erlang:element(3, V1)}
                         , erlang:element(3, V1)
                         })
                 end)
             end
           , pass =>
             fun
               (V@2) ->
                 (V(V@2))
                 (fun
                   (V1) ->
                     V@1({ tuple
                         , erlang:element(2, erlang:element(2, V1))
                         , (erlang:element(3, erlang:element(2, V1)))
                           (erlang:element(3, V1))
                         })
                 end)
             end
           , 'Monoid0' =>
             fun
               (_) ->
                 DictMonoid
             end
           , 'MonadTell1' =>
             fun
               (_) ->
                 MonadTellWriterT2
             end
           }
        end
    end
  end.

monadThrowWriterT() ->
  fun
    (DictMonoid) ->
      monadThrowWriterT(DictMonoid)
  end.

monadThrowWriterT(DictMonoid = #{ mempty := DictMonoid@1 }) ->
  begin
    MonadWriterT1 = monadWriterT(DictMonoid),
    fun
      (#{ 'Monad0' := DictMonadThrow, throwError := DictMonadThrow@1 }) ->
        begin
          Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
            DictMonadThrow(undefined),
          MonadWriterT2 = MonadWriterT1(Monad0),
          #{ throwError =>
             fun
               (E) ->
                 ((erlang:map_get(bind, Monad0@2(undefined)))
                  (DictMonadThrow@1(E)))
                 (fun
                   (A) ->
                     (erlang:map_get(pure, Monad0@1(undefined)))
                     ({tuple, A, DictMonoid@1})
                 end)
             end
           , 'Monad0' =>
             fun
               (_) ->
                 MonadWriterT2
             end
           }
        end
    end
  end.

monadErrorWriterT() ->
  fun
    (DictMonoid) ->
      monadErrorWriterT(DictMonoid)
  end.

monadErrorWriterT(DictMonoid) ->
  begin
    MonadThrowWriterT1 = monadThrowWriterT(DictMonoid),
    fun
      (#{ 'MonadThrow0' := DictMonadError, catchError := DictMonadError@1 }) ->
        begin
          MonadThrowWriterT2 = MonadThrowWriterT1(DictMonadError(undefined)),
          #{ catchError =>
             fun
               (V) ->
                 fun
                   (H) ->
                     (DictMonadError@1(V))
                     (fun
                       (E) ->
                         H(E)
                     end)
                 end
             end
           , 'MonadThrow0' =>
             fun
               (_) ->
                 MonadThrowWriterT2
             end
           }
        end
    end
  end.

monoidWriterT() ->
  fun
    (DictApplicative) ->
      monoidWriterT(DictApplicative)
  end.

monoidWriterT(DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative@1(undefined),
    fun
      (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
        begin
          #{ append := V@2 } = DictMonoid@1(undefined),
          #{ map := Functor0 } = V(undefined),
          fun
            (#{ 'Semigroup0' := DictMonoid1, mempty := DictMonoid1@1 }) ->
              begin
                #{ append := V@3 } = DictMonoid1(undefined),
                SemigroupWriterT3 =
                  #{ append =>
                     fun
                       (A) ->
                         fun
                           (B) ->
                             (V@1((Functor0(fun
                                     (V3) ->
                                       fun
                                         (V4) ->
                                           { tuple
                                           , (erlang:element(2, V3))
                                             (erlang:element(2, V4))
                                           , (V@2(erlang:element(3, V3)))
                                             (erlang:element(3, V4))
                                           }
                                       end
                                   end))
                                  ((Functor0(fun
                                      (V@4) ->
                                        { tuple
                                        , V@3(erlang:element(2, V@4))
                                        , erlang:element(3, V@4)
                                        }
                                    end))
                                   (A))))
                             (B)
                         end
                     end
                   },
                #{ mempty =>
                   (erlang:map_get(
                      pure,
                      (applicativeWriterT(DictMonoid))(DictApplicative)
                    ))
                   (DictMonoid1@1)
                 , 'Semigroup0' =>
                   fun
                     (_) ->
                       SemigroupWriterT3
                   end
                 }
              end
          end
        end
    end
  end.

altWriterT() ->
  fun
    (DictAlt) ->
      altWriterT(DictAlt)
  end.

altWriterT(#{ 'Functor0' := DictAlt, alt := DictAlt@1 }) ->
  begin
    #{ map := V } = DictAlt(undefined),
    FunctorWriterT1 =
      #{ map =>
         fun
           (F) ->
             V(fun
               (V@1) ->
                 {tuple, F(erlang:element(2, V@1)), erlang:element(3, V@1)}
             end)
         end
       },
    #{ alt =>
       fun
         (V@1) ->
           fun
             (V1) ->
               (DictAlt@1(V@1))(V1)
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorWriterT1
       end
     }
  end.

plusWriterT() ->
  fun
    (DictPlus) ->
      plusWriterT(DictPlus)
  end.

plusWriterT(#{ 'Alt0' := DictPlus, empty := DictPlus@1 }) ->
  begin
    #{ 'Functor0' := V, alt := V@1 } = DictPlus(undefined),
    #{ map := V@2 } = V(undefined),
    AltWriterT1 =
      begin
        FunctorWriterT1 =
          #{ map =>
             fun
               (F) ->
                 V@2(fun
                   (V@3) ->
                     {tuple, F(erlang:element(2, V@3)), erlang:element(3, V@3)}
                 end)
             end
           },
        #{ alt =>
           fun
             (V@3) ->
               fun
                 (V1) ->
                   (V@1(V@3))(V1)
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorWriterT1
           end
         }
      end,
    #{ empty => DictPlus@1
     , 'Alt0' =>
       fun
         (_) ->
           AltWriterT1
       end
     }
  end.

alternativeWriterT() ->
  fun
    (DictMonoid) ->
      alternativeWriterT(DictMonoid)
  end.

alternativeWriterT(DictMonoid) ->
  begin
    ApplicativeWriterT1 = applicativeWriterT(DictMonoid),
    fun
      (#{ 'Applicative0' := DictAlternative, 'Plus1' := DictAlternative@1 }) ->
        begin
          ApplicativeWriterT2 = ApplicativeWriterT1(DictAlternative(undefined)),
          #{ 'Alt0' := V, empty := V@1 } = DictAlternative@1(undefined),
          #{ 'Functor0' := V@2, alt := V@3 } = V(undefined),
          PlusWriterT1 =
            begin
              #{ map := V@4 } = V@2(undefined),
              FunctorWriterT1 =
                #{ map =>
                   fun
                     (F) ->
                       V@4(fun
                         (V@5) ->
                           { tuple
                           , F(erlang:element(2, V@5))
                           , erlang:element(3, V@5)
                           }
                       end)
                   end
                 },
              AltWriterT1 =
                #{ alt =>
                   fun
                     (V@5) ->
                       fun
                         (V1) ->
                           (V@3(V@5))(V1)
                       end
                   end
                 , 'Functor0' =>
                   fun
                     (_) ->
                       FunctorWriterT1
                   end
                 },
              #{ empty => V@1
               , 'Alt0' =>
                 fun
                   (_) ->
                     AltWriterT1
                 end
               }
            end,
          #{ 'Applicative0' =>
             fun
               (_) ->
                 ApplicativeWriterT2
             end
           , 'Plus1' =>
             fun
               (_) ->
                 PlusWriterT1
             end
           }
        end
    end
  end.

monadPlusWriterT() ->
  fun
    (DictMonoid) ->
      monadPlusWriterT(DictMonoid)
  end.

monadPlusWriterT(DictMonoid) ->
  begin
    MonadWriterT1 = monadWriterT(DictMonoid),
    AlternativeWriterT1 = alternativeWriterT(DictMonoid),
    fun
      (#{ 'Alternative1' := DictMonadPlus, 'Monad0' := DictMonadPlus@1 }) ->
        begin
          MonadWriterT2 = MonadWriterT1(DictMonadPlus@1(undefined)),
          AlternativeWriterT2 = AlternativeWriterT1(DictMonadPlus(undefined)),
          #{ 'Monad0' =>
             fun
               (_) ->
                 MonadWriterT2
             end
           , 'Alternative1' =>
             fun
               (_) ->
                 AlternativeWriterT2
             end
           }
        end
    end
  end.

monadZeroWriterT() ->
  fun
    (DictMonoid) ->
      monadZeroWriterT(DictMonoid)
  end.

monadZeroWriterT(DictMonoid) ->
  begin
    MonadWriterT1 = monadWriterT(DictMonoid),
    AlternativeWriterT1 = alternativeWriterT(DictMonoid),
    fun
      (#{ 'Alternative1' := DictMonadZero, 'Monad0' := DictMonadZero@1 }) ->
        begin
          MonadWriterT2 = MonadWriterT1(DictMonadZero@1(undefined)),
          AlternativeWriterT2 = AlternativeWriterT1(DictMonadZero(undefined)),
          #{ 'Monad0' =>
             fun
               (_) ->
                 MonadWriterT2
             end
           , 'Alternative1' =>
             fun
               (_) ->
                 AlternativeWriterT2
             end
           , 'MonadZeroIsDeprecated2' =>
             fun
               (_) ->
                 undefined
             end
           }
        end
    end
  end.

