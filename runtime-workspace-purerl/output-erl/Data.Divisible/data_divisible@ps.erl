-module(data_divisible@ps).
-export([ divisiblePredicate/0
        , divisibleOp/0
        , divisibleOp/1
        , divisibleEquivalence/0
        , divisibleComparison/0
        , conquer/0
        , conquer/1
        ]).
-compile(no_auto_import).
divisiblePredicate() ->
  #{ conquer =>
     fun
       (_) ->
         true
     end
   , 'Divide0' =>
     fun
       (_) ->
         data_divide@ps:dividePredicate()
     end
   }.

divisibleOp() ->
  fun
    (DictMonoid) ->
      divisibleOp(DictMonoid)
  end.

divisibleOp(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    DivideOp = data_divide@ps:divideOp(DictMonoid(undefined)),
    #{ conquer =>
       fun
         (_) ->
           DictMonoid@1
       end
     , 'Divide0' =>
       fun
         (_) ->
           DivideOp
       end
     }
  end.

divisibleEquivalence() ->
  #{ conquer =>
     fun
       (_) ->
         fun
           (_) ->
             true
         end
     end
   , 'Divide0' =>
     fun
       (_) ->
         data_divide@ps:divideEquivalence()
     end
   }.

divisibleComparison() ->
  #{ conquer =>
     fun
       (_) ->
         fun
           (_) ->
             {eQ}
         end
     end
   , 'Divide0' =>
     fun
       (_) ->
         data_divide@ps:divideComparison()
     end
   }.

conquer() ->
  fun
    (Dict) ->
      conquer(Dict)
  end.

conquer(#{ conquer := Dict }) ->
  Dict.

