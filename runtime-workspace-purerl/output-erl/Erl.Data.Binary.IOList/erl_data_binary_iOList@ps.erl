-module(erl_data_binary_iOList@ps).
-export([ semigroupIolist/0
        , applyIolist/0
        , mempty_/0
        , append_/0
        , concat/0
        , toBinary/0
        , fromBinary/0
        , byteSize/0
        ]).
-compile(no_auto_import).
semigroupIolist() ->
  #{ append => append_() }.

applyIolist() ->
  #{ mempty => []
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupIolist()
     end
   }.

mempty_() ->
  erl_data_binary_iOList@foreign:mempty_().

append_() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_binary_iOList@foreign:append_(V, V@1)
      end
  end.

concat() ->
  fun
    (V) ->
      erl_data_binary_iOList@foreign:concat(V)
  end.

toBinary() ->
  fun
    (V) ->
      erl_data_binary_iOList@foreign:toBinary(V)
  end.

fromBinary() ->
  fun
    (V) ->
      erl_data_binary_iOList@foreign:fromBinary(V)
  end.

byteSize() ->
  fun
    (V) ->
      erl_data_binary_iOList@foreign:byteSize(V)
  end.

