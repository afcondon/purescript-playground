-module(main@ps).
-export([ toPlaygroundValue/0
        , toPlaygroundValue/1
        , toPlaygroundValue1/0
        , toPlaygroundValue2/0
        , toPlaygroundValue2/1
        , cell_c5/0
        , cell_c4/0
        , cell_c3/0
        , cell_c2/0
        , cell_c1/0
        , 'main.0'/0
        , main/0
        ]).
-compile(no_auto_import).
toPlaygroundValue() ->
  fun
    (V) ->
      toPlaygroundValue(V)
  end.

toPlaygroundValue(V) ->
  case V of
    {just, V@1} ->
      begin
        V@2 = {pVNumber, data_int@foreign:toNumber(V@1)},
        fun
          () ->
            {pVCtor, <<"Just">>, array:from_list([V@2])}
        end
      end;
    {nothing} ->
      fun
        () ->
          {pVCtor, <<"Nothing">>, array:from_list([])}
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

toPlaygroundValue1() ->
  erlang:map_get(
    toPlaygroundValue,
    playground_runtime@ps:toPlaygroundValueArray(playground_runtime@ps:toPlaygroundValueInt())
  ).

toPlaygroundValue2() ->
  fun
    (V) ->
      toPlaygroundValue2(V)
  end.

toPlaygroundValue2(V) ->
  case V of
    {left, V@1} ->
      fun
        () ->
          {pVCtor, <<"Left">>, array:from_list([{pVString, V@1}])}
      end;
    {right, V@2} ->
      begin
        V@3 = {pVNumber, data_int@foreign:toNumber(V@2)},
        fun
          () ->
            {pVCtor, <<"Right">>, array:from_list([V@3])}
        end
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

cell_c5() ->
  {right, 30}.

cell_c4() ->
  control_bind@foreign:arrayBind(
    array:from_list([1, 2, 3]),
    fun
      (X) ->
        control_bind@foreign:arrayBind(
          array:from_list([10, 20]),
          fun
            (Y) ->
              array:from_list([X + Y])
          end
        )
    end
  ).

cell_c3() ->
  {just, 30}.

cell_c2() ->
  {just, 30}.

cell_c1() ->
  {just, 20}.

'main.0'() ->
  toPlaygroundValue({just, 20}).

main() ->
  fun
    () ->
      begin
        V_c1 = ('main.0'())(),
        (playground_runtime@ps:emit(<<"c1">>, V_c1))(),
        V_c2 = (toPlaygroundValue({just, 30}))(),
        (playground_runtime@ps:emit(<<"c2">>, V_c2))(),
        V_c3 = (toPlaygroundValue({just, 30}))(),
        (playground_runtime@ps:emit(<<"c3">>, V_c3))(),
        V_c4 = ((toPlaygroundValue1())(cell_c4()))(),
        (playground_runtime@ps:emit(<<"c4">>, V_c4))(),
        V_c5 = (toPlaygroundValue2({right, 30}))(),
        (playground_runtime@ps:emit(<<"c5">>, V_c5))(),
        (playground_runtime@foreign:done())()
      end
  end.

