-module(data_semigroup_first@ps).
-export([ 'First'/0
        , 'First'/1
        , showFirst/0
        , showFirst/1
        , semigroupFirst/0
        , ordFirst/0
        , ordFirst/1
        , functorFirst/0
        , eqFirst/0
        , eqFirst/1
        , eq1First/0
        , ord1First/0
        , boundedFirst/0
        , boundedFirst/1
        , applyFirst/0
        , bindFirst/0
        , applicativeFirst/0
        , monadFirst/0
        ]).
-compile(no_auto_import).
'First'() ->
  fun
    (X) ->
      'First'(X)
  end.

'First'(X) ->
  X.

showFirst() ->
  fun
    (DictShow) ->
      showFirst(DictShow)
  end.

showFirst(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(First ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupFirst() ->
  #{ append =>
     fun
       (X) ->
         fun
           (_) ->
             X
         end
     end
   }.

ordFirst() ->
  fun
    (DictOrd) ->
      ordFirst(DictOrd)
  end.

ordFirst(DictOrd) ->
  DictOrd.

functorFirst() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             F(M)
         end
     end
   }.

eqFirst() ->
  fun
    (DictEq) ->
      eqFirst(DictEq)
  end.

eqFirst(DictEq) ->
  DictEq.

eq1First() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         DictEq
     end
   }.

ord1First() ->
  #{ compare1 =>
     fun
       (#{ compare := DictOrd }) ->
         DictOrd
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1First()
     end
   }.

boundedFirst() ->
  fun
    (DictBounded) ->
      boundedFirst(DictBounded)
  end.

boundedFirst(DictBounded) ->
  DictBounded.

applyFirst() ->
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
         functorFirst()
     end
   }.

bindFirst() ->
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
         applyFirst()
     end
   }.

applicativeFirst() ->
  #{ pure => 'First'()
   , 'Apply0' =>
     fun
       (_) ->
         applyFirst()
     end
   }.

monadFirst() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeFirst()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindFirst()
     end
   }.

