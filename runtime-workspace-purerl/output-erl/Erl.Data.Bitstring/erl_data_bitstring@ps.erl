-module(erl_data_bitstring@ps).
-export([ toBinary/0
        , fromBinary/0
        , isBinary/0
        , toBinaryImpl/0
        , bitSize/0
        , byteSize/0
        , toBinary/1
        ]).
-compile(no_auto_import).
toBinary() ->
  ((toBinaryImpl())({nothing}))(data_maybe@ps:'Just'()).

fromBinary() ->
  fun
    (V) ->
      erl_data_bitstring@foreign:fromBinary(V)
  end.

isBinary() ->
  fun
    (V) ->
      erl_data_bitstring@foreign:isBinary(V)
  end.

toBinaryImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              erl_data_bitstring@foreign:toBinaryImpl(V, V@1, V@2)
          end
      end
  end.

bitSize() ->
  fun
    (V) ->
      erl_data_bitstring@foreign:bitSize(V)
  end.

byteSize() ->
  fun
    (V) ->
      erl_data_bitstring@foreign:byteSize(V)
  end.

toBinary(V) ->
  erl_data_bitstring@foreign:toBinaryImpl({nothing}, data_maybe@ps:'Just'(), V).

