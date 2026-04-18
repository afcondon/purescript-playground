-module(control_category@ps).
-export([identity/0, identity/1, categoryFn/0]).
-compile(no_auto_import).
identity() ->
  fun
    (Dict) ->
      identity(Dict)
  end.

identity(#{ identity := Dict }) ->
  Dict.

categoryFn() ->
  #{ identity =>
     fun
       (X) ->
         X
     end
   , 'Semigroupoid0' =>
     fun
       (_) ->
         control_semigroupoid@ps:semigroupoidFn()
     end
   }.

