-module(data_foldableWithIndex@ps).
-export([ 'monoidEndo.semigroupEndo1'/0
        , monoidEndo/0
        , 'monoidDual.semigroupDual1'/0
        , monoidDual/0
        , foldrWithIndex/0
        , foldrWithIndex/1
        , traverseWithIndex_/0
        , traverseWithIndex_/1
        , forWithIndex_/0
        , forWithIndex_/1
        , foldrDefault/0
        , foldrDefault/2
        , foldlWithIndex/0
        , foldlWithIndex/1
        , foldlDefault/0
        , foldlDefault/2
        , foldableWithIndexTuple/0
        , foldableWithIndexMultiplicative/0
        , foldableWithIndexMaybe/0
        , foldableWithIndexLast/0
        , foldableWithIndexIdentity/0
        , foldableWithIndexFirst/0
        , foldableWithIndexEither/0
        , foldableWithIndexDual/0
        , foldableWithIndexDisj/0
        , foldableWithIndexConst/0
        , foldableWithIndexConj/0
        , foldableWithIndexAdditive/0
        , foldWithIndexM/0
        , foldWithIndexM/4
        , foldMapWithIndexDefaultR/0
        , foldMapWithIndexDefaultR/2
        , foldableWithIndexArray/0
        , foldMapWithIndexDefaultL/0
        , foldMapWithIndexDefaultL/2
        , foldMapWithIndex/0
        , foldMapWithIndex/1
        , foldableWithIndexApp/0
        , foldableWithIndexApp/1
        , foldableWithIndexCompose/0
        , foldableWithIndexCompose/1
        , foldableWithIndexCoproduct/0
        , foldableWithIndexCoproduct/1
        , foldableWithIndexProduct/0
        , foldableWithIndexProduct/1
        , foldlWithIndexDefault/0
        , foldlWithIndexDefault/1
        , foldrWithIndexDefault/0
        , foldrWithIndexDefault/1
        , surroundMapWithIndex/0
        , surroundMapWithIndex/1
        , foldMapDefault/0
        , foldMapDefault/2
        , findWithIndex/0
        , findWithIndex/2
        , findMapWithIndex/0
        , findMapWithIndex/2
        , anyWithIndex/0
        , anyWithIndex/2
        , allWithIndex/0
        , allWithIndex/2
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'monoidEndo.semigroupEndo1'() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (X) ->
                 V(V1(X))
             end
         end
     end
   }.

monoidEndo() ->
  #{ mempty =>
     fun
       (X) ->
         X
     end
   , 'Semigroup0' =>
     fun
       (_) ->
         'monoidEndo.semigroupEndo1'()
     end
   }.

'monoidDual.semigroupDual1'() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (X) ->
                 V1(V(X))
             end
         end
     end
   }.

monoidDual() ->
  #{ mempty => erlang:map_get(mempty, monoidEndo())
   , 'Semigroup0' =>
     fun
       (_) ->
         'monoidDual.semigroupDual1'()
     end
   }.

foldrWithIndex() ->
  fun
    (Dict) ->
      foldrWithIndex(Dict)
  end.

foldrWithIndex(#{ foldrWithIndex := Dict }) ->
  Dict.

traverseWithIndex_() ->
  fun
    (DictApplicative) ->
      traverseWithIndex_(DictApplicative)
  end.

traverseWithIndex_(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    fun
      (#{ foldrWithIndex := DictFoldableWithIndex }) ->
        fun
          (F) ->
            (DictFoldableWithIndex(fun
               (I) ->
                 begin
                   V@2 = F(I),
                   fun
                     (X) ->
                       begin
                         V@3 = V@2(X),
                         fun
                           (B) ->
                             (V@1(((erlang:map_get(map, V(undefined)))
                                   (fun
                                     (_) ->
                                       control_apply@ps:identity()
                                   end))
                                  (V@3)))
                             (B)
                         end
                       end
                   end
                 end
             end))
            (DictApplicative@1(unit))
        end
    end
  end.

forWithIndex_() ->
  fun
    (DictApplicative) ->
      forWithIndex_(DictApplicative)
  end.

forWithIndex_(DictApplicative) ->
  begin
    TraverseWithIndex_1 = traverseWithIndex_(DictApplicative),
    fun
      (DictFoldableWithIndex) ->
        begin
          V = TraverseWithIndex_1(DictFoldableWithIndex),
          fun
            (B) ->
              fun
                (A) ->
                  (V(A))(B)
              end
          end
        end
    end
  end.

foldrDefault() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (F) ->
          foldrDefault(DictFoldableWithIndex, F)
      end
  end.

foldrDefault(#{ foldrWithIndex := DictFoldableWithIndex }, F) ->
  DictFoldableWithIndex(fun
    (_) ->
      F
  end).

foldlWithIndex() ->
  fun
    (Dict) ->
      foldlWithIndex(Dict)
  end.

foldlWithIndex(#{ foldlWithIndex := Dict }) ->
  Dict.

foldlDefault() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (F) ->
          foldlDefault(DictFoldableWithIndex, F)
      end
  end.

foldlDefault(#{ foldlWithIndex := DictFoldableWithIndex }, F) ->
  DictFoldableWithIndex(fun
    (_) ->
      F
  end).

foldableWithIndexTuple() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 ((F(unit))(erlang:element(3, V)))(Z)
             end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 ((F(unit))(Z))(erlang:element(3, V))
             end
         end
     end
   , foldMapWithIndex =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (V) ->
                 (F(unit))(erlang:element(3, V))
             end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableTuple()
     end
   }.

foldableWithIndexMultiplicative() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (Z) ->
               fun
                 (V@1) ->
                   (V(V@1))(Z)
               end
           end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , foldMapWithIndex =>
     fun
       (_) ->
         fun
           (F) ->
             F(unit)
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableMultiplicative()
     end
   }.

foldableWithIndexMaybe() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (V1) ->
               fun
                 (V2) ->
                   case V2 of
                     {nothing} ->
                       V1;
                     {just, V2@1} ->
                       (V(V2@1))(V1);
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (V1) ->
               fun
                 (V2) ->
                   case V2 of
                     {nothing} ->
                       V1;
                     {just, V2@1} ->
                       (V(V1))(V2@1);
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
         end
     end
   , foldMapWithIndex =>
     fun
       (#{ mempty := DictMonoid }) ->
         fun
           (F) ->
             begin
               V = F(unit),
               fun
                 (V1) ->
                   case V1 of
                     {nothing} ->
                       DictMonoid;
                     {just, V1@1} ->
                       V(V1@1);
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
             end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableMaybe()
     end
   }.

foldableWithIndexLast() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (Z) ->
               fun
                 (V@1) ->
                   case V@1 of
                     {nothing} ->
                       Z;
                     {just, V@2} ->
                       (V(V@2))(Z);
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (Z) ->
               fun
                 (V@1) ->
                   case V@1 of
                     {nothing} ->
                       Z;
                     {just, V@2} ->
                       (V(Z))(V@2);
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
         end
     end
   , foldMapWithIndex =>
     fun
       (#{ mempty := DictMonoid }) ->
         fun
           (F) ->
             begin
               V = F(unit),
               fun
                 (V1) ->
                   case V1 of
                     {nothing} ->
                       DictMonoid;
                     {just, V1@1} ->
                       V(V1@1);
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
             end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableLast()
     end
   }.

foldableWithIndexIdentity() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 ((F(unit))(V))(Z)
             end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 ((F(unit))(Z))(V)
             end
         end
     end
   , foldMapWithIndex =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (V) ->
                 (F(unit))(V)
             end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableIdentity()
     end
   }.

foldableWithIndexFirst() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (Z) ->
               fun
                 (V@1) ->
                   case V@1 of
                     {nothing} ->
                       Z;
                     {just, V@2} ->
                       (V(V@2))(Z);
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (Z) ->
               fun
                 (V@1) ->
                   case V@1 of
                     {nothing} ->
                       Z;
                     {just, V@2} ->
                       (V(Z))(V@2);
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
         end
     end
   , foldMapWithIndex =>
     fun
       (#{ mempty := DictMonoid }) ->
         fun
           (F) ->
             begin
               V = F(unit),
               fun
                 (V1) ->
                   case V1 of
                     {nothing} ->
                       DictMonoid;
                     {just, V1@1} ->
                       V(V1@1);
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
             end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableFirst()
     end
   }.

foldableWithIndexEither() ->
  #{ foldrWithIndex =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (V2) ->
                 case V2 of
                   {left, _} ->
                     V1;
                   {right, V2@1} ->
                     ((V(unit))(V2@1))(V1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , foldlWithIndex =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (V2) ->
                 case V2 of
                   {left, _} ->
                     V1;
                   {right, V2@1} ->
                     ((V(unit))(V1))(V2@1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , foldMapWithIndex =>
     fun
       (#{ mempty := DictMonoid }) ->
         fun
           (V) ->
             fun
               (V1) ->
                 case V1 of
                   {left, _} ->
                     DictMonoid;
                   {right, V1@1} ->
                     (V(unit))(V1@1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableEither()
     end
   }.

foldableWithIndexDual() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (Z) ->
               fun
                 (V@1) ->
                   (V(V@1))(Z)
               end
           end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , foldMapWithIndex =>
     fun
       (_) ->
         fun
           (F) ->
             F(unit)
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableDual()
     end
   }.

foldableWithIndexDisj() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (Z) ->
               fun
                 (V@1) ->
                   (V(V@1))(Z)
               end
           end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , foldMapWithIndex =>
     fun
       (_) ->
         fun
           (F) ->
             F(unit)
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableDisj()
     end
   }.

foldableWithIndexConst() ->
  #{ foldrWithIndex =>
     fun
       (_) ->
         fun
           (Z) ->
             fun
               (_) ->
                 Z
             end
         end
     end
   , foldlWithIndex =>
     fun
       (_) ->
         fun
           (Z) ->
             fun
               (_) ->
                 Z
             end
         end
     end
   , foldMapWithIndex =>
     fun
       (#{ mempty := DictMonoid }) ->
         fun
           (_) ->
             fun
               (_) ->
                 DictMonoid
             end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableConst()
     end
   }.

foldableWithIndexConj() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (Z) ->
               fun
                 (V@1) ->
                   (V(V@1))(Z)
               end
           end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , foldMapWithIndex =>
     fun
       (_) ->
         fun
           (F) ->
             F(unit)
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableConj()
     end
   }.

foldableWithIndexAdditive() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (Z) ->
               fun
                 (V@1) ->
                   (V(V@1))(Z)
               end
           end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , foldMapWithIndex =>
     fun
       (_) ->
         fun
           (F) ->
             F(unit)
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableAdditive()
     end
   }.

foldWithIndexM() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (DictMonad) ->
          fun
            (F) ->
              fun
                (A0) ->
                  foldWithIndexM(DictFoldableWithIndex, DictMonad, F, A0)
              end
          end
      end
  end.

foldWithIndexM( #{ foldlWithIndex := DictFoldableWithIndex }
              , #{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }
              , F
              , A0
              ) ->
  (DictFoldableWithIndex(fun
     (I) ->
       fun
         (Ma) ->
           fun
             (B) ->
               ((erlang:map_get(bind, DictMonad@1(undefined)))(Ma))
               (begin
                 V = F(I),
                 fun
                   (A) ->
                     (V(A))(B)
                 end
               end)
           end
       end
   end))
  ((erlang:map_get(pure, DictMonad(undefined)))(A0)).

foldMapWithIndexDefaultR() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (DictMonoid) ->
          foldMapWithIndexDefaultR(DictFoldableWithIndex, DictMonoid)
      end
  end.

foldMapWithIndexDefaultR( #{ foldrWithIndex := DictFoldableWithIndex }
                        , #{ 'Semigroup0' := DictMonoid
                           , mempty := DictMonoid@1
                           }
                        ) ->
  fun
    (F) ->
      (DictFoldableWithIndex(fun
         (I) ->
           fun
             (X) ->
               fun
                 (Acc) ->
                   ((erlang:map_get(append, DictMonoid(undefined)))((F(I))(X)))
                   (Acc)
               end
           end
       end))
      (DictMonoid@1)
  end.

foldableWithIndexArray() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             begin
               V =
                 ((data_foldable@ps:foldrArray())
                  (fun
                    (V) ->
                      begin
                        V@1 = erlang:element(2, V),
                        V@2 = erlang:element(3, V),
                        fun
                          (Y) ->
                            ((F(V@1))(V@2))(Y)
                        end
                      end
                  end))
                 (Z),
               V@1 =
                 (data_functorWithIndex@ps:mapWithIndexArray())
                 (data_tuple@ps:'Tuple'()),
               fun
                 (X) ->
                   V(V@1(X))
               end
             end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             begin
               V =
                 ((data_foldable@ps:foldlArray())
                  (fun
                    (Y) ->
                      fun
                        (V) ->
                          ((F(erlang:element(2, V)))(Y))(erlang:element(3, V))
                      end
                  end))
                 (Z),
               V@1 =
                 (data_functorWithIndex@ps:mapWithIndexArray())
                 (data_tuple@ps:'Tuple'()),
               fun
                 (X) ->
                   V(V@1(X))
               end
             end
         end
     end
   , foldMapWithIndex =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         fun
           (F) ->
             ((erlang:map_get(foldrWithIndex, foldableWithIndexArray()))
              (fun
                (I) ->
                  fun
                    (X) ->
                      fun
                        (Acc) ->
                          ((erlang:map_get(append, DictMonoid(undefined)))
                           ((F(I))(X)))
                          (Acc)
                      end
                  end
              end))
             (DictMonoid@1)
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableArray()
     end
   }.

foldMapWithIndexDefaultL() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (DictMonoid) ->
          foldMapWithIndexDefaultL(DictFoldableWithIndex, DictMonoid)
      end
  end.

foldMapWithIndexDefaultL( #{ foldlWithIndex := DictFoldableWithIndex }
                        , #{ 'Semigroup0' := DictMonoid
                           , mempty := DictMonoid@1
                           }
                        ) ->
  fun
    (F) ->
      (DictFoldableWithIndex(fun
         (I) ->
           fun
             (Acc) ->
               fun
                 (X) ->
                   ((erlang:map_get(append, DictMonoid(undefined)))(Acc))
                   ((F(I))(X))
               end
           end
       end))
      (DictMonoid@1)
  end.

foldMapWithIndex() ->
  fun
    (Dict) ->
      foldMapWithIndex(Dict)
  end.

foldMapWithIndex(#{ foldMapWithIndex := Dict }) ->
  Dict.

foldableWithIndexApp() ->
  fun
    (DictFoldableWithIndex) ->
      foldableWithIndexApp(DictFoldableWithIndex)
  end.

foldableWithIndexApp(#{ 'Foldable0' := DictFoldableWithIndex
                      , foldMapWithIndex := DictFoldableWithIndex@1
                      , foldlWithIndex := DictFoldableWithIndex@2
                      , foldrWithIndex := DictFoldableWithIndex@3
                      }) ->
  begin
    #{ foldMap := V, foldl := V@1, foldr := V@2 } =
      DictFoldableWithIndex(undefined),
    FoldableApp =
      #{ foldr =>
         fun
           (F) ->
             fun
               (I) ->
                 fun
                   (V@3) ->
                     ((V@2(F))(I))(V@3)
                 end
             end
         end
       , foldl =>
         fun
           (F) ->
             fun
               (I) ->
                 fun
                   (V@3) ->
                     ((V@1(F))(I))(V@3)
                 end
             end
         end
       , foldMap =>
         fun
           (DictMonoid) ->
             V(DictMonoid)
         end
       },
    #{ foldrWithIndex =>
       fun
         (F) ->
           fun
             (Z) ->
               fun
                 (V@3) ->
                   ((DictFoldableWithIndex@3(F))(Z))(V@3)
               end
           end
       end
     , foldlWithIndex =>
       fun
         (F) ->
           fun
             (Z) ->
               fun
                 (V@3) ->
                   ((DictFoldableWithIndex@2(F))(Z))(V@3)
               end
           end
       end
     , foldMapWithIndex =>
       fun
         (DictMonoid) ->
           DictFoldableWithIndex@1(DictMonoid)
       end
     , 'Foldable0' =>
       fun
         (_) ->
           FoldableApp
       end
     }
  end.

foldableWithIndexCompose() ->
  fun
    (DictFoldableWithIndex) ->
      foldableWithIndexCompose(DictFoldableWithIndex)
  end.

foldableWithIndexCompose(#{ 'Foldable0' := DictFoldableWithIndex
                          , foldMapWithIndex := DictFoldableWithIndex@1
                          , foldlWithIndex := DictFoldableWithIndex@2
                          , foldrWithIndex := DictFoldableWithIndex@3
                          }) ->
  begin
    #{ foldMap := V, foldl := V@1, foldr := V@2 } =
      DictFoldableWithIndex(undefined),
    fun
      (#{ 'Foldable0' := DictFoldableWithIndex1
        , foldMapWithIndex := DictFoldableWithIndex1@1
        , foldlWithIndex := DictFoldableWithIndex1@2
        , foldrWithIndex := DictFoldableWithIndex1@3
        }) ->
        begin
          #{ foldMap := V@3, foldl := V@4, foldr := V@5 } =
            DictFoldableWithIndex1(undefined),
          FoldableCompose1 =
            #{ foldr =>
               fun
                 (F) ->
                   fun
                     (I) ->
                       fun
                         (V@6) ->
                           ((V@2(begin
                               V@7 = V@5(F),
                               fun
                                 (B) ->
                                   fun
                                     (A) ->
                                       (V@7(A))(B)
                                   end
                               end
                             end))
                            (I))
                           (V@6)
                       end
                   end
               end
             , foldl =>
               fun
                 (F) ->
                   fun
                     (I) ->
                       fun
                         (V@6) ->
                           ((V@1(V@4(F)))(I))(V@6)
                       end
                   end
               end
             , foldMap =>
               fun
                 (DictMonoid) ->
                   begin
                     FoldMap4 = V(DictMonoid),
                     FoldMap5 = V@3(DictMonoid),
                     fun
                       (F) ->
                         fun
                           (V@6) ->
                             (FoldMap4(FoldMap5(F)))(V@6)
                         end
                     end
                   end
               end
             },
          #{ foldrWithIndex =>
             fun
               (F) ->
                 fun
                   (I) ->
                     fun
                       (V@6) ->
                         ((DictFoldableWithIndex@3(fun
                             (A) ->
                               begin
                                 V@7 =
                                   DictFoldableWithIndex1@3(fun
                                     (B) ->
                                       F({tuple, A, B})
                                   end),
                                 fun
                                   (B) ->
                                     fun
                                       (A@1) ->
                                         (V@7(A@1))(B)
                                     end
                                 end
                               end
                           end))
                          (I))
                         (V@6)
                     end
                 end
             end
           , foldlWithIndex =>
             fun
               (F) ->
                 fun
                   (I) ->
                     fun
                       (V@6) ->
                         ((DictFoldableWithIndex@2(fun
                             (X) ->
                               DictFoldableWithIndex1@2(fun
                                 (B) ->
                                   F({tuple, X, B})
                               end)
                           end))
                          (I))
                         (V@6)
                     end
                 end
             end
           , foldMapWithIndex =>
             fun
               (DictMonoid) ->
                 begin
                   FoldMapWithIndex3 = DictFoldableWithIndex@1(DictMonoid),
                   FoldMapWithIndex4 = DictFoldableWithIndex1@1(DictMonoid),
                   fun
                     (F) ->
                       fun
                         (V@6) ->
                           (FoldMapWithIndex3(fun
                              (X) ->
                                FoldMapWithIndex4(fun
                                  (B) ->
                                    F({tuple, X, B})
                                end)
                            end))
                           (V@6)
                       end
                   end
                 end
             end
           , 'Foldable0' =>
             fun
               (_) ->
                 FoldableCompose1
             end
           }
        end
    end
  end.

foldableWithIndexCoproduct() ->
  fun
    (DictFoldableWithIndex) ->
      foldableWithIndexCoproduct(DictFoldableWithIndex)
  end.

foldableWithIndexCoproduct(#{ 'Foldable0' := DictFoldableWithIndex
                            , foldMapWithIndex := DictFoldableWithIndex@1
                            , foldlWithIndex := DictFoldableWithIndex@2
                            , foldrWithIndex := DictFoldableWithIndex@3
                            }) ->
  begin
    FoldableCoproduct =
      (data_foldable@ps:foldableCoproduct())(DictFoldableWithIndex(undefined)),
    fun
      (#{ 'Foldable0' := DictFoldableWithIndex1
        , foldMapWithIndex := DictFoldableWithIndex1@1
        , foldlWithIndex := DictFoldableWithIndex1@2
        , foldrWithIndex := DictFoldableWithIndex1@3
        }) ->
        begin
          FoldableCoproduct1 =
            FoldableCoproduct(DictFoldableWithIndex1(undefined)),
          #{ foldrWithIndex =>
             fun
               (F) ->
                 fun
                   (Z) ->
                     begin
                       V =
                         (DictFoldableWithIndex@3(fun
                            (X) ->
                              F({left, X})
                          end))
                         (Z),
                       V@1 =
                         (DictFoldableWithIndex1@3(fun
                            (X) ->
                              F({right, X})
                          end))
                         (Z),
                       fun
                         (V2) ->
                           case V2 of
                             {left, V2@1} ->
                               V(V2@1);
                             {right, V2@2} ->
                               V@1(V2@2);
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                       end
                     end
                 end
             end
           , foldlWithIndex =>
             fun
               (F) ->
                 fun
                   (Z) ->
                     begin
                       V =
                         (DictFoldableWithIndex@2(fun
                            (X) ->
                              F({left, X})
                          end))
                         (Z),
                       V@1 =
                         (DictFoldableWithIndex1@2(fun
                            (X) ->
                              F({right, X})
                          end))
                         (Z),
                       fun
                         (V2) ->
                           case V2 of
                             {left, V2@1} ->
                               V(V2@1);
                             {right, V2@2} ->
                               V@1(V2@2);
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                       end
                     end
                 end
             end
           , foldMapWithIndex =>
             fun
               (DictMonoid) ->
                 begin
                   FoldMapWithIndex3 = DictFoldableWithIndex@1(DictMonoid),
                   FoldMapWithIndex4 = DictFoldableWithIndex1@1(DictMonoid),
                   fun
                     (F) ->
                       begin
                         V =
                           FoldMapWithIndex3(fun
                             (X) ->
                               F({left, X})
                           end),
                         V@1 =
                           FoldMapWithIndex4(fun
                             (X) ->
                               F({right, X})
                           end),
                         fun
                           (V2) ->
                             case V2 of
                               {left, V2@1} ->
                                 V(V2@1);
                               {right, V2@2} ->
                                 V@1(V2@2);
                               _ ->
                                 erlang:error({fail, <<"Failed pattern match">>})
                             end
                         end
                       end
                   end
                 end
             end
           , 'Foldable0' =>
             fun
               (_) ->
                 FoldableCoproduct1
             end
           }
        end
    end
  end.

foldableWithIndexProduct() ->
  fun
    (DictFoldableWithIndex) ->
      foldableWithIndexProduct(DictFoldableWithIndex)
  end.

foldableWithIndexProduct(#{ 'Foldable0' := DictFoldableWithIndex
                          , foldMapWithIndex := DictFoldableWithIndex@1
                          , foldlWithIndex := DictFoldableWithIndex@2
                          , foldrWithIndex := DictFoldableWithIndex@3
                          }) ->
  begin
    FoldableProduct =
      (data_foldable@ps:foldableProduct())(DictFoldableWithIndex(undefined)),
    fun
      (#{ 'Foldable0' := DictFoldableWithIndex1
        , foldMapWithIndex := DictFoldableWithIndex1@1
        , foldlWithIndex := DictFoldableWithIndex1@2
        , foldrWithIndex := DictFoldableWithIndex1@3
        }) ->
        begin
          FoldableProduct1 = FoldableProduct(DictFoldableWithIndex1(undefined)),
          #{ foldrWithIndex =>
             fun
               (F) ->
                 fun
                   (Z) ->
                     fun
                       (V) ->
                         ((DictFoldableWithIndex@3(fun
                             (X) ->
                               F({left, X})
                           end))
                          (((DictFoldableWithIndex1@3(fun
                               (X) ->
                                 F({right, X})
                             end))
                            (Z))
                           (erlang:element(3, V))))
                         (erlang:element(2, V))
                     end
                 end
             end
           , foldlWithIndex =>
             fun
               (F) ->
                 fun
                   (Z) ->
                     fun
                       (V) ->
                         ((DictFoldableWithIndex1@2(fun
                             (X) ->
                               F({right, X})
                           end))
                          (((DictFoldableWithIndex@2(fun
                               (X) ->
                                 F({left, X})
                             end))
                            (Z))
                           (erlang:element(2, V))))
                         (erlang:element(3, V))
                     end
                 end
             end
           , foldMapWithIndex =>
             fun
               (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
                 begin
                   FoldMapWithIndex3 = DictFoldableWithIndex@1(DictMonoid),
                   FoldMapWithIndex4 = DictFoldableWithIndex1@1(DictMonoid),
                   fun
                     (F) ->
                       fun
                         (V) ->
                           ((erlang:map_get(append, DictMonoid@1(undefined)))
                            ((FoldMapWithIndex3(fun
                                (X) ->
                                  F({left, X})
                              end))
                             (erlang:element(2, V))))
                           ((FoldMapWithIndex4(fun
                               (X) ->
                                 F({right, X})
                             end))
                            (erlang:element(3, V)))
                       end
                   end
                 end
             end
           , 'Foldable0' =>
             fun
               (_) ->
                 FoldableProduct1
             end
           }
        end
    end
  end.

foldlWithIndexDefault() ->
  fun
    (DictFoldableWithIndex) ->
      foldlWithIndexDefault(DictFoldableWithIndex)
  end.

foldlWithIndexDefault(#{ foldMapWithIndex := DictFoldableWithIndex }) ->
  begin
    FoldMapWithIndex1 = DictFoldableWithIndex(monoidDual()),
    fun
      (C) ->
        fun
          (U) ->
            fun
              (Xs) ->
                ((FoldMapWithIndex1(fun
                    (I) ->
                      begin
                        V = C(I),
                        fun
                          (X) ->
                            fun
                              (A) ->
                                (V(A))(X)
                            end
                        end
                      end
                  end))
                 (Xs))
                (U)
            end
        end
    end
  end.

foldrWithIndexDefault() ->
  fun
    (DictFoldableWithIndex) ->
      foldrWithIndexDefault(DictFoldableWithIndex)
  end.

foldrWithIndexDefault(#{ foldMapWithIndex := DictFoldableWithIndex }) ->
  begin
    FoldMapWithIndex1 = DictFoldableWithIndex(monoidEndo()),
    fun
      (C) ->
        fun
          (U) ->
            fun
              (Xs) ->
                ((FoldMapWithIndex1(fun
                    (I) ->
                      C(I)
                  end))
                 (Xs))
                (U)
            end
        end
    end
  end.

surroundMapWithIndex() ->
  fun
    (DictFoldableWithIndex) ->
      surroundMapWithIndex(DictFoldableWithIndex)
  end.

surroundMapWithIndex(#{ foldMapWithIndex := DictFoldableWithIndex }) ->
  begin
    FoldMapWithIndex1 = DictFoldableWithIndex(monoidEndo()),
    fun
      (#{ append := DictSemigroup }) ->
        fun
          (D) ->
            fun
              (T) ->
                fun
                  (F) ->
                    ((FoldMapWithIndex1(fun
                        (I) ->
                          fun
                            (A) ->
                              fun
                                (M) ->
                                  (DictSemigroup(D))
                                  ((DictSemigroup((T(I))(A)))(M))
                              end
                          end
                      end))
                     (F))
                    (D)
                end
            end
        end
    end
  end.

foldMapDefault() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (DictMonoid) ->
          foldMapDefault(DictFoldableWithIndex, DictMonoid)
      end
  end.

foldMapDefault(#{ foldMapWithIndex := DictFoldableWithIndex }, DictMonoid) ->
  begin
    FoldMapWithIndex2 = DictFoldableWithIndex(DictMonoid),
    fun
      (F) ->
        FoldMapWithIndex2(fun
          (_) ->
            F
        end)
    end
  end.

findWithIndex() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (P) ->
          findWithIndex(DictFoldableWithIndex, P)
      end
  end.

findWithIndex(#{ foldlWithIndex := DictFoldableWithIndex }, P) ->
  (DictFoldableWithIndex(fun
     (V) ->
       fun
         (V1) ->
           fun
             (V2) ->
               case ?IS_KNOWN_TAG(nothing, 0, V1) andalso ((P(V))(V2)) of
                 true ->
                   {just, #{ index => V, value => V2 }};
                 _ ->
                   V1
               end
           end
       end
   end))
  ({nothing}).

findMapWithIndex() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (F) ->
          findMapWithIndex(DictFoldableWithIndex, F)
      end
  end.

findMapWithIndex(#{ foldlWithIndex := DictFoldableWithIndex }, F) ->
  (DictFoldableWithIndex(fun
     (V) ->
       fun
         (V1) ->
           fun
             (V2) ->
               case V1 of
                 {nothing} ->
                   (F(V))(V2);
                 _ ->
                   V1
               end
           end
       end
   end))
  ({nothing}).

anyWithIndex() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (DictHeytingAlgebra) ->
          anyWithIndex(DictFoldableWithIndex, DictHeytingAlgebra)
      end
  end.

anyWithIndex( #{ foldMapWithIndex := DictFoldableWithIndex }
            , #{ disj := DictHeytingAlgebra, ff := DictHeytingAlgebra@1 }
            ) ->
  begin
    FoldMapWithIndex2 =
      DictFoldableWithIndex(begin
        SemigroupDisj1 =
          #{ append =>
             fun
               (V) ->
                 fun
                   (V1) ->
                     (DictHeytingAlgebra(V))(V1)
                 end
             end
           },
        #{ mempty => DictHeytingAlgebra@1
         , 'Semigroup0' =>
           fun
             (_) ->
               SemigroupDisj1
           end
         }
      end),
    fun
      (T) ->
        FoldMapWithIndex2(fun
          (I) ->
            T(I)
        end)
    end
  end.

allWithIndex() ->
  fun
    (DictFoldableWithIndex) ->
      fun
        (DictHeytingAlgebra) ->
          allWithIndex(DictFoldableWithIndex, DictHeytingAlgebra)
      end
  end.

allWithIndex( #{ foldMapWithIndex := DictFoldableWithIndex }
            , #{ conj := DictHeytingAlgebra, tt := DictHeytingAlgebra@1 }
            ) ->
  begin
    FoldMapWithIndex2 =
      DictFoldableWithIndex(begin
        SemigroupConj1 =
          #{ append =>
             fun
               (V) ->
                 fun
                   (V1) ->
                     (DictHeytingAlgebra(V))(V1)
                 end
             end
           },
        #{ mempty => DictHeytingAlgebra@1
         , 'Semigroup0' =>
           fun
             (_) ->
               SemigroupConj1
           end
         }
      end),
    fun
      (T) ->
        FoldMapWithIndex2(fun
          (I) ->
            T(I)
        end)
    end
  end.

