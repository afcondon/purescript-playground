-module(erl_data_list@ps).
-export([ any/0
        , zipWith/0
        , zipWith/3
        , zipWithA/0
        , zipWithA/1
        , zip/0
        , updateAt/0
        , updateAt/3
        , unzip/0
        , unsnoc/0
        , unsnoc/1
        , toUnfoldable/0
        , toUnfoldable/1
        , takeWhile/0
        , takeWhile/1
        , 'take.go'/0
        , 'take.go'/3
        , take/0
        , tail/0
        , tail/1
        , span/0
        , span/2
        , snoc/0
        , snoc/2
        , singleton/0
        , singleton/1
        , range/0
        , range/2
        , nubBy/0
        , nubBy/2
        , nub/0
        , nub/1
        , mergeBy/0
        , mergeBy/3
        , sortBy/0
        , sortBy/1
        , sort/0
        , sort/1
        , merge/0
        , merge/1
        , last/0
        , last/1
        , intersectBy/0
        , intersectBy/3
        , intersect/0
        , intersect/1
        , insertBy/0
        , insertBy/3
        , insertAt/0
        , insertAt/3
        , insert/0
        , insert/1
        , init/0
        , init/1
        , index/0
        , index/2
        , head/0
        , head/1
        , transpose/0
        , transpose/1
        , groupBy/0
        , groupBy/2
        , group/0
        , group/1
        , 'group\''/0
        , 'group\''/1
        , fromFoldable/0
        , fromFoldable/1
        , foldM/0
        , foldM/4
        , findIndex/0
        , findIndex/1
        , findLastIndex/0
        , findLastIndex/2
        , filterM/0
        , filterM/1
        , elemLastIndex/0
        , elemLastIndex/2
        , elemIndex/0
        , elemIndex/2
        , dropWhile/0
        , dropWhile/1
        , drop/0
        , drop/2
        , slice/0
        , slice/3
        , deleteBy/0
        , deleteBy/3
        , unionBy/0
        , unionBy/3
        , union/0
        , union/1
        , deleteAt/0
        , deleteAt/2
        , delete/0
        , delete/1
        , difference/0
        , difference/1
        , concatMap/0
        , concatMap/2
        , catMaybes/0
        , alterAt/0
        , alterAt/3
        , modifyAt/0
        , modifyAt/2
        , rangeImpl/0
        , length/0
        , reverse/0
        , concat/0
        , zip/2
        , unzip/1
        , take/2
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
any() ->
  (erlang:map_get(foldMap, erl_data_list_types@ps:foldableList()))
  (begin
    SemigroupDisj1 =
      #{ append =>
         fun
           (V) ->
             fun
               (V1) ->
                 V orelse V1
             end
         end
       },
    #{ mempty => false
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupDisj1
       end
     }
  end).

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
  begin
    Go =
      fun
        Go (L1, L2, Acc) ->
          begin
            V = erl_data_list_types@ps:uncons(L2),
            V1 = erl_data_list_types@ps:uncons(L1),
            case V1 of
              {nothing} ->
                Acc;
              _ ->
                case V of
                  {nothing} ->
                    Acc;
                  _ ->
                    if
                      ?IS_KNOWN_TAG(just, 1, V1)
                        andalso ?IS_KNOWN_TAG(just, 1, V) ->
                        begin
                          {just, #{ head := V@1, tail := V@2 }} = V,
                          {just, #{ head := V1@1, tail := V1@2 }} = V1,
                          (fun
                            (Acc@1) ->
                              Go(V1@2, V@2, Acc@1)
                          end)
                          ([ (F(V1@1))(V@1) | Acc ])
                        end;
                      true ->
                        erlang:error({fail, <<"Failed pattern match">>})
                    end
                end
            end
          end
      end,
    erl_data_list@foreign:reverse((fun
                                    (Acc) ->
                                      Go(Xs, Ys, Acc)
                                  end)
                                  ([]))
  end.

zipWithA() ->
  fun
    (DictApplicative) ->
      zipWithA(DictApplicative)
  end.

zipWithA(DictApplicative) ->
  begin
    Sequence1 =
      (erlang:map_get(sequence, erl_data_list_types@ps:traversableList()))
      (DictApplicative),
    fun
      (F) ->
        fun
          (Xs) ->
            fun
              (Ys) ->
                Sequence1(zipWith(F, Xs, Ys))
            end
        end
    end
  end.

zip() ->
  (zipWith())(data_tuple@ps:'Tuple'()).

updateAt() ->
  fun
    (N) ->
      fun
        (X) ->
          fun
            (L) ->
              updateAt(N, X, L)
          end
      end
  end.

updateAt(N, X, L) ->
  begin
    V = erl_data_list_types@ps:uncons(L),
    case V of
      {just, #{ tail := V@1 }} ->
        if
          N =:= 0 ->
            {just, [ X | V@1 ]};
          true ->
            begin
              V@2 = updateAt(N - 1, X, V@1),
              case V@2 of
                {just, V@3} ->
                  begin
                    {just, #{ head := V@4 }} = V,
                    {just, [ V@4 | V@3 ]}
                  end;
                _ ->
                  {nothing}
              end
            end
        end;
      {nothing} ->
        {nothing};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

unzip() ->
  ((erl_data_list_types@ps:foldrImpl())
   (fun
     (V) ->
       begin
         V@1 = erlang:element(2, V),
         V@2 = erlang:element(3, V),
         fun
           (V1) ->
             { tuple
             , [ V@1 | erlang:element(2, V1) ]
             , [ V@2 | erlang:element(3, V1) ]
             }
         end
       end
   end))
  ({tuple, [], []}).

unsnoc() ->
  fun
    (Lst) ->
      unsnoc(Lst)
  end.

unsnoc(Lst) ->
  begin
    Go =
      fun
        Go (Lst_, Acc) ->
          begin
            V = erl_data_list_types@ps:uncons(Lst_),
            case V of
              {just, #{ head := V@1, tail := V@2 }} ->
                if
                  [] =:= V@2 ->
                    {just, #{ revInit => Acc, last => V@1 }};
                  true ->
                    begin
                      Acc@1 = [ V@1 | Acc ],
                      Go(V@2, Acc@1)
                    end
                end;
              {nothing} ->
                {nothing};
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
          end
      end,
    V =
      begin
        Acc = [],
        Go(Lst, Acc)
      end,
    case V of
      {just, #{ last := V@1, revInit := V@2 }} ->
        {just, #{ init => erl_data_list@foreign:reverse(V@2), last => V@1 }};
      _ ->
        {nothing}
    end
  end.

toUnfoldable() ->
  fun
    (DictUnfoldable) ->
      toUnfoldable(DictUnfoldable)
  end.

toUnfoldable(#{ unfoldr := DictUnfoldable }) ->
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
  end).

takeWhile() ->
  fun
    (P) ->
      takeWhile(P)
  end.

takeWhile(P) ->
  begin
    Go =
      fun
        Go (V, V1) ->
          begin
            V@1 = erl_data_list_types@ps:uncons(V1),
            case ?IS_KNOWN_TAG(just, 1, V@1)
                andalso (P(erlang:map_get(head, erlang:element(2, V@1)))) of
              true ->
                begin
                  {just, #{ head := V@2, tail := V@3 }} = V@1,
                  V@4 = [ V@2 | V ],
                  Go(V@4, V@3)
                end;
              _ ->
                erl_data_list@foreign:reverse(V)
            end
          end
      end,
    V = [],
    fun
      (V1) ->
        Go(V, V1)
    end
  end.

'take.go'() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              'take.go'(V, V1, V2)
          end
      end
  end.

'take.go'(V, V1, V2) ->
  if
    V1 =:= 0 ->
      erl_data_list@foreign:reverse(V);
    true ->
      begin
        V3 = erl_data_list_types@ps:uncons(V2),
        case V3 of
          {nothing} ->
            erl_data_list@foreign:reverse(V);
          {just, #{ head := V3@1, tail := V3@2 }} ->
            'take.go'([ V3@1 | V ], V1 - 1, V3@2);
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end.

take() ->
  ('take.go'())([]).

tail() ->
  fun
    (X) ->
      tail(X)
  end.

tail(X) ->
  begin
    V = erl_data_list_types@ps:uncons(X),
    case V of
      {just, #{ tail := V@1 }} ->
        {just, V@1};
      _ ->
        {nothing}
    end
  end.

span() ->
  fun
    (P) ->
      fun
        (Xs) ->
          span(P, Xs)
      end
  end.

span(P, Xs) ->
  begin
    V = erl_data_list_types@ps:uncons(Xs),
    case ?IS_KNOWN_TAG(just, 1, V)
        andalso (P(erlang:map_get(head, erlang:element(2, V)))) of
      true ->
        begin
          {just, #{ head := V@1, tail := V@2 }} = V,
          #{ init := V1, rest := V1@1 } = span(P, V@2),
          #{ init => [ V@1 | V1 ], rest => V1@1 }
        end;
      _ ->
        #{ init => [], rest => Xs }
    end
  end.

snoc() ->
  fun
    (Xs) ->
      fun
        (X) ->
          snoc(Xs, X)
      end
  end.

snoc(Xs, X) ->
  erl_data_list@foreign:reverse([ X | erl_data_list@foreign:reverse(Xs) ]).

singleton() ->
  fun
    (A) ->
      singleton(A)
  end.

singleton(A) ->
  [A].

range() ->
  fun
    (N) ->
      fun
        (M) ->
          range(N, M)
      end
  end.

range(N, M) ->
  erl_data_list@foreign:rangeImpl(
    N,
    M,
    if
      N > M ->
        -1;
      true ->
        1
    end
  ).

nubBy() ->
  fun
    (Eq_) ->
      fun
        (L) ->
          nubBy(Eq_, L)
      end
  end.

nubBy(Eq_, L) ->
  begin
    V = erl_data_list_types@ps:uncons(L),
    case V of
      {nothing} ->
        [];
      {just, #{ head := V@1, tail := V@2 }} ->
        [ V@1
        | nubBy(
            Eq_,
            lists:filter(
              fun
                (Y) ->
                  not ((Eq_(V@1))(Y))
              end,
              V@2
            )
          )
        ];
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

nub() ->
  fun
    (DictEq) ->
      nub(DictEq)
  end.

nub(#{ eq := DictEq }) ->
  (nubBy())(DictEq).

mergeBy() ->
  fun
    (Cmp) ->
      fun
        (As) ->
          fun
            (Bs) ->
              mergeBy(Cmp, As, Bs)
          end
      end
  end.

mergeBy(Cmp, As, Bs) ->
  begin
    V = erl_data_list_types@ps:uncons(Bs),
    V1 = erl_data_list_types@ps:uncons(As),
    case V1 of
      {just, _} ->
        case V of
          {just, #{ head := V@1 }} ->
            begin
              {just, #{ head := V1@1 }} = V1,
              V@2 = (Cmp(V1@1))(V@1),
              case ?IS_KNOWN_TAG(gT, 0, V@2) of
                true ->
                  begin
                    {just, #{ head := V@3, tail := V@4 }} = V,
                    [ V@3 | mergeBy(Cmp, As, V@4) ]
                  end;
                _ ->
                  begin
                    {just, #{ head := V1@2, tail := V1@3 }} = V1,
                    [ V1@2 | mergeBy(Cmp, V1@3, Bs) ]
                  end
              end
            end;
          {nothing} ->
            As;
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end;
      {nothing} ->
        Bs;
      _ ->
        case V of
          {nothing} ->
            As;
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
    end
  end.

sortBy() ->
  fun
    (Cmp) ->
      sortBy(Cmp)
  end.

sortBy(Cmp) ->
  begin
    MergePairs =
      fun
        MergePairs (V) ->
          begin
            V@1 = erl_data_list_types@ps:uncons(V),
            case V@1 of
              {just, #{ tail := V@2 }} ->
                begin
                  V@3 = erl_data_list_types@ps:uncons(V@2),
                  case V@3 of
                    {just, #{ head := V@4, tail := V@5 }} ->
                      begin
                        {just, #{ head := V@6 }} = V@1,
                        [ mergeBy(Cmp, V@6, V@4) | MergePairs(V@5) ]
                      end;
                    _ ->
                      V
                  end
                end;
              _ ->
                V
            end
          end
      end,
    MergeAll =
      fun
        MergeAll (V) ->
          begin
            V@1 = erl_data_list_types@ps:uncons(V),
            if
              ?IS_KNOWN_TAG(just, 1, V@1)
                andalso ([] =:= (erlang:map_get(tail, erlang:element(2, V@1)))) ->
                begin
                  {just, #{ head := V@2 }} = V@1,
                  V@2
                end;
              true ->
                MergeAll(MergePairs(V))
            end
          end
      end,
    Sequences =
      fun
        (Sequences, Descending, Ascending) ->
          fun
            (V) ->
              begin
                V@1 = erl_data_list_types@ps:uncons(V),
                case V@1 of
                  {just, #{ tail := V@2 }} ->
                    begin
                      V@3 = erl_data_list_types@ps:uncons(V@2),
                      case V@3 of
                        {just, #{ head := V@4, tail := V@5 }} ->
                          begin
                            {just, #{ head := V@6 }} = V@1,
                            V@7 = (Cmp(V@6))(V@4),
                            case ?IS_KNOWN_TAG(gT, 0, V@7) of
                              true ->
                                (((Descending(Sequences, Descending, Ascending))
                                  (V@4))
                                 ([V@6]))
                                (V@5);
                              _ ->
                                (((Ascending(Sequences, Descending, Ascending))
                                  (V@4))
                                 (fun
                                   (V3) ->
                                     [ V@6 | V3 ]
                                 end))
                                (V@5)
                            end
                          end;
                        _ ->
                          [V]
                      end
                    end;
                  _ ->
                    [V]
                end
              end
          end
      end,
    Descending =
      fun
        (Sequences@1, Descending, Ascending) ->
          fun
            (V) ->
              fun
                (V1) ->
                  fun
                    (V2) ->
                      begin
                        V@1 = erl_data_list_types@ps:uncons(V2),
                        case ?IS_KNOWN_TAG(just, 1, V@1)
                            andalso begin
                              V@2 =
                                (Cmp(V))
                                (erlang:map_get(head, erlang:element(2, V@1))),
                              ?IS_KNOWN_TAG(gT, 0, V@2)
                            end of
                          true ->
                            begin
                              {just, #{ head := V@3, tail := V@4 }} = V@1,
                              (((Descending(Sequences@1, Descending, Ascending))
                                (V@3))
                               ([ V | V1 ]))
                              (V@4)
                            end;
                          _ ->
                            [ [ V | V1 ]
                            | (Sequences@1(Sequences@1, Descending, Ascending))
                              (V2)
                            ]
                        end
                      end
                  end
              end
          end
      end,
    Ascending =
      fun
        (Sequences@1, Descending@1, Ascending) ->
          fun
            (V) ->
              fun
                (V1) ->
                  fun
                    (V2) ->
                      begin
                        V@1 = erl_data_list_types@ps:uncons(V2),
                        case ?IS_KNOWN_TAG(just, 1, V@1)
                            andalso begin
                              V@2 =
                                (Cmp(V))
                                (erlang:map_get(head, erlang:element(2, V@1))),
                              ?IS_KNOWN_TAG(lT, 0, V@2)
                                orelse (not ?IS_KNOWN_TAG(gT, 0, V@2))
                            end of
                          true ->
                            begin
                              {just, #{ head := V@3, tail := V@4 }} = V@1,
                              (((Ascending(
                                   Sequences@1,
                                   Descending@1,
                                   Ascending
                                 ))
                                (V@3))
                               (fun
                                 (Ys) ->
                                   V1([ V | Ys ])
                               end))
                              (V@4)
                            end;
                          _ ->
                            [ V1([V])
                            | (Sequences@1(
                                 Sequences@1,
                                 Descending@1,
                                 Ascending
                               ))
                              (V2)
                            ]
                        end
                      end
                  end
              end
          end
      end,
    Sequences@1 = Sequences(Sequences, Descending, Ascending),
    Descending(Sequences, Descending, Ascending),
    Ascending(Sequences, Descending, Ascending),
    fun
      (X) ->
        MergeAll(Sequences@1(X))
    end
  end.

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

merge() ->
  fun
    (DictOrd) ->
      merge(DictOrd)
  end.

merge(#{ compare := DictOrd }) ->
  (mergeBy())(DictOrd).

last() ->
  fun
    (List) ->
      last(List)
  end.

last(List) ->
  begin
    V = erl_data_list_types@ps:uncons(List),
    case V of
      {just, V@1 = #{ tail := V@2 }} ->
        if
          [] =:= V@2 ->
            {just, erlang:map_get(head, V@1)};
          true ->
            last(V@2)
        end;
      _ ->
        {nothing}
    end
  end.

intersectBy() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              intersectBy(V, V1, V2)
          end
      end
  end.

intersectBy(V, V1, V2) ->
  begin
    V@1 = erl_data_list_types@ps:uncons(V1),
    case ?IS_KNOWN_TAG(nothing, 0, V@1) of
      true ->
        [];
      _ ->
        begin
          V@2 = erl_data_list_types@ps:uncons(V2),
          case ?IS_KNOWN_TAG(nothing, 0, V@2) of
            true ->
              [];
            _ ->
              lists:filter(
                fun
                  (X) ->
                    ((any())(V(X)))(V2)
                end,
                V1
              )
          end
        end
    end
  end.

intersect() ->
  fun
    (DictEq) ->
      intersect(DictEq)
  end.

intersect(#{ eq := DictEq }) ->
  (intersectBy())(DictEq).

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
    V = erl_data_list_types@ps:uncons(Ys),
    case V of
      {nothing} ->
        [X];
      {just, #{ head := V@1 }} ->
        begin
          V@2 = (Cmp(X))(V@1),
          case ?IS_KNOWN_TAG(gT, 0, V@2) of
            true ->
              begin
                {just, #{ head := V@3, tail := V@4 }} = V,
                [ V@3 | insertBy(Cmp, X, V@4) ]
              end;
            _ ->
              [ X | Ys ]
          end
        end;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

insertAt() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              insertAt(V, V1, V2)
          end
      end
  end.

insertAt(V, V1, V2) ->
  if
    V =:= 0 ->
      {just, [ V1 | V2 ]};
    true ->
      begin
        V@1 = erl_data_list_types@ps:uncons(V2),
        case V@1 of
          {just, #{ tail := V@2 }} ->
            begin
              V@3 = insertAt(V - 1, V1, V@2),
              case V@3 of
                {just, V@4} ->
                  begin
                    {just, #{ head := V@5 }} = V@1,
                    {just, [ V@5 | V@4 ]}
                  end;
                _ ->
                  {nothing}
              end
            end;
          _ ->
            {nothing}
        end
      end
  end.

insert() ->
  fun
    (DictOrd) ->
      insert(DictOrd)
  end.

insert(#{ compare := DictOrd }) ->
  (insertBy())(DictOrd).

init() ->
  fun
    (Lst) ->
      init(Lst)
  end.

init(Lst) ->
  begin
    V = unsnoc(Lst),
    case V of
      {just, #{ init := V@1 }} ->
        {just, V@1};
      _ ->
        {nothing}
    end
  end.

index() ->
  fun
    (L) ->
      fun
        (I) ->
          index(L, I)
      end
  end.

index(L, I) ->
  begin
    V = erl_data_list_types@ps:uncons(L),
    case V of
      {nothing} ->
        {nothing};
      {just, V@1} ->
        if
          I =:= 0 ->
            {just, erlang:map_get(head, V@1)};
          true ->
            index(erlang:map_get(tail, V@1), I - 1)
        end;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

head() ->
  fun
    (X) ->
      head(X)
  end.

head(X) ->
  begin
    V = erl_data_list_types@ps:uncons(X),
    case V of
      {just, #{ head := V@1 }} ->
        {just, V@1};
      _ ->
        {nothing}
    end
  end.

transpose() ->
  fun
    (L) ->
      transpose(L)
  end.

transpose(L) ->
  begin
    V = erl_data_list_types@ps:uncons(L),
    case V of
      {nothing} ->
        [];
      {just, #{ head := V@1, tail := V@2 }} ->
        begin
          V1 = erl_data_list_types@ps:uncons(V@1),
          case V1 of
            {nothing} ->
              transpose(V@2);
            {just, #{ head := V1@1, tail := V1@2 }} ->
              [ [ V1@1 | (erl_data_list_types@ps:mapMaybe(head()))(V@2) ]
              | transpose([ V1@2
                          | (erl_data_list_types@ps:mapMaybe(tail()))(V@2)
                          ])
              ];
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
        end;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

groupBy() ->
  fun
    (Eq2) ->
      fun
        (X) ->
          groupBy(Eq2, X)
      end
  end.

groupBy(Eq2, X) ->
  begin
    V = erl_data_list_types@ps:uncons(X),
    case V of
      {nothing} ->
        [];
      {just, #{ head := V@1, tail := V@2 }} ->
        begin
          #{ init := V1, rest := V1@1 } = span(Eq2(V@1), V@2),
          [ {nonEmpty, V@1, V1} | groupBy(Eq2, V1@1) ]
        end;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

group() ->
  fun
    (DictEq) ->
      group(DictEq)
  end.

group(#{ eq := DictEq }) ->
  (groupBy())(DictEq).

'group\''() ->
  fun
    (DictOrd) ->
      'group\''(DictOrd)
  end.

'group\''(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    V = group(DictOrd(undefined)),
    fun
      (X) ->
        V((sortBy(DictOrd@1))(X))
    end
  end.

fromFoldable() ->
  fun
    (DictFoldable) ->
      fromFoldable(DictFoldable)
  end.

fromFoldable(#{ foldr := DictFoldable }) ->
  (DictFoldable(erl_data_list_types@ps:cons()))([]).

foldM() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (L) ->
                  foldM(DictMonad, F, A, L)
              end
          end
      end
  end.

foldM(DictMonad, F, A, L) ->
  begin
    V = erl_data_list_types@ps:uncons(L),
    case V of
      {nothing} ->
        (erlang:map_get(
           pure,
           (erlang:map_get('Applicative0', DictMonad))(undefined)
         ))
        (A);
      {just, #{ head := V@1, tail := V@2 }} ->
        ((erlang:map_get(bind, (erlang:map_get('Bind1', DictMonad))(undefined)))
         ((F(A))(V@1)))
        (fun
          (A_) ->
            foldM(DictMonad, F, A_, V@2)
        end);
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

findIndex() ->
  fun
    (Fn) ->
      findIndex(Fn)
  end.

findIndex(Fn) ->
  begin
    Go =
      fun
        Go (N, L) ->
          begin
            V = erl_data_list_types@ps:uncons(L),
            case V of
              {just, #{ head := V@1 }} ->
                case Fn(V@1) of
                  true ->
                    {just, N};
                  _ ->
                    begin
                      {just, #{ tail := V@2 }} = V,
                      N@1 = N + 1,
                      Go(N@1, V@2)
                    end
                end;
              {nothing} ->
                {nothing};
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
          end
      end,
    N = 0,
    fun
      (L) ->
        Go(N, L)
    end
  end.

findLastIndex() ->
  fun
    (Fn) ->
      fun
        (Xs) ->
          findLastIndex(Fn, Xs)
      end
  end.

findLastIndex(Fn, Xs) ->
  begin
    V = (findIndex(Fn))(erl_data_list@foreign:reverse(Xs)),
    case V of
      {just, V@1} ->
        {just, ((erl_data_list@foreign:length(Xs)) - 1) - V@1};
      _ ->
        {nothing}
    end
  end.

filterM() ->
  fun
    (DictMonad) ->
      filterM(DictMonad)
  end.

filterM(DictMonad = #{ 'Applicative0' := DictMonad@1, 'Bind1' := DictMonad@2 }) ->
  begin
    #{ pure := V } = DictMonad@1(undefined),
    V@1 = DictMonad@2(undefined),
    fun
      (P) ->
        fun
          (X) ->
            begin
              V@2 = erl_data_list_types@ps:uncons(X),
              case V@2 of
                {nothing} ->
                  V([]);
                {just, #{ head := V@3, tail := V@4 }} ->
                  begin
                    #{ bind := V@5 } = V@1,
                    (V@5(P(V@3)))
                    (fun
                      (B) ->
                        (V@5(((filterM(DictMonad))(P))(V@4)))
                        (fun
                          (Xs_) ->
                            V(if
                              B ->
                                [ V@3 | Xs_ ];
                              true ->
                                Xs_
                            end)
                        end)
                    end)
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
            end
        end
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
  findIndex(fun
    (V) ->
      (DictEq(V))(X)
  end).

dropWhile() ->
  fun
    (P) ->
      dropWhile(P)
  end.

dropWhile(P) ->
  begin
    Go =
      fun
        Go (V) ->
          begin
            V@1 = erl_data_list_types@ps:uncons(V),
            case ?IS_KNOWN_TAG(just, 1, V@1)
                andalso (P(erlang:map_get(head, erlang:element(2, V@1)))) of
              true ->
                begin
                  {just, #{ tail := V@2 }} = V@1,
                  Go(V@2)
                end;
              _ ->
                V
            end
          end
      end,
    Go
  end.

drop() ->
  fun
    (V) ->
      fun
        (V1) ->
          drop(V, V1)
      end
  end.

drop(V, V1) ->
  if
    V =:= 0 ->
      V1;
    true ->
      begin
        V2 = erl_data_list_types@ps:uncons(V1),
        case V2 of
          {nothing} ->
            [];
          {just, #{ tail := V2@1 }} ->
            drop(V - 1, V2@1);
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end.

slice() ->
  fun
    (Start) ->
      fun
        (End) ->
          fun
            (Xs) ->
              slice(Start, End, Xs)
          end
      end
  end.

slice(Start, End, Xs) ->
  take(End - Start, drop(Start, Xs)).

deleteBy() ->
  fun
    (Eq_) ->
      fun
        (X) ->
          fun
            (L) ->
              deleteBy(Eq_, X, L)
          end
      end
  end.

deleteBy(Eq_, X, L) ->
  begin
    V = erl_data_list_types@ps:uncons(L),
    case V of
      {nothing} ->
        [];
      {just, #{ head := V@1, tail := V@2 }} ->
        case (Eq_(X))(V@1) of
          true ->
            V@2;
          _ ->
            [ V@1 | deleteBy(Eq_, X, V@2) ]
        end;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

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
  Xs
    ++ (erl_data_list_types@foreign:foldlImpl(
          fun
            (B) ->
              fun
                (A) ->
                  deleteBy(Eq2, A, B)
              end
          end,
          nubBy(Eq2, Ys),
          Xs
        )).

union() ->
  fun
    (DictEq) ->
      union(DictEq)
  end.

union(#{ eq := DictEq }) ->
  (unionBy())(DictEq).

deleteAt() ->
  fun
    (N) ->
      fun
        (L) ->
          deleteAt(N, L)
      end
  end.

deleteAt(N, L) ->
  begin
    V = erl_data_list_types@ps:uncons(L),
    case V of
      {just, #{ tail := V@1 }} ->
        if
          N =:= 0 ->
            {just, V@1};
          true ->
            begin
              V@2 = deleteAt(N - 1, V@1),
              case V@2 of
                {just, V@3} ->
                  begin
                    {just, #{ head := V@4 }} = V,
                    {just, [ V@4 | V@3 ]}
                  end;
                _ ->
                  {nothing}
              end
            end
        end;
      {nothing} ->
        {nothing};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
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

difference(#{ eq := DictEq }) ->
  (erl_data_list_types@ps:foldlImpl())
  (fun
    (B) ->
      fun
        (A) ->
          deleteBy(DictEq, A, B)
      end
  end).

concatMap() ->
  fun
    (F) ->
      fun
        (List) ->
          concatMap(F, List)
      end
  end.

concatMap(F, List) ->
  begin
    V = erl_data_list_types@ps:uncons(List),
    case V of
      {nothing} ->
        [];
      {just, #{ head := V@1, tail := V@2 }} ->
        (F(V@1)) ++ (concatMap(F, V@2));
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

catMaybes() ->
  erl_data_list_types@ps:mapMaybe(fun
    (X) ->
      X
  end).

alterAt() ->
  fun
    (N) ->
      fun
        (F) ->
          fun
            (L) ->
              alterAt(N, F, L)
          end
      end
  end.

alterAt(N, F, L) ->
  begin
    V = erl_data_list_types@ps:uncons(L),
    case V of
      {just, V@1 = #{ tail := V@2 }} ->
        if
          N =:= 0 ->
            { just
            , begin
                V1 = F(erlang:map_get(head, V@1)),
                case V1 of
                  {nothing} ->
                    V@2;
                  {just, V1@1} ->
                    [ V1@1 | V@2 ];
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end
            };
          true ->
            begin
              V@3 = alterAt(N - 1, F, V@2),
              case V@3 of
                {just, V@4} ->
                  begin
                    {just, #{ head := V@5 }} = V,
                    {just, [ V@5 | V@4 ]}
                  end;
                _ ->
                  {nothing}
              end
            end
        end;
      {nothing} ->
        {nothing};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

modifyAt() ->
  fun
    (N) ->
      fun
        (F) ->
          modifyAt(N, F)
      end
  end.

modifyAt(N, F) ->
  ((alterAt())(N))
  (fun
    (X) ->
      {just, F(X)}
  end).

rangeImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              erl_data_list@foreign:rangeImpl(V, V@1, V@2)
          end
      end
  end.

length() ->
  fun
    (V) ->
      erl_data_list@foreign:length(V)
  end.

reverse() ->
  fun
    (V) ->
      erl_data_list@foreign:reverse(V)
  end.

concat() ->
  fun
    (V) ->
      erl_data_list@foreign:concat(V)
  end.

zip(V, V@1) ->
  zipWith(data_tuple@ps:'Tuple'(), V, V@1).

unzip(V) ->
  erl_data_list_types@foreign:foldrImpl(
    fun
      (V@1) ->
        begin
          V@2 = erlang:element(2, V@1),
          V@3 = erlang:element(3, V@1),
          fun
            (V1) ->
              { tuple
              , [ V@2 | erlang:element(2, V1) ]
              , [ V@3 | erlang:element(3, V1) ]
              }
          end
        end
    end,
    {tuple, [], []},
    V
  ).

take(V, V@1) ->
  'take.go'([], V, V@1).

