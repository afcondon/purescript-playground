-module(data_profunctor@ps).
-export([ identity/0
        , identity/1
        , profunctorFn/0
        , dimap/0
        , dimap/1
        , lcmap/0
        , lcmap/2
        , rmap/0
        , rmap/2
        , unwrapIso/0
        , unwrapIso/2
        , wrapIso/0
        , wrapIso/3
        , arr/0
        , arr/1
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

profunctorFn() ->
  #{ dimap =>
     fun
       (A2b) ->
         fun
           (C2d) ->
             fun
               (B2c) ->
                 fun
                   (X) ->
                     C2d(B2c(A2b(X)))
                 end
             end
         end
     end
   }.

dimap() ->
  fun
    (Dict) ->
      dimap(Dict)
  end.

dimap(#{ dimap := Dict }) ->
  Dict.

lcmap() ->
  fun
    (DictProfunctor) ->
      fun
        (A2b) ->
          lcmap(DictProfunctor, A2b)
      end
  end.

lcmap(#{ dimap := DictProfunctor }, A2b) ->
  (DictProfunctor(A2b))(identity()).

rmap() ->
  fun
    (DictProfunctor) ->
      fun
        (B2c) ->
          rmap(DictProfunctor, B2c)
      end
  end.

rmap(#{ dimap := DictProfunctor }, B2c) ->
  (DictProfunctor(identity()))(B2c).

unwrapIso() ->
  fun
    (DictProfunctor) ->
      fun
        (V) ->
          unwrapIso(DictProfunctor, V)
      end
  end.

unwrapIso(#{ dimap := DictProfunctor }, _) ->
  begin
    V = unsafe_coerce@ps:unsafeCoerce(),
    (DictProfunctor(V))(V)
  end.

wrapIso() ->
  fun
    (DictProfunctor) ->
      fun
        (V) ->
          fun
            (V@1) ->
              wrapIso(DictProfunctor, V, V@1)
          end
      end
  end.

wrapIso(#{ dimap := DictProfunctor }, _, _) ->
  begin
    V = unsafe_coerce@ps:unsafeCoerce(),
    (DictProfunctor(V))(V)
  end.

arr() ->
  fun
    (DictCategory) ->
      arr(DictCategory)
  end.

arr(#{ identity := DictCategory }) ->
  fun
    (#{ dimap := DictProfunctor }) ->
      fun
        (F) ->
          ((DictProfunctor(identity()))(F))(DictCategory)
      end
  end.

