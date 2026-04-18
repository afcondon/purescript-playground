-module(control_plus@ps).
-export([plusArray/0, empty/0, empty/1]).
-compile(no_auto_import).
plusArray() ->
  #{ empty => array:from_list([])
   , 'Alt0' =>
     fun
       (_) ->
         control_alt@ps:altArray()
     end
   }.

empty() ->
  fun
    (Dict) ->
      empty(Dict)
  end.

empty(#{ empty := Dict }) ->
  Dict.

