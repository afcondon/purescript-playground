-module(data_time@ps).
-export([ 'Time'/0
        , showTime/0
        , setSecond/0
        , setSecond/2
        , setMinute/0
        , setMinute/2
        , setMillisecond/0
        , setMillisecond/2
        , setHour/0
        , setHour/2
        , second/0
        , second/1
        , minute/0
        , minute/1
        , millisecond/0
        , millisecond/1
        , millisToTime/0
        , millisToTime/1
        , hour/0
        , hour/1
        , timeToMillis/0
        , timeToMillis/1
        , eqTime/0
        , ordTime/0
        , diff/0
        , diff/3
        , boundedTime/0
        , maxTime/0
        , minTime/0
        , adjust/0
        , adjust/3
        ]).
-compile(no_auto_import).
'Time'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  {time, Value0, Value1, Value2, Value3}
              end
          end
      end
  end.

showTime() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(Time (Hour ",
           (data_show@foreign:showIntImpl(erlang:element(2, V)))/binary,
           ") (Minute ",
           (data_show@foreign:showIntImpl(erlang:element(3, V)))/binary,
           ") (Second ",
           (data_show@foreign:showIntImpl(erlang:element(4, V)))/binary,
           ") (Millisecond ",
           (data_show@foreign:showIntImpl(erlang:element(5, V)))/binary,
           "))"
         >>
     end
   }.

setSecond() ->
  fun
    (S) ->
      fun
        (V) ->
          setSecond(S, V)
      end
  end.

setSecond(S, V) ->
  {time, erlang:element(2, V), erlang:element(3, V), S, erlang:element(5, V)}.

setMinute() ->
  fun
    (M) ->
      fun
        (V) ->
          setMinute(M, V)
      end
  end.

setMinute(M, V) ->
  {time, erlang:element(2, V), M, erlang:element(4, V), erlang:element(5, V)}.

setMillisecond() ->
  fun
    (Ms) ->
      fun
        (V) ->
          setMillisecond(Ms, V)
      end
  end.

setMillisecond(Ms, V) ->
  {time, erlang:element(2, V), erlang:element(3, V), erlang:element(4, V), Ms}.

setHour() ->
  fun
    (H) ->
      fun
        (V) ->
          setHour(H, V)
      end
  end.

setHour(H, V) ->
  {time, H, erlang:element(3, V), erlang:element(4, V), erlang:element(5, V)}.

second() ->
  fun
    (V) ->
      second(V)
  end.

second(V) ->
  erlang:element(4, V).

minute() ->
  fun
    (V) ->
      minute(V)
  end.

minute(V) ->
  erlang:element(3, V).

millisecond() ->
  fun
    (V) ->
      millisecond(V)
  end.

millisecond(V) ->
  erlang:element(5, V).

millisToTime() ->
  fun
    (V) ->
      millisToTime(V)
  end.

millisToTime(V) ->
  begin
    Hours = math@foreign:floor(V / 3600000.0),
    Minutes = math@foreign:floor((V - (Hours * 3600000.0)) / 60000.0),
    Seconds =
      math@foreign:floor((V - ((Hours * 3600000.0) + (Minutes * 60000.0)))
        / 1000.0),
    V@1 = data_int@ps:floor(Hours),
    if
      (V@1 >= 0) andalso (V@1 =< 23) ->
        begin
          V@2 = data_int@ps:floor(Minutes),
          if
            (V@2 >= 0) andalso (V@2 =< 59) ->
              begin
                V@3 = data_int@ps:floor(Seconds),
                if
                  (V@3 >= 0) andalso (V@3 =< 59) ->
                    begin
                      V@4 =
                        data_int@ps:floor(V
                          - (((Hours * 3600000.0) + (Minutes * 60000.0))
                            + (Seconds * 1000.0))),
                      if
                        (V@4 >= 0) andalso (V@4 =< 999) ->
                          {time, V@1, V@2, V@3, V@4};
                        true ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end
                    end;
                  true ->
                    begin
                      V@5 =
                        data_int@ps:floor(V
                          - (((Hours * 3600000.0) + (Minutes * 60000.0))
                            + (Seconds * 1000.0))),
                      if
                        (V@5 >= 0) andalso (V@5 =< 999) ->
                          erlang:error({fail, <<"Failed pattern match">>});
                        true ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end
                    end
                end
              end;
            true ->
              begin
                V@6 = data_int@ps:floor(Seconds),
                if
                  (V@6 >= 0) andalso (V@6 =< 59) ->
                    begin
                      V@7 =
                        data_int@ps:floor(V
                          - (((Hours * 3600000.0) + (Minutes * 60000.0))
                            + (Seconds * 1000.0))),
                      if
                        (V@7 >= 0) andalso (V@7 =< 999) ->
                          erlang:error({fail, <<"Failed pattern match">>});
                        true ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end
                    end;
                  true ->
                    begin
                      V@8 =
                        data_int@ps:floor(V
                          - (((Hours * 3600000.0) + (Minutes * 60000.0))
                            + (Seconds * 1000.0))),
                      if
                        (V@8 >= 0) andalso (V@8 =< 999) ->
                          erlang:error({fail, <<"Failed pattern match">>});
                        true ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end
                    end
                end
              end
          end
        end;
      true ->
        begin
          V@9 = data_int@ps:floor(Minutes),
          if
            (V@9 >= 0) andalso (V@9 =< 59) ->
              begin
                V@10 = data_int@ps:floor(Seconds),
                if
                  (V@10 >= 0) andalso (V@10 =< 59) ->
                    begin
                      V@11 =
                        data_int@ps:floor(V
                          - (((Hours * 3600000.0) + (Minutes * 60000.0))
                            + (Seconds * 1000.0))),
                      if
                        (V@11 >= 0) andalso (V@11 =< 999) ->
                          erlang:error({fail, <<"Failed pattern match">>});
                        true ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end
                    end;
                  true ->
                    begin
                      V@12 =
                        data_int@ps:floor(V
                          - (((Hours * 3600000.0) + (Minutes * 60000.0))
                            + (Seconds * 1000.0))),
                      if
                        (V@12 >= 0) andalso (V@12 =< 999) ->
                          erlang:error({fail, <<"Failed pattern match">>});
                        true ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end
                    end
                end
              end;
            true ->
              begin
                V@13 = data_int@ps:floor(Seconds),
                if
                  (V@13 >= 0) andalso (V@13 =< 59) ->
                    begin
                      V@14 =
                        data_int@ps:floor(V
                          - (((Hours * 3600000.0) + (Minutes * 60000.0))
                            + (Seconds * 1000.0))),
                      if
                        (V@14 >= 0) andalso (V@14 =< 999) ->
                          erlang:error({fail, <<"Failed pattern match">>});
                        true ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end
                    end;
                  true ->
                    begin
                      V@15 =
                        data_int@ps:floor(V
                          - (((Hours * 3600000.0) + (Minutes * 60000.0))
                            + (Seconds * 1000.0))),
                      if
                        (V@15 >= 0) andalso (V@15 =< 999) ->
                          erlang:error({fail, <<"Failed pattern match">>});
                        true ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end
                    end
                end
              end
          end
        end
    end
  end.

hour() ->
  fun
    (V) ->
      hour(V)
  end.

hour(V) ->
  erlang:element(2, V).

timeToMillis() ->
  fun
    (T) ->
      timeToMillis(T)
  end.

timeToMillis(T) ->
  (((3600000.0 * (data_int@foreign:toNumber(erlang:element(2, T))))
    + (60000.0 * (data_int@foreign:toNumber(erlang:element(3, T)))))
    + (1000.0 * (data_int@foreign:toNumber(erlang:element(4, T)))))
    + (data_int@foreign:toNumber(erlang:element(5, T))).

eqTime() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             ((((erlang:element(2, X)) =:= (erlang:element(2, Y)))
               andalso ((erlang:element(3, X)) =:= (erlang:element(3, Y))))
               andalso ((erlang:element(4, X)) =:= (erlang:element(4, Y))))
               andalso ((erlang:element(5, X)) =:= (erlang:element(5, Y)))
         end
     end
   }.

ordTime() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             begin
               V =
                 ((erlang:map_get(compare, data_ord@ps:ordInt()))
                  (erlang:element(2, X)))
                 (erlang:element(2, Y)),
               case V of
                 {lT} ->
                   {lT};
                 {gT} ->
                   {gT};
                 _ ->
                   begin
                     V1 =
                       ((erlang:map_get(compare, data_ord@ps:ordInt()))
                        (erlang:element(3, X)))
                       (erlang:element(3, Y)),
                     case V1 of
                       {lT} ->
                         {lT};
                       {gT} ->
                         {gT};
                       _ ->
                         begin
                           V2 =
                             ((erlang:map_get(compare, data_ord@ps:ordInt()))
                              (erlang:element(4, X)))
                             (erlang:element(4, Y)),
                           case V2 of
                             {lT} ->
                               {lT};
                             {gT} ->
                               {gT};
                             _ ->
                               ((erlang:map_get(compare, data_ord@ps:ordInt()))
                                (erlang:element(5, X)))
                               (erlang:element(5, Y))
                           end
                         end
                     end
                   end
               end
             end
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqTime()
     end
   }.

diff() ->
  fun
    (DictDuration) ->
      fun
        (T1) ->
          fun
            (T2) ->
              diff(DictDuration, T1, T2)
          end
      end
  end.

diff(#{ toDuration := DictDuration }, T1, T2) ->
  DictDuration((timeToMillis(T1)) + (- (timeToMillis(T2)))).

boundedTime() ->
  #{ bottom => {time, 0, 0, 0, 0}
   , top => {time, 23, 59, 59, 999}
   , 'Ord0' =>
     fun
       (_) ->
         ordTime()
     end
   }.

maxTime() ->
  timeToMillis({time, 23, 59, 59, 999}).

minTime() ->
  timeToMillis({time, 0, 0, 0, 0}).

adjust() ->
  fun
    (DictDuration) ->
      fun
        (D) ->
          fun
            (T) ->
              adjust(DictDuration, D, T)
          end
      end
  end.

adjust(#{ fromDuration := DictDuration }, D, T) ->
  begin
    D_ = DictDuration(D),
    WholeDays = math@foreign:floor(D_ / 86400000.0),
    MsAdjusted = ((timeToMillis(T)) + D_) + (- (WholeDays * 86400000.0)),
    Wrap =
      case MsAdjusted > (maxTime()) of
        true ->
          1.0;
        _ ->
          case MsAdjusted < (minTime()) of
            true ->
              -1.0;
            _ ->
              0.0
          end
      end,
    { tuple
    , WholeDays + Wrap
    , millisToTime(MsAdjusted + (86400000.0 * (- Wrap)))
    }
  end.

