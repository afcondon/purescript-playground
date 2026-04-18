-module(erl_data_list_nonEmpty@ps).
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
        , nubBy/0
        , nubBy/1
        , nub/0
        , nub/1
        , modifyAt/0
        , modifyAt/3
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
        , 'group\''/0
        , 'group\''/1
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
        , filterMap/0
        , filterMap/1
        , filterM/0
        , filterM/1
        , filter/0
        , filter/1
        , elemLastIndex/0
        , elemLastIndex/2
        , elemIndex/0
        , elemIndex/2
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
  , erl_data_list@ps:zipWith(F, erlang:element(3, V), erlang:element(3, V1))
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
          erl_data_list_types@ps:traversable1NonEmptyList()
        ))
       (DictApplicative(undefined)))
      (erl_data_list_types@ps:identity()),
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
      erl_data_list_types@ps:uncons((F([ erlang:element(2, V)
                                       | erlang:element(3, V)
                                       ]))
                                    ([ erlang:element(2, V1)
                                     | erlang:element(3, V1)
                                     ])),
    case V2 of
      {just, #{ head := V2@1, tail := V2@2 }} ->
        {nonEmpty, V2@1, V2@2};
      {nothing} ->
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
    V1 =
      erl_data_list_types@ps:uncons(F([ erlang:element(2, V)
                                      | erlang:element(3, V)
                                      ])),
    case V1 of
      {just, #{ head := V1@1, tail := V1@2 }} ->
        {nonEmpty, V1@1, V1@2};
      {nothing} ->
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
        V@1 = erl_data_list@ps:updateAt(I - 1, A, erlang:element(3, V)),
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
    , lists:map(data_tuple@ps:fst(), erlang:element(3, Ts))
    }
  , { nonEmpty
    , erlang:element(3, erlang:element(2, Ts))
    , lists:map(data_tuple@ps:snd(), erlang:element(3, Ts))
    }
  }.

unsnoc() ->
  fun
    (V) ->
      unsnoc(V)
  end.

unsnoc(V) ->
  begin
    V1 = erl_data_list@ps:unsnoc(erlang:element(3, V)),
    case V1 of
      {nothing} ->
        #{ init => [], last => erlang:element(2, V) };
      {just, #{ init := V1@1, last := V1@2 }} ->
        #{ init => [ erlang:element(2, V) | V1@1 ], last => V1@2 };
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
  ((wrappedOperation2())(<<"unionBy">>))((erl_data_list@ps:unionBy())(X)).

union() ->
  fun
    (DictEq) ->
      union(DictEq)
  end.

union(DictEq) ->
  ((wrappedOperation2())(<<"union">>))(erl_data_list@ps:union(DictEq)).

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
  [ erlang:element(2, V) | erlang:element(3, V) ].

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
          begin
            V = erl_data_list_types@ps:uncons(Xs),
            case V of
              {just, #{ head := V@1, tail := V@2 }} ->
                {just, {tuple, V@1, V@2}};
              _ ->
                {nothing}
            end
          end
      end),
    fun
      (X) ->
        V([ erlang:element(2, X) | erlang:element(3, X) ])
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
  ((wrappedOperation())(<<"sortBy">>))(erl_data_list@ps:sortBy(X)).

sort() ->
  fun
    (DictOrd) ->
      sort(DictOrd)
  end.

sort(#{ compare := DictOrd }) ->
  fun
    (Xs) ->
      wrappedOperation(<<"sortBy">>, erl_data_list@ps:sortBy(DictOrd), Xs)
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
  , erl_data_list@foreign:reverse([ Y
                                  | erl_data_list@foreign:reverse(erlang:element(
                                                                    3,
                                                                    V
                                                                  ))
                                  ])
  }.

singleton() ->
  fun
    (X) ->
      singleton(X)
  end.

singleton(X) ->
  {nonEmpty, X, []}.

'snoc\''() ->
  fun
    (L) ->
      fun
        (Y) ->
          'snoc\''(L, Y)
      end
  end.

'snoc\''(L, Y) ->
  begin
    V = erl_data_list_types@ps:uncons(L),
    case V of
      {just, #{ head := V@1, tail := V@2 }} ->
        { nonEmpty
        , V@1
        , erl_data_list@foreign:reverse([ Y
                                        | erl_data_list@foreign:reverse(V@2)
                                        ])
        };
      {nothing} ->
        {nonEmpty, Y, []};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

reverse() ->
  ((wrappedOperation())(<<"reverse">>))(erl_data_list@ps:reverse()).

nubBy() ->
  fun
    (X) ->
      nubBy(X)
  end.

nubBy(X) ->
  ((wrappedOperation())(<<"nubBy">>))((erl_data_list@ps:nubBy())(X)).

nub() ->
  fun
    (DictEq) ->
      nub(DictEq)
  end.

nub(DictEq) ->
  ((wrappedOperation())(<<"nub">>))(erl_data_list@ps:nub(DictEq)).

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
          erl_data_list@ps:alterAt(
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

partition() ->
  fun
    (X) ->
      fun
        (V) ->
          partition(X, V)
      end
  end.

partition(X, V) ->
  ((erlang:map_get(partition, erl_data_list_types@ps:filterableList()))(X))
  ([ erlang:element(2, V) | erlang:element(3, V) ]).

span() ->
  fun
    (X) ->
      fun
        (V) ->
          span(X, V)
      end
  end.

span(X, V) ->
  erl_data_list@ps:span(X, [ erlang:element(2, V) | erlang:element(3, V) ]).

take() ->
  fun
    (X) ->
      take(X)
  end.

take(X) ->
  begin
    V = (erl_data_list@ps:take())(X),
    fun
      (V@1) ->
        V([ erlang:element(2, V@1) | erlang:element(3, V@1) ])
    end
  end.

takeWhile() ->
  fun
    (X) ->
      takeWhile(X)
  end.

takeWhile(X) ->
  begin
    V = erl_data_list@ps:takeWhile(X),
    fun
      (V@1) ->
        V([ erlang:element(2, V@1) | erlang:element(3, V@1) ])
    end
  end.

length() ->
  fun
    (V) ->
      length(V)
  end.

length(V) ->
  1 + (erl_data_list@foreign:length(erlang:element(3, V))).

last() ->
  fun
    (V) ->
      last(V)
  end.

last(V) ->
  begin
    V@1 = erl_data_list@ps:last(erlang:element(3, V)),
    case V@1 of
      {nothing} ->
        erlang:element(2, V);
      {just, V@2} ->
        V@2;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

intersectBy() ->
  fun
    (X) ->
      intersectBy(X)
  end.

intersectBy(X) ->
  ((wrappedOperation2())(<<"intersectBy">>))
  ((erl_data_list@ps:intersectBy())(X)).

intersect() ->
  fun
    (DictEq) ->
      intersect(DictEq)
  end.

intersect(DictEq) ->
  ((wrappedOperation2())(<<"intersect">>))(erl_data_list@ps:intersect(DictEq)).

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
      {just, {nonEmpty, A, [ erlang:element(2, V) | erlang:element(3, V) ]}};
    true ->
      begin
        V@1 = erl_data_list@ps:insertAt(I - 1, A, erlang:element(3, V)),
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
    V@1 = erl_data_list@ps:unsnoc(erlang:element(3, V)),
    case V@1 of
      {just, #{ init := V@2 }} ->
        [ erlang:element(2, V) | V@2 ];
      _ ->
        []
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
      erl_data_list@ps:index(erlang:element(3, V), I - 1)
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
  ((wrappedOperation())(<<"groupBy">>))((erl_data_list@ps:groupBy())(X)).

'group\''() ->
  fun
    (DictOrd) ->
      'group\''(DictOrd)
  end.

'group\''(DictOrd) ->
  ((wrappedOperation())(<<"group\'">>))(erl_data_list@ps:'group\''(DictOrd)).

group() ->
  fun
    (DictEq) ->
      group(DictEq)
  end.

group(DictEq) ->
  ((wrappedOperation())(<<"group">>))(erl_data_list@ps:group(DictEq)).

fromList() ->
  fun
    (X) ->
      fromList(X)
  end.

fromList(X) ->
  begin
    V = erl_data_list_types@ps:uncons(X),
    case V of
      {nothing} ->
        {nothing};
      {just, #{ head := V@1, tail := V@2 }} ->
        {just, {nonEmpty, V@1, V@2}};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

fromFoldable() ->
  fun
    (DictFoldable) ->
      fromFoldable(DictFoldable)
  end.

fromFoldable(#{ foldr := DictFoldable }) ->
  begin
    V = (DictFoldable(erl_data_list_types@ps:cons()))([]),
    fun
      (X) ->
        fromList(V(X))
    end
  end.

foldM() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (V) ->
                  foldM(DictMonad, F, A, V)
              end
          end
      end
  end.

foldM(DictMonad = #{ 'Bind1' := DictMonad@1 }, F, A, V) ->
  begin
    V@1 = erlang:element(3, V),
    ((erlang:map_get(bind, DictMonad@1(undefined)))
     ((F(A))(erlang:element(2, V))))
    (fun
      (A_) ->
        erl_data_list@ps:foldM(DictMonad, F, A_, V@1)
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
    V1 = erl_data_list@ps:findLastIndex(F, erlang:element(3, V)),
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
        V@1 = (erl_data_list@ps:findIndex(F))(erlang:element(3, V)),
        case V@1 of
          {just, V@2} ->
            {just, V@2 + 1};
          _ ->
            {nothing}
        end
      end
  end.

filterMap() ->
  fun
    (X) ->
      filterMap(X)
  end.

filterMap(X) ->
  begin
    V = erl_data_list_types@ps:mapMaybe(X),
    fun
      (V@1) ->
        V([ erlang:element(2, V@1) | erlang:element(3, V@1) ])
    end
  end.

filterM() ->
  fun
    (DictMonad) ->
      filterM(DictMonad)
  end.

filterM(DictMonad) ->
  begin
    V = erl_data_list@ps:filterM(DictMonad),
    fun
      (X) ->
        begin
          V@1 = V(X),
          fun
            (V@2) ->
              V@1([ erlang:element(2, V@2) | erlang:element(3, V@2) ])
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
    V = (erl_data_list_types@ps:filter())(X),
    fun
      (V@1) ->
        V([ erlang:element(2, V@1) | erlang:element(3, V@1) ])
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

dropWhile() ->
  fun
    (X) ->
      dropWhile(X)
  end.

dropWhile(X) ->
  begin
    V = erl_data_list@ps:dropWhile(X),
    fun
      (V@1) ->
        V([ erlang:element(2, V@1) | erlang:element(3, V@1) ])
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
  erl_data_list@ps:drop(X, [ erlang:element(2, V) | erlang:element(3, V) ]).

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
  {nonEmpty, Y, [ erlang:element(2, V) | erlang:element(3, V) ]}.

concatMap() ->
  fun
    (B) ->
      fun
        (A) ->
          concatMap(B, A)
      end
  end.

concatMap(B, A) ->
  ((erlang:map_get(bind, erl_data_list_types@ps:bindNonEmptyList()))(A))(B).

concat() ->
  fun
    (V) ->
      concat(V)
  end.

concat(V) ->
  ((erlang:map_get(bind, erl_data_list_types@ps:bindNonEmptyList()))(V))
  (identity()).

catMaybes() ->
  fun
    (V) ->
      catMaybes(V)
  end.

catMaybes(V) ->
  (erl_data_list@ps:catMaybes())
  ([ erlang:element(2, V) | erlang:element(3, V) ]).

appendFoldable() ->
  fun
    (DictFoldable) ->
      appendFoldable(DictFoldable)
  end.

appendFoldable(#{ foldr := DictFoldable }) ->
  begin
    FromFoldable1 = (DictFoldable(erl_data_list_types@ps:cons()))([]),
    fun
      (V) ->
        fun
          (Ys) ->
            { nonEmpty
            , erlang:element(2, V)
            , (erlang:element(3, V)) ++ (FromFoldable1(Ys))
            }
        end
    end
  end.

zip(V, V@1) ->
  zipWith(data_tuple@ps:'Tuple'(), V, V@1).

reverse(V) ->
  wrappedOperation(<<"reverse">>, erl_data_list@ps:reverse(), V).

