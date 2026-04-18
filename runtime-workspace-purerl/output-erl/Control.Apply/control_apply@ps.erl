-module(control_apply@ps).
-export([ identity/0
        , identity/1
        , applyProxy/0
        , applyFn/0
        , applyArray/0
        , apply/0
        , apply/1
        , applyFirst/0
        , applyFirst/3
        , applySecond/0
        , applySecond/3
        , lift2/0
        , lift2/4
        , lift3/0
        , lift3/5
        , lift4/0
        , lift4/6
        , lift5/0
        , lift5/7
        , arrayApply/0
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

applyProxy() ->
  #{ apply =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_functor@ps:functorProxy()
     end
   }.

applyFn() ->
  #{ apply =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (X) ->
                 (F(X))(G(X))
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_functor@ps:functorFn()
     end
   }.

applyArray() ->
  #{ apply => arrayApply()
   , 'Functor0' =>
     fun
       (_) ->
         data_functor@ps:functorArray()
     end
   }.

apply() ->
  fun
    (Dict) ->
      apply(Dict)
  end.

apply(#{ apply := Dict }) ->
  Dict.

applyFirst() ->
  fun
    (DictApply) ->
      fun
        (A) ->
          fun
            (B) ->
              applyFirst(DictApply, A, B)
          end
      end
  end.

applyFirst(#{ 'Functor0' := DictApply, apply := DictApply@1 }, A, B) ->
  (DictApply@1(((erlang:map_get(map, DictApply(undefined)))
                (data_function@ps:const()))
               (A)))
  (B).

applySecond() ->
  fun
    (DictApply) ->
      fun
        (A) ->
          fun
            (B) ->
              applySecond(DictApply, A, B)
          end
      end
  end.

applySecond(#{ 'Functor0' := DictApply, apply := DictApply@1 }, A, B) ->
  (DictApply@1(((erlang:map_get(map, DictApply(undefined)))
                (fun
                  (_) ->
                    identity()
                end))
               (A)))
  (B).

lift2() ->
  fun
    (DictApply) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (B) ->
                  lift2(DictApply, F, A, B)
              end
          end
      end
  end.

lift2(#{ 'Functor0' := DictApply, apply := DictApply@1 }, F, A, B) ->
  (DictApply@1(((erlang:map_get(map, DictApply(undefined)))(F))(A)))(B).

lift3() ->
  fun
    (DictApply) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (B) ->
                  fun
                    (C) ->
                      lift3(DictApply, F, A, B, C)
                  end
              end
          end
      end
  end.

lift3(#{ 'Functor0' := DictApply, apply := DictApply@1 }, F, A, B, C) ->
  (DictApply@1((DictApply@1(((erlang:map_get(map, DictApply(undefined)))(F))(A)))
               (B)))
  (C).

lift4() ->
  fun
    (DictApply) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (B) ->
                  fun
                    (C) ->
                      fun
                        (D) ->
                          lift4(DictApply, F, A, B, C, D)
                      end
                  end
              end
          end
      end
  end.

lift4(#{ 'Functor0' := DictApply, apply := DictApply@1 }, F, A, B, C, D) ->
  (DictApply@1((DictApply@1((DictApply@1(((erlang:map_get(
                                             map,
                                             DictApply(undefined)
                                           ))
                                          (F))
                                         (A)))
                            (B)))
               (C)))
  (D).

lift5() ->
  fun
    (DictApply) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (B) ->
                  fun
                    (C) ->
                      fun
                        (D) ->
                          fun
                            (E) ->
                              lift5(DictApply, F, A, B, C, D, E)
                          end
                      end
                  end
              end
          end
      end
  end.

lift5(#{ 'Functor0' := DictApply, apply := DictApply@1 }, F, A, B, C, D, E) ->
  (DictApply@1((DictApply@1((DictApply@1((DictApply@1(((erlang:map_get(
                                                          map,
                                                          DictApply(undefined)
                                                        ))
                                                       (F))
                                                      (A)))
                                         (B)))
                            (C)))
               (D)))
  (E).

arrayApply() ->
  fun
    (V) ->
      fun
        (V@1) ->
          control_apply@foreign:arrayApply(V, V@1)
      end
  end.

