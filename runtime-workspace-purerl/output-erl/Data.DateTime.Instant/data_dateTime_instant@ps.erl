-module(data_dateTime_instant@ps).
-export([ unInstant/0
        , unInstant/1
        , toDateTime/0
        , showInstant/0
        , ordDateTime/0
        , instant/0
        , instant/1
        , fromDateTime/0
        , fromDateTime/1
        , fromDate/0
        , fromDate/1
        , eqDateTime/0
        , boundedInstant/0
        , fromDateTimeImpl/0
        , toDateTimeImpl/0
        , toDateTime/1
        ]).
-compile(no_auto_import).
unInstant() ->
  fun
    (V) ->
      unInstant(V)
  end.

unInstant(V) ->
  V.

toDateTime() ->
  (toDateTimeImpl())
  (fun
    (Y) ->
      fun
        (Mo) ->
          fun
            (D) ->
              fun
                (H) ->
                  fun
                    (Mi) ->
                      fun
                        (S) ->
                          fun
                            (Ms) ->
                              { dateTime
                              , data_date@ps:canonicalDate(
                                  Y,
                                  if
                                    Mo =:= 1 ->
                                      {january};
                                    Mo =:= 2 ->
                                      {february};
                                    Mo =:= 3 ->
                                      {march};
                                    Mo =:= 4 ->
                                      {april};
                                    Mo =:= 5 ->
                                      {may};
                                    Mo =:= 6 ->
                                      {june};
                                    Mo =:= 7 ->
                                      {july};
                                    Mo =:= 8 ->
                                      {august};
                                    Mo =:= 9 ->
                                      {september};
                                    Mo =:= 10 ->
                                      {october};
                                    Mo =:= 11 ->
                                      {november};
                                    Mo =:= 12 ->
                                      {december};
                                    true ->
                                      erlang:error({ fail
                                                   , <<"Failed pattern match">>
                                                   })
                                  end,
                                  D
                                )
                              , {time, H, Mi, S, Ms}
                              }
                          end
                      end
                  end
              end
          end
      end
  end).

showInstant() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(Instant (Milliseconds ",
           (data_show@foreign:showNumberImpl(V))/binary,
           "))"
         >>
     end
   }.

ordDateTime() ->
  data_ord@ps:ordNumber().

instant() ->
  fun
    (V) ->
      instant(V)
  end.

instant(V) ->
  if
    (V >= -62167219200000.0) andalso (V =< 8639977881599999.0) ->
      {just, V};
    true ->
      {nothing}
  end.

fromDateTime() ->
  fun
    (V) ->
      fromDateTime(V)
  end.

fromDateTime(V) ->
  (data_dateTime_instant@foreign:fromDateTimeImpl())
  (
    erlang:element(2, erlang:element(2, V)),
    case erlang:element(3, erlang:element(2, V)) of
      {january} ->
        1;
      {february} ->
        2;
      {march} ->
        3;
      {april} ->
        4;
      {may} ->
        5;
      {june} ->
        6;
      {july} ->
        7;
      {august} ->
        8;
      {september} ->
        9;
      {october} ->
        10;
      {november} ->
        11;
      {december} ->
        12;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end,
    erlang:element(4, erlang:element(2, V)),
    erlang:element(2, erlang:element(3, V)),
    erlang:element(3, erlang:element(3, V)),
    erlang:element(4, erlang:element(3, V)),
    erlang:element(5, erlang:element(3, V))
  ).

fromDate() ->
  fun
    (D) ->
      fromDate(D)
  end.

fromDate(D) ->
  (data_dateTime_instant@foreign:fromDateTimeImpl())
  (
    erlang:element(2, D),
    case erlang:element(3, D) of
      {january} ->
        1;
      {february} ->
        2;
      {march} ->
        3;
      {april} ->
        4;
      {may} ->
        5;
      {june} ->
        6;
      {july} ->
        7;
      {august} ->
        8;
      {september} ->
        9;
      {october} ->
        10;
      {november} ->
        11;
      {december} ->
        12;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end,
    erlang:element(4, D),
    0,
    0,
    0,
    0
  ).

eqDateTime() ->
  data_eq@ps:eqNumber().

boundedInstant() ->
  #{ bottom => -62167219200000.0
   , top => 8639977881599999.0
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordNumber()
     end
   }.

fromDateTimeImpl() ->
  data_dateTime_instant@foreign:fromDateTimeImpl().

toDateTimeImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_dateTime_instant@foreign:toDateTimeImpl(V, V@1)
      end
  end.

toDateTime(V) ->
  data_dateTime_instant@foreign:toDateTimeImpl(
    fun
      (Y) ->
        fun
          (Mo) ->
            fun
              (D) ->
                fun
                  (H) ->
                    fun
                      (Mi) ->
                        fun
                          (S) ->
                            fun
                              (Ms) ->
                                { dateTime
                                , data_date@ps:canonicalDate(
                                    Y,
                                    if
                                      Mo =:= 1 ->
                                        {january};
                                      Mo =:= 2 ->
                                        {february};
                                      Mo =:= 3 ->
                                        {march};
                                      Mo =:= 4 ->
                                        {april};
                                      Mo =:= 5 ->
                                        {may};
                                      Mo =:= 6 ->
                                        {june};
                                      Mo =:= 7 ->
                                        {july};
                                      Mo =:= 8 ->
                                        {august};
                                      Mo =:= 9 ->
                                        {september};
                                      Mo =:= 10 ->
                                        {october};
                                      Mo =:= 11 ->
                                        {november};
                                      Mo =:= 12 ->
                                        {december};
                                      true ->
                                        erlang:error({ fail
                                                     , <<
                                                         "Failed pattern match"
                                                       >>
                                                     })
                                    end,
                                    D
                                  )
                                , {time, H, Mi, S, Ms}
                                }
                            end
                        end
                    end
                end
            end
        end
    end,
    V
  ).

