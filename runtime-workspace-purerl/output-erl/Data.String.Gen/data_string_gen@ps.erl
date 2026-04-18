-module(data_string_gen@ps).
-export([ max/0
        , max/2
        , genString/0
        , genString/2
        , genUnicodeString/0
        , genUnicodeString/2
        , genDigitString/0
        , genDigitString/2
        , 'genAsciiString\''/0
        , 'genAsciiString\''/2
        , genAsciiString/0
        , genAsciiString/2
        , genAlphaUppercaseString/0
        , genAlphaUppercaseString/2
        , genAlphaString/0
        , genAlphaString/2
        , genAlphaLowercaseString/0
        , genAlphaLowercaseString/2
        ]).
-compile(no_auto_import).
max() ->
  fun
    (X) ->
      fun
        (Y) ->
          max(X, Y)
      end
  end.

max(X, Y) ->
  begin
    V = ((erlang:map_get(compare, data_ord@ps:ordInt()))(X))(Y),
    case V of
      {lT} ->
        Y;
      {eQ} ->
        X;
      {gT} ->
        X;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

genString() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          genString(DictMonadRec, DictMonadGen)
      end
  end.

genString( DictMonadRec
         , DictMonadGen = #{ 'Monad0' := DictMonadGen@1
                           , chooseInt := DictMonadGen@2
                           , resize := DictMonadGen@3
                           , sized := DictMonadGen@4
                           }
         ) ->
  begin
    #{ 'Apply0' := Bind1, bind := Bind1@1 } =
      (erlang:map_get('Bind1', DictMonadGen@1(undefined)))(undefined),
    Unfoldable1 =
      (control_monad_gen@ps:unfoldable(DictMonadRec, DictMonadGen))
      (data_unfoldable@ps:unfoldableArray()),
    fun
      (GenChar) ->
        DictMonadGen@4(fun
          (Size) ->
            (Bind1@1((DictMonadGen@2(1))(max(1, Size))))
            (fun
              (NewSize) ->
                (DictMonadGen@3(fun
                   (_) ->
                     NewSize
                 end))
                (((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', Bind1(undefined)))(undefined)
                   ))
                  (data_string_codeUnits@ps:fromCharArray()))
                 (Unfoldable1(GenChar)))
            end)
        end)
    end
  end.

genUnicodeString() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          genUnicodeString(DictMonadRec, DictMonadGen)
      end
  end.

genUnicodeString(DictMonadRec, DictMonadGen) ->
  (genString(DictMonadRec, DictMonadGen))
  (data_char_gen@ps:genUnicodeChar(DictMonadGen)).

genDigitString() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          genDigitString(DictMonadRec, DictMonadGen)
      end
  end.

genDigitString(DictMonadRec, DictMonadGen) ->
  (genString(DictMonadRec, DictMonadGen))
  (data_char_gen@ps:genDigitChar(DictMonadGen)).

'genAsciiString\''() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          'genAsciiString\''(DictMonadRec, DictMonadGen)
      end
  end.

'genAsciiString\''(DictMonadRec, DictMonadGen) ->
  (genString(DictMonadRec, DictMonadGen))
  (data_char_gen@ps:'genAsciiChar\''(DictMonadGen)).

genAsciiString() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          genAsciiString(DictMonadRec, DictMonadGen)
      end
  end.

genAsciiString(DictMonadRec, DictMonadGen) ->
  (genString(DictMonadRec, DictMonadGen))
  (data_char_gen@ps:genAsciiChar(DictMonadGen)).

genAlphaUppercaseString() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          genAlphaUppercaseString(DictMonadRec, DictMonadGen)
      end
  end.

genAlphaUppercaseString(DictMonadRec, DictMonadGen) ->
  (genString(DictMonadRec, DictMonadGen))
  (data_char_gen@ps:genAlphaUppercase(DictMonadGen)).

genAlphaString() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          genAlphaString(DictMonadRec, DictMonadGen)
      end
  end.

genAlphaString(DictMonadRec, DictMonadGen) ->
  (genString(DictMonadRec, DictMonadGen))
  (data_char_gen@ps:genAlpha(DictMonadGen)).

genAlphaLowercaseString() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          genAlphaLowercaseString(DictMonadRec, DictMonadGen)
      end
  end.

genAlphaLowercaseString(DictMonadRec, DictMonadGen) ->
  (genString(DictMonadRec, DictMonadGen))
  (data_char_gen@ps:genAlphaLowercase(DictMonadGen)).

