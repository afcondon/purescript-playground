-module(data_time_gen@ps).
-export([genTime/0, genTime/1]).
-compile(no_auto_import).
genTime() ->
  fun
    (DictMonadGen) ->
      genTime(DictMonadGen)
  end.

genTime(DictMonadGen = #{ 'Monad0' := DictMonadGen@1 }) ->
  begin
    #{ 'Functor0' := Apply0, apply := Apply0@1 } =
      (erlang:map_get(
         'Apply0',
         (erlang:map_get('Bind1', DictMonadGen@1(undefined)))(undefined)
       ))
      (undefined),
    (Apply0@1((Apply0@1((Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                                   (data_time@ps:'Time'()))
                                  ((data_enum_gen@ps:genBoundedEnum(DictMonadGen))
                                   (data_time_component@ps:boundedEnumHour()))))
                        ((data_enum_gen@ps:genBoundedEnum(DictMonadGen))
                         (data_time_component@ps:boundedEnumMinute()))))
              ((data_enum_gen@ps:genBoundedEnum(DictMonadGen))
               (data_time_component@ps:boundedEnumSecond()))))
    ((data_enum_gen@ps:genBoundedEnum(DictMonadGen))
     (data_time_component@ps:boundedEnumMillisecond()))
  end.

