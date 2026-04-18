-module(data_semiring_generic@ps).
-export([ 'genericZero\''/0
        , 'genericZero\''/1
        , genericZero/0
        , genericZero/2
        , genericSemiringNoArguments/0
        , genericSemiringArgument/0
        , genericSemiringArgument/1
        , 'genericOne\''/0
        , 'genericOne\''/1
        , genericOne/0
        , genericOne/2
        , 'genericMul\''/0
        , 'genericMul\''/1
        , genericMul/0
        , genericMul/4
        , 'genericAdd\''/0
        , 'genericAdd\''/1
        , genericSemiringConstructor/0
        , genericSemiringConstructor/1
        , genericSemiringProduct/0
        , genericSemiringProduct/1
        , genericAdd/0
        , genericAdd/4
        ]).
-compile(no_auto_import).
'genericZero\''() ->
  fun
    (Dict) ->
      'genericZero\''(Dict)
  end.

'genericZero\''(#{ 'genericZero\'' := Dict }) ->
  Dict.

genericZero() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericSemiring) ->
          genericZero(DictGeneric, DictGenericSemiring)
      end
  end.

genericZero(#{ to := DictGeneric }, #{ 'genericZero\'' := DictGenericSemiring }) ->
  DictGeneric(DictGenericSemiring).

genericSemiringNoArguments() ->
  #{ 'genericAdd\'' =>
     fun
       (_) ->
         fun
           (_) ->
             {noArguments}
         end
     end
   , 'genericZero\'' => {noArguments}
   , 'genericMul\'' =>
     fun
       (_) ->
         fun
           (_) ->
             {noArguments}
         end
     end
   , 'genericOne\'' => {noArguments}
   }.

genericSemiringArgument() ->
  fun
    (DictSemiring) ->
      genericSemiringArgument(DictSemiring)
  end.

genericSemiringArgument(#{ add := DictSemiring
                         , mul := DictSemiring@1
                         , one := DictSemiring@2
                         , zero := DictSemiring@3
                         }) ->
  #{ 'genericAdd\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemiring(V))(V1)
         end
     end
   , 'genericZero\'' => DictSemiring@3
   , 'genericMul\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemiring@1(V))(V1)
         end
     end
   , 'genericOne\'' => DictSemiring@2
   }.

'genericOne\''() ->
  fun
    (Dict) ->
      'genericOne\''(Dict)
  end.

'genericOne\''(#{ 'genericOne\'' := Dict }) ->
  Dict.

genericOne() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericSemiring) ->
          genericOne(DictGeneric, DictGenericSemiring)
      end
  end.

genericOne(#{ to := DictGeneric }, #{ 'genericOne\'' := DictGenericSemiring }) ->
  DictGeneric(DictGenericSemiring).

'genericMul\''() ->
  fun
    (Dict) ->
      'genericMul\''(Dict)
  end.

'genericMul\''(#{ 'genericMul\'' := Dict }) ->
  Dict.

genericMul() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericSemiring) ->
          fun
            (X) ->
              fun
                (Y) ->
                  genericMul(DictGeneric, DictGenericSemiring, X, Y)
              end
          end
      end
  end.

genericMul( #{ from := DictGeneric, to := DictGeneric@1 }
          , #{ 'genericMul\'' := DictGenericSemiring }
          , X
          , Y
          ) ->
  DictGeneric@1((DictGenericSemiring(DictGeneric(X)))(DictGeneric(Y))).

'genericAdd\''() ->
  fun
    (Dict) ->
      'genericAdd\''(Dict)
  end.

'genericAdd\''(#{ 'genericAdd\'' := Dict }) ->
  Dict.

genericSemiringConstructor() ->
  fun
    (DictGenericSemiring) ->
      genericSemiringConstructor(DictGenericSemiring)
  end.

genericSemiringConstructor(#{ 'genericAdd\'' := DictGenericSemiring
                            , 'genericMul\'' := DictGenericSemiring@1
                            , 'genericOne\'' := DictGenericSemiring@2
                            , 'genericZero\'' := DictGenericSemiring@3
                            }) ->
  #{ 'genericAdd\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictGenericSemiring(V))(V1)
         end
     end
   , 'genericZero\'' => DictGenericSemiring@3
   , 'genericMul\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictGenericSemiring@1(V))(V1)
         end
     end
   , 'genericOne\'' => DictGenericSemiring@2
   }.

genericSemiringProduct() ->
  fun
    (DictGenericSemiring) ->
      genericSemiringProduct(DictGenericSemiring)
  end.

genericSemiringProduct(#{ 'genericAdd\'' := DictGenericSemiring
                        , 'genericMul\'' := DictGenericSemiring@1
                        , 'genericOne\'' := DictGenericSemiring@2
                        , 'genericZero\'' := DictGenericSemiring@3
                        }) ->
  fun
    (#{ 'genericAdd\'' := DictGenericSemiring1
      , 'genericMul\'' := DictGenericSemiring1@1
      , 'genericOne\'' := DictGenericSemiring1@2
      , 'genericZero\'' := DictGenericSemiring1@3
      }) ->
      #{ 'genericAdd\'' =>
         fun
           (V) ->
             fun
               (V1) ->
                 { product
                 , (DictGenericSemiring(erlang:element(2, V)))
                   (erlang:element(2, V1))
                 , (DictGenericSemiring1(erlang:element(3, V)))
                   (erlang:element(3, V1))
                 }
             end
         end
       , 'genericZero\'' =>
         {product, DictGenericSemiring@3, DictGenericSemiring1@3}
       , 'genericMul\'' =>
         fun
           (V) ->
             fun
               (V1) ->
                 { product
                 , (DictGenericSemiring@1(erlang:element(2, V)))
                   (erlang:element(2, V1))
                 , (DictGenericSemiring1@1(erlang:element(3, V)))
                   (erlang:element(3, V1))
                 }
             end
         end
       , 'genericOne\'' =>
         {product, DictGenericSemiring@2, DictGenericSemiring1@2}
       }
  end.

genericAdd() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericSemiring) ->
          fun
            (X) ->
              fun
                (Y) ->
                  genericAdd(DictGeneric, DictGenericSemiring, X, Y)
              end
          end
      end
  end.

genericAdd( #{ from := DictGeneric, to := DictGeneric@1 }
          , #{ 'genericAdd\'' := DictGenericSemiring }
          , X
          , Y
          ) ->
  DictGeneric@1((DictGenericSemiring(DictGeneric(X)))(DictGeneric(Y))).

