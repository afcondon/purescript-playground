-module(type_equality@ps).
-export([refl/0, proof/0, proof/1, to/0, to/1, from/0, from/1]).
-compile(no_auto_import).
refl() ->
  #{ proof =>
     fun
       (A) ->
         A
     end
   , 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

proof() ->
  fun
    (Dict) ->
      proof(Dict)
  end.

proof(#{ proof := Dict }) ->
  Dict.

to() ->
  fun
    (DictTypeEquals) ->
      to(DictTypeEquals)
  end.

to(#{ proof := DictTypeEquals }) ->
  DictTypeEquals(fun
    (A) ->
      A
  end).

from() ->
  fun
    (DictTypeEquals) ->
      from(DictTypeEquals)
  end.

from(#{ proof := DictTypeEquals }) ->
  DictTypeEquals(fun
    (A) ->
      A
  end).

