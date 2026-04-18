-module(erl_data_binary_type@ps).
-export([ showBinary/0
        , semigroupBinary/0
        , monoidBinary/0
        , binaryEq/0
        , eq_/0
        , mempty_/0
        , append_/0
        , show_/0
        , showAsErlang/0
        , showAsPurescript/0
        ]).
-compile(no_auto_import).
showBinary() ->
  #{ show => show_() }.

semigroupBinary() ->
  #{ append => append_() }.

monoidBinary() ->
  #{ mempty => <<"">>
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupBinary()
     end
   }.

binaryEq() ->
  #{ eq => eq_() }.

eq_() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_binary_type@foreign:eq_(V, V@1)
      end
  end.

mempty_() ->
  erl_data_binary_type@foreign:mempty_().

append_() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_binary_type@foreign:append_(V, V@1)
      end
  end.

show_() ->
  fun
    (V) ->
      erl_data_binary_type@foreign:show_(V)
  end.

showAsErlang() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_binary_type@foreign:showAsErlang(V, V@1)
      end
  end.

showAsPurescript() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_binary_type@foreign:showAsPurescript(V, V@1)
      end
  end.

