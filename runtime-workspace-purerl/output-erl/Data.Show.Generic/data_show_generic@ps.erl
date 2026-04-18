-module(data_show_generic@ps).
-export([ genericShowArgsNoArguments/0
        , genericShowArgsArgument/0
        , genericShowArgsArgument/1
        , genericShowArgs/0
        , genericShowArgs/1
        , genericShowArgsProduct/0
        , genericShowArgsProduct/2
        , genericShowConstructor/0
        , genericShowConstructor/2
        , 'genericShow\''/0
        , 'genericShow\''/1
        , genericShowNoConstructors/0
        , genericShowSum/0
        , genericShowSum/2
        , genericShow/0
        , genericShow/3
        , intercalate/0
        ]).
-compile(no_auto_import).
genericShowArgsNoArguments() ->
  #{ genericShowArgs =>
     fun
       (_) ->
         array:from_list([])
     end
   }.

genericShowArgsArgument() ->
  fun
    (DictShow) ->
      genericShowArgsArgument(DictShow)
  end.

genericShowArgsArgument(#{ show := DictShow }) ->
  #{ genericShowArgs =>
     fun
       (V) ->
         array:from_list([DictShow(V)])
     end
   }.

genericShowArgs() ->
  fun
    (Dict) ->
      genericShowArgs(Dict)
  end.

genericShowArgs(#{ genericShowArgs := Dict }) ->
  Dict.

genericShowArgsProduct() ->
  fun
    (DictGenericShowArgs) ->
      fun
        (DictGenericShowArgs1) ->
          genericShowArgsProduct(DictGenericShowArgs, DictGenericShowArgs1)
      end
  end.

genericShowArgsProduct( #{ genericShowArgs := DictGenericShowArgs }
                      , #{ genericShowArgs := DictGenericShowArgs1 }
                      ) ->
  #{ genericShowArgs =>
     fun
       (V) ->
         data_semigroup@foreign:concatArray(
           DictGenericShowArgs(erlang:element(2, V)),
           DictGenericShowArgs1(erlang:element(3, V))
         )
     end
   }.

genericShowConstructor() ->
  fun
    (DictGenericShowArgs) ->
      fun
        (DictIsSymbol) ->
          genericShowConstructor(DictGenericShowArgs, DictIsSymbol)
      end
  end.

genericShowConstructor( #{ genericShowArgs := DictGenericShowArgs }
                      , #{ reflectSymbol := DictIsSymbol }
                      ) ->
  #{ 'genericShow\'' =>
     fun
       (V) ->
         begin
           Ctor = DictIsSymbol({proxy}),
           V1 = DictGenericShowArgs(V),
           case (array:size(V1)) =:= 0 of
             true ->
               Ctor;
             _ ->
               <<
                 "(",
                 (data_show_generic@foreign:intercalate(
                    <<" ">>,
                    data_semigroup@foreign:concatArray(
                      array:from_list([Ctor]),
                      V1
                    )
                  ))/binary,
                 ")"
               >>
           end
         end
     end
   }.

'genericShow\''() ->
  fun
    (Dict) ->
      'genericShow\''(Dict)
  end.

'genericShow\''(#{ 'genericShow\'' := Dict }) ->
  Dict.

genericShowNoConstructors() ->
  #{ 'genericShow\'' =>
     fun
       (A) ->
         (erlang:map_get('genericShow\'', genericShowNoConstructors()))(A)
     end
   }.

genericShowSum() ->
  fun
    (DictGenericShow) ->
      fun
        (DictGenericShow1) ->
          genericShowSum(DictGenericShow, DictGenericShow1)
      end
  end.

genericShowSum(DictGenericShow, DictGenericShow1) ->
  #{ 'genericShow\'' =>
     fun
       (V) ->
         case V of
           {inl, V@1} ->
             begin
               #{ 'genericShow\'' := DictGenericShow@1 } = DictGenericShow,
               DictGenericShow@1(V@1)
             end;
           {inr, V@2} ->
             begin
               #{ 'genericShow\'' := DictGenericShow1@1 } = DictGenericShow1,
               DictGenericShow1@1(V@2)
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

genericShow() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericShow) ->
          fun
            (X) ->
              genericShow(DictGeneric, DictGenericShow, X)
          end
      end
  end.

genericShow( #{ from := DictGeneric }
           , #{ 'genericShow\'' := DictGenericShow }
           , X
           ) ->
  DictGenericShow(DictGeneric(X)).

intercalate() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_show_generic@foreign:intercalate(V, V@1)
      end
  end.

