-module(data_list@ps).
-export([ any/0
        , identity/0
        , identity/1
        , 'Pattern'/0
        , 'Pattern'/1
        , updateAt/0
        , updateAt/3
        , unzip/0
        , uncons/0
        , uncons/1
        , toUnfoldable/0
        , toUnfoldable/1
        , tail/0
        , tail/1
        , stripPrefix/0
        , stripPrefix/3
        , span/0
        , span/2
        , snoc/0
        , snoc/2
        , singleton/0
        , singleton/1
        , sortBy/0
        , sortBy/1
        , sort/0
        , sort/1
        , showPattern/0
        , showPattern/1
        , 'reverse.go'/0
        , 'reverse.go'/2
        , reverse/0
        , 'take.go'/0
        , 'take.go'/3
        , take/0
        , takeWhile/0
        , takeWhile/1
        , unsnoc/0
        , unsnoc/1
        , zipWith/0
        , zipWith/3
        , zip/0
        , zipWithA/0
        , zipWithA/1
        , range/0
        , range/2
        , partition/0
        , partition/2
        , null/0
        , null/1
        , nubBy/0
        , nubBy/1
        , nub/0
        , nub/1
        , newtypePattern/0
        , mapWithIndex/0
        , mapMaybe/0
        , mapMaybe/1
        , manyRec/0
        , manyRec/2
        , someRec/0
        , someRec/2
        , some/0
        , some/3
        , many/0
        , many/3
        , 'length.go'/0
        , 'length.go'/2
        , length/0
        , last/0
        , last/1
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
        , groupAllBy/0
        , groupAllBy/1
        , group/0
        , group/1
        , groupAll/0
        , groupAll/1
        , 'group\''/0
        , 'group\''/2
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
        , filter/0
        , filter/1
        , intersectBy/0
        , intersectBy/3
        , intersect/0
        , intersect/1
        , nubByEq/0
        , nubByEq/2
        , nubEq/0
        , nubEq/1
        , eqPattern/0
        , eqPattern/1
        , ordPattern/0
        , ordPattern/1
        , elemLastIndex/0
        , elemLastIndex/2
        , elemIndex/0
        , elemIndex/2
        , dropWhile/0
        , dropWhile/1
        , dropEnd/0
        , dropEnd/2
        , drop/0
        , drop/2
        , slice/0
        , slice/3
        , takeEnd/0
        , takeEnd/2
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
        , concat/0
        , concat/1
        , catMaybes/0
        , alterAt/0
        , alterAt/3
        , modifyAt/0
        , modifyAt/2
        , reverse/1
        , take/2
        , zip/2
        , length/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
any() ->
  (erlang:map_get(foldMap, data_list_types@ps:foldableList()))
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

identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

'Pattern'() ->
  fun
    (X) ->
      'Pattern'(X)
  end.

'Pattern'(X) ->
  X.

updateAt() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              updateAt(V, V1, V2)
          end
      end
  end.

updateAt(V, V1, V2) ->
  case V2 of
    {cons, _, V2@1} ->
      if
        V =:= 0 ->
          {just, {cons, V1, V2@1}};
        true ->
          begin
            V@1 = updateAt(V - 1, V1, V2@1),
            case V@1 of
              {just, V@2} ->
                begin
                  {cons, V2@2, _} = V2,
                  {just, {cons, V2@2, V@2}}
                end;
              _ ->
                {nothing}
            end
          end
      end;
    _ ->
      {nothing}
  end.

unzip() ->
  ((erlang:map_get(foldr, data_list_types@ps:foldableList()))
   (fun
     (V) ->
       begin
         V@1 = erlang:element(2, V),
         V@2 = erlang:element(3, V),
         fun
           (V1) ->
             { tuple
             , {cons, V@1, erlang:element(2, V1)}
             , {cons, V@2, erlang:element(3, V1)}
             }
         end
       end
   end))
  ({tuple, {nil}, {nil}}).

uncons() ->
  fun
    (V) ->
      uncons(V)
  end.

uncons(V) ->
  case V of
    {nil} ->
      {nothing};
    {cons, V@1, V@2} ->
      {just, #{ head => V@1, tail => V@2 }};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

toUnfoldable() ->
  fun
    (DictUnfoldable) ->
      toUnfoldable(DictUnfoldable)
  end.

toUnfoldable(#{ unfoldr := DictUnfoldable }) ->
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
  end).

tail() ->
  fun
    (V) ->
      tail(V)
  end.

tail(V) ->
  case V of
    {nil} ->
      {nothing};
    {cons, _, V@1} ->
      {just, V@1};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

stripPrefix() ->
  fun
    (DictEq) ->
      fun
        (V) ->
          fun
            (S) ->
              stripPrefix(DictEq, V, S)
          end
      end
  end.

stripPrefix(DictEq, V, S) ->
  begin
    V@1 =
      fun
        (Prefix, Input) ->
          case Input of
            {cons, _, _} ->
              case Prefix of
                {cons, Prefix@1, _} ->
                  begin
                    {cons, Input@1, _} = Input,
                    #{ eq := DictEq@1 } = DictEq,
                    case (DictEq@1(Prefix@1))(Input@1) of
                      true ->
                        begin
                          {cons, _, Prefix@2} = Prefix,
                          {cons, _, Input@2} = Input,
                          {just, {loop, #{ a => Prefix@2, b => Input@2 }}}
                        end;
                      _ ->
                        {nothing}
                    end
                  end;
                {nil} ->
                  begin
                    {cons, _, _} = Input,
                    {just, {done, Input}}
                  end;
                _ ->
                  {nothing}
              end;
            _ ->
              case Prefix of
                {nil} ->
                  {just, {done, Input}};
                _ ->
                  {nothing}
              end
          end
      end,
    V@2 =
      fun
        (V@2) ->
          case V@2 of
            {nothing} ->
              {done, {nothing}};
            {just, V@3} ->
              case V@3 of
                {loop, #{ a := V@4, b := V@5 }} ->
                  {loop, V@1(V@4, V@5)};
                {done, V@6} ->
                  {done, {just, V@6}};
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Go =
      fun
        Go (V@3) ->
          case V@3 of
            {loop, V@4} ->
              Go(V@2(V@4));
            {done, V@5} ->
              V@5;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Go(V@2(V@1(V, S)))
  end.

span() ->
  fun
    (V) ->
      fun
        (V1) ->
          span(V, V1)
      end
  end.

span(V, V1) ->
  case ?IS_KNOWN_TAG(cons, 2, V1) andalso (V(erlang:element(2, V1))) of
    true ->
      begin
        {cons, V1@1, V1@2} = V1,
        #{ init := V2, rest := V2@1 } = span(V, V1@2),
        #{ init => {cons, V1@1, V2}, rest => V2@1 }
      end;
    _ ->
      #{ init => {nil}, rest => V1 }
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
  (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
    (data_list_types@ps:'Cons'()))
   ({cons, X, {nil}}))
  (Xs).

singleton() ->
  fun
    (A) ->
      singleton(A)
  end.

singleton(A) ->
  {cons, A, {nil}}.

sortBy() ->
  fun
    (Cmp) ->
      sortBy(Cmp)
  end.

sortBy(Cmp) ->
  begin
    Merge =
      fun
        Merge (V, V1) ->
          case V of
            {cons, _, _} ->
              case V1 of
                {cons, V1@1, _} ->
                  begin
                    V@1 = (Cmp(erlang:element(2, V)))(V1@1),
                    case ?IS_KNOWN_TAG(gT, 0, V@1) of
                      true ->
                        { cons
                        , V1@1
                        , begin
                            V1@2 = erlang:element(3, V1),
                            Merge(V, V1@2)
                          end
                        };
                      _ ->
                        { cons
                        , erlang:element(2, V)
                        , begin
                            V@2 = erlang:element(3, V),
                            Merge(V@2, V1)
                          end
                        }
                    end
                  end;
                {nil} ->
                  V;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            {nil} ->
              V1;
            _ ->
              case V1 of
                {nil} ->
                  V;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
          end
      end,
    MergePairs =
      fun
        MergePairs (V) ->
          if
            ?IS_KNOWN_TAG(cons, 2, V)
              andalso ?IS_KNOWN_TAG(cons, 2, erlang:element(3, V)) ->
              begin
                {cons, V@1, {cons, V@2, V@3}} = V,
                {cons, Merge(V@1, V@2), MergePairs(V@3)}
              end;
            true ->
              V
          end
      end,
    MergeAll =
      fun
        MergeAll (V) ->
          if
            ?IS_KNOWN_TAG(cons, 2, V)
              andalso ?IS_KNOWN_TAG(nil, 0, erlang:element(3, V)) ->
              begin
                {cons, V@1, _} = V,
                V@1
              end;
            true ->
              MergeAll(MergePairs(V))
          end
      end,
    Sequences =
      fun
        (Sequences, Descending, Ascending) ->
          fun
            (V) ->
              if
                ?IS_KNOWN_TAG(cons, 2, V)
                  andalso ?IS_KNOWN_TAG(cons, 2, erlang:element(3, V)) ->
                  begin
                    {cons, V@1, {cons, V@2, V@3}} = V,
                    V@4 = (Cmp(V@1))(V@2),
                    case ?IS_KNOWN_TAG(gT, 0, V@4) of
                      true ->
                        (((Descending(Sequences, Descending, Ascending))(V@2))
                         ({cons, V@1, {nil}}))
                        (V@3);
                      _ ->
                        (((Ascending(Sequences, Descending, Ascending))(V@2))
                         (fun
                           (V1) ->
                             {cons, V@1, V1}
                         end))
                        (V@3)
                    end
                  end;
                true ->
                  {cons, V, {nil}}
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
                      case ?IS_KNOWN_TAG(cons, 2, V2)
                          andalso begin
                            V@1 = (Cmp(V))(erlang:element(2, V2)),
                            ?IS_KNOWN_TAG(gT, 0, V@1)
                          end of
                        true ->
                          begin
                            {cons, V2@1, V2@2} = V2,
                            (((Descending(Sequences@1, Descending, Ascending))
                              (V2@1))
                             ({cons, V, V1}))
                            (V2@2)
                          end;
                        _ ->
                          { cons
                          , {cons, V, V1}
                          , (Sequences@1(Sequences@1, Descending, Ascending))
                            (V2)
                          }
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
                      case ?IS_KNOWN_TAG(cons, 2, V2)
                          andalso begin
                            V@1 = (Cmp(V))(erlang:element(2, V2)),
                            ?IS_KNOWN_TAG(lT, 0, V@1)
                              orelse (not ?IS_KNOWN_TAG(gT, 0, V@1))
                          end of
                        true ->
                          begin
                            {cons, V2@1, V2@2} = V2,
                            (((Ascending(Sequences@1, Descending@1, Ascending))
                              (V2@1))
                             (fun
                               (Ys) ->
                                 V1({cons, V, Ys})
                             end))
                            (V2@2)
                          end;
                        _ ->
                          { cons
                          , V1({cons, V, {nil}})
                          , (Sequences@1(Sequences@1, Descending@1, Ascending))
                            (V2)
                          }
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

showPattern() ->
  fun
    (DictShow) ->
      showPattern(DictShow)
  end.

showPattern(DictShow) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(Pattern ",
           ((erlang:map_get(show, data_list_types@ps:showList(DictShow)))(V))/binary,
           ")"
         >>
     end
   }.

'reverse.go'() ->
  fun
    (V) ->
      fun
        (V1) ->
          'reverse.go'(V, V1)
      end
  end.

'reverse.go'(V, V1) ->
  case V1 of
    {nil} ->
      V;
    {cons, V1@1, V1@2} ->
      'reverse.go'({cons, V1@1, V}, V1@2);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

reverse() ->
  ('reverse.go'())({nil}).

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
    V1 < 1 ->
      reverse(V);
    ?IS_KNOWN_TAG(nil, 0, V2) ->
      reverse(V);
    ?IS_KNOWN_TAG(cons, 2, V2) ->
      begin
        {cons, V2@1, V2@2} = V2,
        'take.go'({cons, V2@1, V}, V1 - 1, V2@2)
      end;
    true ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

take() ->
  ('take.go'())({nil}).

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
          case ?IS_KNOWN_TAG(cons, 2, V1) andalso (P(erlang:element(2, V1))) of
            true ->
              begin
                {cons, V1@1, V1@2} = V1,
                V@1 = {cons, V1@1, V},
                Go(V@1, V1@2)
              end;
            _ ->
              reverse(V)
          end
      end,
    V = {nil},
    fun
      (V1) ->
        Go(V, V1)
    end
  end.

unsnoc() ->
  fun
    (Lst) ->
      unsnoc(Lst)
  end.

unsnoc(Lst) ->
  begin
    Go =
      fun
        Go (V, V1) ->
          case V of
            {nil} ->
              {nothing};
            {cons, V@1, V@2} ->
              case V@2 of
                {nil} ->
                  {just, #{ revInit => V1, last => V@1 }};
                _ ->
                  begin
                    V1@1 = {cons, V@1, V1},
                    Go(V@2, V1@1)
                  end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V =
      begin
        V1 = {nil},
        Go(Lst, V1)
      end,
    case V of
      {just, #{ last := V@1, revInit := V@2 }} ->
        {just, #{ init => reverse(V@2), last => V@1 }};
      _ ->
        {nothing}
    end
  end.

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
        Go (V, V1, V2) ->
          case V of
            {nil} ->
              V2;
            _ ->
              case V1 of
                {nil} ->
                  V2;
                _ ->
                  if
                    ?IS_KNOWN_TAG(cons, 2, V) andalso ?IS_KNOWN_TAG(cons, 2, V1) ->
                      begin
                        {cons, V@1, V@2} = V,
                        {cons, V1@1, V1@2} = V1,
                        (fun
                          (V2@1) ->
                            Go(V@2, V1@2, V2@1)
                        end)
                        ({cons, (F(V@1))(V1@1), V2})
                      end;
                    true ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
              end
          end
      end,
    reverse((fun
              (V2) ->
                Go(Xs, Ys, V2)
            end)
            ({nil}))
  end.

zip() ->
  (zipWith())(data_tuple@ps:'Tuple'()).

zipWithA() ->
  fun
    (DictApplicative) ->
      zipWithA(DictApplicative)
  end.

zipWithA(DictApplicative) ->
  begin
    Sequence1 =
      ((erlang:map_get(traverse, data_list_types@ps:traversableList()))
       (DictApplicative))
      (data_list_types@ps:identity()),
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

range() ->
  fun
    (Start) ->
      fun
        (End) ->
          range(Start, End)
      end
  end.

range(Start, End) ->
  if
    Start =:= End ->
      {cons, Start, {nil}};
    true ->
      begin
        Go =
          fun
            Go (S, E, Step, Rest) ->
              if
                S =:= E ->
                  {cons, S, Rest};
                true ->
                  (begin
                     S@1 = S + Step,
                     fun
                       (Step@1) ->
                         fun
                           (Rest@1) ->
                             Go(S@1, E, Step@1, Rest@1)
                         end
                     end
                   end
                   (Step))
                  ({cons, S, Rest})
              end
          end,
        ((fun
           (Step) ->
             fun
               (Rest) ->
                 Go(End, Start, Step, Rest)
             end
         end)
         (if
           Start > End ->
             1;
           true ->
             -1
         end))
        ({nil})
      end
  end.

partition() ->
  fun
    (P) ->
      fun
        (Xs) ->
          partition(P, Xs)
      end
  end.

partition(P, Xs) ->
  (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
    (fun
      (X) ->
        fun
          (#{ no := V, yes := V@1 }) ->
            case P(X) of
              true ->
                #{ no => V, yes => {cons, X, V@1} };
              _ ->
                #{ no => {cons, X, V}, yes => V@1 }
            end
        end
    end))
   (#{ no => {nil}, yes => {nil} }))
  (Xs).

null() ->
  fun
    (V) ->
      null(V)
  end.

null(V) ->
  ?IS_KNOWN_TAG(nil, 0, V).

nubBy() ->
  fun
    (P) ->
      nubBy(P)
  end.

nubBy(P) ->
  begin
    Go =
      fun
        Go (V, V1, V2) ->
          case V2 of
            {nil} ->
              V1;
            {cons, V2@1, V2@2} ->
              begin
                V3 = #{ result := V3@1 } =
                  data_list_internal@ps:insertAndLookupBy(P, V2@1, V),
                if
                  erlang:map_get(found, V3) ->
                    (fun
                      (V2@3) ->
                        Go(V3@1, V1, V2@3)
                    end)
                    (V2@2);
                  true ->
                    begin
                      V1@1 = {cons, V2@1, V1},
                      fun
                        (V2@3) ->
                          Go(V3@1, V1@1, V2@3)
                      end
                    end
                    (V2@2)
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V@1 =
      begin
        V = {leaf},
        V1 = {nil},
        fun
          (V2) ->
            Go(V, V1, V2)
        end
      end,
    fun
      (X) ->
        reverse(V@1(X))
    end
  end.

nub() ->
  fun
    (DictOrd) ->
      nub(DictOrd)
  end.

nub(#{ compare := DictOrd }) ->
  nubBy(DictOrd).

newtypePattern() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

mapWithIndex() ->
  erlang:map_get(mapWithIndex, data_list_types@ps:functorWithIndexList()).

mapMaybe() ->
  fun
    (F) ->
      mapMaybe(F)
  end.

mapMaybe(F) ->
  begin
    Go =
      fun
        Go (V, V1) ->
          case V1 of
            {nil} ->
              reverse(V);
            {cons, V1@1, V1@2} ->
              begin
                V2 = F(V1@1),
                case V2 of
                  {nothing} ->
                    Go(V, V1@2);
                  {just, V2@1} ->
                    begin
                      V@1 = {cons, V2@1, V},
                      Go(V@1, V1@2)
                    end;
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V = {nil},
    fun
      (V1) ->
        Go(V, V1)
    end
  end.

manyRec() ->
  fun
    (DictMonadRec) ->
      fun
        (DictAlternative) ->
          manyRec(DictMonadRec, DictAlternative)
      end
  end.

manyRec( #{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }
       , #{ 'Applicative0' := DictAlternative, 'Plus1' := DictAlternative@1 }
       ) ->
  begin
    #{ 'Functor0' := Alt0, alt := Alt0@1 } =
      (erlang:map_get('Alt0', DictAlternative@1(undefined)))(undefined),
    #{ pure := V } = DictAlternative(undefined),
    fun
      (P) ->
        (DictMonadRec@1(fun
           (Acc) ->
             ((erlang:map_get(
                 bind,
                 (erlang:map_get('Bind1', DictMonadRec(undefined)))(undefined)
               ))
              ((Alt0@1(((erlang:map_get(map, Alt0(undefined)))
                        (control_monad_rec_class@ps:'Loop'()))
                       (P)))
               (V({done, unit}))))
             (fun
               (Aa) ->
                 V(case Aa of
                   {loop, Aa@1} ->
                     {loop, {cons, Aa@1, Acc}};
                   {done, _} ->
                     {done, reverse(Acc)};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end)
             end)
         end))
        ({nil})
    end
  end.

someRec() ->
  fun
    (DictMonadRec) ->
      fun
        (DictAlternative) ->
          someRec(DictMonadRec, DictAlternative)
      end
  end.

someRec( DictMonadRec
       , DictAlternative = #{ 'Applicative0' := DictAlternative@1
                            , 'Plus1' := DictAlternative@2
                            }
       ) ->
  begin
    ManyRec2 = manyRec(DictMonadRec, DictAlternative),
    fun
      (V) ->
        ((erlang:map_get(
            apply,
            (erlang:map_get('Apply0', DictAlternative@1(undefined)))(undefined)
          ))
         (((erlang:map_get(
              map,
              (erlang:map_get(
                 'Functor0',
                 (erlang:map_get('Alt0', DictAlternative@2(undefined)))
                 (undefined)
               ))
              (undefined)
            ))
           (data_list_types@ps:'Cons'()))
          (V)))
        (ManyRec2(V))
    end
  end.

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
     (data_list_types@ps:'Cons'()))
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
  ((erlang:map_get(pure, DictAlternative@1(undefined)))({nil})).

'length.go'() ->
  fun
    (B) ->
      fun
        (V) ->
          'length.go'(B, V)
      end
  end.

'length.go'(B, V) ->
  case V of
    {nil} ->
      B;
    {cons, _, V@1} ->
      'length.go'(B + 1, V@1);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

length() ->
  ('length.go'())(0).

last() ->
  fun
    (V) ->
      last(V)
  end.

last(V) ->
  case V of
    {cons, _, V@1} ->
      case V@1 of
        {nil} ->
          {just, erlang:element(2, V)};
        _ ->
          last(V@1)
      end;
    _ ->
      {nothing}
  end.

insertBy() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              insertBy(V, V1, V2)
          end
      end
  end.

insertBy(V, V1, V2) ->
  case V2 of
    {nil} ->
      {cons, V1, {nil}};
    {cons, V2@1, _} ->
      begin
        V@1 = (V(V1))(V2@1),
        case ?IS_KNOWN_TAG(gT, 0, V@1) of
          true ->
            {cons, V2@1, insertBy(V, V1, erlang:element(3, V2))};
          _ ->
            {cons, V1, V2}
        end
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
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
      {just, {cons, V1, V2}};
    ?IS_KNOWN_TAG(cons, 2, V2) ->
      begin
        {cons, _, V2@1} = V2,
        V@1 = insertAt(V - 1, V1, V2@1),
        case V@1 of
          {just, V@2} ->
            begin
              {cons, V2@2, _} = V2,
              {just, {cons, V2@2, V@2}}
            end;
          _ ->
            {nothing}
        end
      end;
    true ->
      {nothing}
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
    (V) ->
      fun
        (V1) ->
          index(V, V1)
      end
  end.

index(V, V1) ->
  case V of
    {nil} ->
      {nothing};
    {cons, _, _} ->
      if
        V1 =:= 0 ->
          {just, erlang:element(2, V)};
        true ->
          index(erlang:element(3, V), V1 - 1)
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

head() ->
  fun
    (V) ->
      head(V)
  end.

head(V) ->
  case V of
    {nil} ->
      {nothing};
    {cons, V@1, _} ->
      {just, V@1};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

transpose() ->
  fun
    (V) ->
      transpose(V)
  end.

transpose(V) ->
  case V of
    {nil} ->
      {nil};
    {cons, V@1, V@2} ->
      case V@1 of
        {nil} ->
          transpose(V@2);
        {cons, V@3, V@4} ->
          { cons
          , {cons, V@3, (mapMaybe(head()))(V@2)}
          , transpose({cons, V@4, (mapMaybe(tail()))(V@2)})
          };
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

groupBy() ->
  fun
    (V) ->
      fun
        (V1) ->
          groupBy(V, V1)
      end
  end.

groupBy(V, V1) ->
  case V1 of
    {nil} ->
      {nil};
    {cons, V1@1, V1@2} ->
      begin
        #{ init := V2, rest := V2@1 } = span(V(V1@1), V1@2),
        {cons, {nonEmpty, V1@1, V2}, groupBy(V, V2@1)}
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

groupAllBy() ->
  fun
    (DictOrd) ->
      groupAllBy(DictOrd)
  end.

groupAllBy(#{ compare := DictOrd }) ->
  fun
    (P) ->
      fun
        (X) ->
          groupBy(P, (sortBy(DictOrd))(X))
      end
  end.

group() ->
  fun
    (DictEq) ->
      group(DictEq)
  end.

group(#{ eq := DictEq }) ->
  (groupBy())(DictEq).

groupAll() ->
  fun
    (DictOrd) ->
      groupAll(DictOrd)
  end.

groupAll(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    V = group(DictOrd(undefined)),
    fun
      (X) ->
        V((sortBy(DictOrd@1))(X))
    end
  end.

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

fromFoldable() ->
  fun
    (DictFoldable) ->
      fromFoldable(DictFoldable)
  end.

fromFoldable(#{ foldr := DictFoldable }) ->
  (DictFoldable(data_list_types@ps:'Cons'()))({nil}).

foldM() ->
  fun
    (DictMonad) ->
      fun
        (V) ->
          fun
            (V1) ->
              fun
                (V2) ->
                  foldM(DictMonad, V, V1, V2)
              end
          end
      end
  end.

foldM(DictMonad, V, V1, V2) ->
  case V2 of
    {nil} ->
      (erlang:map_get(
         pure,
         (erlang:map_get('Applicative0', DictMonad))(undefined)
       ))
      (V1);
    {cons, V2@1, V2@2} ->
      ((erlang:map_get(bind, (erlang:map_get('Bind1', DictMonad))(undefined)))
       ((V(V1))(V2@1)))
      (fun
        (B_) ->
          foldM(DictMonad, V, B_, V2@2)
      end);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
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
        Go (V, V1) ->
          case V1 of
            {cons, V1@1, _} ->
              case Fn(V1@1) of
                true ->
                  {just, V};
                _ ->
                  begin
                    {cons, _, V1@2} = V1,
                    V@1 = V + 1,
                    Go(V@1, V1@2)
                  end
              end;
            {nil} ->
              {nothing};
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V = 0,
    fun
      (V1) ->
        Go(V, V1)
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
    Go =
      fun
        Go (V, V1) ->
          case V1 of
            {cons, V1@1, _} ->
              case Fn(V1@1) of
                true ->
                  {just, V};
                _ ->
                  begin
                    {cons, _, V1@2} = V1,
                    V@1 = V + 1,
                    Go(V@1, V1@2)
                  end
              end;
            {nil} ->
              {nothing};
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V@1 =
      begin
        V = 0,
        V1 = reverse(Xs),
        Go(V, V1)
      end,
    case V@1 of
      {just, V@2} ->
        {just, ((length(Xs)) - 1) - V@2};
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
      (V@2) ->
        fun
          (V1) ->
            case V1 of
              {nil} ->
                V({nil});
              {cons, V1@1, V1@2} ->
                begin
                  #{ bind := V@3 } = V@1,
                  (V@3(V@2(V1@1)))
                  (fun
                    (B) ->
                      (V@3(((filterM(DictMonad))(V@2))(V1@2)))
                      (fun
                        (Xs_) ->
                          V(if
                            B ->
                              {cons, V1@1, Xs_};
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
  end.

filter() ->
  fun
    (P) ->
      filter(P)
  end.

filter(P) ->
  begin
    Go =
      fun
        Go (V, V1) ->
          case V1 of
            {nil} ->
              reverse(V);
            {cons, V1@1, V1@2} ->
              case P(V1@1) of
                true ->
                  begin
                    V@1 = {cons, V1@1, V},
                    Go(V@1, V1@2)
                  end;
                _ ->
                  Go(V, V1@2)
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V = {nil},
    fun
      (V1) ->
        Go(V, V1)
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
  case V1 of
    {nil} ->
      {nil};
    _ ->
      case V2 of
        {nil} ->
          {nil};
        _ ->
          (filter(fun
             (X) ->
               ((any())(V(X)))(V2)
           end))
          (V1)
      end
  end.

intersect() ->
  fun
    (DictEq) ->
      intersect(DictEq)
  end.

intersect(#{ eq := DictEq }) ->
  (intersectBy())(DictEq).

nubByEq() ->
  fun
    (V) ->
      fun
        (V1) ->
          nubByEq(V, V1)
      end
  end.

nubByEq(V, V1) ->
  case V1 of
    {nil} ->
      {nil};
    {cons, V1@1, V1@2} ->
      { cons
      , V1@1
      , nubByEq(
          V,
          (filter(fun
             (Y) ->
               not ((V(V1@1))(Y))
           end))
          (V1@2)
        )
      };
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

nubEq() ->
  fun
    (DictEq) ->
      nubEq(DictEq)
  end.

nubEq(#{ eq := DictEq }) ->
  (nubByEq())(DictEq).

eqPattern() ->
  fun
    (DictEq) ->
      eqPattern(DictEq)
  end.

eqPattern(DictEq) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             begin
               Go =
                 fun
                   Go (V, V1, V2) ->
                     if
                       not V2 ->
                         false;
                       ?IS_KNOWN_TAG(nil, 0, V) ->
                         ?IS_KNOWN_TAG(nil, 0, V1) andalso V2;
                       true ->
                         ?IS_KNOWN_TAG(cons, 2, V)
                           andalso (?IS_KNOWN_TAG(cons, 2, V1)
                             andalso (begin
                                        V@1 = erlang:element(3, V),
                                        V1@1 = erlang:element(3, V1),
                                        fun
                                          (V2@1) ->
                                            Go(V@1, V1@1, V2@1)
                                        end
                                      end
                                      (V2
                                        andalso (((erlang:map_get(eq, DictEq))
                                                  (erlang:element(2, V1)))
                                                 (erlang:element(2, V))))))
                     end
                 end,
               (fun
                 (V2) ->
                   Go(X, Y, V2)
               end)
               (true)
             end
         end
     end
   }.

ordPattern() ->
  fun
    (DictOrd) ->
      ordPattern(DictOrd)
  end.

ordPattern(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    V = DictOrd@1(undefined),
    EqPattern1 =
      #{ eq =>
         fun
           (X) ->
             fun
               (Y) ->
                 begin
                   Go =
                     fun
                       Go (V@1, V1, V2) ->
                         if
                           not V2 ->
                             false;
                           ?IS_KNOWN_TAG(nil, 0, V@1) ->
                             ?IS_KNOWN_TAG(nil, 0, V1) andalso V2;
                           true ->
                             ?IS_KNOWN_TAG(cons, 2, V@1)
                               andalso (?IS_KNOWN_TAG(cons, 2, V1)
                                 andalso (begin
                                            V@2 = erlang:element(3, V@1),
                                            V1@1 = erlang:element(3, V1),
                                            fun
                                              (V2@1) ->
                                                Go(V@2, V1@1, V2@1)
                                            end
                                          end
                                          (V2
                                            andalso (((erlang:map_get(eq, V))
                                                      (erlang:element(2, V1)))
                                                     (erlang:element(2, V@1))))))
                         end
                     end,
                   (fun
                     (V2) ->
                       Go(X, Y, V2)
                   end)
                   (true)
                 end
             end
         end
       },
    #{ compare =>
       fun
         (X) ->
           fun
             (Y) ->
               ((erlang:map_get(compare, data_list_types@ps:ordList(DictOrd)))
                (X))
               (Y)
           end
       end
     , 'Eq0' =>
       fun
         (_) ->
           EqPattern1
       end
     }
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

elemIndex(DictEq, X) ->
  begin
    Go =
      fun
        Go (V, V1) ->
          case V1 of
            {cons, V1@1, _} ->
              begin
                #{ eq := DictEq@1 } = DictEq,
                case (DictEq@1(V1@1))(X) of
                  true ->
                    {just, V};
                  _ ->
                    begin
                      {cons, _, V1@2} = V1,
                      V@1 = V + 1,
                      Go(V@1, V1@2)
                    end
                end
              end;
            {nil} ->
              {nothing};
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V = 0,
    fun
      (V1) ->
        Go(V, V1)
    end
  end.

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
          case ?IS_KNOWN_TAG(cons, 2, V) andalso (P(erlang:element(2, V))) of
            true ->
              begin
                {cons, _, V@1} = V,
                Go(V@1)
              end;
            _ ->
              V
          end
      end,
    Go
  end.

dropEnd() ->
  fun
    (N) ->
      fun
        (Xs) ->
          dropEnd(N, Xs)
      end
  end.

dropEnd(N, Xs) ->
  take((length(Xs)) - N, Xs).

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
    V < 1 ->
      V1;
    ?IS_KNOWN_TAG(nil, 0, V1) ->
      {nil};
    ?IS_KNOWN_TAG(cons, 2, V1) ->
      begin
        {cons, _, V1@1} = V1,
        drop(V - 1, V1@1)
      end;
    true ->
      erlang:error({fail, <<"Failed pattern match">>})
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

takeEnd() ->
  fun
    (N) ->
      fun
        (Xs) ->
          takeEnd(N, Xs)
      end
  end.

takeEnd(N, Xs) ->
  drop((length(Xs)) - N, Xs).

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
  case V2 of
    {nil} ->
      {nil};
    {cons, V2@1, V2@2} ->
      case (V(V1))(V2@1) of
        true ->
          V2@2;
        _ ->
          {cons, V2@1, deleteBy(V, V1, V2@2)}
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
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
  begin
    Go =
      fun
        Go (B, V) ->
          case V of
            {nil} ->
              B;
            {cons, V@1, V@2} ->
              begin
                B@1 = deleteBy(Eq2, V@1, B),
                Go(B@1, V@2)
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
      (data_list_types@ps:'Cons'()))
     (begin
       B = nubByEq(Eq2, Ys),
       Go(B, Xs)
     end))
    (Xs)
  end.

union() ->
  fun
    (DictEq) ->
      union(DictEq)
  end.

union(#{ eq := DictEq }) ->
  (unionBy())(DictEq).

deleteAt() ->
  fun
    (V) ->
      fun
        (V1) ->
          deleteAt(V, V1)
      end
  end.

deleteAt(V, V1) ->
  case V1 of
    {cons, _, V1@1} ->
      if
        V =:= 0 ->
          {just, V1@1};
        true ->
          begin
            V@1 = deleteAt(V - 1, V1@1),
            case V@1 of
              {just, V@2} ->
                begin
                  {cons, V1@2, _} = V1,
                  {just, {cons, V1@2, V@2}}
                end;
              _ ->
                {nothing}
            end
          end
      end;
    _ ->
      {nothing}
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
  begin
    Go =
      fun
        Go (B, V) ->
          case V of
            {nil} ->
              B;
            {cons, V@1, V@2} ->
              begin
                #{ eq := DictEq@1 } = DictEq,
                B@1 = deleteBy(DictEq@1, V@1, B),
                Go(B@1, V@2)
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    fun
      (B) ->
        fun
          (V) ->
            Go(B, V)
        end
    end
  end.

concatMap() ->
  fun
    (B) ->
      fun
        (A) ->
          concatMap(B, A)
      end
  end.

concatMap(B, A) ->
  ((erlang:map_get(bind, data_list_types@ps:bindList()))(A))(B).

concat() ->
  fun
    (V) ->
      concat(V)
  end.

concat(V) ->
  ((erlang:map_get(bind, data_list_types@ps:bindList()))(V))(identity()).

catMaybes() ->
  mapMaybe(identity()).

alterAt() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              alterAt(V, V1, V2)
          end
      end
  end.

alterAt(V, V1, V2) ->
  case V2 of
    {cons, _, V2@1} ->
      if
        V =:= 0 ->
          { just
          , begin
              V3 = V1(erlang:element(2, V2)),
              case V3 of
                {nothing} ->
                  V2@1;
                {just, V3@1} ->
                  {cons, V3@1, V2@1};
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
            end
          };
        true ->
          begin
            V@1 = alterAt(V - 1, V1, V2@1),
            case V@1 of
              {just, V@2} ->
                begin
                  {cons, V2@2, _} = V2,
                  {just, {cons, V2@2, V@2}}
                end;
              _ ->
                {nothing}
            end
          end
      end;
    _ ->
      {nothing}
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

reverse(V) ->
  'reverse.go'({nil}, V).

take(V, V@1) ->
  'take.go'({nil}, V, V@1).

zip(V, V@1) ->
  zipWith(data_tuple@ps:'Tuple'(), V, V@1).

length(V) ->
  case V of
    {nil} ->
      0;
    {cons, _, V@1} ->
      'length.go'(1, V@1);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

