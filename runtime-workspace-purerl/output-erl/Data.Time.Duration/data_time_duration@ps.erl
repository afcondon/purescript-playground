-module(data_time_duration@ps).
-export([ identity/0
        , identity/1
        , 'Seconds'/0
        , 'Seconds'/1
        , 'Minutes'/0
        , 'Minutes'/1
        , 'Milliseconds'/0
        , 'Milliseconds'/1
        , 'Hours'/0
        , 'Hours'/1
        , 'Days'/0
        , 'Days'/1
        , toDuration/0
        , toDuration/1
        , showSeconds/0
        , showMinutes/0
        , showMilliseconds/0
        , showHours/0
        , showDays/0
        , semigroupSeconds/0
        , semigroupMinutes/0
        , semigroupMilliseconds/0
        , semigroupHours/0
        , semigroupDays/0
        , ordSeconds/0
        , ordMinutes/0
        , ordMilliseconds/0
        , ordHours/0
        , ordDays/0
        , newtypeSeconds/0
        , newtypeMinutes/0
        , newtypeMilliseconds/0
        , newtypeHours/0
        , newtypeDays/0
        , monoidSeconds/0
        , monoidMinutes/0
        , monoidMilliseconds/0
        , monoidHours/0
        , monoidDays/0
        , fromDuration/0
        , fromDuration/1
        , negateDuration/0
        , negateDuration/2
        , eqSeconds/0
        , eqMinutes/0
        , eqMilliseconds/0
        , eqHours/0
        , eqDays/0
        , durationSeconds/0
        , durationMinutes/0
        , durationMilliseconds/0
        , durationHours/0
        , durationDays/0
        , convertDuration/0
        , convertDuration/3
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

'Seconds'() ->
  fun
    (X) ->
      'Seconds'(X)
  end.

'Seconds'(X) ->
  X.

'Minutes'() ->
  fun
    (X) ->
      'Minutes'(X)
  end.

'Minutes'(X) ->
  X.

'Milliseconds'() ->
  fun
    (X) ->
      'Milliseconds'(X)
  end.

'Milliseconds'(X) ->
  X.

'Hours'() ->
  fun
    (X) ->
      'Hours'(X)
  end.

'Hours'(X) ->
  X.

'Days'() ->
  fun
    (X) ->
      'Days'(X)
  end.

'Days'(X) ->
  X.

toDuration() ->
  fun
    (Dict) ->
      toDuration(Dict)
  end.

toDuration(#{ toDuration := Dict }) ->
  Dict.

showSeconds() ->
  #{ show =>
     fun
       (V) ->
         <<"(Seconds ", (data_show@foreign:showNumberImpl(V))/binary, ")">>
     end
   }.

showMinutes() ->
  #{ show =>
     fun
       (V) ->
         <<"(Minutes ", (data_show@foreign:showNumberImpl(V))/binary, ")">>
     end
   }.

showMilliseconds() ->
  #{ show =>
     fun
       (V) ->
         <<"(Milliseconds ", (data_show@foreign:showNumberImpl(V))/binary, ")">>
     end
   }.

showHours() ->
  #{ show =>
     fun
       (V) ->
         <<"(Hours ", (data_show@foreign:showNumberImpl(V))/binary, ")">>
     end
   }.

showDays() ->
  #{ show =>
     fun
       (V) ->
         <<"(Days ", (data_show@foreign:showNumberImpl(V))/binary, ")">>
     end
   }.

semigroupSeconds() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             V + V1
         end
     end
   }.

semigroupMinutes() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             V + V1
         end
     end
   }.

semigroupMilliseconds() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             V + V1
         end
     end
   }.

semigroupHours() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             V + V1
         end
     end
   }.

semigroupDays() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             V + V1
         end
     end
   }.

ordSeconds() ->
  data_ord@ps:ordNumber().

ordMinutes() ->
  data_ord@ps:ordNumber().

ordMilliseconds() ->
  data_ord@ps:ordNumber().

ordHours() ->
  data_ord@ps:ordNumber().

ordDays() ->
  data_ord@ps:ordNumber().

newtypeSeconds() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeMinutes() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeMilliseconds() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeHours() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeDays() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidSeconds() ->
  #{ mempty => 0.0
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupSeconds()
     end
   }.

monoidMinutes() ->
  #{ mempty => 0.0
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupMinutes()
     end
   }.

monoidMilliseconds() ->
  #{ mempty => 0.0
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupMilliseconds()
     end
   }.

monoidHours() ->
  #{ mempty => 0.0
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupHours()
     end
   }.

monoidDays() ->
  #{ mempty => 0.0
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupDays()
     end
   }.

fromDuration() ->
  fun
    (Dict) ->
      fromDuration(Dict)
  end.

fromDuration(#{ fromDuration := Dict }) ->
  Dict.

negateDuration() ->
  fun
    (DictDuration) ->
      fun
        (X) ->
          negateDuration(DictDuration, X)
      end
  end.

negateDuration( #{ fromDuration := DictDuration, toDuration := DictDuration@1 }
              , X
              ) ->
  DictDuration@1(- (DictDuration(X))).

eqSeconds() ->
  data_eq@ps:eqNumber().

eqMinutes() ->
  data_eq@ps:eqNumber().

eqMilliseconds() ->
  data_eq@ps:eqNumber().

eqHours() ->
  data_eq@ps:eqNumber().

eqDays() ->
  data_eq@ps:eqNumber().

durationSeconds() ->
  #{ fromDuration =>
     fun
       (V) ->
         V * 1000.0
     end
   , toDuration =>
     fun
       (V) ->
         V / 1000.0
     end
   }.

durationMinutes() ->
  #{ fromDuration =>
     fun
       (V) ->
         V * 60000.0
     end
   , toDuration =>
     fun
       (V) ->
         V / 60000.0
     end
   }.

durationMilliseconds() ->
  begin
    V = identity(),
    #{ fromDuration => V, toDuration => V }
  end.

durationHours() ->
  #{ fromDuration =>
     fun
       (V) ->
         V * 3600000.0
     end
   , toDuration =>
     fun
       (V) ->
         V / 3600000.0
     end
   }.

durationDays() ->
  #{ fromDuration =>
     fun
       (V) ->
         V * 86400000.0
     end
   , toDuration =>
     fun
       (V) ->
         V / 86400000.0
     end
   }.

convertDuration() ->
  fun
    (DictDuration) ->
      fun
        (DictDuration1) ->
          fun
            (X) ->
              convertDuration(DictDuration, DictDuration1, X)
          end
      end
  end.

convertDuration( #{ fromDuration := DictDuration }
               , #{ toDuration := DictDuration1 }
               , X
               ) ->
  DictDuration1(DictDuration(X)).

