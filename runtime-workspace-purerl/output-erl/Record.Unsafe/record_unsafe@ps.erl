-module(record_unsafe@ps).
-export([unsafeHas/0, unsafeGet/0, unsafeSet/0, unsafeDelete/0]).
-compile(no_auto_import).
unsafeHas() ->
  fun
    (V) ->
      fun
        (V@1) ->
          record_unsafe@foreign:unsafeHas(V, V@1)
      end
  end.

unsafeGet() ->
  fun
    (V) ->
      fun
        (V@1) ->
          record_unsafe@foreign:unsafeGet(V, V@1)
      end
  end.

unsafeSet() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              record_unsafe@foreign:unsafeSet(V, V@1, V@2)
          end
      end
  end.

unsafeDelete() ->
  fun
    (V) ->
      fun
        (V@1) ->
          record_unsafe@foreign:unsafeDelete(V, V@1)
      end
  end.

