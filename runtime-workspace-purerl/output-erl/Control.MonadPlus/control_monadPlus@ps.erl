-module(control_monadPlus@ps).
-export([monadPlusArray/0]).
-compile(no_auto_import).
monadPlusArray() ->
  #{ 'Monad0' =>
     fun
       (_) ->
         control_monad@ps:monadArray()
     end
   , 'Alternative1' =>
     fun
       (_) ->
         control_alternative@ps:alternativeArray()
     end
   }.

