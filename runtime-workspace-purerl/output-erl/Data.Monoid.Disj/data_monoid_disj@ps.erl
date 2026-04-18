-module(data_monoid_disj@ps).
-export([ 'Disj'/0
        , 'Disj'/1
        , showDisj/0
        , showDisj/1
        , semiringDisj/0
        , semiringDisj/1
        , semigroupDisj/0
        , semigroupDisj/1
        , ordDisj/0
        , ordDisj/1
        , monoidDisj/0
        , monoidDisj/1
        , functorDisj/0
        , eqDisj/0
        , eqDisj/1
        , eq1Disj/0
        , ord1Disj/0
        , boundedDisj/0
        , boundedDisj/1
        , applyDisj/0
        , bindDisj/0
        , applicativeDisj/0
        , monadDisj/0
        ]).
-compile(no_auto_import).
'Disj'() ->
  fun
    (X) ->
      'Disj'(X)
  end.

'Disj'(X) ->
  X.

showDisj() ->
  fun
    (DictShow) ->
      showDisj(DictShow)
  end.

showDisj(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Disj ", (DictShow(V))/binary, ")">>
     end
   }.

semiringDisj() ->
  fun
    (DictHeytingAlgebra) ->
      semiringDisj(DictHeytingAlgebra)
  end.

semiringDisj(#{ conj := DictHeytingAlgebra
              , disj := DictHeytingAlgebra@1
              , ff := DictHeytingAlgebra@2
              , tt := DictHeytingAlgebra@3
              }) ->
  #{ zero => DictHeytingAlgebra@2
   , one => DictHeytingAlgebra@3
   , add =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictHeytingAlgebra@1(V))(V1)
         end
     end
   , mul =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictHeytingAlgebra(V))(V1)
         end
     end
   }.

semigroupDisj() ->
  fun
    (DictHeytingAlgebra) ->
      semigroupDisj(DictHeytingAlgebra)
  end.

semigroupDisj(#{ disj := DictHeytingAlgebra }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictHeytingAlgebra(V))(V1)
         end
     end
   }.

ordDisj() ->
  fun
    (DictOrd) ->
      ordDisj(DictOrd)
  end.

ordDisj(DictOrd) ->
  DictOrd.

monoidDisj() ->
  fun
    (DictHeytingAlgebra) ->
      monoidDisj(DictHeytingAlgebra)
  end.

monoidDisj(#{ disj := DictHeytingAlgebra, ff := DictHeytingAlgebra@1 }) ->
  begin
    SemigroupDisj1 =
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
           SemigroupDisj1
       end
     }
  end.

functorDisj() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             F(M)
         end
     end
   }.

eqDisj() ->
  fun
    (DictEq) ->
      eqDisj(DictEq)
  end.

eqDisj(DictEq) ->
  DictEq.

eq1Disj() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         DictEq
     end
   }.

ord1Disj() ->
  #{ compare1 =>
     fun
       (#{ compare := DictOrd }) ->
         DictOrd
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Disj()
     end
   }.

boundedDisj() ->
  fun
    (DictBounded) ->
      boundedDisj(DictBounded)
  end.

boundedDisj(DictBounded) ->
  DictBounded.

applyDisj() ->
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
         functorDisj()
     end
   }.

bindDisj() ->
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
         applyDisj()
     end
   }.

applicativeDisj() ->
  #{ pure => 'Disj'()
   , 'Apply0' =>
     fun
       (_) ->
         applyDisj()
     end
   }.

monadDisj() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeDisj()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindDisj()
     end
   }.

