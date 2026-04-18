-module(math@ps).
-export([ abs/0
        , acos/0
        , asin/0
        , atan/0
        , atan2/0
        , ceil/0
        , cos/0
        , exp/0
        , floor/0
        , imul/0
        , trunc/0
        , log/0
        , max/0
        , min/0
        , pow/0
        , remainder/0
        , round/0
        , sin/0
        , sqrt/0
        , tan/0
        , e/0
        , ln2/0
        , ln10/0
        , log2e/0
        , log10e/0
        , pi/0
        , tau/0
        , sqrt1_2/0
        , sqrt2/0
        ]).
-compile(no_auto_import).
abs() ->
  fun
    (V) ->
      math@foreign:abs(V)
  end.

acos() ->
  fun
    (V) ->
      math@foreign:acos(V)
  end.

asin() ->
  fun
    (V) ->
      math@foreign:asin(V)
  end.

atan() ->
  fun
    (V) ->
      math@foreign:atan(V)
  end.

atan2() ->
  fun
    (V) ->
      fun
        (V@1) ->
          math@foreign:atan2(V, V@1)
      end
  end.

ceil() ->
  fun
    (V) ->
      math@foreign:ceil(V)
  end.

cos() ->
  fun
    (V) ->
      math@foreign:cos(V)
  end.

exp() ->
  fun
    (V) ->
      math@foreign:exp(V)
  end.

floor() ->
  fun
    (V) ->
      math@foreign:floor(V)
  end.

imul() ->
  fun
    (V) ->
      fun
        (V@1) ->
          math@foreign:imul(V, V@1)
      end
  end.

trunc() ->
  fun
    (V) ->
      math@foreign:trunc(V)
  end.

log() ->
  fun
    (V) ->
      math@foreign:log(V)
  end.

max() ->
  fun
    (V) ->
      fun
        (V@1) ->
          math@foreign:max(V, V@1)
      end
  end.

min() ->
  fun
    (V) ->
      fun
        (V@1) ->
          math@foreign:min(V, V@1)
      end
  end.

pow() ->
  fun
    (V) ->
      fun
        (V@1) ->
          math@foreign:pow(V, V@1)
      end
  end.

remainder() ->
  fun
    (V) ->
      fun
        (V@1) ->
          math@foreign:remainder(V, V@1)
      end
  end.

round() ->
  fun
    (V) ->
      math@foreign:round(V)
  end.

sin() ->
  fun
    (V) ->
      math@foreign:sin(V)
  end.

sqrt() ->
  fun
    (V) ->
      math@foreign:sqrt(V)
  end.

tan() ->
  fun
    (V) ->
      math@foreign:tan(V)
  end.

e() ->
  math@foreign:e().

ln2() ->
  math@foreign:ln2().

ln10() ->
  math@foreign:ln10().

log2e() ->
  math@foreign:log2e().

log10e() ->
  math@foreign:log10e().

pi() ->
  math@foreign:pi().

tau() ->
  math@foreign:tau().

sqrt1_2() ->
  math@foreign:sqrt1_2().

sqrt2() ->
  math@foreign:sqrt2().

