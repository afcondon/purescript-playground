-module(data_dateTime@foreign).
-export([calcDiff/2, adjustImpl/4]).

recordToDateTime(#{year := Y
     , month := M
     , day := D
     , hour := H
     , minute := MI
     , second := S
     , millisecond := _MS %% Pewp
                  }) ->
  { { Y, M, D }, { H, MI, S } }.

dateTimeToRecord({ { Y, M, D }, { H, MI, S } }) ->
  #{year => Y
  , month => M
  , day => D
  , hour => H
  , minute => MI
  , second => S
  , millisecond => 0 }.

calcDiff(D1 = #{  millisecond := MS1 }, D2 = #{ millisecond := MS2 }) ->

  DateTime1 = recordToDateTime(D1),
  DateTime2 = recordToDateTime(D2),

  float((MS1 - MS2) + (calendar:datetime_to_gregorian_seconds(DateTime1) - calendar:datetime_to_gregorian_seconds(DateTime2)) * 1000).

adjustImpl(Just, _Nothing, Offset, Date = #{ millisecond := Ms }) ->
  DateTime = recordToDateTime(Date),
  Seconds = calendar:datetime_to_gregorian_seconds(DateTime),
  Milliseconds = (Seconds * 1000) + Ms,
  NewMilliseconds = trunc(float(Milliseconds) + Offset),
  NewSeconds = NewMilliseconds div 1000,
  Leftover = NewMilliseconds rem 1000,

  Result = calendar:gregorian_seconds_to_datetime(NewSeconds),
  Just((dateTimeToRecord(Result))#{  millisecond => Leftover }).
