-module(data_bifoldable@ps).
-export([ identity/0
        , identity/1
        , 'monoidEndo.semigroupEndo1'/0
        , monoidEndo/0
        , 'monoidDual.semigroupDual1'/0
        , monoidDual/0
        , bifoldr/0
        , bifoldr/1
        , bitraverse_/0
        , bitraverse_/2
        , bifor_/0
        , bifor_/2
        , bisequence_/0
        , bisequence_/2
        , bifoldl/0
        , bifoldl/1
        , bifoldableTuple/0
        , bifoldableJoker/0
        , bifoldableJoker/1
        , bifoldableEither/0
        , bifoldableConst/0
        , bifoldableClown/0
        , bifoldableClown/1
        , bifoldMapDefaultR/0
        , bifoldMapDefaultR/2
        , bifoldMapDefaultL/0
        , bifoldMapDefaultL/2
        , bifoldMap/0
        , bifoldMap/1
        , bifoldableFlip/0
        , bifoldableFlip/1
        , bifoldlDefault/0
        , bifoldlDefault/1
        , bifoldrDefault/0
        , bifoldrDefault/1
        , bifoldableProduct2/0
        , bifoldableProduct2/2
        , bifold/0
        , bifold/2
        , biany/0
        , biany/2
        , biall/0
        , biall/2
        ]).
-compile(no_auto_import).
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

bifoldr() ->
  fun
    (Dict) ->
      bifoldr(Dict)
  end.

bifoldr(#{ bifoldr := Dict }) ->
  Dict.

bitraverse_() ->
  fun
    (DictBifoldable) ->
      fun
        (DictApplicative) ->
          bitraverse_(DictBifoldable, DictApplicative)
      end
  end.

bitraverse_( #{ bifoldr := DictBifoldable }
           , #{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }
           ) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    ApplySecond =
      fun
        (A) ->
          fun
            (B) ->
              (V@1(((erlang:map_get(map, V(undefined)))
                    (fun
                      (_) ->
                        control_apply@ps:identity()
                    end))
                   (A)))
              (B)
          end
      end,
    fun
      (F) ->
        fun
          (G) ->
            ((DictBifoldable(fun
                (X) ->
                  ApplySecond(F(X))
              end))
             (fun
               (X) ->
                 ApplySecond(G(X))
             end))
            (DictApplicative@1(unit))
        end
    end
  end.

bifor_() ->
  fun
    (DictBifoldable) ->
      fun
        (DictApplicative) ->
          bifor_(DictBifoldable, DictApplicative)
      end
  end.

bifor_(DictBifoldable, DictApplicative) ->
  begin
    Bitraverse_2 = bitraverse_(DictBifoldable, DictApplicative),
    fun
      (T) ->
        fun
          (F) ->
            fun
              (G) ->
                ((Bitraverse_2(F))(G))(T)
            end
        end
    end
  end.

bisequence_() ->
  fun
    (DictBifoldable) ->
      fun
        (DictApplicative) ->
          bisequence_(DictBifoldable, DictApplicative)
      end
  end.

bisequence_(DictBifoldable, DictApplicative) ->
  begin
    V = identity(),
    ((bitraverse_(DictBifoldable, DictApplicative))(V))(V)
  end.

bifoldl() ->
  fun
    (Dict) ->
      bifoldl(Dict)
  end.

bifoldl(#{ bifoldl := Dict }) ->
  Dict.

bifoldableTuple() ->
  #{ bifoldMap =>
     fun
       (#{ 'Semigroup0' := DictMonoid }) ->
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (V) ->
                     ((erlang:map_get(append, DictMonoid(undefined)))
                      (F(erlang:element(2, V))))
                     (G(erlang:element(3, V)))
                 end
             end
         end
     end
   , bifoldr =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (Z) ->
                 fun
                   (V) ->
                     (F(erlang:element(2, V)))((G(erlang:element(3, V)))(Z))
                 end
             end
         end
     end
   , bifoldl =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (Z) ->
                 fun
                   (V) ->
                     (G((F(Z))(erlang:element(2, V))))(erlang:element(3, V))
                 end
             end
         end
     end
   }.

bifoldableJoker() ->
  fun
    (DictFoldable) ->
      bifoldableJoker(DictFoldable)
  end.

bifoldableJoker(#{ foldMap := DictFoldable
                 , foldl := DictFoldable@1
                 , foldr := DictFoldable@2
                 }) ->
  #{ bifoldr =>
     fun
       (_) ->
         fun
           (R) ->
             fun
               (U) ->
                 fun
                   (V1) ->
                     ((DictFoldable@2(R))(U))(V1)
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
                     ((DictFoldable@1(R))(U))(V1)
                 end
             end
         end
     end
   , bifoldMap =>
     fun
       (DictMonoid) ->
         begin
           FoldMap1 = DictFoldable(DictMonoid),
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
   }.

bifoldableEither() ->
  #{ bifoldr =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (V2) ->
                 fun
                   (V3) ->
                     case V3 of
                       {left, V3@1} ->
                         (V(V3@1))(V2);
                       {right, V3@2} ->
                         (V1(V3@2))(V2);
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end
             end
         end
     end
   , bifoldl =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (V2) ->
                 fun
                   (V3) ->
                     case V3 of
                       {left, V3@1} ->
                         (V(V2))(V3@1);
                       {right, V3@2} ->
                         (V1(V2))(V3@2);
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end
             end
         end
     end
   , bifoldMap =>
     fun
       (_) ->
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (V2) ->
                     case V2 of
                       {left, V2@1} ->
                         V(V2@1);
                       {right, V2@2} ->
                         V1(V2@2);
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end
             end
         end
     end
   }.

bifoldableConst() ->
  #{ bifoldr =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (Z) ->
                 fun
                   (V1) ->
                     (F(V1))(Z)
                 end
             end
         end
     end
   , bifoldl =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (Z) ->
                 fun
                   (V1) ->
                     (F(Z))(V1)
                 end
             end
         end
     end
   , bifoldMap =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (_) ->
                 fun
                   (V1) ->
                     F(V1)
                 end
             end
         end
     end
   }.

bifoldableClown() ->
  fun
    (DictFoldable) ->
      bifoldableClown(DictFoldable)
  end.

bifoldableClown(#{ foldMap := DictFoldable
                 , foldl := DictFoldable@1
                 , foldr := DictFoldable@2
                 }) ->
  #{ bifoldr =>
     fun
       (L) ->
         fun
           (_) ->
             fun
               (U) ->
                 fun
                   (V1) ->
                     ((DictFoldable@2(L))(U))(V1)
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
                     ((DictFoldable@1(L))(U))(V1)
                 end
             end
         end
     end
   , bifoldMap =>
     fun
       (DictMonoid) ->
         begin
           FoldMap1 = DictFoldable(DictMonoid),
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
   }.

bifoldMapDefaultR() ->
  fun
    (DictBifoldable) ->
      fun
        (DictMonoid) ->
          bifoldMapDefaultR(DictBifoldable, DictMonoid)
      end
  end.

bifoldMapDefaultR( #{ bifoldr := DictBifoldable }
                 , #{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }
                 ) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    fun
      (F) ->
        fun
          (G) ->
            ((DictBifoldable(fun
                (X) ->
                  V(F(X))
              end))
             (fun
               (X) ->
                 V(G(X))
             end))
            (DictMonoid@1)
        end
    end
  end.

bifoldMapDefaultL() ->
  fun
    (DictBifoldable) ->
      fun
        (DictMonoid) ->
          bifoldMapDefaultL(DictBifoldable, DictMonoid)
      end
  end.

bifoldMapDefaultL( #{ bifoldl := DictBifoldable }
                 , #{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }
                 ) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    fun
      (F) ->
        fun
          (G) ->
            ((DictBifoldable(fun
                (M) ->
                  fun
                    (A) ->
                      (V(M))(F(A))
                  end
              end))
             (fun
               (M) ->
                 fun
                   (B) ->
                     (V(M))(G(B))
                 end
             end))
            (DictMonoid@1)
        end
    end
  end.

bifoldMap() ->
  fun
    (Dict) ->
      bifoldMap(Dict)
  end.

bifoldMap(#{ bifoldMap := Dict }) ->
  Dict.

bifoldableFlip() ->
  fun
    (DictBifoldable) ->
      bifoldableFlip(DictBifoldable)
  end.

bifoldableFlip(#{ bifoldMap := DictBifoldable
                , bifoldl := DictBifoldable@1
                , bifoldr := DictBifoldable@2
                }) ->
  #{ bifoldr =>
     fun
       (R) ->
         fun
           (L) ->
             fun
               (U) ->
                 fun
                   (V) ->
                     (((DictBifoldable@2(L))(R))(U))(V)
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
                   (V) ->
                     (((DictBifoldable@1(L))(R))(U))(V)
                 end
             end
         end
     end
   , bifoldMap =>
     fun
       (DictMonoid) ->
         begin
           BifoldMap2 = DictBifoldable(DictMonoid),
           fun
             (R) ->
               fun
                 (L) ->
                   fun
                     (V) ->
                       ((BifoldMap2(L))(R))(V)
                   end
               end
           end
         end
     end
   }.

bifoldlDefault() ->
  fun
    (DictBifoldable) ->
      bifoldlDefault(DictBifoldable)
  end.

bifoldlDefault(#{ bifoldMap := DictBifoldable }) ->
  begin
    BifoldMap1 = DictBifoldable(monoidDual()),
    fun
      (F) ->
        fun
          (G) ->
            fun
              (Z) ->
                fun
                  (P) ->
                    (((BifoldMap1(fun
                         (X) ->
                           fun
                             (A) ->
                               (F(A))(X)
                           end
                       end))
                      (fun
                        (X) ->
                          fun
                            (A) ->
                              (G(A))(X)
                          end
                      end))
                     (P))
                    (Z)
                end
            end
        end
    end
  end.

bifoldrDefault() ->
  fun
    (DictBifoldable) ->
      bifoldrDefault(DictBifoldable)
  end.

bifoldrDefault(#{ bifoldMap := DictBifoldable }) ->
  begin
    BifoldMap1 = DictBifoldable(monoidEndo()),
    fun
      (F) ->
        fun
          (G) ->
            fun
              (Z) ->
                fun
                  (P) ->
                    (((BifoldMap1(fun
                         (X) ->
                           F(X)
                       end))
                      (fun
                        (X) ->
                          G(X)
                      end))
                     (P))
                    (Z)
                end
            end
        end
    end
  end.

bifoldableProduct2() ->
  fun
    (DictBifoldable) ->
      fun
        (DictBifoldable1) ->
          bifoldableProduct2(DictBifoldable, DictBifoldable1)
      end
  end.

bifoldableProduct2( DictBifoldable = #{ bifoldMap := DictBifoldable@1 }
                  , DictBifoldable1 = #{ bifoldMap := DictBifoldable1@1 }
                  ) ->
  #{ bifoldr =>
     fun
       (L) ->
         fun
           (R) ->
             fun
               (U) ->
                 fun
                   (M) ->
                     ((((bifoldrDefault(bifoldableProduct2(
                                          DictBifoldable,
                                          DictBifoldable1
                                        )))
                        (L))
                       (R))
                      (U))
                     (M)
                 end
             end
         end
     end
   , bifoldl =>
     fun
       (L) ->
         fun
           (R) ->
             fun
               (U) ->
                 fun
                   (M) ->
                     ((((bifoldlDefault(bifoldableProduct2(
                                          DictBifoldable,
                                          DictBifoldable1
                                        )))
                        (L))
                       (R))
                      (U))
                     (M)
                 end
             end
         end
     end
   , bifoldMap =>
     fun
       (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
         begin
           BifoldMap3 = DictBifoldable@1(DictMonoid),
           BifoldMap4 = DictBifoldable1@1(DictMonoid),
           fun
             (L) ->
               fun
                 (R) ->
                   fun
                     (V) ->
                       ((erlang:map_get(append, DictMonoid@1(undefined)))
                        (((BifoldMap3(L))(R))(erlang:element(2, V))))
                       (((BifoldMap4(L))(R))(erlang:element(3, V)))
                   end
               end
           end
         end
     end
   }.

bifold() ->
  fun
    (DictBifoldable) ->
      fun
        (DictMonoid) ->
          bifold(DictBifoldable, DictMonoid)
      end
  end.

bifold(#{ bifoldMap := DictBifoldable }, DictMonoid) ->
  begin
    V = identity(),
    ((DictBifoldable(DictMonoid))(V))(V)
  end.

biany() ->
  fun
    (DictBifoldable) ->
      fun
        (DictBooleanAlgebra) ->
          biany(DictBifoldable, DictBooleanAlgebra)
      end
  end.

biany( #{ bifoldMap := DictBifoldable }
     , #{ 'HeytingAlgebra0' := DictBooleanAlgebra }
     ) ->
  begin
    BifoldMap2 =
      DictBifoldable(begin
        #{ disj := V, ff := V@1 } = DictBooleanAlgebra(undefined),
        SemigroupDisj1 =
          #{ append =>
             fun
               (V@2) ->
                 fun
                   (V1) ->
                     (V(V@2))(V1)
                 end
             end
           },
        #{ mempty => V@1
         , 'Semigroup0' =>
           fun
             (_) ->
               SemigroupDisj1
           end
         }
      end),
    fun
      (P) ->
        fun
          (Q) ->
            (BifoldMap2(fun
               (X) ->
                 P(X)
             end))
            (fun
              (X) ->
                Q(X)
            end)
        end
    end
  end.

biall() ->
  fun
    (DictBifoldable) ->
      fun
        (DictBooleanAlgebra) ->
          biall(DictBifoldable, DictBooleanAlgebra)
      end
  end.

biall( #{ bifoldMap := DictBifoldable }
     , #{ 'HeytingAlgebra0' := DictBooleanAlgebra }
     ) ->
  begin
    BifoldMap2 =
      DictBifoldable(begin
        #{ conj := V, tt := V@1 } = DictBooleanAlgebra(undefined),
        SemigroupConj1 =
          #{ append =>
             fun
               (V@2) ->
                 fun
                   (V1) ->
                     (V(V@2))(V1)
                 end
             end
           },
        #{ mempty => V@1
         , 'Semigroup0' =>
           fun
             (_) ->
               SemigroupConj1
           end
         }
      end),
    fun
      (P) ->
        fun
          (Q) ->
            (BifoldMap2(fun
               (X) ->
                 P(X)
             end))
            (fun
              (X) ->
                Q(X)
            end)
        end
    end
  end.

