-module(data_array@ps).
-export([ intercalate1/0
        , intercalate1/1
        , zipWithA/0
        , zipWithA/1
        , zip/0
        , updateAt/0
        , updateAtIndices/0
        , updateAtIndices/3
        , unsafeIndex/0
        , unsafeIndex/1
        , uncons/0
        , toUnfoldable/0
        , toUnfoldable/2
        , take/0
        , take/2
        , tail/0
        , splitAt/0
        , splitAt/2
        , sortBy/0
        , sortBy/1
        , sortWith/0
        , sortWith/2
        , sort/0
        , sort/1
        , singleton/0
        , singleton/1
        , null/0
        , null/1
        , mapWithIndex/0
        , mapWithIndex/2
        , intercalate/0
        , intercalate/1
        , insertAt/0
        , init/0
        , init/1
        , index/0
        , last/0
        , last/1
        , unsnoc/0
        , unsnoc/1
        , modifyAt/0
        , modifyAt/3
        , modifyAtIndices/0
        , modifyAtIndices/4
        , span/0
        , span/2
        , takeWhile/0
        , takeWhile/2
        , head/0
        , head/1
        , fromFoldable/0
        , fromFoldable/1
        , foldr/0
        , foldl/0
        , foldRecM/0
        , foldRecM/1
        , foldMap/0
        , foldMap/1
        , foldM/0
        , foldM/3
        , fold/0
        , fold/1
        , findMap/0
        , findLastIndex/0
        , insertBy/0
        , insertBy/3
        , insert/0
        , insert/1
        , findIndex/0
        , intersectBy/0
        , intersectBy/3
        , intersect/0
        , intersect/1
        , find/0
        , find/2
        , elemLastIndex/0
        , elemLastIndex/2
        , elemIndex/0
        , elemIndex/2
        , notElem/0
        , notElem/3
        , elem/0
        , elem/3
        , dropWhile/0
        , dropWhile/2
        , dropEnd/0
        , dropEnd/2
        , drop/0
        , drop/2
        , takeEnd/0
        , takeEnd/2
        , deleteAt/0
        , deleteBy/0
        , deleteBy/3
        , delete/0
        , delete/1
        , difference/0
        , difference/1
        , cons/0
        , cons/2
        , groupBy/0
        , groupBy/1
        , group/0
        , group/1
        , groupAllBy/0
        , groupAllBy/1
        , groupAll/0
        , groupAll/1
        , 'group\''/0
        , 'group\''/2
        , nubBy/0
        , nubBy/2
        , nub/0
        , nub/1
        , nubByEq/0
        , nubByEq/2
        , nubEq/0
        , nubEq/1
        , unionBy/0
        , unionBy/3
        , union/0
        , union/1
        , some/0
        , some/3
        , many/0
        , many/3
        , unzip/0
        , concatMap/0
        , concatMap/2
        , mapMaybe/0
        , mapMaybe/1
        , filterA/0
        , filterA/1
        , catMaybes/0
        , alterAt/0
        , alterAt/3
        , range/0
        , replicate/0
        , fromFoldableImpl/0
        , length/0
        , snoc/0
        , unconsImpl/0
        , indexImpl/0
        , findMapImpl/0
        , findIndexImpl/0
        , findLastIndexImpl/0
        , '_insertAt'/0
        , '_deleteAt'/0
        , '_updateAt'/0
        , reverse/0
        , concat/0
        , filter/0
        , partition/0
        , scanl/0
        , scanr/0
        , intersperse/0
        , sortByImpl/0
        , slice/0
        , zipWith/0
        , unsafeIndexImpl/0
        , any/0
        , all/0
        , zip/2
        , updateAt/3
        , uncons/1
        , tail/1
        , insertAt/3
        , index/2
        , foldr/3
        , foldl/3
        , findMap/2
        , findLastIndex/2
        , findIndex/2
        , deleteAt/2
        , unzip/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
intercalate1() ->
  fun
    (DictMonoid) ->
      intercalate1(DictMonoid)
  end.

intercalate1(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    V = DictMonoid(undefined),
    fun
      (Sep) ->
        fun
          (Xs) ->
            erlang:map_get(
              acc,
              data_foldable@foreign:foldlArray(
                fun
                  (V@1) ->
                    fun
                      (V1) ->
                        if
                          erlang:map_get(init, V@1) ->
                            #{ init => false, acc => V1 };
                          true ->
                            begin
                              #{ append := V@2 } = V,
                              #{ init => false
                               , acc =>
                                 (V@2(erlang:map_get(acc, V@1)))((V@2(Sep))(V1))
                               }
                            end
                        end
                    end
                end,
                #{ init => true, acc => DictMonoid@1 },
                Xs
              )
            )
        end
    end
  end.

zipWithA() ->
  fun
    (DictApplicative) ->
      zipWithA(DictApplicative)
  end.

zipWithA(DictApplicative) ->
  begin
    Sequence1 =
      ((erlang:map_get(traverse, data_traversable@ps:traversableArray()))
       (DictApplicative))
      (data_traversable@ps:identity()),
    fun
      (F) ->
        fun
          (Xs) ->
            fun
              (Ys) ->
                Sequence1(data_array@foreign:zipWith(F, Xs, Ys))
            end
        end
    end
  end.

zip() ->
  (zipWith())(data_tuple@ps:'Tuple'()).

updateAt() ->
  (('_updateAt'())(data_maybe@ps:'Just'()))({nothing}).

updateAtIndices() ->
  fun
    (DictFoldable) ->
      fun
        (Us) ->
          fun
            (Xs) ->
              updateAtIndices(DictFoldable, Us, Xs)
          end
      end
  end.

updateAtIndices(#{ foldl := DictFoldable }, Us, Xs) ->
  ((DictFoldable(fun
      (Xs_) ->
        fun
          (V) ->
            begin
              V@1 = updateAt(erlang:element(2, V), erlang:element(3, V), Xs_),
              case V@1 of
                {nothing} ->
                  Xs_;
                {just, V@2} ->
                  V@2;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
            end
        end
    end))
   (Xs))
  (Us).

unsafeIndex() ->
  fun
    (V) ->
      unsafeIndex(V)
  end.

unsafeIndex(_) ->
  unsafeIndexImpl().

uncons() ->
  ((unconsImpl())
   (fun
     (_) ->
       {nothing}
   end))
  (fun
    (X) ->
      fun
        (Xs) ->
          {just, #{ head => X, tail => Xs }}
      end
  end).

toUnfoldable() ->
  fun
    (DictUnfoldable) ->
      fun
        (Xs) ->
          toUnfoldable(DictUnfoldable, Xs)
      end
  end.

toUnfoldable(#{ unfoldr := DictUnfoldable }, Xs) ->
  begin
    Len = array:size(Xs),
    (DictUnfoldable(fun
       (I) ->
         if
           I < Len ->
             {just, {tuple, array:get(I, Xs), I + 1}};
           true ->
             {nothing}
         end
     end))
    (0)
  end.

take() ->
  fun
    (N) ->
      fun
        (Xs) ->
          take(N, Xs)
      end
  end.

take(N, Xs) ->
  if
    N < 1 ->
      array:from_list([]);
    true ->
      data_array@foreign:slice(0, N, Xs)
  end.

tail() ->
  ((unconsImpl())
   (fun
     (_) ->
       {nothing}
   end))
  (fun
    (_) ->
      fun
        (Xs) ->
          {just, Xs}
      end
  end).

splitAt() ->
  fun
    (V) ->
      fun
        (V1) ->
          splitAt(V, V1)
      end
  end.

splitAt(V, V1) ->
  if
    V =< 0 ->
      #{ before => array:from_list([]), 'after' => V1 };
    true ->
      #{ before => data_array@foreign:slice(0, V, V1)
       , 'after' => data_array@foreign:slice(V, array:size(V1), V1)
       }
  end.

sortBy() ->
  fun
    (Comp) ->
      sortBy(Comp)
  end.

sortBy(Comp) ->
  ((sortByImpl())(Comp))
  (fun
    (V) ->
      case V of
        {gT} ->
          1;
        {eQ} ->
          0;
        {lT} ->
          -1;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end
  end).

sortWith() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          sortWith(DictOrd, F)
      end
  end.

sortWith(#{ compare := DictOrd }, F) ->
  sortBy(fun
    (X) ->
      fun
        (Y) ->
          (DictOrd(F(X)))(F(Y))
      end
  end).

sort() ->
  fun
    (DictOrd) ->
      sort(DictOrd)
  end.

sort(#{ compare := DictOrd }) ->
  fun
    (Xs) ->
      (sortBy(DictOrd))(Xs)
  end.

singleton() ->
  fun
    (A) ->
      singleton(A)
  end.

singleton(A) ->
  array:from_list([A]).

null() ->
  fun
    (Xs) ->
      null(Xs)
  end.

null(Xs) ->
  (array:size(Xs)) =:= 0.

mapWithIndex() ->
  fun
    (V) ->
      fun
        (V1) ->
          mapWithIndex(V, V1)
      end
  end.

mapWithIndex(V, V1) ->
  case (array:size(V1)) =:= 0 of
    true ->
      array:from_list([]);
    _ ->
      data_array@foreign:zipWith(
        V,
        data_array@foreign:range(0, (array:size(V1)) - 1),
        V1
      )
  end.

intercalate() ->
  fun
    (DictMonoid) ->
      intercalate(DictMonoid)
  end.

intercalate(DictMonoid) ->
  intercalate1(DictMonoid).

insertAt() ->
  (('_insertAt'())(data_maybe@ps:'Just'()))({nothing}).

init() ->
  fun
    (Xs) ->
      init(Xs)
  end.

init(Xs) ->
  case (array:size(Xs)) =:= 0 of
    true ->
      {nothing};
    _ ->
      {just, data_array@foreign:slice(0, (array:size(Xs)) - 1, Xs)}
  end.

index() ->
  ((indexImpl())(data_maybe@ps:'Just'()))({nothing}).

last() ->
  fun
    (Xs) ->
      last(Xs)
  end.

last(Xs) ->
  index(Xs, (array:size(Xs)) - 1).

unsnoc() ->
  fun
    (Xs) ->
      unsnoc(Xs)
  end.

unsnoc(Xs) ->
  begin
    V = init(Xs),
    case V of
      {just, _} ->
        begin
          V@1 = index(Xs, (array:size(Xs)) - 1),
          case V@1 of
            {just, V@2} ->
              begin
                {just, V@3} = V,
                {just, #{ init => V@3, last => V@2 }}
              end;
            _ ->
              {nothing}
          end
        end;
      _ ->
        {nothing}
    end
  end.

modifyAt() ->
  fun
    (I) ->
      fun
        (F) ->
          fun
            (Xs) ->
              modifyAt(I, F, Xs)
          end
      end
  end.

modifyAt(I, F, Xs) ->
  begin
    V = index(Xs, I),
    case V of
      {nothing} ->
        {nothing};
      {just, V@1} ->
        updateAt(I, F(V@1), Xs);
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

modifyAtIndices() ->
  fun
    (DictFoldable) ->
      fun
        (Is) ->
          fun
            (F) ->
              fun
                (Xs) ->
                  modifyAtIndices(DictFoldable, Is, F, Xs)
              end
          end
      end
  end.

modifyAtIndices(#{ foldl := DictFoldable }, Is, F, Xs) ->
  ((DictFoldable(fun
      (Xs_) ->
        fun
          (I) ->
            begin
              V = modifyAt(I, F, Xs_),
              case V of
                {nothing} ->
                  Xs_;
                {just, V@1} ->
                  V@1;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
            end
        end
    end))
   (Xs))
  (Is).

span() ->
  fun
    (P) ->
      fun
        (Arr) ->
          span(P, Arr)
      end
  end.

span(P, Arr) ->
  begin
    Go =
      fun
        Go (I) ->
          begin
            V = index(Arr, I),
            case V of
              {just, V@1} ->
                case P(V@1) of
                  true ->
                    Go(I + 1);
                  _ ->
                    {just, I}
                end;
              {nothing} ->
                {nothing};
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
          end
      end,
    BreakIndex = Go(0),
    case BreakIndex of
      {just, BreakIndex@1} ->
        if
          BreakIndex@1 =:= 0 ->
            #{ init => array:from_list([]), rest => Arr };
          true ->
            #{ init => data_array@foreign:slice(0, BreakIndex@1, Arr)
             , rest =>
               data_array@foreign:slice(BreakIndex@1, array:size(Arr), Arr)
             }
        end;
      {nothing} ->
        #{ init => Arr, rest => array:from_list([]) };
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

takeWhile() ->
  fun
    (P) ->
      fun
        (Xs) ->
          takeWhile(P, Xs)
      end
  end.

takeWhile(P, Xs) ->
  erlang:map_get(init, span(P, Xs)).

head() ->
  fun
    (Xs) ->
      head(Xs)
  end.

head(Xs) ->
  index(Xs, 0).

fromFoldable() ->
  fun
    (DictFoldable) ->
      fromFoldable(DictFoldable)
  end.

fromFoldable(#{ foldr := DictFoldable }) ->
  (fromFoldableImpl())(DictFoldable).

foldr() ->
  data_foldable@ps:foldrArray().

foldl() ->
  data_foldable@ps:foldlArray().

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
          (B) ->
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
                (#{ a => B, b => 0 })
            end
        end
    end
  end.

foldMap() ->
  fun
    (DictMonoid) ->
      foldMap(DictMonoid)
  end.

foldMap(DictMonoid) ->
  (erlang:map_get(foldMap, data_foldable@ps:foldableArray()))(DictMonoid).

foldM() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (B) ->
              foldM(DictMonad, F, B)
          end
      end
  end.

foldM( DictMonad = #{ 'Applicative0' := DictMonad@1, 'Bind1' := DictMonad@2 }
     , F
     , B
     ) ->
  ((unconsImpl())
   (fun
     (_) ->
       (erlang:map_get(pure, DictMonad@1(undefined)))(B)
   end))
  (fun
    (A) ->
      fun
        (As) ->
          ((erlang:map_get(bind, DictMonad@2(undefined)))((F(B))(A)))
          (fun
            (B_) ->
              (foldM(DictMonad, F, B_))(As)
          end)
      end
  end).

fold() ->
  fun
    (DictMonoid) ->
      fold(DictMonoid)
  end.

fold(DictMonoid) ->
  ((erlang:map_get(foldMap, data_foldable@ps:foldableArray()))(DictMonoid))
  (data_foldable@ps:identity()).

findMap() ->
  ((findMapImpl())({nothing}))(data_maybe@ps:isJust()).

findLastIndex() ->
  ((findLastIndexImpl())(data_maybe@ps:'Just'()))({nothing}).

insertBy() ->
  fun
    (Cmp) ->
      fun
        (X) ->
          fun
            (Ys) ->
              insertBy(Cmp, X, Ys)
          end
      end
  end.

insertBy(Cmp, X, Ys) ->
  begin
    V@2 = {just, V@3} =
      insertAt(
        begin
          V =
            findLastIndex(
              fun
                (Y) ->
                  begin
                    V = (Cmp(X))(Y),
                    ?IS_KNOWN_TAG(gT, 0, V)
                  end
              end,
              Ys
            ),
          case V of
            {nothing} ->
              0;
            {just, V@1} ->
              V@1 + 1;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
        end,
        X,
        Ys
      ),
    case V@2 of
      {just, _} ->
        V@3;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

insert() ->
  fun
    (DictOrd) ->
      insert(DictOrd)
  end.

insert(#{ compare := DictOrd }) ->
  (insertBy())(DictOrd).

findIndex() ->
  ((findIndexImpl())(data_maybe@ps:'Just'()))({nothing}).

intersectBy() ->
  fun
    (Eq2) ->
      fun
        (Xs) ->
          fun
            (Ys) ->
              intersectBy(Eq2, Xs, Ys)
          end
      end
  end.

intersectBy(Eq2, Xs, Ys) ->
  data_array@foreign:filter(
    fun
      (X) ->
        begin
          V = findIndex(Eq2(X), Ys),
          case V of
            {nothing} ->
              false;
            {just, _} ->
              true;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
        end
    end,
    Xs
  ).

intersect() ->
  fun
    (DictEq) ->
      intersect(DictEq)
  end.

intersect(#{ eq := DictEq }) ->
  (intersectBy())(DictEq).

find() ->
  fun
    (F) ->
      fun
        (Xs) ->
          find(F, Xs)
      end
  end.

find(F, Xs) ->
  begin
    V = findIndex(F, Xs),
    case V of
      {just, V@1} ->
        {just, array:get(V@1, Xs)};
      _ ->
        {nothing}
    end
  end.

elemLastIndex() ->
  fun
    (DictEq) ->
      fun
        (X) ->
          elemLastIndex(DictEq, X)
      end
  end.

elemLastIndex(#{ eq := DictEq }, X) ->
  (findLastIndex())
  (fun
    (V) ->
      (DictEq(V))(X)
  end).

elemIndex() ->
  fun
    (DictEq) ->
      fun
        (X) ->
          elemIndex(DictEq, X)
      end
  end.

elemIndex(#{ eq := DictEq }, X) ->
  (findIndex())
  (fun
    (V) ->
      (DictEq(V))(X)
  end).

notElem() ->
  fun
    (DictEq) ->
      fun
        (A) ->
          fun
            (Arr) ->
              notElem(DictEq, A, Arr)
          end
      end
  end.

notElem(#{ eq := DictEq }, A, Arr) ->
  begin
    V =
      findIndex(
        fun
          (V) ->
            (DictEq(V))(A)
        end,
        Arr
      ),
    case V of
      {nothing} ->
        true;
      {just, _} ->
        false;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

elem() ->
  fun
    (DictEq) ->
      fun
        (A) ->
          fun
            (Arr) ->
              elem(DictEq, A, Arr)
          end
      end
  end.

elem(#{ eq := DictEq }, A, Arr) ->
  begin
    V =
      findIndex(
        fun
          (V) ->
            (DictEq(V))(A)
        end,
        Arr
      ),
    case V of
      {nothing} ->
        false;
      {just, _} ->
        true;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

dropWhile() ->
  fun
    (P) ->
      fun
        (Xs) ->
          dropWhile(P, Xs)
      end
  end.

dropWhile(P, Xs) ->
  erlang:map_get(rest, span(P, Xs)).

dropEnd() ->
  fun
    (N) ->
      fun
        (Xs) ->
          dropEnd(N, Xs)
      end
  end.

dropEnd(N, Xs) ->
  begin
    V = (array:size(Xs)) - N,
    if
      V < 1 ->
        array:from_list([]);
      true ->
        data_array@foreign:slice(0, V, Xs)
    end
  end.

drop() ->
  fun
    (N) ->
      fun
        (Xs) ->
          drop(N, Xs)
      end
  end.

drop(N, Xs) ->
  if
    N < 1 ->
      Xs;
    true ->
      data_array@foreign:slice(N, array:size(Xs), Xs)
  end.

takeEnd() ->
  fun
    (N) ->
      fun
        (Xs) ->
          takeEnd(N, Xs)
      end
  end.

takeEnd(N, Xs) ->
  begin
    V = (array:size(Xs)) - N,
    if
      V < 1 ->
        Xs;
      true ->
        data_array@foreign:slice(V, array:size(Xs), Xs)
    end
  end.

deleteAt() ->
  (('_deleteAt'())(data_maybe@ps:'Just'()))({nothing}).

deleteBy() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              deleteBy(V, V1, V2)
          end
      end
  end.

deleteBy(V, V1, V2) ->
  case (array:size(V2)) =:= 0 of
    true ->
      array:from_list([]);
    _ ->
      begin
        V@1 = findIndex(V(V1), V2),
        case V@1 of
          {nothing} ->
            V2;
          {just, V@2} ->
            begin
              V@3 = {just, V@4} = deleteAt(V@2, V2),
              case V@3 of
                {just, _} ->
                  V@4;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
            end;
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end.

delete() ->
  fun
    (DictEq) ->
      delete(DictEq)
  end.

delete(#{ eq := DictEq }) ->
  (deleteBy())(DictEq).

difference() ->
  fun
    (DictEq) ->
      difference(DictEq)
  end.

difference(DictEq) ->
  (data_foldable@ps:foldrArray())(delete(DictEq)).

cons() ->
  fun
    (X) ->
      fun
        (Xs) ->
          cons(X, Xs)
      end
  end.

cons(X, Xs) ->
  data_semigroup@foreign:concatArray(array:from_list([X]), Xs).

groupBy() ->
  fun
    (Op) ->
      groupBy(Op)
  end.

groupBy(Op) ->
  begin
    Go =
      fun
        Go (Acc, Xs) ->
          begin
            V = uncons(Xs),
            case V of
              {just, #{ head := V@1, tail := V@2 }} ->
                begin
                  #{ init := Sp, rest := Sp@1 } = span(Op(V@1), V@2),
                  Acc@1 =
                    data_semigroup@foreign:concatArray(
                      array:from_list([data_semigroup@foreign:concatArray(
                                         array:from_list([V@1]),
                                         Sp
                                       )]),
                      Acc
                    ),
                  Go(Acc@1, Sp@1)
                end;
              {nothing} ->
                data_array@foreign:reverse(Acc);
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
          end
      end,
    Acc = array:from_list([]),
    fun
      (Xs) ->
        Go(Acc, Xs)
    end
  end.

group() ->
  fun
    (DictEq) ->
      group(DictEq)
  end.

group(#{ eq := DictEq }) ->
  fun
    (Xs) ->
      (groupBy(DictEq))(Xs)
  end.

groupAllBy() ->
  fun
    (Cmp) ->
      groupAllBy(Cmp)
  end.

groupAllBy(Cmp) ->
  begin
    V =
      groupBy(fun
        (X) ->
          fun
            (Y) ->
              begin
                V = (Cmp(X))(Y),
                ?IS_KNOWN_TAG(eQ, 0, V)
              end
          end
      end),
    V@1 = sortBy(Cmp),
    fun
      (X) ->
        V(V@1(X))
    end
  end.

groupAll() ->
  fun
    (DictOrd) ->
      groupAll(DictOrd)
  end.

groupAll(#{ compare := DictOrd }) ->
  groupAllBy(DictOrd).

'group\''() ->
  fun
    (V) ->
      fun
        (DictOrd) ->
          'group\''(V, DictOrd)
      end
  end.

'group\''(_, #{ compare := DictOrd }) ->
  groupAllBy(DictOrd).

nubBy() ->
  fun
    (Comp) ->
      fun
        (Xs) ->
          nubBy(Comp, Xs)
      end
  end.

nubBy(Comp, Xs) ->
  begin
    IndexedAndSorted =
      (sortBy(fun
         (X) ->
           fun
             (Y) ->
               (Comp(erlang:element(3, X)))(erlang:element(3, Y))
           end
       end))
      (mapWithIndex(data_tuple@ps:'Tuple'(), Xs)),
    V = index(IndexedAndSorted, 0),
    case V of
      {nothing} ->
        array:from_list([]);
      {just, V@1} ->
        data_functor@foreign:arrayMap(
          data_tuple@ps:snd(),
          (sortWith(data_ord@ps:ordInt(), data_tuple@ps:fst()))
          (data_foldable@foreign:foldlArray(
             fun
               (Result) ->
                 fun
                   (V@2) ->
                     begin
                       V@5 =
                         (Comp(begin
                            V@3 = {just, V@4} = index(Result, 0),
                            case V@3 of
                              {just, _} ->
                                erlang:element(3, V@4);
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end
                          end))
                         (erlang:element(3, V@2)),
                       case ?IS_KNOWN_TAG(lT, 0, V@5)
                           orelse (?IS_KNOWN_TAG(gT, 0, V@5)
                             orelse (not ?IS_KNOWN_TAG(eQ, 0, V@5))) of
                         true ->
                           data_semigroup@foreign:concatArray(
                             array:from_list([V@2]),
                             Result
                           );
                         _ ->
                           Result
                       end
                     end
                 end
             end,
             array:from_list([V@1]),
             IndexedAndSorted
           ))
        );
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

nub() ->
  fun
    (DictOrd) ->
      nub(DictOrd)
  end.

nub(#{ compare := DictOrd }) ->
  (nubBy())(DictOrd).

nubByEq() ->
  fun
    (Eq2) ->
      fun
        (Xs) ->
          nubByEq(Eq2, Xs)
      end
  end.

nubByEq(Eq2, Xs) ->
  begin
    V = uncons(Xs),
    case V of
      {just, V@1} ->
        begin
          #{ head := _, tail := _ } = V@1,
          data_semigroup@foreign:concatArray(
            array:from_list([erlang:map_get(head, V@1)]),
            nubByEq(
              Eq2,
              data_array@foreign:filter(
                fun
                  (Y) ->
                    not ((Eq2(erlang:map_get(head, V@1)))(Y))
                end,
                erlang:map_get(tail, V@1)
              )
            )
          )
        end;
      {nothing} ->
        array:from_list([]);
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

nubEq() ->
  fun
    (DictEq) ->
      nubEq(DictEq)
  end.

nubEq(#{ eq := DictEq }) ->
  (nubByEq())(DictEq).

unionBy() ->
  fun
    (Eq2) ->
      fun
        (Xs) ->
          fun
            (Ys) ->
              unionBy(Eq2, Xs, Ys)
          end
      end
  end.

unionBy(Eq2, Xs, Ys) ->
  data_semigroup@foreign:concatArray(
    Xs,
    data_foldable@foreign:foldlArray(
      fun
        (B) ->
          fun
            (A) ->
              deleteBy(Eq2, A, B)
          end
      end,
      nubByEq(Eq2, Ys),
      Xs
    )
  ).

union() ->
  fun
    (DictEq) ->
      union(DictEq)
  end.

union(#{ eq := DictEq }) ->
  (unionBy())(DictEq).

some() ->
  fun
    (DictAlternative) ->
      fun
        (DictLazy) ->
          fun
            (V) ->
              some(DictAlternative, DictLazy, V)
          end
      end
  end.

some( DictAlternative = #{ 'Applicative0' := DictAlternative@1
                         , 'Plus1' := DictAlternative@2
                         }
    , DictLazy = #{ defer := DictLazy@1 }
    , V
    ) ->
  ((erlang:map_get(
      apply,
      (erlang:map_get('Apply0', DictAlternative@1(undefined)))(undefined)
    ))
   (((erlang:map_get(
        map,
        (erlang:map_get(
           'Functor0',
           (erlang:map_get('Alt0', DictAlternative@2(undefined)))(undefined)
         ))
        (undefined)
      ))
     (cons()))
    (V)))
  (DictLazy@1(fun
     (_) ->
       many(DictAlternative, DictLazy, V)
   end)).

many() ->
  fun
    (DictAlternative) ->
      fun
        (DictLazy) ->
          fun
            (V) ->
              many(DictAlternative, DictLazy, V)
          end
      end
  end.

many( DictAlternative = #{ 'Applicative0' := DictAlternative@1
                         , 'Plus1' := DictAlternative@2
                         }
    , DictLazy
    , V
    ) ->
  ((erlang:map_get(
      alt,
      (erlang:map_get('Alt0', DictAlternative@2(undefined)))(undefined)
    ))
   (some(DictAlternative, DictLazy, V)))
  ((erlang:map_get(pure, DictAlternative@1(undefined)))(array:from_list([]))).

unzip() ->
  ((unconsImpl())
   (fun
     (_) ->
       {tuple, array:from_list([]), array:from_list([])}
   end))
  (fun
    (V) ->
      begin
        V@1 = erlang:element(2, V),
        V@2 = erlang:element(3, V),
        fun
          (Ts) ->
            begin
              V1 = unzip(Ts),
              { tuple
              , data_semigroup@foreign:concatArray(
                  array:from_list([V@1]),
                  erlang:element(2, V1)
                )
              , data_semigroup@foreign:concatArray(
                  array:from_list([V@2]),
                  erlang:element(3, V1)
                )
              }
            end
        end
      end
  end).

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

mapMaybe() ->
  fun
    (F) ->
      mapMaybe(F)
  end.

mapMaybe(F) ->
  (concatMap())
  (fun
    (X) ->
      begin
        V = F(X),
        case V of
          {nothing} ->
            array:from_list([]);
          {just, V@1} ->
            array:from_list([V@1]);
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end).

filterA() ->
  fun
    (DictApplicative) ->
      filterA(DictApplicative)
  end.

filterA(DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
  begin
    Traverse1 =
      (erlang:map_get(traverse, data_traversable@ps:traversableArray()))
      (DictApplicative),
    #{ map := V } =
      (erlang:map_get('Functor0', DictApplicative@1(undefined)))(undefined),
    fun
      (P) ->
        begin
          V@1 =
            Traverse1(fun
              (X) ->
                (V((data_tuple@ps:'Tuple'())(X)))(P(X))
            end),
          V@2 =
            V(mapMaybe(fun
                (V@2) ->
                  if
                    erlang:element(3, V@2) ->
                      {just, erlang:element(2, V@2)};
                    true ->
                      {nothing}
                  end
              end)),
          fun
            (X) ->
              V@2(V@1(X))
          end
        end
    end
  end.

catMaybes() ->
  mapMaybe(fun
    (X) ->
      X
  end).

alterAt() ->
  fun
    (I) ->
      fun
        (F) ->
          fun
            (Xs) ->
              alterAt(I, F, Xs)
          end
      end
  end.

alterAt(I, F, Xs) ->
  begin
    V = index(Xs, I),
    case V of
      {nothing} ->
        {nothing};
      {just, V@1} ->
        begin
          V@2 = F(V@1),
          case V@2 of
            {nothing} ->
              deleteAt(I, Xs);
            {just, V@3} ->
              updateAt(I, V@3, Xs);
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
        end;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

range() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:range(V, V@1)
      end
  end.

replicate() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:replicate(V, V@1)
      end
  end.

fromFoldableImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:fromFoldableImpl(V, V@1)
      end
  end.

length() ->
  fun
    (V) ->
      data_array@foreign:length(V)
  end.

snoc() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:snoc(V, V@1)
      end
  end.

unconsImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_array@foreign:unconsImpl(V, V@1, V@2)
          end
      end
  end.

indexImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_array@foreign:indexImpl(V, V@1, V@2, V@3)
              end
          end
      end
  end.

findMapImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_array@foreign:findMapImpl(V, V@1, V@2, V@3)
              end
          end
      end
  end.

findIndexImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_array@foreign:findIndexImpl(V, V@1, V@2, V@3)
              end
          end
      end
  end.

findLastIndexImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_array@foreign:findLastIndexImpl(V, V@1, V@2, V@3)
              end
          end
      end
  end.

'_insertAt'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      data_array@foreign:'_insertAt'(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

'_deleteAt'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_array@foreign:'_deleteAt'(V, V@1, V@2, V@3)
              end
          end
      end
  end.

'_updateAt'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      data_array@foreign:'_updateAt'(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

reverse() ->
  fun
    (V) ->
      data_array@foreign:reverse(V)
  end.

concat() ->
  fun
    (V) ->
      data_array@foreign:concat(V)
  end.

filter() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:filter(V, V@1)
      end
  end.

partition() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:partition(V, V@1)
      end
  end.

scanl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_array@foreign:scanl(V, V@1, V@2)
          end
      end
  end.

scanr() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_array@foreign:scanr(V, V@1, V@2)
          end
      end
  end.

intersperse() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:intersperse(V, V@1)
      end
  end.

sortByImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_array@foreign:sortByImpl(V, V@1, V@2)
          end
      end
  end.

slice() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_array@foreign:slice(V, V@1, V@2)
          end
      end
  end.

zipWith() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_array@foreign:zipWith(V, V@1, V@2)
          end
      end
  end.

unsafeIndexImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:unsafeIndexImpl(V, V@1)
      end
  end.

any() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:any(V, V@1)
      end
  end.

all() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_array@foreign:all(V, V@1)
      end
  end.

zip(V, V@1) ->
  data_array@foreign:zipWith(data_tuple@ps:'Tuple'(), V, V@1).

updateAt(V, V@1, V@2) ->
  data_array@foreign:'_updateAt'(data_maybe@ps:'Just'(), {nothing}, V, V@1, V@2).

uncons(V) ->
  data_array@foreign:unconsImpl(
    fun
      (_) ->
        {nothing}
    end,
    fun
      (X) ->
        fun
          (Xs) ->
            {just, #{ head => X, tail => Xs }}
        end
    end,
    V
  ).

tail(V) ->
  data_array@foreign:unconsImpl(
    fun
      (_) ->
        {nothing}
    end,
    fun
      (_) ->
        fun
          (Xs) ->
            {just, Xs}
        end
    end,
    V
  ).

insertAt(V, V@1, V@2) ->
  data_array@foreign:'_insertAt'(data_maybe@ps:'Just'(), {nothing}, V, V@1, V@2).

index(V, V@1) ->
  data_array@foreign:indexImpl(data_maybe@ps:'Just'(), {nothing}, V, V@1).

foldr(V, V@1, V@2) ->
  data_foldable@foreign:foldrArray(V, V@1, V@2).

foldl(V, V@1, V@2) ->
  data_foldable@foreign:foldlArray(V, V@1, V@2).

findMap(V, V@1) ->
  data_array@foreign:findMapImpl({nothing}, data_maybe@ps:isJust(), V, V@1).

findLastIndex(V, V@1) ->
  data_array@foreign:findLastIndexImpl(
    data_maybe@ps:'Just'(),
    {nothing},
    V,
    V@1
  ).

findIndex(V, V@1) ->
  data_array@foreign:findIndexImpl(data_maybe@ps:'Just'(), {nothing}, V, V@1).

deleteAt(V, V@1) ->
  data_array@foreign:'_deleteAt'(data_maybe@ps:'Just'(), {nothing}, V, V@1).

unzip(V) ->
  data_array@foreign:unconsImpl(
    fun
      (_) ->
        {tuple, array:from_list([]), array:from_list([])}
    end,
    fun
      (V@1) ->
        begin
          V@2 = erlang:element(2, V@1),
          V@3 = erlang:element(3, V@1),
          fun
            (Ts) ->
              begin
                V1 = unzip(Ts),
                { tuple
                , data_semigroup@foreign:concatArray(
                    array:from_list([V@2]),
                    erlang:element(2, V1)
                  )
                , data_semigroup@foreign:concatArray(
                    array:from_list([V@3]),
                    erlang:element(3, V1)
                  )
                }
              end
          end
        end
    end,
    V
  ).

