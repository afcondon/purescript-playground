-module(data_comparison@ps).
-export([ 'Comparison'/0
        , 'Comparison'/1
        , semigroupComparison/0
        , newtypeComparison/0
        , monoidComparison/0
        , defaultComparison/0
        , defaultComparison/1
        , contravariantComparison/0
        ]).
-compile(no_auto_import).
'Comparison'() ->
  fun
    (X) ->
      'Comparison'(X)
  end.

'Comparison'(X) ->
  X.

semigroupComparison() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (X) ->
                 begin
                   V@1 = V(X),
                   V@2 = V1(X),
                   fun
                     (X@1) ->
                       begin
                         V@3 = V@1(X@1),
                         V@4 = V@2(X@1),
                         case V@3 of
                           {lT} ->
                             {lT};
                           {gT} ->
                             {gT};
                           {eQ} ->
                             V@4;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                       end
                   end
                 end
             end
         end
     end
   }.

newtypeComparison() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidComparison() ->
  #{ mempty =>
     fun
       (_) ->
         fun
           (_) ->
             {eQ}
         end
     end
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupComparison()
     end
   }.

defaultComparison() ->
  fun
    (DictOrd) ->
      defaultComparison(DictOrd)
  end.

defaultComparison(#{ compare := DictOrd }) ->
  DictOrd.

contravariantComparison() ->
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

