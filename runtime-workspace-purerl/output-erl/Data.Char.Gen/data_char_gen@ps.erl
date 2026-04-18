-module(data_char_gen@ps).
-export([ toEnumWithDefaults/0
        , toEnumWithDefaults/3
        , foldable1NonEmpty/0
        , genUnicodeChar/0
        , genUnicodeChar/1
        , genDigitChar/0
        , genDigitChar/1
        , 'genAsciiChar\''/0
        , 'genAsciiChar\''/1
        , genAsciiChar/0
        , genAsciiChar/1
        , genAlphaUppercase/0
        , genAlphaUppercase/1
        , genAlphaLowercase/0
        , genAlphaLowercase/1
        , genAlpha/0
        , genAlpha/1
        ]).
-compile(no_auto_import).
toEnumWithDefaults() ->
  fun
    (Low) ->
      fun
        (High) ->
          fun
            (X) ->
              toEnumWithDefaults(Low, High, X)
          end
      end
  end.

toEnumWithDefaults(_, _, X) ->
  data_enum@foreign:fromCharCode(X).

foldable1NonEmpty() ->
  data_nonEmpty@ps:foldable1NonEmpty(data_foldable@ps:foldableArray()).

genUnicodeChar() ->
  fun
    (DictMonadGen) ->
      genUnicodeChar(DictMonadGen)
  end.

genUnicodeChar(#{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }) ->
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
   (((toEnumWithDefaults())(data_bounded@foreign:bottomChar()))
    (data_bounded@foreign:topChar())))
  ((DictMonadGen@1(0))(65536)).

genDigitChar() ->
  fun
    (DictMonadGen) ->
      genDigitChar(DictMonadGen)
  end.

genDigitChar(#{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }) ->
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
   (((toEnumWithDefaults())(data_bounded@foreign:bottomChar()))
    (data_bounded@foreign:topChar())))
  ((DictMonadGen@1(48))(57)).

'genAsciiChar\''() ->
  fun
    (DictMonadGen) ->
      'genAsciiChar\''(DictMonadGen)
  end.

'genAsciiChar\''(#{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }) ->
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
   (((toEnumWithDefaults())(data_bounded@foreign:bottomChar()))
    (data_bounded@foreign:topChar())))
  ((DictMonadGen@1(0))(127)).

genAsciiChar() ->
  fun
    (DictMonadGen) ->
      genAsciiChar(DictMonadGen)
  end.

genAsciiChar(#{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }) ->
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
   (((toEnumWithDefaults())(data_bounded@foreign:bottomChar()))
    (data_bounded@foreign:topChar())))
  ((DictMonadGen@1(32))(127)).

genAlphaUppercase() ->
  fun
    (DictMonadGen) ->
      genAlphaUppercase(DictMonadGen)
  end.

genAlphaUppercase(#{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }) ->
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
   (((toEnumWithDefaults())(data_bounded@foreign:bottomChar()))
    (data_bounded@foreign:topChar())))
  ((DictMonadGen@1(65))(90)).

genAlphaLowercase() ->
  fun
    (DictMonadGen) ->
      genAlphaLowercase(DictMonadGen)
  end.

genAlphaLowercase(#{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }) ->
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
   (((toEnumWithDefaults())(data_bounded@foreign:bottomChar()))
    (data_bounded@foreign:topChar())))
  ((DictMonadGen@1(97))(122)).

genAlpha() ->
  fun
    (DictMonadGen) ->
      genAlpha(DictMonadGen)
  end.

genAlpha(DictMonadGen) ->
  (control_monad_gen@ps:oneOf(DictMonadGen, foldable1NonEmpty()))
  ({ nonEmpty
   , genAlphaLowercase(DictMonadGen)
   , array:from_list([genAlphaUppercase(DictMonadGen)])
   }).

