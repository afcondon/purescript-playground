-module(data_ring_generic@ps).
-export([ 'genericSub\''/0
        , 'genericSub\''/1
        , genericSub/0
        , genericSub/4
        , genericRingProduct/0
        , genericRingProduct/2
        , genericRingNoArguments/0
        , genericRingConstructor/0
        , genericRingConstructor/1
        , genericRingArgument/0
        , genericRingArgument/1
        ]).
-compile(no_auto_import).
'genericSub\''() ->
  fun
    (Dict) ->
      'genericSub\''(Dict)
  end.

'genericSub\''(#{ 'genericSub\'' := Dict }) ->
  Dict.

genericSub() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericRing) ->
          fun
            (X) ->
              fun
                (Y) ->
                  genericSub(DictGeneric, DictGenericRing, X, Y)
              end
          end
      end
  end.

genericSub( #{ from := DictGeneric, to := DictGeneric@1 }
          , #{ 'genericSub\'' := DictGenericRing }
          , X
          , Y
          ) ->
  DictGeneric@1((DictGenericRing(DictGeneric(X)))(DictGeneric(Y))).

genericRingProduct() ->
  fun
    (DictGenericRing) ->
      fun
        (DictGenericRing1) ->
          genericRingProduct(DictGenericRing, DictGenericRing1)
      end
  end.

genericRingProduct( #{ 'genericSub\'' := DictGenericRing }
                  , #{ 'genericSub\'' := DictGenericRing1 }
                  ) ->
  #{ 'genericSub\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             { product
             , (DictGenericRing(erlang:element(2, V)))(erlang:element(2, V1))
             , (DictGenericRing1(erlang:element(3, V)))(erlang:element(3, V1))
             }
         end
     end
   }.

genericRingNoArguments() ->
  #{ 'genericSub\'' =>
     fun
       (_) ->
         fun
           (_) ->
             {noArguments}
         end
     end
   }.

genericRingConstructor() ->
  fun
    (DictGenericRing) ->
      genericRingConstructor(DictGenericRing)
  end.

genericRingConstructor(#{ 'genericSub\'' := DictGenericRing }) ->
  #{ 'genericSub\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictGenericRing(V))(V1)
         end
     end
   }.

genericRingArgument() ->
  fun
    (DictRing) ->
      genericRingArgument(DictRing)
  end.

genericRingArgument(#{ sub := DictRing }) ->
  #{ 'genericSub\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictRing(V))(V1)
         end
     end
   }.

