-module(data_monoid_generic@ps).
-export([ genericMonoidNoArguments/0
        , genericMonoidArgument/0
        , genericMonoidArgument/1
        , 'genericMempty\''/0
        , 'genericMempty\''/1
        , genericMonoidConstructor/0
        , genericMonoidConstructor/1
        , genericMonoidProduct/0
        , genericMonoidProduct/1
        , genericMempty/0
        , genericMempty/2
        ]).
-compile(no_auto_import).
genericMonoidNoArguments() ->
  #{ 'genericMempty\'' => {noArguments} }.

genericMonoidArgument() ->
  fun
    (DictMonoid) ->
      genericMonoidArgument(DictMonoid)
  end.

genericMonoidArgument(#{ mempty := DictMonoid }) ->
  #{ 'genericMempty\'' => DictMonoid }.

'genericMempty\''() ->
  fun
    (Dict) ->
      'genericMempty\''(Dict)
  end.

'genericMempty\''(#{ 'genericMempty\'' := Dict }) ->
  Dict.

genericMonoidConstructor() ->
  fun
    (DictGenericMonoid) ->
      genericMonoidConstructor(DictGenericMonoid)
  end.

genericMonoidConstructor(#{ 'genericMempty\'' := DictGenericMonoid }) ->
  #{ 'genericMempty\'' => DictGenericMonoid }.

genericMonoidProduct() ->
  fun
    (DictGenericMonoid) ->
      genericMonoidProduct(DictGenericMonoid)
  end.

genericMonoidProduct(#{ 'genericMempty\'' := DictGenericMonoid }) ->
  fun
    (#{ 'genericMempty\'' := DictGenericMonoid1 }) ->
      #{ 'genericMempty\'' => {product, DictGenericMonoid, DictGenericMonoid1} }
  end.

genericMempty() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericMonoid) ->
          genericMempty(DictGeneric, DictGenericMonoid)
      end
  end.

genericMempty( #{ to := DictGeneric }
             , #{ 'genericMempty\'' := DictGenericMonoid }
             ) ->
  DictGeneric(DictGenericMonoid).

