-module(data_array_nonEmpty@ps).
-export([ max/0
        , max/2
        , intercalate1/0
        , intercalate1/1
        , toArray/0
        , toArray/1
        , 'unionBy\''/0
        , 'unionBy\''/3
        , 'union\''/0
        , 'union\''/1
        , unionBy/0
        , unionBy/3
        , union/0
        , union/1
        , unzip/0
        , unzip/1
        , updateAt/0
        , updateAt/2
        , zip/0
        , zip/2
        , zipWith/0
        , zipWith/3
        , zipWithA/0
        , zipWithA/1
        , splitAt/0
        , splitAt/2
        , some/0
        , some/3
        , 'snoc\''/0
        , 'snoc\''/2
        , snoc/0
        , snoc/2
        , singleton/0
        , singleton/1
        , replicate/0
        , replicate/2
        , range/0
        , range/2
        , modifyAt/0
        , modifyAt/3
        , 'intersectBy\''/0
        , 'intersectBy\''/2
        , intersectBy/0
        , intersectBy/3
        , 'intersect\''/0
        , 'intersect\''/1
        , intersect/0
        , intersect/1
        , intercalate/0
        , intercalate/1
        , insertAt/0
        , insertAt/2
        , fromFoldable1/0
        , fromFoldable1/1
        , fromArray/0
        , fromArray/1
        , fromFoldable/0
        , fromFoldable/1
        , foldr1/0
        , foldl1/0
        , foldMap1/0
        , foldMap1/1
        , fold1/0
        , fold1/1
        , 'difference\''/0
        , 'difference\''/1
        , 'cons\''/0
        , 'cons\''/2
        , fromNonEmpty/0
        , fromNonEmpty/1
        , concatMap/0
        , concatMap/2
        , 'concat.0'/0
        , concat/0
        , concat/1
        , appendArray/0
        , appendArray/2
        , alterAt/0
        , alterAt/3
        , head/0
        , head/1
        , init/0
        , init/1
        , last/0
        , last/1
        , tail/0
        , tail/1
        , uncons/0
        , uncons/1
        , toNonEmpty/0
        , toNonEmpty/1
        , unsnoc/0
        , unsnoc/1
        , all/0
        , all/1
        , any/0
        , any/1
        , catMaybes/0
        , catMaybes/1
        , delete/0
        , delete/3
        , deleteAt/0
        , deleteAt/1
        , deleteBy/0
        , deleteBy/3
        , difference/0
        , difference/1
        , drop/0
        , drop/2
        , dropEnd/0
        , dropEnd/2
        , dropWhile/0
        , dropWhile/2
        , elem/0
        , elem/3
        , elemIndex/0
        , elemIndex/2
        , elemLastIndex/0
        , elemLastIndex/2
        , filter/0
        , filter/1
        , filterA/0
        , filterA/1
        , find/0
        , find/2
        , findIndex/0
        , findIndex/1
        , findLastIndex/0
        , findLastIndex/1
        , findMap/0
        , findMap/1
        , foldM/0
        , foldM/3
        , foldRecM/0
        , foldRecM/1
        , index/0
        , index/1
        , length/0
        , length/1
        , mapMaybe/0
        , mapMaybe/2
        , notElem/0
        , notElem/3
        , partition/0
        , partition/1
        , slice/0
        , slice/2
        , span/0
        , span/2
        , take/0
        , take/2
        , takeEnd/0
        , takeEnd/2
        , takeWhile/0
        , takeWhile/2
        , toUnfoldable/0
        , toUnfoldable/2
        , cons/0
        , cons/2
        , group/0
        , group/1
        , 'group\''/0
        , 'group\''/2
        , groupAllBy/0
        , groupAllBy/1
        , groupAll/0
        , groupAll/1
        , groupBy/0
        , groupBy/1
        , insert/0
        , insert/3
        , insertBy/0
        , insertBy/3
        , intersperse/0
        , intersperse/1
        , mapWithIndex/0
        , mapWithIndex/2
        , modifyAtIndices/0
        , modifyAtIndices/4
        , nub/0
        , nub/2
        , nubBy/0
        , nubBy/2
        , nubByEq/0
        , nubByEq/2
        , nubEq/0
        , nubEq/2
        , reverse/0
        , reverse/1
        , scanl/0
        , scanl/2
        , scanr/0
        , scanr/2
        , sort/0
        , sort/1
        , sortBy/0
        , sortBy/1
        , sortWith/0
        , sortWith/2
        , updateAtIndices/0
        , updateAtIndices/3
        , unsafeIndex/0
        , unsafeIndex/3
        , toUnfoldable1/0
        , toUnfoldable1/2
        , foldr1/2
        , foldl1/2
        , 'concat.0'/1
        ]).
-compile(no_auto_import).
max() ->
  fun
    (X) ->
      fun
        (Y) ->
          max(X, Y)
      end
  end.

max(X, Y) ->
  begin
    V = ((erlang:map_get(compare, data_ord@ps:ordInt()))(X))(Y),
    case V of
      {lT} ->
        Y;
      {eQ} ->
        X;
      {gT} ->
        X;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

intercalate1() ->
  fun
    (DictSemigroup) ->
      intercalate1(DictSemigroup)
  end.

intercalate1(#{ append := DictSemigroup }) ->
  begin
    FoldMap12 =
      (erlang:map_get(
         foldMap1,
         data_array_nonEmpty_internal@ps:foldable1NonEmptyArray()
       ))
      (#{ append =>
          fun
            (V) ->
              fun
                (V1) ->
                  fun
                    (J) ->
                      (DictSemigroup(V(J)))((DictSemigroup(J))(V1(J)))
                  end
              end
          end
        }),
    fun
      (A) ->
        fun
          (Foldable) ->
            ((FoldMap12(fun
                (X) ->
                  fun
                    (_) ->
                      X
                  end
              end))
             (Foldable))
            (A)
        end
    end
  end.

toArray() ->
  fun
    (V) ->
      toArray(V)
  end.

toArray(V) ->
  V.

'unionBy\''() ->
  fun
    (Eq) ->
      fun
        (Xs) ->
          fun
            (X) ->
              'unionBy\''(Eq, Xs, X)
          end
      end
  end.

'unionBy\''(Eq, Xs, X) ->
  data_array@ps:unionBy(Eq, Xs, X).

'union\''() ->
  fun
    (DictEq) ->
      'union\''(DictEq)
  end.

'union\''(#{ eq := DictEq }) ->
  ('unionBy\''())(DictEq).

unionBy() ->
  fun
    (Eq) ->
      fun
        (Xs) ->
          fun
            (X) ->
              unionBy(Eq, Xs, X)
          end
      end
  end.

unionBy(Eq, Xs, X) ->
  data_array@ps:unionBy(Eq, Xs, X).

union() ->
  fun
    (DictEq) ->
      union(DictEq)
  end.

union(#{ eq := DictEq }) ->
  (unionBy())(DictEq).

unzip() ->
  fun
    (X) ->
      unzip(X)
  end.

unzip(X) ->
  begin
    V = data_array@ps:unzip(X),
    {tuple, erlang:element(2, V), erlang:element(3, V)}
  end.

updateAt() ->
  fun
    (I) ->
      fun
        (X) ->
          updateAt(I, X)
      end
  end.

updateAt(I, X) ->
  ((data_array@ps:updateAt())(I))(X).

zip() ->
  fun
    (Xs) ->
      fun
        (Ys) ->
          zip(Xs, Ys)
      end
  end.

zip(Xs, Ys) ->
  data_array@ps:zip(Xs, Ys).

zipWith() ->
  fun
    (F) ->
      fun
        (Xs) ->
          fun
            (Ys) ->
              zipWith(F, Xs, Ys)
          end
      end
  end.

zipWith(F, Xs, Ys) ->
  data_array@foreign:zipWith(F, Xs, Ys).

zipWithA() ->
  fun
    (DictApplicative) ->
      zipWithA(DictApplicative)
  end.

zipWithA(DictApplicative) ->
  data_array@ps:zipWithA(DictApplicative).

splitAt() ->
  fun
    (I) ->
      fun
        (Xs) ->
          splitAt(I, Xs)
      end
  end.

splitAt(I, Xs) ->
  data_array@ps:splitAt(I, Xs).

some() ->
  fun
    (DictAlternative) ->
      fun
        (DictLazy) ->
          fun
            (X) ->
              some(DictAlternative, DictLazy, X)
          end
      end
  end.

some(DictAlternative, DictLazy, X) ->
  data_array@ps:some(DictAlternative, DictLazy, X).

'snoc\''() ->
  fun
    (Xs) ->
      fun
        (X) ->
          'snoc\''(Xs, X)
      end
  end.

'snoc\''(Xs, X) ->
  data_array@foreign:snoc(Xs, X).

snoc() ->
  fun
    (Xs) ->
      fun
        (X) ->
          snoc(Xs, X)
      end
  end.

snoc(Xs, X) ->
  data_array@foreign:snoc(Xs, X).

singleton() ->
  fun
    (X) ->
      singleton(X)
  end.

singleton(X) ->
  array:from_list([X]).

replicate() ->
  fun
    (I) ->
      fun
        (X) ->
          replicate(I, X)
      end
  end.

replicate(I, X) ->
  data_array@foreign:replicate(max(1, I), X).

range() ->
  fun
    (X) ->
      fun
        (Y) ->
          range(X, Y)
      end
  end.

range(X, Y) ->
  data_array@foreign:range(X, Y).

modifyAt() ->
  fun
    (I) ->
      fun
        (F) ->
          fun
            (X) ->
              modifyAt(I, F, X)
          end
      end
  end.

modifyAt(I, F, X) ->
  data_array@ps:modifyAt(I, F, X).

'intersectBy\''() ->
  fun
    (Eq) ->
      fun
        (Xs) ->
          'intersectBy\''(Eq, Xs)
      end
  end.

'intersectBy\''(Eq, Xs) ->
  ((data_array@ps:intersectBy())(Eq))(Xs).

intersectBy() ->
  fun
    (Eq) ->
      fun
        (Xs) ->
          fun
            (X) ->
              intersectBy(Eq, Xs, X)
          end
      end
  end.

intersectBy(Eq, Xs, X) ->
  data_array@ps:intersectBy(Eq, Xs, X).

'intersect\''() ->
  fun
    (DictEq) ->
      'intersect\''(DictEq)
  end.

'intersect\''(#{ eq := DictEq }) ->
  ('intersectBy\''())(DictEq).

intersect() ->
  fun
    (DictEq) ->
      intersect(DictEq)
  end.

intersect(#{ eq := DictEq }) ->
  (intersectBy())(DictEq).

intercalate() ->
  fun
    (DictSemigroup) ->
      intercalate(DictSemigroup)
  end.

intercalate(DictSemigroup) ->
  intercalate1(DictSemigroup).

insertAt() ->
  fun
    (I) ->
      fun
        (X) ->
          insertAt(I, X)
      end
  end.

insertAt(I, X) ->
  ((data_array@ps:insertAt())(I))(X).

fromFoldable1() ->
  fun
    (DictFoldable1) ->
      fromFoldable1(DictFoldable1)
  end.

fromFoldable1(#{ 'Foldable0' := DictFoldable1 }) ->
  (data_array@ps:fromFoldableImpl())
  (erlang:map_get(foldr, DictFoldable1(undefined))).

fromArray() ->
  fun
    (Xs) ->
      fromArray(Xs)
  end.

fromArray(Xs) ->
  case (array:size(Xs)) > 0 of
    true ->
      {just, Xs};
    _ ->
      {nothing}
  end.

fromFoldable() ->
  fun
    (DictFoldable) ->
      fromFoldable(DictFoldable)
  end.

fromFoldable(#{ foldr := DictFoldable }) ->
  begin
    V = (data_array@ps:fromFoldableImpl())(DictFoldable),
    fun
      (X) ->
        begin
          V@1 = V(X),
          case (array:size(V@1)) > 0 of
            true ->
              {just, V@1};
            _ ->
              {nothing}
          end
        end
    end
  end.

foldr1() ->
  data_array_nonEmpty_internal@ps:foldr1Impl().

foldl1() ->
  data_array_nonEmpty_internal@ps:foldl1Impl().

foldMap1() ->
  fun
    (DictSemigroup) ->
      foldMap1(DictSemigroup)
  end.

foldMap1(DictSemigroup) ->
  (erlang:map_get(
     foldMap1,
     data_array_nonEmpty_internal@ps:foldable1NonEmptyArray()
   ))
  (DictSemigroup).

fold1() ->
  fun
    (DictSemigroup) ->
      fold1(DictSemigroup)
  end.

fold1(DictSemigroup) ->
  ((erlang:map_get(
      foldMap1,
      data_array_nonEmpty_internal@ps:foldable1NonEmptyArray()
    ))
   (DictSemigroup))
  (data_semigroup_foldable@ps:identity()).

'difference\''() ->
  fun
    (DictEq) ->
      'difference\''(DictEq)
  end.

'difference\''(DictEq) ->
  (data_foldable@ps:foldrArray())(data_array@ps:delete(DictEq)).

'cons\''() ->
  fun
    (X) ->
      fun
        (Xs) ->
          'cons\''(X, Xs)
      end
  end.

'cons\''(X, Xs) ->
  data_semigroup@foreign:concatArray(array:from_list([X]), Xs).

fromNonEmpty() ->
  fun
    (V) ->
      fromNonEmpty(V)
  end.

fromNonEmpty(V) ->
  data_semigroup@foreign:concatArray(
    array:from_list([erlang:element(2, V)]),
    erlang:element(3, V)
  ).

concatMap() ->
  fun
    (B) ->
      fun
        (A) ->
          concatMap(B, A)
      end
  end.

concatMap(B, A) ->
  control_bind@foreign:arrayBind(A, B).

'concat.0'() ->
  (data_functor@ps:arrayMap())(toArray()).

concat() ->
  fun
    (X) ->
      concat(X)
  end.

concat(X) ->
  data_array@foreign:concat('concat.0'(X)).

appendArray() ->
  fun
    (Xs) ->
      fun
        (Ys) ->
          appendArray(Xs, Ys)
      end
  end.

appendArray(Xs, Ys) ->
  data_semigroup@foreign:concatArray(Xs, Ys).

alterAt() ->
  fun
    (I) ->
      fun
        (F) ->
          fun
            (X) ->
              alterAt(I, F, X)
          end
      end
  end.

alterAt(I, F, X) ->
  data_array@ps:alterAt(I, F, X).

head() ->
  fun
    (X) ->
      head(X)
  end.

head(X) ->
  begin
    V = {just, V@1} = data_array@ps:index(X, 0),
    case V of
      {just, _} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

init() ->
  fun
    (X) ->
      init(X)
  end.

init(X) ->
  begin
    V = {just, V@1} = data_array@ps:init(X),
    case V of
      {just, _} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

last() ->
  fun
    (X) ->
      last(X)
  end.

last(X) ->
  begin
    V = {just, V@1} = data_array@ps:index(X, (array:size(X)) - 1),
    case V of
      {just, _} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

tail() ->
  fun
    (X) ->
      tail(X)
  end.

tail(X) ->
  begin
    V = {just, V@1} = data_array@ps:tail(X),
    case V of
      {just, _} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

uncons() ->
  fun
    (X) ->
      uncons(X)
  end.

uncons(X) ->
  begin
    V = {just, V@1} = data_array@ps:uncons(X),
    case V of
      {just, _} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

toNonEmpty() ->
  fun
    (X) ->
      toNonEmpty(X)
  end.

toNonEmpty(X) ->
  begin
    V = {just, V@1} = data_array@ps:uncons(X),
    #{ head := V@2, tail := V@3 } =
      case V of
        {just, _} ->
          V@1;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end,
    {nonEmpty, V@2, V@3}
  end.

unsnoc() ->
  fun
    (X) ->
      unsnoc(X)
  end.

unsnoc(X) ->
  begin
    V = {just, V@1} = data_array@ps:unsnoc(X),
    case V of
      {just, _} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

all() ->
  fun
    (P) ->
      all(P)
  end.

all(P) ->
  (data_array@ps:all())(P).

any() ->
  fun
    (P) ->
      any(P)
  end.

any(P) ->
  (data_array@ps:any())(P).

catMaybes() ->
  fun
    (X) ->
      catMaybes(X)
  end.

catMaybes(X) ->
  (data_array@ps:mapMaybe(fun
     (X@1) ->
       X@1
   end))
  (X).

delete() ->
  fun
    (DictEq) ->
      fun
        (X) ->
          fun
            (X@1) ->
              delete(DictEq, X, X@1)
          end
      end
  end.

delete(#{ eq := DictEq }, X, X@1) ->
  data_array@ps:deleteBy(DictEq, X, X@1).

deleteAt() ->
  fun
    (I) ->
      deleteAt(I)
  end.

deleteAt(I) ->
  (data_array@ps:deleteAt())(I).

deleteBy() ->
  fun
    (F) ->
      fun
        (X) ->
          fun
            (X@1) ->
              deleteBy(F, X, X@1)
          end
      end
  end.

deleteBy(F, X, X@1) ->
  data_array@ps:deleteBy(F, X, X@1).

difference() ->
  fun
    (DictEq) ->
      difference(DictEq)
  end.

difference(DictEq) ->
  (data_foldable@ps:foldrArray())(data_array@ps:delete(DictEq)).

drop() ->
  fun
    (I) ->
      fun
        (X) ->
          drop(I, X)
      end
  end.

drop(I, X) ->
  if
    I < 1 ->
      X;
    true ->
      data_array@foreign:slice(I, array:size(X), X)
  end.

dropEnd() ->
  fun
    (I) ->
      fun
        (X) ->
          dropEnd(I, X)
      end
  end.

dropEnd(I, X) ->
  data_array@ps:dropEnd(I, X).

dropWhile() ->
  fun
    (F) ->
      fun
        (X) ->
          dropWhile(F, X)
      end
  end.

dropWhile(F, X) ->
  erlang:map_get(rest, data_array@ps:span(F, X)).

elem() ->
  fun
    (DictEq) ->
      fun
        (X) ->
          fun
            (X@1) ->
              elem(DictEq, X, X@1)
          end
      end
  end.

elem(DictEq, X, X@1) ->
  data_array@ps:elem(DictEq, X, X@1).

elemIndex() ->
  fun
    (DictEq) ->
      fun
        (X) ->
          elemIndex(DictEq, X)
      end
  end.

elemIndex(#{ eq := DictEq }, X) ->
  (data_array@ps:findIndex())
  (fun
    (V) ->
      (DictEq(V))(X)
  end).

elemLastIndex() ->
  fun
    (DictEq) ->
      fun
        (X) ->
          elemLastIndex(DictEq, X)
      end
  end.

elemLastIndex(#{ eq := DictEq }, X) ->
  (data_array@ps:findLastIndex())
  (fun
    (V) ->
      (DictEq(V))(X)
  end).

filter() ->
  fun
    (F) ->
      filter(F)
  end.

filter(F) ->
  (data_array@ps:filter())(F).

filterA() ->
  fun
    (DictApplicative) ->
      filterA(DictApplicative)
  end.

filterA(DictApplicative) ->
  data_array@ps:filterA(DictApplicative).

find() ->
  fun
    (P) ->
      fun
        (X) ->
          find(P, X)
      end
  end.

find(P, X) ->
  begin
    V = data_array@ps:findIndex(P, X),
    case V of
      {just, V@1} ->
        {just, array:get(V@1, X)};
      _ ->
        {nothing}
    end
  end.

findIndex() ->
  fun
    (P) ->
      findIndex(P)
  end.

findIndex(P) ->
  (data_array@ps:findIndex())(P).

findLastIndex() ->
  fun
    (X) ->
      findLastIndex(X)
  end.

findLastIndex(X) ->
  (data_array@ps:findLastIndex())(X).

findMap() ->
  fun
    (P) ->
      findMap(P)
  end.

findMap(P) ->
  (data_array@ps:findMap())(P).

foldM() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (Acc) ->
              foldM(DictMonad, F, Acc)
          end
      end
  end.

foldM(DictMonad, F, Acc) ->
  data_array@ps:foldM(DictMonad, F, Acc).

foldRecM() ->
  fun
    (DictMonadRec) ->
      foldRecM(DictMonadRec)
  end.

foldRecM(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1 } = DictMonadRec(undefined),
    #{ pure := V } = Monad0@1(undefined),
    fun
      (F) ->
        fun
          (Acc) ->
            fun
              (Array) ->
                (DictMonadRec@1(fun
                   (#{ a := O, b := O@1 }) ->
                     case O@1 >= (array:size(Array)) of
                       true ->
                         V({done, O});
                       _ ->
                         begin
                           #{ 'Bind1' := Monad0@2 } = Monad0,
                           ((erlang:map_get(bind, Monad0@2(undefined)))
                            ((F(O))(array:get(O@1, Array))))
                           (fun
                             (Res_) ->
                               V({loop, #{ a => Res_, b => O@1 + 1 }})
                           end)
                         end
                     end
                 end))
                (#{ a => Acc, b => 0 })
            end
        end
    end
  end.

index() ->
  fun
    (X) ->
      index(X)
  end.

index(X) ->
  (data_array@ps:index())(X).

length() ->
  fun
    (X) ->
      length(X)
  end.

length(X) ->
  array:size(X).

mapMaybe() ->
  fun
    (F) ->
      fun
        (X) ->
          mapMaybe(F, X)
      end
  end.

mapMaybe(F, X) ->
  (data_array@ps:mapMaybe(F))(X).

notElem() ->
  fun
    (DictEq) ->
      fun
        (X) ->
          fun
            (X@1) ->
              notElem(DictEq, X, X@1)
          end
      end
  end.

notElem(DictEq, X, X@1) ->
  data_array@ps:notElem(DictEq, X, X@1).

partition() ->
  fun
    (F) ->
      partition(F)
  end.

partition(F) ->
  (data_array@ps:partition())(F).

slice() ->
  fun
    (Start) ->
      fun
        (End) ->
          slice(Start, End)
      end
  end.

slice(Start, End) ->
  ((data_array@ps:slice())(Start))(End).

span() ->
  fun
    (F) ->
      fun
        (X) ->
          span(F, X)
      end
  end.

span(F, X) ->
  data_array@ps:span(F, X).

take() ->
  fun
    (I) ->
      fun
        (X) ->
          take(I, X)
      end
  end.

take(I, X) ->
  if
    I < 1 ->
      array:from_list([]);
    true ->
      data_array@foreign:slice(0, I, X)
  end.

takeEnd() ->
  fun
    (I) ->
      fun
        (X) ->
          takeEnd(I, X)
      end
  end.

takeEnd(I, X) ->
  data_array@ps:takeEnd(I, X).

takeWhile() ->
  fun
    (F) ->
      fun
        (X) ->
          takeWhile(F, X)
      end
  end.

takeWhile(F, X) ->
  erlang:map_get(init, data_array@ps:span(F, X)).

toUnfoldable() ->
  fun
    (DictUnfoldable) ->
      fun
        (X) ->
          toUnfoldable(DictUnfoldable, X)
      end
  end.

toUnfoldable(#{ unfoldr := DictUnfoldable }, X) ->
  begin
    Len = array:size(X),
    (DictUnfoldable(fun
       (I) ->
         if
           I < Len ->
             {just, {tuple, array:get(I, X), I + 1}};
           true ->
             {nothing}
         end
     end))
    (0)
  end.

cons() ->
  fun
    (X) ->
      fun
        (X@1) ->
          cons(X, X@1)
      end
  end.

cons(X, X@1) ->
  data_semigroup@foreign:concatArray(array:from_list([X]), X@1).

group() ->
  fun
    (DictEq) ->
      group(DictEq)
  end.

group(#{ eq := DictEq }) ->
  fun
    (X) ->
      (data_array@ps:groupBy(DictEq))(X)
  end.

'group\''() ->
  fun
    (V) ->
      fun
        (DictOrd) ->
          'group\''(V, DictOrd)
      end
  end.

'group\''(_, #{ compare := DictOrd }) ->
  data_array@ps:groupAllBy(DictOrd).

groupAllBy() ->
  fun
    (Op) ->
      groupAllBy(Op)
  end.

groupAllBy(Op) ->
  data_array@ps:groupAllBy(Op).

groupAll() ->
  fun
    (DictOrd) ->
      groupAll(DictOrd)
  end.

groupAll(#{ compare := DictOrd }) ->
  data_array@ps:groupAllBy(DictOrd).

groupBy() ->
  fun
    (Op) ->
      groupBy(Op)
  end.

groupBy(Op) ->
  data_array@ps:groupBy(Op).

insert() ->
  fun
    (DictOrd) ->
      fun
        (X) ->
          fun
            (X@1) ->
              insert(DictOrd, X, X@1)
          end
      end
  end.

insert(#{ compare := DictOrd }, X, X@1) ->
  data_array@ps:insertBy(DictOrd, X, X@1).

insertBy() ->
  fun
    (F) ->
      fun
        (X) ->
          fun
            (X@1) ->
              insertBy(F, X, X@1)
          end
      end
  end.

insertBy(F, X, X@1) ->
  data_array@ps:insertBy(F, X, X@1).

intersperse() ->
  fun
    (X) ->
      intersperse(X)
  end.

intersperse(X) ->
  (data_array@ps:intersperse())(X).

mapWithIndex() ->
  fun
    (F) ->
      fun
        (X) ->
          mapWithIndex(F, X)
      end
  end.

mapWithIndex(F, X) ->
  data_array@ps:mapWithIndex(F, X).

modifyAtIndices() ->
  fun
    (DictFoldable) ->
      fun
        (Is) ->
          fun
            (F) ->
              fun
                (X) ->
                  modifyAtIndices(DictFoldable, Is, F, X)
              end
          end
      end
  end.

modifyAtIndices(DictFoldable, Is, F, X) ->
  data_array@ps:modifyAtIndices(DictFoldable, Is, F, X).

nub() ->
  fun
    (DictOrd) ->
      fun
        (X) ->
          nub(DictOrd, X)
      end
  end.

nub(#{ compare := DictOrd }, X) ->
  data_array@ps:nubBy(DictOrd, X).

nubBy() ->
  fun
    (F) ->
      fun
        (X) ->
          nubBy(F, X)
      end
  end.

nubBy(F, X) ->
  data_array@ps:nubBy(F, X).

nubByEq() ->
  fun
    (F) ->
      fun
        (X) ->
          nubByEq(F, X)
      end
  end.

nubByEq(F, X) ->
  data_array@ps:nubByEq(F, X).

nubEq() ->
  fun
    (DictEq) ->
      fun
        (X) ->
          nubEq(DictEq, X)
      end
  end.

nubEq(#{ eq := DictEq }, X) ->
  data_array@ps:nubByEq(DictEq, X).

reverse() ->
  fun
    (X) ->
      reverse(X)
  end.

reverse(X) ->
  data_array@foreign:reverse(X).

scanl() ->
  fun
    (F) ->
      fun
        (X) ->
          scanl(F, X)
      end
  end.

scanl(F, X) ->
  ((data_array@ps:scanl())(F))(X).

scanr() ->
  fun
    (F) ->
      fun
        (X) ->
          scanr(F, X)
      end
  end.

scanr(F, X) ->
  ((data_array@ps:scanr())(F))(X).

sort() ->
  fun
    (DictOrd) ->
      sort(DictOrd)
  end.

sort(#{ compare := DictOrd }) ->
  fun
    (X) ->
      (data_array@ps:sortBy(DictOrd))(X)
  end.

sortBy() ->
  fun
    (F) ->
      sortBy(F)
  end.

sortBy(F) ->
  data_array@ps:sortBy(F).

sortWith() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          sortWith(DictOrd, F)
      end
  end.

sortWith(DictOrd, F) ->
  data_array@ps:sortWith(DictOrd, F).

updateAtIndices() ->
  fun
    (DictFoldable) ->
      fun
        (Pairs) ->
          fun
            (X) ->
              updateAtIndices(DictFoldable, Pairs, X)
          end
      end
  end.

updateAtIndices(DictFoldable, Pairs, X) ->
  data_array@ps:updateAtIndices(DictFoldable, Pairs, X).

unsafeIndex() ->
  fun
    (V) ->
      fun
        (X) ->
          fun
            (V@1) ->
              unsafeIndex(V, X, V@1)
          end
      end
  end.

unsafeIndex(_, X, V) ->
  array:get(V, X).

toUnfoldable1() ->
  fun
    (DictUnfoldable1) ->
      fun
        (Xs) ->
          toUnfoldable1(DictUnfoldable1, Xs)
      end
  end.

toUnfoldable1(#{ unfoldr1 := DictUnfoldable1 }, Xs) ->
  begin
    Len = array:size(Xs),
    (DictUnfoldable1(fun
       (I) ->
         { tuple
         , array:get(I, Xs)
         , if
             I < (Len - 1) ->
               {just, I + 1};
             true ->
               {nothing}
           end
         }
     end))
    (0)
  end.

foldr1(V, V@1) ->
  data_array_nonEmpty_internal@foreign:foldr1Impl(V, V@1).

foldl1(V, V@1) ->
  data_array_nonEmpty_internal@foreign:foldl1Impl(V, V@1).

'concat.0'(V) ->
  data_functor@foreign:arrayMap(toArray(), V).

