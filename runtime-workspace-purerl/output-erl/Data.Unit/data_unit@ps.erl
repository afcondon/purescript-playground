-module(data_unit@ps).
-export([showUnit/0, unit/0]).
-compile(no_auto_import).
showUnit() ->
  #{ show =>
     fun
       (_) ->
         <<"unit">>
     end
   }.

unit() ->
  data_unit@foreign:unit().

