-module(data_list_lazy@ps).
-export([ any/0
        , identity/0
        , identity/1
        , 'Pattern'/0
        , 'Pattern'/1
        , zipWith/0
        , zipWith/3
        , zipWithA/0
        , zipWithA/1
        , zip/0
        , updateAt/0
        , updateAt/3
        , unzip/0
        , uncons/0
        , uncons/1
        , toUnfoldable/0
        , toUnfoldable/1
        , takeWhile/0
        , takeWhile/1
        , take/0
        , take/1
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
        , showPattern/0
        , showPattern/1
        , scanlLazy/0
        , scanlLazy/3
        , reverse/0
        , reverse/1
        , replicateM/0
        , replicateM/1
        , repeat/0
        , repeat/1
        , replicate/0
        , replicate/2
        , range/0
        , range/2
        , partition/0
        , partition/1
        , null/0
        , null/1
        , nubBy/0
        , nubBy/1
        , nub/0
        , nub/1
        , newtypePattern/0
        , mapMaybe/0
        , mapMaybe/1
        , some/0
        , some/3
        , many/0
        , many/3
        , length/0
        , 'last.go'/0
        , 'last.go'/1
        , last/0
        , last/1
        , iterate/0
        , iterate/2
        , insertAt/0
        , insertAt/3
        , 'init.go'/0
        , 'init.go'/1
        , init/0
        , init/1
        , index/0
        , index/1
        , head/0
        , head/1
        , transpose/0
        , transpose/1
        , groupBy/0
        , groupBy/1
        , group/0
        , group/1
        , insertBy/0
        , insertBy/3
        , insert/0
        , insert/1
        , fromFoldable/0
        , fromFoldable/1
        , foldrLazy/0
        , foldrLazy/3
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
        , nubByEq/1
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
        , drop/0
        , drop/1
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
        , cycle/0
        , cycle/1
        , concatMap/0
        , concatMap/2
        , concat/0
        , concat/1
        , catMaybes/0
        , alterAt/0
        , alterAt/3
        , modifyAt/0
        , modifyAt/2
        , zip/2
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
any() ->
  (erlang:map_get(foldMap, data_list_lazy_types@ps:foldableList()))
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
    V =
      data_lazy@foreign:defer(fun
        (_) ->
          begin
            V = data_lazy@foreign:force(Xs),
            fun
              (V1) ->
                case V of
                  {nil} ->
                    {nil};
                  _ ->
                    case V1 of
                      {nil} ->
                        {nil};
                      _ ->
                        if
                          ?IS_KNOWN_TAG(cons, 2, V)
                            andalso ?IS_KNOWN_TAG(cons, 2, V1) ->
                            begin
                              {cons, V@1, V@2} = V,
                              {cons, V1@1, V1@2} = V1,
                              {cons, (F(V@1))(V1@1), zipWith(F, V@2, V1@2)}
                            end;
                          true ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                    end
                end
            end
          end
      end),
    data_lazy@foreign:defer(fun
      (_) ->
        (data_lazy@foreign:force(V))(data_lazy@foreign:force(Ys))
    end)
  end.

zipWithA() ->
  fun
    (DictApplicative) ->
      zipWithA(DictApplicative)
  end.

zipWithA(DictApplicative) ->
  begin
    Sequence1 =
      ((erlang:map_get(traverse, data_list_lazy_types@ps:traversableList()))
       (DictApplicative))
      (data_list_lazy_types@ps:identity()),
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
            (Xs) ->
              updateAt(N, X, Xs)
          end
      end
  end.

updateAt(N, X, Xs) ->
  data_lazy@foreign:defer(fun
    (_) ->
      begin
        V = data_lazy@foreign:force(Xs),
        case V of
          {nil} ->
            {nil};
          {cons, _, V@1} ->
            if
              N =:= 0 ->
                {cons, X, V@1};
              true ->
                {cons, erlang:element(2, V), updateAt(N - 1, X, V@1)}
            end;
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end).

unzip() ->
  begin
    V = data_list_lazy_types@ps:nil(),
    ((erlang:map_get(foldr, data_list_lazy_types@ps:foldableList()))
     (fun
       (V@1) ->
         begin
           V@2 = erlang:element(2, V@1),
           V@3 = erlang:element(3, V@1),
           fun
             (V1) ->
               begin
                 V@4 = erlang:element(2, V1),
                 V@5 = erlang:element(3, V1),
                 { tuple
                 , data_lazy@foreign:defer(fun
                     (_) ->
                       {cons, V@2, V@4}
                   end)
                 , data_lazy@foreign:defer(fun
                     (_) ->
                       {cons, V@3, V@5}
                   end)
                 }
               end
           end
         end
     end))
    ({tuple, V, V})
  end.

uncons() ->
  fun
    (Xs) ->
      uncons(Xs)
  end.

uncons(Xs) ->
  begin
    V = data_lazy@foreign:force(Xs),
    case V of
      {nil} ->
        {nothing};
      {cons, V@1, V@2} ->
        {just, #{ head => V@1, tail => V@2 }};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
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
        V = uncons(Xs),
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
  (erlang:map_get(map, data_lazy@ps:functorLazy()))
  (fun
    (V) ->
      case ?IS_KNOWN_TAG(cons, 2, V) andalso (P(erlang:element(2, V))) of
        true ->
          begin
            {cons, V@1, V@2} = V,
            {cons, V@1, (takeWhile(P))(V@2)}
          end;
        _ ->
          {nil}
      end
  end).

take() ->
  fun
    (N) ->
      take(N)
  end.

take(N) ->
  if
    N =< 0 ->
      fun
        (_) ->
          data_list_lazy_types@ps:nil()
      end;
    true ->
      (erlang:map_get(map, data_lazy@ps:functorLazy()))
      (fun
        (V1) ->
          case V1 of
            {nil} ->
              {nil};
            {cons, V1@1, V1@2} ->
              {cons, V1@1, (take(N - 1))(V1@2)};
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end)
  end.

tail() ->
  fun
    (Xs) ->
      tail(Xs)
  end.

tail(Xs) ->
  begin
    V = uncons(Xs),
    case V of
      {just, #{ tail := V@1 }} ->
        {just, V@1};
      _ ->
        {nothing}
    end
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
          begin
            V1 = data_lazy@foreign:force(Prefix),
            case V1 of
              {nil} ->
                {just, {done, Input}};
              {cons, _, _} ->
                begin
                  V2 = data_lazy@foreign:force(Input),
                  case ?IS_KNOWN_TAG(cons, 2, V2)
                      andalso (((erlang:map_get(eq, DictEq))
                                (erlang:element(2, V1)))
                               (erlang:element(2, V2))) of
                    true ->
                      begin
                        {cons, _, V2@1} = V2,
                        {cons, _, V1@1} = V1,
                        {just, {loop, #{ a => V1@1, b => V2@1 }}}
                      end;
                    _ ->
                      {nothing}
                  end
                end;
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
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
    (P) ->
      fun
        (Xs) ->
          span(P, Xs)
      end
  end.

span(P, Xs) ->
  begin
    V = uncons(Xs),
    case ?IS_KNOWN_TAG(just, 1, V)
        andalso (P(erlang:map_get(head, erlang:element(2, V)))) of
      true ->
        begin
          {just, #{ head := V@1, tail := V@2 }} = V,
          #{ init := V1, rest := V1@1 } = span(P, V@2),
          #{ init =>
             data_lazy@foreign:defer(fun
               (_) ->
                 {cons, V@1, V1}
             end)
           , rest => V1@1
           }
        end;
      _ ->
        #{ init => data_list_lazy_types@ps:nil(), rest => Xs }
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
  (((erlang:map_get(foldr, data_list_lazy_types@ps:foldableList()))
    (data_list_lazy_types@ps:cons()))
   (data_lazy@foreign:defer(fun
      (_) ->
        {cons, X, data_list_lazy_types@ps:nil()}
    end)))
  (Xs).

singleton() ->
  fun
    (A) ->
      singleton(A)
  end.

singleton(A) ->
  data_lazy@foreign:defer(fun
    (_) ->
      {cons, A, data_list_lazy_types@ps:nil()}
  end).

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
           ((erlang:map_get(show, data_list_lazy_types@ps:showList(DictShow)))
            (V))/binary,
           ")"
         >>
     end
   }.

scanlLazy() ->
  fun
    (F) ->
      fun
        (Acc) ->
          fun
            (Xs) ->
              scanlLazy(F, Acc, Xs)
          end
      end
  end.

scanlLazy(F, Acc, Xs) ->
  data_lazy@foreign:defer(fun
    (_) ->
      begin
        V = data_lazy@foreign:force(Xs),
        case V of
          {nil} ->
            {nil};
          {cons, V@1, V@2} ->
            begin
              Acc_ = (F(Acc))(V@1),
              {cons, Acc_, scanlLazy(F, Acc_, V@2)}
            end;
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end).

reverse() ->
  fun
    (Xs) ->
      reverse(Xs)
  end.

reverse(Xs) ->
  data_lazy@foreign:defer(fun
    (_) ->
      data_lazy@foreign:force((((erlang:map_get(
                                   foldl,
                                   data_list_lazy_types@ps:foldableList()
                                 ))
                                (fun
                                  (B) ->
                                    fun
                                      (A) ->
                                        data_lazy@foreign:defer(fun
                                          (_) ->
                                            {cons, A, B}
                                        end)
                                    end
                                end))
                               (data_list_lazy_types@ps:nil()))
                              (Xs))
  end).

replicateM() ->
  fun
    (DictMonad) ->
      replicateM(DictMonad)
  end.

replicateM(DictMonad = #{ 'Applicative0' := DictMonad@1
                        , 'Bind1' := DictMonad@2
                        }) ->
  begin
    #{ pure := V } = DictMonad@1(undefined),
    V@1 = DictMonad@2(undefined),
    fun
      (N) ->
        fun
          (M) ->
            if
              N < 1 ->
                V(data_list_lazy_types@ps:nil());
              true ->
                begin
                  #{ bind := V@2 } = V@1,
                  (V@2(M))
                  (fun
                    (A) ->
                      (V@2(((replicateM(DictMonad))(N - 1))(M)))
                      (fun
                        (As) ->
                          V(data_lazy@foreign:defer(fun
                              (_) ->
                                {cons, A, As}
                            end))
                      end)
                  end)
                end
            end
        end
    end
  end.

repeat() ->
  fun
    (X) ->
      repeat(X)
  end.

repeat(X) ->
  begin
    Go =
      fun
        Go () ->
          data_lazy@foreign:defer(fun
            (_) ->
              data_lazy@foreign:force(data_lazy@foreign:defer(fun
                                        (_) ->
                                          {cons, X, Go()}
                                      end))
          end)
      end,
    Go()
  end.

replicate() ->
  fun
    (I) ->
      fun
        (Xs) ->
          replicate(I, Xs)
      end
  end.

replicate(I, Xs) ->
  (take(I))(repeat(Xs)).

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
    Start > End ->
      ((erlang:map_get(unfoldr, data_list_lazy_types@ps:unfoldableList()))
       (fun
         (X) ->
           if
             X >= End ->
               {just, {tuple, X, X - 1}};
             true ->
               {nothing}
           end
       end))
      (Start);
    true ->
      ((erlang:map_get(unfoldr, data_list_lazy_types@ps:unfoldableList()))
       (fun
         (X) ->
           if
             X =< End ->
               {just, {tuple, X, X + 1}};
             true ->
               {nothing}
           end
       end))
      (Start)
  end.

partition() ->
  fun
    (F) ->
      partition(F)
  end.

partition(F) ->
  begin
    V = data_list_lazy_types@ps:nil(),
    ((erlang:map_get(foldr, data_list_lazy_types@ps:foldableList()))
     (fun
       (X) ->
         fun
           (#{ no := V@1, yes := V@2 }) ->
             case F(X) of
               true ->
                 #{ yes =>
                    data_lazy@foreign:defer(fun
                      (_) ->
                        {cons, X, V@2}
                    end)
                  , no => V@1
                  };
               _ ->
                 #{ yes => V@2
                  , no =>
                    data_lazy@foreign:defer(fun
                      (_) ->
                        {cons, X, V@1}
                    end)
                  }
             end
         end
     end))
    (#{ yes => V, no => V })
  end.

null() ->
  fun
    (X) ->
      null(X)
  end.

null(X) ->
  begin
    V = uncons(X),
    case V of
      {nothing} ->
        true;
      {just, _} ->
        false;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

nubBy() ->
  fun
    (P) ->
      nubBy(P)
  end.

nubBy(P) ->
  begin
    GoStep =
      fun
        (GoStep, Go) ->
          fun
            (V) ->
              fun
                (V1) ->
                  case V1 of
                    {nil} ->
                      {nil};
                    {cons, V1@1, V1@2} ->
                      begin
                        V2 = #{ result := V2@1 } =
                          data_list_internal@ps:insertAndLookupBy(P, V1@1, V),
                        if
                          erlang:map_get(found, V2) ->
                            data_lazy@foreign:force(((Go(GoStep, Go))(V2@1))
                                                    (V1@2));
                          true ->
                            {cons, V1@1, ((Go(GoStep, Go))(V2@1))(V1@2)}
                        end
                      end;
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
              end
          end
      end,
    Go =
      fun
        (GoStep@1, Go) ->
          fun
            (S) ->
              fun
                (V) ->
                  begin
                    V@1 = (GoStep@1(GoStep@1, Go))(S),
                    data_lazy@foreign:defer(fun
                      (_) ->
                        V@1(data_lazy@foreign:force(V))
                    end)
                  end
              end
          end
      end,
    GoStep(GoStep, Go),
    Go@1 = Go(GoStep, Go),
    Go@1({leaf})
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

mapMaybe() ->
  fun
    (F) ->
      mapMaybe(F)
  end.

mapMaybe(F) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {nil} ->
              {nil};
            {cons, V@1, V@2} ->
              begin
                V1 = F(V@1),
                case V1 of
                  {nothing} ->
                    Go(data_lazy@foreign:force(V@2));
                  {just, V1@1} ->
                    {cons, V1@1, (mapMaybe(F))(V@2)};
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    fun
      (X) ->
        data_lazy@foreign:defer(fun
          (_) ->
            Go(data_lazy@foreign:force(X))
        end)
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
     (data_list_lazy_types@ps:cons()))
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
  ((erlang:map_get(pure, DictAlternative@1(undefined)))
   (data_list_lazy_types@ps:nil())).

length() ->
  ((erlang:map_get(foldl, data_list_lazy_types@ps:foldableList()))
   (fun
     (L) ->
       fun
         (_) ->
           L + 1
       end
   end))
  (0).

'last.go'() ->
  fun
    (V) ->
      'last.go'(V)
  end.

'last.go'(V) ->
  case V of
    {cons, _, V@1} ->
      begin
        V@2 = uncons(V@1),
        case case V@2 of
            {nothing} ->
              true;
            {just, _} ->
              false;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end of
          true ->
            {just, erlang:element(2, V)};
          _ ->
            'last.go'(data_lazy@foreign:force(V@1))
        end
      end;
    _ ->
      {nothing}
  end.

last() ->
  fun
    (X) ->
      last(X)
  end.

last(X) ->
  'last.go'(data_lazy@foreign:force(X)).

iterate() ->
  fun
    (F) ->
      fun
        (X) ->
          iterate(F, X)
      end
  end.

iterate(F, X) ->
  begin
    Go =
      fun
        Go () ->
          data_lazy@foreign:defer(fun
            (_) ->
              data_lazy@foreign:force(begin
                V =
                  ((erlang:map_get(map, data_list_lazy_types@ps:functorList()))
                   (F))
                  (Go()),
                data_lazy@foreign:defer(fun
                  (_) ->
                    {cons, X, V}
                end)
              end)
          end)
      end,
    Go()
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
      data_lazy@foreign:defer(fun
        (_) ->
          {cons, V1, V2}
      end);
    true ->
      data_lazy@foreign:defer(fun
        (_) ->
          begin
            V@1 = data_lazy@foreign:force(V2),
            case V@1 of
              {nil} ->
                {cons, V1, data_list_lazy_types@ps:nil()};
              {cons, V@2, V@3} ->
                {cons, V@2, insertAt(V - 1, V1, V@3)};
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
          end
      end)
  end.

'init.go'() ->
  fun
    (V) ->
      'init.go'(V)
  end.

'init.go'(V) ->
  case V of
    {cons, _, V@1} ->
      begin
        V@2 = uncons(V@1),
        case case V@2 of
            {nothing} ->
              true;
            {just, _} ->
              false;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end of
          true ->
            {just, data_list_lazy_types@ps:nil()};
          _ ->
            begin
              {cons, _, V@3} = V,
              V@4 = 'init.go'(data_lazy@foreign:force(V@3)),
              case V@4 of
                {just, V@5} ->
                  begin
                    {cons, V@6, _} = V,
                    { just
                    , data_lazy@foreign:defer(fun
                        (_) ->
                          {cons, V@6, V@5}
                      end)
                    }
                  end;
                _ ->
                  {nothing}
              end
            end
        end
      end;
    _ ->
      {nothing}
  end.

init() ->
  fun
    (X) ->
      init(X)
  end.

init(X) ->
  'init.go'(data_lazy@foreign:force(X)).

index() ->
  fun
    (Xs) ->
      index(Xs)
  end.

index(Xs) ->
  begin
    Go =
      fun
        Go (V, V1) ->
          case V of
            {nil} ->
              {nothing};
            {cons, _, _} ->
              if
                V1 =:= 0 ->
                  {just, erlang:element(2, V)};
                true ->
                  begin
                    V@1 = data_lazy@foreign:force(erlang:element(3, V)),
                    V1@1 = V1 - 1,
                    Go(V@1, V1@1)
                  end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V = data_lazy@foreign:force(Xs),
    fun
      (V1) ->
        Go(V, V1)
    end
  end.

head() ->
  fun
    (Xs) ->
      head(Xs)
  end.

head(Xs) ->
  begin
    V = uncons(Xs),
    case V of
      {just, #{ head := V@1 }} ->
        {just, V@1};
      _ ->
        {nothing}
    end
  end.

transpose() ->
  fun
    (Xs) ->
      transpose(Xs)
  end.

transpose(Xs) ->
  begin
    V = uncons(Xs),
    case V of
      {nothing} ->
        Xs;
      {just, #{ head := V@1, tail := V@2 }} ->
        begin
          V1 = uncons(V@1),
          case V1 of
            {nothing} ->
              transpose(V@2);
            {just, #{ head := V1@1, tail := V1@2 }} ->
              begin
                V@3 = (mapMaybe(head()))(V@2),
                V@4 =
                  data_lazy@foreign:defer(fun
                    (_) ->
                      {cons, V1@1, V@3}
                  end),
                V@6 =
                  transpose(begin
                    V@5 = (mapMaybe(tail()))(V@2),
                    data_lazy@foreign:defer(fun
                      (_) ->
                        {cons, V1@2, V@5}
                    end)
                  end),
                data_lazy@foreign:defer(fun
                  (_) ->
                    {cons, V@4, V@6}
                end)
              end;
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
    (Eq) ->
      groupBy(Eq)
  end.

groupBy(Eq) ->
  (erlang:map_get(map, data_lazy@ps:functorLazy()))
  (fun
    (V) ->
      case V of
        {nil} ->
          {nil};
        {cons, V@1, V@2} ->
          begin
            #{ init := V1, rest := V1@1 } = span(Eq(V@1), V@2),
            { cons
            , data_lazy@foreign:defer(fun
                (_) ->
                  {nonEmpty, V@1, V1}
              end)
            , (groupBy(Eq))(V1@1)
            }
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end
  end).

group() ->
  fun
    (DictEq) ->
      group(DictEq)
  end.

group(#{ eq := DictEq }) ->
  groupBy(DictEq).

insertBy() ->
  fun
    (Cmp) ->
      fun
        (X) ->
          fun
            (Xs) ->
              insertBy(Cmp, X, Xs)
          end
      end
  end.

insertBy(Cmp, X, Xs) ->
  data_lazy@foreign:defer(fun
    (_) ->
      begin
        V = data_lazy@foreign:force(Xs),
        case V of
          {nil} ->
            {cons, X, data_list_lazy_types@ps:nil()};
          {cons, V@1, _} ->
            begin
              V@2 = (Cmp(X))(V@1),
              case ?IS_KNOWN_TAG(gT, 0, V@2) of
                true ->
                  {cons, V@1, insertBy(Cmp, X, erlang:element(3, V))};
                _ ->
                  { cons
                  , X
                  , data_lazy@foreign:defer(fun
                      (_) ->
                        V
                    end)
                  }
              end
            end;
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end).

insert() ->
  fun
    (DictOrd) ->
      insert(DictOrd)
  end.

insert(#{ compare := DictOrd }) ->
  (insertBy())(DictOrd).

fromFoldable() ->
  fun
    (DictFoldable) ->
      fromFoldable(DictFoldable)
  end.

fromFoldable(#{ foldr := DictFoldable }) ->
  (DictFoldable(data_list_lazy_types@ps:cons()))(data_list_lazy_types@ps:nil()).

foldrLazy() ->
  fun
    (DictLazy) ->
      fun
        (Op) ->
          fun
            (Z) ->
              foldrLazy(DictLazy, Op, Z)
          end
      end
  end.

foldrLazy(DictLazy, Op, Z) ->
  begin
    Go =
      fun
        Go (Xs) ->
          begin
            V = data_lazy@foreign:force(Xs),
            case V of
              {cons, V@1, V@2} ->
                begin
                  #{ defer := DictLazy@1 } = DictLazy,
                  DictLazy@1(fun
                    (_) ->
                      (Op(V@1))(Go(V@2))
                  end)
                end;
              {nil} ->
                Z;
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
          end
      end,
    Go
  end.

foldM() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (B) ->
              fun
                (Xs) ->
                  foldM(DictMonad, F, B, Xs)
              end
          end
      end
  end.

foldM(DictMonad, F, B, Xs) ->
  begin
    V = uncons(Xs),
    case V of
      {nothing} ->
        (erlang:map_get(
           pure,
           (erlang:map_get('Applicative0', DictMonad))(undefined)
         ))
        (B);
      {just, #{ head := V@1, tail := V@2 }} ->
        ((erlang:map_get(bind, (erlang:map_get('Bind1', DictMonad))(undefined)))
         ((F(B))(V@1)))
        (fun
          (B_) ->
            foldM(DictMonad, F, B_, V@2)
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
        Go (N, List) ->
          begin
            V = uncons(List),
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
      (List) ->
        Go(N, List)
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
    V = (findIndex(Fn))(reverse(Xs)),
    case V of
      {just, V@1} ->
        {just, (((length())(Xs)) - 1) - V@1};
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
          (List) ->
            begin
              V@2 = uncons(List),
              case V@2 of
                {nothing} ->
                  V(data_list_lazy_types@ps:nil());
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
                                data_lazy@foreign:defer(fun
                                  (_) ->
                                    {cons, V@3, Xs_}
                                end);
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

filter() ->
  fun
    (P) ->
      filter(P)
  end.

filter(P) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {nil} ->
              {nil};
            {cons, V@1, V@2} ->
              case P(V@1) of
                true ->
                  {cons, V@1, (filter(P))(V@2)};
                _ ->
                  Go(data_lazy@foreign:force(V@2))
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    fun
      (X) ->
        data_lazy@foreign:defer(fun
          (_) ->
            Go(data_lazy@foreign:force(X))
        end)
    end
  end.

intersectBy() ->
  fun
    (Eq) ->
      fun
        (Xs) ->
          fun
            (Ys) ->
              intersectBy(Eq, Xs, Ys)
          end
      end
  end.

intersectBy(Eq, Xs, Ys) ->
  (filter(fun
     (X) ->
       ((any())(Eq(X)))(Ys)
   end))
  (Xs).

intersect() ->
  fun
    (DictEq) ->
      intersect(DictEq)
  end.

intersect(#{ eq := DictEq }) ->
  (intersectBy())(DictEq).

nubByEq() ->
  fun
    (Eq) ->
      nubByEq(Eq)
  end.

nubByEq(Eq) ->
  (erlang:map_get(map, data_lazy@ps:functorLazy()))
  (fun
    (V) ->
      case V of
        {nil} ->
          {nil};
        {cons, V@1, V@2} ->
          { cons
          , V@1
          , (nubByEq(Eq))
            ((filter(fun
                (Y) ->
                  not ((Eq(V@1))(Y))
              end))
             (V@2))
          };
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end
  end).

nubEq() ->
  fun
    (DictEq) ->
      nubEq(DictEq)
  end.

nubEq(#{ eq := DictEq }) ->
  nubByEq(DictEq).

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
             (((erlang:map_get(eq1, data_list_lazy_types@ps:eq1List()))(DictEq))
              (X))
             (Y)
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
                 (((erlang:map_get(eq1, data_list_lazy_types@ps:eq1List()))(V))
                  (X))
                 (Y)
             end
         end
       },
    #{ compare =>
       fun
         (X) ->
           fun
             (Y) ->
               ((erlang:map_get(
                   compare,
                   data_list_lazy_types@ps:ordList(DictOrd)
                 ))
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
          case ?IS_KNOWN_TAG(cons, 2, V) andalso (P(erlang:element(2, V))) of
            true ->
              begin
                {cons, _, V@1} = V,
                Go(data_lazy@foreign:force(V@1))
              end;
            _ ->
              data_lazy@foreign:defer(fun
                (_) ->
                  V
              end)
          end
      end,
    fun
      (X) ->
        Go(data_lazy@foreign:force(X))
    end
  end.

drop() ->
  fun
    (N) ->
      drop(N)
  end.

drop(N) ->
  begin
    Go =
      fun
        Go (V, V1) ->
          if
            V =:= 0 ->
              V1;
            ?IS_KNOWN_TAG(nil, 0, V1) ->
              {nil};
            ?IS_KNOWN_TAG(cons, 2, V1) ->
              begin
                {cons, _, V1@1} = V1,
                V@1 = V - 1,
                V1@2 = data_lazy@foreign:force(V1@1),
                Go(V@1, V1@2)
              end;
            true ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    (erlang:map_get(map, data_lazy@ps:functorLazy()))
    (fun
      (V1) ->
        Go(N, V1)
    end)
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
  (take(End - Start))((drop(Start))(Xs)).

deleteBy() ->
  fun
    (Eq) ->
      fun
        (X) ->
          fun
            (Xs) ->
              deleteBy(Eq, X, Xs)
          end
      end
  end.

deleteBy(Eq, X, Xs) ->
  data_lazy@foreign:defer(fun
    (_) ->
      begin
        V = data_lazy@foreign:force(Xs),
        case V of
          {nil} ->
            {nil};
          {cons, V@1, V@2} ->
            case (Eq(X))(V@1) of
              true ->
                data_lazy@foreign:force(V@2);
              _ ->
                {cons, V@1, deleteBy(Eq, X, V@2)}
            end;
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end).

unionBy() ->
  fun
    (Eq) ->
      fun
        (Xs) ->
          fun
            (Ys) ->
              unionBy(Eq, Xs, Ys)
          end
      end
  end.

unionBy(Eq, Xs, Ys) ->
  ((erlang:map_get(append, data_list_lazy_types@ps:semigroupList()))(Xs))
  ((((erlang:map_get(foldl, data_list_lazy_types@ps:foldableList()))
     (fun
       (B) ->
         fun
           (A) ->
             deleteBy(Eq, A, B)
         end
     end))
    ((nubByEq(Eq))(Ys)))
   (Xs)).

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
        (Xs) ->
          deleteAt(N, Xs)
      end
  end.

deleteAt(N, Xs) ->
  data_lazy@foreign:defer(fun
    (_) ->
      begin
        V = data_lazy@foreign:force(Xs),
        case V of
          {nil} ->
            {nil};
          {cons, _, V@1} ->
            if
              N =:= 0 ->
                data_lazy@foreign:force(V@1);
              true ->
                {cons, erlang:element(2, V), deleteAt(N - 1, V@1)}
            end;
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end).

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
  (erlang:map_get(foldl, data_list_lazy_types@ps:foldableList()))
  (fun
    (B) ->
      fun
        (A) ->
          deleteBy(DictEq, A, B)
      end
  end).

cycle() ->
  fun
    (Xs) ->
      cycle(Xs)
  end.

cycle(Xs) ->
  begin
    Go =
      fun
        Go () ->
          data_lazy@foreign:defer(fun
            (_) ->
              data_lazy@foreign:force(((erlang:map_get(
                                          append,
                                          data_list_lazy_types@ps:semigroupList()
                                        ))
                                       (Xs))
                                      (Go()))
          end)
      end,
    Go()
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
  ((erlang:map_get(bind, data_list_lazy_types@ps:bindList()))(A))(B).

concat() ->
  fun
    (V) ->
      concat(V)
  end.

concat(V) ->
  ((erlang:map_get(bind, data_list_lazy_types@ps:bindList()))(V))(identity()).

catMaybes() ->
  mapMaybe(identity()).

alterAt() ->
  fun
    (N) ->
      fun
        (F) ->
          fun
            (Xs) ->
              alterAt(N, F, Xs)
          end
      end
  end.

alterAt(N, F, Xs) ->
  data_lazy@foreign:defer(fun
    (_) ->
      begin
        V = data_lazy@foreign:force(Xs),
        case V of
          {nil} ->
            {nil};
          {cons, V@1, V@2} ->
            if
              N =:= 0 ->
                begin
                  V2 = F(V@1),
                  case V2 of
                    {nothing} ->
                      data_lazy@foreign:force(V@2);
                    {just, V2@1} ->
                      {cons, V2@1, V@2};
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
                end;
              true ->
                {cons, V@1, alterAt(N - 1, F, V@2)}
            end;
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end).

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

zip(V, V@1) ->
  zipWith(data_tuple@ps:'Tuple'(), V, V@1).

