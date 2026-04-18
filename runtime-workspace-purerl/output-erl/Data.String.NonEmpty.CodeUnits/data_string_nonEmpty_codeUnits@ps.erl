-module(data_string_nonEmpty_codeUnits@ps).
-export([ snoc/0
        , snoc/2
        , singleton/0
        , singleton/1
        , takeWhile/0
        , takeWhile/2
        , 'lastIndexOf\''/0
        , 'lastIndexOf\''/1
        , lastIndexOf/0
        , lastIndexOf/1
        , 'indexOf\''/0
        , 'indexOf\''/1
        , indexOf/0
        , indexOf/1
        , length/0
        , length/1
        , splitAt/0
        , splitAt/2
        , take/0
        , take/2
        , takeRight/0
        , takeRight/2
        , toChar/0
        , toChar/1
        , toCharArray/0
        , toCharArray/1
        , toNonEmptyCharArray/0
        , toNonEmptyCharArray/1
        , uncons/0
        , uncons/1
        , fromFoldable1/0
        , fromFoldable1/1
        , fromCharArray/0
        , fromCharArray/1
        , fromNonEmptyCharArray/0
        , fromNonEmptyCharArray/1
        , dropWhile/0
        , dropWhile/2
        , dropRight/0
        , dropRight/2
        , drop/0
        , drop/2
        , countPrefix/0
        , countPrefix/1
        , cons/0
        , cons/2
        , charAt/0
        , charAt/1
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
  <<S/binary, (data_string_codeUnits@foreign:singleton(C))/binary>>.

singleton() ->
  fun
    (X) ->
      singleton(X)
  end.

singleton(X) ->
  data_string_codeUnits@foreign:singleton(X).

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
      data_string_codeUnits@foreign:take(
        data_string_codeUnits@foreign:countPrefix(F, X),
        X
      ),
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
      'lastIndexOf\''(Pat)
  end.

'lastIndexOf\''(Pat) ->
  (data_string_codeUnits@ps:'lastIndexOf\''())(Pat).

lastIndexOf() ->
  fun
    (X) ->
      lastIndexOf(X)
  end.

lastIndexOf(X) ->
  (data_string_codeUnits@ps:lastIndexOf())(X).

'indexOf\''() ->
  fun
    (Pat) ->
      'indexOf\''(Pat)
  end.

'indexOf\''(Pat) ->
  (data_string_codeUnits@ps:'indexOf\''())(Pat).

indexOf() ->
  fun
    (X) ->
      indexOf(X)
  end.

indexOf(X) ->
  (data_string_codeUnits@ps:indexOf())(X).

length() ->
  fun
    (X) ->
      length(X)
  end.

length(X) ->
  data_string_codeUnits@foreign:length(X).

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
    #{ 'after' := V, before := V@1 } =
      data_string_codeUnits@foreign:splitAt(I, Nes),
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
      {just, data_string_codeUnits@foreign:take(I, Nes)}
  end.

takeRight() ->
  fun
    (I) ->
      fun
        (Nes) ->
          takeRight(I, Nes)
      end
  end.

takeRight(I, Nes) ->
  if
    I < 1 ->
      {nothing};
    true ->
      { just
      , data_string_codeUnits@foreign:drop(
          (data_string_codeUnits@foreign:length(Nes)) - I,
          Nes
        )
      }
  end.

toChar() ->
  fun
    (X) ->
      toChar(X)
  end.

toChar(X) ->
  data_string_codeUnits@ps:toChar(X).

toCharArray() ->
  fun
    (X) ->
      toCharArray(X)
  end.

toCharArray(X) ->
  data_string_codeUnits@foreign:toCharArray(X).

toNonEmptyCharArray() ->
  fun
    (X) ->
      toNonEmptyCharArray(X)
  end.

toNonEmptyCharArray(X) ->
  begin
    V = data_string_codeUnits@foreign:toCharArray(X),
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
  #{ head => data_string_unsafe@foreign:charAt(0, Nes)
   , tail =>
     begin
       V = data_string_codeUnits@foreign:drop(1, Nes),
       if
         V =:= <<"">> ->
           {nothing};
         true ->
           {just, V}
       end
     end
   }.

fromFoldable1() ->
  fun
    (DictFoldable1) ->
      fromFoldable1(DictFoldable1)
  end.

fromFoldable1(#{ foldMap1 := DictFoldable1 }) ->
  (DictFoldable1(data_semigroup@ps:semigroupString()))
  (fun
    (X) ->
      data_string_codeUnits@foreign:singleton(X)
  end).

fromCharArray() ->
  fun
    (V) ->
      fromCharArray(V)
  end.

fromCharArray(V) ->
  case (array:size(V)) =:= 0 of
    true ->
      {nothing};
    _ ->
      {just, data_string_codeUnits@foreign:fromCharArray(V)}
  end.

fromNonEmptyCharArray() ->
  fun
    (X) ->
      fromNonEmptyCharArray(X)
  end.

fromNonEmptyCharArray(X) ->
  case (array:size(X)) =:= 0 of
    true ->
      erlang:error({fail, <<"Failed pattern match">>});
    _ ->
      data_string_codeUnits@foreign:fromCharArray(X)
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
    V =
      data_string_codeUnits@foreign:drop(
        data_string_codeUnits@foreign:countPrefix(F, X),
        X
      ),
    if
      V =:= <<"">> ->
        {nothing};
      true ->
        {just, V}
    end
  end.

dropRight() ->
  fun
    (I) ->
      fun
        (Nes) ->
          dropRight(I, Nes)
      end
  end.

dropRight(I, Nes) ->
  case I >= (data_string_codeUnits@foreign:length(Nes)) of
    true ->
      {nothing};
    _ ->
      { just
      , data_string_codeUnits@foreign:take(
          (data_string_codeUnits@foreign:length(Nes)) - I,
          Nes
        )
      }
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
  case I >= (data_string_codeUnits@foreign:length(Nes)) of
    true ->
      {nothing};
    _ ->
      {just, data_string_codeUnits@foreign:drop(I, Nes)}
  end.

countPrefix() ->
  fun
    (X) ->
      countPrefix(X)
  end.

countPrefix(X) ->
  (data_string_codeUnits@ps:countPrefix())(X).

cons() ->
  fun
    (C) ->
      fun
        (S) ->
          cons(C, S)
      end
  end.

cons(C, S) ->
  <<(data_string_codeUnits@foreign:singleton(C))/binary, S/binary>>.

charAt() ->
  fun
    (X) ->
      charAt(X)
  end.

charAt(X) ->
  (data_string_codeUnits@ps:charAt())(X).

