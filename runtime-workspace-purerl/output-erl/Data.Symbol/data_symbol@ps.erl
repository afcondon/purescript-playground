-module(data_symbol@ps).
-export([ 'SProxy'/0
        , reifySymbol/0
        , reifySymbol/2
        , reflectSymbol/0
        , reflectSymbol/1
        , unsafeCoerce/0
        ]).
-compile(no_auto_import).
'SProxy'() ->
  {sProxy}.

reifySymbol() ->
  fun
    (S) ->
      fun
        (F) ->
          reifySymbol(S, F)
      end
  end.

reifySymbol(S, F) ->
  ((data_symbol@foreign:unsafeCoerce(fun
      (DictIsSymbol) ->
        F(DictIsSymbol)
    end))
   (#{ reflectSymbol =>
       fun
         (_) ->
           S
       end
     }))
  ({proxy}).

reflectSymbol() ->
  fun
    (Dict) ->
      reflectSymbol(Dict)
  end.

reflectSymbol(#{ reflectSymbol := Dict }) ->
  Dict.

unsafeCoerce() ->
  fun
    (V) ->
      data_symbol@foreign:unsafeCoerce(V)
  end.

