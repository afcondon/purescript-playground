-module(data_monoid_multiplicative@ps).
-export([ 'Multiplicative'/0
        , 'Multiplicative'/1
        , showMultiplicative/0
        , showMultiplicative/1
        , semigroupMultiplicative/0
        , semigroupMultiplicative/1
        , ordMultiplicative/0
        , ordMultiplicative/1
        , monoidMultiplicative/0
        , monoidMultiplicative/1
        , functorMultiplicative/0
        , eqMultiplicative/0
        , eqMultiplicative/1
        , eq1Multiplicative/0
        , ord1Multiplicative/0
        , boundedMultiplicative/0
        , boundedMultiplicative/1
        , applyMultiplicative/0
        , bindMultiplicative/0
        , applicativeMultiplicative/0
        , monadMultiplicative/0
        ]).
-compile(no_auto_import).
'Multiplicative'() ->
  fun
    (X) ->
      'Multiplicative'(X)
  end.

'Multiplicative'(X) ->
  X.

showMultiplicative() ->
  fun
    (DictShow) ->
      showMultiplicative(DictShow)
  end.

showMultiplicative(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Multiplicative ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupMultiplicative() ->
  fun
    (DictSemiring) ->
      semigroupMultiplicative(DictSemiring)
  end.

semigroupMultiplicative(#{ mul := DictSemiring }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemiring(V))(V1)
         end
     end
   }.

ordMultiplicative() ->
  fun
    (DictOrd) ->
      ordMultiplicative(DictOrd)
  end.

ordMultiplicative(DictOrd) ->
  DictOrd.

monoidMultiplicative() ->
  fun
    (DictSemiring) ->
      monoidMultiplicative(DictSemiring)
  end.

monoidMultiplicative(#{ mul := DictSemiring, one := DictSemiring@1 }) ->
  begin
    SemigroupMultiplicative1 =
      #{ append =>
         fun
           (V) ->
             fun
               (V1) ->
                 (DictSemiring(V))(V1)
             end
         end
       },
    #{ mempty => DictSemiring@1
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupMultiplicative1
       end
     }
  end.

functorMultiplicative() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             F(M)
         end
     end
   }.

eqMultiplicative() ->
  fun
    (DictEq) ->
      eqMultiplicative(DictEq)
  end.

eqMultiplicative(DictEq) ->
  DictEq.

eq1Multiplicative() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         DictEq
     end
   }.

ord1Multiplicative() ->
  #{ compare1 =>
     fun
       (#{ compare := DictOrd }) ->
         DictOrd
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Multiplicative()
     end
   }.

boundedMultiplicative() ->
  fun
    (DictBounded) ->
      boundedMultiplicative(DictBounded)
  end.

boundedMultiplicative(DictBounded) ->
  DictBounded.

applyMultiplicative() ->
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
         functorMultiplicative()
     end
   }.

bindMultiplicative() ->
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
         applyMultiplicative()
     end
   }.

applicativeMultiplicative() ->
  #{ pure => 'Multiplicative'()
   , 'Apply0' =>
     fun
       (_) ->
         applyMultiplicative()
     end
   }.

monadMultiplicative() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeMultiplicative()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindMultiplicative()
     end
   }.

