-module(main@ps).
-export([toPlaygroundValue/0, cell_c4/0, cell_c1/0, main/0]).
-compile(no_auto_import).
toPlaygroundValue() ->
  erlang:map_get(
    toPlaygroundValue,
    playground_runtime@ps:toPlaygroundValueArray(playground_runtime@ps:toPlaygroundValueInt())
  ).

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

cell_c1() ->
  {just, 20}.

main() ->
  fun
    () ->
      begin
        (playground_runtime@ps:emit(
           <<"c1">>,
           { pVCtor
           , <<"Just">>
           , array:from_list([{pVNumber, data_int@foreign:toNumber(20)}])
           }
         ))(),
        V_c4 = ((toPlaygroundValue())(cell_c4()))(),
        (playground_runtime@ps:emit(<<"c4">>, V_c4))(),
        (playground_runtime@foreign:done())()
      end
  end.

