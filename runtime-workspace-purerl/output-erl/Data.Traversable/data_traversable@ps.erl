-module(data_traversable@ps).
-export([ identity/0
        , identity/1
        , traverse/0
        , traverse/1
        , traversableTuple/0
        , traversableMultiplicative/0
        , traversableMaybe/0
        , traversableIdentity/0
        , traversableEither/0
        , traversableDual/0
        , traversableDisj/0
        , traversableConst/0
        , traversableConj/0
        , traversableCompose/0
        , traversableCompose/1
        , traversableAdditive/0
        , sequenceDefault/0
        , sequenceDefault/2
        , traversableArray/0
        , sequence/0
        , sequence/1
        , traversableApp/0
        , traversableApp/1
        , traversableCoproduct/0
        , traversableCoproduct/1
        , traversableFirst/0
        , traversableLast/0
        , traversableProduct/0
        , traversableProduct/1
        , traverseDefault/0
        , traverseDefault/2
        , mapAccumR/0
        , mapAccumR/1
        , scanr/0
        , scanr/1
        , mapAccumL/0
        , mapAccumL/1
        , scanl/0
        , scanl/1
        , for/0
        , for/2
        , traverseArrayImpl/0
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

traverse() ->
  fun
    (Dict) ->
      traverse(Dict)
  end.

traverse(#{ traverse := Dict }) ->
  Dict.

traversableTuple() ->
  #{ traverse =>
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
                 (F(erlang:element(3, V)))
             end
         end
     end
   , sequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative(undefined)))
                 (undefined)
               ))
              ((data_tuple@ps:'Tuple'())(erlang:element(2, V))))
             (erlang:element(3, V))
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_tuple@ps:functorTuple()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableTuple()
     end
   }.

traversableMultiplicative() ->
  #{ traverse =>
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
                  (data_monoid_multiplicative@ps:'Multiplicative'()))
                 (F(V))
             end
         end
     end
   , sequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative(undefined)))
                 (undefined)
               ))
              (data_monoid_multiplicative@ps:'Multiplicative'()))
             (V)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_multiplicative@ps:functorMultiplicative()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableMultiplicative()
     end
   }.

traversableMaybe() ->
  #{ traverse =>
     fun
       (DictApplicative) ->
         fun
           (V) ->
             fun
               (V1) ->
                 case V1 of
                   {nothing} ->
                     (erlang:map_get(pure, DictApplicative))({nothing});
                   {just, V1@1} ->
                     ((erlang:map_get(
                         map,
                         (erlang:map_get(
                            'Functor0',
                            (erlang:map_get('Apply0', DictApplicative))
                            (undefined)
                          ))
                         (undefined)
                       ))
                      (data_maybe@ps:'Just'()))
                     (V(V1@1));
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , sequence =>
     fun
       (DictApplicative) ->
         fun
           (V) ->
             case V of
               {nothing} ->
                 (erlang:map_get(pure, DictApplicative))({nothing});
               {just, V@1} ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get(
                        'Functor0',
                        (erlang:map_get('Apply0', DictApplicative))(undefined)
                      ))
                     (undefined)
                   ))
                  (data_maybe@ps:'Just'()))
                 (V@1);
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_maybe@ps:functorMaybe()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableMaybe()
     end
   }.

traversableIdentity() ->
  #{ traverse =>
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
                 (F(V))
             end
         end
     end
   , sequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative(undefined)))
                 (undefined)
               ))
              (data_identity@ps:'Identity'()))
             (V)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_identity@ps:functorIdentity()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableIdentity()
     end
   }.

traversableEither() ->
  #{ traverse =>
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
                     (V(V1@2));
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , sequence =>
     fun
       (DictApplicative) ->
         fun
           (V) ->
             case V of
               {left, V@1} ->
                 (erlang:map_get(pure, DictApplicative))({left, V@1});
               {right, V@2} ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get(
                        'Functor0',
                        (erlang:map_get('Apply0', DictApplicative))(undefined)
                      ))
                     (undefined)
                   ))
                  (data_either@ps:'Right'()))
                 (V@2);
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_either@ps:functorEither()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableEither()
     end
   }.

traversableDual() ->
  #{ traverse =>
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
                  (data_monoid_dual@ps:'Dual'()))
                 (F(V))
             end
         end
     end
   , sequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative(undefined)))
                 (undefined)
               ))
              (data_monoid_dual@ps:'Dual'()))
             (V)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_dual@ps:functorDual()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableDual()
     end
   }.

traversableDisj() ->
  #{ traverse =>
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
                  (data_monoid_disj@ps:'Disj'()))
                 (F(V))
             end
         end
     end
   , sequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative(undefined)))
                 (undefined)
               ))
              (data_monoid_disj@ps:'Disj'()))
             (V)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_disj@ps:functorDisj()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableDisj()
     end
   }.

traversableConst() ->
  #{ traverse =>
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
   , sequence =>
     fun
       (#{ pure := DictApplicative }) ->
         fun
           (V) ->
             DictApplicative(V)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_const@ps:functorConst()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableConst()
     end
   }.

traversableConj() ->
  #{ traverse =>
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
                  (data_monoid_conj@ps:'Conj'()))
                 (F(V))
             end
         end
     end
   , sequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative(undefined)))
                 (undefined)
               ))
              (data_monoid_conj@ps:'Conj'()))
             (V)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_conj@ps:functorConj()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableConj()
     end
   }.

traversableCompose() ->
  fun
    (DictTraversable) ->
      traversableCompose(DictTraversable)
  end.

traversableCompose(DictTraversable = #{ 'Foldable1' := DictTraversable@1
                                      , 'Functor0' := DictTraversable@2
                                      , traverse := DictTraversable@3
                                      }) ->
  begin
    #{ map := V } = DictTraversable@2(undefined),
    #{ foldMap := V@1, foldl := V@2, foldr := V@3 } =
      DictTraversable@1(undefined),
    fun
      (DictTraversable1 = #{ 'Foldable1' := DictTraversable1@1
                           , 'Functor0' := DictTraversable1@2
                           , traverse := DictTraversable1@3
                           }) ->
        begin
          #{ map := V@4 } = DictTraversable1@2(undefined),
          FunctorCompose1 =
            #{ map =>
               fun
                 (F) ->
                   fun
                     (V@5) ->
                       (V(V@4(F)))(V@5)
                   end
               end
             },
          #{ foldMap := V@5, foldl := V@6, foldr := V@7 } =
            DictTraversable1@1(undefined),
          FoldableCompose1 =
            #{ foldr =>
               fun
                 (F) ->
                   fun
                     (I) ->
                       fun
                         (V@8) ->
                           ((V@3(begin
                               V@9 = V@7(F),
                               fun
                                 (B) ->
                                   fun
                                     (A) ->
                                       (V@9(A))(B)
                                   end
                               end
                             end))
                            (I))
                           (V@8)
                       end
                   end
               end
             , foldl =>
               fun
                 (F) ->
                   fun
                     (I) ->
                       fun
                         (V@8) ->
                           ((V@2(V@6(F)))(I))(V@8)
                       end
                   end
               end
             , foldMap =>
               fun
                 (DictMonoid) ->
                   begin
                     FoldMap4 = V@1(DictMonoid),
                     FoldMap5 = V@5(DictMonoid),
                     fun
                       (F) ->
                         fun
                           (V@8) ->
                             (FoldMap4(FoldMap5(F)))(V@8)
                         end
                     end
                   end
               end
             },
          #{ traverse =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   Traverse4 = DictTraversable@3(DictApplicative),
                   Traverse5 = DictTraversable1@3(DictApplicative),
                   fun
                     (F) ->
                       fun
                         (V@8) ->
                           ((erlang:map_get(
                               map,
                               (erlang:map_get(
                                  'Functor0',
                                  DictApplicative@1(undefined)
                                ))
                               (undefined)
                             ))
                            (data_functor_compose@ps:'Compose'()))
                           ((Traverse4(Traverse5(F)))(V@8))
                       end
                   end
                 end
             end
           , sequence =>
             fun
               (DictApplicative) ->
                 ((erlang:map_get(
                     traverse,
                     (traversableCompose(DictTraversable))(DictTraversable1)
                   ))
                  (DictApplicative))
                 (identity())
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorCompose1
             end
           , 'Foldable1' =>
             fun
               (_) ->
                 FoldableCompose1
             end
           }
        end
    end
  end.

traversableAdditive() ->
  #{ traverse =>
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
                  (data_monoid_additive@ps:'Additive'()))
                 (F(V))
             end
         end
     end
   , sequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative(undefined)))
                 (undefined)
               ))
              (data_monoid_additive@ps:'Additive'()))
             (V)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_additive@ps:functorAdditive()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableAdditive()
     end
   }.

sequenceDefault() ->
  fun
    (DictTraversable) ->
      fun
        (DictApplicative) ->
          sequenceDefault(DictTraversable, DictApplicative)
      end
  end.

sequenceDefault(#{ traverse := DictTraversable }, DictApplicative) ->
  (DictTraversable(DictApplicative))(identity()).

traversableArray() ->
  #{ traverse =>
     fun
       (#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
         begin
           #{ 'Functor0' := Apply0, apply := Apply0@1 } =
             DictApplicative(undefined),
           (((traverseArrayImpl())(Apply0@1))
            (erlang:map_get(map, Apply0(undefined))))
           (DictApplicative@1)
         end
     end
   , sequence =>
     fun
       (DictApplicative) ->
         ((erlang:map_get(traverse, traversableArray()))(DictApplicative))
         (identity())
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_functor@ps:functorArray()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableArray()
     end
   }.

sequence() ->
  fun
    (Dict) ->
      sequence(Dict)
  end.

sequence(#{ sequence := Dict }) ->
  Dict.

traversableApp() ->
  fun
    (DictTraversable) ->
      traversableApp(DictTraversable)
  end.

traversableApp(#{ 'Foldable1' := DictTraversable
                , 'Functor0' := DictTraversable@1
                , sequence := DictTraversable@2
                , traverse := DictTraversable@3
                }) ->
  begin
    V = DictTraversable@1(undefined),
    #{ foldMap := V@1, foldl := V@2, foldr := V@3 } = DictTraversable(undefined),
    FoldableApp =
      #{ foldr =>
         fun
           (F) ->
             fun
               (I) ->
                 fun
                   (V@4) ->
                     ((V@3(F))(I))(V@4)
                 end
             end
         end
       , foldl =>
         fun
           (F) ->
             fun
               (I) ->
                 fun
                   (V@4) ->
                     ((V@2(F))(I))(V@4)
                 end
             end
         end
       , foldMap =>
         fun
           (DictMonoid) ->
             V@1(DictMonoid)
         end
       },
    #{ traverse =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Traverse3 = DictTraversable@3(DictApplicative),
             fun
               (F) ->
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
                      (data_functor_app@ps:'App'()))
                     ((Traverse3(F))(V@4))
                 end
             end
           end
       end
     , sequence =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Sequence3 = DictTraversable@2(DictApplicative),
             fun
               (V@4) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined)
                   ))
                  (data_functor_app@ps:'App'()))
                 (Sequence3(V@4))
             end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           V
       end
     , 'Foldable1' =>
       fun
         (_) ->
           FoldableApp
       end
     }
  end.

traversableCoproduct() ->
  fun
    (DictTraversable) ->
      traversableCoproduct(DictTraversable)
  end.

traversableCoproduct(#{ 'Foldable1' := DictTraversable
                      , 'Functor0' := DictTraversable@1
                      , sequence := DictTraversable@2
                      , traverse := DictTraversable@3
                      }) ->
  begin
    #{ map := V } = DictTraversable@1(undefined),
    FoldableCoproduct =
      (data_foldable@ps:foldableCoproduct())(DictTraversable(undefined)),
    fun
      (#{ 'Foldable1' := DictTraversable1
        , 'Functor0' := DictTraversable1@1
        , sequence := DictTraversable1@2
        , traverse := DictTraversable1@3
        }) ->
        begin
          #{ map := V@1 } = DictTraversable1@1(undefined),
          FunctorCoproduct1 =
            #{ map =>
               fun
                 (F) ->
                   fun
                     (V@2) ->
                       begin
                         V@3 = V(F),
                         V@4 = V@1(F),
                         case V@2 of
                           {left, V@5} ->
                             {left, V@3(V@5)};
                           {right, V@6} ->
                             {right, V@4(V@6)};
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                       end
                   end
               end
             },
          FoldableCoproduct1 = FoldableCoproduct(DictTraversable1(undefined)),
          #{ traverse =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   #{ map := V@2 } =
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined),
                   Traverse4 = DictTraversable@3(DictApplicative),
                   Traverse5 = DictTraversable1@3(DictApplicative),
                   fun
                     (F) ->
                       begin
                         V@3 =
                           V@2(fun
                             (X) ->
                               {left, X}
                           end),
                         V@4 = Traverse4(F),
                         V@5 =
                           V@2(fun
                             (X) ->
                               {right, X}
                           end),
                         V@6 = Traverse5(F),
                         fun
                           (V2) ->
                             case V2 of
                               {left, V2@1} ->
                                 V@3(V@4(V2@1));
                               {right, V2@2} ->
                                 V@5(V@6(V2@2));
                               _ ->
                                 erlang:error({fail, <<"Failed pattern match">>})
                             end
                         end
                       end
                   end
                 end
             end
           , sequence =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   #{ map := V@2 } =
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined),
                   V@3 =
                     V@2(fun
                       (X) ->
                         {left, X}
                     end),
                   V@4 = DictTraversable@2(DictApplicative),
                   V@5 =
                     V@2(fun
                       (X) ->
                         {right, X}
                     end),
                   V@6 = DictTraversable1@2(DictApplicative),
                   fun
                     (V2) ->
                       case V2 of
                         {left, V2@1} ->
                           V@3(V@4(V2@1));
                         {right, V2@2} ->
                           V@5(V@6(V2@2));
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorCoproduct1
             end
           , 'Foldable1' =>
             fun
               (_) ->
                 FoldableCoproduct1
             end
           }
        end
    end
  end.

traversableFirst() ->
  #{ traverse =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         fun
           (F) ->
             fun
               (V) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined)
                   ))
                  (data_maybe_first@ps:'First'()))
                 ((((erlang:map_get(traverse, traversableMaybe()))
                    (DictApplicative))
                   (F))
                  (V))
             end
         end
     end
   , sequence =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                 (undefined)
               ))
              (data_maybe_first@ps:'First'()))
             (((erlang:map_get(sequence, traversableMaybe()))(DictApplicative))
              (V))
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_maybe@ps:functorMaybe()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableFirst()
     end
   }.

traversableLast() ->
  #{ traverse =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         fun
           (F) ->
             fun
               (V) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined)
                   ))
                  (data_maybe_last@ps:'Last'()))
                 ((((erlang:map_get(traverse, traversableMaybe()))
                    (DictApplicative))
                   (F))
                  (V))
             end
         end
     end
   , sequence =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                 (undefined)
               ))
              (data_maybe_last@ps:'Last'()))
             (((erlang:map_get(sequence, traversableMaybe()))(DictApplicative))
              (V))
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_maybe@ps:functorMaybe()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         data_foldable@ps:foldableLast()
     end
   }.

traversableProduct() ->
  fun
    (DictTraversable) ->
      traversableProduct(DictTraversable)
  end.

traversableProduct(#{ 'Foldable1' := DictTraversable
                    , 'Functor0' := DictTraversable@1
                    , sequence := DictTraversable@2
                    , traverse := DictTraversable@3
                    }) ->
  begin
    #{ map := V } = DictTraversable@1(undefined),
    FoldableProduct =
      (data_foldable@ps:foldableProduct())(DictTraversable(undefined)),
    fun
      (#{ 'Foldable1' := DictTraversable1
        , 'Functor0' := DictTraversable1@1
        , sequence := DictTraversable1@2
        , traverse := DictTraversable1@3
        }) ->
        begin
          #{ map := V@1 } = DictTraversable1@1(undefined),
          FunctorProduct1 =
            #{ map =>
               fun
                 (F) ->
                   fun
                     (V@2) ->
                       { tuple
                       , (V(F))(erlang:element(2, V@2))
                       , (V@1(F))(erlang:element(3, V@2))
                       }
                   end
               end
             },
          FoldableProduct1 = FoldableProduct(DictTraversable1(undefined)),
          #{ traverse =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   #{ 'Functor0' := V@2, apply := V@3 } =
                     DictApplicative@1(undefined),
                   Traverse4 = DictTraversable@3(DictApplicative),
                   Traverse5 = DictTraversable1@3(DictApplicative),
                   fun
                     (F) ->
                       fun
                         (V@4) ->
                           (V@3(((erlang:map_get(map, V@2(undefined)))
                                 (data_functor_product@ps:product()))
                                ((Traverse4(F))(erlang:element(2, V@4)))))
                           ((Traverse5(F))(erlang:element(3, V@4)))
                       end
                   end
                 end
             end
           , sequence =>
             fun
               (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
                 begin
                   #{ 'Functor0' := V@2, apply := V@3 } =
                     DictApplicative@1(undefined),
                   Sequence4 = DictTraversable@2(DictApplicative),
                   Sequence5 = DictTraversable1@2(DictApplicative),
                   fun
                     (V@4) ->
                       (V@3(((erlang:map_get(map, V@2(undefined)))
                             (data_functor_product@ps:product()))
                            (Sequence4(erlang:element(2, V@4)))))
                       (Sequence5(erlang:element(3, V@4)))
                   end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorProduct1
             end
           , 'Foldable1' =>
             fun
               (_) ->
                 FoldableProduct1
             end
           }
        end
    end
  end.

traverseDefault() ->
  fun
    (DictTraversable) ->
      fun
        (DictApplicative) ->
          traverseDefault(DictTraversable, DictApplicative)
      end
  end.

traverseDefault( #{ 'Functor0' := DictTraversable
                  , sequence := DictTraversable@1
                  }
               , DictApplicative
               ) ->
  begin
    Sequence3 = DictTraversable@1(DictApplicative),
    fun
      (F) ->
        fun
          (Ta) ->
            Sequence3(((erlang:map_get(map, DictTraversable(undefined)))(F))(Ta))
        end
    end
  end.

mapAccumR() ->
  fun
    (DictTraversable) ->
      mapAccumR(DictTraversable)
  end.

mapAccumR(#{ traverse := DictTraversable }) ->
  begin
    Traverse2 =
      DictTraversable(data_traversable_accum_internal@ps:applicativeStateR()),
    fun
      (F) ->
        fun
          (S0) ->
            fun
              (Xs) ->
                ((Traverse2(fun
                    (A) ->
                      fun
                        (S) ->
                          (F(S))(A)
                      end
                  end))
                 (Xs))
                (S0)
            end
        end
    end
  end.

scanr() ->
  fun
    (DictTraversable) ->
      scanr(DictTraversable)
  end.

scanr(DictTraversable) ->
  begin
    MapAccumR1 = mapAccumR(DictTraversable),
    fun
      (F) ->
        fun
          (B0) ->
            fun
              (Xs) ->
                erlang:map_get(
                  value,
                  ((MapAccumR1(fun
                      (B) ->
                        fun
                          (A) ->
                            begin
                              B_ = (F(A))(B),
                              #{ accum => B_, value => B_ }
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

mapAccumL() ->
  fun
    (DictTraversable) ->
      mapAccumL(DictTraversable)
  end.

mapAccumL(#{ traverse := DictTraversable }) ->
  begin
    Traverse2 =
      DictTraversable(data_traversable_accum_internal@ps:applicativeStateL()),
    fun
      (F) ->
        fun
          (S0) ->
            fun
              (Xs) ->
                ((Traverse2(fun
                    (A) ->
                      fun
                        (S) ->
                          (F(S))(A)
                      end
                  end))
                 (Xs))
                (S0)
            end
        end
    end
  end.

scanl() ->
  fun
    (DictTraversable) ->
      scanl(DictTraversable)
  end.

scanl(DictTraversable) ->
  begin
    MapAccumL1 = mapAccumL(DictTraversable),
    fun
      (F) ->
        fun
          (B0) ->
            fun
              (Xs) ->
                erlang:map_get(
                  value,
                  ((MapAccumL1(fun
                      (B) ->
                        fun
                          (A) ->
                            begin
                              B_ = (F(B))(A),
                              #{ accum => B_, value => B_ }
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

for() ->
  fun
    (DictApplicative) ->
      fun
        (DictTraversable) ->
          for(DictApplicative, DictTraversable)
      end
  end.

for(DictApplicative, #{ traverse := DictTraversable }) ->
  begin
    Traverse2 = DictTraversable(DictApplicative),
    fun
      (X) ->
        fun
          (F) ->
            (Traverse2(F))(X)
        end
    end
  end.

traverseArrayImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      data_traversable@foreign:traverseArrayImpl(
                        V,
                        V@1,
                        V@2,
                        V@3,
                        V@4
                      )
                  end
              end
          end
      end
  end.

