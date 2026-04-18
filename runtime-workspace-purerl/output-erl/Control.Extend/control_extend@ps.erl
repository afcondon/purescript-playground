-module(control_extend@ps).
-export([ identity/0
        , identity/1
        , extendFn/0
        , extendFn/1
        , extendArray/0
        , extend/0
        , extend/1
        , extendFlipped/0
        , extendFlipped/3
        , duplicate/0
        , duplicate/1
        , composeCoKleisliFlipped/0
        , composeCoKleisliFlipped/4
        , composeCoKleisli/0
        , composeCoKleisli/4
        , arrayExtend/0
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

extendFn() ->
  fun
    (DictSemigroup) ->
      extendFn(DictSemigroup)
  end.

extendFn(#{ append := DictSemigroup }) ->
  #{ extend =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (W) ->
                 F(fun
                   (W_) ->
                     G((DictSemigroup(W))(W_))
                 end)
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_functor@ps:functorFn()
     end
   }.

extendArray() ->
  #{ extend => arrayExtend()
   , 'Functor0' =>
     fun
       (_) ->
         data_functor@ps:functorArray()
     end
   }.

extend() ->
  fun
    (Dict) ->
      extend(Dict)
  end.

extend(#{ extend := Dict }) ->
  Dict.

extendFlipped() ->
  fun
    (DictExtend) ->
      fun
        (W) ->
          fun
            (F) ->
              extendFlipped(DictExtend, W, F)
          end
      end
  end.

extendFlipped(#{ extend := DictExtend }, W, F) ->
  (DictExtend(F))(W).

duplicate() ->
  fun
    (DictExtend) ->
      duplicate(DictExtend)
  end.

duplicate(#{ extend := DictExtend }) ->
  DictExtend(identity()).

composeCoKleisliFlipped() ->
  fun
    (DictExtend) ->
      fun
        (F) ->
          fun
            (G) ->
              fun
                (W) ->
                  composeCoKleisliFlipped(DictExtend, F, G, W)
              end
          end
      end
  end.

composeCoKleisliFlipped(#{ extend := DictExtend }, F, G, W) ->
  F((DictExtend(G))(W)).

composeCoKleisli() ->
  fun
    (DictExtend) ->
      fun
        (F) ->
          fun
            (G) ->
              fun
                (W) ->
                  composeCoKleisli(DictExtend, F, G, W)
              end
          end
      end
  end.

composeCoKleisli(#{ extend := DictExtend }, F, G, W) ->
  G((DictExtend(F))(W)).

arrayExtend() ->
  fun
    (V) ->
      fun
        (V@1) ->
          control_extend@foreign:arrayExtend(V, V@1)
      end
  end.

