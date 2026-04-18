-module(data_monoid_dual@ps).
-export([ 'Dual'/0
        , 'Dual'/1
        , showDual/0
        , showDual/1
        , semigroupDual/0
        , semigroupDual/1
        , ordDual/0
        , ordDual/1
        , monoidDual/0
        , monoidDual/1
        , functorDual/0
        , eqDual/0
        , eqDual/1
        , eq1Dual/0
        , ord1Dual/0
        , boundedDual/0
        , boundedDual/1
        , applyDual/0
        , bindDual/0
        , applicativeDual/0
        , monadDual/0
        ]).
-compile(no_auto_import).
'Dual'() ->
  fun
    (X) ->
      'Dual'(X)
  end.

'Dual'(X) ->
  X.

showDual() ->
  fun
    (DictShow) ->
      showDual(DictShow)
  end.

showDual(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Dual ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupDual() ->
  fun
    (DictSemigroup) ->
      semigroupDual(DictSemigroup)
  end.

semigroupDual(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemigroup(V1))(V)
         end
     end
   }.

ordDual() ->
  fun
    (DictOrd) ->
      ordDual(DictOrd)
  end.

ordDual(DictOrd) ->
  DictOrd.

monoidDual() ->
  fun
    (DictMonoid) ->
      monoidDual(DictMonoid)
  end.

monoidDual(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupDual1 =
      #{ append =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 (V(V1))(V@1)
             end
         end
       },
    #{ mempty => DictMonoid@1
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupDual1
       end
     }
  end.

functorDual() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             F(M)
         end
     end
   }.

eqDual() ->
  fun
    (DictEq) ->
      eqDual(DictEq)
  end.

eqDual(DictEq) ->
  DictEq.

eq1Dual() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         DictEq
     end
   }.

ord1Dual() ->
  #{ compare1 =>
     fun
       (#{ compare := DictOrd }) ->
         DictOrd
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Dual()
     end
   }.

boundedDual() ->
  fun
    (DictBounded) ->
      boundedDual(DictBounded)
  end.

boundedDual(DictBounded) ->
  DictBounded.

applyDual() ->
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
         functorDual()
     end
   }.

bindDual() ->
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
         applyDual()
     end
   }.

applicativeDual() ->
  #{ pure => 'Dual'()
   , 'Apply0' =>
     fun
       (_) ->
         applyDual()
     end
   }.

monadDual() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeDual()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindDual()
     end
   }.

