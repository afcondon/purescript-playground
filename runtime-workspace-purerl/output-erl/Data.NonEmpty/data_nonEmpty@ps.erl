-module(data_nonEmpty@ps).
-export([ 'NonEmpty'/0
        , unfoldable1NonEmpty/0
        , unfoldable1NonEmpty/1
        , tail/0
        , tail/1
        , singleton/0
        , singleton/1
        , showNonEmpty/0
        , showNonEmpty/2
        , oneOf/0
        , oneOf/2
        , head/0
        , head/1
        , functorNonEmpty/0
        , functorNonEmpty/1
        , functorWithIndex/0
        , functorWithIndex/1
        , fromNonEmpty/0
        , fromNonEmpty/2
        , foldableNonEmpty/0
        , foldableNonEmpty/1
        , foldableWithIndexNonEmpty/0
        , foldableWithIndexNonEmpty/1
        , traversableNonEmpty/0
        , traversableNonEmpty/1
        , traversableWithIndexNonEmpty/0
        , traversableWithIndexNonEmpty/1
        , foldable1NonEmpty/0
        , foldable1NonEmpty/1
        , foldl1/0
        , foldl1/1
        , eqNonEmpty/0
        , eqNonEmpty/2
        , ordNonEmpty/0
        , ordNonEmpty/1
        , eq1NonEmpty/0
        , eq1NonEmpty/1
        , ord1NonEmpty/0
        , ord1NonEmpty/1
        ]).
-compile(no_auto_import).
'NonEmpty'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {nonEmpty, Value0, Value1}
      end
  end.

unfoldable1NonEmpty() ->
  fun
    (DictUnfoldable) ->
      unfoldable1NonEmpty(DictUnfoldable)
  end.

unfoldable1NonEmpty(#{ unfoldr := DictUnfoldable }) ->
  #{ unfoldr1 =>
     fun
       (F) ->
         fun
           (B) ->
             begin
               V = F(B),
               { nonEmpty
               , erlang:element(2, V)
               , (DictUnfoldable(fun
                    (V1) ->
                      case V1 of
                        {just, V1@1} ->
                          {just, F(V1@1)};
                        _ ->
                          {nothing}
                      end
                  end))
                 (erlang:element(3, V))
               }
             end
         end
     end
   }.

tail() ->
  fun
    (V) ->
      tail(V)
  end.

tail(V) ->
  erlang:element(3, V).

singleton() ->
  fun
    (DictPlus) ->
      singleton(DictPlus)
  end.

singleton(#{ empty := DictPlus }) ->
  fun
    (A) ->
      {nonEmpty, A, DictPlus}
  end.

showNonEmpty() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showNonEmpty(DictShow, DictShow1)
      end
  end.

showNonEmpty(#{ show := DictShow }, #{ show := DictShow1 }) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(NonEmpty ",
           (DictShow(erlang:element(2, V)))/binary,
           " ",
           (DictShow1(erlang:element(3, V)))/binary,
           ")"
         >>
     end
   }.

oneOf() ->
  fun
    (DictAlternative) ->
      fun
        (V) ->
          oneOf(DictAlternative, V)
      end
  end.

oneOf(#{ 'Applicative0' := DictAlternative, 'Plus1' := DictAlternative@1 }, V) ->
  ((erlang:map_get(
      alt,
      (erlang:map_get('Alt0', DictAlternative@1(undefined)))(undefined)
    ))
   ((erlang:map_get(pure, DictAlternative(undefined)))(erlang:element(2, V))))
  (erlang:element(3, V)).

head() ->
  fun
    (V) ->
      head(V)
  end.

head(V) ->
  erlang:element(2, V).

functorNonEmpty() ->
  fun
    (DictFunctor) ->
      functorNonEmpty(DictFunctor)
  end.

functorNonEmpty(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             { nonEmpty
             , F(erlang:element(2, M))
             , (DictFunctor(F))(erlang:element(3, M))
             }
         end
     end
   }.

functorWithIndex() ->
  fun
    (DictFunctorWithIndex) ->
      functorWithIndex(DictFunctorWithIndex)
  end.

functorWithIndex(#{ 'Functor0' := DictFunctorWithIndex
                  , mapWithIndex := DictFunctorWithIndex@1
                  }) ->
  begin
    #{ map := V } = DictFunctorWithIndex(undefined),
    FunctorNonEmpty1 =
      #{ map =>
         fun
           (F) ->
             fun
               (M) ->
                 { nonEmpty
                 , F(erlang:element(2, M))
                 , (V(F))(erlang:element(3, M))
                 }
             end
         end
       },
    #{ mapWithIndex =>
       fun
         (F) ->
           fun
             (V@1) ->
               { nonEmpty
               , (F({nothing}))(erlang:element(2, V@1))
               , (DictFunctorWithIndex@1(fun
                    (X) ->
                      F({just, X})
                  end))
                 (erlang:element(3, V@1))
               }
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorNonEmpty1
       end
     }
  end.

fromNonEmpty() ->
  fun
    (F) ->
      fun
        (V) ->
          fromNonEmpty(F, V)
      end
  end.

fromNonEmpty(F, V) ->
  (F(erlang:element(2, V)))(erlang:element(3, V)).

foldableNonEmpty() ->
  fun
    (DictFoldable) ->
      foldableNonEmpty(DictFoldable)
  end.

foldableNonEmpty(#{ foldMap := DictFoldable
                  , foldl := DictFoldable@1
                  , foldr := DictFoldable@2
                  }) ->
  #{ foldMap =>
     fun
       (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
         begin
           FoldMap1 = DictFoldable(DictMonoid),
           fun
             (F) ->
               fun
                 (V) ->
                   ((erlang:map_get(append, DictMonoid@1(undefined)))
                    (F(erlang:element(2, V))))
                   ((FoldMap1(F))(erlang:element(3, V)))
               end
           end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (V) ->
                 ((DictFoldable@1(F))((F(B))(erlang:element(2, V))))
                 (erlang:element(3, V))
             end
         end
     end
   , foldr =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (V) ->
                 (F(erlang:element(2, V)))
                 (((DictFoldable@2(F))(B))(erlang:element(3, V)))
             end
         end
     end
   }.

foldableWithIndexNonEmpty() ->
  fun
    (DictFoldableWithIndex) ->
      foldableWithIndexNonEmpty(DictFoldableWithIndex)
  end.

foldableWithIndexNonEmpty(#{ 'Foldable0' := DictFoldableWithIndex
                           , foldMapWithIndex := DictFoldableWithIndex@1
                           , foldlWithIndex := DictFoldableWithIndex@2
                           , foldrWithIndex := DictFoldableWithIndex@3
                           }) ->
  begin
    #{ foldMap := V, foldl := V@1, foldr := V@2 } =
      DictFoldableWithIndex(undefined),
    FoldableNonEmpty1 =
      #{ foldMap =>
         fun
           (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
             begin
               FoldMap1 = V(DictMonoid),
               fun
                 (F) ->
                   fun
                     (V@3) ->
                       ((erlang:map_get(append, DictMonoid@1(undefined)))
                        (F(erlang:element(2, V@3))))
                       ((FoldMap1(F))(erlang:element(3, V@3)))
                   end
               end
             end
         end
       , foldl =>
         fun
           (F) ->
             fun
               (B) ->
                 fun
                   (V@3) ->
                     ((V@1(F))((F(B))(erlang:element(2, V@3))))
                     (erlang:element(3, V@3))
                 end
             end
         end
       , foldr =>
         fun
           (F) ->
             fun
               (B) ->
                 fun
                   (V@3) ->
                     (F(erlang:element(2, V@3)))
                     (((V@2(F))(B))(erlang:element(3, V@3)))
                 end
             end
         end
       },
    #{ foldMapWithIndex =>
       fun
         (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
           begin
             FoldMapWithIndex1 = DictFoldableWithIndex@1(DictMonoid),
             fun
               (F) ->
                 fun
                   (V@3) ->
                     ((erlang:map_get(append, DictMonoid@1(undefined)))
                      ((F({nothing}))(erlang:element(2, V@3))))
                     ((FoldMapWithIndex1(fun
                         (X) ->
                           F({just, X})
                       end))
                      (erlang:element(3, V@3)))
                 end
             end
           end
       end
     , foldlWithIndex =>
       fun
         (F) ->
           fun
             (B) ->
               fun
                 (V@3) ->
                   ((DictFoldableWithIndex@2(fun
                       (X) ->
                         F({just, X})
                     end))
                    (((F({nothing}))(B))(erlang:element(2, V@3))))
                   (erlang:element(3, V@3))
               end
           end
       end
     , foldrWithIndex =>
       fun
         (F) ->
           fun
             (B) ->
               fun
                 (V@3) ->
                   ((F({nothing}))(erlang:element(2, V@3)))
                   (((DictFoldableWithIndex@3(fun
                        (X) ->
                          F({just, X})
                      end))
                     (B))
                    (erlang:element(3, V@3)))
               end
           end
       end
     , 'Foldable0' =>
       fun
         (_) ->
           FoldableNonEmpty1
       end
     }
  end.

traversableNonEmpty() ->
  fun
    (DictTraversable) ->
      traversableNonEmpty(DictTraversable)
  end.

traversableNonEmpty(#{ 'Foldable1' := DictTraversable
                     , 'Functor0' := DictTraversable@1
                     , sequence := DictTraversable@2
                     , traverse := DictTraversable@3
                     }) ->
  begin
    #{ map := V } = DictTraversable@1(undefined),
    FunctorNonEmpty1 =
      #{ map =>
         fun
           (F) ->
             fun
               (M) ->
                 { nonEmpty
                 , F(erlang:element(2, M))
                 , (V(F))(erlang:element(3, M))
                 }
             end
         end
       },
    #{ foldMap := V@1, foldl := V@2, foldr := V@3 } = DictTraversable(undefined),
    FoldableNonEmpty1 =
      #{ foldMap =>
         fun
           (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
             begin
               FoldMap1 = V@1(DictMonoid),
               fun
                 (F) ->
                   fun
                     (V@4) ->
                       ((erlang:map_get(append, DictMonoid@1(undefined)))
                        (F(erlang:element(2, V@4))))
                       ((FoldMap1(F))(erlang:element(3, V@4)))
                   end
               end
             end
         end
       , foldl =>
         fun
           (F) ->
             fun
               (B) ->
                 fun
                   (V@4) ->
                     ((V@2(F))((F(B))(erlang:element(2, V@4))))
                     (erlang:element(3, V@4))
                 end
             end
         end
       , foldr =>
         fun
           (F) ->
             fun
               (B) ->
                 fun
                   (V@4) ->
                     (F(erlang:element(2, V@4)))
                     (((V@3(F))(B))(erlang:element(3, V@4)))
                 end
             end
         end
       },
    #{ sequence =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             #{ 'Functor0' := Apply0, apply := Apply0@1 } =
               DictApplicative@1(undefined),
             Sequence1 = DictTraversable@2(DictApplicative),
             fun
               (V@4) ->
                 (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                            ('NonEmpty'()))
                           (erlang:element(2, V@4))))
                 (Sequence1(erlang:element(3, V@4)))
             end
           end
       end
     , traverse =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             #{ 'Functor0' := Apply0, apply := Apply0@1 } =
               DictApplicative@1(undefined),
             Traverse1 = DictTraversable@3(DictApplicative),
             fun
               (F) ->
                 fun
                   (V@4) ->
                     (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                                ('NonEmpty'()))
                               (F(erlang:element(2, V@4)))))
                     ((Traverse1(F))(erlang:element(3, V@4)))
                 end
             end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorNonEmpty1
       end
     , 'Foldable1' =>
       fun
         (_) ->
           FoldableNonEmpty1
       end
     }
  end.

traversableWithIndexNonEmpty() ->
  fun
    (DictTraversableWithIndex) ->
      traversableWithIndexNonEmpty(DictTraversableWithIndex)
  end.

traversableWithIndexNonEmpty(#{ 'FoldableWithIndex1' := DictTraversableWithIndex
                              , 'FunctorWithIndex0' :=
                                DictTraversableWithIndex@1
                              , 'Traversable2' := DictTraversableWithIndex@2
                              , traverseWithIndex := DictTraversableWithIndex@3
                              }) ->
  begin
    #{ 'Functor0' := V, mapWithIndex := V@1 } =
      DictTraversableWithIndex@1(undefined),
    #{ map := V@2 } = V(undefined),
    FunctorWithIndex1 =
      begin
        FunctorNonEmpty1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (M) ->
                     { nonEmpty
                     , F(erlang:element(2, M))
                     , (V@2(F))(erlang:element(3, M))
                     }
                 end
             end
           },
        #{ mapWithIndex =>
           fun
             (F) ->
               fun
                 (V@3) ->
                   { nonEmpty
                   , (F({nothing}))(erlang:element(2, V@3))
                   , (V@1(fun
                        (X) ->
                          F({just, X})
                      end))
                     (erlang:element(3, V@3))
                   }
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorNonEmpty1
           end
         }
      end,
    FoldableWithIndexNonEmpty1 =
      foldableWithIndexNonEmpty(DictTraversableWithIndex(undefined)),
    TraversableNonEmpty1 =
      traversableNonEmpty(DictTraversableWithIndex@2(undefined)),
    #{ traverseWithIndex =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             #{ 'Functor0' := Apply0, apply := Apply0@1 } =
               DictApplicative@1(undefined),
             TraverseWithIndex1 = DictTraversableWithIndex@3(DictApplicative),
             fun
               (F) ->
                 fun
                   (V@3) ->
                     (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                                ('NonEmpty'()))
                               ((F({nothing}))(erlang:element(2, V@3)))))
                     ((TraverseWithIndex1(fun
                         (X) ->
                           F({just, X})
                       end))
                      (erlang:element(3, V@3)))
                 end
             end
           end
       end
     , 'FunctorWithIndex0' =>
       fun
         (_) ->
           FunctorWithIndex1
       end
     , 'FoldableWithIndex1' =>
       fun
         (_) ->
           FoldableWithIndexNonEmpty1
       end
     , 'Traversable2' =>
       fun
         (_) ->
           TraversableNonEmpty1
       end
     }
  end.

foldable1NonEmpty() ->
  fun
    (DictFoldable) ->
      foldable1NonEmpty(DictFoldable)
  end.

foldable1NonEmpty(#{ foldMap := DictFoldable
                   , foldl := DictFoldable@1
                   , foldr := DictFoldable@2
                   }) ->
  begin
    FoldableNonEmpty1 =
      #{ foldMap =>
         fun
           (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
             begin
               FoldMap1 = DictFoldable(DictMonoid),
               fun
                 (F) ->
                   fun
                     (V) ->
                       ((erlang:map_get(append, DictMonoid@1(undefined)))
                        (F(erlang:element(2, V))))
                       ((FoldMap1(F))(erlang:element(3, V)))
                   end
               end
             end
         end
       , foldl =>
         fun
           (F) ->
             fun
               (B) ->
                 fun
                   (V) ->
                     ((DictFoldable@1(F))((F(B))(erlang:element(2, V))))
                     (erlang:element(3, V))
                 end
             end
         end
       , foldr =>
         fun
           (F) ->
             fun
               (B) ->
                 fun
                   (V) ->
                     (F(erlang:element(2, V)))
                     (((DictFoldable@2(F))(B))(erlang:element(3, V)))
                 end
             end
         end
       },
    #{ foldMap1 =>
       fun
         (#{ append := DictSemigroup }) ->
           fun
             (F) ->
               fun
                 (V) ->
                   ((DictFoldable@1(fun
                       (S) ->
                         fun
                           (A1) ->
                             (DictSemigroup(S))(F(A1))
                         end
                     end))
                    (F(erlang:element(2, V))))
                   (erlang:element(3, V))
               end
           end
       end
     , foldr1 =>
       fun
         (F) ->
           fun
             (V) ->
               begin
                 V@1 = F(erlang:element(2, V)),
                 V@2 =
                   ((DictFoldable@2(fun
                       (A1) ->
                         begin
                           V@2 = F(A1),
                           fun
                             (X) ->
                               { just
                               , case X of
                                   {nothing} ->
                                     A1;
                                   {just, X@1} ->
                                     V@2(X@1);
                                   _ ->
                                     erlang:error({ fail
                                                  , <<"Failed pattern match">>
                                                  })
                                 end
                               }
                           end
                         end
                     end))
                    ({nothing}))
                   (erlang:element(3, V)),
                 case V@2 of
                   {nothing} ->
                     erlang:element(2, V);
                   {just, V@3} ->
                     V@1(V@3);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
               end
           end
       end
     , foldl1 =>
       fun
         (F) ->
           fun
             (V) ->
               ((DictFoldable@1(F))(erlang:element(2, V)))(erlang:element(3, V))
           end
       end
     , 'Foldable0' =>
       fun
         (_) ->
           FoldableNonEmpty1
       end
     }
  end.

foldl1() ->
  fun
    (DictFoldable) ->
      foldl1(DictFoldable)
  end.

foldl1(DictFoldable) ->
  begin
    Foldl11 = erlang:map_get(foldl1, foldable1NonEmpty(DictFoldable)),
    fun
      (_) ->
        Foldl11
    end
  end.

eqNonEmpty() ->
  fun
    (DictEq1) ->
      fun
        (DictEq) ->
          eqNonEmpty(DictEq1, DictEq)
      end
  end.

eqNonEmpty(#{ eq1 := DictEq1 }, DictEq = #{ eq := DictEq@1 }) ->
  begin
    Eq11 = DictEq1(DictEq),
    #{ eq =>
       fun
         (X) ->
           fun
             (Y) ->
               ((DictEq@1(erlang:element(2, X)))(erlang:element(2, Y)))
                 andalso ((Eq11(erlang:element(3, X)))(erlang:element(3, Y)))
           end
       end
     }
  end.

ordNonEmpty() ->
  fun
    (DictOrd1) ->
      ordNonEmpty(DictOrd1)
  end.

ordNonEmpty(#{ 'Eq10' := DictOrd1, compare1 := DictOrd1@1 }) ->
  begin
    #{ eq1 := V } = DictOrd1(undefined),
    fun
      (DictOrd = #{ 'Eq0' := DictOrd@1, compare := DictOrd@2 }) ->
        begin
          Compare11 = DictOrd1@1(DictOrd),
          V@1 = #{ eq := V@2 } = DictOrd@1(undefined),
          Eq11 = V(V@1),
          EqNonEmpty2 =
            #{ eq =>
               fun
                 (X) ->
                   fun
                     (Y) ->
                       ((V@2(erlang:element(2, X)))(erlang:element(2, Y)))
                         andalso ((Eq11(erlang:element(3, X)))
                                  (erlang:element(3, Y)))
                   end
               end
             },
          #{ compare =>
             fun
               (X) ->
                 fun
                   (Y) ->
                     begin
                       V@3 =
                         (DictOrd@2(erlang:element(2, X)))(erlang:element(2, Y)),
                       case V@3 of
                         {lT} ->
                           {lT};
                         {gT} ->
                           {gT};
                         _ ->
                           (Compare11(erlang:element(3, X)))
                           (erlang:element(3, Y))
                       end
                     end
                 end
             end
           , 'Eq0' =>
             fun
               (_) ->
                 EqNonEmpty2
             end
           }
        end
    end
  end.

eq1NonEmpty() ->
  fun
    (DictEq1) ->
      eq1NonEmpty(DictEq1)
  end.

eq1NonEmpty(#{ eq1 := DictEq1 }) ->
  #{ eq1 =>
     fun
       (DictEq = #{ eq := DictEq@1 }) ->
         begin
           Eq11 = DictEq1(DictEq),
           fun
             (X) ->
               fun
                 (Y) ->
                   ((DictEq@1(erlang:element(2, X)))(erlang:element(2, Y)))
                     andalso ((Eq11(erlang:element(3, X)))
                              (erlang:element(3, Y)))
               end
           end
         end
     end
   }.

ord1NonEmpty() ->
  fun
    (DictOrd1) ->
      ord1NonEmpty(DictOrd1)
  end.

ord1NonEmpty(DictOrd1 = #{ 'Eq10' := DictOrd1@1 }) ->
  begin
    OrdNonEmpty1 = ordNonEmpty(DictOrd1),
    #{ eq1 := V } = DictOrd1@1(undefined),
    Eq1NonEmpty1 =
      #{ eq1 =>
         fun
           (DictEq = #{ eq := DictEq@1 }) ->
             begin
               Eq11 = V(DictEq),
               fun
                 (X) ->
                   fun
                     (Y) ->
                       ((DictEq@1(erlang:element(2, X)))(erlang:element(2, Y)))
                         andalso ((Eq11(erlang:element(3, X)))
                                  (erlang:element(3, Y)))
                   end
               end
             end
         end
       },
    #{ compare1 =>
       fun
         (DictOrd) ->
           erlang:map_get(compare, OrdNonEmpty1(DictOrd))
       end
     , 'Eq10' =>
       fun
         (_) ->
           Eq1NonEmpty1
       end
     }
  end.

