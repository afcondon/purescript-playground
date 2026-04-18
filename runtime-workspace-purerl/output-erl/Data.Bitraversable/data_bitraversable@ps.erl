-module(data_bitraversable@ps).
-export([ identity/0
        , identity/1
        , bitraverse/0
        , bitraverse/1
        , lfor/0
        , lfor/2
        , ltraverse/0
        , ltraverse/2
        , rfor/0
        , rfor/2
        , rtraverse/0
        , rtraverse/2
        , bitraversableTuple/0
        , bitraversableJoker/0
        , bitraversableJoker/1
        , bitraversableEither/0
        , bitraversableConst/0
        , bitraversableClown/0
        , bitraversableClown/1
        , bisequenceDefault/0
        , bisequenceDefault/2
        , bisequence/0
        , bisequence/1
        , bitraversableFlip/0
        , bitraversableFlip/1
        , bitraversableProduct2/0
        , bitraversableProduct2/1
        , bitraverseDefault/0
        , bitraverseDefault/2
        , bifor/0
        , bifor/2
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

bitraverse() ->
  fun
    (Dict) ->
      bitraverse(Dict)
  end.

bitraverse(#{ bitraverse := Dict }) ->
  Dict.

lfor() ->
  fun
    (DictBitraversable) ->
      fun
        (DictApplicative) ->
          lfor(DictBitraversable, DictApplicative)
      end
  end.

lfor( #{ bitraverse := DictBitraversable }
    , DictApplicative = #{ pure := DictApplicative@1 }
    ) ->
  begin
    Bitraverse2 = DictBitraversable(DictApplicative),
    fun
      (T) ->
        fun
          (F) ->
            ((Bitraverse2(F))(DictApplicative@1))(T)
        end
    end
  end.

ltraverse() ->
  fun
    (DictBitraversable) ->
      fun
        (DictApplicative) ->
          ltraverse(DictBitraversable, DictApplicative)
      end
  end.

ltraverse( #{ bitraverse := DictBitraversable }
         , DictApplicative = #{ pure := DictApplicative@1 }
         ) ->
  begin
    Bitraverse2 = DictBitraversable(DictApplicative),
    fun
      (F) ->
        (Bitraverse2(F))(DictApplicative@1)
    end
  end.

rfor() ->
  fun
    (DictBitraversable) ->
      fun
        (DictApplicative) ->
          rfor(DictBitraversable, DictApplicative)
      end
  end.

rfor( #{ bitraverse := DictBitraversable }
    , DictApplicative = #{ pure := DictApplicative@1 }
    ) ->
  begin
    Bitraverse2 = DictBitraversable(DictApplicative),
    fun
      (T) ->
        fun
          (F) ->
            ((Bitraverse2(DictApplicative@1))(F))(T)
        end
    end
  end.

rtraverse() ->
  fun
    (DictBitraversable) ->
      fun
        (DictApplicative) ->
          rtraverse(DictBitraversable, DictApplicative)
      end
  end.

rtraverse( #{ bitraverse := DictBitraversable }
         , DictApplicative = #{ pure := DictApplicative@1 }
         ) ->
  (DictBitraversable(DictApplicative))(DictApplicative@1).

bitraversableTuple() ->
  #{ bitraverse =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         begin
           #{ 'Functor0' := Apply0, apply := Apply0@1 } =
             DictApplicative(undefined),
           fun
             (F) ->
               fun
                 (G) ->
                   fun
                     (V) ->
                       (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                                  (data_tuple@ps:'Tuple'()))
                                 (F(erlang:element(2, V)))))
                       (G(erlang:element(3, V)))
                   end
               end
           end
         end
     end
   , bisequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         begin
           #{ 'Functor0' := Apply0, apply := Apply0@1 } =
             DictApplicative(undefined),
           fun
             (V) ->
               (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                          (data_tuple@ps:'Tuple'()))
                         (erlang:element(2, V))))
               (erlang:element(3, V))
           end
         end
     end
   , 'Bifunctor0' =>
     fun
       (_) ->
         data_bifunctor@ps:bifunctorTuple()
     end
   , 'Bifoldable1' =>
     fun
       (_) ->
         data_bifoldable@ps:bifoldableTuple()
     end
   }.

bitraversableJoker() ->
  fun
    (DictTraversable) ->
      bitraversableJoker(DictTraversable)
  end.

bitraversableJoker(#{ 'Foldable1' := DictTraversable
                    , 'Functor0' := DictTraversable@1
                    , sequence := DictTraversable@2
                    , traverse := DictTraversable@3
                    }) ->
  begin
    #{ map := V } = DictTraversable@1(undefined),
    BifunctorJoker =
      #{ bimap =>
         fun
           (_) ->
             fun
               (G) ->
                 fun
                   (V1) ->
                     (V(G))(V1)
                 end
             end
         end
       },
    #{ foldMap := V@1, foldl := V@2, foldr := V@3 } = DictTraversable(undefined),
    BifoldableJoker =
      #{ bifoldr =>
         fun
           (_) ->
             fun
               (R) ->
                 fun
                   (U) ->
                     fun
                       (V1) ->
                         ((V@3(R))(U))(V1)
                     end
                 end
             end
         end
       , bifoldl =>
         fun
           (_) ->
             fun
               (R) ->
                 fun
                   (U) ->
                     fun
                       (V1) ->
                         ((V@2(R))(U))(V1)
                     end
                 end
             end
         end
       , bifoldMap =>
         fun
           (DictMonoid) ->
             begin
               FoldMap1 = V@1(DictMonoid),
               fun
                 (_) ->
                   fun
                     (R) ->
                       fun
                         (V1) ->
                           (FoldMap1(R))(V1)
                       end
                   end
               end
             end
         end
       },
    #{ bitraverse =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Traverse1 = DictTraversable@3(DictApplicative),
             fun
               (_) ->
                 fun
                   (R) ->
                     fun
                       (V1) ->
                         ((erlang:map_get(
                             map,
                             (erlang:map_get(
                                'Functor0',
                                DictApplicative@1(undefined)
                              ))
                             (undefined)
                           ))
                          (data_functor_joker@ps:'Joker'()))
                         ((Traverse1(R))(V1))
                     end
                 end
             end
           end
       end
     , bisequence =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Sequence1 = DictTraversable@2(DictApplicative),
             fun
               (V@4) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined)
                   ))
                  (data_functor_joker@ps:'Joker'()))
                 (Sequence1(V@4))
             end
           end
       end
     , 'Bifunctor0' =>
       fun
         (_) ->
           BifunctorJoker
       end
     , 'Bifoldable1' =>
       fun
         (_) ->
           BifoldableJoker
       end
     }
  end.

bitraversableEither() ->
  #{ bitraverse =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         begin
           #{ map := V } =
             (erlang:map_get('Functor0', DictApplicative(undefined)))(undefined),
           fun
             (V@1) ->
               fun
                 (V1) ->
                   fun
                     (V2) ->
                       case V2 of
                         {left, V2@1} ->
                           (V(data_either@ps:'Left'()))(V@1(V2@1));
                         {right, V2@2} ->
                           (V(data_either@ps:'Right'()))(V1(V2@2));
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end
               end
           end
         end
     end
   , bisequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         begin
           #{ map := V } =
             (erlang:map_get('Functor0', DictApplicative(undefined)))(undefined),
           fun
             (V@1) ->
               case V@1 of
                 {left, V@2} ->
                   (V(data_either@ps:'Left'()))(V@2);
                 {right, V@3} ->
                   (V(data_either@ps:'Right'()))(V@3);
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
           end
         end
     end
   , 'Bifunctor0' =>
     fun
       (_) ->
         data_bifunctor@ps:bifunctorEither()
     end
   , 'Bifoldable1' =>
     fun
       (_) ->
         data_bifoldable@ps:bifoldableEither()
     end
   }.

bitraversableConst() ->
  #{ bitraverse =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (F) ->
             fun
               (_) ->
                 fun
                   (V1) ->
                     ((erlang:map_get(
                         map,
                         (erlang:map_get(
                            'Functor0',
                            DictApplicative(undefined)
                          ))
                         (undefined)
                       ))
                      (data_const@ps:'Const'()))
                     (F(V1))
                 end
             end
         end
     end
   , bisequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative(undefined)))
                 (undefined)
               ))
              (data_const@ps:'Const'()))
             (V)
         end
     end
   , 'Bifunctor0' =>
     fun
       (_) ->
         data_bifunctor@ps:bifunctorConst()
     end
   , 'Bifoldable1' =>
     fun
       (_) ->
         data_bifoldable@ps:bifoldableConst()
     end
   }.

bitraversableClown() ->
  fun
    (DictTraversable) ->
      bitraversableClown(DictTraversable)
  end.

bitraversableClown(#{ 'Foldable1' := DictTraversable
                    , 'Functor0' := DictTraversable@1
                    , sequence := DictTraversable@2
                    , traverse := DictTraversable@3
                    }) ->
  begin
    #{ map := V } = DictTraversable@1(undefined),
    BifunctorClown =
      #{ bimap =>
         fun
           (F) ->
             fun
               (_) ->
                 fun
                   (V1) ->
                     (V(F))(V1)
                 end
             end
         end
       },
    #{ foldMap := V@1, foldl := V@2, foldr := V@3 } = DictTraversable(undefined),
    BifoldableClown =
      #{ bifoldr =>
         fun
           (L) ->
             fun
               (_) ->
                 fun
                   (U) ->
                     fun
                       (V1) ->
                         ((V@3(L))(U))(V1)
                     end
                 end
             end
         end
       , bifoldl =>
         fun
           (L) ->
             fun
               (_) ->
                 fun
                   (U) ->
                     fun
                       (V1) ->
                         ((V@2(L))(U))(V1)
                     end
                 end
             end
         end
       , bifoldMap =>
         fun
           (DictMonoid) ->
             begin
               FoldMap1 = V@1(DictMonoid),
               fun
                 (L) ->
                   fun
                     (_) ->
                       fun
                         (V1) ->
                           (FoldMap1(L))(V1)
                       end
                   end
               end
             end
         end
       },
    #{ bitraverse =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Traverse1 = DictTraversable@3(DictApplicative),
             fun
               (L) ->
                 fun
                   (_) ->
                     fun
                       (V1) ->
                         ((erlang:map_get(
                             map,
                             (erlang:map_get(
                                'Functor0',
                                DictApplicative@1(undefined)
                              ))
                             (undefined)
                           ))
                          (data_functor_clown@ps:'Clown'()))
                         ((Traverse1(L))(V1))
                     end
                 end
             end
           end
       end
     , bisequence =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Sequence1 = DictTraversable@2(DictApplicative),
             fun
               (V@4) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined)
                   ))
                  (data_functor_clown@ps:'Clown'()))
                 (Sequence1(V@4))
             end
           end
       end
     , 'Bifunctor0' =>
       fun
         (_) ->
           BifunctorClown
       end
     , 'Bifoldable1' =>
       fun
         (_) ->
           BifoldableClown
       end
     }
  end.

bisequenceDefault() ->
  fun
    (DictBitraversable) ->
      fun
        (DictApplicative) ->
          bisequenceDefault(DictBitraversable, DictApplicative)
      end
  end.

bisequenceDefault(#{ bitraverse := DictBitraversable }, DictApplicative) ->
  begin
    V = identity(),
    ((DictBitraversable(DictApplicative))(V))(V)
  end.

bisequence() ->
  fun
    (Dict) ->
      bisequence(Dict)
  end.

bisequence(#{ bisequence := Dict }) ->
  Dict.

bitraversableFlip() ->
  fun
    (DictBitraversable) ->
      bitraversableFlip(DictBitraversable)
  end.

bitraversableFlip(#{ 'Bifoldable1' := DictBitraversable
                   , 'Bifunctor0' := DictBitraversable@1
                   , bisequence := DictBitraversable@2
                   , bitraverse := DictBitraversable@3
                   }) ->
  begin
    #{ bimap := V } = DictBitraversable@1(undefined),
    BifunctorFlip =
      #{ bimap =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (V@1) ->
                     ((V(G))(F))(V@1)
                 end
             end
         end
       },
    #{ bifoldMap := V@1, bifoldl := V@2, bifoldr := V@3 } =
      DictBitraversable(undefined),
    BifoldableFlip =
      #{ bifoldr =>
         fun
           (R) ->
             fun
               (L) ->
                 fun
                   (U) ->
                     fun
                       (V@4) ->
                         (((V@3(L))(R))(U))(V@4)
                     end
                 end
             end
         end
       , bifoldl =>
         fun
           (R) ->
             fun
               (L) ->
                 fun
                   (U) ->
                     fun
                       (V@4) ->
                         (((V@2(L))(R))(U))(V@4)
                     end
                 end
             end
         end
       , bifoldMap =>
         fun
           (DictMonoid) ->
             begin
               BifoldMap2 = V@1(DictMonoid),
               fun
                 (R) ->
                   fun
                     (L) ->
                       fun
                         (V@4) ->
                           ((BifoldMap2(L))(R))(V@4)
                       end
                   end
               end
             end
         end
       },
    #{ bitraverse =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Bitraverse2 = DictBitraversable@3(DictApplicative),
             fun
               (R) ->
                 fun
                   (L) ->
                     fun
                       (V@4) ->
                         ((erlang:map_get(
                             map,
                             (erlang:map_get(
                                'Functor0',
                                DictApplicative@1(undefined)
                              ))
                             (undefined)
                           ))
                          (data_functor_flip@ps:'Flip'()))
                         (((Bitraverse2(L))(R))(V@4))
                     end
                 end
             end
           end
       end
     , bisequence =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Bisequence2 = DictBitraversable@2(DictApplicative),
             fun
               (V@4) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined)
                   ))
                  (data_functor_flip@ps:'Flip'()))
                 (Bisequence2(V@4))
             end
           end
       end
     , 'Bifunctor0' =>
       fun
         (_) ->
           BifunctorFlip
       end
     , 'Bifoldable1' =>
       fun
         (_) ->
           BifoldableFlip
       end
     }
  end.

bitraversableProduct2() ->
  fun
    (DictBitraversable) ->
      bitraversableProduct2(DictBitraversable)
  end.

bitraversableProduct2(#{ 'Bifoldable1' := DictBitraversable
                       , 'Bifunctor0' := DictBitraversable@1
                       , bisequence := DictBitraversable@2
                       , bitraverse := DictBitraversable@3
                       }) ->
  begin
    #{ bimap := V } = DictBitraversable@1(undefined),
    BifoldableProduct2 =
      (data_bifoldable@ps:bifoldableProduct2())(DictBitraversable(undefined)),
    fun
      (#{ 'Bifoldable1' := DictBitraversable1
        , 'Bifunctor0' := DictBitraversable1@1
        , bisequence := DictBitraversable1@2
        , bitraverse := DictBitraversable1@3
        }) ->
        begin
          #{ bimap := V@1 } = DictBitraversable1@1(undefined),
          BifunctorProduct21 =
            #{ bimap =>
               fun
                 (F) ->
                   fun
                     (G) ->
                       fun
                         (V@2) ->
                           { product2
                           , ((V(F))(G))(erlang:element(2, V@2))
                           , ((V@1(F))(G))(erlang:element(3, V@2))
                           }
                       end
                   end
               end
             },
          BifoldableProduct21 =
            BifoldableProduct2(DictBitraversable1(undefined)),
          #{ bitraverse =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   #{ 'Functor0' := Apply0, apply := Apply0@1 } =
                     DictApplicative@1(undefined),
                   Bitraverse3 = DictBitraversable@3(DictApplicative),
                   Bitraverse4 = DictBitraversable1@3(DictApplicative),
                   fun
                     (L) ->
                       fun
                         (R) ->
                           fun
                             (V@2) ->
                               (Apply0@1(((erlang:map_get(
                                             map,
                                             Apply0(undefined)
                                           ))
                                          (data_functor_product2@ps:'Product2'()))
                                         (((Bitraverse3(L))(R))
                                          (erlang:element(2, V@2)))))
                               (((Bitraverse4(L))(R))(erlang:element(3, V@2)))
                           end
                       end
                   end
                 end
             end
           , bisequence =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   #{ 'Functor0' := Apply0, apply := Apply0@1 } =
                     DictApplicative@1(undefined),
                   Bisequence3 = DictBitraversable@2(DictApplicative),
                   Bisequence4 = DictBitraversable1@2(DictApplicative),
                   fun
                     (V@2) ->
                       (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                                  (data_functor_product2@ps:'Product2'()))
                                 (Bisequence3(erlang:element(2, V@2)))))
                       (Bisequence4(erlang:element(3, V@2)))
                   end
                 end
             end
           , 'Bifunctor0' =>
             fun
               (_) ->
                 BifunctorProduct21
             end
           , 'Bifoldable1' =>
             fun
               (_) ->
                 BifoldableProduct21
             end
           }
        end
    end
  end.

bitraverseDefault() ->
  fun
    (DictBitraversable) ->
      fun
        (DictApplicative) ->
          bitraverseDefault(DictBitraversable, DictApplicative)
      end
  end.

bitraverseDefault( #{ 'Bifunctor0' := DictBitraversable
                    , bisequence := DictBitraversable@1
                    }
                 , DictApplicative
                 ) ->
  begin
    Bisequence2 = DictBitraversable@1(DictApplicative),
    fun
      (F) ->
        fun
          (G) ->
            fun
              (T) ->
                Bisequence2((((erlang:map_get(
                                 bimap,
                                 DictBitraversable(undefined)
                               ))
                              (F))
                             (G))
                            (T))
            end
        end
    end
  end.

bifor() ->
  fun
    (DictBitraversable) ->
      fun
        (DictApplicative) ->
          bifor(DictBitraversable, DictApplicative)
      end
  end.

bifor(#{ bitraverse := DictBitraversable }, DictApplicative) ->
  begin
    Bitraverse2 = DictBitraversable(DictApplicative),
    fun
      (T) ->
        fun
          (F) ->
            fun
              (G) ->
                ((Bitraverse2(F))(G))(T)
            end
        end
    end
  end.

