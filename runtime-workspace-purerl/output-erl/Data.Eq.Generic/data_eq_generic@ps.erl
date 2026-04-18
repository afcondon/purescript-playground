-module(data_eq_generic@ps).
-export([ genericEqNoConstructors/0
        , genericEqNoArguments/0
        , genericEqArgument/0
        , genericEqArgument/1
        , 'genericEq\''/0
        , 'genericEq\''/1
        , genericEqConstructor/0
        , genericEqConstructor/1
        , genericEqProduct/0
        , genericEqProduct/2
        , genericEqSum/0
        , genericEqSum/2
        , genericEq/0
        , genericEq/4
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
genericEqNoConstructors() ->
  #{ 'genericEq\'' =>
     fun
       (_) ->
         fun
           (_) ->
             true
         end
     end
   }.

genericEqNoArguments() ->
  #{ 'genericEq\'' =>
     fun
       (_) ->
         fun
           (_) ->
             true
         end
     end
   }.

genericEqArgument() ->
  fun
    (DictEq) ->
      genericEqArgument(DictEq)
  end.

genericEqArgument(#{ eq := DictEq }) ->
  #{ 'genericEq\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictEq(V))(V1)
         end
     end
   }.

'genericEq\''() ->
  fun
    (Dict) ->
      'genericEq\''(Dict)
  end.

'genericEq\''(#{ 'genericEq\'' := Dict }) ->
  Dict.

genericEqConstructor() ->
  fun
    (DictGenericEq) ->
      genericEqConstructor(DictGenericEq)
  end.

genericEqConstructor(#{ 'genericEq\'' := DictGenericEq }) ->
  #{ 'genericEq\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictGenericEq(V))(V1)
         end
     end
   }.

genericEqProduct() ->
  fun
    (DictGenericEq) ->
      fun
        (DictGenericEq1) ->
          genericEqProduct(DictGenericEq, DictGenericEq1)
      end
  end.

genericEqProduct(#{ 'genericEq\'' := DictGenericEq }, DictGenericEq1) ->
  #{ 'genericEq\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             ((DictGenericEq(erlang:element(2, V)))(erlang:element(2, V1)))
               andalso (((erlang:map_get('genericEq\'', DictGenericEq1))
                         (erlang:element(3, V)))
                        (erlang:element(3, V1)))
         end
     end
   }.

genericEqSum() ->
  fun
    (DictGenericEq) ->
      fun
        (DictGenericEq1) ->
          genericEqSum(DictGenericEq, DictGenericEq1)
      end
  end.

genericEqSum(DictGenericEq, DictGenericEq1) ->
  #{ 'genericEq\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {inl, _} ->
                 ?IS_KNOWN_TAG(inl, 1, V1)
                   andalso (((erlang:map_get('genericEq\'', DictGenericEq))
                             (erlang:element(2, V)))
                            (erlang:element(2, V1)));
               _ ->
                 ?IS_KNOWN_TAG(inr, 1, V)
                   andalso (?IS_KNOWN_TAG(inr, 1, V1)
                     andalso (((erlang:map_get('genericEq\'', DictGenericEq1))
                               (erlang:element(2, V)))
                              (erlang:element(2, V1))))
             end
         end
     end
   }.

genericEq() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericEq) ->
          fun
            (X) ->
              fun
                (Y) ->
                  genericEq(DictGeneric, DictGenericEq, X, Y)
              end
          end
      end
  end.

genericEq(#{ from := DictGeneric }, #{ 'genericEq\'' := DictGenericEq }, X, Y) ->
  (DictGenericEq(DictGeneric(X)))(DictGeneric(Y)).

