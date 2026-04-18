-module(data_string_codePoints@ps).
-export([ showCodePoint/0
        , uncons/0
        , uncons/1
        , unconsButWithTuple/0
        , unconsButWithTuple/1
        , toCodePointArrayFallback/0
        , toCodePointArrayFallback/1
        , unsafeCodePointAt0Fallback/0
        , unsafeCodePointAt0Fallback/1
        , unsafeCodePointAt0/0
        , toCodePointArray/0
        , length/0
        , length/1
        , lastIndexOf/0
        , lastIndexOf/2
        , indexOf/0
        , indexOf/2
        , singletonFallback/0
        , singletonFallback/1
        , fromCodePointArray/0
        , singleton/0
        , takeFallback/0
        , takeFallback/2
        , take/0
        , 'lastIndexOf\''/0
        , 'lastIndexOf\''/3
        , splitAt/0
        , splitAt/2
        , eqCodePoint/0
        , ordCodePoint/0
        , drop/0
        , drop/2
        , 'indexOf\''/0
        , 'indexOf\''/3
        , countTail/0
        , countTail/3
        , countFallback/0
        , countFallback/2
        , countPrefix/0
        , dropWhile/0
        , dropWhile/2
        , takeWhile/0
        , takeWhile/2
        , codePointFromChar/0
        , codePointFromChar/1
        , codePointAtFallback/0
        , codePointAtFallback/2
        , codePointAt/0
        , codePointAt/2
        , boundedCodePoint/0
        , boundedEnumCodePoint/0
        , enumCodePoint/0
        , '_unsafeCodePointAt0'/0
        , '_codePointAt'/0
        , '_countPrefix'/0
        , '_fromCodePointArray'/0
        , '_singleton'/0
        , '_take'/0
        , '_toCodePointArray'/0
        , fromCodePointArray/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
showCodePoint() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(CodePoint 0x",
           (data_string_common@foreign:toUpper(data_int@foreign:toStringAs(
                                                 16,
                                                 V
                                               )))/binary,
           ")"
         >>
     end
   }.

uncons() ->
  fun
    (S) ->
      uncons(S)
  end.

uncons(S) ->
  begin
    V = data_string_codeUnits@foreign:length(S),
    if
      V =:= 0 ->
        {nothing};
      V =:= 1 ->
        { just
        , #{ head =>
             data_enum@foreign:toCharCode(data_string_unsafe@foreign:charAt(
                                            0,
                                            S
                                          ))
           , tail => <<"">>
           }
        };
      true ->
        begin
          Cu1 =
            data_enum@foreign:toCharCode(data_string_unsafe@foreign:charAt(1, S)),
          Cu0 =
            data_enum@foreign:toCharCode(data_string_unsafe@foreign:charAt(0, S)),
          if
            ((55296 =< Cu0) andalso (Cu0 =< 56319))
              andalso ((56320 =< Cu1) andalso (Cu1 =< 57343)) ->
              { just
              , #{ head => (((Cu0 - 55296) * 1024) + (Cu1 - 56320)) + 65536
                 , tail => data_string_codeUnits@foreign:drop(2, S)
                 }
              };
            true ->
              { just
              , #{ head => Cu0
                 , tail => data_string_codeUnits@foreign:drop(1, S)
                 }
              }
          end
        end
    end
  end.

unconsButWithTuple() ->
  fun
    (S) ->
      unconsButWithTuple(S)
  end.

unconsButWithTuple(S) ->
  begin
    V = uncons(S),
    case V of
      {just, #{ head := V@1, tail := V@2 }} ->
        {just, {tuple, V@1, V@2}};
      _ ->
        {nothing}
    end
  end.

toCodePointArrayFallback() ->
  fun
    (S) ->
      toCodePointArrayFallback(S)
  end.

toCodePointArrayFallback(S) ->
  ((erlang:map_get(unfoldr, data_unfoldable@ps:unfoldableArray()))
   (unconsButWithTuple()))
  (S).

unsafeCodePointAt0Fallback() ->
  fun
    (S) ->
      unsafeCodePointAt0Fallback(S)
  end.

unsafeCodePointAt0Fallback(S) ->
  begin
    Cu0 = data_enum@foreign:toCharCode(data_string_unsafe@foreign:charAt(0, S)),
    case ((55296 =< Cu0) andalso (Cu0 =< 56319))
        andalso ((data_string_codeUnits@foreign:length(S)) > 1) of
      true ->
        begin
          Cu1 =
            data_enum@foreign:toCharCode(data_string_unsafe@foreign:charAt(1, S)),
          if
            (56320 =< Cu1) andalso (Cu1 =< 57343) ->
              (((Cu0 - 55296) * 1024) + (Cu1 - 56320)) + 65536;
            true ->
              Cu0
          end
        end;
      _ ->
        Cu0
    end
  end.

unsafeCodePointAt0() ->
  data_string_codePoints@foreign:'_unsafeCodePointAt0'(unsafeCodePointAt0Fallback()).

toCodePointArray() ->
  (data_string_codePoints@foreign:'_toCodePointArray'(toCodePointArrayFallback()))
  (unsafeCodePointAt0()).

length() ->
  fun
    (X) ->
      length(X)
  end.

length(X) ->
  array:size((toCodePointArray())(X)).

lastIndexOf() ->
  fun
    (P) ->
      fun
        (S) ->
          lastIndexOf(P, S)
      end
  end.

lastIndexOf(P, S) ->
  begin
    V = data_string_codeUnits@ps:lastIndexOf(P, S),
    case V of
      {just, V@1} ->
        { just
        , array:size((toCodePointArray())
                     (data_string_codeUnits@foreign:take(V@1, S)))
        };
      _ ->
        {nothing}
    end
  end.

indexOf() ->
  fun
    (P) ->
      fun
        (S) ->
          indexOf(P, S)
      end
  end.

indexOf(P, S) ->
  begin
    V = data_string_codeUnits@ps:indexOf(P, S),
    case V of
      {just, V@1} ->
        { just
        , array:size((toCodePointArray())
                     (data_string_codeUnits@foreign:take(V@1, S)))
        };
      _ ->
        {nothing}
    end
  end.

singletonFallback() ->
  fun
    (V) ->
      singletonFallback(V)
  end.

singletonFallback(V) ->
  if
    V =< 65535 ->
      data_string_codeUnits@foreign:singleton(data_enum@foreign:fromCharCode(V));
    true ->
      <<
        (data_string_codeUnits@foreign:singleton(data_enum@foreign:fromCharCode(((V
                                                   - 65536)
                                                   div 1024)
                                                   + 55296)))/binary,
        (data_string_codeUnits@foreign:singleton(data_enum@foreign:fromCharCode((data_euclideanRing@foreign:intMod(
                                                                                   V
                                                                                     - 65536,
                                                                                   1024
                                                                                 ))
                                                   + 56320)))/binary
      >>
  end.

fromCodePointArray() ->
  ('_fromCodePointArray'())(singletonFallback()).

singleton() ->
  data_string_codePoints@foreign:'_singleton'(singletonFallback()).

takeFallback() ->
  fun
    (V) ->
      fun
        (V1) ->
          takeFallback(V, V1)
      end
  end.

takeFallback(V, V1) ->
  if
    V < 1 ->
      <<"">>;
    true ->
      begin
        V2 = uncons(V1),
        case V2 of
          {just, #{ head := V2@1, tail := V2@2 }} ->
            <<((singleton())(V2@1))/binary, (takeFallback(V - 1, V2@2))/binary>>;
          _ ->
            V1
        end
      end
  end.

take() ->
  data_string_codePoints@foreign:'_take'(takeFallback()).

'lastIndexOf\''() ->
  fun
    (P) ->
      fun
        (I) ->
          fun
            (S) ->
              'lastIndexOf\''(P, I, S)
          end
      end
  end.

'lastIndexOf\''(P, I, S) ->
  begin
    V =
      data_string_codeUnits@ps:'lastIndexOf\''(
        P,
        data_string_codeUnits@foreign:length(((take())(I))(S)),
        S
      ),
    case V of
      {just, V@1} ->
        { just
        , array:size((toCodePointArray())
                     (data_string_codeUnits@foreign:take(V@1, S)))
        };
      _ ->
        {nothing}
    end
  end.

splitAt() ->
  fun
    (I) ->
      fun
        (S) ->
          splitAt(I, S)
      end
  end.

splitAt(I, S) ->
  begin
    Before = ((take())(I))(S),
    #{ before => Before
     , 'after' =>
       data_string_codeUnits@foreign:drop(
         data_string_codeUnits@foreign:length(Before),
         S
       )
     }
  end.

eqCodePoint() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             X =:= Y
         end
     end
   }.

ordCodePoint() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             ((erlang:map_get(compare, data_ord@ps:ordInt()))(X))(Y)
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqCodePoint()
     end
   }.

drop() ->
  fun
    (N) ->
      fun
        (S) ->
          drop(N, S)
      end
  end.

drop(N, S) ->
  data_string_codeUnits@foreign:drop(
    data_string_codeUnits@foreign:length(((take())(N))(S)),
    S
  ).

'indexOf\''() ->
  fun
    (P) ->
      fun
        (I) ->
          fun
            (S) ->
              'indexOf\''(P, I, S)
          end
      end
  end.

'indexOf\''(P, I, S) ->
  begin
    S_ =
      data_string_codeUnits@foreign:drop(
        data_string_codeUnits@foreign:length(((take())(I))(S)),
        S
      ),
    V = data_string_codeUnits@ps:indexOf(P, S_),
    case V of
      {just, V@1} ->
        { just
        , I
            + (array:size((toCodePointArray())
                          (data_string_codeUnits@foreign:take(V@1, S_))))
        };
      _ ->
        {nothing}
    end
  end.

countTail() ->
  fun
    (P) ->
      fun
        (S) ->
          fun
            (Accum) ->
              countTail(P, S, Accum)
          end
      end
  end.

countTail(P, S, Accum) ->
  begin
    V = uncons(S),
    case ?IS_KNOWN_TAG(just, 1, V)
        andalso (P(erlang:map_get(head, erlang:element(2, V)))) of
      true ->
        begin
          {just, #{ tail := V@1 }} = V,
          countTail(P, V@1, Accum + 1)
        end;
      _ ->
        Accum
    end
  end.

countFallback() ->
  fun
    (P) ->
      fun
        (S) ->
          countFallback(P, S)
      end
  end.

countFallback(P, S) ->
  countTail(P, S, 0).

countPrefix() ->
  ((data_string_codePoints@foreign:'_countPrefix'())(countFallback()))
  (unsafeCodePointAt0()).

dropWhile() ->
  fun
    (P) ->
      fun
        (S) ->
          dropWhile(P, S)
      end
  end.

dropWhile(P, S) ->
  data_string_codeUnits@foreign:drop(
    data_string_codeUnits@foreign:length(((take())(((countPrefix())(P))(S)))(S)),
    S
  ).

takeWhile() ->
  fun
    (P) ->
      fun
        (S) ->
          takeWhile(P, S)
      end
  end.

takeWhile(P, S) ->
  ((take())(((countPrefix())(P))(S)))(S).

codePointFromChar() ->
  fun
    (X) ->
      codePointFromChar(X)
  end.

codePointFromChar(X) ->
  data_enum@foreign:toCharCode(X).

codePointAtFallback() ->
  fun
    (N) ->
      fun
        (S) ->
          codePointAtFallback(N, S)
      end
  end.

codePointAtFallback(N, S) ->
  begin
    V = uncons(S),
    case V of
      {just, V@1} ->
        if
          N =:= 0 ->
            {just, erlang:map_get(head, V@1)};
          true ->
            codePointAtFallback(N - 1, erlang:map_get(tail, V@1))
        end;
      _ ->
        {nothing}
    end
  end.

codePointAt() ->
  fun
    (V) ->
      fun
        (V1) ->
          codePointAt(V, V1)
      end
  end.

codePointAt(V, V1) ->
  if
    V < 0 ->
      {nothing};
    V =:= 0 ->
      if
        V1 =:= <<"">> ->
          {nothing};
        true ->
          {just, (unsafeCodePointAt0())(V1)}
      end;
    true ->
      data_string_codePoints@foreign:'_codePointAt'(
        codePointAtFallback(),
        data_maybe@ps:'Just'(),
        {nothing},
        unsafeCodePointAt0(),
        V,
        V1
      )
  end.

boundedCodePoint() ->
  #{ bottom => 0
   , top => 1114111
   , 'Ord0' =>
     fun
       (_) ->
         ordCodePoint()
     end
   }.

boundedEnumCodePoint() ->
  #{ cardinality => 1114112
   , fromEnum =>
     fun
       (V) ->
         V
     end
   , toEnum =>
     fun
       (N) ->
         if
           (N >= 0) andalso (N =< 1114111) ->
             {just, N};
           true ->
             {nothing}
         end
     end
   , 'Bounded0' =>
     fun
       (_) ->
         boundedCodePoint()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumCodePoint()
     end
   }.

enumCodePoint() ->
  #{ succ =>
     fun
       (A) ->
         begin
           V = A + 1,
           if
             (V >= 0) andalso (V =< 1114111) ->
               {just, V};
             true ->
               {nothing}
           end
         end
     end
   , pred =>
     fun
       (A) ->
         begin
           V = A - 1,
           if
             (V >= 0) andalso (V =< 1114111) ->
               {just, V};
             true ->
               {nothing}
           end
         end
     end
   , 'Ord0' =>
     fun
       (_) ->
         ordCodePoint()
     end
   }.

'_unsafeCodePointAt0'() ->
  fun
    (V) ->
      data_string_codePoints@foreign:'_unsafeCodePointAt0'(V)
  end.

'_codePointAt'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      fun
                        (V@5) ->
                          data_string_codePoints@foreign:'_codePointAt'(
                            V,
                            V@1,
                            V@2,
                            V@3,
                            V@4,
                            V@5
                          )
                      end
                  end
              end
          end
      end
  end.

'_countPrefix'() ->
  data_string_codePoints@foreign:'_countPrefix'().

'_fromCodePointArray'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_codePoints@foreign:'_fromCodePointArray'(V, V@1)
      end
  end.

'_singleton'() ->
  fun
    (V) ->
      data_string_codePoints@foreign:'_singleton'(V)
  end.

'_take'() ->
  fun
    (V) ->
      data_string_codePoints@foreign:'_take'(V)
  end.

'_toCodePointArray'() ->
  fun
    (V) ->
      data_string_codePoints@foreign:'_toCodePointArray'(V)
  end.

fromCodePointArray(V) ->
  data_string_codePoints@foreign:'_fromCodePointArray'(singletonFallback(), V).

