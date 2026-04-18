-module(main@ps).
-export([cell_c2/0, cell_c1/0, main/0]).
-compile(no_auto_import).
cell_c2() ->
  playground_user@ps:runCounter().

cell_c1() ->
  playground_user@ps:roundTrip().

main() ->
  fun
    () ->
      begin
        V = (playground_user@ps:roundTrip())(),
        (playground_runtime@ps:emit(
           <<"c1">>,
           {pVNumber, data_int@foreign:toNumber(V)}
         ))(),
        V@1 = (playground_user@ps:runCounter())(),
        (playground_runtime@ps:emit(
           <<"c2">>,
           {pVNumber, data_int@foreign:toNumber(V@1)}
         ))(),
        (playground_runtime@foreign:done())()
      end
  end.

