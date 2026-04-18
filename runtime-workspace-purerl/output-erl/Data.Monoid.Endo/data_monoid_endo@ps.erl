-module(data_monoid_endo@ps).
-export([ 'Endo'/0
        , 'Endo'/1
        , showEndo/0
        , showEndo/1
        , semigroupEndo/0
        , semigroupEndo/1
        , ordEndo/0
        , ordEndo/1
        , monoidEndo/0
        , monoidEndo/1
        , eqEndo/0
        , eqEndo/1
        , boundedEndo/0
        , boundedEndo/1
        ]).
-compile(no_auto_import).
'Endo'() ->
  fun
    (X) ->
      'Endo'(X)
  end.

'Endo'(X) ->
  X.

showEndo() ->
  fun
    (DictShow) ->
      showEndo(DictShow)
  end.

showEndo(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Endo ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupEndo() ->
  fun
    (DictSemigroupoid) ->
      semigroupEndo(DictSemigroupoid)
  end.

semigroupEndo(#{ compose := DictSemigroupoid }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemigroupoid(V))(V1)
         end
     end
   }.

ordEndo() ->
  fun
    (DictOrd) ->
      ordEndo(DictOrd)
  end.

ordEndo(DictOrd) ->
  DictOrd.

monoidEndo() ->
  fun
    (DictCategory) ->
      monoidEndo(DictCategory)
  end.

monoidEndo(#{ 'Semigroupoid0' := DictCategory, identity := DictCategory@1 }) ->
  begin
    #{ compose := V } = DictCategory(undefined),
    SemigroupEndo1 =
      #{ append =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 (V(V@1))(V1)
             end
         end
       },
    #{ mempty => DictCategory@1
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEndo1
       end
     }
  end.

eqEndo() ->
  fun
    (DictEq) ->
      eqEndo(DictEq)
  end.

eqEndo(DictEq) ->
  DictEq.

boundedEndo() ->
  fun
    (DictBounded) ->
      boundedEndo(DictBounded)
  end.

boundedEndo(DictBounded) ->
  DictBounded.

