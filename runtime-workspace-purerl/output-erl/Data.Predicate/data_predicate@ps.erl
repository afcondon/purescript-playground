-module(data_predicate@ps).
-export([ 'Predicate'/0
        , 'Predicate'/1
        , newtypePredicate/0
        , heytingAlgebraPredicate/0
        , contravariantPredicate/0
        , booleanAlgebraPredicate/0
        ]).
-compile(no_auto_import).
'Predicate'() ->
  fun
    (X) ->
      'Predicate'(X)
  end.

'Predicate'(X) ->
  X.

newtypePredicate() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

heytingAlgebraPredicate() ->
  #{ ff =>
     fun
       (_) ->
         false
     end
   , tt =>
     fun
       (_) ->
         true
     end
   , implies =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (A) ->
                 (not (F(A))) orelse (G(A))
             end
         end
     end
   , conj =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (A) ->
                 (F(A)) andalso (G(A))
             end
         end
     end
   , disj =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (A) ->
                 (F(A)) orelse (G(A))
             end
         end
     end
   , 'not' =>
     fun
       (F) ->
         fun
           (A) ->
             not (F(A))
         end
     end
   }.

contravariantPredicate() ->
  #{ cmap =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (X) ->
                 V(F(X))
             end
         end
     end
   }.

booleanAlgebraPredicate() ->
  data_booleanAlgebra@ps:booleanAlgebraFn(data_booleanAlgebra@ps:booleanAlgebraBoolean()).

