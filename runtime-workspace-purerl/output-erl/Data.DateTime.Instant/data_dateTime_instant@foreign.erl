-module(data_dateTime_instant@foreign).
-export([fromDateTimeImpl/0, toDateTimeImpl/2]).

fromDateTimeImpl() -> fun (Y,Mo,D,H,M,S,MS) ->
    Secs = calendar:datetime_to_gregorian_seconds({{Y,Mo,D},{H,M,S}}),
    Epoch = calendar:datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}}),
    float( (Secs - Epoch) * 1000 + MS )
end.

toDateTimeImpl(Ctor,Instant) ->
    Epoch = calendar:datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}}),
    Secs = Epoch + round(Instant) div 1000,
    {{Y,Mo,D},{H,M,S}} = calendar:gregorian_seconds_to_datetime(Secs),
    Ms = round(Instant) rem 1000,
    ((((((Ctor(Y))(Mo))(D))(H))(M))(S))(Ms).
