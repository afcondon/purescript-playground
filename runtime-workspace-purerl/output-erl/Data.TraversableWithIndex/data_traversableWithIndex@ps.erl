-module(data_traversableWithIndex@ps).
-export([ traverseWithIndexDefault/0
        , traverseWithIndexDefault/2
        , traverseWithIndex/0
        , traverseWithIndex/1
        , traverseDefault/0
        , traverseDefault/2
        , traversableWithIndexTuple/0
        , traversableWithIndexProduct/0
        , traversableWithIndexProduct/1
        , traversableWithIndexMultiplicative/0
        , traversableWithIndexMaybe/0
        , traversableWithIndexLast/0
        , traversableWithIndexIdentity/0
        , traversableWithIndexFirst/0
        , traversableWithIndexEither/0
        , traversableWithIndexDual/0
        , traversableWithIndexDisj/0
        , traversableWithIndexCoproduct/0
        , traversableWithIndexCoproduct/1
        , traversableWithIndexConst/0
        , traversableWithIndexConj/0
        , traversableWithIndexCompose/0
        , traversableWithIndexCompose/1
        , traversableWithIndexArray/0
        , traversableWithIndexApp/0
        , traversableWithIndexApp/1
        , traversableWithIndexAdditive/0
        , mapAccumRWithIndex/0
        , mapAccumRWithIndex/1
        , scanrWithIndex/0
        , scanrWithIndex/1
        , mapAccumLWithIndex/0
        , mapAccumLWithIndex/1
        , scanlWithIndex/0
        , scanlWithIndex/1
        , forWithIndex/0
        , forWithIndex/2
        ]).
-compile(no_auto_import).
traverseWithIndexDefault() ->
  fun
    (DictTraversableWithIndex) ->
      fun
        (DictApplicative) ->
          traverseWithIndexDefault(DictTraversableWithIndex, DictApplicative)
      end
  end.

traverseWithIndexDefault( #{ 'FunctorWithIndex0' := DictTraversableWithIndex
                           , 'Traversable2' := DictTraversableWithIndex@1
                           }
                        , DictApplicative
                        ) ->
  begin
    Sequence1 =
      (erlang:map_get(sequence, DictTraversableWithIndex@1(undefined)))
      (DictApplicative),
    fun
      (F) ->
        begin
          V =
            (erlang:map_get(mapWithIndex, DictTraversableWithIndex(undefined)))
            (F),
          fun
            (X) ->
              Sequence1(V(X))
          end
        end
    end
  end.

traverseWithIndex() ->
  fun
    (Dict) ->
      traverseWithIndex(Dict)
  end.

traverseWithIndex(#{ traverseWithIndex := Dict }) ->
  Dict.

traverseDefault() ->
  fun
    (DictTraversableWithIndex) ->
      fun
        (DictApplicative) ->
          traverseDefault(DictTraversableWithIndex, DictApplicative)
      end
  end.

traverseDefault( #{ traverseWithIndex := DictTraversableWithIndex }
               , DictApplicative
               ) ->
  begin
    TraverseWithIndex2 = DictTraversableWithIndex(DictApplicative),
    fun
      (F) ->
        TraverseWithIndex2(fun
          (_) ->
            F
        end)
    end
  end.

traversableWithIndexTuple() ->
  #{ traverseWithIndex =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (F) ->
             fun
               (V) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative(undefined)))
                     (undefined)
                   ))
                  ((data_tuple@ps:'Tuple'())(erlang:element(2, V))))
                 ((F(unit))(erlang:element(3, V)))
             end
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexTuple()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexTuple()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableTuple()
     end
   }.

traversableWithIndexProduct() ->
  fun
    (DictTraversableWithIndex) ->
      traversableWithIndexProduct(DictTraversableWithIndex)
  end.

traversableWithIndexProduct(#{ 'FoldableWithIndex1' := DictTraversableWithIndex
                             , 'FunctorWithIndex0' := DictTraversableWithIndex@1
                             , 'Traversable2' := DictTraversableWithIndex@2
                             , traverseWithIndex := DictTraversableWithIndex@3
                             }) ->
  begin
    #{ 'Functor0' := V, mapWithIndex := V@1 } =
      DictTraversableWithIndex@1(undefined),
    #{ map := V@2 } = V(undefined),
    FoldableWithIndexProduct =
      data_foldableWithIndex@ps:foldableWithIndexProduct(DictTraversableWithIndex(undefined)),
    TraversableProduct =
      data_traversable@ps:traversableProduct(DictTraversableWithIndex@2(undefined)),
    fun
      (#{ 'FoldableWithIndex1' := DictTraversableWithIndex1
        , 'FunctorWithIndex0' := DictTraversableWithIndex1@1
        , 'Traversable2' := DictTraversableWithIndex1@2
        , traverseWithIndex := DictTraversableWithIndex1@3
        }) ->
        begin
          #{ 'Functor0' := V@3, mapWithIndex := V@4 } =
            DictTraversableWithIndex1@1(undefined),
          #{ map := V@5 } = V@3(undefined),
          FunctorWithIndexProduct1 =
            begin
              FunctorProduct1 =
                #{ map =>
                   fun
                     (F) ->
                       fun
                         (V@6) ->
                           { tuple
                           , (V@2(F))(erlang:element(2, V@6))
                           , (V@5(F))(erlang:element(3, V@6))
                           }
                       end
                   end
                 },
              #{ mapWithIndex =>
                 fun
                   (F) ->
                     fun
                       (V@6) ->
                         { tuple
                         , (V@1(fun
                              (X) ->
                                F({left, X})
                            end))
                           (erlang:element(2, V@6))
                         , (V@4(fun
                              (X) ->
                                F({right, X})
                            end))
                           (erlang:element(3, V@6))
                         }
                     end
                 end
               , 'Functor0' =>
                 fun
                   (_) ->
                     FunctorProduct1
                 end
               }
            end,
          FoldableWithIndexProduct1 =
            FoldableWithIndexProduct(DictTraversableWithIndex1(undefined)),
          TraversableProduct1 =
            TraversableProduct(DictTraversableWithIndex1@2(undefined)),
          #{ traverseWithIndex =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   #{ 'Functor0' := V@6, apply := V@7 } =
                     DictApplicative@1(undefined),
                   TraverseWithIndex3 =
                     DictTraversableWithIndex@3(DictApplicative),
                   TraverseWithIndex4 =
                     DictTraversableWithIndex1@3(DictApplicative),
                   fun
                     (F) ->
                       fun
                         (V@8) ->
                           (V@7(((erlang:map_get(map, V@6(undefined)))
                                 (data_functor_product@ps:product()))
                                ((TraverseWithIndex3(fun
                                    (X) ->
                                      F({left, X})
                                  end))
                                 (erlang:element(2, V@8)))))
                           ((TraverseWithIndex4(fun
                               (X) ->
                                 F({right, X})
                             end))
                            (erlang:element(3, V@8)))
                       end
                   end
                 end
             end
           , 'FunctorWithIndex0' =>
             fun
               (_) ->
                 FunctorWithIndexProduct1
             end
           , 'FoldableWithIndex1' =>
             fun
               (_) ->
                 FoldableWithIndexProduct1
             end
           , 'Traversable2' =>
             fun
               (_) ->
                 TraversableProduct1
             end
           }
        end
    end
  end.

traversableWithIndexMultiplicative() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (F) ->
             ((erlang:map_get(
                 traverse,
                 data_traversable@ps:traversableMultiplicative()
               ))
              (DictApplicative))
             (F(unit))
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexMultiplicative()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexMultiplicative()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableMultiplicative()
     end
   }.

traversableWithIndexMaybe() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (F) ->
             ((erlang:map_get(traverse, data_traversable@ps:traversableMaybe()))
              (DictApplicative))
             (F(unit))
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexMaybe()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexMaybe()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableMaybe()
     end
   }.

traversableWithIndexLast() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (F) ->
             ((erlang:map_get(traverse, data_traversable@ps:traversableLast()))
              (DictApplicative))
             (F(unit))
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexLast()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexLast()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableLast()
     end
   }.

traversableWithIndexIdentity() ->
  #{ traverseWithIndex =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (F) ->
             fun
               (V) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative(undefined)))
                     (undefined)
                   ))
                  (data_identity@ps:'Identity'()))
                 ((F(unit))(V))
             end
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexIdentity()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexIdentity()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableIdentity()
     end
   }.

traversableWithIndexFirst() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (F) ->
             ((erlang:map_get(traverse, data_traversable@ps:traversableFirst()))
              (DictApplicative))
             (F(unit))
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexFirst()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexFirst()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableFirst()
     end
   }.

traversableWithIndexEither() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (V) ->
             fun
               (V1) ->
                 case V1 of
                   {left, V1@1} ->
                     (erlang:map_get(pure, DictApplicative))({left, V1@1});
                   {right, V1@2} ->
                     ((erlang:map_get(
                         map,
                         (erlang:map_get(
                            'Functor0',
                            (erlang:map_get('Apply0', DictApplicative))
                            (undefined)
                          ))
                         (undefined)
                       ))
                      (data_either@ps:'Right'()))
                     ((V(unit))(V1@2));
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexEither()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexEither()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableEither()
     end
   }.

traversableWithIndexDual() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (F) ->
             ((erlang:map_get(traverse, data_traversable@ps:traversableDual()))
              (DictApplicative))
             (F(unit))
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexDual()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexDual()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableDual()
     end
   }.

traversableWithIndexDisj() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (F) ->
             ((erlang:map_get(traverse, data_traversable@ps:traversableDisj()))
              (DictApplicative))
             (F(unit))
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexDisj()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexDisj()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableDisj()
     end
   }.

traversableWithIndexCoproduct() ->
  fun
    (DictTraversableWithIndex) ->
      traversableWithIndexCoproduct(DictTraversableWithIndex)
  end.

traversableWithIndexCoproduct(#{ 'FoldableWithIndex1' :=
                                 DictTraversableWithIndex
                               , 'FunctorWithIndex0' :=
                                 DictTraversableWithIndex@1
                               , 'Traversable2' := DictTraversableWithIndex@2
                               , traverseWithIndex := DictTraversableWithIndex@3
                               }) ->
  begin
    FunctorWithIndexCoproduct =
      data_functorWithIndex@ps:functorWithIndexCoproduct(DictTraversableWithIndex@1(undefined)),
    FoldableWithIndexCoproduct =
      data_foldableWithIndex@ps:foldableWithIndexCoproduct(DictTraversableWithIndex(undefined)),
    TraversableCoproduct =
      data_traversable@ps:traversableCoproduct(DictTraversableWithIndex@2(undefined)),
    fun
      (#{ 'FoldableWithIndex1' := DictTraversableWithIndex1
        , 'FunctorWithIndex0' := DictTraversableWithIndex1@1
        , 'Traversable2' := DictTraversableWithIndex1@2
        , traverseWithIndex := DictTraversableWithIndex1@3
        }) ->
        begin
          FunctorWithIndexCoproduct1 =
            FunctorWithIndexCoproduct(DictTraversableWithIndex1@1(undefined)),
          FoldableWithIndexCoproduct1 =
            FoldableWithIndexCoproduct(DictTraversableWithIndex1(undefined)),
          TraversableCoproduct1 =
            TraversableCoproduct(DictTraversableWithIndex1@2(undefined)),
          #{ traverseWithIndex =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   #{ map := V } =
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined),
                   TraverseWithIndex3 =
                     DictTraversableWithIndex@3(DictApplicative),
                   TraverseWithIndex4 =
                     DictTraversableWithIndex1@3(DictApplicative),
                   fun
                     (F) ->
                       begin
                         V@1 =
                           V(fun
                             (X) ->
                               {left, X}
                           end),
                         V@2 =
                           TraverseWithIndex3(fun
                             (X) ->
                               F({left, X})
                           end),
                         V@3 =
                           V(fun
                             (X) ->
                               {right, X}
                           end),
                         V@4 =
                           TraverseWithIndex4(fun
                             (X) ->
                               F({right, X})
                           end),
                         fun
                           (V2) ->
                             case V2 of
                               {left, V2@1} ->
                                 V@1(V@2(V2@1));
                               {right, V2@2} ->
                                 V@3(V@4(V2@2));
                               _ ->
                                 erlang:error({fail, <<"Failed pattern match">>})
                             end
                         end
                       end
                   end
                 end
             end
           , 'FunctorWithIndex0' =>
             fun
               (_) ->
                 FunctorWithIndexCoproduct1
             end
           , 'FoldableWithIndex1' =>
             fun
               (_) ->
                 FoldableWithIndexCoproduct1
             end
           , 'Traversable2' =>
             fun
               (_) ->
                 TraversableCoproduct1
             end
           }
        end
    end
  end.

traversableWithIndexConst() ->
  #{ traverseWithIndex =>
     fun
       (#{ pure := DictApplicative }) ->
         fun
           (_) ->
             fun
               (V1) ->
                 DictApplicative(V1)
             end
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexConst()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexConst()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableConst()
     end
   }.

traversableWithIndexConj() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (F) ->
             ((erlang:map_get(traverse, data_traversable@ps:traversableConj()))
              (DictApplicative))
             (F(unit))
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexConj()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexConj()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableConj()
     end
   }.

traversableWithIndexCompose() ->
  fun
    (DictTraversableWithIndex) ->
      traversableWithIndexCompose(DictTraversableWithIndex)
  end.

traversableWithIndexCompose(#{ 'FoldableWithIndex1' := DictTraversableWithIndex
                             , 'FunctorWithIndex0' := DictTraversableWithIndex@1
                             , 'Traversable2' := DictTraversableWithIndex@2
                             , traverseWithIndex := DictTraversableWithIndex@3
                             }) ->
  begin
    #{ 'Functor0' := V, mapWithIndex := V@1 } =
      DictTraversableWithIndex@1(undefined),
    #{ map := V@2 } = V(undefined),
    FoldableWithIndexCompose =
      data_foldableWithIndex@ps:foldableWithIndexCompose(DictTraversableWithIndex(undefined)),
    TraversableCompose =
      data_traversable@ps:traversableCompose(DictTraversableWithIndex@2(undefined)),
    fun
      (#{ 'FoldableWithIndex1' := DictTraversableWithIndex1
        , 'FunctorWithIndex0' := DictTraversableWithIndex1@1
        , 'Traversable2' := DictTraversableWithIndex1@2
        , traverseWithIndex := DictTraversableWithIndex1@3
        }) ->
        begin
          #{ 'Functor0' := V@3, mapWithIndex := V@4 } =
            DictTraversableWithIndex1@1(undefined),
          #{ map := V@5 } = V@3(undefined),
          FunctorWithIndexCompose1 =
            begin
              FunctorCompose1 =
                #{ map =>
                   fun
                     (F) ->
                       fun
                         (V@6) ->
                           (V@2(V@5(F)))(V@6)
                       end
                   end
                 },
              #{ mapWithIndex =>
                 fun
                   (F) ->
                     fun
                       (V@6) ->
                         (V@1(fun
                            (X) ->
                              V@4(fun
                                (B) ->
                                  F({tuple, X, B})
                              end)
                          end))
                         (V@6)
                     end
                 end
               , 'Functor0' =>
                 fun
                   (_) ->
                     FunctorCompose1
                 end
               }
            end,
          FoldableWithIndexCompose1 =
            FoldableWithIndexCompose(DictTraversableWithIndex1(undefined)),
          TraversableCompose1 =
            TraversableCompose(DictTraversableWithIndex1@2(undefined)),
          #{ traverseWithIndex =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   TraverseWithIndex3 =
                     DictTraversableWithIndex@3(DictApplicative),
                   TraverseWithIndex4 =
                     DictTraversableWithIndex1@3(DictApplicative),
                   fun
                     (F) ->
                       fun
                         (V@6) ->
                           ((erlang:map_get(
                               map,
                               (erlang:map_get(
                                  'Functor0',
                                  DictApplicative@1(undefined)
                                ))
                               (undefined)
                             ))
                            (data_functor_compose@ps:'Compose'()))
                           ((TraverseWithIndex3(fun
                               (X) ->
                                 TraverseWithIndex4(fun
                                   (B) ->
                                     F({tuple, X, B})
                                 end)
                             end))
                            (V@6))
                       end
                   end
                 end
             end
           , 'FunctorWithIndex0' =>
             fun
               (_) ->
                 FunctorWithIndexCompose1
             end
           , 'FoldableWithIndex1' =>
             fun
               (_) ->
                 FoldableWithIndexCompose1
             end
           , 'Traversable2' =>
             fun
               (_) ->
                 TraversableCompose1
             end
           }
        end
    end
  end.

traversableWithIndexArray() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         begin
           Sequence1 =
             (erlang:map_get(
                sequence,
                (erlang:map_get('Traversable2', traversableWithIndexArray()))
                (undefined)
              ))
             (DictApplicative),
           fun
             (F) ->
               begin
                 V =
                   (erlang:map_get(
                      mapWithIndex,
                      (erlang:map_get(
                         'FunctorWithIndex0',
                         traversableWithIndexArray()
                       ))
                      (undefined)
                    ))
                   (F),
                 fun
                   (X) ->
                     Sequence1(V(X))
                 end
               end
           end
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexArray()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexArray()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableArray()
     end
   }.

traversableWithIndexApp() ->
  fun
    (DictTraversableWithIndex) ->
      traversableWithIndexApp(DictTraversableWithIndex)
  end.

traversableWithIndexApp(#{ 'FoldableWithIndex1' := DictTraversableWithIndex
                         , 'FunctorWithIndex0' := DictTraversableWithIndex@1
                         , 'Traversable2' := DictTraversableWithIndex@2
                         , traverseWithIndex := DictTraversableWithIndex@3
                         }) ->
  begin
    #{ 'Functor0' := V, mapWithIndex := V@1 } =
      DictTraversableWithIndex@1(undefined),
    V@2 = V(undefined),
    FunctorWithIndexApp =
      #{ mapWithIndex =>
         fun
           (F) ->
             fun
               (V@3) ->
                 (V@1(F))(V@3)
             end
         end
       , 'Functor0' =>
         fun
           (_) ->
             V@2
         end
       },
    #{ 'Foldable0' := V@3
     , foldMapWithIndex := V@4
     , foldlWithIndex := V@5
     , foldrWithIndex := V@6
     } =
      DictTraversableWithIndex(undefined),
    #{ foldMap := V@7, foldl := V@8, foldr := V@9 } = V@3(undefined),
    FoldableWithIndexApp =
      begin
        FoldableApp =
          #{ foldr =>
             fun
               (F) ->
                 fun
                   (I) ->
                     fun
                       (V@10) ->
                         ((V@9(F))(I))(V@10)
                     end
                 end
             end
           , foldl =>
             fun
               (F) ->
                 fun
                   (I) ->
                     fun
                       (V@10) ->
                         ((V@8(F))(I))(V@10)
                     end
                 end
             end
           , foldMap =>
             fun
               (DictMonoid) ->
                 V@7(DictMonoid)
             end
           },
        #{ foldrWithIndex =>
           fun
             (F) ->
               fun
                 (Z) ->
                   fun
                     (V@10) ->
                       ((V@6(F))(Z))(V@10)
                   end
               end
           end
         , foldlWithIndex =>
           fun
             (F) ->
               fun
                 (Z) ->
                   fun
                     (V@10) ->
                       ((V@5(F))(Z))(V@10)
                   end
               end
           end
         , foldMapWithIndex =>
           fun
             (DictMonoid) ->
               V@4(DictMonoid)
           end
         , 'Foldable0' =>
           fun
             (_) ->
               FoldableApp
           end
         }
      end,
    TraversableApp =
      data_traversable@ps:traversableApp(DictTraversableWithIndex@2(undefined)),
    #{ traverseWithIndex =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             TraverseWithIndex2 = DictTraversableWithIndex@3(DictApplicative),
             fun
               (F) ->
                 fun
                   (V@10) ->
                     ((erlang:map_get(
                         map,
                         (erlang:map_get(
                            'Functor0',
                            DictApplicative@1(undefined)
                          ))
                         (undefined)
                       ))
                      (data_functor_app@ps:'App'()))
                     ((TraverseWithIndex2(F))(V@10))
                 end
             end
           end
       end
     , 'FunctorWithIndex0' =>
       fun
         (_) ->
           FunctorWithIndexApp
       end
     , 'FoldableWithIndex1' =>
       fun
         (_) ->
           FoldableWithIndexApp
       end
     , 'Traversable2' =>
       fun
         (_) ->
           TraversableApp
       end
     }
  end.

traversableWithIndexAdditive() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (F) ->
             ((erlang:map_get(
                 traverse,
                 data_traversable@ps:traversableAdditive()
               ))
              (DictApplicative))
             (F(unit))
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         data_functorWithIndex@ps:functorWithIndexAdditive()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         data_foldableWithIndex@ps:foldableWithIndexAdditive()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         data_traversable@ps:traversableAdditive()
     end
   }.

mapAccumRWithIndex() ->
  fun
    (DictTraversableWithIndex) ->
      mapAccumRWithIndex(DictTraversableWithIndex)
  end.

mapAccumRWithIndex(#{ traverseWithIndex := DictTraversableWithIndex }) ->
  begin
    TraverseWithIndex1 =
      DictTraversableWithIndex(data_traversable_accum_internal@ps:applicativeStateR()),
    fun
      (F) ->
        fun
          (S0) ->
            fun
              (Xs) ->
                ((TraverseWithIndex1(fun
                    (I) ->
                      fun
                        (A) ->
                          fun
                            (S) ->
                              ((F(I))(S))(A)
                          end
                      end
                  end))
                 (Xs))
                (S0)
            end
        end
    end
  end.

scanrWithIndex() ->
  fun
    (DictTraversableWithIndex) ->
      scanrWithIndex(DictTraversableWithIndex)
  end.

scanrWithIndex(DictTraversableWithIndex) ->
  begin
    MapAccumRWithIndex1 = mapAccumRWithIndex(DictTraversableWithIndex),
    fun
      (F) ->
        fun
          (B0) ->
            fun
              (Xs) ->
                erlang:map_get(
                  value,
                  ((MapAccumRWithIndex1(fun
                      (I) ->
                        fun
                          (B) ->
                            fun
                              (A) ->
                                begin
                                  B_ = ((F(I))(A))(B),
                                  #{ accum => B_, value => B_ }
                                end
                            end
                        end
                    end))
                   (B0))
                  (Xs)
                )
            end
        end
    end
  end.

mapAccumLWithIndex() ->
  fun
    (DictTraversableWithIndex) ->
      mapAccumLWithIndex(DictTraversableWithIndex)
  end.

mapAccumLWithIndex(#{ traverseWithIndex := DictTraversableWithIndex }) ->
  begin
    TraverseWithIndex1 =
      DictTraversableWithIndex(data_traversable_accum_internal@ps:applicativeStateL()),
    fun
      (F) ->
        fun
          (S0) ->
            fun
              (Xs) ->
                ((TraverseWithIndex1(fun
                    (I) ->
                      fun
                        (A) ->
                          fun
                            (S) ->
                              ((F(I))(S))(A)
                          end
                      end
                  end))
                 (Xs))
                (S0)
            end
        end
    end
  end.

scanlWithIndex() ->
  fun
    (DictTraversableWithIndex) ->
      scanlWithIndex(DictTraversableWithIndex)
  end.

scanlWithIndex(DictTraversableWithIndex) ->
  begin
    MapAccumLWithIndex1 = mapAccumLWithIndex(DictTraversableWithIndex),
    fun
      (F) ->
        fun
          (B0) ->
            fun
              (Xs) ->
                erlang:map_get(
                  value,
                  ((MapAccumLWithIndex1(fun
                      (I) ->
                        fun
                          (B) ->
                            fun
                              (A) ->
                                begin
                                  B_ = ((F(I))(B))(A),
                                  #{ accum => B_, value => B_ }
                                end
                            end
                        end
                    end))
                   (B0))
                  (Xs)
                )
            end
        end
    end
  end.

forWithIndex() ->
  fun
    (DictApplicative) ->
      fun
        (DictTraversableWithIndex) ->
          forWithIndex(DictApplicative, DictTraversableWithIndex)
      end
  end.

forWithIndex( DictApplicative
            , #{ traverseWithIndex := DictTraversableWithIndex }
            ) ->
  begin
    V = DictTraversableWithIndex(DictApplicative),
    fun
      (B) ->
        fun
          (A) ->
            (V(A))(B)
        end
    end
  end.

