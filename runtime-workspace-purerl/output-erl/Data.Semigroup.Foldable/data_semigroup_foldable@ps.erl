-module(data_semigroup_foldable@ps).
-export([ identity/0
        , identity/1
        , 'FoldRight1'/0
        , semigroupAct/0
        , semigroupAct/1
        , mkFoldRight1/0
        , foldr1/0
        , foldr1/1
        , foldl1/0
        , foldl1/1
        , maximumBy/0
        , maximumBy/2
        , minimumBy/0
        , minimumBy/2
        , foldableTuple/0
        , foldableMultiplicative/0
        , foldableIdentity/0
        , foldableDual/0
        , foldRight1Semigroup/0
        , semigroupDual/0
        , foldMap1DefaultR/0
        , foldMap1DefaultR/3
        , foldMap1DefaultL/0
        , foldMap1DefaultL/3
        , foldMap1Default/0
        , foldMap1Default/4
        , foldMap1/0
        , foldMap1/1
        , foldl1Default/0
        , foldl1Default/1
        , foldr1Default/0
        , foldr1Default/1
        , intercalateMap/0
        , intercalateMap/2
        , intercalate/0
        , intercalate/2
        , maximum/0
        , maximum/1
        , minimum/0
        , minimum/1
        , traverse1_/0
        , traverse1_/2
        , for1_/0
        , for1_/2
        , sequence1_/0
        , sequence1_/2
        , fold1/0
        , fold1/2
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

'FoldRight1'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {foldRight1, Value0, Value1}
      end
  end.

semigroupAct() ->
  fun
    (DictApply) ->
      semigroupAct(DictApply)
  end.

semigroupAct(#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictApply@1(((erlang:map_get(map, DictApply(undefined)))
                           (fun
                             (_) ->
                               control_apply@ps:identity()
                           end))
                          (V)))
             (V1)
         end
     end
   }.

mkFoldRight1() ->
  ('FoldRight1'())(data_function@ps:const()).

foldr1() ->
  fun
    (Dict) ->
      foldr1(Dict)
  end.

foldr1(#{ foldr1 := Dict }) ->
  Dict.

foldl1() ->
  fun
    (Dict) ->
      foldl1(Dict)
  end.

foldl1(#{ foldl1 := Dict }) ->
  Dict.

maximumBy() ->
  fun
    (DictFoldable1) ->
      fun
        (Cmp) ->
          maximumBy(DictFoldable1, Cmp)
      end
  end.

maximumBy(#{ foldl1 := DictFoldable1 }, Cmp) ->
  DictFoldable1(fun
    (X) ->
      fun
        (Y) ->
          begin
            V = (Cmp(X))(Y),
            case ?IS_KNOWN_TAG(gT, 0, V) of
              true ->
                X;
              _ ->
                Y
            end
          end
      end
  end).

minimumBy() ->
  fun
    (DictFoldable1) ->
      fun
        (Cmp) ->
          minimumBy(DictFoldable1, Cmp)
      end
  end.

minimumBy(#{ foldl1 := DictFoldable1 }, Cmp) ->
  DictFoldable1(fun
    (X) ->
      fun
        (Y) ->
          begin
            V = (Cmp(X))(Y),
            case ?IS_KNOWN_TAG(lT, 0, V) of
              true ->
                X;
              _ ->
                Y
            end
          end
      end
  end).

foldableTuple() ->
  #{ foldMap1 =>
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
   , foldr1 =>
     fun
       (_) ->
         fun
           (V1) ->
             erlang:element(3, V1)
         end
     end
   , foldl1 =>
     fun
       (_) ->
         fun
           (V1) ->
             erlang:element(3, V1)
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableTuple()
     end
   }.

foldableMultiplicative() ->
  #{ foldr1 =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   , foldl1 =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   , foldMap1 =>
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
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableMultiplicative()
     end
   }.

foldableIdentity() ->
  #{ foldMap1 =>
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
   , foldl1 =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   , foldr1 =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableIdentity()
     end
   }.

foldableDual() ->
  #{ foldr1 =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   , foldl1 =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   , foldMap1 =>
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
   , 'Foldable0' =>
     fun
       (_) ->
         data_foldable@ps:foldableDual()
     end
   }.

foldRight1Semigroup() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             begin
               V@1 = erlang:element(3, V),
               { foldRight1
               , fun
                   (A) ->
                     fun
                       (F) ->
                         ((erlang:element(2, V))
                          ((F(V@1))(((erlang:element(2, V1))(A))(F))))
                         (F)
                     end
                 end
               , erlang:element(3, V1)
               }
             end
         end
     end
   }.

semigroupDual() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             begin
               V@1 = erlang:element(3, V1),
               { foldRight1
               , fun
                   (A) ->
                     fun
                       (F) ->
                         ((erlang:element(2, V1))
                          ((F(V@1))(((erlang:element(2, V))(A))(F))))
                         (F)
                     end
                 end
               , erlang:element(3, V)
               }
             end
         end
     end
   }.

foldMap1DefaultR() ->
  fun
    (DictFoldable1) ->
      fun
        (DictFunctor) ->
          fun
            (DictSemigroup) ->
              foldMap1DefaultR(DictFoldable1, DictFunctor, DictSemigroup)
          end
      end
  end.

foldMap1DefaultR( #{ foldr1 := DictFoldable1 }
                , #{ map := DictFunctor }
                , #{ append := DictSemigroup }
                ) ->
  fun
    (F) ->
      begin
        V = DictFunctor(F),
        V@1 = DictFoldable1(DictSemigroup),
        fun
          (X) ->
            V@1(V(X))
        end
      end
  end.

foldMap1DefaultL() ->
  fun
    (DictFoldable1) ->
      fun
        (DictFunctor) ->
          fun
            (DictSemigroup) ->
              foldMap1DefaultL(DictFoldable1, DictFunctor, DictSemigroup)
          end
      end
  end.

foldMap1DefaultL( #{ foldl1 := DictFoldable1 }
                , #{ map := DictFunctor }
                , #{ append := DictSemigroup }
                ) ->
  fun
    (F) ->
      begin
        V = DictFunctor(F),
        V@1 = DictFoldable1(DictSemigroup),
        fun
          (X) ->
            V@1(V(X))
        end
      end
  end.

foldMap1Default() ->
  fun
    (V) ->
      fun
        (DictFoldable1) ->
          fun
            (DictFunctor) ->
              fun
                (DictSemigroup) ->
                  foldMap1Default(V, DictFoldable1, DictFunctor, DictSemigroup)
              end
          end
      end
  end.

foldMap1Default( _
               , #{ foldl1 := DictFoldable1 }
               , #{ map := DictFunctor }
               , #{ append := DictSemigroup }
               ) ->
  fun
    (F) ->
      begin
        V = DictFunctor(F),
        V@1 = DictFoldable1(DictSemigroup),
        fun
          (X) ->
            V@1(V(X))
        end
      end
  end.

foldMap1() ->
  fun
    (Dict) ->
      foldMap1(Dict)
  end.

foldMap1(#{ foldMap1 := Dict }) ->
  Dict.

foldl1Default() ->
  fun
    (DictFoldable1) ->
      foldl1Default(DictFoldable1)
  end.

foldl1Default(#{ foldMap1 := DictFoldable1 }) ->
  begin
    V = (DictFoldable1(semigroupDual()))(mkFoldRight1()),
    fun
      (X) ->
        fun
          (A) ->
            begin
              V@1 = V(A),
              ((erlang:element(2, V@1))(erlang:element(3, V@1)))
              (fun
                (B) ->
                  fun
                    (A@1) ->
                      (X(A@1))(B)
                  end
              end)
            end
        end
    end
  end.

foldr1Default() ->
  fun
    (DictFoldable1) ->
      foldr1Default(DictFoldable1)
  end.

foldr1Default(#{ foldMap1 := DictFoldable1 }) ->
  begin
    V = (DictFoldable1(foldRight1Semigroup()))(mkFoldRight1()),
    fun
      (B) ->
        fun
          (A) ->
            begin
              V@1 = V(A),
              ((erlang:element(2, V@1))(erlang:element(3, V@1)))(B)
            end
        end
    end
  end.

intercalateMap() ->
  fun
    (DictFoldable1) ->
      fun
        (DictSemigroup) ->
          intercalateMap(DictFoldable1, DictSemigroup)
      end
  end.

intercalateMap(#{ foldMap1 := DictFoldable1 }, #{ append := DictSemigroup }) ->
  begin
    FoldMap12 =
      DictFoldable1(#{ append =>
                       fun
                         (V) ->
                           fun
                             (V1) ->
                               fun
                                 (J) ->
                                   (DictSemigroup(V(J)))
                                   ((DictSemigroup(J))(V1(J)))
                               end
                           end
                       end
                     }),
    fun
      (J) ->
        fun
          (F) ->
            fun
              (Foldable) ->
                ((FoldMap12(fun
                    (X) ->
                      begin
                        V = F(X),
                        fun
                          (_) ->
                            V
                        end
                      end
                  end))
                 (Foldable))
                (J)
            end
        end
    end
  end.

intercalate() ->
  fun
    (DictFoldable1) ->
      fun
        (DictSemigroup) ->
          intercalate(DictFoldable1, DictSemigroup)
      end
  end.

intercalate(#{ foldMap1 := DictFoldable1 }, #{ append := DictSemigroup }) ->
  begin
    FoldMap12 =
      DictFoldable1(#{ append =>
                       fun
                         (V) ->
                           fun
                             (V1) ->
                               fun
                                 (J) ->
                                   (DictSemigroup(V(J)))
                                   ((DictSemigroup(J))(V1(J)))
                               end
                           end
                       end
                     }),
    fun
      (A) ->
        fun
          (Foldable) ->
            ((FoldMap12(fun
                (X) ->
                  fun
                    (_) ->
                      X
                  end
              end))
             (Foldable))
            (A)
        end
    end
  end.

maximum() ->
  fun
    (DictOrd) ->
      maximum(DictOrd)
  end.

maximum(#{ compare := DictOrd }) ->
  begin
    SemigroupMax =
      #{ append =>
         fun
           (V) ->
             fun
               (V1) ->
                 begin
                   V@1 = (DictOrd(V))(V1),
                   case V@1 of
                     {lT} ->
                       V1;
                     {eQ} ->
                       V;
                     {gT} ->
                       V;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end
         end
       },
    fun
      (#{ foldMap1 := DictFoldable1 }) ->
        (DictFoldable1(SemigroupMax))(unsafe_coerce@ps:unsafeCoerce())
    end
  end.

minimum() ->
  fun
    (DictOrd) ->
      minimum(DictOrd)
  end.

minimum(#{ compare := DictOrd }) ->
  begin
    SemigroupMin =
      #{ append =>
         fun
           (V) ->
             fun
               (V1) ->
                 begin
                   V@1 = (DictOrd(V))(V1),
                   case V@1 of
                     {lT} ->
                       V;
                     {eQ} ->
                       V;
                     {gT} ->
                       V1;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end
         end
       },
    fun
      (#{ foldMap1 := DictFoldable1 }) ->
        (DictFoldable1(SemigroupMin))(unsafe_coerce@ps:unsafeCoerce())
    end
  end.

traverse1_() ->
  fun
    (DictFoldable1) ->
      fun
        (DictApply) ->
          traverse1_(DictFoldable1, DictApply)
      end
  end.

traverse1_( #{ foldMap1 := DictFoldable1 }
          , DictApply = #{ 'Functor0' := DictApply@1 }
          ) ->
  begin
    #{ map := V } = DictApply@1(undefined),
    FoldMap12 = DictFoldable1(semigroupAct(DictApply)),
    fun
      (F) ->
        fun
          (T) ->
            (V(fun
               (_) ->
                 unit
             end))
            ((FoldMap12(fun
                (X) ->
                  F(X)
              end))
             (T))
        end
    end
  end.

for1_() ->
  fun
    (DictFoldable1) ->
      fun
        (DictApply) ->
          for1_(DictFoldable1, DictApply)
      end
  end.

for1_(DictFoldable1, DictApply) ->
  begin
    V = traverse1_(DictFoldable1, DictApply),
    fun
      (B) ->
        fun
          (A) ->
            (V(A))(B)
        end
    end
  end.

sequence1_() ->
  fun
    (DictFoldable1) ->
      fun
        (DictApply) ->
          sequence1_(DictFoldable1, DictApply)
      end
  end.

sequence1_(DictFoldable1, DictApply) ->
  (traverse1_(DictFoldable1, DictApply))(identity()).

fold1() ->
  fun
    (DictFoldable1) ->
      fun
        (DictSemigroup) ->
          fold1(DictFoldable1, DictSemigroup)
      end
  end.

fold1(#{ foldMap1 := DictFoldable1 }, DictSemigroup) ->
  (DictFoldable1(DictSemigroup))(identity()).

