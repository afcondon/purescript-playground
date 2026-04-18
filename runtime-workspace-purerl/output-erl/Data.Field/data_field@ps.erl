-module(data_field@ps).
-export([field/0, field/2]).
-compile(no_auto_import).
field() ->
  fun
    (DictEuclideanRing) ->
      fun
        (DictDivisionRing) ->
          field(DictEuclideanRing, DictDivisionRing)
      end
  end.

field(DictEuclideanRing, DictDivisionRing) ->
  #{ 'EuclideanRing0' =>
     fun
       (_) ->
         DictEuclideanRing
     end
   , 'DivisionRing1' =>
     fun
       (_) ->
         DictDivisionRing
     end
   }.

