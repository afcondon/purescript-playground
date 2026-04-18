-module(data_decidable@ps).
-export([ identity/0
        , identity/1
        , lose/0
        , lose/1
        , lost/0
        , lost/1
        , decidablePredicate/0
        , decidableOp/0
        , decidableOp/1
        , decidableEquivalence/0
        , decidableComparison/0
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

lose() ->
  fun
    (Dict) ->
      lose(Dict)
  end.

lose(#{ lose := Dict }) ->
  Dict.

lost() ->
  fun
    (DictDecidable) ->
      lost(DictDecidable)
  end.

lost(#{ lose := DictDecidable }) ->
  DictDecidable(identity()).

decidablePredicate() ->
  #{ lose =>
     fun
       (F) ->
         fun
           (A) ->
             begin
               Spin =
                 fun
                   Spin (V) ->
                     Spin(V)
                 end,
               Spin(F(A))
             end
         end
     end
   , 'Decide0' =>
     fun
       (_) ->
         data_decide@ps:choosePredicate()
     end
   , 'Divisible1' =>
     fun
       (_) ->
         data_divisible@ps:divisiblePredicate()
     end
   }.

decidableOp() ->
  fun
    (DictMonoid) ->
      decidableOp(DictMonoid)
  end.

decidableOp(DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
  begin
    ChooseOp = data_decide@ps:chooseOp(DictMonoid@1(undefined)),
    DivisibleOp = data_divisible@ps:divisibleOp(DictMonoid),
    #{ lose =>
       fun
         (F) ->
           fun
             (A) ->
               begin
                 Spin =
                   fun
                     Spin (V) ->
                       Spin(V)
                   end,
                 Spin(F(A))
               end
           end
       end
     , 'Decide0' =>
       fun
         (_) ->
           ChooseOp
       end
     , 'Divisible1' =>
       fun
         (_) ->
           DivisibleOp
       end
     }
  end.

decidableEquivalence() ->
  #{ lose =>
     fun
       (F) ->
         fun
           (A) ->
             begin
               Spin =
                 fun
                   Spin (V) ->
                     Spin(V)
                 end,
               Spin(F(A))
             end
         end
     end
   , 'Decide0' =>
     fun
       (_) ->
         data_decide@ps:chooseEquivalence()
     end
   , 'Divisible1' =>
     fun
       (_) ->
         data_divisible@ps:divisibleEquivalence()
     end
   }.

decidableComparison() ->
  #{ lose =>
     fun
       (F) ->
         fun
           (A) ->
             fun
               (_) ->
                 begin
                   Spin =
                     fun
                       Spin (V) ->
                         Spin(V)
                     end,
                   Spin(F(A))
                 end
             end
         end
     end
   , 'Decide0' =>
     fun
       (_) ->
         data_decide@ps:chooseComparison()
     end
   , 'Divisible1' =>
     fun
       (_) ->
         data_divisible@ps:divisibleComparison()
     end
   }.

