-module(data_array_nonEmpty_internal@ps).
-export([ 'NonEmptyArray'/0
        , 'NonEmptyArray'/1
        , unfoldable1NonEmptyArray/0
        , traversableWithIndexNonEmptyArray/0
        , traversableNonEmptyArray/0
        , showNonEmptyArray/0
        , showNonEmptyArray/1
        , semigroupNonEmptyArray/0
        , ordNonEmptyArray/0
        , ordNonEmptyArray/1
        , ord1NonEmptyArray/0
        , monadNonEmptyArray/0
        , functorWithIndexNonEmptyArray/0
        , functorNonEmptyArray/0
        , foldableWithIndexNonEmptyArray/0
        , foldableNonEmptyArray/0
        , foldable1NonEmptyArray/0
        , traversable1NonEmptyArray/0
        , eqNonEmptyArray/0
        , eqNonEmptyArray/1
        , eq1NonEmptyArray/0
        , bindNonEmptyArray/0
        , applyNonEmptyArray/0
        , applicativeNonEmptyArray/0
        , altNonEmptyArray/0
        , foldl1Impl/0
        , foldr1Impl/0
        , traverse1Impl/0
        ]).
-compile(no_auto_import).
'NonEmptyArray'() ->
  fun
    (X) ->
      'NonEmptyArray'(X)
  end.

'NonEmptyArray'(X) ->
  X.

unfoldable1NonEmptyArray() ->
  data_unfoldable1@ps:unfoldable1Array().

traversableWithIndexNonEmptyArray() ->
  data_traversableWithIndex@ps:traversableWithIndexArray().

traversableNonEmptyArray() ->
  data_traversable@ps:traversableArray().

showNonEmptyArray() ->
  fun
    (DictShow) ->
      showNonEmptyArray(DictShow)
  end.

showNonEmptyArray(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(NonEmptyArray ",
           (data_show@foreign:showArrayImpl(DictShow, V))/binary,
           ")"
         >>
     end
   }.

semigroupNonEmptyArray() ->
  data_semigroup@ps:semigroupArray().

ordNonEmptyArray() ->
  fun
    (DictOrd) ->
      ordNonEmptyArray(DictOrd)
  end.

ordNonEmptyArray(DictOrd) ->
  data_ord@ps:ordArray(DictOrd).

ord1NonEmptyArray() ->
  data_ord@ps:ord1Array().

monadNonEmptyArray() ->
  control_monad@ps:monadArray().

functorWithIndexNonEmptyArray() ->
  data_functorWithIndex@ps:functorWithIndexArray().

functorNonEmptyArray() ->
  data_functor@ps:functorArray().

foldableWithIndexNonEmptyArray() ->
  data_foldableWithIndex@ps:foldableWithIndexArray().

foldableNonEmptyArray() ->
  data_foldable@ps:foldableArray().

foldable1NonEmptyArray() ->
  #{ foldMap1 =>
     fun
       (#{ append := DictSemigroup }) ->
         fun
           (F) ->
             begin
               V = (data_functor@ps:arrayMap())(F),
               V@1 =
                 (erlang:map_get(foldl1, foldable1NonEmptyArray()))
                 (DictSemigroup),
               fun
                 (X) ->
                   V@1(V(X))
               end
             end
         end
     end
   , foldr1 => foldr1Impl()
   , foldl1 => foldl1Impl()
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableArray()
     end
   }.

traversable1NonEmptyArray() ->
  #{ traverse1 =>
     fun
       (#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
         ((traverse1Impl())(DictApply@1))
         (erlang:map_get(map, DictApply(undefined)))
     end
   , sequence1 =>
     fun
       (DictApply) ->
         ((erlang:map_get(traverse1, traversable1NonEmptyArray()))(DictApply))
         (data_semigroup_traversable@ps:identity())
     end
   , 'Foldable10' =>
     fun
       (_) ->
         foldable1NonEmptyArray()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         data_traversable@ps:traversableArray()
     end
   }.

eqNonEmptyArray() ->
  fun
    (DictEq) ->
      eqNonEmptyArray(DictEq)
  end.

eqNonEmptyArray(#{ eq := DictEq }) ->
  #{ eq => (data_eq@ps:eqArrayImpl())(DictEq) }.

eq1NonEmptyArray() ->
  data_eq@ps:eq1Array().

bindNonEmptyArray() ->
  control_bind@ps:bindArray().

applyNonEmptyArray() ->
  control_apply@ps:applyArray().

applicativeNonEmptyArray() ->
  control_applicative@ps:applicativeArray().

altNonEmptyArray() ->
  control_alt@ps:altArray().

foldl1Impl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array_nonEmpty_internal@foreign:foldl1Impl(V, V@1)
      end
  end.

foldr1Impl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array_nonEmpty_internal@foreign:foldr1Impl(V, V@1)
      end
  end.

traverse1Impl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_array_nonEmpty_internal@foreign:traverse1Impl(
                    V,
                    V@1,
                    V@2,
                    V@3
                  )
              end
          end
      end
  end.

