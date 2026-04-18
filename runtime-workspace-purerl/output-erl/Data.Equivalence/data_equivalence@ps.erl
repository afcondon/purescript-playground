-module(data_equivalence@ps).
-export([ 'Equivalence'/0
        , 'Equivalence'/1
        , semigroupEquivalence/0
        , newtypeEquivalence/0
        , monoidEquivalence/0
        , defaultEquivalence/0
        , defaultEquivalence/1
        , contravariantEquivalence/0
        , comparisonEquivalence/0
        , comparisonEquivalence/3
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'Equivalence'() ->
  fun
    (X) ->
      'Equivalence'(X)
  end.

'Equivalence'(X) ->
  X.

semigroupEquivalence() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (A) ->
                 fun
                   (B) ->
                     ((V(A))(B)) andalso ((V1(A))(B))
                 end
             end
         end
     end
   }.

newtypeEquivalence() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidEquivalence() ->
  #{ mempty =>
     fun
       (_) ->
         fun
           (_) ->
             true
         end
     end
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupEquivalence()
     end
   }.

defaultEquivalence() ->
  fun
    (DictEq) ->
      defaultEquivalence(DictEq)
  end.

defaultEquivalence(#{ eq := DictEq }) ->
  DictEq.

contravariantEquivalence() ->
  #{ cmap =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (X) ->
                 fun
                   (Y) ->
                     (V(F(X)))(F(Y))
                 end
             end
         end
     end
   }.

comparisonEquivalence() ->
  fun
    (V) ->
      fun
        (A) ->
          fun
            (B) ->
              comparisonEquivalence(V, A, B)
          end
      end
  end.

comparisonEquivalence(V, A, B) ->
  begin
    V@1 = (V(A))(B),
    ?IS_KNOWN_TAG(eQ, 0, V@1)
  end.

