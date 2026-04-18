-module(control_monad_maybe_trans@ps).
-export([ identity/0
        , identity/1
        , 'MaybeT'/0
        , 'MaybeT'/1
        , runMaybeT/0
        , runMaybeT/1
        , newtypeMaybeT/0
        , monadTransMaybeT/0
        , mapMaybeT/0
        , mapMaybeT/2
        , functorMaybeT/0
        , functorMaybeT/1
        , monadMaybeT/0
        , monadMaybeT/1
        , bindMaybeT/0
        , bindMaybeT/1
        , applyMaybeT/0
        , applyMaybeT/1
        , applicativeMaybeT/0
        , applicativeMaybeT/1
        , semigroupMaybeT/0
        , semigroupMaybeT/1
        , monadAskMaybeT/0
        , monadAskMaybeT/1
        , monadReaderMaybeT/0
        , monadReaderMaybeT/1
        , monadContMaybeT/0
        , monadContMaybeT/1
        , monadEffectMaybe/0
        , monadEffectMaybe/1
        , monadRecMaybeT/0
        , monadRecMaybeT/1
        , monadStateMaybeT/0
        , monadStateMaybeT/1
        , monadTellMaybeT/0
        , monadTellMaybeT/1
        , monadWriterMaybeT/0
        , monadWriterMaybeT/1
        , monadThrowMaybeT/0
        , monadThrowMaybeT/1
        , monadErrorMaybeT/0
        , monadErrorMaybeT/1
        , monoidMaybeT/0
        , monoidMaybeT/1
        , altMaybeT/0
        , altMaybeT/1
        , plusMaybeT/0
        , plusMaybeT/1
        , alternativeMaybeT/0
        , alternativeMaybeT/1
        , monadPlusMaybeT/0
        , monadPlusMaybeT/1
        , monadZeroMaybeT/0
        , monadZeroMaybeT/1
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

'MaybeT'() ->
  fun
    (X) ->
      'MaybeT'(X)
  end.

'MaybeT'(X) ->
  X.

runMaybeT() ->
  fun
    (V) ->
      runMaybeT(V)
  end.

runMaybeT(V) ->
  V.

newtypeMaybeT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monadTransMaybeT() ->
  #{ lift =>
     fun
       (#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
         fun
           (X) ->
             ((erlang:map_get(bind, DictMonad@1(undefined)))(X))
             (fun
               (A_) ->
                 (erlang:map_get(pure, DictMonad(undefined)))({just, A_})
             end)
         end
     end
   }.

mapMaybeT() ->
  fun
    (F) ->
      fun
        (V) ->
          mapMaybeT(F, V)
      end
  end.

mapMaybeT(F, V) ->
  F(V).

functorMaybeT() ->
  fun
    (DictFunctor) ->
      functorMaybeT(DictFunctor)
  end.

functorMaybeT(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             (DictFunctor(fun
                (V1) ->
                  case V1 of
                    {just, V1@1} ->
                      {just, F(V1@1)};
                    _ ->
                      {nothing}
                  end
              end))
             (V)
         end
     end
   }.

monadMaybeT() ->
  fun
    (DictMonad) ->
      monadMaybeT(DictMonad)
  end.

monadMaybeT(DictMonad) ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeMaybeT(DictMonad)
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindMaybeT(DictMonad)
     end
   }.

bindMaybeT() ->
  fun
    (DictMonad) ->
      bindMaybeT(DictMonad)
  end.

bindMaybeT(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  #{ bind =>
     fun
       (V) ->
         fun
           (F) ->
             ((erlang:map_get(bind, DictMonad@1(undefined)))(V))
             (fun
               (V1) ->
                 case V1 of
                   {nothing} ->
                     begin
                       #{ 'Applicative0' := DictMonad@2 } = DictMonad,
                       (erlang:map_get(pure, DictMonad@2(undefined)))({nothing})
                     end;
                   {just, V1@1} ->
                     F(V1@1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end)
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyMaybeT(DictMonad)
     end
   }.

applyMaybeT() ->
  fun
    (DictMonad) ->
      applyMaybeT(DictMonad)
  end.

applyMaybeT(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    #{ map := V } =
      (erlang:map_get(
         'Functor0',
         (erlang:map_get('Apply0', DictMonad@1(undefined)))(undefined)
       ))
      (undefined),
    FunctorMaybeT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 (V(fun
                    (V1) ->
                      case V1 of
                        {just, V1@1} ->
                          {just, F(V1@1)};
                        _ ->
                          {nothing}
                      end
                  end))
                 (V@1)
             end
         end
       },
    #{ apply =>
       begin
         #{ bind := V@1 } = bindMaybeT(DictMonad),
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
                         (erlang:map_get(pure, applicativeMaybeT(DictMonad)))
                         (F_(A_))
                     end)
                 end)
             end
         end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorMaybeT1
       end
     }
  end.

applicativeMaybeT() ->
  fun
    (DictMonad) ->
      applicativeMaybeT(DictMonad)
  end.

applicativeMaybeT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  #{ pure =>
     fun
       (X) ->
         (erlang:map_get(pure, DictMonad@1(undefined)))({just, X})
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyMaybeT(DictMonad)
     end
   }.

semigroupMaybeT() ->
  fun
    (DictMonad) ->
      semigroupMaybeT(DictMonad)
  end.

semigroupMaybeT(DictMonad) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = applyMaybeT(DictMonad),
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

monadAskMaybeT() ->
  fun
    (DictMonadAsk) ->
      monadAskMaybeT(DictMonadAsk)
  end.

monadAskMaybeT(#{ 'Monad0' := DictMonadAsk, ask := DictMonadAsk@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadAsk(undefined),
    MonadMaybeT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeMaybeT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindMaybeT(Monad0)
         end
       },
    #{ ask =>
       ((erlang:map_get(bind, Monad0@2(undefined)))(DictMonadAsk@1))
       (fun
         (A_) ->
           (erlang:map_get(pure, Monad0@1(undefined)))({just, A_})
       end)
     , 'Monad0' =>
       fun
         (_) ->
           MonadMaybeT1
       end
     }
  end.

monadReaderMaybeT() ->
  fun
    (DictMonadReader) ->
      monadReaderMaybeT(DictMonadReader)
  end.

monadReaderMaybeT(#{ 'MonadAsk0' := DictMonadReader
                   , local := DictMonadReader@1
                   }) ->
  begin
    MonadAskMaybeT1 = monadAskMaybeT(DictMonadReader(undefined)),
    #{ local =>
       fun
         (F) ->
           DictMonadReader@1(F)
       end
     , 'MonadAsk0' =>
       fun
         (_) ->
           MonadAskMaybeT1
       end
     }
  end.

monadContMaybeT() ->
  fun
    (DictMonadCont) ->
      monadContMaybeT(DictMonadCont)
  end.

monadContMaybeT(#{ 'Monad0' := DictMonadCont, callCC := DictMonadCont@1 }) ->
  begin
    V = DictMonadCont(undefined),
    MonadMaybeT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeMaybeT(V)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindMaybeT(V)
         end
       },
    #{ callCC =>
       fun
         (F) ->
           DictMonadCont@1(fun
             (C) ->
               F(fun
                 (A) ->
                   C({just, A})
               end)
           end)
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadMaybeT1
       end
     }
  end.

monadEffectMaybe() ->
  fun
    (DictMonadEffect) ->
      monadEffectMaybe(DictMonadEffect)
  end.

monadEffectMaybe(#{ 'Monad0' := DictMonadEffect
                  , liftEffect := DictMonadEffect@1
                  }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadEffect(undefined),
    MonadMaybeT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeMaybeT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindMaybeT(Monad0)
         end
       },
    #{ liftEffect =>
       fun
         (X) ->
           ((erlang:map_get(bind, Monad0@2(undefined)))(DictMonadEffect@1(X)))
           (fun
             (A_) ->
               (erlang:map_get(pure, Monad0@1(undefined)))({just, A_})
           end)
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadMaybeT1
       end
     }
  end.

monadRecMaybeT() ->
  fun
    (DictMonadRec) ->
      monadRecMaybeT(DictMonadRec)
  end.

monadRecMaybeT(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadRec(undefined),
    MonadMaybeT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeMaybeT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindMaybeT(Monad0)
         end
       },
    #{ tailRecM =>
       fun
         (F) ->
           DictMonadRec@1(fun
             (A) ->
               ((erlang:map_get(bind, Monad0@2(undefined)))(F(A)))
               (fun
                 (M_) ->
                   (erlang:map_get(pure, Monad0@1(undefined)))
                   (case M_ of
                     {nothing} ->
                       {done, {nothing}};
                     {just, M_@1} ->
                       case M_@1 of
                         {loop, M_@2} ->
                           {loop, M_@2};
                         {done, M_@3} ->
                           {done, {just, M_@3}};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end)
               end)
           end)
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadMaybeT1
       end
     }
  end.

monadStateMaybeT() ->
  fun
    (DictMonadState) ->
      monadStateMaybeT(DictMonadState)
  end.

monadStateMaybeT(#{ 'Monad0' := DictMonadState, state := DictMonadState@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadState(undefined),
    MonadMaybeT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeMaybeT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindMaybeT(Monad0)
         end
       },
    #{ state =>
       fun
         (F) ->
           ((erlang:map_get(bind, Monad0@2(undefined)))(DictMonadState@1(F)))
           (fun
             (A_) ->
               (erlang:map_get(pure, Monad0@1(undefined)))({just, A_})
           end)
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadMaybeT1
       end
     }
  end.

monadTellMaybeT() ->
  fun
    (DictMonadTell) ->
      monadTellMaybeT(DictMonadTell)
  end.

monadTellMaybeT(#{ 'Monad1' := DictMonadTell
                 , 'Semigroup0' := DictMonadTell@1
                 , tell := DictMonadTell@2
                 }) ->
  begin
    Monad1 = #{ 'Applicative0' := Monad1@1, 'Bind1' := Monad1@2 } =
      DictMonadTell(undefined),
    Semigroup0 = DictMonadTell@1(undefined),
    MonadMaybeT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeMaybeT(Monad1)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindMaybeT(Monad1)
         end
       },
    #{ tell =>
       fun
         (X) ->
           ((erlang:map_get(bind, Monad1@2(undefined)))(DictMonadTell@2(X)))
           (fun
             (A_) ->
               (erlang:map_get(pure, Monad1@1(undefined)))({just, A_})
           end)
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           Semigroup0
       end
     , 'Monad1' =>
       fun
         (_) ->
           MonadMaybeT1
       end
     }
  end.

monadWriterMaybeT() ->
  fun
    (DictMonadWriter) ->
      monadWriterMaybeT(DictMonadWriter)
  end.

monadWriterMaybeT(#{ 'MonadTell1' := DictMonadWriter
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
    MonadTellMaybeT1 = monadTellMaybeT(MonadTell1),
    #{ listen =>
       fun
         (V@2) ->
           (V(DictMonadWriter@2(V@2)))
           (fun
             (V@3) ->
               V@1(case erlang:element(2, V@3) of
                 {just, _} ->
                   { just
                   , { tuple
                     , erlang:element(2, erlang:element(2, V@3))
                     , erlang:element(3, V@3)
                     }
                   };
                 _ ->
                   {nothing}
               end)
           end)
       end
     , pass =>
       fun
         (V@2) ->
           DictMonadWriter@3((V(V@2))
                             (fun
                               (A) ->
                                 V@1(case A of
                                   {nothing} ->
                                     {tuple, {nothing}, identity()};
                                   {just, A@1} ->
                                     { tuple
                                     , {just, erlang:element(2, A@1)}
                                     , erlang:element(3, A@1)
                                     };
                                   _ ->
                                     erlang:error({ fail
                                                  , <<"Failed pattern match">>
                                                  })
                                 end)
                             end))
       end
     , 'Monoid0' =>
       fun
         (_) ->
           Monoid0
       end
     , 'MonadTell1' =>
       fun
         (_) ->
           MonadTellMaybeT1
       end
     }
  end.

monadThrowMaybeT() ->
  fun
    (DictMonadThrow) ->
      monadThrowMaybeT(DictMonadThrow)
  end.

monadThrowMaybeT(#{ 'Monad0' := DictMonadThrow, throwError := DictMonadThrow@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadThrow(undefined),
    MonadMaybeT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeMaybeT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindMaybeT(Monad0)
         end
       },
    #{ throwError =>
       fun
         (E) ->
           ((erlang:map_get(bind, Monad0@2(undefined)))(DictMonadThrow@1(E)))
           (fun
             (A_) ->
               (erlang:map_get(pure, Monad0@1(undefined)))({just, A_})
           end)
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadMaybeT1
       end
     }
  end.

monadErrorMaybeT() ->
  fun
    (DictMonadError) ->
      monadErrorMaybeT(DictMonadError)
  end.

monadErrorMaybeT(#{ 'MonadThrow0' := DictMonadError
                  , catchError := DictMonadError@1
                  }) ->
  begin
    MonadThrowMaybeT1 = monadThrowMaybeT(DictMonadError(undefined)),
    #{ catchError =>
       fun
         (V) ->
           fun
             (H) ->
               (DictMonadError@1(V))
               (fun
                 (A) ->
                   H(A)
               end)
           end
       end
     , 'MonadThrow0' =>
       fun
         (_) ->
           MonadThrowMaybeT1
       end
     }
  end.

monoidMaybeT() ->
  fun
    (DictMonad) ->
      monoidMaybeT(DictMonad)
  end.

monoidMaybeT(DictMonad) ->
  begin
    SemigroupMaybeT1 = semigroupMaybeT(DictMonad),
    fun
      (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
        begin
          SemigroupMaybeT2 = SemigroupMaybeT1(DictMonoid(undefined)),
          #{ mempty =>
             (erlang:map_get(pure, applicativeMaybeT(DictMonad)))(DictMonoid@1)
           , 'Semigroup0' =>
             fun
               (_) ->
                 SemigroupMaybeT2
             end
           }
        end
    end
  end.

altMaybeT() ->
  fun
    (DictMonad) ->
      altMaybeT(DictMonad)
  end.

altMaybeT(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    #{ 'Apply0' := Bind1, bind := Bind1@1 } = DictMonad@1(undefined),
    #{ map := V } = (erlang:map_get('Functor0', Bind1(undefined)))(undefined),
    FunctorMaybeT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 (V(fun
                    (V1) ->
                      case V1 of
                        {just, V1@1} ->
                          {just, F(V1@1)};
                        _ ->
                          {nothing}
                      end
                  end))
                 (V@1)
             end
         end
       },
    #{ alt =>
       fun
         (V@1) ->
           fun
             (V1) ->
               (Bind1@1(V@1))
               (fun
                 (M) ->
                   case M of
                     {nothing} ->
                       V1;
                     _ ->
                       begin
                         #{ 'Applicative0' := DictMonad@2 } = DictMonad,
                         (erlang:map_get(pure, DictMonad@2(undefined)))(M)
                       end
                   end
               end)
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorMaybeT1
       end
     }
  end.

plusMaybeT() ->
  fun
    (DictMonad) ->
      plusMaybeT(DictMonad)
  end.

plusMaybeT(DictMonad = #{ 'Applicative0' := DictMonad@1
                        , 'Bind1' := DictMonad@2
                        }) ->
  begin
    #{ 'Apply0' := Bind1, bind := Bind1@1 } = DictMonad@2(undefined),
    #{ map := V } = (erlang:map_get('Functor0', Bind1(undefined)))(undefined),
    AltMaybeT1 =
      begin
        FunctorMaybeT1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@1) ->
                     (V(fun
                        (V1) ->
                          case V1 of
                            {just, V1@1} ->
                              {just, F(V1@1)};
                            _ ->
                              {nothing}
                          end
                      end))
                     (V@1)
                 end
             end
           },
        #{ alt =>
           fun
             (V@1) ->
               fun
                 (V1) ->
                   (Bind1@1(V@1))
                   (fun
                     (M) ->
                       case M of
                         {nothing} ->
                           V1;
                         _ ->
                           begin
                             #{ 'Applicative0' := DictMonad@3 } = DictMonad,
                             (erlang:map_get(pure, DictMonad@3(undefined)))(M)
                           end
                       end
                   end)
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorMaybeT1
           end
         }
      end,
    #{ empty => (erlang:map_get(pure, DictMonad@1(undefined)))({nothing})
     , 'Alt0' =>
       fun
         (_) ->
           AltMaybeT1
       end
     }
  end.

alternativeMaybeT() ->
  fun
    (DictMonad) ->
      alternativeMaybeT(DictMonad)
  end.

alternativeMaybeT(DictMonad) ->
  begin
    ApplicativeMaybeT1 = applicativeMaybeT(DictMonad),
    PlusMaybeT1 = plusMaybeT(DictMonad),
    #{ 'Applicative0' =>
       fun
         (_) ->
           ApplicativeMaybeT1
       end
     , 'Plus1' =>
       fun
         (_) ->
           PlusMaybeT1
       end
     }
  end.

monadPlusMaybeT() ->
  fun
    (DictMonad) ->
      monadPlusMaybeT(DictMonad)
  end.

monadPlusMaybeT(DictMonad) ->
  begin
    MonadMaybeT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeMaybeT(DictMonad)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindMaybeT(DictMonad)
         end
       },
    AlternativeMaybeT1 = alternativeMaybeT(DictMonad),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadMaybeT1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeMaybeT1
       end
     }
  end.

monadZeroMaybeT() ->
  fun
    (DictMonad) ->
      monadZeroMaybeT(DictMonad)
  end.

monadZeroMaybeT(DictMonad) ->
  begin
    MonadMaybeT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeMaybeT(DictMonad)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindMaybeT(DictMonad)
         end
       },
    AlternativeMaybeT1 = alternativeMaybeT(DictMonad),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadMaybeT1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeMaybeT1
       end
     , 'MonadZeroIsDeprecated2' =>
       fun
         (_) ->
           undefined
       end
     }
  end.

