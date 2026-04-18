-module(effect_console@ps).
-export([ warnShow/0
        , warnShow/2
        , logShow/0
        , logShow/2
        , infoShow/0
        , infoShow/2
        , errorShow/0
        , errorShow/2
        , log/0
        , warn/0
        , error/0
        , info/0
        , clear/0
        , time/0
        , timeLog/0
        , timeEnd/0
        ]).
-compile(no_auto_import).
warnShow() ->
  fun
    (DictShow) ->
      fun
        (A) ->
          warnShow(DictShow, A)
      end
  end.

warnShow(#{ show := DictShow }, A) ->
  effect_console@foreign:warn(DictShow(A)).

logShow() ->
  fun
    (DictShow) ->
      fun
        (A) ->
          logShow(DictShow, A)
      end
  end.

logShow(#{ show := DictShow }, A) ->
  effect_console@foreign:log(DictShow(A)).

infoShow() ->
  fun
    (DictShow) ->
      fun
        (A) ->
          infoShow(DictShow, A)
      end
  end.

infoShow(#{ show := DictShow }, A) ->
  effect_console@foreign:info(DictShow(A)).

errorShow() ->
  fun
    (DictShow) ->
      fun
        (A) ->
          errorShow(DictShow, A)
      end
  end.

errorShow(#{ show := DictShow }, A) ->
  effect_console@foreign:error(DictShow(A)).

log() ->
  fun
    (V) ->
      effect_console@foreign:log(V)
  end.

warn() ->
  fun
    (V) ->
      effect_console@foreign:warn(V)
  end.

error() ->
  fun
    (V) ->
      effect_console@foreign:error(V)
  end.

info() ->
  fun
    (V) ->
      effect_console@foreign:info(V)
  end.

clear() ->
  effect_console@foreign:clear().

time() ->
  fun
    (V) ->
      effect_console@foreign:time(V)
  end.

timeLog() ->
  fun
    (V) ->
      effect_console@foreign:timeLog(V)
  end.

timeEnd() ->
  fun
    (V) ->
      effect_console@foreign:timeEnd(V)
  end.

