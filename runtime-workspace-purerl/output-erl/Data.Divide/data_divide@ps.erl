-module(data_divide@ps).
-export([ identity/0
        , identity/1
        , dividePredicate/0
        , divideOp/0
        , divideOp/1
        , divideEquivalence/0
        , divideComparison/0
        , divide/0
        , divide/1
        , divided/0
        , divided/1
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

dividePredicate() ->
  #{ divide =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (A) ->
                     begin
                       V2 = F(A),
                       (V(erlang:element(2, V2)))
                         andalso (V1(erlang:element(3, V2)))
                     end
                 end
             end
         end
     end
   , 'Contravariant0' =>
     fun
       (_) ->
         data_predicate@ps:contravariantPredicate()
     end
   }.

divideOp() ->
  fun
    (DictSemigroup) ->
      divideOp(DictSemigroup)
  end.

divideOp(#{ append := DictSemigroup }) ->
  #{ divide =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (A) ->
                     begin
                       V2 = F(A),
                       (DictSemigroup(V(erlang:element(2, V2))))
                       (V1(erlang:element(3, V2)))
                     end
                 end
             end
         end
     end
   , 'Contravariant0' =>
     fun
       (_) ->
         data_op@ps:contravariantOp()
     end
   }.

divideEquivalence() ->
  #{ divide =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (A) ->
                     fun
                       (B) ->
                         begin
                           V2 = F(A),
                           V3 = F(B),
                           ((V(erlang:element(2, V2)))(erlang:element(2, V3)))
                             andalso ((V1(erlang:element(3, V2)))
                                      (erlang:element(3, V3)))
                         end
                     end
                 end
             end
         end
     end
   , 'Contravariant0' =>
     fun
       (_) ->
         data_equivalence@ps:contravariantEquivalence()
     end
   }.

divideComparison() ->
  #{ divide =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (A) ->
                     fun
                       (B) ->
                         begin
                           V2 = F(A),
                           V3 = F(B),
                           V@1 =
                             (V(erlang:element(2, V2)))(erlang:element(2, V3)),
                           V@2 =
                             (V1(erlang:element(3, V2)))(erlang:element(3, V3)),
                           case V@1 of
                             {lT} ->
                               {lT};
                             {gT} ->
                               {gT};
                             {eQ} ->
                               V@2;
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                         end
                     end
                 end
             end
         end
     end
   , 'Contravariant0' =>
     fun
       (_) ->
         data_comparison@ps:contravariantComparison()
     end
   }.

divide() ->
  fun
    (Dict) ->
      divide(Dict)
  end.

divide(#{ divide := Dict }) ->
  Dict.

divided() ->
  fun
    (DictDivide) ->
      divided(DictDivide)
  end.

divided(#{ divide := DictDivide }) ->
  DictDivide(identity()).

