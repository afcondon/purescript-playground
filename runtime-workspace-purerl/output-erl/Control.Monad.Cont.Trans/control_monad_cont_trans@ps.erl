-module(control_monad_cont_trans@ps).
-export([ 'ContT'/0
        , 'ContT'/1
        , withContT/0
        , withContT/3
        , runContT/0
        , runContT/2
        , newtypeContT/0
        , monadTransContT/0
        , mapContT/0
        , mapContT/3
        , functorContT/0
        , functorContT/1
        , applyContT/0
        , applyContT/1
        , bindContT/0
        , bindContT/1
        , semigroupContT/0
        , semigroupContT/2
        , applicativeContT/0
        , applicativeContT/1
        , monadContT/0
        , monadContT/1
        , monadAskContT/0
        , monadAskContT/1
        , monadReaderContT/0
        , monadReaderContT/1
        , monadContContT/0
        , monadContContT/1
        , monadEffectContT/0
        , monadEffectContT/1
        , monadStateContT/0
        , monadStateContT/1
        , monoidContT/0
        , monoidContT/2
        ]).
-compile(no_auto_import).
'ContT'() ->
  fun
    (X) ->
      'ContT'(X)
  end.

'ContT'(X) ->
  X.

withContT() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (K) ->
              withContT(F, V, K)
          end
      end
  end.

withContT(F, V, K) ->
  V(F(K)).

runContT() ->
  fun
    (V) ->
      fun
        (K) ->
          runContT(V, K)
      end
  end.

runContT(V, K) ->
  V(K).

newtypeContT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monadTransContT() ->
  #{ lift =>
     fun
       (#{ 'Bind1' := DictMonad }) ->
         erlang:map_get(bind, DictMonad(undefined))
     end
   }.

mapContT() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (K) ->
              mapContT(F, V, K)
          end
      end
  end.

mapContT(F, V, K) ->
  F(V(K)).

functorContT() ->
  fun
    (DictFunctor) ->
      functorContT(DictFunctor)
  end.

functorContT(_) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (K) ->
                 V(fun
                   (A) ->
                     K(F(A))
                 end)
             end
         end
     end
   }.

applyContT() ->
  fun
    (DictApply) ->
      applyContT(DictApply)
  end.

applyContT(_) ->
  begin
    FunctorContT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V) ->
                 fun
                   (K) ->
                     V(fun
                       (A) ->
                         K(F(A))
                     end)
                 end
             end
         end
       },
    #{ apply =>
       fun
         (V) ->
           fun
             (V1) ->
               fun
                 (K) ->
                   V(fun
                     (G) ->
                       V1(fun
                         (A) ->
                           K(G(A))
                       end)
                   end)
               end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorContT1
       end
     }
  end.

bindContT() ->
  fun
    (DictBind) ->
      bindContT(DictBind)
  end.

bindContT(_) ->
  begin
    FunctorContT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V) ->
                 fun
                   (K) ->
                     V(fun
                       (A) ->
                         K(F(A))
                     end)
                 end
             end
         end
       },
    ApplyContT1 =
      #{ apply =>
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (K) ->
                     V(fun
                       (G) ->
                         V1(fun
                           (A) ->
                             K(G(A))
                         end)
                     end)
                 end
             end
         end
       , 'Functor0' =>
         fun
           (_) ->
             FunctorContT1
         end
       },
    #{ bind =>
       fun
         (V) ->
           fun
             (K) ->
               fun
                 (K_) ->
                   V(fun
                     (A) ->
                       (K(A))(K_)
                   end)
               end
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyContT1
       end
     }
  end.

semigroupContT() ->
  fun
    (DictApply) ->
      fun
        (DictSemigroup) ->
          semigroupContT(DictApply, DictSemigroup)
      end
  end.

semigroupContT(_, #{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (A) ->
         fun
           (B) ->
             fun
               (K) ->
                 A(fun
                   (A@1) ->
                     begin
                       V = DictSemigroup(A@1),
                       B(fun
                         (A@2) ->
                           K(V(A@2))
                       end)
                     end
                 end)
             end
         end
     end
   }.

applicativeContT() ->
  fun
    (DictApplicative) ->
      applicativeContT(DictApplicative)
  end.

applicativeContT(_) ->
  begin
    FunctorContT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V) ->
                 fun
                   (K) ->
                     V(fun
                       (A) ->
                         K(F(A))
                     end)
                 end
             end
         end
       },
    ApplyContT1 =
      #{ apply =>
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (K) ->
                     V(fun
                       (G) ->
                         V1(fun
                           (A) ->
                             K(G(A))
                         end)
                     end)
                 end
             end
         end
       , 'Functor0' =>
         fun
           (_) ->
             FunctorContT1
         end
       },
    #{ pure =>
       fun
         (A) ->
           fun
             (K) ->
               K(A)
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyContT1
       end
     }
  end.

monadContT() ->
  fun
    (DictMonad) ->
      monadContT(DictMonad)
  end.

monadContT(_) ->
  begin
    FunctorContT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V) ->
                 fun
                   (K) ->
                     V(fun
                       (A) ->
                         K(F(A))
                     end)
                 end
             end
         end
       },
    ApplicativeContT1 =
      begin
        ApplyContT1 =
          #{ apply =>
             fun
               (V) ->
                 fun
                   (V1) ->
                     fun
                       (K) ->
                         V(fun
                           (G) ->
                             V1(fun
                               (A) ->
                                 K(G(A))
                             end)
                         end)
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorContT1
             end
           },
        #{ pure =>
           fun
             (A) ->
               fun
                 (K) ->
                   K(A)
               end
           end
         , 'Apply0' =>
           fun
             (_) ->
               ApplyContT1
           end
         }
      end,
    FunctorContT1@1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V) ->
                 fun
                   (K) ->
                     V(fun
                       (A) ->
                         K(F(A))
                     end)
                 end
             end
         end
       },
    BindContT1 =
      begin
        ApplyContT1@1 =
          #{ apply =>
             fun
               (V) ->
                 fun
                   (V1) ->
                     fun
                       (K) ->
                         V(fun
                           (G) ->
                             V1(fun
                               (A) ->
                                 K(G(A))
                             end)
                         end)
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorContT1@1
             end
           },
        #{ bind =>
           fun
             (V) ->
               fun
                 (K) ->
                   fun
                     (K_) ->
                       V(fun
                         (A) ->
                           (K(A))(K_)
                       end)
                   end
               end
           end
         , 'Apply0' =>
           fun
             (_) ->
               ApplyContT1@1
           end
         }
      end,
    #{ 'Applicative0' =>
       fun
         (_) ->
           ApplicativeContT1
       end
     , 'Bind1' =>
       fun
         (_) ->
           BindContT1
       end
     }
  end.

monadAskContT() ->
  fun
    (DictMonadAsk) ->
      monadAskContT(DictMonadAsk)
  end.

monadAskContT(#{ 'Monad0' := DictMonadAsk, ask := DictMonadAsk@1 }) ->
  begin
    Monad0 = #{ 'Bind1' := Monad0@1 } = DictMonadAsk(undefined),
    MonadContT1 = monadContT(Monad0),
    #{ ask => (erlang:map_get(bind, Monad0@1(undefined)))(DictMonadAsk@1)
     , 'Monad0' =>
       fun
         (_) ->
           MonadContT1
       end
     }
  end.

monadReaderContT() ->
  fun
    (DictMonadReader) ->
      monadReaderContT(DictMonadReader)
  end.

monadReaderContT(#{ 'MonadAsk0' := DictMonadReader, local := DictMonadReader@1 }) ->
  begin
    MonadAsk0 = #{ 'Monad0' := MonadAsk0@1, ask := MonadAsk0@2 } =
      DictMonadReader(undefined),
    MonadAskContT1 = monadAskContT(MonadAsk0),
    #{ local =>
       fun
         (F) ->
           fun
             (V) ->
               fun
                 (K) ->
                   ((erlang:map_get(
                       bind,
                       (erlang:map_get('Bind1', MonadAsk0@1(undefined)))
                       (undefined)
                     ))
                    (MonadAsk0@2))
                   (fun
                     (R) ->
                       (DictMonadReader@1(F))
                       (V(begin
                          V@1 =
                            DictMonadReader@1(fun
                              (_) ->
                                R
                            end),
                          fun
                            (X) ->
                              V@1(K(X))
                          end
                        end))
                   end)
               end
           end
       end
     , 'MonadAsk0' =>
       fun
         (_) ->
           MonadAskContT1
       end
     }
  end.

monadContContT() ->
  fun
    (DictMonad) ->
      monadContContT(DictMonad)
  end.

monadContContT(DictMonad) ->
  begin
    MonadContT1 = monadContT(DictMonad),
    #{ callCC =>
       fun
         (F) ->
           fun
             (K) ->
               (F(fun
                  (A) ->
                    fun
                      (_) ->
                        K(A)
                    end
                end))
               (K)
           end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadContT1
       end
     }
  end.

monadEffectContT() ->
  fun
    (DictMonadEffect) ->
      monadEffectContT(DictMonadEffect)
  end.

monadEffectContT(#{ 'Monad0' := DictMonadEffect
                  , liftEffect := DictMonadEffect@1
                  }) ->
  begin
    Monad0 = #{ 'Bind1' := Monad0@1 } = DictMonadEffect(undefined),
    MonadContT1 = monadContT(Monad0),
    #{ liftEffect =>
       begin
         V = erlang:map_get(bind, Monad0@1(undefined)),
         fun
           (X) ->
             V(DictMonadEffect@1(X))
         end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadContT1
       end
     }
  end.

monadStateContT() ->
  fun
    (DictMonadState) ->
      monadStateContT(DictMonadState)
  end.

monadStateContT(#{ 'Monad0' := DictMonadState, state := DictMonadState@1 }) ->
  begin
    Monad0 = #{ 'Bind1' := Monad0@1 } = DictMonadState(undefined),
    MonadContT1 = monadContT(Monad0),
    #{ state =>
       begin
         V = erlang:map_get(bind, Monad0@1(undefined)),
         fun
           (X) ->
             V(DictMonadState@1(X))
         end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadContT1
       end
     }
  end.

monoidContT() ->
  fun
    (DictApplicative) ->
      fun
        (DictMonoid) ->
          monoidContT(DictApplicative, DictMonoid)
      end
  end.

monoidContT(_, #{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupContT2 =
      #{ append =>
         fun
           (A) ->
             fun
               (B) ->
                 fun
                   (K) ->
                     A(fun
                       (A@1) ->
                         begin
                           V@1 = V(A@1),
                           B(fun
                             (A@2) ->
                               K(V@1(A@2))
                           end)
                         end
                     end)
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (K) ->
           K(DictMonoid@1)
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupContT2
       end
     }
  end.

