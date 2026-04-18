-module(control_semigroupoid@ps).
-export([ semigroupoidFn/0
        , compose/0
        , compose/1
        , composeFlipped/0
        , composeFlipped/3
        ]).
-compile(no_auto_import).
semigroupoidFn() ->
  #{ compose =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (X) ->
                 F(G(X))
             end
         end
     end
   }.

compose() ->
  fun
    (Dict) ->
      compose(Dict)
  end.

compose(#{ compose := Dict }) ->
  Dict.

composeFlipped() ->
  fun
    (DictSemigroupoid) ->
      fun
        (F) ->
          fun
            (G) ->
              composeFlipped(DictSemigroupoid, F, G)
          end
      end
  end.

composeFlipped(#{ compose := DictSemigroupoid }, F, G) ->
  (DictSemigroupoid(G))(F).

