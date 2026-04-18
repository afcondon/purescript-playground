-module(data_identity@ps).
-export([ 'Identity'/0
        , 'Identity'/1
        , showIdentity/0
        , showIdentity/1
        , semiringIdentity/0
        , semiringIdentity/1
        , semigroupIdenity/0
        , semigroupIdenity/1
        , ringIdentity/0
        , ringIdentity/1
        , ordIdentity/0
        , ordIdentity/1
        , newtypeIdentity/0
        , monoidIdentity/0
        , monoidIdentity/1
        , lazyIdentity/0
        , lazyIdentity/1
        , heytingAlgebraIdentity/0
        , heytingAlgebraIdentity/1
        , functorIdentity/0
        , invariantIdentity/0
        , extendIdentity/0
        , euclideanRingIdentity/0
        , euclideanRingIdentity/1
        , eqIdentity/0
        , eqIdentity/1
        , eq1Identity/0
        , ord1Identity/0
        , comonadIdentity/0
        , commutativeRingIdentity/0
        , commutativeRingIdentity/1
        , boundedIdentity/0
        , boundedIdentity/1
        , booleanAlgebraIdentity/0
        , booleanAlgebraIdentity/1
        , applyIdentity/0
        , bindIdentity/0
        , applicativeIdentity/0
        , monadIdentity/0
        , altIdentity/0
        ]).
-compile(no_auto_import).
'Identity'() ->
  fun
    (X) ->
      'Identity'(X)
  end.

'Identity'(X) ->
  X.

showIdentity() ->
  fun
    (DictShow) ->
      showIdentity(DictShow)
  end.

showIdentity(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Identity ", (DictShow(V))/binary, ")">>
     end
   }.

semiringIdentity() ->
  fun
    (DictSemiring) ->
      semiringIdentity(DictSemiring)
  end.

semiringIdentity(DictSemiring) ->
  DictSemiring.

semigroupIdenity() ->
  fun
    (DictSemigroup) ->
      semigroupIdenity(DictSemigroup)
  end.

semigroupIdenity(DictSemigroup) ->
  DictSemigroup.

ringIdentity() ->
  fun
    (DictRing) ->
      ringIdentity(DictRing)
  end.

ringIdentity(DictRing) ->
  DictRing.

ordIdentity() ->
  fun
    (DictOrd) ->
      ordIdentity(DictOrd)
  end.

ordIdentity(DictOrd) ->
  DictOrd.

newtypeIdentity() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidIdentity() ->
  fun
    (DictMonoid) ->
      monoidIdentity(DictMonoid)
  end.

monoidIdentity(DictMonoid) ->
  DictMonoid.

lazyIdentity() ->
  fun
    (DictLazy) ->
      lazyIdentity(DictLazy)
  end.

lazyIdentity(DictLazy) ->
  DictLazy.

heytingAlgebraIdentity() ->
  fun
    (DictHeytingAlgebra) ->
      heytingAlgebraIdentity(DictHeytingAlgebra)
  end.

heytingAlgebraIdentity(DictHeytingAlgebra) ->
  DictHeytingAlgebra.

functorIdentity() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             F(M)
         end
     end
   }.

invariantIdentity() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (M) ->
                 F(M)
             end
         end
     end
   }.

extendIdentity() ->
  #{ extend =>
     fun
       (F) ->
         fun
           (M) ->
             F(M)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorIdentity()
     end
   }.

euclideanRingIdentity() ->
  fun
    (DictEuclideanRing) ->
      euclideanRingIdentity(DictEuclideanRing)
  end.

euclideanRingIdentity(DictEuclideanRing) ->
  DictEuclideanRing.

eqIdentity() ->
  fun
    (DictEq) ->
      eqIdentity(DictEq)
  end.

eqIdentity(DictEq) ->
  DictEq.

eq1Identity() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         DictEq
     end
   }.

ord1Identity() ->
  #{ compare1 =>
     fun
       (#{ compare := DictOrd }) ->
         DictOrd
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Identity()
     end
   }.

comonadIdentity() ->
  #{ extract =>
     fun
       (V) ->
         V
     end
   , 'Extend0' =>
     fun
       (_) ->
         extendIdentity()
     end
   }.

commutativeRingIdentity() ->
  fun
    (DictCommutativeRing) ->
      commutativeRingIdentity(DictCommutativeRing)
  end.

commutativeRingIdentity(DictCommutativeRing) ->
  DictCommutativeRing.

boundedIdentity() ->
  fun
    (DictBounded) ->
      boundedIdentity(DictBounded)
  end.

boundedIdentity(DictBounded) ->
  DictBounded.

booleanAlgebraIdentity() ->
  fun
    (DictBooleanAlgebra) ->
      booleanAlgebraIdentity(DictBooleanAlgebra)
  end.

booleanAlgebraIdentity(DictBooleanAlgebra) ->
  DictBooleanAlgebra.

applyIdentity() ->
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
         functorIdentity()
     end
   }.

bindIdentity() ->
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
         applyIdentity()
     end
   }.

applicativeIdentity() ->
  #{ pure => 'Identity'()
   , 'Apply0' =>
     fun
       (_) ->
         applyIdentity()
     end
   }.

monadIdentity() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeIdentity()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindIdentity()
     end
   }.

altIdentity() ->
  #{ alt =>
     fun
       (X) ->
         fun
           (_) ->
             X
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorIdentity()
     end
   }.

