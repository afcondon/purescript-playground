-module(data_string_codeUnits@ps).
-export([ uncons/0
        , uncons/1
        , toChar/0
        , takeWhile/0
        , takeWhile/2
        , takeRight/0
        , takeRight/2
        , stripSuffix/0
        , stripSuffix/2
        , stripPrefix/0
        , stripPrefix/2
        , slice/0
        , slice/3
        , 'lastIndexOf\''/0
        , lastIndexOf/0
        , 'indexOf\''/0
        , indexOf/0
        , dropWhile/0
        , dropWhile/2
        , dropRight/0
        , dropRight/2
        , contains/0
        , contains/1
        , charAt/0
        , fromCharArray/0
        , toCharArray/0
        , singleton/0
        , '_charAt'/0
        , '_toChar'/0
        , length/0
        , '_indexOf'/0
        , '_indexOfStartingAt'/0
        , '_lastIndexOf'/0
        , '_lastIndexOfStartingAt'/0
        , take/0
        , drop/0
        , countPrefix/0
        , '_slice'/0
        , splitAt/0
        , toChar/1
        , 'lastIndexOf\''/3
        , lastIndexOf/2
        , 'indexOf\''/3
        , indexOf/2
        , charAt/2
        ]).
-compile(no_auto_import).
uncons() ->
  fun
    (V) ->
      uncons(V)
  end.

uncons(V) ->
  if
    V =:= <<"">> ->
      {nothing};
    true ->
      { just
      , #{ head => data_string_unsafe@foreign:charAt(0, V)
         , tail => data_string_codeUnits@foreign:drop(1, V)
         }
      }
  end.

toChar() ->
  (('_toChar'())(data_maybe@ps:'Just'()))({nothing}).

takeWhile() ->
  fun
    (P) ->
      fun
        (S) ->
          takeWhile(P, S)
      end
  end.

takeWhile(P, S) ->
  data_string_codeUnits@foreign:take(
    data_string_codeUnits@foreign:countPrefix(P, S),
    S
  ).

takeRight() ->
  fun
    (I) ->
      fun
        (S) ->
          takeRight(I, S)
      end
  end.

takeRight(I, S) ->
  data_string_codeUnits@foreign:drop(
    (data_string_codeUnits@foreign:length(S)) - I,
    S
  ).

stripSuffix() ->
  fun
    (V) ->
      fun
        (Str) ->
          stripSuffix(V, Str)
      end
  end.

stripSuffix(V, Str) ->
  begin
    V1 =
      data_string_codeUnits@foreign:splitAt(
        (data_string_codeUnits@foreign:length(Str))
          - (data_string_codeUnits@foreign:length(V)),
        Str
      ),
    if
      (erlang:map_get('after', V1)) =:= V ->
        begin
          #{ before := V1@1 } = V1,
          {just, V1@1}
        end;
      true ->
        {nothing}
    end
  end.

stripPrefix() ->
  fun
    (V) ->
      fun
        (Str) ->
          stripPrefix(V, Str)
      end
  end.

stripPrefix(V, Str) ->
  begin
    V1 =
      data_string_codeUnits@foreign:splitAt(
        data_string_codeUnits@foreign:length(V),
        Str
      ),
    if
      (erlang:map_get(before, V1)) =:= V ->
        begin
          #{ 'after' := V1@1 } = V1,
          {just, V1@1}
        end;
      true ->
        {nothing}
    end
  end.

slice() ->
  fun
    (B) ->
      fun
        (E) ->
          fun
            (S) ->
              slice(B, E, S)
          end
      end
  end.

slice(B, E, S) ->
  begin
    L = data_string_codeUnits@foreign:length(S),
    E_ =
      if
        E < 0 ->
          L + E;
        true ->
          E
      end,
    B_ =
      if
        B < 0 ->
          L + B;
        true ->
          B
      end,
    if
      (B_ < 0)
        orelse ((B_ >= L) orelse ((E_ < 0) orelse ((E_ > L) orelse (B_ > E_)))) ->
        {nothing};
      true ->
        {just, data_string_codeUnits@foreign:'_slice'(B, E, S)}
    end
  end.

'lastIndexOf\''() ->
  (('_lastIndexOfStartingAt'())(data_maybe@ps:'Just'()))({nothing}).

lastIndexOf() ->
  (('_lastIndexOf'())(data_maybe@ps:'Just'()))({nothing}).

'indexOf\''() ->
  (('_indexOfStartingAt'())(data_maybe@ps:'Just'()))({nothing}).

indexOf() ->
  (('_indexOf'())(data_maybe@ps:'Just'()))({nothing}).

dropWhile() ->
  fun
    (P) ->
      fun
        (S) ->
          dropWhile(P, S)
      end
  end.

dropWhile(P, S) ->
  data_string_codeUnits@foreign:drop(
    data_string_codeUnits@foreign:countPrefix(P, S),
    S
  ).

dropRight() ->
  fun
    (I) ->
      fun
        (S) ->
          dropRight(I, S)
      end
  end.

dropRight(I, S) ->
  data_string_codeUnits@foreign:take(
    (data_string_codeUnits@foreign:length(S)) - I,
    S
  ).

contains() ->
  fun
    (Pat) ->
      contains(Pat)
  end.

contains(Pat) ->
  begin
    V = (indexOf())(Pat),
    fun
      (X) ->
        begin
          V@1 = V(X),
          case V@1 of
            {nothing} ->
              false;
            {just, _} ->
              true;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
        end
    end
  end.

charAt() ->
  (('_charAt'())(data_maybe@ps:'Just'()))({nothing}).

fromCharArray() ->
  fun
    (V) ->
      data_string_codeUnits@foreign:fromCharArray(V)
  end.

toCharArray() ->
  fun
    (V) ->
      data_string_codeUnits@foreign:toCharArray(V)
  end.

singleton() ->
  fun
    (V) ->
      data_string_codeUnits@foreign:singleton(V)
  end.

'_charAt'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_string_codeUnits@foreign:'_charAt'(V, V@1, V@2, V@3)
              end
          end
      end
  end.

'_toChar'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_string_codeUnits@foreign:'_toChar'(V, V@1, V@2)
          end
      end
  end.

length() ->
  fun
    (V) ->
      data_string_codeUnits@foreign:length(V)
  end.

'_indexOf'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_string_codeUnits@foreign:'_indexOf'(V, V@1, V@2, V@3)
              end
          end
      end
  end.

'_indexOfStartingAt'() ->
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
                      data_string_codeUnits@foreign:'_indexOfStartingAt'(
                        V,
                        V@1,
                        V@2,
                        V@3,
                        V@4
                      )
                  end
              end
          end
      end
  end.

'_lastIndexOf'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_string_codeUnits@foreign:'_lastIndexOf'(V, V@1, V@2, V@3)
              end
          end
      end
  end.

'_lastIndexOfStartingAt'() ->
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
                      data_string_codeUnits@foreign:'_lastIndexOfStartingAt'(
                        V,
                        V@1,
                        V@2,
                        V@3,
                        V@4
                      )
                  end
              end
          end
      end
  end.

take() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_codeUnits@foreign:take(V, V@1)
      end
  end.

drop() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_codeUnits@foreign:drop(V, V@1)
      end
  end.

countPrefix() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_codeUnits@foreign:countPrefix(V, V@1)
      end
  end.

'_slice'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_string_codeUnits@foreign:'_slice'(V, V@1, V@2)
          end
      end
  end.

splitAt() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_codeUnits@foreign:splitAt(V, V@1)
      end
  end.

toChar(V) ->
  data_string_codeUnits@foreign:'_toChar'(data_maybe@ps:'Just'(), {nothing}, V).

'lastIndexOf\''(V, V@1, V@2) ->
  data_string_codeUnits@foreign:'_lastIndexOfStartingAt'(
    data_maybe@ps:'Just'(),
    {nothing},
    V,
    V@1,
    V@2
  ).

lastIndexOf(V, V@1) ->
  data_string_codeUnits@foreign:'_lastIndexOf'(
    data_maybe@ps:'Just'(),
    {nothing},
    V,
    V@1
  ).

'indexOf\''(V, V@1, V@2) ->
  data_string_codeUnits@foreign:'_indexOfStartingAt'(
    data_maybe@ps:'Just'(),
    {nothing},
    V,
    V@1,
    V@2
  ).

indexOf(V, V@1) ->
  data_string_codeUnits@foreign:'_indexOf'(
    data_maybe@ps:'Just'(),
    {nothing},
    V,
    V@1
  ).

charAt(V, V@1) ->
  data_string_codeUnits@foreign:'_charAt'(
    data_maybe@ps:'Just'(),
    {nothing},
    V,
    V@1
  ).

