-module(data_ord_generic@ps).
-export([ genericOrdNoConstructors/0
        , genericOrdNoArguments/0
        , genericOrdArgument/0
        , genericOrdArgument/1
        , 'genericCompare\''/0
        , 'genericCompare\''/1
        , genericOrdConstructor/0
        , genericOrdConstructor/1
        , genericOrdProduct/0
        , genericOrdProduct/2
        , genericOrdSum/0
        , genericOrdSum/2
        , genericCompare/0
        , genericCompare/4
        ]).
-compile(no_auto_import).
genericOrdNoConstructors() ->
  #{ 'genericCompare\'' =>
     fun
       (_) ->
         fun
           (_) ->
             {eQ}
         end
     end
   }.

genericOrdNoArguments() ->
  #{ 'genericCompare\'' =>
     fun
       (_) ->
         fun
           (_) ->
             {eQ}
         end
     end
   }.

genericOrdArgument() ->
  fun
    (DictOrd) ->
      genericOrdArgument(DictOrd)
  end.

genericOrdArgument(#{ compare := DictOrd }) ->
  #{ 'genericCompare\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictOrd(V))(V1)
         end
     end
   }.

'genericCompare\''() ->
  fun
    (Dict) ->
      'genericCompare\''(Dict)
  end.

'genericCompare\''(#{ 'genericCompare\'' := Dict }) ->
  Dict.

genericOrdConstructor() ->
  fun
    (DictGenericOrd) ->
      genericOrdConstructor(DictGenericOrd)
  end.

genericOrdConstructor(#{ 'genericCompare\'' := DictGenericOrd }) ->
  #{ 'genericCompare\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictGenericOrd(V))(V1)
         end
     end
   }.

genericOrdProduct() ->
  fun
    (DictGenericOrd) ->
      fun
        (DictGenericOrd1) ->
          genericOrdProduct(DictGenericOrd, DictGenericOrd1)
      end
  end.

genericOrdProduct(#{ 'genericCompare\'' := DictGenericOrd }, DictGenericOrd1) ->
  #{ 'genericCompare\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             begin
               V2 =
                 (DictGenericOrd(erlang:element(2, V)))(erlang:element(2, V1)),
               case V2 of
                 {eQ} ->
                   begin
                     #{ 'genericCompare\'' := DictGenericOrd1@1 } =
                       DictGenericOrd1,
                     (DictGenericOrd1@1(erlang:element(3, V)))
                     (erlang:element(3, V1))
                   end;
                 _ ->
                   V2
               end
             end
         end
     end
   }.

genericOrdSum() ->
  fun
    (DictGenericOrd) ->
      fun
        (DictGenericOrd1) ->
          genericOrdSum(DictGenericOrd, DictGenericOrd1)
      end
  end.

genericOrdSum(DictGenericOrd, DictGenericOrd1) ->
  #{ 'genericCompare\'' =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {inl, _} ->
                 case V1 of
                   {inl, V1@1} ->
                     begin
                       {inl, V@1} = V,
                       #{ 'genericCompare\'' := DictGenericOrd@1 } =
                         DictGenericOrd,
                       (DictGenericOrd@1(V@1))(V1@1)
                     end;
                   {inr, _} ->
                     {lT};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end;
               {inr, _} ->
                 case V1 of
                   {inr, V1@2} ->
                     begin
                       {inr, V@2} = V,
                       #{ 'genericCompare\'' := DictGenericOrd1@1 } =
                         DictGenericOrd1,
                       (DictGenericOrd1@1(V@2))(V1@2)
                     end;
                   {inl, _} ->
                     {gT};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   }.

genericCompare() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericOrd) ->
          fun
            (X) ->
              fun
                (Y) ->
                  genericCompare(DictGeneric, DictGenericOrd, X, Y)
              end
          end
      end
  end.

genericCompare( #{ from := DictGeneric }
              , #{ 'genericCompare\'' := DictGenericOrd }
              , X
              , Y
              ) ->
  (DictGenericOrd(DictGeneric(X)))(DictGeneric(Y)).

