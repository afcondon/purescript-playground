-module(effect_unsafe@ps).
-export([unsafePerformEffect/0]).
-compile(no_auto_import).
unsafePerformEffect() ->
  fun
    (V) ->
      effect_unsafe@foreign:unsafePerformEffect(V)
  end.

