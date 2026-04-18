-module(data_number_format@ps).
-export([ clamp/0
        , clamp/3
        , 'Precision'/0
        , 'Fixed'/0
        , 'Exponential'/0
        , toStringWith/0
        , toStringWith/1
        , precision/0
        , precision/1
        , fixed/0
        , fixed/1
        , exponential/0
        , exponential/1
        , toPrecisionNative/0
        , toFixedNative/0
        , toExponentialNative/0
        , toString/0
        ]).
-compile(no_auto_import).
clamp() ->
  fun
    (Low) ->
      fun
        (Hi) ->
          fun
            (X) ->
              clamp(Low, Hi, X)
          end
      end
  end.

clamp(Low, Hi, X) ->
  begin
    V = data_ord@ps:ordInt(),
    V@1 = ((erlang:map_get(compare, V))(Low))(X),
    V@2 =
      case V@1 of
        {lT} ->
          X;
        {eQ} ->
          Low;
        {gT} ->
          Low;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end,
    V@3 = ((erlang:map_get(compare, V))(Hi))(V@2),
    case V@3 of
      {lT} ->
        Hi;
      {eQ} ->
        Hi;
      {gT} ->
        V@2;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

'Precision'() ->
  fun
    (Value0) ->
      {precision, Value0}
  end.

'Fixed'() ->
  fun
    (Value0) ->
      {fixed, Value0}
  end.

'Exponential'() ->
  fun
    (Value0) ->
      {exponential, Value0}
  end.

toStringWith() ->
  fun
    (V) ->
      toStringWith(V)
  end.

toStringWith(V) ->
  case V of
    {precision, V@1} ->
      (toPrecisionNative())(V@1);
    {fixed, V@2} ->
      (toFixedNative())(V@2);
    {exponential, V@3} ->
      (toExponentialNative())(V@3);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

precision() ->
  fun
    (X) ->
      precision(X)
  end.

precision(X) ->
  {precision, clamp(1, 21, X)}.

fixed() ->
  fun
    (X) ->
      fixed(X)
  end.

fixed(X) ->
  {fixed, clamp(0, 20, X)}.

exponential() ->
  fun
    (X) ->
      exponential(X)
  end.

exponential(X) ->
  {exponential, clamp(0, 20, X)}.

toPrecisionNative() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_number_format@foreign:toPrecisionNative(V, V@1)
      end
  end.

toFixedNative() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_number_format@foreign:toFixedNative(V, V@1)
      end
  end.

toExponentialNative() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_number_format@foreign:toExponentialNative(V, V@1)
      end
  end.

toString() ->
  fun
    (V) ->
      data_number_format@foreign:toString(V)
  end.

