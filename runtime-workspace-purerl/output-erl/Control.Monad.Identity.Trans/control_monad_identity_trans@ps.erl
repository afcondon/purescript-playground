-module(control_monad_identity_trans@ps).
-export([ 'IdentityT'/0
        , 'IdentityT'/1
        , traversableIdentityT/0
        , traversableIdentityT/1
        , runIdentityT/0
        , runIdentityT/1
        , plusIdentityT/0
        , plusIdentityT/1
        , newtypeIdentityT/0
        , monadZeroIdentityT/0
        , monadZeroIdentityT/1
        , monadWriterIdentityT/0
        , monadWriterIdentityT/1
        , monadTransIdentityT/0
        , monadThrowIdentityT/0
        , monadThrowIdentityT/1
        , monadTellIdentityT/0
        , monadTellIdentityT/1
        , monadStateIdentityT/0
        , monadStateIdentityT/1
        , monadRecIdentityT/0
        , monadRecIdentityT/1
        , monadReaderIdentityT/0
        , monadReaderIdentityT/1
        , monadPlusIdentityT/0
        , monadPlusIdentityT/1
        , monadIdentityT/0
        , monadIdentityT/1
        , monadErrorIdentityT/0
        , monadErrorIdentityT/1
        , monadEffectIdentityT/0
        , monadEffectIdentityT/1
        , monadContIdentityT/0
        , monadContIdentityT/1
        , monadAskIdentityT/0
        , monadAskIdentityT/1
        , mapIdentityT/0
        , mapIdentityT/2
        , functorIdentityT/0
        , functorIdentityT/1
        , foldableIdentityT/0
        , foldableIdentityT/1
        , eqIdentityT/0
        , eqIdentityT/2
        , ordIdentityT/0
        , ordIdentityT/1
        , eq1IdentityT/0
        , eq1IdentityT/1
        , ord1IdentityT/0
        , ord1IdentityT/1
        , bindIdentityT/0
        , bindIdentityT/1
        , applyIdentityT/0
        , applyIdentityT/1
        , applicativeIdentityT/0
        , applicativeIdentityT/1
        , alternativeIdentityT/0
        , alternativeIdentityT/1
        , altIdentityT/0
        , altIdentityT/1
        ]).
-compile(no_auto_import).
'IdentityT'() ->
  fun
    (X) ->
      'IdentityT'(X)
  end.

'IdentityT'(X) ->
  X.

traversableIdentityT() ->
  fun
    (DictTraversable) ->
      traversableIdentityT(DictTraversable)
  end.

traversableIdentityT(DictTraversable) ->
  DictTraversable.

runIdentityT() ->
  fun
    (V) ->
      runIdentityT(V)
  end.

runIdentityT(V) ->
  V.

plusIdentityT() ->
  fun
    (DictPlus) ->
      plusIdentityT(DictPlus)
  end.

plusIdentityT(DictPlus) ->
  DictPlus.

newtypeIdentityT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monadZeroIdentityT() ->
  fun
    (DictMonadZero) ->
      monadZeroIdentityT(DictMonadZero)
  end.

monadZeroIdentityT(DictMonadZero) ->
  DictMonadZero.

monadWriterIdentityT() ->
  fun
    (DictMonadWriter) ->
      monadWriterIdentityT(DictMonadWriter)
  end.

monadWriterIdentityT(DictMonadWriter) ->
  DictMonadWriter.

monadTransIdentityT() ->
  #{ lift =>
     fun
       (_) ->
         'IdentityT'()
     end
   }.

monadThrowIdentityT() ->
  fun
    (DictMonadThrow) ->
      monadThrowIdentityT(DictMonadThrow)
  end.

monadThrowIdentityT(DictMonadThrow) ->
  DictMonadThrow.

monadTellIdentityT() ->
  fun
    (DictMonadTell) ->
      monadTellIdentityT(DictMonadTell)
  end.

monadTellIdentityT(DictMonadTell) ->
  DictMonadTell.

monadStateIdentityT() ->
  fun
    (DictMonadState) ->
      monadStateIdentityT(DictMonadState)
  end.

monadStateIdentityT(DictMonadState) ->
  DictMonadState.

monadRecIdentityT() ->
  fun
    (DictMonadRec) ->
      monadRecIdentityT(DictMonadRec)
  end.

monadRecIdentityT(DictMonadRec) ->
  DictMonadRec.

monadReaderIdentityT() ->
  fun
    (DictMonadReader) ->
      monadReaderIdentityT(DictMonadReader)
  end.

monadReaderIdentityT(DictMonadReader) ->
  DictMonadReader.

monadPlusIdentityT() ->
  fun
    (DictMonadPlus) ->
      monadPlusIdentityT(DictMonadPlus)
  end.

monadPlusIdentityT(DictMonadPlus) ->
  DictMonadPlus.

monadIdentityT() ->
  fun
    (DictMonad) ->
      monadIdentityT(DictMonad)
  end.

monadIdentityT(DictMonad) ->
  DictMonad.

monadErrorIdentityT() ->
  fun
    (DictMonadError) ->
      monadErrorIdentityT(DictMonadError)
  end.

monadErrorIdentityT(DictMonadError) ->
  DictMonadError.

monadEffectIdentityT() ->
  fun
    (DictMonadEffect) ->
      monadEffectIdentityT(DictMonadEffect)
  end.

monadEffectIdentityT(DictMonadEffect) ->
  DictMonadEffect.

monadContIdentityT() ->
  fun
    (DictMonadCont) ->
      monadContIdentityT(DictMonadCont)
  end.

monadContIdentityT(DictMonadCont) ->
  DictMonadCont.

monadAskIdentityT() ->
  fun
    (DictMonadAsk) ->
      monadAskIdentityT(DictMonadAsk)
  end.

monadAskIdentityT(DictMonadAsk) ->
  DictMonadAsk.

mapIdentityT() ->
  fun
    (F) ->
      fun
        (V) ->
          mapIdentityT(F, V)
      end
  end.

mapIdentityT(F, V) ->
  F(V).

functorIdentityT() ->
  fun
    (DictFunctor) ->
      functorIdentityT(DictFunctor)
  end.

functorIdentityT(DictFunctor) ->
  DictFunctor.

foldableIdentityT() ->
  fun
    (DictFoldable) ->
      foldableIdentityT(DictFoldable)
  end.

foldableIdentityT(DictFoldable) ->
  DictFoldable.

eqIdentityT() ->
  fun
    (DictEq1) ->
      fun
        (DictEq) ->
          eqIdentityT(DictEq1, DictEq)
      end
  end.

eqIdentityT(#{ eq1 := DictEq1 }, DictEq) ->
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

ordIdentityT() ->
  fun
    (DictOrd1) ->
      ordIdentityT(DictOrd1)
  end.

ordIdentityT(#{ 'Eq10' := DictOrd1, compare1 := DictOrd1@1 }) ->
  begin
    #{ eq1 := V } = DictOrd1(undefined),
    fun
      (DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
        begin
          Compare11 = DictOrd1@1(DictOrd),
          Eq11 = V(DictOrd@1(undefined)),
          EqIdentityT2 =
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
                 EqIdentityT2
             end
           }
        end
    end
  end.

eq1IdentityT() ->
  fun
    (DictEq1) ->
      eq1IdentityT(DictEq1)
  end.

eq1IdentityT(#{ eq1 := DictEq1 }) ->
  #{ eq1 =>
     fun
       (DictEq) ->
         DictEq1(DictEq)
     end
   }.

ord1IdentityT() ->
  fun
    (DictOrd1) ->
      ord1IdentityT(DictOrd1)
  end.

ord1IdentityT(#{ 'Eq10' := DictOrd1, compare1 := DictOrd1@1 }) ->
  begin
    #{ eq1 := V } = DictOrd1(undefined),
    #{ eq1 := V@1 } = DictOrd1(undefined),
    Eq1IdentityT1 =
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
                 EqIdentityT2 =
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
                        EqIdentityT2
                    end
                  }
               end
             )
           end
       end
     , 'Eq10' =>
       fun
         (_) ->
           Eq1IdentityT1
       end
     }
  end.

bindIdentityT() ->
  fun
    (DictBind) ->
      bindIdentityT(DictBind)
  end.

bindIdentityT(DictBind) ->
  DictBind.

applyIdentityT() ->
  fun
    (DictApply) ->
      applyIdentityT(DictApply)
  end.

applyIdentityT(DictApply) ->
  DictApply.

applicativeIdentityT() ->
  fun
    (DictApplicative) ->
      applicativeIdentityT(DictApplicative)
  end.

applicativeIdentityT(DictApplicative) ->
  DictApplicative.

alternativeIdentityT() ->
  fun
    (DictAlternative) ->
      alternativeIdentityT(DictAlternative)
  end.

alternativeIdentityT(DictAlternative) ->
  DictAlternative.

altIdentityT() ->
  fun
    (DictAlt) ->
      altIdentityT(DictAlt)
  end.

altIdentityT(DictAlt) ->
  DictAlt.

