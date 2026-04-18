-module(data_profunctor_closed@ps).
-export([closedFunction/0, closed/0, closed/1]).
-compile(no_auto_import).
closedFunction() ->
  #{ closed => erlang:map_get(compose, control_semigroupoid@ps:semigroupoidFn())
   , 'Profunctor0' =>
     fun
       (_) ->
         data_profunctor@ps:profunctorFn()
     end
   }.

closed() ->
  fun
    (Dict) ->
      closed(Dict)
  end.

closed(#{ closed := Dict }) ->
  Dict.

