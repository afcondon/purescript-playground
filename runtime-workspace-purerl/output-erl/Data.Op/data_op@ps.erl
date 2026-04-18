-module(data_op@ps).
-export([ 'Op'/0
        , 'Op'/1
        , semigroupoidOp/0
        , semigroupOp/0
        , semigroupOp/1
        , newtypeOp/0
        , monoidOp/0
        , monoidOp/1
        , contravariantOp/0
        , categoryOp/0
        ]).
-compile(no_auto_import).
'Op'() ->
  fun
    (X) ->
      'Op'(X)
  end.

'Op'(X) ->
  X.

semigroupoidOp() ->
  #{ compose =>
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

semigroupOp() ->
  fun
    (DictSemigroup) ->
      semigroupOp(DictSemigroup)
  end.

semigroupOp(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (X) ->
                 (DictSemigroup(F(X)))(G(X))
             end
         end
     end
   }.

newtypeOp() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidOp() ->
  fun
    (DictMonoid) ->
      monoidOp(DictMonoid)
  end.

monoidOp(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupFn =
      #{ append =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (X) ->
                     (V(F(X)))(G(X))
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
           SemigroupFn
       end
     }
  end.

contravariantOp() ->
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

categoryOp() ->
  #{ identity =>
     fun
       (X) ->
         X
     end
   , 'Semigroupoid0' =>
     fun
       (_) ->
         semigroupoidOp()
     end
   }.

