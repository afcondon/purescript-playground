-module(data_dateTime@ps).
-export([ 'DateTime'/0
        , toRecord/0
        , toRecord/1
        , time/0
        , time/1
        , showDateTime/0
        , modifyTimeF/0
        , modifyTimeF/3
        , modifyTime/0
        , modifyTime/2
        , modifyDateF/0
        , modifyDateF/3
        , modifyDate/0
        , modifyDate/2
        , eqDateTime/0
        , ordDateTime/0
        , diff/0
        , diff/3
        , date/0
        , date/1
        , boundedDateTime/0
        , adjust/0
        , adjust/3
        , calcDiff/0
        , adjustImpl/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'DateTime'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {dateTime, Value0, Value1}
      end
  end.

toRecord() ->
  fun
    (V) ->
      toRecord(V)
  end.

toRecord(V) ->
  #{ year => erlang:element(2, erlang:element(2, V))
   , month =>
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
     end
   , day => erlang:element(4, erlang:element(2, V))
   , hour => erlang:element(2, erlang:element(3, V))
   , minute => erlang:element(3, erlang:element(3, V))
   , second => erlang:element(4, erlang:element(3, V))
   , millisecond => erlang:element(5, erlang:element(3, V))
   }.

time() ->
  fun
    (V) ->
      time(V)
  end.

time(V) ->
  erlang:element(3, V).

showDateTime() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(DateTime ",
           ((erlang:map_get(show, data_date@ps:showDate()))
            (erlang:element(2, V)))/binary,
           " ",
           ((erlang:map_get(show, data_time@ps:showTime()))
            (erlang:element(3, V)))/binary,
           ")"
         >>
     end
   }.

modifyTimeF() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (V) ->
              modifyTimeF(DictFunctor, F, V)
          end
      end
  end.

modifyTimeF(#{ map := DictFunctor }, F, V) ->
  (DictFunctor(('DateTime'())(erlang:element(2, V))))(F(erlang:element(3, V))).

modifyTime() ->
  fun
    (F) ->
      fun
        (V) ->
          modifyTime(F, V)
      end
  end.

modifyTime(F, V) ->
  {dateTime, erlang:element(2, V), F(erlang:element(3, V))}.

modifyDateF() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (V) ->
              modifyDateF(DictFunctor, F, V)
          end
      end
  end.

modifyDateF(#{ map := DictFunctor }, F, V) ->
  begin
    V@1 = erlang:element(3, V),
    (DictFunctor(fun
       (A) ->
         {dateTime, A, V@1}
     end))
    (F(erlang:element(2, V)))
  end.

modifyDate() ->
  fun
    (F) ->
      fun
        (V) ->
          modifyDate(F, V)
      end
  end.

modifyDate(F, V) ->
  {dateTime, F(erlang:element(2, V)), erlang:element(3, V)}.

eqDateTime() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             (((erlang:map_get(eq, data_date@ps:eqDate()))
               (erlang:element(2, X)))
              (erlang:element(2, Y)))
               andalso (((((erlang:element(2, erlang:element(3, X)))
                 =:= (erlang:element(2, erlang:element(3, Y))))
                 andalso ((erlang:element(3, erlang:element(3, X)))
                   =:= (erlang:element(3, erlang:element(3, Y)))))
                 andalso ((erlang:element(4, erlang:element(3, X)))
                   =:= (erlang:element(4, erlang:element(3, Y)))))
                 andalso ((erlang:element(5, erlang:element(3, X)))
                   =:= (erlang:element(5, erlang:element(3, Y)))))
         end
     end
   }.

ordDateTime() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             begin
               V =
                 ((erlang:map_get(compare, data_date@ps:ordDate()))
                  (erlang:element(2, X)))
                 (erlang:element(2, Y)),
               case V of
                 {lT} ->
                   {lT};
                 {gT} ->
                   {gT};
                 _ ->
                   ((erlang:map_get(compare, data_time@ps:ordTime()))
                    (erlang:element(3, X)))
                   (erlang:element(3, Y))
               end
             end
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqDateTime()
     end
   }.

diff() ->
  fun
    (DictDuration) ->
      fun
        (Dt1) ->
          fun
            (Dt2) ->
              diff(DictDuration, Dt1, Dt2)
          end
      end
  end.

diff(#{ toDuration := DictDuration }, Dt1, Dt2) ->
  DictDuration(data_dateTime@foreign:calcDiff(toRecord(Dt1), toRecord(Dt2))).

date() ->
  fun
    (V) ->
      date(V)
  end.

date(V) ->
  erlang:element(2, V).

boundedDateTime() ->
  #{ bottom => {dateTime, {date, 0, {january}, 1}, {time, 0, 0, 0, 0}}
   , top => {dateTime, {date, 275759, {december}, 31}, {time, 23, 59, 59, 999}}
   , 'Ord0' =>
     fun
       (_) ->
         ordDateTime()
     end
   }.

adjust() ->
  fun
    (DictDuration) ->
      fun
        (D) ->
          fun
            (Dt) ->
              adjust(DictDuration, D, Dt)
          end
      end
  end.

adjust(#{ fromDuration := DictDuration }, D, Dt) ->
  begin
    V =
      data_dateTime@foreign:adjustImpl(
        data_maybe@ps:'Just'(),
        {nothing},
        DictDuration(D),
        toRecord(Dt)
      ),
    case V of
      {just, _} ->
        begin
          V@2 =
            if
              ((erlang:map_get(year, erlang:element(2, V))) >= 0)
                andalso ((erlang:map_get(year, erlang:element(2, V))) =< 275759) ->
                begin
                  {just, #{ year := V@1 }} = V,
                  {just, V@1}
                end;
              true ->
                {nothing}
            end,
          V@4 =
            case V@2 of
              {just, V@3} ->
                {just, (data_date@ps:exactDate())(V@3)};
              _ ->
                {nothing}
            end,
          V@5 =
            if
              (erlang:map_get(month, erlang:element(2, V))) =:= 1 ->
                {just, {january}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 2 ->
                {just, {february}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 3 ->
                {just, {march}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 4 ->
                {just, {april}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 5 ->
                {just, {may}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 6 ->
                {just, {june}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 7 ->
                {just, {july}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 8 ->
                {just, {august}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 9 ->
                {just, {september}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 10 ->
                {just, {october}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 11 ->
                {just, {november}};
              (erlang:map_get(month, erlang:element(2, V))) =:= 12 ->
                {just, {december}};
              true ->
                {nothing}
            end,
          V@9 =
            case V@4 of
              {just, _} ->
                case V@5 of
                  {just, _} ->
                    if
                      ((erlang:map_get(day, erlang:element(2, V))) >= 1)
                        andalso ((erlang:map_get(day, erlang:element(2, V)))
                          =< 31) ->
                        begin
                          {just, V@6} = V@5,
                          {just, V@7} = V@4,
                          {just, #{ day := V@8 }} = V,
                          {just, (V@7(V@6))(V@8)}
                        end;
                      true ->
                        {nothing}
                    end;
                  _ ->
                    if
                      ((erlang:map_get(day, erlang:element(2, V))) >= 1)
                        andalso ((erlang:map_get(day, erlang:element(2, V)))
                          =< 31) ->
                        {nothing};
                      true ->
                        {nothing}
                    end
                end;
              {nothing} ->
                if
                  ((erlang:map_get(day, erlang:element(2, V))) >= 1)
                    andalso ((erlang:map_get(day, erlang:element(2, V))) =< 31) ->
                    {nothing};
                  true ->
                    {nothing}
                end;
              _ ->
                if
                  ((erlang:map_get(day, erlang:element(2, V))) >= 1)
                    andalso ((erlang:map_get(day, erlang:element(2, V))) =< 31) ->
                    erlang:error({fail, <<"Failed pattern match">>});
                  true ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
            end,
          V@11 =
            case V@9 of
              {just, V@10} ->
                V@10;
              {nothing} ->
                {nothing};
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end,
          V@13 =
            case V@11 of
              {just, V@12} ->
                {just, ('DateTime'())(V@12)};
              _ ->
                {nothing}
            end,
          if
            ((erlang:map_get(hour, erlang:element(2, V))) >= 0)
              andalso ((erlang:map_get(hour, erlang:element(2, V))) =< 23) ->
              if
                ((erlang:map_get(minute, erlang:element(2, V))) >= 0)
                  andalso ((erlang:map_get(minute, erlang:element(2, V))) =< 59) ->
                  if
                    ((erlang:map_get(second, erlang:element(2, V))) >= 0)
                      andalso ((erlang:map_get(second, erlang:element(2, V)))
                        =< 59) ->
                      if
                        ((erlang:map_get(millisecond, erlang:element(2, V)))
                          >= 0)
                          andalso ((erlang:map_get(
                                      millisecond,
                                      erlang:element(2, V)
                                    ))
                            =< 999) ->
                          case V@13 of
                            {just, V@14} ->
                              begin
                                { just
                                , #{ hour := V@15
                                   , millisecond := V@16
                                   , minute := V@17
                                   , second := V@18
                                   }
                                } =
                                  V,
                                {just, V@14({time, V@15, V@17, V@18, V@16})}
                              end;
                            {nothing} ->
                              {nothing};
                            _ ->
                              erlang:error({fail, <<"Failed pattern match">>})
                          end;
                        ?IS_KNOWN_TAG(just, 1, V@13) ->
                          {nothing};
                        ?IS_KNOWN_TAG(nothing, 0, V@13) ->
                          {nothing};
                        true ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end;
                    ((erlang:map_get(millisecond, erlang:element(2, V))) >= 0)
                      andalso ((erlang:map_get(
                                  millisecond,
                                  erlang:element(2, V)
                                ))
                        =< 999) ->
                      case V@13 of
                        {just, _} ->
                          {nothing};
                        {nothing} ->
                          {nothing};
                        _ ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end;
                    ?IS_KNOWN_TAG(just, 1, V@13) ->
                      {nothing};
                    ?IS_KNOWN_TAG(nothing, 0, V@13) ->
                      {nothing};
                    true ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end;
                ((erlang:map_get(second, erlang:element(2, V))) >= 0)
                  andalso ((erlang:map_get(second, erlang:element(2, V))) =< 59) ->
                  if
                    ((erlang:map_get(millisecond, erlang:element(2, V))) >= 0)
                      andalso ((erlang:map_get(
                                  millisecond,
                                  erlang:element(2, V)
                                ))
                        =< 999) ->
                      case V@13 of
                        {just, _} ->
                          {nothing};
                        {nothing} ->
                          {nothing};
                        _ ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end;
                    ?IS_KNOWN_TAG(just, 1, V@13) ->
                      {nothing};
                    ?IS_KNOWN_TAG(nothing, 0, V@13) ->
                      {nothing};
                    true ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end;
                ((erlang:map_get(millisecond, erlang:element(2, V))) >= 0)
                  andalso ((erlang:map_get(millisecond, erlang:element(2, V)))
                    =< 999) ->
                  case V@13 of
                    {just, _} ->
                      {nothing};
                    {nothing} ->
                      {nothing};
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end;
                ?IS_KNOWN_TAG(just, 1, V@13) ->
                  {nothing};
                ?IS_KNOWN_TAG(nothing, 0, V@13) ->
                  {nothing};
                true ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            ((erlang:map_get(millisecond, erlang:element(2, V))) >= 0)
              andalso ((erlang:map_get(millisecond, erlang:element(2, V)))
                =< 999) ->
              case V@13 of
                {just, _} ->
                  {nothing};
                {nothing} ->
                  {nothing};
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            ?IS_KNOWN_TAG(just, 1, V@13) ->
              {nothing};
            ?IS_KNOWN_TAG(nothing, 0, V@13) ->
              {nothing};
            true ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
        end;
      {nothing} ->
        {nothing};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

calcDiff() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_dateTime@foreign:calcDiff(V, V@1)
      end
  end.

adjustImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_dateTime@foreign:adjustImpl(V, V@1, V@2, V@3)
              end
          end
      end
  end.

