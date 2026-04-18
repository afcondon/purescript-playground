-module(control_monad_except_trans@ps).
-export([ identity/0
        , identity/1
        , 'ExceptT'/0
        , 'ExceptT'/1
        , withExceptT/0
        , withExceptT/3
        , runExceptT/0
        , runExceptT/1
        , newtypeExceptT/0
        , monadTransExceptT/0
        , mapExceptT/0
        , mapExceptT/2
        , functorExceptT/0
        , functorExceptT/1
        , except/0
        , except/2
        , monadExceptT/0
        , monadExceptT/1
        , bindExceptT/0
        , bindExceptT/1
        , applyExceptT/0
        , applyExceptT/1
        , applicativeExceptT/0
        , applicativeExceptT/1
        , semigroupExceptT/0
        , semigroupExceptT/1
        , monadAskExceptT/0
        , monadAskExceptT/1
        , monadReaderExceptT/0
        , monadReaderExceptT/1
        , monadContExceptT/0
        , monadContExceptT/1
        , monadEffectExceptT/0
        , monadEffectExceptT/1
        , monadRecExceptT/0
        , monadRecExceptT/1
        , monadStateExceptT/0
        , monadStateExceptT/1
        , monadTellExceptT/0
        , monadTellExceptT/1
        , monadWriterExceptT/0
        , monadWriterExceptT/1
        , monadThrowExceptT/0
        , monadThrowExceptT/1
        , monadErrorExceptT/0
        , monadErrorExceptT/1
        , monoidExceptT/0
        , monoidExceptT/1
        , altExceptT/0
        , altExceptT/2
        , plusExceptT/0
        , plusExceptT/1
        , alternativeExceptT/0
        , alternativeExceptT/1
        , monadPlusExceptT/0
        , monadPlusExceptT/1
        , monadZeroExceptT/0
        , monadZeroExceptT/1
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

'ExceptT'() ->
  fun
    (X) ->
      'ExceptT'(X)
  end.

'ExceptT'(X) ->
  X.

withExceptT() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (V) ->
              withExceptT(DictFunctor, F, V)
          end
      end
  end.

withExceptT(#{ map := DictFunctor }, F, V) ->
  (DictFunctor(fun
     (V2) ->
       case V2 of
         {right, V2@1} ->
           {right, V2@1};
         {left, V2@2} ->
           {left, F(V2@2)};
         _ ->
           erlang:error({fail, <<"Failed pattern match">>})
       end
   end))
  (V).

runExceptT() ->
  fun
    (V) ->
      runExceptT(V)
  end.

runExceptT(V) ->
  V.

newtypeExceptT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monadTransExceptT() ->
  #{ lift =>
     fun
       (#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
         fun
           (M) ->
             ((erlang:map_get(bind, DictMonad@1(undefined)))(M))
             (fun
               (A) ->
                 (erlang:map_get(pure, DictMonad(undefined)))({right, A})
             end)
         end
     end
   }.

mapExceptT() ->
  fun
    (F) ->
      fun
        (V) ->
          mapExceptT(F, V)
      end
  end.

mapExceptT(F, V) ->
  F(V).

functorExceptT() ->
  fun
    (DictFunctor) ->
      functorExceptT(DictFunctor)
  end.

functorExceptT(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         DictFunctor(fun
           (M) ->
             case M of
               {left, M@1} ->
                 {left, M@1};
               {right, M@2} ->
                 {right, F(M@2)};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end)
     end
   }.

except() ->
  fun
    (DictApplicative) ->
      fun
        (X) ->
          except(DictApplicative, X)
      end
  end.

except(#{ pure := DictApplicative }, X) ->
  DictApplicative(X).

monadExceptT() ->
  fun
    (DictMonad) ->
      monadExceptT(DictMonad)
  end.

monadExceptT(DictMonad) ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeExceptT(DictMonad)
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindExceptT(DictMonad)
     end
   }.

bindExceptT() ->
  fun
    (DictMonad) ->
      bindExceptT(DictMonad)
  end.

bindExceptT(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  #{ bind =>
     fun
       (V) ->
         fun
           (K) ->
             ((erlang:map_get(bind, DictMonad@1(undefined)))(V))
             (fun
               (V2) ->
                 case V2 of
                   {left, V2@1} ->
                     begin
                       #{ 'Applicative0' := DictMonad@2 } = DictMonad,
                       (erlang:map_get(pure, DictMonad@2(undefined)))
                       ({left, V2@1})
                     end;
                   {right, V2@2} ->
                     K(V2@2);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end)
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyExceptT(DictMonad)
     end
   }.

applyExceptT() ->
  fun
    (DictMonad) ->
      applyExceptT(DictMonad)
  end.

applyExceptT(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    #{ map := V } =
      (erlang:map_get(
         'Functor0',
         (erlang:map_get('Apply0', DictMonad@1(undefined)))(undefined)
       ))
      (undefined),
    FunctorExceptT1 =
      #{ map =>
         fun
           (F) ->
             V(fun
               (M) ->
                 case M of
                   {left, M@1} ->
                     {left, M@1};
                   {right, M@2} ->
                     {right, F(M@2)};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end)
         end
       },
    #{ apply =>
       begin
         #{ bind := V@1 } = bindExceptT(DictMonad),
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
                         (erlang:map_get(pure, applicativeExceptT(DictMonad)))
                         (F_(A_))
                     end)
                 end)
             end
         end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorExceptT1
       end
     }
  end.

applicativeExceptT() ->
  fun
    (DictMonad) ->
      applicativeExceptT(DictMonad)
  end.

applicativeExceptT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  #{ pure =>
     fun
       (X) ->
         (erlang:map_get(pure, DictMonad@1(undefined)))({right, X})
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyExceptT(DictMonad)
     end
   }.

semigroupExceptT() ->
  fun
    (DictMonad) ->
      semigroupExceptT(DictMonad)
  end.

semigroupExceptT(DictMonad) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = applyExceptT(DictMonad),
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

monadAskExceptT() ->
  fun
    (DictMonadAsk) ->
      monadAskExceptT(DictMonadAsk)
  end.

monadAskExceptT(#{ 'Monad0' := DictMonadAsk, ask := DictMonadAsk@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadAsk(undefined),
    MonadExceptT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeExceptT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindExceptT(Monad0)
         end
       },
    #{ ask =>
       ((erlang:map_get(bind, Monad0@2(undefined)))(DictMonadAsk@1))
       (fun
         (A) ->
           (erlang:map_get(pure, Monad0@1(undefined)))({right, A})
       end)
     , 'Monad0' =>
       fun
         (_) ->
           MonadExceptT1
       end
     }
  end.

monadReaderExceptT() ->
  fun
    (DictMonadReader) ->
      monadReaderExceptT(DictMonadReader)
  end.

monadReaderExceptT(#{ 'MonadAsk0' := DictMonadReader
                    , local := DictMonadReader@1
                    }) ->
  begin
    MonadAskExceptT1 = monadAskExceptT(DictMonadReader(undefined)),
    #{ local =>
       fun
         (F) ->
           DictMonadReader@1(F)
       end
     , 'MonadAsk0' =>
       fun
         (_) ->
           MonadAskExceptT1
       end
     }
  end.

monadContExceptT() ->
  fun
    (DictMonadCont) ->
      monadContExceptT(DictMonadCont)
  end.

monadContExceptT(#{ 'Monad0' := DictMonadCont, callCC := DictMonadCont@1 }) ->
  begin
    V = DictMonadCont(undefined),
    MonadExceptT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeExceptT(V)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindExceptT(V)
         end
       },
    #{ callCC =>
       fun
         (F) ->
           DictMonadCont@1(fun
             (C) ->
               F(fun
                 (A) ->
                   C({right, A})
               end)
           end)
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadExceptT1
       end
     }
  end.

monadEffectExceptT() ->
  fun
    (DictMonadEffect) ->
      monadEffectExceptT(DictMonadEffect)
  end.

monadEffectExceptT(#{ 'Monad0' := DictMonadEffect
                    , liftEffect := DictMonadEffect@1
                    }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadEffect(undefined),
    MonadExceptT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeExceptT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindExceptT(Monad0)
         end
       },
    #{ liftEffect =>
       fun
         (X) ->
           ((erlang:map_get(bind, Monad0@2(undefined)))(DictMonadEffect@1(X)))
           (fun
             (A) ->
               (erlang:map_get(pure, Monad0@1(undefined)))({right, A})
           end)
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadExceptT1
       end
     }
  end.

monadRecExceptT() ->
  fun
    (DictMonadRec) ->
      monadRecExceptT(DictMonadRec)
  end.

monadRecExceptT(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadRec(undefined),
    MonadExceptT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeExceptT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindExceptT(Monad0)
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
                     {left, M_@1} ->
                       {done, {left, M_@1}};
                     {right, M_@2} ->
                       case M_@2 of
                         {loop, M_@3} ->
                           {loop, M_@3};
                         {done, M_@4} ->
                           {done, {right, M_@4}};
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
           MonadExceptT1
       end
     }
  end.

monadStateExceptT() ->
  fun
    (DictMonadState) ->
      monadStateExceptT(DictMonadState)
  end.

monadStateExceptT(#{ 'Monad0' := DictMonadState, state := DictMonadState@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadState(undefined),
    MonadExceptT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeExceptT(Monad0)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindExceptT(Monad0)
         end
       },
    #{ state =>
       fun
         (F) ->
           ((erlang:map_get(bind, Monad0@2(undefined)))(DictMonadState@1(F)))
           (fun
             (A) ->
               (erlang:map_get(pure, Monad0@1(undefined)))({right, A})
           end)
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadExceptT1
       end
     }
  end.

monadTellExceptT() ->
  fun
    (DictMonadTell) ->
      monadTellExceptT(DictMonadTell)
  end.

monadTellExceptT(#{ 'Monad1' := DictMonadTell
                  , 'Semigroup0' := DictMonadTell@1
                  , tell := DictMonadTell@2
                  }) ->
  begin
    Monad1 = #{ 'Applicative0' := Monad1@1, 'Bind1' := Monad1@2 } =
      DictMonadTell(undefined),
    Semigroup0 = DictMonadTell@1(undefined),
    MonadExceptT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeExceptT(Monad1)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindExceptT(Monad1)
         end
       },
    #{ tell =>
       fun
         (X) ->
           ((erlang:map_get(bind, Monad1@2(undefined)))(DictMonadTell@2(X)))
           (fun
             (A) ->
               (erlang:map_get(pure, Monad1@1(undefined)))({right, A})
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
           MonadExceptT1
       end
     }
  end.

monadWriterExceptT() ->
  fun
    (DictMonadWriter) ->
      monadWriterExceptT(DictMonadWriter)
  end.

monadWriterExceptT(#{ 'MonadTell1' := DictMonadWriter
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
    MonadTellExceptT1 = monadTellExceptT(MonadTell1),
    #{ listen =>
       fun
         (V@2) ->
           (V(DictMonadWriter@2(V@2)))
           (fun
             (V@3) ->
               V@1(case erlang:element(2, V@3) of
                 {left, _} ->
                   {left, erlang:element(2, erlang:element(2, V@3))};
                 {right, _} ->
                   { right
                   , { tuple
                     , erlang:element(2, erlang:element(2, V@3))
                     , erlang:element(3, V@3)
                     }
                   };
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
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
                                   {left, A@1} ->
                                     {tuple, {left, A@1}, identity()};
                                   {right, A@2} ->
                                     { tuple
                                     , {right, erlang:element(2, A@2)}
                                     , erlang:element(3, A@2)
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
           MonadTellExceptT1
       end
     }
  end.

monadThrowExceptT() ->
  fun
    (DictMonad) ->
      monadThrowExceptT(DictMonad)
  end.

monadThrowExceptT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    MonadExceptT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             applicativeExceptT(DictMonad)
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindExceptT(DictMonad)
         end
       },
    #{ throwError =>
       fun
         (X) ->
           (erlang:map_get(pure, DictMonad@1(undefined)))({left, X})
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadExceptT1
       end
     }
  end.

monadErrorExceptT() ->
  fun
    (DictMonad) ->
      monadErrorExceptT(DictMonad)
  end.

monadErrorExceptT(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    MonadThrowExceptT1 = monadThrowExceptT(DictMonad),
    #{ catchError =>
       fun
         (V) ->
           fun
             (K) ->
               ((erlang:map_get(bind, DictMonad@1(undefined)))(V))
               (fun
                 (V2) ->
                   case V2 of
                     {left, V2@1} ->
                       K(V2@1);
                     {right, V2@2} ->
                       begin
                         #{ 'Applicative0' := DictMonad@2 } = DictMonad,
                         (erlang:map_get(pure, DictMonad@2(undefined)))
                         ({right, V2@2})
                       end;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end)
           end
       end
     , 'MonadThrow0' =>
       fun
         (_) ->
           MonadThrowExceptT1
       end
     }
  end.

monoidExceptT() ->
  fun
    (DictMonad) ->
      monoidExceptT(DictMonad)
  end.

monoidExceptT(DictMonad) ->
  begin
    SemigroupExceptT1 = semigroupExceptT(DictMonad),
    fun
      (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
        begin
          SemigroupExceptT2 = SemigroupExceptT1(DictMonoid(undefined)),
          #{ mempty =>
             (erlang:map_get(pure, applicativeExceptT(DictMonad)))(DictMonoid@1)
           , 'Semigroup0' =>
             fun
               (_) ->
                 SemigroupExceptT2
             end
           }
        end
    end
  end.

altExceptT() ->
  fun
    (DictSemigroup) ->
      fun
        (DictMonad) ->
          altExceptT(DictSemigroup, DictMonad)
      end
  end.

altExceptT( DictSemigroup
          , #{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }
          ) ->
  begin
    Bind1 = #{ 'Apply0' := Bind1@1, bind := Bind1@2 } = DictMonad@1(undefined),
    #{ pure := V } = DictMonad(undefined),
    #{ map := V@1 } =
      (erlang:map_get('Functor0', Bind1@1(undefined)))(undefined),
    FunctorExceptT1 =
      #{ map =>
         fun
           (F) ->
             V@1(fun
               (M) ->
                 case M of
                   {left, M@1} ->
                     {left, M@1};
                   {right, M@2} ->
                     {right, F(M@2)};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end)
         end
       },
    #{ alt =>
       fun
         (V@2) ->
           fun
             (V1) ->
               (Bind1@2(V@2))
               (fun
                 (Rm) ->
                   case Rm of
                     {right, Rm@1} ->
                       V({right, Rm@1});
                     {left, Rm@2} ->
                       begin
                         #{ bind := Bind1@3 } = Bind1,
                         (Bind1@3(V1))
                         (fun
                           (Rn) ->
                             case Rn of
                               {right, Rn@1} ->
                                 V({right, Rn@1});
                               {left, Rn@2} ->
                                 begin
                                   #{ append := DictSemigroup@1 } =
                                     DictSemigroup,
                                   V({left, (DictSemigroup@1(Rm@2))(Rn@2)})
                                 end;
                               _ ->
                                 erlang:error({fail, <<"Failed pattern match">>})
                             end
                         end)
                       end;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end)
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorExceptT1
       end
     }
  end.

plusExceptT() ->
  fun
    (DictMonoid) ->
      plusExceptT(DictMonoid)
  end.

plusExceptT(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    AltExceptT1 = (altExceptT())(DictMonoid(undefined)),
    fun
      (DictMonad) ->
        begin
          AltExceptT2 = AltExceptT1(DictMonad),
          #{ empty =>
             (erlang:map_get(throwError, monadThrowExceptT(DictMonad)))
             (DictMonoid@1)
           , 'Alt0' =>
             fun
               (_) ->
                 AltExceptT2
             end
           }
        end
    end
  end.

alternativeExceptT() ->
  fun
    (DictMonoid) ->
      alternativeExceptT(DictMonoid)
  end.

alternativeExceptT(DictMonoid) ->
  begin
    PlusExceptT1 = plusExceptT(DictMonoid),
    fun
      (DictMonad) ->
        begin
          ApplicativeExceptT1 = applicativeExceptT(DictMonad),
          PlusExceptT2 = PlusExceptT1(DictMonad),
          #{ 'Applicative0' =>
             fun
               (_) ->
                 ApplicativeExceptT1
             end
           , 'Plus1' =>
             fun
               (_) ->
                 PlusExceptT2
             end
           }
        end
    end
  end.

monadPlusExceptT() ->
  fun
    (DictMonoid) ->
      monadPlusExceptT(DictMonoid)
  end.

monadPlusExceptT(DictMonoid) ->
  begin
    AlternativeExceptT1 = alternativeExceptT(DictMonoid),
    fun
      (DictMonad) ->
        begin
          MonadExceptT1 =
            #{ 'Applicative0' =>
               fun
                 (_) ->
                   applicativeExceptT(DictMonad)
               end
             , 'Bind1' =>
               fun
                 (_) ->
                   bindExceptT(DictMonad)
               end
             },
          AlternativeExceptT2 = AlternativeExceptT1(DictMonad),
          #{ 'Monad0' =>
             fun
               (_) ->
                 MonadExceptT1
             end
           , 'Alternative1' =>
             fun
               (_) ->
                 AlternativeExceptT2
             end
           }
        end
    end
  end.

monadZeroExceptT() ->
  fun
    (DictMonoid) ->
      monadZeroExceptT(DictMonoid)
  end.

monadZeroExceptT(DictMonoid) ->
  begin
    AlternativeExceptT1 = alternativeExceptT(DictMonoid),
    fun
      (DictMonad) ->
        begin
          MonadExceptT1 =
            #{ 'Applicative0' =>
               fun
                 (_) ->
                   applicativeExceptT(DictMonad)
               end
             , 'Bind1' =>
               fun
                 (_) ->
                   bindExceptT(DictMonad)
               end
             },
          AlternativeExceptT2 = AlternativeExceptT1(DictMonad),
          #{ 'Monad0' =>
             fun
               (_) ->
                 MonadExceptT1
             end
           , 'Alternative1' =>
             fun
               (_) ->
                 AlternativeExceptT2
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

