-module(data_date_component_gen@ps).
-export([ genYear/0
        , genYear/1
        , genWeekday/0
        , genWeekday/1
        , genMonth/0
        , genMonth/1
        , genDay/0
        , genDay/1
        ]).
-compile(no_auto_import).
genYear() ->
  fun
    (DictMonadGen) ->
      genYear(DictMonadGen)
  end.

genYear(#{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }) ->
  ((erlang:map_get(
      map,
      (erlang:map_get(
         'Functor0',
         (erlang:map_get(
            'Apply0',
            (erlang:map_get('Bind1', DictMonadGen(undefined)))(undefined)
          ))
         (undefined)
       ))
      (undefined)
    ))
   (fun
     (X) ->
       if
         (X >= 0) andalso (X =< 275759) ->
           X;
         true ->
           erlang:error({fail, <<"Failed pattern match">>})
       end
   end))
  ((DictMonadGen@1(1900))(2100)).

genWeekday() ->
  fun
    (DictMonadGen) ->
      genWeekday(DictMonadGen)
  end.

genWeekday(DictMonadGen) ->
  (data_enum_gen@ps:genBoundedEnum(DictMonadGen))
  (data_date_component@ps:boundedEnumWeekday()).

genMonth() ->
  fun
    (DictMonadGen) ->
      genMonth(DictMonadGen)
  end.

genMonth(DictMonadGen) ->
  (data_enum_gen@ps:genBoundedEnum(DictMonadGen))
  (data_date_component@ps:boundedEnumMonth()).

genDay() ->
  fun
    (DictMonadGen) ->
      genDay(DictMonadGen)
  end.

genDay(DictMonadGen) ->
  (data_enum_gen@ps:genBoundedEnum(DictMonadGen))
  (data_date_component@ps:boundedEnumDay()).

