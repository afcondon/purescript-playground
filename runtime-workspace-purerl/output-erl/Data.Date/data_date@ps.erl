-module(data_date@ps).
-export([ 'Date'/0
        , year/0
        , year/1
        , weekday/0
        , weekday/1
        , showDate/0
        , month/0
        , month/1
        , isLeapYear/0
        , isLeapYear/1
        , lastDayOfMonth/0
        , lastDayOfMonth/2
        , eqDate/0
        , ordDate/0
        , enumDate/0
        , diff/0
        , diff/3
        , day/0
        , day/1
        , canonicalDate/0
        , canonicalDate/3
        , exactDate/0
        , exactDate/3
        , boundedDate/0
        , adjust/0
        , adjust/2
        , canonicalDateImpl/0
        , calcWeekday/0
        , calcDiff/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'Date'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              {date, Value0, Value1, Value2}
          end
      end
  end.

year() ->
  fun
    (V) ->
      year(V)
  end.

year(V) ->
  erlang:element(2, V).

weekday() ->
  fun
    (V) ->
      weekday(V)
  end.

weekday(V) ->
  begin
    N =
      (data_date@foreign:calcWeekday())
      (
        erlang:element(2, V),
        case erlang:element(3, V) of
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
        erlang:element(4, V)
      ),
    if
      N =:= 0 ->
        {sunday};
      N =:= 1 ->
        {monday};
      N =:= 2 ->
        {tuesday};
      N =:= 3 ->
        {wednesday};
      N =:= 4 ->
        {thursday};
      N =:= 5 ->
        {friday};
      N =:= 6 ->
        {saturday};
      N =:= 7 ->
        {sunday};
      true ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

showDate() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(Date (Year ",
           (data_show@foreign:showIntImpl(erlang:element(2, V)))/binary,
           ") ",
           case erlang:element(3, V) of
             {january} ->
               <<"January">>;
             {february} ->
               <<"February">>;
             {march} ->
               <<"March">>;
             {april} ->
               <<"April">>;
             {may} ->
               <<"May">>;
             {june} ->
               <<"June">>;
             {july} ->
               <<"July">>;
             {august} ->
               <<"August">>;
             {september} ->
               <<"September">>;
             {october} ->
               <<"October">>;
             {november} ->
               <<"November">>;
             {december} ->
               <<"December">>;
             _ ->
               erlang:error({fail, <<"Failed pattern match">>})
           end/binary,
           " (Day ",
           (data_show@foreign:showIntImpl(erlang:element(4, V)))/binary,
           "))"
         >>
     end
   }.

month() ->
  fun
    (V) ->
      month(V)
  end.

month(V) ->
  erlang:element(3, V).

isLeapYear() ->
  fun
    (Y) ->
      isLeapYear(Y)
  end.

isLeapYear(Y) ->
  ((data_euclideanRing@foreign:intMod(Y, 4)) =:= 0)
    andalso (((data_euclideanRing@foreign:intMod(Y, 400)) =:= 0)
      orelse ((data_euclideanRing@foreign:intMod(Y, 100)) =/= 0)).

lastDayOfMonth() ->
  fun
    (Y) ->
      fun
        (M) ->
          lastDayOfMonth(Y, M)
      end
  end.

lastDayOfMonth(Y, M) ->
  case M of
    {january} ->
      31;
    {february} ->
      case isLeapYear(Y) of
        true ->
          29;
        _ ->
          28
      end;
    {march} ->
      31;
    {april} ->
      30;
    {may} ->
      31;
    {june} ->
      30;
    {july} ->
      31;
    {august} ->
      31;
    {september} ->
      30;
    {october} ->
      31;
    {november} ->
      30;
    {december} ->
      31;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

eqDate() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             (((erlang:element(2, X)) =:= (erlang:element(2, Y)))
               andalso case erlang:element(3, X) of
                 {january} ->
                   ?IS_KNOWN_TAG(january, 0, erlang:element(3, Y));
                 {february} ->
                   ?IS_KNOWN_TAG(february, 0, erlang:element(3, Y));
                 {march} ->
                   ?IS_KNOWN_TAG(march, 0, erlang:element(3, Y));
                 {april} ->
                   ?IS_KNOWN_TAG(april, 0, erlang:element(3, Y));
                 {may} ->
                   ?IS_KNOWN_TAG(may, 0, erlang:element(3, Y));
                 {june} ->
                   ?IS_KNOWN_TAG(june, 0, erlang:element(3, Y));
                 {july} ->
                   ?IS_KNOWN_TAG(july, 0, erlang:element(3, Y));
                 {august} ->
                   ?IS_KNOWN_TAG(august, 0, erlang:element(3, Y));
                 {september} ->
                   ?IS_KNOWN_TAG(september, 0, erlang:element(3, Y));
                 {october} ->
                   ?IS_KNOWN_TAG(october, 0, erlang:element(3, Y));
                 {november} ->
                   ?IS_KNOWN_TAG(november, 0, erlang:element(3, Y));
                 _ ->
                   ?IS_KNOWN_TAG(december, 0, erlang:element(3, X))
                     andalso ?IS_KNOWN_TAG(december, 0, erlang:element(3, Y))
               end)
               andalso ((erlang:element(4, X)) =:= (erlang:element(4, Y)))
         end
     end
   }.

ordDate() ->
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
                       ((erlang:map_get(
                           compare,
                           data_date_component@ps:ordMonth()
                         ))
                        (erlang:element(3, X)))
                       (erlang:element(3, Y)),
                     case V1 of
                       {lT} ->
                         {lT};
                       {gT} ->
                         {gT};
                       _ ->
                         ((erlang:map_get(compare, data_ord@ps:ordInt()))
                          (erlang:element(4, X)))
                         (erlang:element(4, Y))
                     end
                   end
               end
             end
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqDate()
     end
   }.

enumDate() ->
  #{ succ =>
     fun
       (V) ->
         begin
           Sm =
             (erlang:map_get(succ, data_date_component@ps:enumMonth()))
             (erlang:element(3, V)),
           V@1 = (erlang:element(4, V)) + 1,
           V1 =
             if
               (V@1 >= 1) andalso (V@1 =< 31) ->
                 {just, V@1};
               true ->
                 {nothing}
             end,
           V@2 = lastDayOfMonth(erlang:element(2, V), erlang:element(3, V)),
           case case V1 of
               {nothing} ->
                 false;
               {just, V1@1} ->
                 V1@1 > V@2;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end of
             true ->
               case case Sm of
                   {nothing} ->
                     true;
                   {just, _} ->
                     false;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end of
                 true ->
                   begin
                     V@3 = (erlang:element(2, V)) + 1,
                     if
                       (V@3 >= 0) andalso (V@3 =< 275759) ->
                         { just
                         , { date
                           , V@3
                           , case Sm of
                               {nothing} ->
                                 {january};
                               {just, Sm@1} ->
                                 Sm@1;
                               _ ->
                                 erlang:error({fail, <<"Failed pattern match">>})
                             end
                           , 1
                           }
                         };
                       true ->
                         {nothing}
                     end
                   end;
                 _ ->
                   { just
                   , { date
                     , erlang:element(2, V)
                     , case Sm of
                         {nothing} ->
                           {january};
                         {just, Sm@2} ->
                           Sm@2;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     , 1
                     }
                   }
               end;
             _ ->
               case case V1 of
                   {nothing} ->
                     true;
                   {just, _} ->
                     false;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
                   andalso case Sm of
                     {nothing} ->
                       true;
                     {just, _} ->
                       false;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end of
                 true ->
                   begin
                     V@4 = (erlang:element(2, V)) + 1,
                     if
                       (V@4 >= 0) andalso (V@4 =< 275759) ->
                         begin
                           V@5 =
                             (('Date'())(V@4))
                             (case case V1 of
                                 {nothing} ->
                                   true;
                                 {just, _} ->
                                   false;
                                 _ ->
                                   erlang:error({ fail
                                                , <<"Failed pattern match">>
                                                })
                               end of
                               true ->
                                 case Sm of
                                   {nothing} ->
                                     {january};
                                   {just, Sm@3} ->
                                     Sm@3;
                                   _ ->
                                     erlang:error({ fail
                                                  , <<"Failed pattern match">>
                                                  })
                                 end;
                               _ ->
                                 erlang:element(3, V)
                             end),
                           case case V1 of
                               {nothing} ->
                                 true;
                               {just, _} ->
                                 false;
                               _ ->
                                 erlang:error({fail, <<"Failed pattern match">>})
                             end of
                             true ->
                               {just, V@5(1)};
                             _ ->
                               case V1 of
                                 {just, V1@2} ->
                                   {just, V@5(V1@2)};
                                 _ ->
                                   {nothing}
                               end
                           end
                         end;
                       true ->
                         {nothing}
                     end
                   end;
                 _ ->
                   begin
                     V@6 =
                       (('Date'())(erlang:element(2, V)))
                       (case case V1 of
                           {nothing} ->
                             true;
                           {just, _} ->
                             false;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end of
                         true ->
                           case Sm of
                             {nothing} ->
                               {january};
                             {just, Sm@4} ->
                               Sm@4;
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end;
                         _ ->
                           erlang:element(3, V)
                       end),
                     case case V1 of
                         {nothing} ->
                           true;
                         {just, _} ->
                           false;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end of
                       true ->
                         {just, V@6(1)};
                       _ ->
                         case V1 of
                           {just, V1@3} ->
                             {just, V@6(V1@3)};
                           _ ->
                             {nothing}
                         end
                     end
                   end
               end
           end
         end
     end
   , pred =>
     fun
       (V) ->
         begin
           Pm =
             (erlang:map_get(pred, data_date_component@ps:enumMonth()))
             (erlang:element(3, V)),
           V@1 = (erlang:element(4, V)) - 1,
           if
             (V@1 >= 1) andalso (V@1 =< 31) ->
               {just, {date, erlang:element(2, V), erlang:element(3, V), V@1}};
             true ->
               begin
                 M_ =
                   case Pm of
                     {nothing} ->
                       {december};
                     {just, Pm@1} ->
                       Pm@1;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end,
                 L = lastDayOfMonth(erlang:element(2, V), M_),
                 case case Pm of
                     {nothing} ->
                       true;
                     {just, _} ->
                       false;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end of
                   true ->
                     begin
                       V@2 = (erlang:element(2, V)) - 1,
                       if
                         (V@2 >= 0) andalso (V@2 =< 275759) ->
                           {just, {date, V@2, M_, L}};
                         true ->
                           {nothing}
                       end
                     end;
                   _ ->
                     {just, {date, erlang:element(2, V), M_, L}}
                 end
               end
           end
         end
     end
   , 'Ord0' =>
     fun
       (_) ->
         ordDate()
     end
   }.

diff() ->
  fun
    (DictDuration) ->
      fun
        (V) ->
          fun
            (V1) ->
              diff(DictDuration, V, V1)
          end
      end
  end.

diff(#{ toDuration := DictDuration }, V, V1) ->
  DictDuration((data_date@foreign:calcDiff())
               (
                 erlang:element(2, V),
                 case erlang:element(3, V) of
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
                 erlang:element(4, V),
                 erlang:element(2, V1),
                 case erlang:element(3, V1) of
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
                 erlang:element(4, V1)
               )).

day() ->
  fun
    (V) ->
      day(V)
  end.

day(V) ->
  erlang:element(4, V).

canonicalDate() ->
  fun
    (Y) ->
      fun
        (M) ->
          fun
            (D) ->
              canonicalDate(Y, M, D)
          end
      end
  end.

canonicalDate(Y, M, D) ->
  (data_date@foreign:canonicalDateImpl())
  (
    fun
      (Y_) ->
        fun
          (M_) ->
            fun
              (D_) ->
                { date
                , Y_
                , if
                    M_ =:= 1 ->
                      {january};
                    M_ =:= 2 ->
                      {february};
                    M_ =:= 3 ->
                      {march};
                    M_ =:= 4 ->
                      {april};
                    M_ =:= 5 ->
                      {may};
                    M_ =:= 6 ->
                      {june};
                    M_ =:= 7 ->
                      {july};
                    M_ =:= 8 ->
                      {august};
                    M_ =:= 9 ->
                      {september};
                    M_ =:= 10 ->
                      {october};
                    M_ =:= 11 ->
                      {november};
                    M_ =:= 12 ->
                      {december};
                    true ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
                , D_
                }
            end
        end
    end,
    Y,
    case M of
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
    D
  ).

exactDate() ->
  fun
    (Y) ->
      fun
        (M) ->
          fun
            (D) ->
              exactDate(Y, M, D)
          end
      end
  end.

exactDate(Y, M, D) ->
  case ((erlang:map_get(eq, eqDate()))(canonicalDate(Y, M, D)))({date, Y, M, D}) of
    true ->
      {just, {date, Y, M, D}};
    _ ->
      {nothing}
  end.

boundedDate() ->
  #{ bottom => {date, 0, {january}, 1}
   , top => {date, 275759, {december}, 31}
   , 'Ord0' =>
     fun
       (_) ->
         ordDate()
     end
   }.

adjust() ->
  fun
    (V) ->
      fun
        (Date) ->
          adjust(V, Date)
      end
  end.

adjust(V, Date) ->
  begin
    Adj =
      fun
        Adj (V1, V2) ->
          if
            V1 =:= 0 ->
              {just, V2};
            true ->
              begin
                J = V1 + (erlang:element(4, V2)),
                Low = J < 1,
                L =
                  lastDayOfMonth(
                    erlang:element(2, V2),
                    if
                      Low ->
                        begin
                          V@1 =
                            (erlang:map_get(
                               pred,
                               data_date_component@ps:enumMonth()
                             ))
                            (erlang:element(3, V2)),
                          case V@1 of
                            {nothing} ->
                              {december};
                            {just, V@2} ->
                              V@2;
                            _ ->
                              erlang:error({fail, <<"Failed pattern match">>})
                          end
                        end;
                      true ->
                        erlang:element(3, V2)
                    end
                  ),
                Hi = J > L,
                V@3 =
                  begin
                    V1@1 =
                      if
                        Low ->
                          J;
                        Hi ->
                          (J - L) - 1;
                        true ->
                          0
                      end,
                    fun
                      (V2@1) ->
                        Adj(V1@1, V2@1)
                    end
                  end,
                V@5 =
                  if
                    Low ->
                      (erlang:map_get(pred, enumDate()))
                      ({date, erlang:element(2, V2), erlang:element(3, V2), 1});
                    Hi ->
                      (erlang:map_get(succ, enumDate()))
                      ({date, erlang:element(2, V2), erlang:element(3, V2), L});
                    true ->
                      begin
                        V@4 =
                          (('Date'())(erlang:element(2, V2)))
                          (erlang:element(3, V2)),
                        if
                          (J >= 1) andalso (J =< 31) ->
                            {just, V@4(J)};
                          true ->
                            {nothing}
                        end
                      end
                  end,
                case V@5 of
                  {just, V@6} ->
                    V@3(V@6);
                  {nothing} ->
                    {nothing};
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end
          end
      end,
    V@1 = data_int@ps:fromNumber(V),
    case V@1 of
      {just, V@2} ->
        Adj(V@2, Date);
      {nothing} ->
        {nothing};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

canonicalDateImpl() ->
  data_date@foreign:canonicalDateImpl().

calcWeekday() ->
  data_date@foreign:calcWeekday().

calcDiff() ->
  data_date@foreign:calcDiff().

