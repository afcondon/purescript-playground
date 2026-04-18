-module(effect_exception_unsafe@ps).
-export([ unsafeThrowException/0
        , unsafeThrowException/1
        , unsafeThrow/0
        , unsafeThrow/1
        ]).
-compile(no_auto_import).
unsafeThrowException() ->
  fun
    (X) ->
      unsafeThrowException(X)
  end.

unsafeThrowException(X) ->
  effect_unsafe@foreign:unsafePerformEffect(fun
    () ->
      erlang:error(X)
  end).

unsafeThrow() ->
  fun
    (X) ->
      unsafeThrow(X)
  end.

unsafeThrow(X) ->
  effect_unsafe@foreign:unsafePerformEffect(fun
    () ->
      erlang:error(effect_exception@foreign:error(X))
  end).

