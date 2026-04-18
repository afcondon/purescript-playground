-module(data_int_bits@ps).
-export(['and'/0, 'or'/0, 'xor'/0, shl/0, shr/0, zshr/0, complement/0]).
-compile(no_auto_import).
'and'() ->
  fun
    (V) ->
      data_int_bits@foreign:'and'(V)
  end.

'or'() ->
  fun
    (V) ->
      data_int_bits@foreign:'or'(V)
  end.

'xor'() ->
  fun
    (V) ->
      data_int_bits@foreign:'xor'(V)
  end.

shl() ->
  fun
    (V) ->
      data_int_bits@foreign:shl(V)
  end.

shr() ->
  fun
    (V) ->
      data_int_bits@foreign:shr(V)
  end.

zshr() ->
  fun
    (V) ->
      data_int_bits@foreign:zshr(V)
  end.

complement() ->
  fun
    (V) ->
      data_int_bits@foreign:complement(V)
  end.

