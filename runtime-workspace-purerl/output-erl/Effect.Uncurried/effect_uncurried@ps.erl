-module(effect_uncurried@ps).
-export([ semigroupEffectFn9/0
        , semigroupEffectFn9/1
        , semigroupEffectFn8/0
        , semigroupEffectFn8/1
        , semigroupEffectFn7/0
        , semigroupEffectFn7/1
        , semigroupEffectFn6/0
        , semigroupEffectFn6/1
        , semigroupEffectFn5/0
        , semigroupEffectFn5/1
        , semigroupEffectFn4/0
        , semigroupEffectFn4/1
        , semigroupEffectFn3/0
        , semigroupEffectFn3/1
        , semigroupEffectFn2/0
        , semigroupEffectFn2/1
        , semigroupEffectFn10/0
        , semigroupEffectFn10/1
        , semigroupEffectFn1/0
        , semigroupEffectFn1/1
        , monoidEffectFn9/0
        , monoidEffectFn9/1
        , monoidEffectFn8/0
        , monoidEffectFn8/1
        , monoidEffectFn7/0
        , monoidEffectFn7/1
        , monoidEffectFn6/0
        , monoidEffectFn6/1
        , monoidEffectFn5/0
        , monoidEffectFn5/1
        , monoidEffectFn4/0
        , monoidEffectFn4/1
        , monoidEffectFn3/0
        , monoidEffectFn3/1
        , monoidEffectFn2/0
        , monoidEffectFn2/1
        , monoidEffectFn10/0
        , monoidEffectFn10/1
        , monoidEffectFn1/0
        , monoidEffectFn1/1
        , mkEffectFn1/0
        , mkEffectFn2/0
        , mkEffectFn3/0
        , mkEffectFn4/0
        , mkEffectFn5/0
        , mkEffectFn6/0
        , mkEffectFn7/0
        , mkEffectFn8/0
        , mkEffectFn9/0
        , mkEffectFn10/0
        , runEffectFn1/0
        , runEffectFn2/0
        , runEffectFn3/0
        , runEffectFn4/0
        , runEffectFn5/0
        , runEffectFn6/0
        , runEffectFn7/0
        , runEffectFn8/0
        , runEffectFn9/0
        , runEffectFn10/0
        ]).
-compile(no_auto_import).
semigroupEffectFn9() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn9(DictSemigroup)
  end.

semigroupEffectFn9(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A, B, C, D, E, F, G, H, I) ->
                 begin
                   A_ = F1(A, B, C, D, E, F, G, H, I),
                   A_@1 = F2(A, B, C, D, E, F, G, H, I),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

semigroupEffectFn8() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn8(DictSemigroup)
  end.

semigroupEffectFn8(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A, B, C, D, E, F, G, H) ->
                 begin
                   A_ = F1(A, B, C, D, E, F, G, H),
                   A_@1 = F2(A, B, C, D, E, F, G, H),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

semigroupEffectFn7() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn7(DictSemigroup)
  end.

semigroupEffectFn7(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A, B, C, D, E, F, G) ->
                 begin
                   A_ = F1(A, B, C, D, E, F, G),
                   A_@1 = F2(A, B, C, D, E, F, G),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

semigroupEffectFn6() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn6(DictSemigroup)
  end.

semigroupEffectFn6(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A, B, C, D, E, F) ->
                 begin
                   A_ = F1(A, B, C, D, E, F),
                   A_@1 = F2(A, B, C, D, E, F),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

semigroupEffectFn5() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn5(DictSemigroup)
  end.

semigroupEffectFn5(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A, B, C, D, E) ->
                 begin
                   A_ = F1(A, B, C, D, E),
                   A_@1 = F2(A, B, C, D, E),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

semigroupEffectFn4() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn4(DictSemigroup)
  end.

semigroupEffectFn4(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A, B, C, D) ->
                 begin
                   A_ = F1(A, B, C, D),
                   A_@1 = F2(A, B, C, D),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

semigroupEffectFn3() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn3(DictSemigroup)
  end.

semigroupEffectFn3(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A, B, C) ->
                 begin
                   A_ = F1(A, B, C),
                   A_@1 = F2(A, B, C),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

semigroupEffectFn2() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn2(DictSemigroup)
  end.

semigroupEffectFn2(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A, B) ->
                 begin
                   A_ = F1(A, B),
                   A_@1 = F2(A, B),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

semigroupEffectFn10() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn10(DictSemigroup)
  end.

semigroupEffectFn10(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A, B, C, D, E, F, G, H, I, J) ->
                 begin
                   A_ = F1(A, B, C, D, E, F, G, H, I, J),
                   A_@1 = F2(A, B, C, D, E, F, G, H, I, J),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

semigroupEffectFn1() ->
  fun
    (DictSemigroup) ->
      semigroupEffectFn1(DictSemigroup)
  end.

semigroupEffectFn1(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F1) ->
         fun
           (F2) ->
             fun
               (A) ->
                 begin
                   A_ = F1(A),
                   A_@1 = F2(A),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

monoidEffectFn9() ->
  fun
    (DictMonoid) ->
      monoidEffectFn9(DictMonoid)
  end.

monoidEffectFn9(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn91 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A, B, C, D, E, F, G, H, I) ->
                     begin
                       A_ = F1(A, B, C, D, E, F, G, H, I),
                       A_@1 = F2(A, B, C, D, E, F, G, H, I),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_, _, _, _, _, _, _, _, _) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn91
       end
     }
  end.

monoidEffectFn8() ->
  fun
    (DictMonoid) ->
      monoidEffectFn8(DictMonoid)
  end.

monoidEffectFn8(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn81 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A, B, C, D, E, F, G, H) ->
                     begin
                       A_ = F1(A, B, C, D, E, F, G, H),
                       A_@1 = F2(A, B, C, D, E, F, G, H),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_, _, _, _, _, _, _, _) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn81
       end
     }
  end.

monoidEffectFn7() ->
  fun
    (DictMonoid) ->
      monoidEffectFn7(DictMonoid)
  end.

monoidEffectFn7(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn71 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A, B, C, D, E, F, G) ->
                     begin
                       A_ = F1(A, B, C, D, E, F, G),
                       A_@1 = F2(A, B, C, D, E, F, G),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_, _, _, _, _, _, _) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn71
       end
     }
  end.

monoidEffectFn6() ->
  fun
    (DictMonoid) ->
      monoidEffectFn6(DictMonoid)
  end.

monoidEffectFn6(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn61 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A, B, C, D, E, F) ->
                     begin
                       A_ = F1(A, B, C, D, E, F),
                       A_@1 = F2(A, B, C, D, E, F),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_, _, _, _, _, _) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn61
       end
     }
  end.

monoidEffectFn5() ->
  fun
    (DictMonoid) ->
      monoidEffectFn5(DictMonoid)
  end.

monoidEffectFn5(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn51 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A, B, C, D, E) ->
                     begin
                       A_ = F1(A, B, C, D, E),
                       A_@1 = F2(A, B, C, D, E),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_, _, _, _, _) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn51
       end
     }
  end.

monoidEffectFn4() ->
  fun
    (DictMonoid) ->
      monoidEffectFn4(DictMonoid)
  end.

monoidEffectFn4(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn41 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A, B, C, D) ->
                     begin
                       A_ = F1(A, B, C, D),
                       A_@1 = F2(A, B, C, D),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_, _, _, _) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn41
       end
     }
  end.

monoidEffectFn3() ->
  fun
    (DictMonoid) ->
      monoidEffectFn3(DictMonoid)
  end.

monoidEffectFn3(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn31 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A, B, C) ->
                     begin
                       A_ = F1(A, B, C),
                       A_@1 = F2(A, B, C),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_, _, _) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn31
       end
     }
  end.

monoidEffectFn2() ->
  fun
    (DictMonoid) ->
      monoidEffectFn2(DictMonoid)
  end.

monoidEffectFn2(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn21 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A, B) ->
                     begin
                       A_ = F1(A, B),
                       A_@1 = F2(A, B),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_, _) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn21
       end
     }
  end.

monoidEffectFn10() ->
  fun
    (DictMonoid) ->
      monoidEffectFn10(DictMonoid)
  end.

monoidEffectFn10(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn101 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A, B, C, D, E, F, G, H, I, J) ->
                     begin
                       A_ = F1(A, B, C, D, E, F, G, H, I, J),
                       A_@1 = F2(A, B, C, D, E, F, G, H, I, J),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_, _, _, _, _, _, _, _, _, _) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn101
       end
     }
  end.

monoidEffectFn1() ->
  fun
    (DictMonoid) ->
      monoidEffectFn1(DictMonoid)
  end.

monoidEffectFn1(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffectFn11 =
      #{ append =>
         fun
           (F1) ->
             fun
               (F2) ->
                 fun
                   (A) ->
                     begin
                       A_ = F1(A),
                       A_@1 = F2(A),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         (_) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffectFn11
       end
     }
  end.

mkEffectFn1() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn1(V)
  end.

mkEffectFn2() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn2(V)
  end.

mkEffectFn3() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn3(V)
  end.

mkEffectFn4() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn4(V)
  end.

mkEffectFn5() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn5(V)
  end.

mkEffectFn6() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn6(V)
  end.

mkEffectFn7() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn7(V)
  end.

mkEffectFn8() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn8(V)
  end.

mkEffectFn9() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn9(V)
  end.

mkEffectFn10() ->
  fun
    (V) ->
      effect_uncurried@foreign:mkEffectFn10(V)
  end.

runEffectFn1() ->
  fun
    (V) ->
      fun
        (V@1) ->
          effect_uncurried@foreign:runEffectFn1(V, V@1)
      end
  end.

runEffectFn2() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              effect_uncurried@foreign:runEffectFn2(V, V@1, V@2)
          end
      end
  end.

runEffectFn3() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  effect_uncurried@foreign:runEffectFn3(V, V@1, V@2, V@3)
              end
          end
      end
  end.

runEffectFn4() ->
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
                      effect_uncurried@foreign:runEffectFn4(
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

runEffectFn5() ->
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
                      fun
                        (V@5) ->
                          effect_uncurried@foreign:runEffectFn5(
                            V,
                            V@1,
                            V@2,
                            V@3,
                            V@4,
                            V@5
                          )
                      end
                  end
              end
          end
      end
  end.

runEffectFn6() ->
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
                      fun
                        (V@5) ->
                          fun
                            (V@6) ->
                              effect_uncurried@foreign:runEffectFn6(
                                V,
                                V@1,
                                V@2,
                                V@3,
                                V@4,
                                V@5,
                                V@6
                              )
                          end
                      end
                  end
              end
          end
      end
  end.

runEffectFn7() ->
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
                      fun
                        (V@5) ->
                          fun
                            (V@6) ->
                              fun
                                (V@7) ->
                                  effect_uncurried@foreign:runEffectFn7(
                                    V,
                                    V@1,
                                    V@2,
                                    V@3,
                                    V@4,
                                    V@5,
                                    V@6,
                                    V@7
                                  )
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

runEffectFn8() ->
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
                      fun
                        (V@5) ->
                          fun
                            (V@6) ->
                              fun
                                (V@7) ->
                                  fun
                                    (V@8) ->
                                      effect_uncurried@foreign:runEffectFn8(
                                        V,
                                        V@1,
                                        V@2,
                                        V@3,
                                        V@4,
                                        V@5,
                                        V@6,
                                        V@7,
                                        V@8
                                      )
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

runEffectFn9() ->
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
                      fun
                        (V@5) ->
                          fun
                            (V@6) ->
                              fun
                                (V@7) ->
                                  fun
                                    (V@8) ->
                                      fun
                                        (V@9) ->
                                          effect_uncurried@foreign:runEffectFn9(
                                            V,
                                            V@1,
                                            V@2,
                                            V@3,
                                            V@4,
                                            V@5,
                                            V@6,
                                            V@7,
                                            V@8,
                                            V@9
                                          )
                                      end
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

runEffectFn10() ->
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
                      fun
                        (V@5) ->
                          fun
                            (V@6) ->
                              fun
                                (V@7) ->
                                  fun
                                    (V@8) ->
                                      fun
                                        (V@9) ->
                                          fun
                                            (V@10) ->
                                              effect_uncurried@foreign:runEffectFn10(
                                                V,
                                                V@1,
                                                V@2,
                                                V@3,
                                                V@4,
                                                V@5,
                                                V@6,
                                                V@7,
                                                V@8,
                                                V@9,
                                                V@10
                                              )
                                          end
                                      end
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

