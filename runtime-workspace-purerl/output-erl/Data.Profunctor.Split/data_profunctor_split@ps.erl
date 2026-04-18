-module(data_profunctor_split@ps).
-export([ identity/0
        , identity/1
        , 'SplitF'/0
        , unSplit/0
        , unSplit/2
        , split/0
        , split/3
        , profunctorSplit/0
        , lowerSplit/0
        , lowerSplit/2
        , liftSplit/0
        , liftSplit/1
        , hoistSplit/0
        , hoistSplit/2
        , functorSplit/0
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

'SplitF'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              {splitF, Value0, Value1, Value2}
          end
      end
  end.

unSplit() ->
  fun
    (F) ->
      fun
        (V) ->
          unSplit(F, V)
      end
  end.

unSplit(F, V) ->
  ((F(erlang:element(2, V)))(erlang:element(3, V)))(erlang:element(4, V)).

split() ->
  fun
    (F) ->
      fun
        (G) ->
          fun
            (Fx) ->
              split(F, G, Fx)
          end
      end
  end.

split(F, G, Fx) ->
  {splitF, F, G, Fx}.

profunctorSplit() ->
  #{ dimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 { splitF
                 , fun
                     (X) ->
                       (erlang:element(2, V))(F(X))
                   end
                 , fun
                     (X) ->
                       G((erlang:element(3, V))(X))
                   end
                 , erlang:element(4, V)
                 }
             end
         end
     end
   }.

lowerSplit() ->
  fun
    (DictInvariant) ->
      fun
        (V) ->
          lowerSplit(DictInvariant, V)
      end
  end.

lowerSplit(#{ imap := DictInvariant }, V) ->
  ((DictInvariant(erlang:element(3, V)))(erlang:element(2, V)))
  (erlang:element(4, V)).

liftSplit() ->
  fun
    (Fx) ->
      liftSplit(Fx)
  end.

liftSplit(Fx) ->
  begin
    V = identity(),
    {splitF, V, V, Fx}
  end.

hoistSplit() ->
  fun
    (Nat) ->
      fun
        (V) ->
          hoistSplit(Nat, V)
      end
  end.

hoistSplit(Nat, V) ->
  { splitF
  , erlang:element(2, V)
  , erlang:element(3, V)
  , Nat(erlang:element(4, V))
  }.

functorSplit() ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             { splitF
             , erlang:element(2, V)
             , fun
                 (X) ->
                   F((erlang:element(3, V))(X))
               end
             , erlang:element(4, V)
             }
         end
     end
   }.

