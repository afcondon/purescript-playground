-module(data_profunctor_star@ps).
-export([ 'Star'/0
        , 'Star'/1
        , semigroupoidStar/0
        , semigroupoidStar/1
        , profunctorStar/0
        , profunctorStar/1
        , strongStar/0
        , strongStar/1
        , newtypeStar/0
        , invariantStar/0
        , invariantStar/1
        , hoistStar/0
        , hoistStar/3
        , functorStar/0
        , functorStar/1
        , distributiveStar/0
        , distributiveStar/1
        , closedStar/0
        , closedStar/1
        , choiceStar/0
        , choiceStar/1
        , categoryStar/0
        , categoryStar/1
        , applyStar/0
        , applyStar/1
        , bindStar/0
        , bindStar/1
        , applicativeStar/0
        , applicativeStar/1
        , monadStar/0
        , monadStar/1
        , altStar/0
        , altStar/1
        , plusStar/0
        , plusStar/1
        , alternativeStar/0
        , alternativeStar/1
        , monadPlusStar/0
        , monadPlusStar/1
        , monadZeroStar/0
        , monadZeroStar/1
        ]).
-compile(no_auto_import).
'Star'() ->
  fun
    (X) ->
      'Star'(X)
  end.

'Star'(X) ->
  X.

semigroupoidStar() ->
  fun
    (DictBind) ->
      semigroupoidStar(DictBind)
  end.

semigroupoidStar(#{ bind := DictBind }) ->
  #{ compose =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (X) ->
                 (DictBind(V1(X)))(V)
             end
         end
     end
   }.

profunctorStar() ->
  fun
    (DictFunctor) ->
      profunctorStar(DictFunctor)
  end.

profunctorStar(#{ map := DictFunctor }) ->
  #{ dimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 begin
                   V@1 = DictFunctor(G),
                   fun
                     (X) ->
                       V@1(V(F(X)))
                   end
                 end
             end
         end
     end
   }.

strongStar() ->
  fun
    (DictFunctor) ->
      strongStar(DictFunctor)
  end.

strongStar(#{ map := DictFunctor }) ->
  begin
    ProfunctorStar1 =
      #{ dimap =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (V) ->
                     begin
                       V@1 = DictFunctor(G),
                       fun
                         (X) ->
                           V@1(V(F(X)))
                       end
                     end
                 end
             end
         end
       },
    #{ first =>
       fun
         (V) ->
           fun
             (V1) ->
               begin
                 V@1 = erlang:element(3, V1),
                 (DictFunctor(fun
                    (V2) ->
                      {tuple, V2, V@1}
                  end))
                 (V(erlang:element(2, V1)))
               end
           end
       end
     , second =>
       fun
         (V) ->
           fun
             (V1) ->
               (DictFunctor((data_tuple@ps:'Tuple'())(erlang:element(2, V1))))
               (V(erlang:element(3, V1)))
           end
       end
     , 'Profunctor0' =>
       fun
         (_) ->
           ProfunctorStar1
       end
     }
  end.

newtypeStar() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

invariantStar() ->
  fun
    (DictInvariant) ->
      invariantStar(DictInvariant)
  end.

invariantStar(#{ imap := DictInvariant }) ->
  #{ imap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 begin
                   V@1 = (DictInvariant(F))(G),
                   fun
                     (X) ->
                       V@1(V(X))
                   end
                 end
             end
         end
     end
   }.

hoistStar() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (X) ->
              hoistStar(F, V, X)
          end
      end
  end.

hoistStar(F, V, X) ->
  F(V(X)).

functorStar() ->
  fun
    (DictFunctor) ->
      functorStar(DictFunctor)
  end.

functorStar(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             begin
               V@1 = DictFunctor(F),
               fun
                 (X) ->
                   V@1(V(X))
               end
             end
         end
     end
   }.

distributiveStar() ->
  fun
    (DictDistributive) ->
      distributiveStar(DictDistributive)
  end.

distributiveStar(DictDistributive = #{ 'Functor0' := DictDistributive@1
                                     , collect := DictDistributive@2
                                     }) ->
  begin
    #{ map := V } = DictDistributive@1(undefined),
    FunctorStar1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 begin
                   V@2 = V(F),
                   fun
                     (X) ->
                       V@2(V@1(X))
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
               (F) ->
                 fun
                   (A) ->
                     (Collect1(fun
                        (V@1) ->
                          V@1(A)
                      end))
                     (F)
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
                      distributiveStar(DictDistributive)
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
           FunctorStar1
       end
     }
  end.

closedStar() ->
  fun
    (DictDistributive) ->
      closedStar(DictDistributive)
  end.

closedStar(#{ 'Functor0' := DictDistributive, distribute := DictDistributive@1 }) ->
  begin
    Distribute = DictDistributive@1(data_functor@ps:functorFn()),
    #{ map := V } = DictDistributive(undefined),
    ProfunctorStar1 =
      #{ dimap =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (V@1) ->
                     begin
                       V@2 = V(G),
                       fun
                         (X) ->
                           V@2(V@1(F(X)))
                       end
                     end
                 end
             end
         end
       },
    #{ closed =>
       fun
         (V@1) ->
           fun
             (G) ->
               Distribute(fun
                 (X) ->
                   V@1(G(X))
               end)
           end
       end
     , 'Profunctor0' =>
       fun
         (_) ->
           ProfunctorStar1
       end
     }
  end.

choiceStar() ->
  fun
    (DictApplicative) ->
      choiceStar(DictApplicative)
  end.

choiceStar(DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
  begin
    #{ map := Functor0 } =
      (erlang:map_get('Functor0', DictApplicative@1(undefined)))(undefined),
    ProfunctorStar1 =
      #{ dimap =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (V) ->
                     begin
                       V@1 = Functor0(G),
                       fun
                         (X) ->
                           V@1(V(F(X)))
                       end
                     end
                 end
             end
         end
       },
    #{ left =>
       fun
         (V) ->
           begin
             V@1 = Functor0(data_either@ps:'Left'()),
             fun
               (V2) ->
                 case V2 of
                   {left, V2@1} ->
                     V@1(V(V2@1));
                   {right, V2@2} ->
                     begin
                       #{ pure := DictApplicative@2 } = DictApplicative,
                       DictApplicative@2({right, V2@2})
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
           end
       end
     , right =>
       fun
         (V) ->
           begin
             V@1 = Functor0(data_either@ps:'Right'()),
             fun
               (V2) ->
                 case V2 of
                   {left, V2@1} ->
                     begin
                       #{ pure := DictApplicative@2 } = DictApplicative,
                       DictApplicative@2({left, V2@1})
                     end;
                   {right, V2@2} ->
                     V@1(V(V2@2));
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
           end
       end
     , 'Profunctor0' =>
       fun
         (_) ->
           ProfunctorStar1
       end
     }
  end.

categoryStar() ->
  fun
    (DictMonad) ->
      categoryStar(DictMonad)
  end.

categoryStar(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
  begin
    #{ bind := V } = DictMonad@1(undefined),
    SemigroupoidStar1 =
      #{ compose =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 fun
                   (X) ->
                     (V(V1(X)))(V@1)
                 end
             end
         end
       },
    #{ identity => erlang:map_get(pure, DictMonad(undefined))
     , 'Semigroupoid0' =>
       fun
         (_) ->
           SemigroupoidStar1
       end
     }
  end.

applyStar() ->
  fun
    (DictApply) ->
      applyStar(DictApply)
  end.

applyStar(#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
  begin
    #{ map := V } = DictApply(undefined),
    FunctorStar1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 begin
                   V@2 = V(F),
                   fun
                     (X) ->
                       V@2(V@1(X))
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
                 (A) ->
                   (DictApply@1(V@1(A)))(V1(A))
               end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorStar1
       end
     }
  end.

bindStar() ->
  fun
    (DictBind) ->
      bindStar(DictBind)
  end.

bindStar(#{ 'Apply0' := DictBind, bind := DictBind@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictBind(undefined),
    #{ map := V@2 } = V(undefined),
    ApplyStar1 =
      begin
        FunctorStar1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@3) ->
                     begin
                       V@4 = V@2(F),
                       fun
                         (X) ->
                           V@4(V@3(X))
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
                     (A) ->
                       (V@1(V@3(A)))(V1(A))
                   end
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorStar1
           end
         }
      end,
    #{ bind =>
       fun
         (V@3) ->
           fun
             (F) ->
               fun
                 (X) ->
                   (DictBind@1(V@3(X)))
                   (fun
                     (A) ->
                       (F(A))(X)
                   end)
               end
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyStar1
       end
     }
  end.

applicativeStar() ->
  fun
    (DictApplicative) ->
      applicativeStar(DictApplicative)
  end.

applicativeStar(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    #{ map := V@2 } = V(undefined),
    ApplyStar1 =
      begin
        FunctorStar1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@3) ->
                     begin
                       V@4 = V@2(F),
                       fun
                         (X) ->
                           V@4(V@3(X))
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
                     (A) ->
                       (V@1(V@3(A)))(V1(A))
                   end
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorStar1
           end
         }
      end,
    #{ pure =>
       fun
         (A) ->
           fun
             (_) ->
               DictApplicative@1(A)
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyStar1
       end
     }
  end.

monadStar() ->
  fun
    (DictMonad) ->
      monadStar(DictMonad)
  end.

monadStar(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
  begin
    #{ 'Apply0' := V, pure := V@1 } = DictMonad(undefined),
    #{ 'Functor0' := V@2, apply := V@3 } = V(undefined),
    ApplicativeStar1 =
      begin
        #{ map := V@4 } = V@2(undefined),
        FunctorStar1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@5) ->
                     begin
                       V@6 = V@4(F),
                       fun
                         (X) ->
                           V@6(V@5(X))
                       end
                     end
                 end
             end
           },
        ApplyStar1 =
          #{ apply =>
             fun
               (V@5) ->
                 fun
                   (V1) ->
                     fun
                       (A) ->
                         (V@3(V@5(A)))(V1(A))
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorStar1
             end
           },
        #{ pure =>
           fun
             (A) ->
               fun
                 (_) ->
                   V@1(A)
               end
           end
         , 'Apply0' =>
           fun
             (_) ->
               ApplyStar1
           end
         }
      end,
    BindStar1 = bindStar(DictMonad@1(undefined)),
    #{ 'Applicative0' =>
       fun
         (_) ->
           ApplicativeStar1
       end
     , 'Bind1' =>
       fun
         (_) ->
           BindStar1
       end
     }
  end.

altStar() ->
  fun
    (DictAlt) ->
      altStar(DictAlt)
  end.

altStar(#{ 'Functor0' := DictAlt, alt := DictAlt@1 }) ->
  begin
    #{ map := V } = DictAlt(undefined),
    FunctorStar1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 begin
                   V@2 = V(F),
                   fun
                     (X) ->
                       V@2(V@1(X))
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
                 (A) ->
                   (DictAlt@1(V@1(A)))(V1(A))
               end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorStar1
       end
     }
  end.

plusStar() ->
  fun
    (DictPlus) ->
      plusStar(DictPlus)
  end.

plusStar(#{ 'Alt0' := DictPlus, empty := DictPlus@1 }) ->
  begin
    #{ 'Functor0' := V, alt := V@1 } = DictPlus(undefined),
    #{ map := V@2 } = V(undefined),
    AltStar1 =
      begin
        FunctorStar1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@3) ->
                     begin
                       V@4 = V@2(F),
                       fun
                         (X) ->
                           V@4(V@3(X))
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
                     (A) ->
                       (V@1(V@3(A)))(V1(A))
                   end
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorStar1
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
           AltStar1
       end
     }
  end.

alternativeStar() ->
  fun
    (DictAlternative) ->
      alternativeStar(DictAlternative)
  end.

alternativeStar(#{ 'Applicative0' := DictAlternative
                 , 'Plus1' := DictAlternative@1
                 }) ->
  begin
    #{ 'Apply0' := V, pure := V@1 } = DictAlternative(undefined),
    #{ 'Functor0' := V@2, apply := V@3 } = V(undefined),
    ApplicativeStar1 =
      begin
        #{ map := V@4 } = V@2(undefined),
        FunctorStar1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@5) ->
                     begin
                       V@6 = V@4(F),
                       fun
                         (X) ->
                           V@6(V@5(X))
                       end
                     end
                 end
             end
           },
        ApplyStar1 =
          #{ apply =>
             fun
               (V@5) ->
                 fun
                   (V1) ->
                     fun
                       (A) ->
                         (V@3(V@5(A)))(V1(A))
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorStar1
             end
           },
        #{ pure =>
           fun
             (A) ->
               fun
                 (_) ->
                   V@1(A)
               end
           end
         , 'Apply0' =>
           fun
             (_) ->
               ApplyStar1
           end
         }
      end,
    #{ 'Alt0' := V@5, empty := V@6 } = DictAlternative@1(undefined),
    PlusStar1 =
      begin
        #{ 'Functor0' := V@7, alt := V@8 } = V@5(undefined),
        #{ map := V@9 } = V@7(undefined),
        FunctorStar1@1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@10) ->
                     begin
                       V@11 = V@9(F),
                       fun
                         (X) ->
                           V@11(V@10(X))
                       end
                     end
                 end
             end
           },
        AltStar1 =
          #{ alt =>
             fun
               (V@10) ->
                 fun
                   (V1) ->
                     fun
                       (A) ->
                         (V@8(V@10(A)))(V1(A))
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorStar1@1
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
               AltStar1
           end
         }
      end,
    #{ 'Applicative0' =>
       fun
         (_) ->
           ApplicativeStar1
       end
     , 'Plus1' =>
       fun
         (_) ->
           PlusStar1
       end
     }
  end.

monadPlusStar() ->
  fun
    (DictMonadPlus) ->
      monadPlusStar(DictMonadPlus)
  end.

monadPlusStar(#{ 'Alternative1' := DictMonadPlus, 'Monad0' := DictMonadPlus@1 }) ->
  begin
    MonadStar1 = monadStar(DictMonadPlus@1(undefined)),
    AlternativeStar1 = alternativeStar(DictMonadPlus(undefined)),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadStar1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeStar1
       end
     }
  end.

monadZeroStar() ->
  fun
    (DictMonadZero) ->
      monadZeroStar(DictMonadZero)
  end.

monadZeroStar(#{ 'Alternative1' := DictMonadZero, 'Monad0' := DictMonadZero@1 }) ->
  begin
    MonadStar1 = monadStar(DictMonadZero@1(undefined)),
    AlternativeStar1 = alternativeStar(DictMonadZero(undefined)),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadStar1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeStar1
       end
     , 'MonadZeroIsDeprecated2' =>
       fun
         (_) ->
           undefined
       end
     }
  end.

