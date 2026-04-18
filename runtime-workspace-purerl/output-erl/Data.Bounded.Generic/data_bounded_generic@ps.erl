-module(data_bounded_generic@ps).
-export([ genericTopNoArguments/0
        , genericTopArgument/0
        , genericTopArgument/1
        , 'genericTop\''/0
        , 'genericTop\''/1
        , genericTopConstructor/0
        , genericTopConstructor/1
        , genericTopProduct/0
        , genericTopProduct/1
        , genericTopSum/0
        , genericTopSum/1
        , genericTop/0
        , genericTop/2
        , genericBottomNoArguments/0
        , genericBottomArgument/0
        , genericBottomArgument/1
        , 'genericBottom\''/0
        , 'genericBottom\''/1
        , genericBottomConstructor/0
        , genericBottomConstructor/1
        , genericBottomProduct/0
        , genericBottomProduct/1
        , genericBottomSum/0
        , genericBottomSum/1
        , genericBottom/0
        , genericBottom/2
        ]).
-compile(no_auto_import).
genericTopNoArguments() ->
  #{ 'genericTop\'' => {noArguments} }.

genericTopArgument() ->
  fun
    (DictBounded) ->
      genericTopArgument(DictBounded)
  end.

genericTopArgument(#{ top := DictBounded }) ->
  #{ 'genericTop\'' => DictBounded }.

'genericTop\''() ->
  fun
    (Dict) ->
      'genericTop\''(Dict)
  end.

'genericTop\''(#{ 'genericTop\'' := Dict }) ->
  Dict.

genericTopConstructor() ->
  fun
    (DictGenericTop) ->
      genericTopConstructor(DictGenericTop)
  end.

genericTopConstructor(#{ 'genericTop\'' := DictGenericTop }) ->
  #{ 'genericTop\'' => DictGenericTop }.

genericTopProduct() ->
  fun
    (DictGenericTop) ->
      genericTopProduct(DictGenericTop)
  end.

genericTopProduct(#{ 'genericTop\'' := DictGenericTop }) ->
  fun
    (#{ 'genericTop\'' := DictGenericTop1 }) ->
      #{ 'genericTop\'' => {product, DictGenericTop, DictGenericTop1} }
  end.

genericTopSum() ->
  fun
    (DictGenericTop) ->
      genericTopSum(DictGenericTop)
  end.

genericTopSum(#{ 'genericTop\'' := DictGenericTop }) ->
  #{ 'genericTop\'' => {inr, DictGenericTop} }.

genericTop() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericTop) ->
          genericTop(DictGeneric, DictGenericTop)
      end
  end.

genericTop(#{ to := DictGeneric }, #{ 'genericTop\'' := DictGenericTop }) ->
  DictGeneric(DictGenericTop).

genericBottomNoArguments() ->
  #{ 'genericBottom\'' => {noArguments} }.

genericBottomArgument() ->
  fun
    (DictBounded) ->
      genericBottomArgument(DictBounded)
  end.

genericBottomArgument(#{ bottom := DictBounded }) ->
  #{ 'genericBottom\'' => DictBounded }.

'genericBottom\''() ->
  fun
    (Dict) ->
      'genericBottom\''(Dict)
  end.

'genericBottom\''(#{ 'genericBottom\'' := Dict }) ->
  Dict.

genericBottomConstructor() ->
  fun
    (DictGenericBottom) ->
      genericBottomConstructor(DictGenericBottom)
  end.

genericBottomConstructor(#{ 'genericBottom\'' := DictGenericBottom }) ->
  #{ 'genericBottom\'' => DictGenericBottom }.

genericBottomProduct() ->
  fun
    (DictGenericBottom) ->
      genericBottomProduct(DictGenericBottom)
  end.

genericBottomProduct(#{ 'genericBottom\'' := DictGenericBottom }) ->
  fun
    (#{ 'genericBottom\'' := DictGenericBottom1 }) ->
      #{ 'genericBottom\'' => {product, DictGenericBottom, DictGenericBottom1} }
  end.

genericBottomSum() ->
  fun
    (DictGenericBottom) ->
      genericBottomSum(DictGenericBottom)
  end.

genericBottomSum(#{ 'genericBottom\'' := DictGenericBottom }) ->
  #{ 'genericBottom\'' => {inl, DictGenericBottom} }.

genericBottom() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericBottom) ->
          genericBottom(DictGeneric, DictGenericBottom)
      end
  end.

genericBottom( #{ to := DictGeneric }
             , #{ 'genericBottom\'' := DictGenericBottom }
             ) ->
  DictGeneric(DictGenericBottom).

