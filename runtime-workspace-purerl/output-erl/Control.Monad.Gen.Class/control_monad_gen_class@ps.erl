-module(control_monad_gen_class@ps).
-export([ sized/0
        , sized/1
        , resize/0
        , resize/1
        , chooseInt/0
        , chooseInt/1
        , chooseFloat/0
        , chooseFloat/1
        , chooseBool/0
        , chooseBool/1
        ]).
-compile(no_auto_import).
sized() ->
  fun
    (Dict) ->
      sized(Dict)
  end.

sized(#{ sized := Dict }) ->
  Dict.

resize() ->
  fun
    (Dict) ->
      resize(Dict)
  end.

resize(#{ resize := Dict }) ->
  Dict.

chooseInt() ->
  fun
    (Dict) ->
      chooseInt(Dict)
  end.

chooseInt(#{ chooseInt := Dict }) ->
  Dict.

chooseFloat() ->
  fun
    (Dict) ->
      chooseFloat(Dict)
  end.

chooseFloat(#{ chooseFloat := Dict }) ->
  Dict.

chooseBool() ->
  fun
    (Dict) ->
      chooseBool(Dict)
  end.

chooseBool(#{ chooseBool := Dict }) ->
  Dict.

