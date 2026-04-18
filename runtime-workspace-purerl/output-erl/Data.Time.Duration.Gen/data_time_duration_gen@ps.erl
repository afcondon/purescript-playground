-module(data_time_duration_gen@ps).
-export([ genSeconds/0
        , genSeconds/1
        , genMinutes/0
        , genMinutes/1
        , genMilliseconds/0
        , genMilliseconds/1
        , genHours/0
        , genHours/1
        , genDays/0
        , genDays/1
        ]).
-compile(no_auto_import).
genSeconds() ->
  fun
    (DictMonadGen) ->
      genSeconds(DictMonadGen)
  end.

genSeconds(#{ 'Monad0' := DictMonadGen, chooseFloat := DictMonadGen@1 }) ->
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
   (data_time_duration@ps:'Seconds'()))
  ((DictMonadGen@1(0.0))(600.0)).

genMinutes() ->
  fun
    (DictMonadGen) ->
      genMinutes(DictMonadGen)
  end.

genMinutes(#{ 'Monad0' := DictMonadGen, chooseFloat := DictMonadGen@1 }) ->
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
   (data_time_duration@ps:'Minutes'()))
  ((DictMonadGen@1(0.0))(600.0)).

genMilliseconds() ->
  fun
    (DictMonadGen) ->
      genMilliseconds(DictMonadGen)
  end.

genMilliseconds(#{ 'Monad0' := DictMonadGen, chooseFloat := DictMonadGen@1 }) ->
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
   (data_time_duration@ps:'Milliseconds'()))
  ((DictMonadGen@1(0.0))(600000.0)).

genHours() ->
  fun
    (DictMonadGen) ->
      genHours(DictMonadGen)
  end.

genHours(#{ 'Monad0' := DictMonadGen, chooseFloat := DictMonadGen@1 }) ->
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
   (data_time_duration@ps:'Hours'()))
  ((DictMonadGen@1(0.0))(240.0)).

genDays() ->
  fun
    (DictMonadGen) ->
      genDays(DictMonadGen)
  end.

genDays(#{ 'Monad0' := DictMonadGen, chooseFloat := DictMonadGen@1 }) ->
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
   (data_time_duration@ps:'Days'()))
  ((DictMonadGen@1(0.0))(42.0)).

