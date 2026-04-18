-module(data_monoid_alternate@ps).
-export([ 'Alternate'/0
        , 'Alternate'/1
        , showAlternate/0
        , showAlternate/1
        , semigroupAlternate/0
        , semigroupAlternate/1
        , plusAlternate/0
        , plusAlternate/1
        , ordAlternate/0
        , ordAlternate/1
        , ord1Alternate/0
        , ord1Alternate/1
        , newtypeAlternate/0
        , monoidAlternate/0
        , monoidAlternate/1
        , monadAlternate/0
        , monadAlternate/1
        , functorAlternate/0
        , functorAlternate/1
        , extendAlternate/0
        , extendAlternate/1
        , eqAlternate/0
        , eqAlternate/1
        , eq1Alternate/0
        , eq1Alternate/1
        , comonadAlternate/0
        , comonadAlternate/1
        , boundedAlternate/0
        , boundedAlternate/1
        , bindAlternate/0
        , bindAlternate/1
        , applyAlternate/0
        , applyAlternate/1
        , applicativeAlternate/0
        , applicativeAlternate/1
        , alternativeAlternate/0
        , alternativeAlternate/1
        , altAlternate/0
        , altAlternate/1
        ]).
-compile(no_auto_import).
'Alternate'() ->
  fun
    (X) ->
      'Alternate'(X)
  end.

'Alternate'(X) ->
  X.

showAlternate() ->
  fun
    (DictShow) ->
      showAlternate(DictShow)
  end.

showAlternate(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Alternate ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupAlternate() ->
  fun
    (DictAlt) ->
      semigroupAlternate(DictAlt)
  end.

semigroupAlternate(#{ alt := DictAlt }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictAlt(V))(V1)
         end
     end
   }.

plusAlternate() ->
  fun
    (DictPlus) ->
      plusAlternate(DictPlus)
  end.

plusAlternate(DictPlus) ->
  DictPlus.

ordAlternate() ->
  fun
    (DictOrd) ->
      ordAlternate(DictOrd)
  end.

ordAlternate(DictOrd) ->
  DictOrd.

ord1Alternate() ->
  fun
    (DictOrd1) ->
      ord1Alternate(DictOrd1)
  end.

ord1Alternate(DictOrd1) ->
  DictOrd1.

newtypeAlternate() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidAlternate() ->
  fun
    (DictPlus) ->
      monoidAlternate(DictPlus)
  end.

monoidAlternate(#{ 'Alt0' := DictPlus, empty := DictPlus@1 }) ->
  begin
    #{ alt := V } = DictPlus(undefined),
    SemigroupAlternate1 =
      #{ append =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 (V(V@1))(V1)
             end
         end
       },
    #{ mempty => DictPlus@1
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupAlternate1
       end
     }
  end.

monadAlternate() ->
  fun
    (DictMonad) ->
      monadAlternate(DictMonad)
  end.

monadAlternate(DictMonad) ->
  DictMonad.

functorAlternate() ->
  fun
    (DictFunctor) ->
      functorAlternate(DictFunctor)
  end.

functorAlternate(DictFunctor) ->
  DictFunctor.

extendAlternate() ->
  fun
    (DictExtend) ->
      extendAlternate(DictExtend)
  end.

extendAlternate(DictExtend) ->
  DictExtend.

eqAlternate() ->
  fun
    (DictEq) ->
      eqAlternate(DictEq)
  end.

eqAlternate(DictEq) ->
  DictEq.

eq1Alternate() ->
  fun
    (DictEq1) ->
      eq1Alternate(DictEq1)
  end.

eq1Alternate(DictEq1) ->
  DictEq1.

comonadAlternate() ->
  fun
    (DictComonad) ->
      comonadAlternate(DictComonad)
  end.

comonadAlternate(DictComonad) ->
  DictComonad.

boundedAlternate() ->
  fun
    (DictBounded) ->
      boundedAlternate(DictBounded)
  end.

boundedAlternate(DictBounded) ->
  DictBounded.

bindAlternate() ->
  fun
    (DictBind) ->
      bindAlternate(DictBind)
  end.

bindAlternate(DictBind) ->
  DictBind.

applyAlternate() ->
  fun
    (DictApply) ->
      applyAlternate(DictApply)
  end.

applyAlternate(DictApply) ->
  DictApply.

applicativeAlternate() ->
  fun
    (DictApplicative) ->
      applicativeAlternate(DictApplicative)
  end.

applicativeAlternate(DictApplicative) ->
  DictApplicative.

alternativeAlternate() ->
  fun
    (DictAlternative) ->
      alternativeAlternate(DictAlternative)
  end.

alternativeAlternate(DictAlternative) ->
  DictAlternative.

altAlternate() ->
  fun
    (DictAlt) ->
      altAlternate(DictAlt)
  end.

altAlternate(DictAlt) ->
  DictAlt.

