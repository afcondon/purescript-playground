-module(data_set@ps).
-export([ fromFoldable1/0
        , identity/0
        , identity/1
        , 'Set'/0
        , 'Set'/1
        , union/0
        , union/3
        , toggle/0
        , toggle/3
        , toMap/0
        , toMap/1
        , toUnfoldable/0
        , toUnfoldable/1
        , toUnfoldable1/0
        , size/0
        , size/1
        , singleton/0
        , singleton/1
        , showSet/0
        , showSet/1
        , semigroupSet/0
        , semigroupSet/1
        , member/0
        , member/3
        , isEmpty/0
        , isEmpty/1
        , insert/0
        , insert/3
        , fromMap/0
        , foldableSet/0
        , findMin/0
        , findMin/1
        , findMax/0
        , findMax/1
        , filter/0
        , filter/1
        , eqSet/0
        , eqSet/1
        , ordSet/0
        , ordSet/1
        , eq1Set/0
        , ord1Set/0
        , empty/0
        , fromFoldable/0
        , fromFoldable/2
        , intersection/0
        , intersection/1
        , map/0
        , map/2
        , mapMaybe/0
        , mapMaybe/2
        , monoidSet/0
        , monoidSet/1
        , unions/0
        , unions/2
        , delete/0
        , delete/3
        , difference/0
        , difference/3
        , subset/0
        , subset/3
        , properSubset/0
        , properSubset/1
        , checkValid/0
        , checkValid/1
        , catMaybes/0
        , catMaybes/1
        , fromFoldable1/1
        , fromMap/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
fromFoldable1() ->
  (data_array@ps:fromFoldableImpl())
  (erlang:map_get(foldr, data_list_types@ps:foldableList())).

identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

'Set'() ->
  fun
    (X) ->
      'Set'(X)
  end.

'Set'(X) ->
  X.

union() ->
  fun
    (DictOrd) ->
      fun
        (V) ->
          fun
            (V1) ->
              union(DictOrd, V, V1)
          end
      end
  end.

union(DictOrd, V, V1) ->
  data_map_internal@ps:unionWith(DictOrd, data_function@ps:const(), V, V1).

toggle() ->
  fun
    (DictOrd) ->
      fun
        (A) ->
          fun
            (V) ->
              toggle(DictOrd, A, V)
          end
      end
  end.

toggle(DictOrd, A, V) ->
  data_map_internal@ps:alter(
    DictOrd,
    fun
      (V2) ->
        case V2 of
          {nothing} ->
            {just, unit};
          {just, _} ->
            {nothing};
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
    end,
    A,
    V
  ).

toMap() ->
  fun
    (V) ->
      toMap(V)
  end.

toMap(V) ->
  V.

toUnfoldable() ->
  fun
    (DictUnfoldable) ->
      toUnfoldable(DictUnfoldable)
  end.

toUnfoldable(#{ unfoldr := DictUnfoldable }) ->
  begin
    V =
      DictUnfoldable(fun
        (Xs) ->
          case Xs of
            {nil} ->
              {nothing};
            {cons, Xs@1, Xs@2} ->
              {just, {tuple, Xs@1, Xs@2}};
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end),
    fun
      (X) ->
        V(data_map_internal@ps:keys(X))
    end
  end.

toUnfoldable1() ->
  toUnfoldable(data_unfoldable@ps:unfoldableArray()).

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

showSet() ->
  fun
    (DictShow) ->
      showSet(DictShow)
  end.

showSet(#{ show := DictShow }) ->
  #{ show =>
     fun
       (S) ->
         <<
           "(fromFoldable ",
           (data_show@foreign:showArrayImpl(DictShow, (toUnfoldable1())(S)))/binary,
           ")"
         >>
     end
   }.

semigroupSet() ->
  fun
    (DictOrd) ->
      semigroupSet(DictOrd)
  end.

semigroupSet(DictOrd) ->
  #{ append => (union())(DictOrd) }.

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

isEmpty() ->
  fun
    (V) ->
      isEmpty(V)
  end.

isEmpty(V) ->
  ?IS_KNOWN_TAG(leaf, 0, V).

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

fromMap() ->
  'Set'().

foldableSet() ->
  #{ foldMap =>
     fun
       (DictMonoid) ->
         begin
           FoldMap1 =
             (erlang:map_get(foldMap, data_list_types@ps:foldableList()))
             (DictMonoid),
           fun
             (F) ->
               begin
                 V = FoldMap1(F),
                 fun
                   (X) ->
                     V(data_map_internal@ps:keys(X))
                 end
               end
           end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (X) ->
             begin
               Go =
                 fun
                   Go (B, V) ->
                     case V of
                       {nil} ->
                         B;
                       {cons, V@1, V@2} ->
                         begin
                           B@1 = (F(B))(V@1),
                           Go(B@1, V@2)
                         end;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end,
               V =
                 fun
                   (V) ->
                     Go(X, V)
                 end,
               fun
                 (X@1) ->
                   V(data_map_internal@ps:keys(X@1))
               end
             end
         end
     end
   , foldr =>
     fun
       (F) ->
         fun
           (X) ->
             begin
               V =
                 ((erlang:map_get(foldr, data_list_types@ps:foldableList()))(F))
                 (X),
               fun
                 (X@1) ->
                   V(data_map_internal@ps:keys(X@1))
               end
             end
         end
     end
   }.

findMin() ->
  fun
    (V) ->
      findMin(V)
  end.

findMin(V) ->
  begin
    V@1 = data_map_internal@ps:findMin(V),
    case V@1 of
      {just, #{ key := V@2 }} ->
        {just, V@2};
      _ ->
        {nothing}
    end
  end.

findMax() ->
  fun
    (V) ->
      findMax(V)
  end.

findMax(V) ->
  begin
    V@1 = data_map_internal@ps:findMax(V),
    case V@1 of
      {just, #{ key := V@2 }} ->
        {just, V@2};
      _ ->
        {nothing}
    end
  end.

filter() ->
  fun
    (DictOrd) ->
      filter(DictOrd)
  end.

filter(DictOrd) ->
  begin
    FilterWithKey = data_map_internal@ps:filterWithKey(DictOrd),
    fun
      (F) ->
        fun
          (V) ->
            (FilterWithKey(fun
               (K) ->
                 fun
                   (_) ->
                     F(K)
                 end
             end))
            (V)
        end
    end
  end.

eqSet() ->
  fun
    (DictEq) ->
      eqSet(DictEq)
  end.

eqSet(DictEq) ->
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

ordSet() ->
  fun
    (DictOrd) ->
      ordSet(DictOrd)
  end.

ordSet(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    V = DictOrd@1(undefined),
    EqSet1 =
      #{ eq =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 ((erlang:map_get(
                     eq,
                     data_map_internal@ps:eqMap(V, data_eq@ps:eqUnit())
                   ))
                  (V@1))
                 (V1)
             end
         end
       },
    #{ compare =>
       fun
         (S1) ->
           fun
             (S2) ->
               ((erlang:map_get(compare, data_list_types@ps:ordList(DictOrd)))
                (data_map_internal@ps:keys(S1)))
               (data_map_internal@ps:keys(S2))
           end
       end
     , 'Eq0' =>
       fun
         (_) ->
           EqSet1
       end
     }
  end.

eq1Set() ->
  #{ eq1 =>
     fun
       (DictEq) ->
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
     end
   }.

ord1Set() ->
  #{ compare1 =>
     fun
       (DictOrd) ->
         erlang:map_get(compare, ordSet(DictOrd))
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Set()
     end
   }.

empty() ->
  {leaf}.

fromFoldable() ->
  fun
    (DictFoldable) ->
      fun
        (DictOrd) ->
          fromFoldable(DictFoldable, DictOrd)
      end
  end.

fromFoldable(#{ foldl := DictFoldable }, DictOrd) ->
  (DictFoldable(fun
     (M) ->
       fun
         (A) ->
           (data_map_internal@ps:insert(DictOrd, A, unit))(M)
       end
   end))
  ({leaf}).

intersection() ->
  fun
    (DictOrd) ->
      intersection(DictOrd)
  end.

intersection(DictOrd) ->
  begin
    FromFoldable3 =
      ((data_foldable@ps:foldlArray())
       (fun
         (M) ->
           fun
             (A) ->
               (data_map_internal@ps:insert(DictOrd, A, unit))(M)
           end
       end))
      ({leaf}),
    fun
      (S1) ->
        fun
          (S2) ->
            begin
              Rs = fromFoldable1(data_map_internal@ps:keys(S2)),
              Rl = array:size(Rs),
              Ls = fromFoldable1(data_map_internal@ps:keys(S1)),
              Ll = array:size(Ls),
              FromFoldable3(begin
                Go =
                  fun
                    Go (Acc, L, R) ->
                      if
                        (L < Ll) andalso (R < Rl) ->
                          begin
                            #{ compare := DictOrd@1 } = DictOrd,
                            V = (DictOrd@1(array:get(L, Ls)))(array:get(R, Rs)),
                            case V of
                              {eQ} ->
                                begin
                                  Acc@1 =
                                    data_array@foreign:snoc(
                                      Acc,
                                      array:get(L, Ls)
                                    ),
                                  L@1 = L + 1,
                                  fun
                                    (R@1) ->
                                      Go(Acc@1, L@1, R@1)
                                  end
                                end
                                (R + 1);
                              {lT} ->
                                begin
                                  L@2 = L + 1,
                                  fun
                                    (R@1) ->
                                      Go(Acc, L@2, R@1)
                                  end
                                end
                                (R);
                              {gT} ->
                                (fun
                                  (R@1) ->
                                    Go(Acc, L, R@1)
                                end)
                                (R + 1);
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end
                          end;
                        true ->
                          Acc
                      end
                  end,
                begin
                  Acc = array:from_list([]),
                  L = 0,
                  fun
                    (R) ->
                      Go(Acc, L, R)
                  end
                end
                (0)
              end)
            end
        end
    end
  end.

map() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          map(DictOrd, F)
      end
  end.

map(DictOrd, F) ->
  ((erlang:map_get(foldl, foldableSet()))
   (fun
     (M) ->
       fun
         (A) ->
           (data_map_internal@ps:insert(DictOrd, F(A), unit))(M)
       end
   end))
  ({leaf}).

mapMaybe() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          mapMaybe(DictOrd, F)
      end
  end.

mapMaybe(DictOrd, F) ->
  ((erlang:map_get(foldr, foldableSet()))
   (fun
     (A) ->
       fun
         (Acc) ->
           begin
             V = F(A),
             case V of
               {nothing} ->
                 Acc;
               {just, V@1} ->
                 (data_map_internal@ps:insert(DictOrd, V@1, unit))(Acc);
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
           end
       end
   end))
  ({leaf}).

monoidSet() ->
  fun
    (DictOrd) ->
      monoidSet(DictOrd)
  end.

monoidSet(DictOrd) ->
  #{ mempty => {leaf}
   , 'Semigroup0' =>
     fun
       (_) ->
         #{ append => (union())(DictOrd) }
     end
   }.

unions() ->
  fun
    (DictFoldable) ->
      fun
        (DictOrd) ->
          unions(DictFoldable, DictOrd)
      end
  end.

unions(#{ foldl := DictFoldable }, DictOrd) ->
  (DictFoldable((union())(DictOrd)))({leaf}).

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
  data_map_internal@ps:delete(DictOrd, A, V).

difference() ->
  fun
    (DictOrd) ->
      fun
        (S1) ->
          fun
            (S2) ->
              difference(DictOrd, S1, S2)
          end
      end
  end.

difference(DictOrd, S1, S2) ->
  begin
    Go =
      fun
        Go (B, V) ->
          case V of
            {nil} ->
              B;
            {cons, V@1, V@2} ->
              begin
                B@1 = data_map_internal@ps:delete(DictOrd, V@1, B),
                Go(B@1, V@2)
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V = data_map_internal@ps:keys(S2),
    Go(S1, V)
  end.

subset() ->
  fun
    (DictOrd) ->
      fun
        (S1) ->
          fun
            (S2) ->
              subset(DictOrd, S1, S2)
          end
      end
  end.

subset(DictOrd, S1, S2) ->
  begin
    V = difference(DictOrd, S1, S2),
    ?IS_KNOWN_TAG(leaf, 0, V)
  end.

properSubset() ->
  fun
    (DictOrd) ->
      properSubset(DictOrd)
  end.

properSubset(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    V = DictOrd@1(undefined),
    fun
      (S1) ->
        fun
          (S2) ->
            begin
              V@1 = difference(DictOrd, S1, S2),
              ?IS_KNOWN_TAG(leaf, 0, V@1)
            end
              andalso (not (((erlang:map_get(
                                eq,
                                data_map_internal@ps:eqMap(
                                  V,
                                  data_eq@ps:eqUnit()
                                )
                              ))
                             (S1))
                            (S2)))
        end
    end
  end.

checkValid() ->
  fun
    (V) ->
      checkValid(V)
  end.

checkValid(V) ->
  data_map_internal@ps:checkValid(V).

catMaybes() ->
  fun
    (DictOrd) ->
      catMaybes(DictOrd)
  end.

catMaybes(DictOrd) ->
  mapMaybe(DictOrd, identity()).

fromFoldable1(V) ->
  data_array@foreign:fromFoldableImpl(
    erlang:map_get(foldr, data_list_types@ps:foldableList()),
    V
  ).

fromMap(V) ->
  V.

