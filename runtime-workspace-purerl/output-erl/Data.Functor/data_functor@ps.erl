-module(data_functor@ps).
-export([ map/0
        , map/1
        , mapFlipped/0
        , mapFlipped/3
        , void/0
        , void/1
        , voidLeft/0
        , voidLeft/3
        , voidRight/0
        , voidRight/2
        , functorProxy/0
        , functorFn/0
        , functorArray/0
        , flap/0
        , flap/3
        , arrayMap/0
        ]).
-compile(no_auto_import).
map() ->
  fun
    (Dict) ->
      map(Dict)
  end.

map(#{ map := Dict }) ->
  Dict.

mapFlipped() ->
  fun
    (DictFunctor) ->
      fun
        (Fa) ->
          fun
            (F) ->
              mapFlipped(DictFunctor, Fa, F)
          end
      end
  end.

mapFlipped(#{ map := DictFunctor }, Fa, F) ->
  (DictFunctor(F))(Fa).

void() ->
  fun
    (DictFunctor) ->
      void(DictFunctor)
  end.

void(#{ map := DictFunctor }) ->
  DictFunctor(fun
    (_) ->
      unit
  end).

voidLeft() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (X) ->
              voidLeft(DictFunctor, F, X)
          end
      end
  end.

voidLeft(#{ map := DictFunctor }, F, X) ->
  (DictFunctor(fun
     (_) ->
       X
   end))
  (F).

voidRight() ->
  fun
    (DictFunctor) ->
      fun
        (X) ->
          voidRight(DictFunctor, X)
      end
  end.

voidRight(#{ map := DictFunctor }, X) ->
  DictFunctor(fun
    (_) ->
      X
  end).

functorProxy() ->
  #{ map =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   }.

functorFn() ->
  #{ map => erlang:map_get(compose, control_semigroupoid@ps:semigroupoidFn()) }.

functorArray() ->
  #{ map => arrayMap() }.

flap() ->
  fun
    (DictFunctor) ->
      fun
        (Ff) ->
          fun
            (X) ->
              flap(DictFunctor, Ff, X)
          end
      end
  end.

flap(#{ map := DictFunctor }, Ff, X) ->
  (DictFunctor(fun
     (F) ->
       F(X)
   end))
  (Ff).

arrayMap() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_functor@foreign:arrayMap(V, V@1)
      end
  end.

