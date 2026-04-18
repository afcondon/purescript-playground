-module(control_biapply@ps).
-export([ identity/0
        , identity/1
        , biapplyTuple/0
        , biapply/0
        , biapply/1
        , biapplyFirst/0
        , biapplyFirst/3
        , biapplySecond/0
        , biapplySecond/3
        , bilift2/0
        , bilift2/5
        , bilift3/0
        , bilift3/6
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

biapplyTuple() ->
  #{ biapply =>
     fun
       (V) ->
         fun
           (V1) ->
             { tuple
             , (erlang:element(2, V))(erlang:element(2, V1))
             , (erlang:element(3, V))(erlang:element(3, V1))
             }
         end
     end
   , 'Bifunctor0' =>
     fun
       (_) ->
         data_bifunctor@ps:bifunctorTuple()
     end
   }.

biapply() ->
  fun
    (Dict) ->
      biapply(Dict)
  end.

biapply(#{ biapply := Dict }) ->
  Dict.

biapplyFirst() ->
  fun
    (DictBiapply) ->
      fun
        (A) ->
          fun
            (B) ->
              biapplyFirst(DictBiapply, A, B)
          end
      end
  end.

biapplyFirst(#{ 'Bifunctor0' := DictBiapply, biapply := DictBiapply@1 }, A, B) ->
  (DictBiapply@1((((erlang:map_get(bimap, DictBiapply(undefined)))
                   (fun
                     (_) ->
                       identity()
                   end))
                  (fun
                    (_) ->
                      identity()
                  end))
                 (A)))
  (B).

biapplySecond() ->
  fun
    (DictBiapply) ->
      fun
        (A) ->
          fun
            (B) ->
              biapplySecond(DictBiapply, A, B)
          end
      end
  end.

biapplySecond(#{ 'Bifunctor0' := DictBiapply, biapply := DictBiapply@1 }, A, B) ->
  begin
    V = data_function@ps:const(),
    (DictBiapply@1((((erlang:map_get(bimap, DictBiapply(undefined)))(V))(V))(A)))
    (B)
  end.

bilift2() ->
  fun
    (DictBiapply) ->
      fun
        (F) ->
          fun
            (G) ->
              fun
                (A) ->
                  fun
                    (B) ->
                      bilift2(DictBiapply, F, G, A, B)
                  end
              end
          end
      end
  end.

bilift2(#{ 'Bifunctor0' := DictBiapply, biapply := DictBiapply@1 }, F, G, A, B) ->
  (DictBiapply@1((((erlang:map_get(bimap, DictBiapply(undefined)))(F))(G))(A)))
  (B).

bilift3() ->
  fun
    (DictBiapply) ->
      fun
        (F) ->
          fun
            (G) ->
              fun
                (A) ->
                  fun
                    (B) ->
                      fun
                        (C) ->
                          bilift3(DictBiapply, F, G, A, B, C)
                      end
                  end
              end
          end
      end
  end.

bilift3( #{ 'Bifunctor0' := DictBiapply, biapply := DictBiapply@1 }
       , F
       , G
       , A
       , B
       , C
       ) ->
  (DictBiapply@1((DictBiapply@1((((erlang:map_get(
                                     bimap,
                                     DictBiapply(undefined)
                                   ))
                                  (F))
                                 (G))
                                (A)))
                 (B)))
  (C).

