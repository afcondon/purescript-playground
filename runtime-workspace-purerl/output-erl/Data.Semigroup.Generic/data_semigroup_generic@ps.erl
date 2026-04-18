-module(data_semigroup_generic@ps).
-export([ genericSemigroupNoConstructors/0
        , genericSemigroupNoArguments/0
        , genericSemigroupArgument/0
        , genericSemigroupArgument/1
        , 'genericAppend\''/0
        , 'genericAppend\''/1
        , genericSemigroupConstructor/0
        , genericSemigroupConstructor/1
        , genericSemigroupProduct/0
        , genericSemigroupProduct/2
        , genericAppend/0
        , genericAppend/4
        ]).
-compile(no_auto_import).
genericSemigroupNoConstructors() ->
  #{ 'genericAppend\'' =>
     fun
       (A) ->
         fun
           (_) ->
             A
         end
     end
   }.

genericSemigroupNoArguments() ->
  #{ 'genericAppend\'' =>
     fun
       (A) ->
         fun
           (_) ->
             A
         end
     end
   }.

genericSemigroupArgument() ->
  fun
    (DictSemigroup) ->
      genericSemigroupArgument(DictSemigroup)
  end.

genericSemigroupArgument(#{ append := DictSemigroup }) ->
  #{ 'genericAppend\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemigroup(V))(V1)
         end
     end
   }.

'genericAppend\''() ->
  fun
    (Dict) ->
      'genericAppend\''(Dict)
  end.

'genericAppend\''(#{ 'genericAppend\'' := Dict }) ->
  Dict.

genericSemigroupConstructor() ->
  fun
    (DictGenericSemigroup) ->
      genericSemigroupConstructor(DictGenericSemigroup)
  end.

genericSemigroupConstructor(#{ 'genericAppend\'' := DictGenericSemigroup }) ->
  #{ 'genericAppend\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictGenericSemigroup(V))(V1)
         end
     end
   }.

genericSemigroupProduct() ->
  fun
    (DictGenericSemigroup) ->
      fun
        (DictGenericSemigroup1) ->
          genericSemigroupProduct(DictGenericSemigroup, DictGenericSemigroup1)
      end
  end.

genericSemigroupProduct( #{ 'genericAppend\'' := DictGenericSemigroup }
                       , #{ 'genericAppend\'' := DictGenericSemigroup1 }
                       ) ->
  #{ 'genericAppend\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             { product
             , (DictGenericSemigroup(erlang:element(2, V)))
               (erlang:element(2, V1))
             , (DictGenericSemigroup1(erlang:element(3, V)))
               (erlang:element(3, V1))
             }
         end
     end
   }.

genericAppend() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericSemigroup) ->
          fun
            (X) ->
              fun
                (Y) ->
                  genericAppend(DictGeneric, DictGenericSemigroup, X, Y)
              end
          end
      end
  end.

genericAppend( #{ from := DictGeneric, to := DictGeneric@1 }
             , #{ 'genericAppend\'' := DictGenericSemigroup }
             , X
             , Y
             ) ->
  DictGeneric@1((DictGenericSemigroup(DictGeneric(X)))(DictGeneric(Y))).

