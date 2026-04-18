-module(data_set_nonEmpty@ps).
-export([ toUnfoldable2/0
        , unionSet/0
        , unionSet/3
        , toUnfoldable1/0
        , toUnfoldable1/2
        , toUnfoldable/0
        , toUnfoldable/1
        , toSet/0
        , toSet/1
        , subset/0
        , subset/3
        , size/0
        , size/1
        , singleton/0
        , singleton/1
        , showNonEmptySet/0
        , showNonEmptySet/1
        , semigroupNonEmptySet/0
        , semigroupNonEmptySet/1
        , properSubset/0
        , properSubset/1
        , ordNonEmptySet/0
        , ordNonEmptySet/1
        , ord1NonEmptySet/0
        , min/0
        , min/1
        , member/0
        , member/3
        , max/0
        , max/1
        , mapMaybe/0
        , mapMaybe/3
        , map/0
        , map/3
        , insert/0
        , insert/3
        , fromSet/0
        , fromSet/1
        , intersection/0
        , intersection/1
        , fromFoldable1/0
        , fromFoldable1/2
        , fromFoldable/0
        , fromFoldable/2
        , foldableNonEmptySet/0
        , foldable1NonEmptySet/0
        , filter/0
        , filter/1
        , eqNonEmptySet/0
        , eqNonEmptySet/1
        , eq1NonEmptySet/0
        , difference/0
        , difference/3
        , delete/0
        , delete/3
        , cons/0
        , cons/3
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
toUnfoldable2() ->
  data_set@ps:toUnfoldable(data_list_types@ps:unfoldableList()).

unionSet() ->
  fun
    (DictOrd) ->
      fun
        (S1) ->
          fun
            (V) ->
              unionSet(DictOrd, S1, V)
          end
      end
  end.

unionSet(DictOrd, S1, V) ->
  data_map_internal@ps:unionWith(DictOrd, data_function@ps:const(), S1, V).

toUnfoldable1() ->
  fun
    (DictUnfoldable1) ->
      fun
        (V) ->
          toUnfoldable1(DictUnfoldable1, V)
      end
  end.

toUnfoldable1(#{ unfoldr1 := DictUnfoldable1 }, V) ->
  (DictUnfoldable1(fun
     (V1 = {cons, V1@1, V1@2}) ->
       case V1 of
         {cons, _, _} ->
           case V1@2 of
             {nil} ->
               {tuple, V1@1, {nothing}};
             _ ->
               {tuple, V1@1, {just, V1@2}}
           end;
         _ ->
           erlang:error({fail, <<"Failed pattern match">>})
       end
   end))
  ((toUnfoldable2())(V)).

toUnfoldable() ->
  fun
    (DictUnfoldable) ->
      toUnfoldable(DictUnfoldable)
  end.

toUnfoldable(DictUnfoldable) ->
  data_set@ps:toUnfoldable(DictUnfoldable).

toSet() ->
  fun
    (V) ->
      toSet(V)
  end.

toSet(V) ->
  V.

subset() ->
  fun
    (DictOrd) ->
      fun
        (V) ->
          fun
            (V1) ->
              subset(DictOrd, V, V1)
          end
      end
  end.

subset(DictOrd, V, V1) ->
  begin
    V@1 = data_set@ps:difference(DictOrd, V, V1),
    ?IS_KNOWN_TAG(leaf, 0, V@1)
  end.

size() ->
  fun
    (V) ->
      size(V)
  end.

size(V) ->
  data_map_internal@ps:size(V).

singleton() ->
  fun
    (A) ->
      singleton(A)
  end.

singleton(A) ->
  {two, {leaf}, A, unit, {leaf}}.

showNonEmptySet() ->
  fun
    (DictShow) ->
      showNonEmptySet(DictShow)
  end.

showNonEmptySet(#{ show := DictShow }) ->
  #{ show =>
     fun
       (S) ->
         <<
           "(fromFoldable1 (NonEmptyArray ",
           (data_show@foreign:showArrayImpl(
              DictShow,
              toUnfoldable1(data_unfoldable1@ps:unfoldable1Array(), S)
            ))/binary,
           "))"
         >>
     end
   }.

semigroupNonEmptySet() ->
  fun
    (DictOrd) ->
      semigroupNonEmptySet(DictOrd)
  end.

semigroupNonEmptySet(DictOrd) ->
  #{ append => (data_set@ps:union())(DictOrd) }.

properSubset() ->
  fun
    (DictOrd) ->
      properSubset(DictOrd)
  end.

properSubset(DictOrd) ->
  data_set@ps:properSubset(DictOrd).

ordNonEmptySet() ->
  fun
    (DictOrd) ->
      ordNonEmptySet(DictOrd)
  end.

ordNonEmptySet(DictOrd) ->
  data_set@ps:ordSet(DictOrd).

ord1NonEmptySet() ->
  data_set@ps:ord1Set().

min() ->
  fun
    (V) ->
      min(V)
  end.

min(V) ->
  begin
    V@1 = {just, #{ key := V@2 }} = data_map_internal@ps:findMin(V),
    case V@1 of
      {just, _} ->
        V@2;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

member() ->
  fun
    (DictOrd) ->
      fun
        (A) ->
          fun
            (V) ->
              member(DictOrd, A, V)
          end
      end
  end.

member(DictOrd, A, V) ->
  begin
    V@1 = (data_map_internal@ps:lookup(DictOrd, A))(V),
    case V@1 of
      {nothing} ->
        false;
      {just, _} ->
        true;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

max() ->
  fun
    (V) ->
      max(V)
  end.

max(V) ->
  begin
    V@1 = {just, #{ key := V@2 }} = data_map_internal@ps:findMax(V),
    case V@1 of
      {just, _} ->
        V@2;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

mapMaybe() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          fun
            (V) ->
              mapMaybe(DictOrd, F, V)
          end
      end
  end.

mapMaybe(DictOrd, F, V) ->
  (data_set@ps:mapMaybe(DictOrd, F))(V).

map() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          fun
            (V) ->
              map(DictOrd, F, V)
          end
      end
  end.

map(DictOrd, F, V) ->
  (data_set@ps:map(DictOrd, F))(V).

insert() ->
  fun
    (DictOrd) ->
      fun
        (A) ->
          fun
            (V) ->
              insert(DictOrd, A, V)
          end
      end
  end.

insert(DictOrd, A, V) ->
  (data_map_internal@ps:insert(DictOrd, A, unit))(V).

fromSet() ->
  fun
    (S) ->
      fromSet(S)
  end.

fromSet(S) ->
  case S of
    {leaf} ->
      {nothing};
    _ ->
      {just, S}
  end.

intersection() ->
  fun
    (DictOrd) ->
      intersection(DictOrd)
  end.

intersection(DictOrd) ->
  begin
    Intersection1 = data_set@ps:intersection(DictOrd),
    fun
      (V) ->
        fun
          (V1) ->
            begin
              V@1 = (Intersection1(V))(V1),
              case V@1 of
                {leaf} ->
                  {nothing};
                _ ->
                  {just, V@1}
              end
            end
        end
    end
  end.

fromFoldable1() ->
  fun
    (DictFoldable1) ->
      fun
        (DictOrd) ->
          fromFoldable1(DictFoldable1, DictOrd)
      end
  end.

fromFoldable1(#{ foldMap1 := DictFoldable1 }, DictOrd) ->
  (DictFoldable1(#{ append => (data_set@ps:union())(DictOrd) }))(singleton()).

fromFoldable() ->
  fun
    (DictFoldable) ->
      fun
        (DictOrd) ->
          fromFoldable(DictFoldable, DictOrd)
      end
  end.

fromFoldable(#{ foldl := DictFoldable }, DictOrd) ->
  begin
    V =
      (DictFoldable(fun
         (M) ->
           fun
             (A) ->
               (data_map_internal@ps:insert(DictOrd, A, unit))(M)
           end
       end))
      ({leaf}),
    fun
      (X) ->
        begin
          V@1 = V(X),
          case V@1 of
            {leaf} ->
              {nothing};
            _ ->
              {just, V@1}
          end
        end
    end
  end.

foldableNonEmptySet() ->
  data_set@ps:foldableSet().

foldable1NonEmptySet() ->
  #{ foldMap1 =>
     fun
       (DictSemigroup) ->
         begin
           FoldMap11 =
             (erlang:map_get(
                foldMap1,
                data_list_types@ps:foldable1NonEmptyList()
              ))
             (DictSemigroup),
           fun
             (F) ->
               begin
                 V = FoldMap11(F),
                 fun
                   (X) ->
                     V(toUnfoldable1(
                         data_list_types@ps:unfoldable1NonEmptyList(),
                         X
                       ))
                 end
               end
           end
         end
     end
   , foldr1 =>
     fun
       (F) ->
         begin
           V =
             (erlang:map_get(
                foldr1,
                data_list_types@ps:foldable1NonEmptyList()
              ))
             (F),
           fun
             (X) ->
               V(toUnfoldable1(data_list_types@ps:unfoldable1NonEmptyList(), X))
           end
         end
     end
   , foldl1 =>
     fun
       (F) ->
         begin
           V =
             (erlang:map_get(
                foldl1,
                data_list_types@ps:foldable1NonEmptyList()
              ))
             (F),
           fun
             (X) ->
               V(toUnfoldable1(data_list_types@ps:unfoldable1NonEmptyList(), X))
           end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_set@ps:foldableSet()
     end
   }.

filter() ->
  fun
    (DictOrd) ->
      filter(DictOrd)
  end.

filter(DictOrd) ->
  data_set@ps:filter(DictOrd).

eqNonEmptySet() ->
  fun
    (DictEq) ->
      eqNonEmptySet(DictEq)
  end.

eqNonEmptySet(DictEq) ->
  #{ eq =>
     fun
       (V) ->
         fun
           (V1) ->
             ((erlang:map_get(
                 eq,
                 data_map_internal@ps:eqMap(DictEq, data_eq@ps:eqUnit())
               ))
              (V))
             (V1)
         end
     end
   }.

eq1NonEmptySet() ->
  data_set@ps:eq1Set().

difference() ->
  fun
    (DictOrd) ->
      fun
        (V) ->
          fun
            (V1) ->
              difference(DictOrd, V, V1)
          end
      end
  end.

difference(DictOrd, V, V1) ->
  begin
    V@1 = data_set@ps:difference(DictOrd, V, V1),
    case V@1 of
      {leaf} ->
        {nothing};
      _ ->
        {just, V@1}
    end
  end.

delete() ->
  fun
    (DictOrd) ->
      fun
        (A) ->
          fun
            (V) ->
              delete(DictOrd, A, V)
          end
      end
  end.

delete(DictOrd, A, V) ->
  begin
    V@1 = data_map_internal@ps:delete(DictOrd, A, V),
    case V@1 of
      {leaf} ->
        {nothing};
      _ ->
        {just, V@1}
    end
  end.

cons() ->
  fun
    (DictOrd) ->
      fun
        (A) ->
          fun
            (X) ->
              cons(DictOrd, A, X)
          end
      end
  end.

cons(DictOrd, A, X) ->
  (data_map_internal@ps:insert(DictOrd, A, unit))(X).

