-module(partial_unsafe@ps).
-export([ unsafePartial/0
        , unsafeCrashWith/0
        , unsafeCrashWith/1
        , '_unsafePartial'/0
        , unsafePartial/1
        ]).
-compile(no_auto_import).
unsafePartial() ->
  '_unsafePartial'().

unsafeCrashWith() ->
  fun
    (Msg) ->
      unsafeCrashWith(Msg)
  end.

unsafeCrashWith(Msg) ->
  erlang:error(Msg).

'_unsafePartial'() ->
  fun
    (V) ->
      partial_unsafe@foreign:'_unsafePartial'(V)
  end.

unsafePartial(V) ->
  partial_unsafe@foreign:'_unsafePartial'(V).

