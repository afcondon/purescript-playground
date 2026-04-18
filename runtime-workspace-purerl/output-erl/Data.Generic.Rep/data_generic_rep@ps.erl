-module(data_generic_rep@ps).
-export([ 'Inl'/0
        , 'Inr'/0
        , 'Product'/0
        , 'NoArguments'/0
        , 'Constructor'/0
        , 'Constructor'/1
        , 'Argument'/0
        , 'Argument'/1
        , to/0
        , to/1
        , showSum/0
        , showSum/2
        , showProduct/0
        , showProduct/2
        , showNoArguments/0
        , showConstructor/0
        , showConstructor/2
        , showArgument/0
        , showArgument/1
        , repOf/0
        , repOf/2
        , from/0
        , from/1
        ]).
-compile(no_auto_import).
'Inl'() ->
  fun
    (Value0) ->
      {inl, Value0}
  end.

'Inr'() ->
  fun
    (Value0) ->
      {inr, Value0}
  end.

'Product'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {product, Value0, Value1}
      end
  end.

'NoArguments'() ->
  {noArguments}.

'Constructor'() ->
  fun
    (X) ->
      'Constructor'(X)
  end.

'Constructor'(X) ->
  X.

'Argument'() ->
  fun
    (X) ->
      'Argument'(X)
  end.

'Argument'(X) ->
  X.

to() ->
  fun
    (Dict) ->
      to(Dict)
  end.

to(#{ to := Dict }) ->
  Dict.

showSum() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showSum(DictShow, DictShow1)
      end
  end.

showSum(DictShow, DictShow1) ->
  #{ show =>
     fun
       (V) ->
         case V of
           {inl, V@1} ->
             begin
               #{ show := DictShow@1 } = DictShow,
               <<"(Inl ", (DictShow@1(V@1))/binary, ")">>
             end;
           {inr, V@2} ->
             begin
               #{ show := DictShow1@1 } = DictShow1,
               <<"(Inr ", (DictShow1@1(V@2))/binary, ")">>
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

showProduct() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showProduct(DictShow, DictShow1)
      end
  end.

showProduct(#{ show := DictShow }, #{ show := DictShow1 }) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(Product ",
           (DictShow(erlang:element(2, V)))/binary,
           " ",
           (DictShow1(erlang:element(3, V)))/binary,
           ")"
         >>
     end
   }.

showNoArguments() ->
  #{ show =>
     fun
       (_) ->
         <<"NoArguments">>
     end
   }.

showConstructor() ->
  fun
    (DictIsSymbol) ->
      fun
        (DictShow) ->
          showConstructor(DictIsSymbol, DictShow)
      end
  end.

showConstructor(#{ reflectSymbol := DictIsSymbol }, #{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(Constructor @",
           (data_show@foreign:showStringImpl(DictIsSymbol({proxy})))/binary,
           " ",
           (DictShow(V))/binary,
           ")"
         >>
     end
   }.

showArgument() ->
  fun
    (DictShow) ->
      showArgument(DictShow)
  end.

showArgument(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Argument ", (DictShow(V))/binary, ")">>
     end
   }.

repOf() ->
  fun
    (DictGeneric) ->
      fun
        (V) ->
          repOf(DictGeneric, V)
      end
  end.

repOf(_, _) ->
  {proxy}.

from() ->
  fun
    (Dict) ->
      from(Dict)
  end.

from(#{ from := Dict }) ->
  Dict.

