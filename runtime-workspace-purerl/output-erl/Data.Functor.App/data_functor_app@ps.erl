-module(data_functor_app@ps).
-export([ 'App'/0
        , 'App'/1
        , showApp/0
        , showApp/1
        , semigroupApp/0
        , semigroupApp/2
        , plusApp/0
        , plusApp/1
        , newtypeApp/0
        , monoidApp/0
        , monoidApp/1
        , monadPlusApp/0
        , monadPlusApp/1
        , monadApp/0
        , monadApp/1
        , lazyApp/0
        , lazyApp/1
        , hoistLowerApp/0
        , hoistLiftApp/0
        , hoistApp/0
        , hoistApp/2
        , functorApp/0
        , functorApp/1
        , extendApp/0
        , extendApp/1
        , eqApp/0
        , eqApp/2
        , ordApp/0
        , ordApp/1
        , eq1App/0
        , eq1App/1
        , ord1App/0
        , ord1App/1
        , comonadApp/0
        , comonadApp/1
        , bindApp/0
        , bindApp/1
        , applyApp/0
        , applyApp/1
        , applicativeApp/0
        , applicativeApp/1
        , alternativeApp/0
        , alternativeApp/1
        , monadZeroApp/0
        , monadZeroApp/1
        , altApp/0
        , altApp/1
        , hoistLowerApp/1
        , hoistLiftApp/1
        ]).
-compile(no_auto_import).
'App'() ->
  fun
    (X) ->
      'App'(X)
  end.

'App'(X) ->
  X.

showApp() ->
  fun
    (DictShow) ->
      showApp(DictShow)
  end.

showApp(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(App ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupApp() ->
  fun
    (DictApply) ->
      fun
        (DictSemigroup) ->
          semigroupApp(DictApply, DictSemigroup)
      end
  end.

semigroupApp( #{ 'Functor0' := DictApply, apply := DictApply@1 }
            , #{ append := DictSemigroup }
            ) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictApply@1(((erlang:map_get(map, DictApply(undefined)))
                           (DictSemigroup))
                          (V)))
             (V1)
         end
     end
   }.

plusApp() ->
  fun
    (DictPlus) ->
      plusApp(DictPlus)
  end.

plusApp(DictPlus) ->
  DictPlus.

newtypeApp() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidApp() ->
  fun
    (DictApplicative) ->
      monoidApp(DictApplicative)
  end.

monoidApp(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    fun
      (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
        begin
          Append1 = erlang:map_get(append, DictMonoid(undefined)),
          SemigroupApp2 =
            #{ append =>
               fun
                 (V@2) ->
                   fun
                     (V1) ->
                       (V@1(((erlang:map_get(map, V(undefined)))(Append1))(V@2)))
                       (V1)
                   end
               end
             },
          #{ mempty => DictApplicative@1(DictMonoid@1)
           , 'Semigroup0' =>
             fun
               (_) ->
                 SemigroupApp2
             end
           }
        end
    end
  end.

monadPlusApp() ->
  fun
    (DictMonadPlus) ->
      monadPlusApp(DictMonadPlus)
  end.

monadPlusApp(DictMonadPlus) ->
  DictMonadPlus.

monadApp() ->
  fun
    (DictMonad) ->
      monadApp(DictMonad)
  end.

monadApp(DictMonad) ->
  DictMonad.

lazyApp() ->
  fun
    (DictLazy) ->
      lazyApp(DictLazy)
  end.

lazyApp(DictLazy) ->
  DictLazy.

hoistLowerApp() ->
  unsafe_coerce@ps:unsafeCoerce().

hoistLiftApp() ->
  unsafe_coerce@ps:unsafeCoerce().

hoistApp() ->
  fun
    (F) ->
      fun
        (V) ->
          hoistApp(F, V)
      end
  end.

hoistApp(F, V) ->
  F(V).

functorApp() ->
  fun
    (DictFunctor) ->
      functorApp(DictFunctor)
  end.

functorApp(DictFunctor) ->
  DictFunctor.

extendApp() ->
  fun
    (DictExtend) ->
      extendApp(DictExtend)
  end.

extendApp(DictExtend) ->
  DictExtend.

eqApp() ->
  fun
    (DictEq1) ->
      fun
        (DictEq) ->
          eqApp(DictEq1, DictEq)
      end
  end.

eqApp(#{ eq1 := DictEq1 }, DictEq) ->
  begin
    Eq11 = DictEq1(DictEq),
    #{ eq =>
       fun
         (X) ->
           fun
             (Y) ->
               (Eq11(X))(Y)
           end
       end
     }
  end.

ordApp() ->
  fun
    (DictOrd1) ->
      ordApp(DictOrd1)
  end.

ordApp(#{ 'Eq10' := DictOrd1, compare1 := DictOrd1@1 }) ->
  begin
    #{ eq1 := V } = DictOrd1(undefined),
    fun
      (DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
        begin
          Compare11 = DictOrd1@1(DictOrd),
          Eq11 = V(DictOrd@1(undefined)),
          EqApp2 =
            #{ eq =>
               fun
                 (X) ->
                   fun
                     (Y) ->
                       (Eq11(X))(Y)
                   end
               end
             },
          #{ compare =>
             fun
               (X) ->
                 fun
                   (Y) ->
                     (Compare11(X))(Y)
                 end
             end
           , 'Eq0' =>
             fun
               (_) ->
                 EqApp2
             end
           }
        end
    end
  end.

eq1App() ->
  fun
    (DictEq1) ->
      eq1App(DictEq1)
  end.

eq1App(#{ eq1 := DictEq1 }) ->
  #{ eq1 =>
     fun
       (DictEq) ->
         DictEq1(DictEq)
     end
   }.

ord1App() ->
  fun
    (DictOrd1) ->
      ord1App(DictOrd1)
  end.

ord1App(#{ 'Eq10' := DictOrd1, compare1 := DictOrd1@1 }) ->
  begin
    #{ eq1 := V } = DictOrd1(undefined),
    #{ eq1 := V@1 } = DictOrd1(undefined),
    Eq1App1 =
      #{ eq1 =>
         fun
           (DictEq) ->
             V@1(DictEq)
         end
       },
    #{ compare1 =>
       fun
         (DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
           begin
             Compare11 = DictOrd1@1(DictOrd),
             Eq11 = V(DictOrd@1(undefined)),
             erlang:map_get(
               compare,
               begin
                 EqApp2 =
                   #{ eq =>
                      fun
                        (X) ->
                          fun
                            (Y) ->
                              (Eq11(X))(Y)
                          end
                      end
                    },
                 #{ compare =>
                    fun
                      (X) ->
                        fun
                          (Y) ->
                            (Compare11(X))(Y)
                        end
                    end
                  , 'Eq0' =>
                    fun
                      (_) ->
                        EqApp2
                    end
                  }
               end
             )
           end
       end
     , 'Eq10' =>
       fun
         (_) ->
           Eq1App1
       end
     }
  end.

comonadApp() ->
  fun
    (DictComonad) ->
      comonadApp(DictComonad)
  end.

comonadApp(DictComonad) ->
  DictComonad.

bindApp() ->
  fun
    (DictBind) ->
      bindApp(DictBind)
  end.

bindApp(DictBind) ->
  DictBind.

applyApp() ->
  fun
    (DictApply) ->
      applyApp(DictApply)
  end.

applyApp(DictApply) ->
  DictApply.

applicativeApp() ->
  fun
    (DictApplicative) ->
      applicativeApp(DictApplicative)
  end.

applicativeApp(DictApplicative) ->
  DictApplicative.

alternativeApp() ->
  fun
    (DictAlternative) ->
      alternativeApp(DictAlternative)
  end.

alternativeApp(DictAlternative) ->
  DictAlternative.

monadZeroApp() ->
  fun
    (DictMonadZero) ->
      monadZeroApp(DictMonadZero)
  end.

monadZeroApp(#{ 'Alternative1' := DictMonadZero, 'Monad0' := DictMonadZero@1 }) ->
  begin
    V = DictMonadZero@1(undefined),
    V@1 = DictMonadZero(undefined),
    #{ 'Monad0' =>
       fun
         (_) ->
           V
       end
     , 'Alternative1' =>
       fun
         (_) ->
           V@1
       end
     , 'MonadZeroIsDeprecated2' =>
       fun
         (_) ->
           undefined
       end
     }
  end.

altApp() ->
  fun
    (DictAlt) ->
      altApp(DictAlt)
  end.

altApp(DictAlt) ->
  DictAlt.

hoistLowerApp(V) ->
  V.

hoistLiftApp(V) ->
  V.

