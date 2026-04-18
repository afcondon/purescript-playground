-module(erl_data_binary_iOData@ps).
-export([ semigroupIoData/0
        , empty/0
        , applyIoData/0
        , mempty_/0
        , append_/0
        , concat/0
        , fromIOList/0
        , fromBinary/0
        , fromString/0
        , toBinary/0
        , byteSize/0
        ]).
-compile(no_auto_import).
semigroupIoData() ->
  #{ append => append_() }.

empty() ->
  [].

applyIoData() ->
  #{ mempty => []
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupIoData()
     end
   }.

mempty_() ->
  erl_data_binary_iOData@foreign:mempty_().

append_() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_binary_iOData@foreign:append_(V, V@1)
      end
  end.

concat() ->
  fun
    (V) ->
      erl_data_binary_iOData@foreign:concat(V)
  end.

fromIOList() ->
  fun
    (V) ->
      erl_data_binary_iOData@foreign:fromIOList(V)
  end.

fromBinary() ->
  fun
    (V) ->
      erl_data_binary_iOData@foreign:fromBinary(V)
  end.

fromString() ->
  fun
    (V) ->
      erl_data_binary_iOData@foreign:fromString(V)
  end.

toBinary() ->
  fun
    (V) ->
      erl_data_binary_iOData@foreign:toBinary(V)
  end.

byteSize() ->
  fun
    (V) ->
      erl_data_binary_iOData@foreign:byteSize(V)
  end.

