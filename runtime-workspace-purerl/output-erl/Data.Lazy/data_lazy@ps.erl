-module(data_lazy@ps).
-export([ showLazy/0
        , showLazy/1
        , semiringLazy/0
        , semiringLazy/1
        , semigroupLazy/0
        , semigroupLazy/1
        , ringLazy/0
        , ringLazy/1
        , monoidLazy/0
        , monoidLazy/1
        , lazyLazy/0
        , functorLazy/0
        , functorWithIndexLazy/0
        , invariantLazy/0
        , foldableLazy/0
        , foldableWithIndexLazy/0
        , traversableLazy/0
        , traversableWithIndexLazy/0
        , foldable1Lazy/0
        , traversable1Lazy/0
        , extendLazy/0
        , eqLazy/0
        , eqLazy/1
        , ordLazy/0
        , ordLazy/1
        , eq1Lazy/0
        , ord1Lazy/0
        , comonadLazy/0
        , commutativeRingLazy/0
        , commutativeRingLazy/1
        , euclideanRingLazy/0
        , euclideanRingLazy/1
        , boundedLazy/0
        , boundedLazy/1
        , applyLazy/0
        , bindLazy/0
        , heytingAlgebraLazy/0
        , heytingAlgebraLazy/1
        , booleanAlgebraLazy/0
        , booleanAlgebraLazy/1
        , applicativeLazy/0
        , monadLazy/0
        , defer/0
        , force/0
        ]).
-compile(no_auto_import).
showLazy() ->
  fun
    (DictShow) ->
      showLazy(DictShow)
  end.

showLazy(#{ show := DictShow }) ->
  #{ show =>
     fun
       (X) ->
         <<
           "(defer \\_ -> ",
           (DictShow(data_lazy@foreign:force(X)))/binary,
           ")"
         >>
     end
   }.

semiringLazy() ->
  fun
    (DictSemiring) ->
      semiringLazy(DictSemiring)
  end.

semiringLazy(#{ add := DictSemiring
              , mul := DictSemiring@1
              , one := DictSemiring@2
              , zero := DictSemiring@3
              }) ->
  #{ add =>
     fun
       (A) ->
         fun
           (B) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 (DictSemiring(data_lazy@foreign:force(A)))
                 (data_lazy@foreign:force(B))
             end)
         end
     end
   , zero =>
     data_lazy@foreign:defer(fun
       (_) ->
         DictSemiring@3
     end)
   , mul =>
     fun
       (A) ->
         fun
           (B) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 (DictSemiring@1(data_lazy@foreign:force(A)))
                 (data_lazy@foreign:force(B))
             end)
         end
     end
   , one =>
     data_lazy@foreign:defer(fun
       (_) ->
         DictSemiring@2
     end)
   }.

semigroupLazy() ->
  fun
    (DictSemigroup) ->
      semigroupLazy(DictSemigroup)
  end.

semigroupLazy(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (A) ->
         fun
           (B) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 (DictSemigroup(data_lazy@foreign:force(A)))
                 (data_lazy@foreign:force(B))
             end)
         end
     end
   }.

ringLazy() ->
  fun
    (DictRing) ->
      ringLazy(DictRing)
  end.

ringLazy(#{ 'Semiring0' := DictRing, sub := DictRing@1 }) ->
  begin
    SemiringLazy1 = semiringLazy(DictRing(undefined)),
    #{ sub =>
       fun
         (A) ->
           fun
             (B) ->
               data_lazy@foreign:defer(fun
                 (_) ->
                   (DictRing@1(data_lazy@foreign:force(A)))
                   (data_lazy@foreign:force(B))
               end)
           end
       end
     , 'Semiring0' =>
       fun
         (_) ->
           SemiringLazy1
       end
     }
  end.

monoidLazy() ->
  fun
    (DictMonoid) ->
      monoidLazy(DictMonoid)
  end.

monoidLazy(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    SemigroupLazy1 = semigroupLazy(DictMonoid(undefined)),
    #{ mempty =>
       data_lazy@foreign:defer(fun
         (_) ->
           DictMonoid@1
       end)
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupLazy1
       end
     }
  end.

lazyLazy() ->
  #{ defer =>
     fun
       (F) ->
         data_lazy@foreign:defer(fun
           (_) ->
             data_lazy@foreign:force(F(unit))
         end)
     end
   }.

functorLazy() ->
  #{ map =>
     fun
       (F) ->
         fun
           (L) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 F(data_lazy@foreign:force(L))
             end)
         end
     end
   }.

functorWithIndexLazy() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         (erlang:map_get(map, functorLazy()))(F(unit))
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorLazy()
     end
   }.

invariantLazy() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             (erlang:map_get(map, functorLazy()))(F)
         end
     end
   }.

foldableLazy() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (L) ->
                 (F(data_lazy@foreign:force(L)))(Z)
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (L) ->
                 (F(Z))(data_lazy@foreign:force(L))
             end
         end
     end
   , foldMap =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (L) ->
                 F(data_lazy@foreign:force(L))
             end
         end
     end
   }.

foldableWithIndexLazy() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         (erlang:map_get(foldr, foldableLazy()))(F(unit))
     end
   , foldlWithIndex =>
     fun
       (F) ->
         (erlang:map_get(foldl, foldableLazy()))(F(unit))
     end
   , foldMapWithIndex =>
     fun
       (DictMonoid) ->
         fun
           (F) ->
             ((erlang:map_get(foldMap, foldableLazy()))(DictMonoid))(F(unit))
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         foldableLazy()
     end
   }.

traversableLazy() ->
  #{ traverse =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (F) ->
             fun
               (L) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative(undefined)))
                     (undefined)
                   ))
                  (fun
                    (X) ->
                      data_lazy@foreign:defer(fun
                        (_) ->
                          X
                      end)
                  end))
                 (F(data_lazy@foreign:force(L)))
             end
         end
     end
   , sequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         fun
           (L) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictApplicative(undefined)))
                 (undefined)
               ))
              (fun
                (X) ->
                  data_lazy@foreign:defer(fun
                    (_) ->
                      X
                  end)
              end))
             (data_lazy@foreign:force(L))
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorLazy()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         foldableLazy()
     end
   }.

traversableWithIndexLazy() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative) ->
         fun
           (F) ->
             ((erlang:map_get(traverse, traversableLazy()))(DictApplicative))
             (F(unit))
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         functorWithIndexLazy()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         foldableWithIndexLazy()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         traversableLazy()
     end
   }.

foldable1Lazy() ->
  #{ foldMap1 =>
     fun
       (_) ->
         fun
           (F) ->
             fun
               (L) ->
                 F(data_lazy@foreign:force(L))
             end
         end
     end
   , foldr1 =>
     fun
       (_) ->
         fun
           (L) ->
             data_lazy@foreign:force(L)
         end
     end
   , foldl1 =>
     fun
       (_) ->
         fun
           (L) ->
             data_lazy@foreign:force(L)
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         foldableLazy()
     end
   }.

traversable1Lazy() ->
  #{ traverse1 =>
     fun
       (#{ 'Functor0' := DictApply }) ->
         fun
           (F) ->
             fun
               (L) ->
                 ((erlang:map_get(map, DictApply(undefined)))
                  (fun
                    (X) ->
                      data_lazy@foreign:defer(fun
                        (_) ->
                          X
                      end)
                  end))
                 (F(data_lazy@foreign:force(L)))
             end
         end
     end
   , sequence1 =>
     fun
       (#{ 'Functor0' := DictApply }) ->
         fun
           (L) ->
             ((erlang:map_get(map, DictApply(undefined)))
              (fun
                (X) ->
                  data_lazy@foreign:defer(fun
                    (_) ->
                      X
                  end)
              end))
             (data_lazy@foreign:force(L))
         end
     end
   , 'Foldable10' =>
     fun
       (_) ->
         foldable1Lazy()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         traversableLazy()
     end
   }.

extendLazy() ->
  #{ extend =>
     fun
       (F) ->
         fun
           (X) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 F(X)
             end)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorLazy()
     end
   }.

eqLazy() ->
  fun
    (DictEq) ->
      eqLazy(DictEq)
  end.

eqLazy(#{ eq := DictEq }) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             (DictEq(data_lazy@foreign:force(X)))(data_lazy@foreign:force(Y))
         end
     end
   }.

ordLazy() ->
  fun
    (DictOrd) ->
      ordLazy(DictOrd)
  end.

ordLazy(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    #{ eq := V } = DictOrd(undefined),
    EqLazy1 =
      #{ eq =>
         fun
           (X) ->
             fun
               (Y) ->
                 (V(data_lazy@foreign:force(X)))(data_lazy@foreign:force(Y))
             end
         end
       },
    #{ compare =>
       fun
         (X) ->
           fun
             (Y) ->
               (DictOrd@1(data_lazy@foreign:force(X)))
               (data_lazy@foreign:force(Y))
           end
       end
     , 'Eq0' =>
       fun
         (_) ->
           EqLazy1
       end
     }
  end.

eq1Lazy() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         fun
           (X) ->
             fun
               (Y) ->
                 (DictEq(data_lazy@foreign:force(X)))
                 (data_lazy@foreign:force(Y))
             end
         end
     end
   }.

ord1Lazy() ->
  #{ compare1 =>
     fun
       (DictOrd) ->
         erlang:map_get(compare, ordLazy(DictOrd))
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Lazy()
     end
   }.

comonadLazy() ->
  #{ extract => force()
   , 'Extend0' =>
     fun
       (_) ->
         extendLazy()
     end
   }.

commutativeRingLazy() ->
  fun
    (DictCommutativeRing) ->
      commutativeRingLazy(DictCommutativeRing)
  end.

commutativeRingLazy(#{ 'Ring0' := DictCommutativeRing }) ->
  begin
    RingLazy1 = ringLazy(DictCommutativeRing(undefined)),
    #{ 'Ring0' =>
       fun
         (_) ->
           RingLazy1
       end
     }
  end.

euclideanRingLazy() ->
  fun
    (DictEuclideanRing) ->
      euclideanRingLazy(DictEuclideanRing)
  end.

euclideanRingLazy(#{ 'CommutativeRing0' := DictEuclideanRing
                   , degree := DictEuclideanRing@1
                   , 'div' := DictEuclideanRing@2
                   , mod := DictEuclideanRing@3
                   }) ->
  begin
    RingLazy1 =
      ringLazy((erlang:map_get('Ring0', DictEuclideanRing(undefined)))
               (undefined)),
    #{ degree =>
       fun
         (X) ->
           DictEuclideanRing@1(data_lazy@foreign:force(X))
       end
     , 'div' =>
       fun
         (A) ->
           fun
             (B) ->
               data_lazy@foreign:defer(fun
                 (_) ->
                   (DictEuclideanRing@2(data_lazy@foreign:force(A)))
                   (data_lazy@foreign:force(B))
               end)
           end
       end
     , mod =>
       fun
         (A) ->
           fun
             (B) ->
               data_lazy@foreign:defer(fun
                 (_) ->
                   (DictEuclideanRing@3(data_lazy@foreign:force(A)))
                   (data_lazy@foreign:force(B))
               end)
           end
       end
     , 'CommutativeRing0' =>
       fun
         (_) ->
           #{ 'Ring0' =>
              fun
                (_) ->
                  RingLazy1
              end
            }
       end
     }
  end.

boundedLazy() ->
  fun
    (DictBounded) ->
      boundedLazy(DictBounded)
  end.

boundedLazy(#{ 'Ord0' := DictBounded
             , bottom := DictBounded@1
             , top := DictBounded@2
             }) ->
  begin
    OrdLazy1 = ordLazy(DictBounded(undefined)),
    #{ top =>
       data_lazy@foreign:defer(fun
         (_) ->
           DictBounded@2
       end)
     , bottom =>
       data_lazy@foreign:defer(fun
         (_) ->
           DictBounded@1
       end)
     , 'Ord0' =>
       fun
         (_) ->
           OrdLazy1
       end
     }
  end.

applyLazy() ->
  #{ apply =>
     fun
       (F) ->
         fun
           (X) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 (data_lazy@foreign:force(F))(data_lazy@foreign:force(X))
             end)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorLazy()
     end
   }.

bindLazy() ->
  #{ bind =>
     fun
       (L) ->
         fun
           (F) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 data_lazy@foreign:force(F(data_lazy@foreign:force(L)))
             end)
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyLazy()
     end
   }.

heytingAlgebraLazy() ->
  fun
    (DictHeytingAlgebra) ->
      heytingAlgebraLazy(DictHeytingAlgebra)
  end.

heytingAlgebraLazy(#{ conj := DictHeytingAlgebra
                    , disj := DictHeytingAlgebra@1
                    , ff := DictHeytingAlgebra@2
                    , implies := DictHeytingAlgebra@3
                    , 'not' := DictHeytingAlgebra@4
                    , tt := DictHeytingAlgebra@5
                    }) ->
  #{ ff =>
     data_lazy@foreign:defer(fun
       (_) ->
         DictHeytingAlgebra@2
     end)
   , tt =>
     data_lazy@foreign:defer(fun
       (_) ->
         DictHeytingAlgebra@5
     end)
   , implies =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               V =
                 data_lazy@foreign:defer(fun
                   (_) ->
                     DictHeytingAlgebra@3(data_lazy@foreign:force(A))
                 end),
               data_lazy@foreign:defer(fun
                 (_) ->
                   (data_lazy@foreign:force(V))(data_lazy@foreign:force(B))
               end)
             end
         end
     end
   , conj =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               V =
                 data_lazy@foreign:defer(fun
                   (_) ->
                     DictHeytingAlgebra(data_lazy@foreign:force(A))
                 end),
               data_lazy@foreign:defer(fun
                 (_) ->
                   (data_lazy@foreign:force(V))(data_lazy@foreign:force(B))
               end)
             end
         end
     end
   , disj =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               V =
                 data_lazy@foreign:defer(fun
                   (_) ->
                     DictHeytingAlgebra@1(data_lazy@foreign:force(A))
                 end),
               data_lazy@foreign:defer(fun
                 (_) ->
                   (data_lazy@foreign:force(V))(data_lazy@foreign:force(B))
               end)
             end
         end
     end
   , 'not' =>
     fun
       (A) ->
         data_lazy@foreign:defer(fun
           (_) ->
             DictHeytingAlgebra@4(data_lazy@foreign:force(A))
         end)
     end
   }.

booleanAlgebraLazy() ->
  fun
    (DictBooleanAlgebra) ->
      booleanAlgebraLazy(DictBooleanAlgebra)
  end.

booleanAlgebraLazy(#{ 'HeytingAlgebra0' := DictBooleanAlgebra }) ->
  begin
    HeytingAlgebraLazy1 = heytingAlgebraLazy(DictBooleanAlgebra(undefined)),
    #{ 'HeytingAlgebra0' =>
       fun
         (_) ->
           HeytingAlgebraLazy1
       end
     }
  end.

applicativeLazy() ->
  #{ pure =>
     fun
       (A) ->
         data_lazy@foreign:defer(fun
           (_) ->
             A
         end)
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyLazy()
     end
   }.

monadLazy() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeLazy()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindLazy()
     end
   }.

defer() ->
  fun
    (V) ->
      data_lazy@foreign:defer(V)
  end.

force() ->
  fun
    (V) ->
      data_lazy@foreign:force(V)
  end.

