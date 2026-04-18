-module(data_heytingAlgebra_generic@ps).
-export([ 'genericTT\''/0
        , 'genericTT\''/1
        , genericTT/0
        , genericTT/2
        , 'genericNot\''/0
        , 'genericNot\''/1
        , genericNot/0
        , genericNot/3
        , 'genericImplies\''/0
        , 'genericImplies\''/1
        , genericImplies/0
        , genericImplies/4
        , genericHeytingAlgebraNoArguments/0
        , genericHeytingAlgebraArgument/0
        , genericHeytingAlgebraArgument/1
        , 'genericFF\''/0
        , 'genericFF\''/1
        , genericFF/0
        , genericFF/2
        , 'genericDisj\''/0
        , 'genericDisj\''/1
        , genericDisj/0
        , genericDisj/4
        , 'genericConj\''/0
        , 'genericConj\''/1
        , genericHeytingAlgebraConstructor/0
        , genericHeytingAlgebraConstructor/1
        , genericHeytingAlgebraProduct/0
        , genericHeytingAlgebraProduct/1
        , genericConj/0
        , genericConj/4
        ]).
-compile(no_auto_import).
'genericTT\''() ->
  fun
    (Dict) ->
      'genericTT\''(Dict)
  end.

'genericTT\''(#{ 'genericTT\'' := Dict }) ->
  Dict.

genericTT() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericHeytingAlgebra) ->
          genericTT(DictGeneric, DictGenericHeytingAlgebra)
      end
  end.

genericTT( #{ to := DictGeneric }
         , #{ 'genericTT\'' := DictGenericHeytingAlgebra }
         ) ->
  DictGeneric(DictGenericHeytingAlgebra).

'genericNot\''() ->
  fun
    (Dict) ->
      'genericNot\''(Dict)
  end.

'genericNot\''(#{ 'genericNot\'' := Dict }) ->
  Dict.

genericNot() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericHeytingAlgebra) ->
          fun
            (X) ->
              genericNot(DictGeneric, DictGenericHeytingAlgebra, X)
          end
      end
  end.

genericNot( #{ from := DictGeneric, to := DictGeneric@1 }
          , #{ 'genericNot\'' := DictGenericHeytingAlgebra }
          , X
          ) ->
  DictGeneric@1(DictGenericHeytingAlgebra(DictGeneric(X))).

'genericImplies\''() ->
  fun
    (Dict) ->
      'genericImplies\''(Dict)
  end.

'genericImplies\''(#{ 'genericImplies\'' := Dict }) ->
  Dict.

genericImplies() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericHeytingAlgebra) ->
          fun
            (X) ->
              fun
                (Y) ->
                  genericImplies(DictGeneric, DictGenericHeytingAlgebra, X, Y)
              end
          end
      end
  end.

genericImplies( #{ from := DictGeneric, to := DictGeneric@1 }
              , #{ 'genericImplies\'' := DictGenericHeytingAlgebra }
              , X
              , Y
              ) ->
  DictGeneric@1((DictGenericHeytingAlgebra(DictGeneric(X)))(DictGeneric(Y))).

genericHeytingAlgebraNoArguments() ->
  #{ 'genericFF\'' => {noArguments}
   , 'genericTT\'' => {noArguments}
   , 'genericImplies\'' =>
     fun
       (_) ->
         fun
           (_) ->
             {noArguments}
         end
     end
   , 'genericConj\'' =>
     fun
       (_) ->
         fun
           (_) ->
             {noArguments}
         end
     end
   , 'genericDisj\'' =>
     fun
       (_) ->
         fun
           (_) ->
             {noArguments}
         end
     end
   , 'genericNot\'' =>
     fun
       (_) ->
         {noArguments}
     end
   }.

genericHeytingAlgebraArgument() ->
  fun
    (DictHeytingAlgebra) ->
      genericHeytingAlgebraArgument(DictHeytingAlgebra)
  end.

genericHeytingAlgebraArgument(#{ conj := DictHeytingAlgebra
                               , disj := DictHeytingAlgebra@1
                               , ff := DictHeytingAlgebra@2
                               , implies := DictHeytingAlgebra@3
                               , 'not' := DictHeytingAlgebra@4
                               , tt := DictHeytingAlgebra@5
                               }) ->
  #{ 'genericFF\'' => DictHeytingAlgebra@2
   , 'genericTT\'' => DictHeytingAlgebra@5
   , 'genericImplies\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictHeytingAlgebra@3(V))(V1)
         end
     end
   , 'genericConj\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictHeytingAlgebra(V))(V1)
         end
     end
   , 'genericDisj\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictHeytingAlgebra@1(V))(V1)
         end
     end
   , 'genericNot\'' =>
     fun
       (V) ->
         DictHeytingAlgebra@4(V)
     end
   }.

'genericFF\''() ->
  fun
    (Dict) ->
      'genericFF\''(Dict)
  end.

'genericFF\''(#{ 'genericFF\'' := Dict }) ->
  Dict.

genericFF() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericHeytingAlgebra) ->
          genericFF(DictGeneric, DictGenericHeytingAlgebra)
      end
  end.

genericFF( #{ to := DictGeneric }
         , #{ 'genericFF\'' := DictGenericHeytingAlgebra }
         ) ->
  DictGeneric(DictGenericHeytingAlgebra).

'genericDisj\''() ->
  fun
    (Dict) ->
      'genericDisj\''(Dict)
  end.

'genericDisj\''(#{ 'genericDisj\'' := Dict }) ->
  Dict.

genericDisj() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericHeytingAlgebra) ->
          fun
            (X) ->
              fun
                (Y) ->
                  genericDisj(DictGeneric, DictGenericHeytingAlgebra, X, Y)
              end
          end
      end
  end.

genericDisj( #{ from := DictGeneric, to := DictGeneric@1 }
           , #{ 'genericDisj\'' := DictGenericHeytingAlgebra }
           , X
           , Y
           ) ->
  DictGeneric@1((DictGenericHeytingAlgebra(DictGeneric(X)))(DictGeneric(Y))).

'genericConj\''() ->
  fun
    (Dict) ->
      'genericConj\''(Dict)
  end.

'genericConj\''(#{ 'genericConj\'' := Dict }) ->
  Dict.

genericHeytingAlgebraConstructor() ->
  fun
    (DictGenericHeytingAlgebra) ->
      genericHeytingAlgebraConstructor(DictGenericHeytingAlgebra)
  end.

genericHeytingAlgebraConstructor(#{ 'genericConj\'' := DictGenericHeytingAlgebra
                                  , 'genericDisj\'' :=
                                    DictGenericHeytingAlgebra@1
                                  , 'genericFF\'' := DictGenericHeytingAlgebra@2
                                  , 'genericImplies\'' :=
                                    DictGenericHeytingAlgebra@3
                                  , 'genericNot\'' :=
                                    DictGenericHeytingAlgebra@4
                                  , 'genericTT\'' := DictGenericHeytingAlgebra@5
                                  }) ->
  #{ 'genericFF\'' => DictGenericHeytingAlgebra@2
   , 'genericTT\'' => DictGenericHeytingAlgebra@5
   , 'genericImplies\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictGenericHeytingAlgebra@3(V))(V1)
         end
     end
   , 'genericConj\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictGenericHeytingAlgebra(V))(V1)
         end
     end
   , 'genericDisj\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictGenericHeytingAlgebra@1(V))(V1)
         end
     end
   , 'genericNot\'' =>
     fun
       (V) ->
         DictGenericHeytingAlgebra@4(V)
     end
   }.

genericHeytingAlgebraProduct() ->
  fun
    (DictGenericHeytingAlgebra) ->
      genericHeytingAlgebraProduct(DictGenericHeytingAlgebra)
  end.

genericHeytingAlgebraProduct(#{ 'genericConj\'' := DictGenericHeytingAlgebra
                              , 'genericDisj\'' := DictGenericHeytingAlgebra@1
                              , 'genericFF\'' := DictGenericHeytingAlgebra@2
                              , 'genericImplies\'' :=
                                DictGenericHeytingAlgebra@3
                              , 'genericNot\'' := DictGenericHeytingAlgebra@4
                              , 'genericTT\'' := DictGenericHeytingAlgebra@5
                              }) ->
  fun
    (#{ 'genericConj\'' := DictGenericHeytingAlgebra1
      , 'genericDisj\'' := DictGenericHeytingAlgebra1@1
      , 'genericFF\'' := DictGenericHeytingAlgebra1@2
      , 'genericImplies\'' := DictGenericHeytingAlgebra1@3
      , 'genericNot\'' := DictGenericHeytingAlgebra1@4
      , 'genericTT\'' := DictGenericHeytingAlgebra1@5
      }) ->
      #{ 'genericFF\'' =>
         {product, DictGenericHeytingAlgebra@2, DictGenericHeytingAlgebra1@2}
       , 'genericTT\'' =>
         {product, DictGenericHeytingAlgebra@5, DictGenericHeytingAlgebra1@5}
       , 'genericImplies\'' =>
         fun
           (V) ->
             fun
               (V1) ->
                 { product
                 , (DictGenericHeytingAlgebra@3(erlang:element(2, V)))
                   (erlang:element(2, V1))
                 , (DictGenericHeytingAlgebra1@3(erlang:element(3, V)))
                   (erlang:element(3, V1))
                 }
             end
         end
       , 'genericConj\'' =>
         fun
           (V) ->
             fun
               (V1) ->
                 { product
                 , (DictGenericHeytingAlgebra(erlang:element(2, V)))
                   (erlang:element(2, V1))
                 , (DictGenericHeytingAlgebra1(erlang:element(3, V)))
                   (erlang:element(3, V1))
                 }
             end
         end
       , 'genericDisj\'' =>
         fun
           (V) ->
             fun
               (V1) ->
                 { product
                 , (DictGenericHeytingAlgebra@1(erlang:element(2, V)))
                   (erlang:element(2, V1))
                 , (DictGenericHeytingAlgebra1@1(erlang:element(3, V)))
                   (erlang:element(3, V1))
                 }
             end
         end
       , 'genericNot\'' =>
         fun
           (V) ->
             { product
             , DictGenericHeytingAlgebra@4(erlang:element(2, V))
             , DictGenericHeytingAlgebra1@4(erlang:element(3, V))
             }
         end
       }
  end.

genericConj() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericHeytingAlgebra) ->
          fun
            (X) ->
              fun
                (Y) ->
                  genericConj(DictGeneric, DictGenericHeytingAlgebra, X, Y)
              end
          end
      end
  end.

genericConj( #{ from := DictGeneric, to := DictGeneric@1 }
           , #{ 'genericConj\'' := DictGenericHeytingAlgebra }
           , X
           , Y
           ) ->
  DictGeneric@1((DictGenericHeytingAlgebra(DictGeneric(X)))(DictGeneric(Y))).

