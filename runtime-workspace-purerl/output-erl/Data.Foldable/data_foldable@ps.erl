-module(data_foldable@ps).
-export([ identity/0
        , identity/1
        , 'monoidEndo.semigroupEndo1'/0
        , monoidEndo/0
        , 'monoidDual.semigroupDual1'/0
        , monoidDual/0
        , foldr/0
        , foldr/1
        , indexr/0
        , indexr/2
        , null/0
        , null/1
        , oneOf/0
        , oneOf/2
        , oneOfMap/0
        , oneOfMap/2
        , traverse_/0
        , traverse_/1
        , for_/0
        , for_/1
        , sequence_/0
        , sequence_/1
        , foldl/0
        , foldl/1
        , indexl/0
        , indexl/2
        , intercalate/0
        , intercalate/2
        , length/0
        , length/2
        , maximumBy/0
        , maximumBy/2
        , maximum/0
        , maximum/2
        , minimumBy/0
        , minimumBy/2
        , minimum/0
        , minimum/2
        , product/0
        , product/2
        , sum/0
        , sum/2
        , foldableTuple/0
        , foldableMultiplicative/0
        , foldableMaybe/0
        , foldableIdentity/0
        , foldableEither/0
        , foldableDual/0
        , foldableDisj/0
        , foldableConst/0
        , foldableConj/0
        , foldableAdditive/0
        , foldMapDefaultR/0
        , foldMapDefaultR/2
        , foldableArray/0
        , foldMapDefaultL/0
        , foldMapDefaultL/2
        , foldMap/0
        , foldMap/1
        , foldableApp/0
        , foldableApp/1
        , foldableCompose/0
        , foldableCompose/2
        , foldableCoproduct/0
        , foldableCoproduct/2
        , foldableFirst/0
        , foldableLast/0
        , foldableProduct/0
        , foldableProduct/2
        , foldlDefault/0
        , foldlDefault/1
        , foldrDefault/0
        , foldrDefault/1
        , lookup/0
        , lookup/1
        , surroundMap/0
        , surroundMap/1
        , surround/0
        , surround/1
        , foldM/0
        , foldM/4
        , fold/0
        , fold/2
        , findMap/0
        , findMap/2
        , find/0
        , find/2
        , any/0
        , any/2
        , elem/0
        , elem/1
        , notElem/0
        , notElem/1
        , 'or'/0
        , 'or'/2
        , all/0
        , all/2
        , 'and'/0
        , 'and'/2
        , foldrArray/0
        , foldlArray/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

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

foldr() ->
  fun
    (Dict) ->
      foldr(Dict)
  end.

foldr(#{ foldr := Dict }) ->
  Dict.

indexr() ->
  fun
    (DictFoldable) ->
      fun
        (Idx) ->
          indexr(DictFoldable, Idx)
      end
  end.

indexr(#{ foldr := DictFoldable }, Idx) ->
  begin
    V =
      (DictFoldable(fun
         (A) ->
           fun
             (Cursor) ->
               case erlang:map_get(elem, Cursor) of
                 {just, _} ->
                   Cursor;
                 _ ->
                   if
                     (erlang:map_get(pos, Cursor)) =:= Idx ->
                       #{ elem => {just, A}
                        , pos => erlang:map_get(pos, Cursor)
                        };
                     true ->
                       #{ pos => (erlang:map_get(pos, Cursor)) + 1
                        , elem => erlang:map_get(elem, Cursor)
                        }
                   end
               end
           end
       end))
      (#{ elem => {nothing}, pos => 0 }),
    fun
      (X) ->
        erlang:map_get(elem, V(X))
    end
  end.

null() ->
  fun
    (DictFoldable) ->
      null(DictFoldable)
  end.

null(#{ foldr := DictFoldable }) ->
  (DictFoldable(fun
     (_) ->
       fun
         (_) ->
           false
       end
   end))
  (true).

oneOf() ->
  fun
    (DictFoldable) ->
      fun
        (DictPlus) ->
          oneOf(DictFoldable, DictPlus)
      end
  end.

oneOf(#{ foldr := DictFoldable }, #{ 'Alt0' := DictPlus, empty := DictPlus@1 }) ->
  (DictFoldable(erlang:map_get(alt, DictPlus(undefined))))(DictPlus@1).

oneOfMap() ->
  fun
    (DictFoldable) ->
      fun
        (DictPlus) ->
          oneOfMap(DictFoldable, DictPlus)
      end
  end.

oneOfMap( #{ foldr := DictFoldable }
        , #{ 'Alt0' := DictPlus, empty := DictPlus@1 }
        ) ->
  fun
    (F) ->
      (DictFoldable(fun
         (X) ->
           (erlang:map_get(alt, DictPlus(undefined)))(F(X))
       end))
      (DictPlus@1)
  end.

traverse_() ->
  fun
    (DictApplicative) ->
      traverse_(DictApplicative)
  end.

traverse_(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    fun
      (#{ foldr := DictFoldable }) ->
        fun
          (F) ->
            (DictFoldable(fun
               (X) ->
                 begin
                   V@2 = F(X),
                   fun
                     (B) ->
                       (V@1(((erlang:map_get(map, V(undefined)))
                             (fun
                               (_) ->
                                 control_apply@ps:identity()
                             end))
                            (V@2)))
                       (B)
                   end
                 end
             end))
            (DictApplicative@1(unit))
        end
    end
  end.

for_() ->
  fun
    (DictApplicative) ->
      for_(DictApplicative)
  end.

for_(DictApplicative) ->
  begin
    Traverse_1 = traverse_(DictApplicative),
    fun
      (DictFoldable) ->
        begin
          V = Traverse_1(DictFoldable),
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

sequence_() ->
  fun
    (DictApplicative) ->
      sequence_(DictApplicative)
  end.

sequence_(DictApplicative) ->
  begin
    Traverse_1 = traverse_(DictApplicative),
    fun
      (DictFoldable) ->
        (Traverse_1(DictFoldable))(identity())
    end
  end.

foldl() ->
  fun
    (Dict) ->
      foldl(Dict)
  end.

foldl(#{ foldl := Dict }) ->
  Dict.

indexl() ->
  fun
    (DictFoldable) ->
      fun
        (Idx) ->
          indexl(DictFoldable, Idx)
      end
  end.

indexl(#{ foldl := DictFoldable }, Idx) ->
  begin
    V =
      (DictFoldable(fun
         (Cursor) ->
           fun
             (A) ->
               case erlang:map_get(elem, Cursor) of
                 {just, _} ->
                   Cursor;
                 _ ->
                   if
                     (erlang:map_get(pos, Cursor)) =:= Idx ->
                       #{ elem => {just, A}
                        , pos => erlang:map_get(pos, Cursor)
                        };
                     true ->
                       #{ pos => (erlang:map_get(pos, Cursor)) + 1
                        , elem => erlang:map_get(elem, Cursor)
                        }
                   end
               end
           end
       end))
      (#{ elem => {nothing}, pos => 0 }),
    fun
      (X) ->
        erlang:map_get(elem, V(X))
    end
  end.

intercalate() ->
  fun
    (DictFoldable) ->
      fun
        (DictMonoid) ->
          intercalate(DictFoldable, DictMonoid)
      end
  end.

intercalate( #{ foldl := DictFoldable }
           , #{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }
           ) ->
  begin
    V = DictMonoid(undefined),
    fun
      (Sep) ->
        fun
          (Xs) ->
            erlang:map_get(
              acc,
              ((DictFoldable(fun
                  (V@1) ->
                    fun
                      (V1) ->
                        if
                          erlang:map_get(init, V@1) ->
                            #{ init => false, acc => V1 };
                          true ->
                            begin
                              #{ append := V@2 } = V,
                              #{ init => false
                               , acc =>
                                 (V@2(erlang:map_get(acc, V@1)))((V@2(Sep))(V1))
                               }
                            end
                        end
                    end
                end))
               (#{ init => true, acc => DictMonoid@1 }))
              (Xs)
            )
        end
    end
  end.

length() ->
  fun
    (DictFoldable) ->
      fun
        (DictSemiring) ->
          length(DictFoldable, DictSemiring)
      end
  end.

length( #{ foldl := DictFoldable }
      , #{ add := DictSemiring, one := DictSemiring@1, zero := DictSemiring@2 }
      ) ->
  (DictFoldable(fun
     (C) ->
       fun
         (_) ->
           (DictSemiring(DictSemiring@1))(C)
       end
   end))
  (DictSemiring@2).

maximumBy() ->
  fun
    (DictFoldable) ->
      fun
        (Cmp) ->
          maximumBy(DictFoldable, Cmp)
      end
  end.

maximumBy(#{ foldl := DictFoldable }, Cmp) ->
  (DictFoldable(fun
     (V) ->
       fun
         (V1) ->
           case V of
             {nothing} ->
               {just, V1};
             {just, V@1} ->
               { just
               , begin
                   V@2 = (Cmp(V@1))(V1),
                   case ?IS_KNOWN_TAG(gT, 0, V@2) of
                     true ->
                       begin
                         {just, V@3} = V,
                         V@3
                       end;
                     _ ->
                       V1
                   end
                 end
               };
             _ ->
               erlang:error({fail, <<"Failed pattern match">>})
           end
       end
   end))
  ({nothing}).

maximum() ->
  fun
    (DictOrd) ->
      fun
        (DictFoldable) ->
          maximum(DictOrd, DictFoldable)
      end
  end.

maximum(DictOrd, #{ foldl := DictFoldable }) ->
  (DictFoldable(fun
     (V) ->
       fun
         (V1) ->
           case V of
             {nothing} ->
               {just, V1};
             {just, V@1} ->
               begin
                 #{ compare := DictOrd@1 } = DictOrd,
                 { just
                 , begin
                     V@2 = (DictOrd@1(V@1))(V1),
                     case ?IS_KNOWN_TAG(gT, 0, V@2) of
                       true ->
                         begin
                           {just, V@3} = V,
                           V@3
                         end;
                       _ ->
                         V1
                     end
                   end
                 }
               end;
             _ ->
               erlang:error({fail, <<"Failed pattern match">>})
           end
       end
   end))
  ({nothing}).

minimumBy() ->
  fun
    (DictFoldable) ->
      fun
        (Cmp) ->
          minimumBy(DictFoldable, Cmp)
      end
  end.

minimumBy(#{ foldl := DictFoldable }, Cmp) ->
  (DictFoldable(fun
     (V) ->
       fun
         (V1) ->
           case V of
             {nothing} ->
               {just, V1};
             {just, V@1} ->
               { just
               , begin
                   V@2 = (Cmp(V@1))(V1),
                   case ?IS_KNOWN_TAG(lT, 0, V@2) of
                     true ->
                       begin
                         {just, V@3} = V,
                         V@3
                       end;
                     _ ->
                       V1
                   end
                 end
               };
             _ ->
               erlang:error({fail, <<"Failed pattern match">>})
           end
       end
   end))
  ({nothing}).

minimum() ->
  fun
    (DictOrd) ->
      fun
        (DictFoldable) ->
          minimum(DictOrd, DictFoldable)
      end
  end.

minimum(DictOrd, #{ foldl := DictFoldable }) ->
  (DictFoldable(fun
     (V) ->
       fun
         (V1) ->
           case V of
             {nothing} ->
               {just, V1};
             {just, V@1} ->
               begin
                 #{ compare := DictOrd@1 } = DictOrd,
                 { just
                 , begin
                     V@2 = (DictOrd@1(V@1))(V1),
                     case ?IS_KNOWN_TAG(lT, 0, V@2) of
                       true ->
                         begin
                           {just, V@3} = V,
                           V@3
                         end;
                       _ ->
                         V1
                     end
                   end
                 }
               end;
             _ ->
               erlang:error({fail, <<"Failed pattern match">>})
           end
       end
   end))
  ({nothing}).

product() ->
  fun
    (DictFoldable) ->
      fun
        (DictSemiring) ->
          product(DictFoldable, DictSemiring)
      end
  end.

product( #{ foldl := DictFoldable }
       , #{ mul := DictSemiring, one := DictSemiring@1 }
       ) ->
  (DictFoldable(DictSemiring))(DictSemiring@1).

sum() ->
  fun
    (DictFoldable) ->
      fun
        (DictSemiring) ->
          sum(DictFoldable, DictSemiring)
      end
  end.

sum( #{ foldl := DictFoldable }
   , #{ add := DictSemiring, zero := DictSemiring@1 }
   ) ->
  (DictFoldable(DictSemiring))(DictSemiring@1).

foldableTuple() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(erlang:element(3, V)))(Z)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(Z))(erlang:element(3, V))
             end
         end
     end
   , foldMap =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (V) ->
                 F(erlang:element(3, V))
             end
         end
     end
   }.

foldableMultiplicative() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(V))(Z)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(Z))(V)
             end
         end
     end
   , foldMap =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (V) ->
                 F(V)
             end
         end
     end
   }.

foldableMaybe() ->
  #{ foldr =>
     fun
       (V) ->
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
   , foldl =>
     fun
       (V) ->
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
   , foldMap =>
     fun
       (#{ mempty := DictMonoid }) ->
         fun
           (V) ->
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
   }.

foldableIdentity() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(V))(Z)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(Z))(V)
             end
         end
     end
   , foldMap =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (V) ->
                 F(V)
             end
         end
     end
   }.

foldableEither() ->
  #{ foldr =>
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
                     (V(V2@1))(V1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , foldl =>
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
                     (V(V1))(V2@1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , foldMap =>
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
                     V(V1@1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   }.

foldableDual() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(V))(Z)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(Z))(V)
             end
         end
     end
   , foldMap =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (V) ->
                 F(V)
             end
         end
     end
   }.

foldableDisj() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(V))(Z)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(Z))(V)
             end
         end
     end
   , foldMap =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (V) ->
                 F(V)
             end
         end
     end
   }.

foldableConst() ->
  #{ foldr =>
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
   , foldl =>
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
   , foldMap =>
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
   }.

foldableConj() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(V))(Z)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(Z))(V)
             end
         end
     end
   , foldMap =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (V) ->
                 F(V)
             end
         end
     end
   }.

foldableAdditive() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(V))(Z)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 (F(Z))(V)
             end
         end
     end
   , foldMap =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (V) ->
                 F(V)
             end
         end
     end
   }.

foldMapDefaultR() ->
  fun
    (DictFoldable) ->
      fun
        (DictMonoid) ->
          foldMapDefaultR(DictFoldable, DictMonoid)
      end
  end.

foldMapDefaultR( #{ foldr := DictFoldable }
               , #{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }
               ) ->
  fun
    (F) ->
      (DictFoldable(fun
         (X) ->
           fun
             (Acc) ->
               ((erlang:map_get(append, DictMonoid(undefined)))(F(X)))(Acc)
           end
       end))
      (DictMonoid@1)
  end.

foldableArray() ->
  #{ foldr => foldrArray()
   , foldl => foldlArray()
   , foldMap =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         fun
           (F) ->
             ((erlang:map_get(foldr, foldableArray()))
              (fun
                (X) ->
                  fun
                    (Acc) ->
                      ((erlang:map_get(append, DictMonoid(undefined)))(F(X)))
                      (Acc)
                  end
              end))
             (DictMonoid@1)
         end
     end
   }.

foldMapDefaultL() ->
  fun
    (DictFoldable) ->
      fun
        (DictMonoid) ->
          foldMapDefaultL(DictFoldable, DictMonoid)
      end
  end.

foldMapDefaultL( #{ foldl := DictFoldable }
               , #{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }
               ) ->
  fun
    (F) ->
      (DictFoldable(fun
         (Acc) ->
           fun
             (X) ->
               ((erlang:map_get(append, DictMonoid(undefined)))(Acc))(F(X))
           end
       end))
      (DictMonoid@1)
  end.

foldMap() ->
  fun
    (Dict) ->
      foldMap(Dict)
  end.

foldMap(#{ foldMap := Dict }) ->
  Dict.

foldableApp() ->
  fun
    (DictFoldable) ->
      foldableApp(DictFoldable)
  end.

foldableApp(#{ foldMap := DictFoldable
             , foldl := DictFoldable@1
             , foldr := DictFoldable@2
             }) ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (I) ->
             fun
               (V) ->
                 ((DictFoldable@2(F))(I))(V)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (I) ->
             fun
               (V) ->
                 ((DictFoldable@1(F))(I))(V)
             end
         end
     end
   , foldMap =>
     fun
       (DictMonoid) ->
         DictFoldable(DictMonoid)
     end
   }.

foldableCompose() ->
  fun
    (DictFoldable) ->
      fun
        (DictFoldable1) ->
          foldableCompose(DictFoldable, DictFoldable1)
      end
  end.

foldableCompose( #{ foldMap := DictFoldable
                  , foldl := DictFoldable@1
                  , foldr := DictFoldable@2
                  }
               , #{ foldMap := DictFoldable1
                  , foldl := DictFoldable1@1
                  , foldr := DictFoldable1@2
                  }
               ) ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (I) ->
             fun
               (V) ->
                 ((DictFoldable@2(begin
                     V@1 = DictFoldable1@2(F),
                     fun
                       (B) ->
                         fun
                           (A) ->
                             (V@1(A))(B)
                         end
                     end
                   end))
                  (I))
                 (V)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (I) ->
             fun
               (V) ->
                 ((DictFoldable@1(DictFoldable1@1(F)))(I))(V)
             end
         end
     end
   , foldMap =>
     fun
       (DictMonoid) ->
         begin
           FoldMap4 = DictFoldable(DictMonoid),
           FoldMap5 = DictFoldable1(DictMonoid),
           fun
             (F) ->
               fun
                 (V) ->
                   (FoldMap4(FoldMap5(F)))(V)
               end
           end
         end
     end
   }.

foldableCoproduct() ->
  fun
    (DictFoldable) ->
      fun
        (DictFoldable1) ->
          foldableCoproduct(DictFoldable, DictFoldable1)
      end
  end.

foldableCoproduct( #{ foldMap := DictFoldable
                    , foldl := DictFoldable@1
                    , foldr := DictFoldable@2
                    }
                 , #{ foldMap := DictFoldable1
                    , foldl := DictFoldable1@1
                    , foldr := DictFoldable1@2
                    }
                 ) ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             begin
               V = (DictFoldable@2(F))(Z),
               V@1 = (DictFoldable1@2(F))(Z),
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
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             begin
               V = (DictFoldable@1(F))(Z),
               V@1 = (DictFoldable1@1(F))(Z),
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
   , foldMap =>
     fun
       (DictMonoid) ->
         begin
           FoldMap4 = DictFoldable(DictMonoid),
           FoldMap5 = DictFoldable1(DictMonoid),
           fun
             (F) ->
               begin
                 V = FoldMap4(F),
                 V@1 = FoldMap5(F),
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
   }.

foldableFirst() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 case V of
                   {nothing} ->
                     Z;
                   {just, V@1} ->
                     (F(V@1))(Z);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 case V of
                   {nothing} ->
                     Z;
                   {just, V@1} ->
                     (F(Z))(V@1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , foldMap =>
     fun
       (#{ mempty := DictMonoid }) ->
         fun
           (V) ->
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
   }.

foldableLast() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 case V of
                   {nothing} ->
                     Z;
                   {just, V@1} ->
                     (F(V@1))(Z);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 case V of
                   {nothing} ->
                     Z;
                   {just, V@1} ->
                     (F(Z))(V@1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , foldMap =>
     fun
       (#{ mempty := DictMonoid }) ->
         fun
           (V) ->
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
   }.

foldableProduct() ->
  fun
    (DictFoldable) ->
      fun
        (DictFoldable1) ->
          foldableProduct(DictFoldable, DictFoldable1)
      end
  end.

foldableProduct( #{ foldMap := DictFoldable
                  , foldl := DictFoldable@1
                  , foldr := DictFoldable@2
                  }
               , #{ foldMap := DictFoldable1
                  , foldl := DictFoldable1@1
                  , foldr := DictFoldable1@2
                  }
               ) ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 ((DictFoldable@2(F))
                  (((DictFoldable1@2(F))(Z))(erlang:element(3, V))))
                 (erlang:element(2, V))
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (V) ->
                 ((DictFoldable1@1(F))
                  (((DictFoldable@1(F))(Z))(erlang:element(2, V))))
                 (erlang:element(3, V))
             end
         end
     end
   , foldMap =>
     fun
       (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
         begin
           FoldMap4 = DictFoldable(DictMonoid),
           FoldMap5 = DictFoldable1(DictMonoid),
           fun
             (F) ->
               fun
                 (V) ->
                   ((erlang:map_get(append, DictMonoid@1(undefined)))
                    ((FoldMap4(F))(erlang:element(2, V))))
                   ((FoldMap5(F))(erlang:element(3, V)))
               end
           end
         end
     end
   }.

foldlDefault() ->
  fun
    (DictFoldable) ->
      foldlDefault(DictFoldable)
  end.

foldlDefault(#{ foldMap := DictFoldable }) ->
  begin
    FoldMap2 = DictFoldable(monoidDual()),
    fun
      (C) ->
        fun
          (U) ->
            fun
              (Xs) ->
                ((FoldMap2(fun
                    (X) ->
                      fun
                        (A) ->
                          (C(A))(X)
                      end
                  end))
                 (Xs))
                (U)
            end
        end
    end
  end.

foldrDefault() ->
  fun
    (DictFoldable) ->
      foldrDefault(DictFoldable)
  end.

foldrDefault(#{ foldMap := DictFoldable }) ->
  begin
    FoldMap2 = DictFoldable(monoidEndo()),
    fun
      (C) ->
        fun
          (U) ->
            fun
              (Xs) ->
                ((FoldMap2(fun
                    (X) ->
                      C(X)
                  end))
                 (Xs))
                (U)
            end
        end
    end
  end.

lookup() ->
  fun
    (DictFoldable) ->
      lookup(DictFoldable)
  end.

lookup(#{ foldMap := DictFoldable }) ->
  begin
    FoldMap2 = DictFoldable(data_maybe_first@ps:monoidFirst()),
    fun
      (#{ eq := DictEq }) ->
        fun
          (A) ->
            FoldMap2(fun
              (V) ->
                case (DictEq(A))(erlang:element(2, V)) of
                  true ->
                    {just, erlang:element(3, V)};
                  _ ->
                    {nothing}
                end
            end)
        end
    end
  end.

surroundMap() ->
  fun
    (DictFoldable) ->
      surroundMap(DictFoldable)
  end.

surroundMap(#{ foldMap := DictFoldable }) ->
  begin
    FoldMap2 = DictFoldable(monoidEndo()),
    fun
      (#{ append := DictSemigroup }) ->
        fun
          (D) ->
            fun
              (T) ->
                fun
                  (F) ->
                    ((FoldMap2(fun
                        (A) ->
                          fun
                            (M) ->
                              (DictSemigroup(D))((DictSemigroup(T(A)))(M))
                          end
                      end))
                     (F))
                    (D)
                end
            end
        end
    end
  end.

surround() ->
  fun
    (DictFoldable) ->
      surround(DictFoldable)
  end.

surround(DictFoldable) ->
  begin
    SurroundMap1 = surroundMap(DictFoldable),
    fun
      (DictSemigroup) ->
        begin
          SurroundMap2 = SurroundMap1(DictSemigroup),
          fun
            (D) ->
              (SurroundMap2(D))(identity())
          end
        end
    end
  end.

foldM() ->
  fun
    (DictFoldable) ->
      fun
        (DictMonad) ->
          fun
            (F) ->
              fun
                (B0) ->
                  foldM(DictFoldable, DictMonad, F, B0)
              end
          end
      end
  end.

foldM( #{ foldl := DictFoldable }
     , #{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }
     , F
     , B0
     ) ->
  (DictFoldable(fun
     (B) ->
       fun
         (A) ->
           ((erlang:map_get(bind, DictMonad@1(undefined)))(B))
           (fun
             (A@1) ->
               (F(A@1))(A)
           end)
       end
   end))
  ((erlang:map_get(pure, DictMonad(undefined)))(B0)).

fold() ->
  fun
    (DictFoldable) ->
      fun
        (DictMonoid) ->
          fold(DictFoldable, DictMonoid)
      end
  end.

fold(#{ foldMap := DictFoldable }, DictMonoid) ->
  (DictFoldable(DictMonoid))(identity()).

findMap() ->
  fun
    (DictFoldable) ->
      fun
        (P) ->
          findMap(DictFoldable, P)
      end
  end.

findMap(#{ foldl := DictFoldable }, P) ->
  (DictFoldable(fun
     (V) ->
       fun
         (V1) ->
           case V of
             {nothing} ->
               P(V1);
             _ ->
               V
           end
       end
   end))
  ({nothing}).

find() ->
  fun
    (DictFoldable) ->
      fun
        (P) ->
          find(DictFoldable, P)
      end
  end.

find(#{ foldl := DictFoldable }, P) ->
  (DictFoldable(fun
     (V) ->
       fun
         (V1) ->
           case ?IS_KNOWN_TAG(nothing, 0, V) andalso (P(V1)) of
             true ->
               {just, V1};
             _ ->
               V
           end
       end
   end))
  ({nothing}).

any() ->
  fun
    (DictFoldable) ->
      fun
        (DictHeytingAlgebra) ->
          any(DictFoldable, DictHeytingAlgebra)
      end
  end.

any( #{ foldMap := DictFoldable }
   , #{ disj := DictHeytingAlgebra, ff := DictHeytingAlgebra@1 }
   ) ->
  DictFoldable(begin
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
  end).

elem() ->
  fun
    (DictFoldable) ->
      elem(DictFoldable)
  end.

elem(#{ foldMap := DictFoldable }) ->
  begin
    Any1 =
      DictFoldable(begin
        SemigroupDisj1 =
          #{ append =>
             fun
               (V) ->
                 fun
                   (V1) ->
                     V orelse V1
                 end
             end
           },
        #{ mempty => false
         , 'Semigroup0' =>
           fun
             (_) ->
               SemigroupDisj1
           end
         }
      end),
    fun
      (#{ eq := DictEq }) ->
        fun
          (X) ->
            Any1(DictEq(X))
        end
    end
  end.

notElem() ->
  fun
    (DictFoldable) ->
      notElem(DictFoldable)
  end.

notElem(#{ foldMap := DictFoldable }) ->
  begin
    Any1 =
      DictFoldable(begin
        SemigroupDisj1 =
          #{ append =>
             fun
               (V) ->
                 fun
                   (V1) ->
                     V orelse V1
                 end
             end
           },
        #{ mempty => false
         , 'Semigroup0' =>
           fun
             (_) ->
               SemigroupDisj1
           end
         }
      end),
    fun
      (#{ eq := DictEq }) ->
        fun
          (X) ->
            begin
              V = Any1(DictEq(X)),
              fun
                (X@1) ->
                  not (V(X@1))
              end
            end
        end
    end
  end.

'or'() ->
  fun
    (DictFoldable) ->
      fun
        (DictHeytingAlgebra) ->
          'or'(DictFoldable, DictHeytingAlgebra)
      end
  end.

'or'( #{ foldMap := DictFoldable }
    , #{ disj := DictHeytingAlgebra, ff := DictHeytingAlgebra@1 }
    ) ->
  (DictFoldable(begin
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
   end))
  (identity()).

all() ->
  fun
    (DictFoldable) ->
      fun
        (DictHeytingAlgebra) ->
          all(DictFoldable, DictHeytingAlgebra)
      end
  end.

all( #{ foldMap := DictFoldable }
   , #{ conj := DictHeytingAlgebra, tt := DictHeytingAlgebra@1 }
   ) ->
  DictFoldable(begin
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
  end).

'and'() ->
  fun
    (DictFoldable) ->
      fun
        (DictHeytingAlgebra) ->
          'and'(DictFoldable, DictHeytingAlgebra)
      end
  end.

'and'( #{ foldMap := DictFoldable }
     , #{ conj := DictHeytingAlgebra, tt := DictHeytingAlgebra@1 }
     ) ->
  (DictFoldable(begin
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
   end))
  (identity()).

foldrArray() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_foldable@foreign:foldrArray(V, V@1, V@2)
          end
      end
  end.

foldlArray() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_foldable@foreign:foldlArray(V, V@1, V@2)
          end
      end
  end.

