-module(data_monoid_conj@ps).
-export([ 'Conj'/0
        , 'Conj'/1
        , showConj/0
        , showConj/1
        , semiringConj/0
        , semiringConj/1
        , semigroupConj/0
        , semigroupConj/1
        , ordConj/0
        , ordConj/1
        , monoidConj/0
        , monoidConj/1
        , functorConj/0
        , eqConj/0
        , eqConj/1
        , eq1Conj/0
        , ord1Conj/0
        , boundedConj/0
        , boundedConj/1
        , applyConj/0
        , bindConj/0
        , applicativeConj/0
        , monadConj/0
        ]).
-compile(no_auto_import).
'Conj'() ->
  fun
    (X) ->
      'Conj'(X)
  end.

'Conj'(X) ->
  X.

showConj() ->
  fun
    (DictShow) ->
      showConj(DictShow)
  end.

showConj(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Conj ", (DictShow(V))/binary, ")">>
     end
   }.

semiringConj() ->
  fun
    (DictHeytingAlgebra) ->
      semiringConj(DictHeytingAlgebra)
  end.

semiringConj(#{ conj := DictHeytingAlgebra
              , disj := DictHeytingAlgebra@1
              , ff := DictHeytingAlgebra@2
              , tt := DictHeytingAlgebra@3
              }) ->
  #{ zero => DictHeytingAlgebra@3
   , one => DictHeytingAlgebra@2
   , add =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictHeytingAlgebra(V))(V1)
         end
     end
   , mul =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictHeytingAlgebra@1(V))(V1)
         end
     end
   }.

semigroupConj() ->
  fun
    (DictHeytingAlgebra) ->
      semigroupConj(DictHeytingAlgebra)
  end.

semigroupConj(#{ conj := DictHeytingAlgebra }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictHeytingAlgebra(V))(V1)
         end
     end
   }.

ordConj() ->
  fun
    (DictOrd) ->
      ordConj(DictOrd)
  end.

ordConj(DictOrd) ->
  DictOrd.

monoidConj() ->
  fun
    (DictHeytingAlgebra) ->
      monoidConj(DictHeytingAlgebra)
  end.

monoidConj(#{ conj := DictHeytingAlgebra, tt := DictHeytingAlgebra@1 }) ->
  begin
    SemigroupConj1 =
      #{ append =>
         fun
           (V) ->
             fun
               (V1) ->
                 (DictHeytingAlgebra(V))(V1)
             end
         end
       },
    #{ mempty => DictHeytingAlgebra@1
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupConj1
       end
     }
  end.

functorConj() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             F(M)
         end
     end
   }.

eqConj() ->
  fun
    (DictEq) ->
      eqConj(DictEq)
  end.

eqConj(DictEq) ->
  DictEq.

eq1Conj() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         DictEq
     end
   }.

ord1Conj() ->
  #{ compare1 =>
     fun
       (#{ compare := DictOrd }) ->
         DictOrd
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Conj()
     end
   }.

boundedConj() ->
  fun
    (DictBounded) ->
      boundedConj(DictBounded)
  end.

boundedConj(DictBounded) ->
  DictBounded.

applyConj() ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             V(V1)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorConj()
     end
   }.

bindConj() ->
  #{ bind =>
     fun
       (V) ->
         fun
           (F) ->
             F(V)
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyConj()
     end
   }.

applicativeConj() ->
  #{ pure => 'Conj'()
   , 'Apply0' =>
     fun
       (_) ->
         applyConj()
     end
   }.

monadConj() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeConj()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindConj()
     end
   }.

