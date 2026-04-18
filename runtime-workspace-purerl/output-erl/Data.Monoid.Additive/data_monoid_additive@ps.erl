-module(data_monoid_additive@ps).
-export([ 'Additive'/0
        , 'Additive'/1
        , showAdditive/0
        , showAdditive/1
        , semigroupAdditive/0
        , semigroupAdditive/1
        , ordAdditive/0
        , ordAdditive/1
        , monoidAdditive/0
        , monoidAdditive/1
        , functorAdditive/0
        , eqAdditive/0
        , eqAdditive/1
        , eq1Additive/0
        , ord1Additive/0
        , boundedAdditive/0
        , boundedAdditive/1
        , applyAdditive/0
        , bindAdditive/0
        , applicativeAdditive/0
        , monadAdditive/0
        ]).
-compile(no_auto_import).
'Additive'() ->
  fun
    (X) ->
      'Additive'(X)
  end.

'Additive'(X) ->
  X.

showAdditive() ->
  fun
    (DictShow) ->
      showAdditive(DictShow)
  end.

showAdditive(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Additive ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupAdditive() ->
  fun
    (DictSemiring) ->
      semigroupAdditive(DictSemiring)
  end.

semigroupAdditive(#{ add := DictSemiring }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemiring(V))(V1)
         end
     end
   }.

ordAdditive() ->
  fun
    (DictOrd) ->
      ordAdditive(DictOrd)
  end.

ordAdditive(DictOrd) ->
  DictOrd.

monoidAdditive() ->
  fun
    (DictSemiring) ->
      monoidAdditive(DictSemiring)
  end.

monoidAdditive(#{ add := DictSemiring, zero := DictSemiring@1 }) ->
  begin
    SemigroupAdditive1 =
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
           SemigroupAdditive1
       end
     }
  end.

functorAdditive() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             F(M)
         end
     end
   }.

eqAdditive() ->
  fun
    (DictEq) ->
      eqAdditive(DictEq)
  end.

eqAdditive(DictEq) ->
  DictEq.

eq1Additive() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         DictEq
     end
   }.

ord1Additive() ->
  #{ compare1 =>
     fun
       (#{ compare := DictOrd }) ->
         DictOrd
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Additive()
     end
   }.

boundedAdditive() ->
  fun
    (DictBounded) ->
      boundedAdditive(DictBounded)
  end.

boundedAdditive(DictBounded) ->
  DictBounded.

applyAdditive() ->
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
         functorAdditive()
     end
   }.

bindAdditive() ->
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
         applyAdditive()
     end
   }.

applicativeAdditive() ->
  #{ pure => 'Additive'()
   , 'Apply0' =>
     fun
       (_) ->
         applyAdditive()
     end
   }.

monadAdditive() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeAdditive()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindAdditive()
     end
   }.

