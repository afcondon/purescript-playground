-module(playground_runtime@ps).
-export([ traverse/0
        , 'PVNull'/0
        , 'PVBool'/0
        , 'PVNumber'/0
        , 'PVString'/0
        , 'PVArray'/0
        , 'PVCtor'/0
        , 'PVRaw'/0
        , toPlaygroundValueUnit/0
        , toPlaygroundValueString/0
        , toPlaygroundValueShow/0
        , toPlaygroundValueShow/1
        , toPlaygroundValueNumber/0
        , toPlaygroundValueInt/0
        , toPlaygroundValueChar/0
        , toPlaygroundValueBoolean/0
        , toPlaygroundValue/0
        , toPlaygroundValue/1
        , toPlaygroundValueArray/0
        , toPlaygroundValueArray/1
        , toPlaygroundValueEffect/0
        , toPlaygroundValueEffect/1
        , toPlaygroundValueEither/0
        , toPlaygroundValueEither/2
        , toPlaygroundValueMaybe/0
        , toPlaygroundValueMaybe/1
        , toPlaygroundValueTuple/0
        , toPlaygroundValueTuple/2
        , showNumber/0
        , showNumber/1
        , jsonString/0
        , jsonString/1
        , encode/0
        , encode/1
        , emit/0
        , emit/2
        , '_emitLine'/0
        , '_formatFloat'/0
        , done/0
        ]).
-compile(no_auto_import).
traverse() ->
  (erlang:map_get(traverse, data_traversable@ps:traversableArray()))
  (effect@ps:applicativeEffect()).

'PVNull'() ->
  {pVNull}.

'PVBool'() ->
  fun
    (Value0) ->
      {pVBool, Value0}
  end.

'PVNumber'() ->
  fun
    (Value0) ->
      {pVNumber, Value0}
  end.

'PVString'() ->
  fun
    (Value0) ->
      {pVString, Value0}
  end.

'PVArray'() ->
  fun
    (Value0) ->
      {pVArray, Value0}
  end.

'PVCtor'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {pVCtor, Value0, Value1}
      end
  end.

'PVRaw'() ->
  fun
    (Value0) ->
      {pVRaw, Value0}
  end.

toPlaygroundValueUnit() ->
  #{ toPlaygroundValue =>
     fun
       (_) ->
         fun
           () ->
             {pVNull}
         end
     end
   }.

toPlaygroundValueString() ->
  #{ toPlaygroundValue =>
     fun
       (S) ->
         fun
           () ->
             {pVString, S}
         end
     end
   }.

toPlaygroundValueShow() ->
  fun
    (DictShow) ->
      toPlaygroundValueShow(DictShow)
  end.

toPlaygroundValueShow(#{ show := DictShow }) ->
  #{ toPlaygroundValue =>
     fun
       (A) ->
         begin
           V = {pVRaw, DictShow(A)},
           fun
             () ->
               V
           end
         end
     end
   }.

toPlaygroundValueNumber() ->
  #{ toPlaygroundValue =>
     fun
       (N) ->
         fun
           () ->
             {pVNumber, N}
         end
     end
   }.

toPlaygroundValueInt() ->
  #{ toPlaygroundValue =>
     fun
       (N) ->
         begin
           V = {pVNumber, data_int@foreign:toNumber(N)},
           fun
             () ->
               V
           end
         end
     end
   }.

toPlaygroundValueChar() ->
  #{ toPlaygroundValue =>
     fun
       (C) ->
         begin
           V = {pVString, data_string_codeUnits@foreign:singleton(C)},
           fun
             () ->
               V
           end
         end
     end
   }.

toPlaygroundValueBoolean() ->
  #{ toPlaygroundValue =>
     fun
       (B) ->
         fun
           () ->
             {pVBool, B}
         end
     end
   }.

toPlaygroundValue() ->
  fun
    (Dict) ->
      toPlaygroundValue(Dict)
  end.

toPlaygroundValue(#{ toPlaygroundValue := Dict }) ->
  Dict.

toPlaygroundValueArray() ->
  fun
    (DictToPlaygroundValue) ->
      toPlaygroundValueArray(DictToPlaygroundValue)
  end.

toPlaygroundValueArray(#{ toPlaygroundValue := DictToPlaygroundValue }) ->
  #{ toPlaygroundValue =>
     fun
       (Xs) ->
         begin
           V = ((traverse())(DictToPlaygroundValue))(Xs),
           fun
             () ->
               begin
                 A_ = V(),
                 {pVArray, A_}
               end
           end
         end
     end
   }.

toPlaygroundValueEffect() ->
  fun
    (DictToPlaygroundValue) ->
      toPlaygroundValueEffect(DictToPlaygroundValue)
  end.

toPlaygroundValueEffect(#{ toPlaygroundValue := DictToPlaygroundValue }) ->
  #{ toPlaygroundValue =>
     fun
       (Eff) ->
         fun
           () ->
             begin
               V = Eff(),
               (DictToPlaygroundValue(V))()
             end
         end
     end
   }.

toPlaygroundValueEither() ->
  fun
    (DictToPlaygroundValue) ->
      fun
        (DictToPlaygroundValue1) ->
          toPlaygroundValueEither(DictToPlaygroundValue, DictToPlaygroundValue1)
      end
  end.

toPlaygroundValueEither(DictToPlaygroundValue, DictToPlaygroundValue1) ->
  #{ toPlaygroundValue =>
     fun
       (V) ->
         case V of
           {left, V@1} ->
             begin
               #{ toPlaygroundValue := DictToPlaygroundValue@1 } =
                 DictToPlaygroundValue,
               V@2 = DictToPlaygroundValue@1(V@1),
               fun
                 () ->
                   begin
                     V1 = V@2(),
                     {pVCtor, <<"Left">>, array:from_list([V1])}
                   end
               end
             end;
           {right, V@3} ->
             begin
               #{ toPlaygroundValue := DictToPlaygroundValue1@1 } =
                 DictToPlaygroundValue1,
               V@4 = DictToPlaygroundValue1@1(V@3),
               fun
                 () ->
                   begin
                     V1 = V@4(),
                     {pVCtor, <<"Right">>, array:from_list([V1])}
                   end
               end
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

toPlaygroundValueMaybe() ->
  fun
    (DictToPlaygroundValue) ->
      toPlaygroundValueMaybe(DictToPlaygroundValue)
  end.

toPlaygroundValueMaybe(DictToPlaygroundValue) ->
  #{ toPlaygroundValue =>
     fun
       (V) ->
         case V of
           {just, V@1} ->
             begin
               #{ toPlaygroundValue := DictToPlaygroundValue@1 } =
                 DictToPlaygroundValue,
               V@2 = DictToPlaygroundValue@1(V@1),
               fun
                 () ->
                   begin
                     V1 = V@2(),
                     {pVCtor, <<"Just">>, array:from_list([V1])}
                   end
               end
             end;
           {nothing} ->
             fun
               () ->
                 {pVCtor, <<"Nothing">>, array:from_list([])}
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

toPlaygroundValueTuple() ->
  fun
    (DictToPlaygroundValue) ->
      fun
        (DictToPlaygroundValue1) ->
          toPlaygroundValueTuple(DictToPlaygroundValue, DictToPlaygroundValue1)
      end
  end.

toPlaygroundValueTuple( #{ toPlaygroundValue := DictToPlaygroundValue }
                      , #{ toPlaygroundValue := DictToPlaygroundValue1 }
                      ) ->
  #{ toPlaygroundValue =>
     fun
       (V) ->
         begin
           V@1 = erlang:element(3, V),
           V@2 = DictToPlaygroundValue(erlang:element(2, V)),
           fun
             () ->
               begin
                 Va = V@2(),
                 Vb = (DictToPlaygroundValue1(V@1))(),
                 {pVCtor, <<"Tuple">>, array:from_list([Va, Vb])}
               end
           end
         end
     end
   }.

showNumber() ->
  fun
    (N) ->
      showNumber(N)
  end.

showNumber(N) ->
  begin
    AsInt = data_int@ps:round(N),
    case (data_int@foreign:toNumber(AsInt)) =:= N of
      true ->
        data_show@foreign:showIntImpl(AsInt);
      _ ->
        playground_runtime@foreign:'_formatFloat'(N)
    end
  end.

jsonString() ->
  fun
    (S) ->
      jsonString(S)
  end.

jsonString(S) ->
  <<
    "\"",
    (data_string_common@foreign:replaceAll(
       <<"\t">>,
       <<"\\t">>,
       data_string_common@foreign:replaceAll(
         <<"\r">>,
         <<"\\r">>,
         data_string_common@foreign:replaceAll(
           <<"\n">>,
           <<"\\n">>,
           data_string_common@foreign:replaceAll(
             <<"\"">>,
             <<"\\\"">>,
             data_string_common@foreign:replaceAll(<<"\\">>, <<"\\\\">>, S)
           )
         )
       )
     ))/binary,
    "\""
  >>.

encode() ->
  fun
    (V) ->
      encode(V)
  end.

encode(V) ->
  case V of
    {pVNull} ->
      <<"null">>;
    {pVBool, _} ->
      if
        erlang:element(2, V) ->
          <<"true">>;
        true ->
          <<"false">>
      end;
    {pVNumber, V@1} ->
      showNumber(V@1);
    {pVString, V@2} ->
      jsonString(V@2);
    {pVArray, V@3} ->
      <<
        "[",
        (data_string_common@foreign:joinWith(
           <<",">>,
           data_functor@foreign:arrayMap(encode(), V@3)
         ))/binary,
        "]"
      >>;
    {pVCtor, V@4, V@5} ->
      <<
        "{\"$ctor\":",
        (jsonString(V@4))/binary,
        ",\"args\":[",
        (data_string_common@foreign:joinWith(
           <<",">>,
           data_functor@foreign:arrayMap(encode(), V@5)
         ))/binary,
        "]}"
      >>;
    {pVRaw, V@6} ->
      <<"{\"$raw\":", (jsonString(V@6))/binary, "}">>;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

emit() ->
  fun
    (Id) ->
      fun
        (Value) ->
          emit(Id, Value)
      end
  end.

emit(Id, Value) ->
  playground_runtime@foreign:'_emitLine'(<<
    "{\"type\":\"emit\",\"id\":",
    (jsonString(Id))/binary,
    ",\"value\":",
    (jsonString(encode(Value)))/binary,
    "}"
  >>).

'_emitLine'() ->
  fun
    (V) ->
      playground_runtime@foreign:'_emitLine'(V)
  end.

'_formatFloat'() ->
  fun
    (V) ->
      playground_runtime@foreign:'_formatFloat'(V)
  end.

done() ->
  playground_runtime@foreign:done().

