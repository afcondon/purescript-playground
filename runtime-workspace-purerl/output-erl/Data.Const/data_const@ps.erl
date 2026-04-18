-module(data_const@ps).
-export([ 'Const'/0
        , 'Const'/1
        , showConst/0
        , showConst/1
        , semiringConst/0
        , semiringConst/1
        , semigroupoidConst/0
        , semigroupConst/0
        , semigroupConst/1
        , ringConst/0
        , ringConst/1
        , ordConst/0
        , ordConst/1
        , newtypeConst/0
        , monoidConst/0
        , monoidConst/1
        , heytingAlgebraConst/0
        , heytingAlgebraConst/1
        , functorConst/0
        , invariantConst/0
        , euclideanRingConst/0
        , euclideanRingConst/1
        , eqConst/0
        , eqConst/1
        , eq1Const/0
        , eq1Const/1
        , ord1Const/0
        , ord1Const/1
        , commutativeRingConst/0
        , commutativeRingConst/1
        , boundedConst/0
        , boundedConst/1
        , booleanAlgebraConst/0
        , booleanAlgebraConst/1
        , applyConst/0
        , applyConst/1
        , applicativeConst/0
        , applicativeConst/1
        ]).
-compile(no_auto_import).
'Const'() ->
  fun
    (X) ->
      'Const'(X)
  end.

'Const'(X) ->
  X.

showConst() ->
  fun
    (DictShow) ->
      showConst(DictShow)
  end.

showConst(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Const ", (DictShow(V))/binary, ")">>
     end
   }.

semiringConst() ->
  fun
    (DictSemiring) ->
      semiringConst(DictSemiring)
  end.

semiringConst(DictSemiring) ->
  DictSemiring.

semigroupoidConst() ->
  #{ compose =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   }.

semigroupConst() ->
  fun
    (DictSemigroup) ->
      semigroupConst(DictSemigroup)
  end.

semigroupConst(DictSemigroup) ->
  DictSemigroup.

ringConst() ->
  fun
    (DictRing) ->
      ringConst(DictRing)
  end.

ringConst(DictRing) ->
  DictRing.

ordConst() ->
  fun
    (DictOrd) ->
      ordConst(DictOrd)
  end.

ordConst(DictOrd) ->
  DictOrd.

newtypeConst() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidConst() ->
  fun
    (DictMonoid) ->
      monoidConst(DictMonoid)
  end.

monoidConst(DictMonoid) ->
  DictMonoid.

heytingAlgebraConst() ->
  fun
    (DictHeytingAlgebra) ->
      heytingAlgebraConst(DictHeytingAlgebra)
  end.

heytingAlgebraConst(DictHeytingAlgebra) ->
  DictHeytingAlgebra.

functorConst() ->
  #{ map =>
     fun
       (_) ->
         fun
           (M) ->
             M
         end
     end
   }.

invariantConst() ->
  #{ imap =>
     fun
       (_) ->
         fun
           (_) ->
             fun
               (M) ->
                 M
             end
         end
     end
   }.

euclideanRingConst() ->
  fun
    (DictEuclideanRing) ->
      euclideanRingConst(DictEuclideanRing)
  end.

euclideanRingConst(DictEuclideanRing) ->
  DictEuclideanRing.

eqConst() ->
  fun
    (DictEq) ->
      eqConst(DictEq)
  end.

eqConst(DictEq) ->
  DictEq.

eq1Const() ->
  fun
    (DictEq) ->
      eq1Const(DictEq)
  end.

eq1Const(#{ eq := DictEq }) ->
  #{ eq1 =>
     fun
       (_) ->
         DictEq
     end
   }.

ord1Const() ->
  fun
    (DictOrd) ->
      ord1Const(DictOrd)
  end.

ord1Const(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    Eq = erlang:map_get(eq, DictOrd(undefined)),
    #{ compare1 =>
       fun
         (_) ->
           DictOrd@1
       end
     , 'Eq10' =>
       fun
         (_) ->
           #{ eq1 =>
              fun
                (_) ->
                  Eq
              end
            }
       end
     }
  end.

commutativeRingConst() ->
  fun
    (DictCommutativeRing) ->
      commutativeRingConst(DictCommutativeRing)
  end.

commutativeRingConst(DictCommutativeRing) ->
  DictCommutativeRing.

boundedConst() ->
  fun
    (DictBounded) ->
      boundedConst(DictBounded)
  end.

boundedConst(DictBounded) ->
  DictBounded.

booleanAlgebraConst() ->
  fun
    (DictBooleanAlgebra) ->
      booleanAlgebraConst(DictBooleanAlgebra)
  end.

booleanAlgebraConst(DictBooleanAlgebra) ->
  DictBooleanAlgebra.

applyConst() ->
  fun
    (DictSemigroup) ->
      applyConst(DictSemigroup)
  end.

applyConst(#{ append := DictSemigroup }) ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemigroup(V))(V1)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorConst()
     end
   }.

applicativeConst() ->
  fun
    (DictMonoid) ->
      applicativeConst(DictMonoid)
  end.

applicativeConst(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    ApplyConst1 =
      #{ apply =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 (V(V@1))(V1)
             end
         end
       , 'Functor0' =>
         fun
           (_) ->
             functorConst()
         end
       },
    #{ pure =>
       fun
         (_) ->
           DictMonoid@1
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyConst1
       end
     }
  end.

