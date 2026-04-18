-module(data_time_component_gen@ps).
-export([ genSecond/0
        , genSecond/1
        , genMinute/0
        , genMinute/1
        , genMillisecond/0
        , genMillisecond/1
        , genHour/0
        , genHour/1
        ]).
-compile(no_auto_import).
genSecond() ->
  fun
    (DictMonadGen) ->
      genSecond(DictMonadGen)
  end.

genSecond(DictMonadGen) ->
  (data_enum_gen@ps:genBoundedEnum(DictMonadGen))
  (data_time_component@ps:boundedEnumSecond()).

genMinute() ->
  fun
    (DictMonadGen) ->
      genMinute(DictMonadGen)
  end.

genMinute(DictMonadGen) ->
  (data_enum_gen@ps:genBoundedEnum(DictMonadGen))
  (data_time_component@ps:boundedEnumMinute()).

genMillisecond() ->
  fun
    (DictMonadGen) ->
      genMillisecond(DictMonadGen)
  end.

genMillisecond(DictMonadGen) ->
  (data_enum_gen@ps:genBoundedEnum(DictMonadGen))
  (data_time_component@ps:boundedEnumMillisecond()).

genHour() ->
  fun
    (DictMonadGen) ->
      genHour(DictMonadGen)
  end.

genHour(DictMonadGen) ->
  (data_enum_gen@ps:genBoundedEnum(DictMonadGen))
  (data_time_component@ps:boundedEnumHour()).

