-module(data_bifunctor@ps).
-export([ identity/0
        , identity/1
        , bimap/0
        , bimap/1
        , lmap/0
        , lmap/2
        , rmap/0
        , rmap/1
        , bifunctorTuple/0
        , bifunctorEither/0
        , bifunctorConst/0
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

bimap() ->
  fun
    (Dict) ->
      bimap(Dict)
  end.

bimap(#{ bimap := Dict }) ->
  Dict.

lmap() ->
  fun
    (DictBifunctor) ->
      fun
        (F) ->
          lmap(DictBifunctor, F)
      end
  end.

lmap(#{ bimap := DictBifunctor }, F) ->
  (DictBifunctor(F))(identity()).

rmap() ->
  fun
    (DictBifunctor) ->
      rmap(DictBifunctor)
  end.

rmap(#{ bimap := DictBifunctor }) ->
  DictBifunctor(identity()).

bifunctorTuple() ->
  #{ bimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 {tuple, F(erlang:element(2, V)), G(erlang:element(3, V))}
             end
         end
     end
   }.

bifunctorEither() ->
  #{ bimap =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (V2) ->
                 case V2 of
                   {left, V2@1} ->
                     {left, V(V2@1)};
                   {right, V2@2} ->
                     {right, V1(V2@2)};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   }.

bifunctorConst() ->
  #{ bimap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V1) ->
                 F(V1)
             end
         end
     end
   }.

