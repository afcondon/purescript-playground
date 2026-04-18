-module(control_alt@ps).
-export([altArray/0, alt/0, alt/1]).
-compile(no_auto_import).
altArray() ->
  #{ alt => data_semigroup@ps:concatArray()
   , 'Functor0' =>
     fun
       (_) ->
         data_functor@ps:functorArray()
     end
   }.

alt() ->
  fun
    (Dict) ->
      alt(Dict)
  end.

alt(#{ alt := Dict }) ->
  Dict.

