-module(erl_atom@ps).
-export([ atomShow/0
        , atomEq/0
        , ordAtom/0
        , atom/0
        , toString/0
        , eqImpl/0
        , ordAtomImpl/0
        ]).
-compile(no_auto_import).
atomShow() ->
  #{ show =>
     fun
       (X) ->
         <<"atom(", (erlang:atom_to_binary(X))/binary, ")">>
     end
   }.

atomEq() ->
  #{ eq => eqImpl() }.

ordAtom() ->
  #{ compare => (((ordAtomImpl())({lT}))({eQ}))({gT})
   , 'Eq0' =>
     fun
       (_) ->
         atomEq()
     end
   }.

atom() ->
  fun
    (V) ->
      erl_atom@foreign:atom(V)
  end.

toString() ->
  fun
    (V) ->
      erl_atom@foreign:toString(V)
  end.

eqImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_atom@foreign:eqImpl(V, V@1)
      end
  end.

ordAtomImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      erl_atom@foreign:ordAtomImpl(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

