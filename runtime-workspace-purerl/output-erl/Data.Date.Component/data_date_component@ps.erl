-module(data_date_component@ps).
-export([ 'Monday'/0
        , 'Tuesday'/0
        , 'Wednesday'/0
        , 'Thursday'/0
        , 'Friday'/0
        , 'Saturday'/0
        , 'Sunday'/0
        , 'January'/0
        , 'February'/0
        , 'March'/0
        , 'April'/0
        , 'May'/0
        , 'June'/0
        , 'July'/0
        , 'August'/0
        , 'September'/0
        , 'October'/0
        , 'November'/0
        , 'December'/0
        , showYear/0
        , showWeekday/0
        , showMonth/0
        , showDay/0
        , ordYear/0
        , ordDay/0
        , eqYear/0
        , eqWeekday/0
        , ordWeekday/0
        , eqMonth/0
        , ordMonth/0
        , eqDay/0
        , boundedYear/0
        , boundedWeekday/0
        , boundedMonth/0
        , boundedEnumYear/0
        , enumYear/0
        , boundedEnumWeekday/0
        , enumWeekday/0
        , boundedEnumMonth/0
        , enumMonth/0
        , boundedDay/0
        , boundedEnumDay/0
        , enumDay/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'Monday'() ->
  {monday}.

'Tuesday'() ->
  {tuesday}.

'Wednesday'() ->
  {wednesday}.

'Thursday'() ->
  {thursday}.

'Friday'() ->
  {friday}.

'Saturday'() ->
  {saturday}.

'Sunday'() ->
  {sunday}.

'January'() ->
  {january}.

'February'() ->
  {february}.

'March'() ->
  {march}.

'April'() ->
  {april}.

'May'() ->
  {may}.

'June'() ->
  {june}.

'July'() ->
  {july}.

'August'() ->
  {august}.

'September'() ->
  {september}.

'October'() ->
  {october}.

'November'() ->
  {november}.

'December'() ->
  {december}.

showYear() ->
  #{ show =>
     fun
       (V) ->
         <<"(Year ", (data_show@foreign:showIntImpl(V))/binary, ")">>
     end
   }.

showWeekday() ->
  #{ show =>
     fun
       (V) ->
         case V of
           {monday} ->
             <<"Monday">>;
           {tuesday} ->
             <<"Tuesday">>;
           {wednesday} ->
             <<"Wednesday">>;
           {thursday} ->
             <<"Thursday">>;
           {friday} ->
             <<"Friday">>;
           {saturday} ->
             <<"Saturday">>;
           {sunday} ->
             <<"Sunday">>;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

showMonth() ->
  #{ show =>
     fun
       (V) ->
         case V of
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
         end
     end
   }.

showDay() ->
  #{ show =>
     fun
       (V) ->
         <<"(Day ", (data_show@foreign:showIntImpl(V))/binary, ")">>
     end
   }.

ordYear() ->
  data_ord@ps:ordInt().

ordDay() ->
  data_ord@ps:ordInt().

eqYear() ->
  data_eq@ps:eqInt().

eqWeekday() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {monday} ->
                 ?IS_KNOWN_TAG(monday, 0, Y);
               {tuesday} ->
                 ?IS_KNOWN_TAG(tuesday, 0, Y);
               {wednesday} ->
                 ?IS_KNOWN_TAG(wednesday, 0, Y);
               {thursday} ->
                 ?IS_KNOWN_TAG(thursday, 0, Y);
               {friday} ->
                 ?IS_KNOWN_TAG(friday, 0, Y);
               {saturday} ->
                 ?IS_KNOWN_TAG(saturday, 0, Y);
               _ ->
                 ?IS_KNOWN_TAG(sunday, 0, X) andalso ?IS_KNOWN_TAG(sunday, 0, Y)
             end
         end
     end
   }.

ordWeekday() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {monday} ->
                 case Y of
                   {monday} ->
                     {eQ};
                   _ ->
                     {lT}
                 end;
               _ ->
                 case Y of
                   {monday} ->
                     {gT};
                   _ ->
                     case X of
                       {tuesday} ->
                         case Y of
                           {tuesday} ->
                             {eQ};
                           _ ->
                             {lT}
                         end;
                       _ ->
                         case Y of
                           {tuesday} ->
                             {gT};
                           _ ->
                             case X of
                               {wednesday} ->
                                 case Y of
                                   {wednesday} ->
                                     {eQ};
                                   _ ->
                                     {lT}
                                 end;
                               _ ->
                                 case Y of
                                   {wednesday} ->
                                     {gT};
                                   _ ->
                                     case X of
                                       {thursday} ->
                                         case Y of
                                           {thursday} ->
                                             {eQ};
                                           _ ->
                                             {lT}
                                         end;
                                       _ ->
                                         case Y of
                                           {thursday} ->
                                             {gT};
                                           _ ->
                                             case X of
                                               {friday} ->
                                                 case Y of
                                                   {friday} ->
                                                     {eQ};
                                                   _ ->
                                                     {lT}
                                                 end;
                                               _ ->
                                                 case Y of
                                                   {friday} ->
                                                     {gT};
                                                   _ ->
                                                     case X of
                                                       {saturday} ->
                                                         case Y of
                                                           {saturday} ->
                                                             {eQ};
                                                           _ ->
                                                             {lT}
                                                         end;
                                                       _ ->
                                                         case Y of
                                                           {saturday} ->
                                                             {gT};
                                                           _ ->
                                                             if
                                                               ?IS_KNOWN_TAG(sunday, 0, X)
                                                                 andalso ?IS_KNOWN_TAG(sunday, 0, Y) ->
                                                                 {eQ};
                                                               true ->
                                                                 erlang:error({ fail
                                                                              , <<
                                                                                  "Failed pattern match"
                                                                                >>
                                                                              })
                                                             end
                                                         end
                                                     end
                                                 end
                                             end
                                         end
                                     end
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
         eqWeekday()
     end
   }.

eqMonth() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {january} ->
                 ?IS_KNOWN_TAG(january, 0, Y);
               {february} ->
                 ?IS_KNOWN_TAG(february, 0, Y);
               {march} ->
                 ?IS_KNOWN_TAG(march, 0, Y);
               {april} ->
                 ?IS_KNOWN_TAG(april, 0, Y);
               {may} ->
                 ?IS_KNOWN_TAG(may, 0, Y);
               {june} ->
                 ?IS_KNOWN_TAG(june, 0, Y);
               {july} ->
                 ?IS_KNOWN_TAG(july, 0, Y);
               {august} ->
                 ?IS_KNOWN_TAG(august, 0, Y);
               {september} ->
                 ?IS_KNOWN_TAG(september, 0, Y);
               {october} ->
                 ?IS_KNOWN_TAG(october, 0, Y);
               {november} ->
                 ?IS_KNOWN_TAG(november, 0, Y);
               _ ->
                 ?IS_KNOWN_TAG(december, 0, X)
                   andalso ?IS_KNOWN_TAG(december, 0, Y)
             end
         end
     end
   }.

ordMonth() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {january} ->
                 case Y of
                   {january} ->
                     {eQ};
                   _ ->
                     {lT}
                 end;
               _ ->
                 case Y of
                   {january} ->
                     {gT};
                   _ ->
                     case X of
                       {february} ->
                         case Y of
                           {february} ->
                             {eQ};
                           _ ->
                             {lT}
                         end;
                       _ ->
                         case Y of
                           {february} ->
                             {gT};
                           _ ->
                             case X of
                               {march} ->
                                 case Y of
                                   {march} ->
                                     {eQ};
                                   _ ->
                                     {lT}
                                 end;
                               _ ->
                                 case Y of
                                   {march} ->
                                     {gT};
                                   _ ->
                                     case X of
                                       {april} ->
                                         case Y of
                                           {april} ->
                                             {eQ};
                                           _ ->
                                             {lT}
                                         end;
                                       _ ->
                                         case Y of
                                           {april} ->
                                             {gT};
                                           _ ->
                                             case X of
                                               {may} ->
                                                 case Y of
                                                   {may} ->
                                                     {eQ};
                                                   _ ->
                                                     {lT}
                                                 end;
                                               _ ->
                                                 case Y of
                                                   {may} ->
                                                     {gT};
                                                   _ ->
                                                     case X of
                                                       {june} ->
                                                         case Y of
                                                           {june} ->
                                                             {eQ};
                                                           _ ->
                                                             {lT}
                                                         end;
                                                       _ ->
                                                         case Y of
                                                           {june} ->
                                                             {gT};
                                                           _ ->
                                                             case X of
                                                               {july} ->
                                                                 case Y of
                                                                   {july} ->
                                                                     {eQ};
                                                                   _ ->
                                                                     {lT}
                                                                 end;
                                                               _ ->
                                                                 case Y of
                                                                   {july} ->
                                                                     {gT};
                                                                   _ ->
                                                                     case X of
                                                                       {august} ->
                                                                         case Y of
                                                                           {august} ->
                                                                             {eQ};
                                                                           _ ->
                                                                             {lT}
                                                                         end;
                                                                       _ ->
                                                                         case Y of
                                                                           {august} ->
                                                                             {gT};
                                                                           _ ->
                                                                             case X of
                                                                               {september} ->
                                                                                 case Y of
                                                                                   {september} ->
                                                                                     {eQ};
                                                                                   _ ->
                                                                                     {lT}
                                                                                 end;
                                                                               _ ->
                                                                                 case Y of
                                                                                   {september} ->
                                                                                     {gT};
                                                                                   _ ->
                                                                                     case X of
                                                                                       {october} ->
                                                                                         case Y of
                                                                                           {october} ->
                                                                                             {eQ};
                                                                                           _ ->
                                                                                             {lT}
                                                                                         end;
                                                                                       _ ->
                                                                                         case Y of
                                                                                           {october} ->
                                                                                             {gT};
                                                                                           _ ->
                                                                                             case X of
                                                                                               {november} ->
                                                                                                 case Y of
                                                                                                   {november} ->
                                                                                                     {eQ};
                                                                                                   _ ->
                                                                                                     {lT}
                                                                                                 end;
                                                                                               _ ->
                                                                                                 case Y of
                                                                                                   {november} ->
                                                                                                     {gT};
                                                                                                   _ ->
                                                                                                     if
                                                                                                       ?IS_KNOWN_TAG(december, 0, X)
                                                                                                         andalso ?IS_KNOWN_TAG(december, 0, Y) ->
                                                                                                         {eQ};
                                                                                                       true ->
                                                                                                         erlang:error({ fail
                                                                                                                      , <<
                                                                                                                          "Failed pattern match"
                                                                                                                        >>
                                                                                                                      })
                                                                                                     end
                                                                                                 end
                                                                                             end
                                                                                         end
                                                                                     end
                                                                                 end
                                                                             end
                                                                         end
                                                                     end
                                                                 end
                                                             end
                                                         end
                                                     end
                                                 end
                                             end
                                         end
                                     end
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
         eqMonth()
     end
   }.

eqDay() ->
  data_eq@ps:eqInt().

boundedYear() ->
  #{ bottom => 0
   , top => 275759
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordInt()
     end
   }.

boundedWeekday() ->
  #{ bottom => {monday}
   , top => {sunday}
   , 'Ord0' =>
     fun
       (_) ->
         ordWeekday()
     end
   }.

boundedMonth() ->
  #{ bottom => {january}
   , top => {december}
   , 'Ord0' =>
     fun
       (_) ->
         ordMonth()
     end
   }.

boundedEnumYear() ->
  #{ cardinality => 275760
   , toEnum =>
     fun
       (N) ->
         if
           (N >= 0) andalso (N =< 275759) ->
             {just, N};
           true ->
             {nothing}
         end
     end
   , fromEnum =>
     fun
       (V) ->
         V
     end
   , 'Bounded0' =>
     fun
       (_) ->
         boundedYear()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumYear()
     end
   }.

enumYear() ->
  #{ succ =>
     fun
       (X) ->
         begin
           V = X + 1,
           if
             (V >= 0) andalso (V =< 275759) ->
               {just, V};
             true ->
               {nothing}
           end
         end
     end
   , pred =>
     fun
       (X) ->
         begin
           V = X - 1,
           if
             (V >= 0) andalso (V =< 275759) ->
               {just, V};
             true ->
               {nothing}
           end
         end
     end
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordInt()
     end
   }.

boundedEnumWeekday() ->
  #{ cardinality => 7
   , toEnum =>
     fun
       (V) ->
         if
           V =:= 1 ->
             {just, {monday}};
           V =:= 2 ->
             {just, {tuesday}};
           V =:= 3 ->
             {just, {wednesday}};
           V =:= 4 ->
             {just, {thursday}};
           V =:= 5 ->
             {just, {friday}};
           V =:= 6 ->
             {just, {saturday}};
           V =:= 7 ->
             {just, {sunday}};
           true ->
             {nothing}
         end
     end
   , fromEnum =>
     fun
       (V) ->
         case V of
           {monday} ->
             1;
           {tuesday} ->
             2;
           {wednesday} ->
             3;
           {thursday} ->
             4;
           {friday} ->
             5;
           {saturday} ->
             6;
           {sunday} ->
             7;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , 'Bounded0' =>
     fun
       (_) ->
         boundedWeekday()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumWeekday()
     end
   }.

enumWeekday() ->
  #{ succ =>
     fun
       (X) ->
         begin
           V =
             case X of
               {monday} ->
                 2;
               {tuesday} ->
                 3;
               {wednesday} ->
                 4;
               {thursday} ->
                 5;
               {friday} ->
                 6;
               {saturday} ->
                 7;
               {sunday} ->
                 8;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end,
           if
             V =:= 1 ->
               {just, {monday}};
             V =:= 2 ->
               {just, {tuesday}};
             V =:= 3 ->
               {just, {wednesday}};
             V =:= 4 ->
               {just, {thursday}};
             V =:= 5 ->
               {just, {friday}};
             V =:= 6 ->
               {just, {saturday}};
             V =:= 7 ->
               {just, {sunday}};
             true ->
               {nothing}
           end
         end
     end
   , pred =>
     fun
       (X) ->
         begin
           V =
             case X of
               {monday} ->
                 0;
               {tuesday} ->
                 1;
               {wednesday} ->
                 2;
               {thursday} ->
                 3;
               {friday} ->
                 4;
               {saturday} ->
                 5;
               {sunday} ->
                 6;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end,
           if
             V =:= 1 ->
               {just, {monday}};
             V =:= 2 ->
               {just, {tuesday}};
             V =:= 3 ->
               {just, {wednesday}};
             V =:= 4 ->
               {just, {thursday}};
             V =:= 5 ->
               {just, {friday}};
             V =:= 6 ->
               {just, {saturday}};
             V =:= 7 ->
               {just, {sunday}};
             true ->
               {nothing}
           end
         end
     end
   , 'Ord0' =>
     fun
       (_) ->
         ordWeekday()
     end
   }.

boundedEnumMonth() ->
  #{ cardinality => 12
   , toEnum =>
     fun
       (V) ->
         if
           V =:= 1 ->
             {just, {january}};
           V =:= 2 ->
             {just, {february}};
           V =:= 3 ->
             {just, {march}};
           V =:= 4 ->
             {just, {april}};
           V =:= 5 ->
             {just, {may}};
           V =:= 6 ->
             {just, {june}};
           V =:= 7 ->
             {just, {july}};
           V =:= 8 ->
             {just, {august}};
           V =:= 9 ->
             {just, {september}};
           V =:= 10 ->
             {just, {october}};
           V =:= 11 ->
             {just, {november}};
           V =:= 12 ->
             {just, {december}};
           true ->
             {nothing}
         end
     end
   , fromEnum =>
     fun
       (V) ->
         case V of
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
     end
   , 'Bounded0' =>
     fun
       (_) ->
         boundedMonth()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumMonth()
     end
   }.

enumMonth() ->
  #{ succ =>
     fun
       (X) ->
         begin
           V =
             case X of
               {january} ->
                 2;
               {february} ->
                 3;
               {march} ->
                 4;
               {april} ->
                 5;
               {may} ->
                 6;
               {june} ->
                 7;
               {july} ->
                 8;
               {august} ->
                 9;
               {september} ->
                 10;
               {october} ->
                 11;
               {november} ->
                 12;
               {december} ->
                 13;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end,
           if
             V =:= 1 ->
               {just, {january}};
             V =:= 2 ->
               {just, {february}};
             V =:= 3 ->
               {just, {march}};
             V =:= 4 ->
               {just, {april}};
             V =:= 5 ->
               {just, {may}};
             V =:= 6 ->
               {just, {june}};
             V =:= 7 ->
               {just, {july}};
             V =:= 8 ->
               {just, {august}};
             V =:= 9 ->
               {just, {september}};
             V =:= 10 ->
               {just, {october}};
             V =:= 11 ->
               {just, {november}};
             V =:= 12 ->
               {just, {december}};
             true ->
               {nothing}
           end
         end
     end
   , pred =>
     fun
       (X) ->
         begin
           V =
             case X of
               {january} ->
                 0;
               {february} ->
                 1;
               {march} ->
                 2;
               {april} ->
                 3;
               {may} ->
                 4;
               {june} ->
                 5;
               {july} ->
                 6;
               {august} ->
                 7;
               {september} ->
                 8;
               {october} ->
                 9;
               {november} ->
                 10;
               {december} ->
                 11;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end,
           if
             V =:= 1 ->
               {just, {january}};
             V =:= 2 ->
               {just, {february}};
             V =:= 3 ->
               {just, {march}};
             V =:= 4 ->
               {just, {april}};
             V =:= 5 ->
               {just, {may}};
             V =:= 6 ->
               {just, {june}};
             V =:= 7 ->
               {just, {july}};
             V =:= 8 ->
               {just, {august}};
             V =:= 9 ->
               {just, {september}};
             V =:= 10 ->
               {just, {october}};
             V =:= 11 ->
               {just, {november}};
             V =:= 12 ->
               {just, {december}};
             true ->
               {nothing}
           end
         end
     end
   , 'Ord0' =>
     fun
       (_) ->
         ordMonth()
     end
   }.

boundedDay() ->
  #{ bottom => 1
   , top => 31
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordInt()
     end
   }.

boundedEnumDay() ->
  #{ cardinality => 31
   , toEnum =>
     fun
       (N) ->
         if
           (N >= 1) andalso (N =< 31) ->
             {just, N};
           true ->
             {nothing}
         end
     end
   , fromEnum =>
     fun
       (V) ->
         V
     end
   , 'Bounded0' =>
     fun
       (_) ->
         boundedDay()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumDay()
     end
   }.

enumDay() ->
  #{ succ =>
     fun
       (X) ->
         begin
           V = X + 1,
           if
             (V >= 1) andalso (V =< 31) ->
               {just, V};
             true ->
               {nothing}
           end
         end
     end
   , pred =>
     fun
       (X) ->
         begin
           V = X - 1,
           if
             (V >= 1) andalso (V =< 31) ->
               {just, V};
             true ->
               {nothing}
           end
         end
     end
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordInt()
     end
   }.

