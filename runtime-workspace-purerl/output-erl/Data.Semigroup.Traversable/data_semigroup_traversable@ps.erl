-module(data_semigroup_traversable@ps).
-export([ identity/0
        , identity/1
        , traverse1/0
        , traverse1/1
        , traversableTuple/0
        , traversableIdentity/0
        , sequence1Default/0
        , sequence1Default/2
        , traversableDual/0
        , traversableMultiplicative/0
        , sequence1/0
        , sequence1/1
        , traverse1Default/0
        , traverse1Default/2
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

traverse1() ->
  fun
    (Dict) ->
      traverse1(Dict)
  end.

traverse1(#{ traverse1 := Dict }) ->
  Dict.

traversableTuple() ->
  #{ traverse1 =>
     fun
       (#{ 'Functor0' := DictApply }) ->
         fun
           (F) ->
             fun
               (V) ->
                 ((erlang:map_get(map, DictApply(undefined)))
                  ((data_tuple@ps:'Tuple'())(erlang:element(2, V))))
                 (F(erlang:element(3, V)))
             end
         end
     end
   , sequence1 =>
     fun
       (#{ 'Functor0' := DictApply }) ->
         fun
           (V) ->
             ((erlang:map_get(map, DictApply(undefined)))
              ((data_tuple@ps:'Tuple'())(erlang:element(2, V))))
             (erlang:element(3, V))
         end
     end
   , 'Foldable10' =>
     fun
       (_) ->
         data_semigroup_foldable@ps:foldableTuple()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         data_traversable@ps:traversableTuple()
     end
   }.

traversableIdentity() ->
  #{ traverse1 =>
     fun
       (#{ 'Functor0' := DictApply }) ->
         fun
           (F) ->
             fun
               (V) ->
                 ((erlang:map_get(map, DictApply(undefined)))
                  (data_identity@ps:'Identity'()))
                 (F(V))
             end
         end
     end
   , sequence1 =>
     fun
       (#{ 'Functor0' := DictApply }) ->
         fun
           (V) ->
             ((erlang:map_get(map, DictApply(undefined)))
              (data_identity@ps:'Identity'()))
             (V)
         end
     end
   , 'Foldable10' =>
     fun
       (_) ->
         data_semigroup_foldable@ps:foldableIdentity()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         data_traversable@ps:traversableIdentity()
     end
   }.

sequence1Default() ->
  fun
    (DictTraversable1) ->
      fun
        (DictApply) ->
          sequence1Default(DictTraversable1, DictApply)
      end
  end.

sequence1Default(#{ traverse1 := DictTraversable1 }, DictApply) ->
  (DictTraversable1(DictApply))(identity()).

traversableDual() ->
  #{ traverse1 =>
     fun
       (#{ 'Functor0' := DictApply }) ->
         fun
           (F) ->
             fun
               (V) ->
                 ((erlang:map_get(map, DictApply(undefined)))
                  (data_monoid_dual@ps:'Dual'()))
                 (F(V))
             end
         end
     end
   , sequence1 =>
     fun
       (DictApply) ->
         ((erlang:map_get(traverse1, traversableDual()))(DictApply))(identity())
     end
   , 'Foldable10' =>
     fun
       (_) ->
         data_semigroup_foldable@ps:foldableDual()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         data_traversable@ps:traversableDual()
     end
   }.

traversableMultiplicative() ->
  #{ traverse1 =>
     fun
       (#{ 'Functor0' := DictApply }) ->
         fun
           (F) ->
             fun
               (V) ->
                 ((erlang:map_get(map, DictApply(undefined)))
                  (data_monoid_multiplicative@ps:'Multiplicative'()))
                 (F(V))
             end
         end
     end
   , sequence1 =>
     fun
       (DictApply) ->
         ((erlang:map_get(traverse1, traversableMultiplicative()))(DictApply))
         (identity())
     end
   , 'Foldable10' =>
     fun
       (_) ->
         data_semigroup_foldable@ps:foldableMultiplicative()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         data_traversable@ps:traversableMultiplicative()
     end
   }.

sequence1() ->
  fun
    (Dict) ->
      sequence1(Dict)
  end.

sequence1(#{ sequence1 := Dict }) ->
  Dict.

traverse1Default() ->
  fun
    (DictTraversable1) ->
      fun
        (DictApply) ->
          traverse1Default(DictTraversable1, DictApply)
      end
  end.

traverse1Default( #{ 'Traversable1' := DictTraversable1
                   , sequence1 := DictTraversable1@1
                   }
                , DictApply
                ) ->
  begin
    Sequence12 = DictTraversable1@1(DictApply),
    fun
      (F) ->
        fun
          (Ta) ->
            Sequence12(((erlang:map_get(
                           map,
                           (erlang:map_get(
                              'Functor0',
                              DictTraversable1(undefined)
                            ))
                           (undefined)
                         ))
                        (F))
                       (Ta))
        end
    end
  end.

