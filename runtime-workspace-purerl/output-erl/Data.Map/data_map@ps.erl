-module(data_map@ps).
-export([ 'SemigroupMap'/0
        , 'SemigroupMap'/1
        , traversableWithIndexSemigroupMap/0
        , traversableSemigroupMap/0
        , showSemigroupMap/0
        , showSemigroupMap/2
        , semigroupSemigroupMap/0
        , semigroupSemigroupMap/2
        , plusSemigroupMap/0
        , plusSemigroupMap/1
        , ordSemigroupMap/0
        , ordSemigroupMap/1
        , ord1SemigroupMap/0
        , ord1SemigroupMap/1
        , newtypeSemigroupMap/0
        , monoidSemigroupMap/0
        , monoidSemigroupMap/2
        , keys/0
        , keys/1
        , functorWithIndexSemigroupMap/0
        , functorSemigroupMap/0
        , foldableWithIndexSemigroupMap/0
        , foldableSemigroupMap/0
        , eqSemigroupMap/0
        , eqSemigroupMap/2
        , eq1SemigroupMap/0
        , eq1SemigroupMap/1
        , bindSemigroupMap/0
        , bindSemigroupMap/1
        , applySemigroupMap/0
        , applySemigroupMap/1
        , altSemigroupMap/0
        , altSemigroupMap/1
        ]).
-compile(no_auto_import).
'SemigroupMap'() ->
  fun
    (X) ->
      'SemigroupMap'(X)
  end.

'SemigroupMap'(X) ->
  X.

traversableWithIndexSemigroupMap() ->
  data_map_internal@ps:traversableWithIndexMap().

traversableSemigroupMap() ->
  data_map_internal@ps:traversableMap().

showSemigroupMap() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showSemigroupMap(DictShow, DictShow1)
      end
  end.

showSemigroupMap(DictShow, DictShow1) ->
  data_map_internal@ps:showMap(DictShow, DictShow1).

semigroupSemigroupMap() ->
  fun
    (DictOrd) ->
      fun
        (DictSemigroup) ->
          semigroupSemigroupMap(DictOrd, DictSemigroup)
      end
  end.

semigroupSemigroupMap(DictOrd, #{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             data_map_internal@ps:unionWith(DictOrd, DictSemigroup, V, V1)
         end
     end
   }.

plusSemigroupMap() ->
  fun
    (DictOrd) ->
      plusSemigroupMap(DictOrd)
  end.

plusSemigroupMap(DictOrd) ->
  #{ empty => {leaf}
   , 'Alt0' =>
     fun
       (_) ->
         #{ alt => data_map_internal@ps:union(DictOrd)
          , 'Functor0' =>
            fun
              (_) ->
                data_map_internal@ps:functorMap()
            end
          }
     end
   }.

ordSemigroupMap() ->
  fun
    (DictOrd) ->
      ordSemigroupMap(DictOrd)
  end.

ordSemigroupMap(DictOrd) ->
  data_map_internal@ps:ordMap(DictOrd).

ord1SemigroupMap() ->
  fun
    (DictOrd) ->
      ord1SemigroupMap(DictOrd)
  end.

ord1SemigroupMap(DictOrd) ->
  data_map_internal@ps:ord1Map(DictOrd).

newtypeSemigroupMap() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidSemigroupMap() ->
  fun
    (DictOrd) ->
      fun
        (DictSemigroup) ->
          monoidSemigroupMap(DictOrd, DictSemigroup)
      end
  end.

monoidSemigroupMap(DictOrd, #{ append := DictSemigroup }) ->
  begin
    SemigroupSemigroupMap2 =
      #{ append =>
         fun
           (V) ->
             fun
               (V1) ->
                 data_map_internal@ps:unionWith(DictOrd, DictSemigroup, V, V1)
             end
         end
       },
    #{ mempty => {leaf}
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupSemigroupMap2
       end
     }
  end.

keys() ->
  fun
    (X) ->
      keys(X)
  end.

keys(X) ->
  ((erlang:map_get(map, data_map_internal@ps:functorMap()))
   (fun
     (_) ->
       unit
   end))
  (X).

functorWithIndexSemigroupMap() ->
  data_map_internal@ps:functorWithIndexMap().

functorSemigroupMap() ->
  data_map_internal@ps:functorMap().

foldableWithIndexSemigroupMap() ->
  data_map_internal@ps:foldableWithIndexMap().

foldableSemigroupMap() ->
  data_map_internal@ps:foldableMap().

eqSemigroupMap() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          eqSemigroupMap(DictEq, DictEq1)
      end
  end.

eqSemigroupMap(DictEq, DictEq1) ->
  data_map_internal@ps:eqMap(DictEq, DictEq1).

eq1SemigroupMap() ->
  fun
    (DictEq) ->
      eq1SemigroupMap(DictEq)
  end.

eq1SemigroupMap(DictEq) ->
  #{ eq1 =>
     fun
       (DictEq1) ->
         erlang:map_get(eq, data_map_internal@ps:eqMap(DictEq, DictEq1))
     end
   }.

bindSemigroupMap() ->
  fun
    (DictOrd) ->
      bindSemigroupMap(DictOrd)
  end.

bindSemigroupMap(DictOrd) ->
  data_map_internal@ps:bindMap(DictOrd).

applySemigroupMap() ->
  fun
    (DictOrd) ->
      applySemigroupMap(DictOrd)
  end.

applySemigroupMap(DictOrd) ->
  #{ apply =>
     ((data_map_internal@ps:intersectionWith())(DictOrd))
     (data_map_internal@ps:identity())
   , 'Functor0' =>
     fun
       (_) ->
         data_map_internal@ps:functorMap()
     end
   }.

altSemigroupMap() ->
  fun
    (DictOrd) ->
      altSemigroupMap(DictOrd)
  end.

altSemigroupMap(DictOrd) ->
  #{ alt => data_map_internal@ps:union(DictOrd)
   , 'Functor0' =>
     fun
       (_) ->
         data_map_internal@ps:functorMap()
     end
   }.

