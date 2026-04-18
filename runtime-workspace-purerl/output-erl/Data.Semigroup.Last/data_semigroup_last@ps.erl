-module(data_semigroup_last@ps).
-export([ 'Last'/0
        , 'Last'/1
        , showLast/0
        , showLast/1
        , semigroupLast/0
        , ordLast/0
        , ordLast/1
        , functorLast/0
        , eqLast/0
        , eqLast/1
        , eq1Last/0
        , ord1Last/0
        , boundedLast/0
        , boundedLast/1
        , applyLast/0
        , bindLast/0
        , applicativeLast/0
        , monadLast/0
        ]).
-compile(no_auto_import).
'Last'() ->
  fun
    (X) ->
      'Last'(X)
  end.

'Last'(X) ->
  X.

showLast() ->
  fun
    (DictShow) ->
      showLast(DictShow)
  end.

showLast(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Last ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupLast() ->
  #{ append =>
     fun
       (_) ->
         fun
           (X) ->
             X
         end
     end
   }.

ordLast() ->
  fun
    (DictOrd) ->
      ordLast(DictOrd)
  end.

ordLast(DictOrd) ->
  DictOrd.

functorLast() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             F(M)
         end
     end
   }.

eqLast() ->
  fun
    (DictEq) ->
      eqLast(DictEq)
  end.

eqLast(DictEq) ->
  DictEq.

eq1Last() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         DictEq
     end
   }.

ord1Last() ->
  #{ compare1 =>
     fun
       (#{ compare := DictOrd }) ->
         DictOrd
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Last()
     end
   }.

boundedLast() ->
  fun
    (DictBounded) ->
      boundedLast(DictBounded)
  end.

boundedLast(DictBounded) ->
  DictBounded.

applyLast() ->
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
         functorLast()
     end
   }.

bindLast() ->
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
         applyLast()
     end
   }.

applicativeLast() ->
  #{ pure => 'Last'()
   , 'Apply0' =>
     fun
       (_) ->
         applyLast()
     end
   }.

monadLast() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeLast()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindLast()
     end
   }.

