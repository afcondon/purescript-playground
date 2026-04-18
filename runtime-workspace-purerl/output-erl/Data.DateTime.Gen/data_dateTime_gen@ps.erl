-module(data_dateTime_gen@ps).
-export([genDateTime/0, genDateTime/1]).
-compile(no_auto_import).
genDateTime() ->
  fun
    (DictMonadGen) ->
      genDateTime(DictMonadGen)
  end.

genDateTime(DictMonadGen = #{ 'Monad0' := DictMonadGen@1 }) ->
  begin
    #{ 'Functor0' := Apply0, apply := Apply0@1 } =
      (erlang:map_get(
         'Apply0',
         (erlang:map_get('Bind1', DictMonadGen@1(undefined)))(undefined)
       ))
      (undefined),
    (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
               (data_dateTime@ps:'DateTime'()))
              (data_date_gen@ps:genDate(DictMonadGen))))
    (data_time_gen@ps:genTime(DictMonadGen))
  end.

