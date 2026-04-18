-module(data_list_nonEmpty@ps).
-export([ identity/0
        , identity/1
        , zipWith/0
        , zipWith/3
        , zipWithA/0
        , zipWithA/1
        , zip/0
        , wrappedOperation2/0
        , wrappedOperation2/4
        , wrappedOperation/0
        , wrappedOperation/3
        , updateAt/0
        , updateAt/3
        , unzip/0
        , unzip/1
        , unsnoc/0
        , unsnoc/1
        , unionBy/0
        , unionBy/1
        , union/0
        , union/1
        , uncons/0
        , uncons/1
        , toList/0
        , toList/1
        , toUnfoldable/0
        , toUnfoldable/1
        , tail/0
        , tail/1
        , sortBy/0
        , sortBy/1
        , sort/0
        , sort/1
        , snoc/0
        , snoc/2
        , singleton/0
        , singleton/1
        , 'snoc\''/0
        , 'snoc\''/2
        , reverse/0
        , nubEq/0
        , nubEq/1
        , nubByEq/0
        , nubByEq/1
        , nubBy/0
        , nubBy/1
        , nub/0
        , nub/1
        , modifyAt/0
        , modifyAt/3
        , mapWithIndex/0
        , mapMaybe/0
        , mapMaybe/1
        , partition/0
        , partition/2
        , span/0
        , span/2
        , take/0
        , take/1
        , takeWhile/0
        , takeWhile/1
        , length/0
        , length/1
        , last/0
        , last/1
        , intersectBy/0
        , intersectBy/1
        , intersect/0
        , intersect/1
        , insertAt/0
        , insertAt/3
        , init/0
        , init/1
        , index/0
        , index/2
        , head/0
        , head/1
        , groupBy/0
        , groupBy/1
        , groupAllBy/0
        , groupAllBy/1
        , groupAll/0
        , groupAll/1
        , 'group\''/0
        , 'group\''/2
        , group/0
        , group/1
        , fromList/0
        , fromList/1
        , fromFoldable/0
        , fromFoldable/1
        , foldM/0
        , foldM/4
        , findLastIndex/0
        , findLastIndex/2
        , findIndex/0
        , findIndex/2
        , filterM/0
        , filterM/1
        , filter/0
        , filter/1
        , elemLastIndex/0
        , elemLastIndex/2
        , elemIndex/0
        , elemIndex/3
        , dropWhile/0
        , dropWhile/1
        , drop/0
        , drop/2
        , 'cons\''/0
        , 'cons\''/2
        , cons/0
        , cons/2
        , concatMap/0
        , concatMap/2
        , concat/0
        , concat/1
        , catMaybes/0
        , catMaybes/1
        , appendFoldable/0
        , appendFoldable/1
        , zip/2
        , reverse/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

zipWith() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (V1) ->
              zipWith(F, V, V1)
          end
      end
  end.

zipWith(F, V, V1) ->
  { nonEmpty
  , (F(erlang:element(2, V)))(erlang:element(2, V1))
  , data_list@ps:zipWith(F, erlang:element(3, V), erlang:element(3, V1))
  }.

zipWithA() ->
  fun
    (DictApplicative) ->
      zipWithA(DictApplicative)
  end.

zipWithA(#{ 'Apply0' := DictApplicative }) ->
  begin
    Sequence11 =
      ((erlang:map_get(
          traverse1,
          data_list_types@ps:traversable1NonEmptyList()
        ))
       (DictApplicative(undefined)))
      (data_list_types@ps:identity()),
    fun
      (F) ->
        fun
          (Xs) ->
            fun
              (Ys) ->
                Sequence11(zipWith(F, Xs, Ys))
            end
        end
    end
  end.

zip() ->
  (zipWith())(data_tuple@ps:'Tuple'()).

wrappedOperation2() ->
  fun
    (Name) ->
      fun
        (F) ->
          fun
            (V) ->
              fun
                (V1) ->
                  wrappedOperation2(Name, F, V, V1)
              end
          end
      end
  end.

wrappedOperation2(Name, F, V, V1) ->
  begin
    V2 =
      (F({cons, erlang:element(2, V), erlang:element(3, V)}))
      ({cons, erlang:element(2, V1), erlang:element(3, V1)}),
    case V2 of
      {cons, V2@1, V2@2} ->
        {nonEmpty, V2@1, V2@2};
      {nil} ->
        erlang:error(<<"Impossible: empty list in NonEmptyList ", Name/binary>>);
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

wrappedOperation() ->
  fun
    (Name) ->
      fun
        (F) ->
          fun
            (V) ->
              wrappedOperation(Name, F, V)
          end
      end
  end.

wrappedOperation(Name, F, V) ->
  begin
    V1 = F({cons, erlang:element(2, V), erlang:element(3, V)}),
    case V1 of
      {cons, V1@1, V1@2} ->
        {nonEmpty, V1@1, V1@2};
      {nil} ->
        erlang:error(<<"Impossible: empty list in NonEmptyList ", Name/binary>>);
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

updateAt() ->
  fun
    (I) ->
      fun
        (A) ->
          fun
            (V) ->
              updateAt(I, A, V)
          end
      end
  end.

updateAt(I, A, V) ->
  if
    I =:= 0 ->
      {just, {nonEmpty, A, erlang:element(3, V)}};
    true ->
      begin
        V@1 = data_list@ps:updateAt(I - 1, A, erlang:element(3, V)),
        case V@1 of
          {just, V@2} ->
            {just, {nonEmpty, erlang:element(2, V), V@2}};
          _ ->
            {nothing}
        end
      end
  end.

unzip() ->
  fun
    (Ts) ->
      unzip(Ts)
  end.

unzip(Ts) ->
  { tuple
  , { nonEmpty
    , erlang:element(2, erlang:element(2, Ts))
    , (data_list_types@ps:listMap(data_tuple@ps:fst()))(erlang:element(3, Ts))
    }
  , { nonEmpty
    , erlang:element(3, erlang:element(2, Ts))
    , (data_list_types@ps:listMap(data_tuple@ps:snd()))(erlang:element(3, Ts))
    }
  }.

unsnoc() ->
  fun
    (V) ->
      unsnoc(V)
  end.

unsnoc(V) ->
  begin
    V1 = data_list@ps:unsnoc(erlang:element(3, V)),
    case V1 of
      {nothing} ->
        #{ init => {nil}, last => erlang:element(2, V) };
      {just, #{ init := V1@1, last := V1@2 }} ->
        #{ init => {cons, erlang:element(2, V), V1@1}, last => V1@2 };
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

unionBy() ->
  fun
    (X) ->
      unionBy(X)
  end.

unionBy(X) ->
  ((wrappedOperation2())(<<"unionBy">>))((data_list@ps:unionBy())(X)).

union() ->
  fun
    (DictEq) ->
      union(DictEq)
  end.

union(DictEq) ->
  ((wrappedOperation2())(<<"union">>))(data_list@ps:union(DictEq)).

uncons() ->
  fun
    (V) ->
      uncons(V)
  end.

uncons(V) ->
  #{ head => erlang:element(2, V), tail => erlang:element(3, V) }.

toList() ->
  fun
    (V) ->
      toList(V)
  end.

toList(V) ->
  {cons, erlang:element(2, V), erlang:element(3, V)}.

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
        V({cons, erlang:element(2, X), erlang:element(3, X)})
    end
  end.

tail() ->
  fun
    (V) ->
      tail(V)
  end.

tail(V) ->
  erlang:element(3, V).

sortBy() ->
  fun
    (X) ->
      sortBy(X)
  end.

sortBy(X) ->
  ((wrappedOperation())(<<"sortBy">>))(data_list@ps:sortBy(X)).

sort() ->
  fun
    (DictOrd) ->
      sort(DictOrd)
  end.

sort(#{ compare := DictOrd }) ->
  fun
    (Xs) ->
      wrappedOperation(<<"sortBy">>, data_list@ps:sortBy(DictOrd), Xs)
  end.

snoc() ->
  fun
    (V) ->
      fun
        (Y) ->
          snoc(V, Y)
      end
  end.

snoc(V, Y) ->
  { nonEmpty
  , erlang:element(2, V)
  , (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
      (data_list_types@ps:'Cons'()))
     ({cons, Y, {nil}}))
    (erlang:element(3, V))
  }.

singleton() ->
  fun
    (X) ->
      singleton(X)
  end.

singleton(X) ->
  {nonEmpty, X, {nil}}.

'snoc\''() ->
  fun
    (V) ->
      fun
        (V1) ->
          'snoc\''(V, V1)
      end
  end.

'snoc\''(V, V1) ->
  case V of
    {cons, V@1, V@2} ->
      { nonEmpty
      , V@1
      , (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
          (data_list_types@ps:'Cons'()))
         ({cons, V1, {nil}}))
        (V@2)
      };
    {nil} ->
      {nonEmpty, V1, {nil}};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

reverse() ->
  ((wrappedOperation())(<<"reverse">>))(data_list@ps:reverse()).

nubEq() ->
  fun
    (DictEq) ->
      nubEq(DictEq)
  end.

nubEq(DictEq) ->
  ((wrappedOperation())(<<"nubEq">>))(data_list@ps:nubEq(DictEq)).

nubByEq() ->
  fun
    (X) ->
      nubByEq(X)
  end.

nubByEq(X) ->
  ((wrappedOperation())(<<"nubByEq">>))((data_list@ps:nubByEq())(X)).

nubBy() ->
  fun
    (X) ->
      nubBy(X)
  end.

nubBy(X) ->
  ((wrappedOperation())(<<"nubBy">>))(data_list@ps:nubBy(X)).

nub() ->
  fun
    (DictOrd) ->
      nub(DictOrd)
  end.

nub(#{ compare := DictOrd }) ->
  ((wrappedOperation())(<<"nub">>))(data_list@ps:nubBy(DictOrd)).

modifyAt() ->
  fun
    (I) ->
      fun
        (F) ->
          fun
            (V) ->
              modifyAt(I, F, V)
          end
      end
  end.

modifyAt(I, F, V) ->
  if
    I =:= 0 ->
      {just, {nonEmpty, F(erlang:element(2, V)), erlang:element(3, V)}};
    true ->
      begin
        V@1 =
          data_list@ps:alterAt(
            I - 1,
            fun
              (X) ->
                {just, F(X)}
            end,
            erlang:element(3, V)
          ),
        case V@1 of
          {just, V@2} ->
            {just, {nonEmpty, erlang:element(2, V), V@2}};
          _ ->
            {nothing}
        end
      end
  end.

mapWithIndex() ->
  erlang:map_get(
    mapWithIndex,
    data_list_types@ps:functorWithIndexNonEmptyList()
  ).

mapMaybe() ->
  fun
    (X) ->
      mapMaybe(X)
  end.

mapMaybe(X) ->
  begin
    V = data_list@ps:mapMaybe(X),
    fun
      (V@1) ->
        V({cons, erlang:element(2, V@1), erlang:element(3, V@1)})
    end
  end.

partition() ->
  fun
    (X) ->
      fun
        (V) ->
          partition(X, V)
      end
  end.

partition(X, V) ->
  data_list@ps:partition(X, {cons, erlang:element(2, V), erlang:element(3, V)}).

span() ->
  fun
    (X) ->
      fun
        (V) ->
          span(X, V)
      end
  end.

span(X, V) ->
  data_list@ps:span(X, {cons, erlang:element(2, V), erlang:element(3, V)}).

take() ->
  fun
    (X) ->
      take(X)
  end.

take(X) ->
  begin
    V = (data_list@ps:take())(X),
    fun
      (V@1) ->
        V({cons, erlang:element(2, V@1), erlang:element(3, V@1)})
    end
  end.

takeWhile() ->
  fun
    (X) ->
      takeWhile(X)
  end.

takeWhile(X) ->
  begin
    V = data_list@ps:takeWhile(X),
    fun
      (V@1) ->
        V({cons, erlang:element(2, V@1), erlang:element(3, V@1)})
    end
  end.

length() ->
  fun
    (V) ->
      length(V)
  end.

length(V) ->
  1 + (data_list@ps:length(erlang:element(3, V))).

last() ->
  fun
    (V) ->
      last(V)
  end.

last(V) ->
  case erlang:element(3, V) of
    {cons, _, _} ->
      case erlang:element(3, erlang:element(3, V)) of
        {nil} ->
          erlang:element(2, erlang:element(3, V));
        _ ->
          begin
            V@1 = data_list@ps:last(erlang:element(3, erlang:element(3, V))),
            case ?IS_KNOWN_TAG(nothing, 0, V@1) of
              true ->
                erlang:element(2, V);
              _ ->
                begin
                  V@2 =
                    data_list@ps:last(erlang:element(3, erlang:element(3, V))),
                  case ?IS_KNOWN_TAG(just, 1, V@2) of
                    true ->
                      erlang:element(
                        2,
                        data_list@ps:last(erlang:element(
                                            3,
                                            erlang:element(3, V)
                                          ))
                      );
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
                end
            end
          end
      end;
    _ ->
      erlang:element(2, V)
  end.

intersectBy() ->
  fun
    (X) ->
      intersectBy(X)
  end.

intersectBy(X) ->
  ((wrappedOperation2())(<<"intersectBy">>))((data_list@ps:intersectBy())(X)).

intersect() ->
  fun
    (DictEq) ->
      intersect(DictEq)
  end.

intersect(DictEq) ->
  ((wrappedOperation2())(<<"intersect">>))(data_list@ps:intersect(DictEq)).

insertAt() ->
  fun
    (I) ->
      fun
        (A) ->
          fun
            (V) ->
              insertAt(I, A, V)
          end
      end
  end.

insertAt(I, A, V) ->
  if
    I =:= 0 ->
      {just, {nonEmpty, A, {cons, erlang:element(2, V), erlang:element(3, V)}}};
    true ->
      begin
        V@1 = data_list@ps:insertAt(I - 1, A, erlang:element(3, V)),
        case V@1 of
          {just, V@2} ->
            {just, {nonEmpty, erlang:element(2, V), V@2}};
          _ ->
            {nothing}
        end
      end
  end.

init() ->
  fun
    (V) ->
      init(V)
  end.

init(V) ->
  begin
    V@1 = data_list@ps:unsnoc(erlang:element(3, V)),
    case V@1 of
      {just, #{ init := V@2 }} ->
        {cons, erlang:element(2, V), V@2};
      _ ->
        {nil}
    end
  end.

index() ->
  fun
    (V) ->
      fun
        (I) ->
          index(V, I)
      end
  end.

index(V, I) ->
  if
    I =:= 0 ->
      {just, erlang:element(2, V)};
    true ->
      data_list@ps:index(erlang:element(3, V), I - 1)
  end.

head() ->
  fun
    (V) ->
      head(V)
  end.

head(V) ->
  erlang:element(2, V).

groupBy() ->
  fun
    (X) ->
      groupBy(X)
  end.

groupBy(X) ->
  ((wrappedOperation())(<<"groupBy">>))((data_list@ps:groupBy())(X)).

groupAllBy() ->
  fun
    (DictOrd) ->
      groupAllBy(DictOrd)
  end.

groupAllBy(#{ compare := DictOrd }) ->
  fun
    (X) ->
      ((wrappedOperation())(<<"groupAllBy">>))
      (fun
        (X@1) ->
          data_list@ps:groupBy(X, (data_list@ps:sortBy(DictOrd))(X@1))
      end)
  end.

groupAll() ->
  fun
    (DictOrd) ->
      groupAll(DictOrd)
  end.

groupAll(DictOrd) ->
  ((wrappedOperation())(<<"groupAll">>))(data_list@ps:groupAll(DictOrd)).

'group\''() ->
  fun
    (V) ->
      fun
        (DictOrd) ->
          'group\''(V, DictOrd)
      end
  end.

'group\''(_, DictOrd) ->
  groupAll(DictOrd).

group() ->
  fun
    (DictEq) ->
      group(DictEq)
  end.

group(DictEq) ->
  ((wrappedOperation())(<<"group">>))(data_list@ps:group(DictEq)).

fromList() ->
  fun
    (V) ->
      fromList(V)
  end.

fromList(V) ->
  case V of
    {nil} ->
      {nothing};
    {cons, V@1, V@2} ->
      {just, {nonEmpty, V@1, V@2}};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

fromFoldable() ->
  fun
    (DictFoldable) ->
      fromFoldable(DictFoldable)
  end.

fromFoldable(#{ foldr := DictFoldable }) ->
  begin
    V = (DictFoldable(data_list_types@ps:'Cons'()))({nil}),
    fun
      (X) ->
        begin
          V@1 = V(X),
          case V@1 of
            {nil} ->
              {nothing};
            {cons, V@2, V@3} ->
              {just, {nonEmpty, V@2, V@3}};
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
        end
    end
  end.

foldM() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (B) ->
              fun
                (V) ->
                  foldM(DictMonad, F, B, V)
              end
          end
      end
  end.

foldM(DictMonad = #{ 'Bind1' := DictMonad@1 }, F, B, V) ->
  begin
    V@1 = erlang:element(3, V),
    ((erlang:map_get(bind, DictMonad@1(undefined)))
     ((F(B))(erlang:element(2, V))))
    (fun
      (B_) ->
        data_list@ps:foldM(DictMonad, F, B_, V@1)
    end)
  end.

findLastIndex() ->
  fun
    (F) ->
      fun
        (V) ->
          findLastIndex(F, V)
      end
  end.

findLastIndex(F, V) ->
  begin
    V1 = data_list@ps:findLastIndex(F, erlang:element(3, V)),
    case V1 of
      {just, V1@1} ->
        {just, V1@1 + 1};
      {nothing} ->
        case F(erlang:element(2, V)) of
          true ->
            {just, 0};
          _ ->
            {nothing}
        end;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

findIndex() ->
  fun
    (F) ->
      fun
        (V) ->
          findIndex(F, V)
      end
  end.

findIndex(F, V) ->
  case F(erlang:element(2, V)) of
    true ->
      {just, 0};
    _ ->
      begin
        Go =
          fun
            Go (V@1, V1) ->
              case V1 of
                {cons, V1@1, _} ->
                  case F(V1@1) of
                    true ->
                      {just, V@1};
                    _ ->
                      begin
                        {cons, _, V1@2} = V1,
                        V@2 = V@1 + 1,
                        Go(V@2, V1@2)
                      end
                  end;
                {nil} ->
                  {nothing};
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
          end,
        V@2 =
          begin
            V@1 = 0,
            V1 = erlang:element(3, V),
            Go(V@1, V1)
          end,
        case V@2 of
          {just, V@3} ->
            {just, V@3 + 1};
          _ ->
            {nothing}
        end
      end
  end.

filterM() ->
  fun
    (DictMonad) ->
      filterM(DictMonad)
  end.

filterM(DictMonad) ->
  begin
    V = data_list@ps:filterM(DictMonad),
    fun
      (X) ->
        begin
          V@1 = V(X),
          fun
            (V@2) ->
              V@1({cons, erlang:element(2, V@2), erlang:element(3, V@2)})
          end
        end
    end
  end.

filter() ->
  fun
    (X) ->
      filter(X)
  end.

filter(X) ->
  begin
    V = data_list@ps:filter(X),
    fun
      (V@1) ->
        V({cons, erlang:element(2, V@1), erlang:element(3, V@1)})
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
          fun
            (V) ->
              elemIndex(DictEq, X, V)
          end
      end
  end.

elemIndex(DictEq = #{ eq := DictEq@1 }, X, V) ->
  case (DictEq@1(erlang:element(2, V)))(X) of
    true ->
      {just, 0};
    _ ->
      begin
        Go =
          fun
            Go (V@1, V1) ->
              case V1 of
                {cons, V1@1, _} ->
                  begin
                    #{ eq := DictEq@2 } = DictEq,
                    case (DictEq@2(V1@1))(X) of
                      true ->
                        {just, V@1};
                      _ ->
                        begin
                          {cons, _, V1@2} = V1,
                          V@2 = V@1 + 1,
                          Go(V@2, V1@2)
                        end
                    end
                  end;
                {nil} ->
                  {nothing};
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
          end,
        V@2 =
          begin
            V@1 = 0,
            V1 = erlang:element(3, V),
            Go(V@1, V1)
          end,
        case V@2 of
          {just, V@3} ->
            {just, V@3 + 1};
          _ ->
            {nothing}
        end
      end
  end.

dropWhile() ->
  fun
    (X) ->
      dropWhile(X)
  end.

dropWhile(X) ->
  begin
    Go =
      fun
        Go (V) ->
          case ?IS_KNOWN_TAG(cons, 2, V) andalso (X(erlang:element(2, V))) of
            true ->
              begin
                {cons, _, V@1} = V,
                Go(V@1)
              end;
            _ ->
              V
          end
      end,
    fun
      (V) ->
        Go({cons, erlang:element(2, V), erlang:element(3, V)})
    end
  end.

drop() ->
  fun
    (X) ->
      fun
        (V) ->
          drop(X, V)
      end
  end.

drop(X, V) ->
  data_list@ps:drop(X, {cons, erlang:element(2, V), erlang:element(3, V)}).

'cons\''() ->
  fun
    (X) ->
      fun
        (Xs) ->
          'cons\''(X, Xs)
      end
  end.

'cons\''(X, Xs) ->
  {nonEmpty, X, Xs}.

cons() ->
  fun
    (Y) ->
      fun
        (V) ->
          cons(Y, V)
      end
  end.

cons(Y, V) ->
  {nonEmpty, Y, {cons, erlang:element(2, V), erlang:element(3, V)}}.

concatMap() ->
  fun
    (B) ->
      fun
        (A) ->
          concatMap(B, A)
      end
  end.

concatMap(B, A) ->
  ((erlang:map_get(bind, data_list_types@ps:bindNonEmptyList()))(A))(B).

concat() ->
  fun
    (V) ->
      concat(V)
  end.

concat(V) ->
  ((erlang:map_get(bind, data_list_types@ps:bindNonEmptyList()))(V))(identity()).

catMaybes() ->
  fun
    (V) ->
      catMaybes(V)
  end.

catMaybes(V) ->
  (data_list@ps:catMaybes())({cons, erlang:element(2, V), erlang:element(3, V)}).

appendFoldable() ->
  fun
    (DictFoldable) ->
      appendFoldable(DictFoldable)
  end.

appendFoldable(#{ foldr := DictFoldable }) ->
  begin
    FromFoldable1 = (DictFoldable(data_list_types@ps:'Cons'()))({nil}),
    fun
      (V) ->
        fun
          (Ys) ->
            { nonEmpty
            , erlang:element(2, V)
            , (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
                (data_list_types@ps:'Cons'()))
               (FromFoldable1(Ys)))
              (erlang:element(3, V))
            }
        end
    end
  end.

zip(V, V@1) ->
  zipWith(data_tuple@ps:'Tuple'(), V, V@1).

reverse(V) ->
  wrappedOperation(<<"reverse">>, data_list@ps:reverse(), V).

