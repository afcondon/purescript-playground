-module(data_list_lazy_nonEmpty@ps).
-export([ uncons/0
        , uncons/1
        , toList/0
        , toList/1
        , toUnfoldable/0
        , toUnfoldable/1
        , tail/0
        , tail/1
        , singleton/0
        , repeat/0
        , repeat/1
        , length/0
        , length/1
        , last/0
        , last/1
        , iterate/0
        , iterate/2
        , init/0
        , init/1
        , head/0
        , head/1
        , fromList/0
        , fromList/1
        , fromFoldable/0
        , fromFoldable/1
        , concatMap/0
        , concatMap/2
        , appendFoldable/0
        , appendFoldable/1
        ]).
-compile(no_auto_import).
uncons() ->
  fun
    (V) ->
      uncons(V)
  end.

uncons(V) ->
  begin
    V1 = data_lazy@foreign:force(V),
    #{ head => erlang:element(2, V1), tail => erlang:element(3, V1) }
  end.

toList() ->
  fun
    (V) ->
      toList(V)
  end.

toList(V) ->
  begin
    V1 = data_lazy@foreign:force(V),
    V@1 = erlang:element(2, V1),
    V@2 = erlang:element(3, V1),
    data_lazy@foreign:defer(fun
      (_) ->
        {cons, V@1, V@2}
    end)
  end.

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
            V = data_list_lazy@ps:uncons(Xs),
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
        V(toList(X))
    end
  end.

tail() ->
  fun
    (V) ->
      tail(V)
  end.

tail(V) ->
  erlang:element(3, data_lazy@foreign:force(V)).

singleton() ->
  erlang:map_get(pure, data_list_lazy_types@ps:applicativeNonEmptyList()).

repeat() ->
  fun
    (X) ->
      repeat(X)
  end.

repeat(X) ->
  data_lazy@foreign:defer(fun
    (_) ->
      {nonEmpty, X, data_list_lazy@ps:repeat(X)}
  end).

length() ->
  fun
    (V) ->
      length(V)
  end.

length(V) ->
  1
    + ((data_list_lazy@ps:length())
       (erlang:element(3, data_lazy@foreign:force(V)))).

last() ->
  fun
    (V) ->
      last(V)
  end.

last(V) ->
  begin
    V1 = data_lazy@foreign:force(V),
    V@1 =
      data_list_lazy@ps:'last.go'(data_lazy@foreign:force(erlang:element(3, V1))),
    case V@1 of
      {nothing} ->
        erlang:element(2, V1);
      {just, V@2} ->
        V@2;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

iterate() ->
  fun
    (F) ->
      fun
        (X) ->
          iterate(F, X)
      end
  end.

iterate(F, X) ->
  data_lazy@foreign:defer(fun
    (_) ->
      {nonEmpty, X, data_list_lazy@ps:iterate(F, F(X))}
  end).

init() ->
  fun
    (V) ->
      init(V)
  end.

init(V) ->
  begin
    V1 = data_lazy@foreign:force(V),
    V@1 =
      data_list_lazy@ps:'init.go'(data_lazy@foreign:force(erlang:element(3, V1))),
    case V@1 of
      {nothing} ->
        data_list_lazy_types@ps:nil();
      {just, V@2} ->
        data_lazy@foreign:defer(fun
          (_) ->
            {cons, erlang:element(2, V1), V@2}
        end);
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

head() ->
  fun
    (V) ->
      head(V)
  end.

head(V) ->
  erlang:element(2, data_lazy@foreign:force(V)).

fromList() ->
  fun
    (L) ->
      fromList(L)
  end.

fromList(L) ->
  begin
    V = data_lazy@foreign:force(L),
    case V of
      {nil} ->
        {nothing};
      {cons, V@1, V@2} ->
        { just
        , data_lazy@foreign:defer(fun
            (_) ->
              {nonEmpty, V@1, V@2}
          end)
        };
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
    V =
      (DictFoldable(data_list_lazy_types@ps:cons()))
      (data_list_lazy_types@ps:nil()),
    fun
      (X) ->
        fromList(V(X))
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
  ((erlang:map_get(bind, data_list_lazy_types@ps:bindNonEmptyList()))(A))(B).

appendFoldable() ->
  fun
    (DictFoldable) ->
      appendFoldable(DictFoldable)
  end.

appendFoldable(#{ foldr := DictFoldable }) ->
  begin
    FromFoldable1 =
      (DictFoldable(data_list_lazy_types@ps:cons()))
      (data_list_lazy_types@ps:nil()),
    fun
      (Nel) ->
        fun
          (Ys) ->
            data_lazy@foreign:defer(fun
              (_) ->
                { nonEmpty
                , erlang:element(2, data_lazy@foreign:force(Nel))
                , ((erlang:map_get(
                      append,
                      data_list_lazy_types@ps:semigroupList()
                    ))
                   (erlang:element(3, data_lazy@foreign:force(Nel))))
                  (FromFoldable1(Ys))
                }
            end)
        end
    end
  end.

