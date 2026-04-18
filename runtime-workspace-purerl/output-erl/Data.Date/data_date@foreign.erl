-module(data_date@foreign).
-export([canonicalDateImpl/0, calcWeekday/0, calcDiff/0]).

rem1(X, R) -> case X rem R of
    0 -> R;
    N -> N
end.

createDate(Y, M, D) ->
    M1 = rem1(M,12),
    Y1 = Y + ((M - M1) div 12),
    YMDays = calendar:date_to_gregorian_days({Y1, M1, 1}),
    Days = YMDays + D - 1,
    calendar:gregorian_days_to_date(Days).

canonicalDateImpl() -> fun (Ctor, Y, M, D) ->
    {Y1, M1, D1} = createDate(Y,M,D),
    ((Ctor(Y1))(M1))(D1)
end.

calcWeekday() -> fun (Y, M, D) ->
    case calendar:day_of_the_week(createDate(Y,M,D)) of
        7 -> 0;
        N -> N
    end
end.

calcDiff() -> fun (Y1, M1, D1, Y2, M2, D2) ->
    Date1 = createDate(Y1, M1, D1),
    Date2 = createDate(Y2, M2, D2),
    S1 = calendar:datetime_to_gregorian_seconds({Date1, {0,0,0}}),
    S2 = calendar:datetime_to_gregorian_seconds({Date2, {0,0,0}}),
    1000 * (S1 - S2)
end.
