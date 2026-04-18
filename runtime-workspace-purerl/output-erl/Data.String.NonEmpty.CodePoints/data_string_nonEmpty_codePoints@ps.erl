-module(data_string_nonEmpty_codePoints@ps).
-export([ snoc/0
        , snoc/2
        , singleton/0
        , singleton/1
        , takeWhile/0
        , takeWhile/2
        , 'lastIndexOf\''/0
        , 'lastIndexOf\''/3
        , lastIndexOf/0
        , lastIndexOf/2
        , 'indexOf\''/0
        , 'indexOf\''/3
        , indexOf/0
        , indexOf/2
        , length/0
        , length/1
        , splitAt/0
        , splitAt/2
        , take/0
        , take/2
        , toCodePointArray/0
        , toCodePointArray/1
        , toNonEmptyCodePointArray/0
        , toNonEmptyCodePointArray/1
        , uncons/0
        , uncons/1
        , fromFoldable1/0
        , fromFoldable1/1
        , fromCodePointArray/0
        , fromCodePointArray/1
        , fromNonEmptyCodePointArray/0
        , fromNonEmptyCodePointArray/1
        , dropWhile/0
        , dropWhile/2
        , drop/0
        , drop/2
        , countPrefix/0
        , countPrefix/1
        , cons/0
        , cons/2
        , codePointAt/0
        , codePointAt/2
        ]).
-compile(no_auto_import).
snoc() ->
  fun
    (C) ->
      fun
        (S) ->
          snoc(C, S)
      end
  end.

snoc(C, S) ->
  <<S/binary, ((data_string_codePoints@ps:singleton())(C))/binary>>.

singleton() ->
  fun
    (X) ->
      singleton(X)
  end.

singleton(X) ->
  (data_string_codePoints@ps:singleton())(X).

takeWhile() ->
  fun
    (F) ->
      fun
        (X) ->
          takeWhile(F, X)
      end
  end.

takeWhile(F, X) ->
  begin
    V =
      ((data_string_codePoints@ps:take())
       (((data_string_codePoints@ps:countPrefix())(F))(X)))
      (X),
    if
      V =:= <<"">> ->
        {nothing};
      true ->
        {just, V}
    end
  end.

'lastIndexOf\''() ->
  fun
    (Pat) ->
      fun
        (X) ->
          fun
            (V) ->
              'lastIndexOf\''(Pat, X, V)
          end
      end
  end.

'lastIndexOf\''(Pat, X, V) ->
  data_string_codePoints@ps:'lastIndexOf\''(Pat, X, V).

lastIndexOf() ->
  fun
    (X) ->
      fun
        (V) ->
          lastIndexOf(X, V)
      end
  end.

lastIndexOf(X, V) ->
  data_string_codePoints@ps:lastIndexOf(X, V).

'indexOf\''() ->
  fun
    (Pat) ->
      fun
        (X) ->
          fun
            (V) ->
              'indexOf\''(Pat, X, V)
          end
      end
  end.

'indexOf\''(Pat, X, V) ->
  data_string_codePoints@ps:'indexOf\''(Pat, X, V).

indexOf() ->
  fun
    (X) ->
      fun
        (V) ->
          indexOf(X, V)
      end
  end.

indexOf(X, V) ->
  data_string_codePoints@ps:indexOf(X, V).

length() ->
  fun
    (X) ->
      length(X)
  end.

length(X) ->
  array:size((data_string_codePoints@ps:toCodePointArray())(X)).

splitAt() ->
  fun
    (I) ->
      fun
        (Nes) ->
          splitAt(I, Nes)
      end
  end.

splitAt(I, Nes) ->
  begin
    #{ 'after' := V, before := V@1 } = data_string_codePoints@ps:splitAt(I, Nes),
    #{ before =>
       if
         V@1 =:= <<"">> ->
           {nothing};
         true ->
           {just, V@1}
       end
     , 'after' =>
       if
         V =:= <<"">> ->
           {nothing};
         true ->
           {just, V}
       end
     }
  end.

take() ->
  fun
    (I) ->
      fun
        (Nes) ->
          take(I, Nes)
      end
  end.

take(I, Nes) ->
  if
    I < 1 ->
      {nothing};
    true ->
      {just, ((data_string_codePoints@ps:take())(I))(Nes)}
  end.

toCodePointArray() ->
  fun
    (X) ->
      toCodePointArray(X)
  end.

toCodePointArray(X) ->
  (data_string_codePoints@ps:toCodePointArray())(X).

toNonEmptyCodePointArray() ->
  fun
    (X) ->
      toNonEmptyCodePointArray(X)
  end.

toNonEmptyCodePointArray(X) ->
  begin
    V = (data_string_codePoints@ps:toCodePointArray())(X),
    case (array:size(V)) > 0 of
      true ->
        V;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

uncons() ->
  fun
    (Nes) ->
      uncons(Nes)
  end.

uncons(Nes) ->
  #{ head =>
     begin
       V = {just, V@1} = data_string_codePoints@ps:codePointAt(0, Nes),
       case V of
         {just, _} ->
           V@1;
         _ ->
           erlang:error({fail, <<"Failed pattern match">>})
       end
     end
   , tail =>
     begin
       V@2 =
         data_string_codeUnits@foreign:drop(
           data_string_codeUnits@foreign:length(((data_string_codePoints@ps:take())
                                                 (1))
                                                (Nes)),
           Nes
         ),
       if
         V@2 =:= <<"">> ->
           {nothing};
         true ->
           {just, V@2}
       end
     end
   }.

fromFoldable1() ->
  fun
    (DictFoldable1) ->
      fromFoldable1(DictFoldable1)
  end.

fromFoldable1(#{ foldMap1 := DictFoldable1 }) ->
  (DictFoldable1(data_semigroup@ps:semigroupString()))(singleton()).

fromCodePointArray() ->
  fun
    (V) ->
      fromCodePointArray(V)
  end.

fromCodePointArray(V) ->
  case (array:size(V)) =:= 0 of
    true ->
      {nothing};
    _ ->
      {just, data_string_codePoints@ps:fromCodePointArray(V)}
  end.

fromNonEmptyCodePointArray() ->
  fun
    (X) ->
      fromNonEmptyCodePointArray(X)
  end.

fromNonEmptyCodePointArray(X) ->
  case (array:size(X)) =:= 0 of
    true ->
      erlang:error({fail, <<"Failed pattern match">>});
    _ ->
      data_string_codePoints@ps:fromCodePointArray(X)
  end.

dropWhile() ->
  fun
    (F) ->
      fun
        (X) ->
          dropWhile(F, X)
      end
  end.

dropWhile(F, X) ->
  begin
    V = data_string_codePoints@ps:dropWhile(F, X),
    if
      V =:= <<"">> ->
        {nothing};
      true ->
        {just, V}
    end
  end.

drop() ->
  fun
    (I) ->
      fun
        (Nes) ->
          drop(I, Nes)
      end
  end.

drop(I, Nes) ->
  case I >= (array:size((data_string_codePoints@ps:toCodePointArray())(Nes))) of
    true ->
      {nothing};
    _ ->
      { just
      , data_string_codeUnits@foreign:drop(
          data_string_codeUnits@foreign:length(((data_string_codePoints@ps:take())
                                                (I))
                                               (Nes)),
          Nes
        )
      }
  end.

countPrefix() ->
  fun
    (X) ->
      countPrefix(X)
  end.

countPrefix(X) ->
  (data_string_codePoints@ps:countPrefix())(X).

cons() ->
  fun
    (C) ->
      fun
        (S) ->
          cons(C, S)
      end
  end.

cons(C, S) ->
  <<((data_string_codePoints@ps:singleton())(C))/binary, S/binary>>.

codePointAt() ->
  fun
    (X) ->
      fun
        (V) ->
          codePointAt(X, V)
      end
  end.

codePointAt(X, V) ->
  data_string_codePoints@ps:codePointAt(X, V).

