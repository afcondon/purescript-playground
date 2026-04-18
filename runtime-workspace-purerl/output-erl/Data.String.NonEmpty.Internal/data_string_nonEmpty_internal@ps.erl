-module(data_string_nonEmpty_internal@ps).
-export([ 'NonEmptyString'/0
        , 'NonEmptyString'/1
        , 'NonEmptyReplacement'/0
        , 'NonEmptyReplacement'/1
        , toUpper/0
        , toUpper/1
        , toString/0
        , toString/1
        , toLower/0
        , toLower/1
        , showNonEmptyString/0
        , showNonEmptyReplacement/0
        , semigroupNonEmptyString/0
        , semigroupNonEmptyReplacement/0
        , replaceAll/0
        , replaceAll/3
        , replace/0
        , replace/3
        , prependString/0
        , prependString/2
        , ordNonEmptyString/0
        , ordNonEmptyReplacement/0
        , nonEmptyNonEmpty/0
        , nonEmptyNonEmpty/1
        , nes/0
        , nes/1
        , makeNonEmptyBad/0
        , makeNonEmptyBad/1
        , localeCompare/0
        , localeCompare/2
        , liftS/0
        , liftS/2
        , joinWith1/0
        , joinWith1/1
        , joinWith/0
        , joinWith/3
        , join1With/0
        , join1With/1
        , fromString/0
        , fromString/1
        , stripPrefix/0
        , stripPrefix/2
        , stripSuffix/0
        , stripSuffix/2
        , trim/0
        , trim/1
        , unsafeFromString/0
        , unsafeFromString/2
        , eqNonEmptyString/0
        , eqNonEmptyReplacement/0
        , contains/0
        , contains/1
        , appendString/0
        , appendString/2
        ]).
-compile(no_auto_import).
'NonEmptyString'() ->
  fun
    (X) ->
      'NonEmptyString'(X)
  end.

'NonEmptyString'(X) ->
  X.

'NonEmptyReplacement'() ->
  fun
    (X) ->
      'NonEmptyReplacement'(X)
  end.

'NonEmptyReplacement'(X) ->
  X.

toUpper() ->
  fun
    (V) ->
      toUpper(V)
  end.

toUpper(V) ->
  data_string_common@foreign:toUpper(V).

toString() ->
  fun
    (V) ->
      toString(V)
  end.

toString(V) ->
  V.

toLower() ->
  fun
    (V) ->
      toLower(V)
  end.

toLower(V) ->
  data_string_common@foreign:toLower(V).

showNonEmptyString() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(NonEmptyString.unsafeFromString ",
           (data_show@foreign:showStringImpl(V))/binary,
           ")"
         >>
     end
   }.

showNonEmptyReplacement() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(NonEmptyReplacement (NonEmptyString.unsafeFromString ",
           (data_show@foreign:showStringImpl(V))/binary,
           "))"
         >>
     end
   }.

semigroupNonEmptyString() ->
  data_semigroup@ps:semigroupString().

semigroupNonEmptyReplacement() ->
  data_semigroup@ps:semigroupString().

replaceAll() ->
  fun
    (Pat) ->
      fun
        (V) ->
          fun
            (V1) ->
              replaceAll(Pat, V, V1)
          end
      end
  end.

replaceAll(Pat, V, V1) ->
  data_string_common@foreign:replaceAll(Pat, V, V1).

replace() ->
  fun
    (Pat) ->
      fun
        (V) ->
          fun
            (V1) ->
              replace(Pat, V, V1)
          end
      end
  end.

replace(Pat, V, V1) ->
  data_string_common@foreign:replace(Pat, V, V1).

prependString() ->
  fun
    (S1) ->
      fun
        (V) ->
          prependString(S1, V)
      end
  end.

prependString(S1, V) ->
  <<S1/binary, V/binary>>.

ordNonEmptyString() ->
  data_ord@ps:ordString().

ordNonEmptyReplacement() ->
  data_ord@ps:ordString().

nonEmptyNonEmpty() ->
  fun
    (DictIsSymbol) ->
      nonEmptyNonEmpty(DictIsSymbol)
  end.

nonEmptyNonEmpty(#{ reflectSymbol := DictIsSymbol }) ->
  #{ nes =>
     fun
       (P) ->
         DictIsSymbol(P)
     end
   }.

nes() ->
  fun
    (Dict) ->
      nes(Dict)
  end.

nes(#{ nes := Dict }) ->
  Dict.

makeNonEmptyBad() ->
  fun
    (V) ->
      makeNonEmptyBad(V)
  end.

makeNonEmptyBad(_) ->
  #{ nes =>
     fun
       (_) ->
         <<"">>
     end
   }.

localeCompare() ->
  fun
    (V) ->
      fun
        (V1) ->
          localeCompare(V, V1)
      end
  end.

localeCompare(V, V1) ->
  data_string_common@ps:localeCompare(V, V1).

liftS() ->
  fun
    (F) ->
      fun
        (V) ->
          liftS(F, V)
      end
  end.

liftS(F, V) ->
  F(V).

joinWith1() ->
  fun
    (DictFoldable1) ->
      joinWith1(DictFoldable1)
  end.

joinWith1(#{ 'Foldable0' := DictFoldable1 }) ->
  begin
    #{ foldl := V } = DictFoldable1(undefined),
    fun
      (Sep) ->
        fun
          (Xs) ->
            erlang:map_get(
              acc,
              ((V(fun
                  (V@1) ->
                    fun
                      (V1) ->
                        if
                          erlang:map_get(init, V@1) ->
                            #{ init => false, acc => V1 };
                          true ->
                            #{ init => false
                             , acc =>
                               <<
                                 (erlang:map_get(acc, V@1))/binary,
                                 Sep/binary,
                                 V1/binary
                               >>
                             }
                        end
                    end
                end))
               (#{ init => true, acc => <<"">> }))
              (Xs)
            )
        end
    end
  end.

joinWith() ->
  fun
    (DictFoldable) ->
      fun
        (Splice) ->
          fun
            (Xs) ->
              joinWith(DictFoldable, Splice, Xs)
          end
      end
  end.

joinWith(#{ foldl := DictFoldable }, Splice, Xs) ->
  erlang:map_get(
    acc,
    ((DictFoldable(fun
        (V) ->
          fun
            (V1) ->
              if
                erlang:map_get(init, V) ->
                  #{ init => false, acc => V1 };
                true ->
                  #{ init => false
                   , acc =>
                     <<
                       (erlang:map_get(acc, V))/binary,
                       Splice/binary,
                       V1/binary
                     >>
                   }
              end
          end
      end))
     (#{ init => true, acc => <<"">> }))
    (Xs)
  ).

join1With() ->
  fun
    (DictFoldable1) ->
      join1With(DictFoldable1)
  end.

join1With(#{ 'Foldable0' := DictFoldable1 }) ->
  begin
    #{ foldl := V } = DictFoldable1(undefined),
    fun
      (Splice) ->
        fun
          (Xs) ->
            erlang:map_get(
              acc,
              ((V(fun
                  (V@1) ->
                    fun
                      (V1) ->
                        if
                          erlang:map_get(init, V@1) ->
                            #{ init => false, acc => V1 };
                          true ->
                            #{ init => false
                             , acc =>
                               <<
                                 (erlang:map_get(acc, V@1))/binary,
                                 Splice/binary,
                                 V1/binary
                               >>
                             }
                        end
                    end
                end))
               (#{ init => true, acc => <<"">> }))
              (Xs)
            )
        end
    end
  end.

fromString() ->
  fun
    (V) ->
      fromString(V)
  end.

fromString(V) ->
  if
    V =:= <<"">> ->
      {nothing};
    true ->
      {just, V}
  end.

stripPrefix() ->
  fun
    (Pat) ->
      fun
        (A) ->
          stripPrefix(Pat, A)
      end
  end.

stripPrefix(Pat, A) ->
  begin
    V = data_string_codeUnits@ps:stripPrefix(Pat, A),
    case V of
      {just, V@1} ->
        if
          V@1 =:= <<"">> ->
            {nothing};
          true ->
            {just, V@1}
        end;
      {nothing} ->
        {nothing};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

stripSuffix() ->
  fun
    (Pat) ->
      fun
        (A) ->
          stripSuffix(Pat, A)
      end
  end.

stripSuffix(Pat, A) ->
  begin
    V = data_string_codeUnits@ps:stripSuffix(Pat, A),
    case V of
      {just, V@1} ->
        if
          V@1 =:= <<"">> ->
            {nothing};
          true ->
            {just, V@1}
        end;
      {nothing} ->
        {nothing};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

trim() ->
  fun
    (V) ->
      trim(V)
  end.

trim(V) ->
  begin
    V@1 = data_string_common@foreign:trim(V),
    if
      V@1 =:= <<"">> ->
        {nothing};
      true ->
        {just, V@1}
    end
  end.

unsafeFromString() ->
  fun
    (V) ->
      fun
        (X) ->
          unsafeFromString(V, X)
      end
  end.

unsafeFromString(_, X) ->
  if
    X =:= <<"">> ->
      erlang:error({fail, <<"Failed pattern match">>});
    true ->
      X
  end.

eqNonEmptyString() ->
  data_eq@ps:eqString().

eqNonEmptyReplacement() ->
  data_eq@ps:eqString().

contains() ->
  fun
    (X) ->
      contains(X)
  end.

contains(X) ->
  data_string_codeUnits@ps:contains(X).

appendString() ->
  fun
    (V) ->
      fun
        (S2) ->
          appendString(V, S2)
      end
  end.

appendString(V, S2) ->
  <<V/binary, S2/binary>>.

