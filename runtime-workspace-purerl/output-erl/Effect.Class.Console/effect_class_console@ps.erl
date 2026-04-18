-module(effect_class_console@ps).
-export([ warnShow/0
        , warnShow/3
        , warn/0
        , warn/2
        , timeLog/0
        , timeLog/2
        , timeEnd/0
        , timeEnd/2
        , time/0
        , time/2
        , logShow/0
        , logShow/3
        , log/0
        , log/2
        , infoShow/0
        , infoShow/3
        , info/0
        , info/2
        , errorShow/0
        , errorShow/3
        , error/0
        , error/2
        , clear/0
        , clear/1
        ]).
-compile(no_auto_import).
warnShow() ->
  fun
    (DictMonadEffect) ->
      fun
        (DictShow) ->
          fun
            (X) ->
              warnShow(DictMonadEffect, DictShow, X)
          end
      end
  end.

warnShow(#{ liftEffect := DictMonadEffect }, #{ show := DictShow }, X) ->
  DictMonadEffect(effect_console@foreign:warn(DictShow(X))).

warn() ->
  fun
    (DictMonadEffect) ->
      fun
        (X) ->
          warn(DictMonadEffect, X)
      end
  end.

warn(#{ liftEffect := DictMonadEffect }, X) ->
  DictMonadEffect(effect_console@foreign:warn(X)).

timeLog() ->
  fun
    (DictMonadEffect) ->
      fun
        (X) ->
          timeLog(DictMonadEffect, X)
      end
  end.

timeLog(#{ liftEffect := DictMonadEffect }, X) ->
  DictMonadEffect(effect_console@foreign:timeLog(X)).

timeEnd() ->
  fun
    (DictMonadEffect) ->
      fun
        (X) ->
          timeEnd(DictMonadEffect, X)
      end
  end.

timeEnd(#{ liftEffect := DictMonadEffect }, X) ->
  DictMonadEffect(effect_console@foreign:timeEnd(X)).

time() ->
  fun
    (DictMonadEffect) ->
      fun
        (X) ->
          time(DictMonadEffect, X)
      end
  end.

time(#{ liftEffect := DictMonadEffect }, X) ->
  DictMonadEffect(effect_console@foreign:time(X)).

logShow() ->
  fun
    (DictMonadEffect) ->
      fun
        (DictShow) ->
          fun
            (X) ->
              logShow(DictMonadEffect, DictShow, X)
          end
      end
  end.

logShow(#{ liftEffect := DictMonadEffect }, #{ show := DictShow }, X) ->
  DictMonadEffect(effect_console@foreign:log(DictShow(X))).

log() ->
  fun
    (DictMonadEffect) ->
      fun
        (X) ->
          log(DictMonadEffect, X)
      end
  end.

log(#{ liftEffect := DictMonadEffect }, X) ->
  DictMonadEffect(effect_console@foreign:log(X)).

infoShow() ->
  fun
    (DictMonadEffect) ->
      fun
        (DictShow) ->
          fun
            (X) ->
              infoShow(DictMonadEffect, DictShow, X)
          end
      end
  end.

infoShow(#{ liftEffect := DictMonadEffect }, #{ show := DictShow }, X) ->
  DictMonadEffect(effect_console@foreign:info(DictShow(X))).

info() ->
  fun
    (DictMonadEffect) ->
      fun
        (X) ->
          info(DictMonadEffect, X)
      end
  end.

info(#{ liftEffect := DictMonadEffect }, X) ->
  DictMonadEffect(effect_console@foreign:info(X)).

errorShow() ->
  fun
    (DictMonadEffect) ->
      fun
        (DictShow) ->
          fun
            (X) ->
              errorShow(DictMonadEffect, DictShow, X)
          end
      end
  end.

errorShow(#{ liftEffect := DictMonadEffect }, #{ show := DictShow }, X) ->
  DictMonadEffect(effect_console@foreign:error(DictShow(X))).

error() ->
  fun
    (DictMonadEffect) ->
      fun
        (X) ->
          error(DictMonadEffect, X)
      end
  end.

error(#{ liftEffect := DictMonadEffect }, X) ->
  DictMonadEffect(effect_console@foreign:error(X)).

clear() ->
  fun
    (DictMonadEffect) ->
      clear(DictMonadEffect)
  end.

clear(#{ liftEffect := DictMonadEffect }) ->
  DictMonadEffect(effect_console@foreign:clear()).

