-module(data_number_approximate@ps).
-export([ 'Tolerance'/0
        , 'Tolerance'/1
        , 'Fraction'/0
        , 'Fraction'/1
        , eqRelative/0
        , eqRelative/3
        , eqApproximate/0
        , neqApproximate/0
        , neqApproximate/2
        , eqAbsolute/0
        , eqAbsolute/3
        , eqApproximate/2
        ]).
-compile(no_auto_import).
'Tolerance'() ->
  fun
    (X) ->
      'Tolerance'(X)
  end.

'Tolerance'(X) ->
  X.

'Fraction'() ->
  fun
    (X) ->
      'Fraction'(X)
  end.

'Fraction'(X) ->
  X.

eqRelative() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              eqRelative(V, V1, V2)
          end
      end
  end.

eqRelative(V, V1, V2) ->
  if
    V1 =:= 0.0 ->
      (math@foreign:abs(V2)) =< V;
    V2 =:= 0.0 ->
      (math@foreign:abs(V1)) =< V;
    true ->
      (math@foreign:abs(V1 - V2)) =< ((V * (math@foreign:abs(V1 + V2))) / 2.0)
  end.

eqApproximate() ->
  (eqRelative())(0.000001).

neqApproximate() ->
  fun
    (X) ->
      fun
        (Y) ->
          neqApproximate(X, Y)
      end
  end.

neqApproximate(X, Y) ->
  not (eqRelative(0.000001, X, Y)).

eqAbsolute() ->
  fun
    (V) ->
      fun
        (X) ->
          fun
            (Y) ->
              eqAbsolute(V, X, Y)
          end
      end
  end.

eqAbsolute(V, X, Y) ->
  (math@foreign:abs(X - Y)) =< V.

eqApproximate(V, V@1) ->
  eqRelative(0.000001, V, V@1).

