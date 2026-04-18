-module(data_interval_duration@ps).
-export([ 'Second'/0
        , 'Minute'/0
        , 'Hour'/0
        , 'Day'/0
        , 'Week'/0
        , 'Month'/0
        , 'Year'/0
        , 'Duration'/0
        , 'Duration'/1
        , showDurationComponent/0
        , show/0
        , showDuration/0
        , newtypeDuration/0
        , eqDurationComponent/0
        , eq/0
        , ordDurationComponent/0
        , compare/0
        , semigroupDuration/0
        , monoidDuration/0
        , eqDuration/0
        , ordDuration/0
        , hour/0
        , hour/1
        , millisecond/0
        , millisecond/1
        , minute/0
        , minute/1
        , month/0
        , month/1
        , second/0
        , second/1
        , week/0
        , week/1
        , year/0
        , year/1
        , day/0
        , day/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'Second'() ->
  {second}.

'Minute'() ->
  {minute}.

'Hour'() ->
  {hour}.

'Day'() ->
  {day}.

'Week'() ->
  {week}.

'Month'() ->
  {month}.

'Year'() ->
  {year}.

'Duration'() ->
  fun
    (X) ->
      'Duration'(X)
  end.

'Duration'(X) ->
  X.

showDurationComponent() ->
  #{ show =>
     fun
       (V) ->
         case V of
           {minute} ->
             <<"Minute">>;
           {second} ->
             <<"Second">>;
           {hour} ->
             <<"Hour">>;
           {day} ->
             <<"Day">>;
           {week} ->
             <<"Week">>;
           {month} ->
             <<"Month">>;
           {year} ->
             <<"Year">>;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

show() ->
  erlang:map_get(
    show,
    data_map_internal@ps:showMap(
      showDurationComponent(),
      data_show@ps:showNumber()
    )
  ).

showDuration() ->
  #{ show =>
     fun
       (V) ->
         <<"(Duration ", ((show())(V))/binary, ")">>
     end
   }.

newtypeDuration() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

eqDurationComponent() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {second} ->
                 ?IS_KNOWN_TAG(second, 0, Y);
               {minute} ->
                 ?IS_KNOWN_TAG(minute, 0, Y);
               {hour} ->
                 ?IS_KNOWN_TAG(hour, 0, Y);
               {day} ->
                 ?IS_KNOWN_TAG(day, 0, Y);
               {week} ->
                 ?IS_KNOWN_TAG(week, 0, Y);
               {month} ->
                 ?IS_KNOWN_TAG(month, 0, Y);
               _ ->
                 ?IS_KNOWN_TAG(year, 0, X) andalso ?IS_KNOWN_TAG(year, 0, Y)
             end
         end
     end
   }.

eq() ->
  erlang:map_get(
    eq,
    data_map_internal@ps:eqMap(eqDurationComponent(), data_eq@ps:eqNumber())
  ).

ordDurationComponent() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {second} ->
                 case Y of
                   {second} ->
                     {eQ};
                   _ ->
                     {lT}
                 end;
               _ ->
                 case Y of
                   {second} ->
                     {gT};
                   _ ->
                     case X of
                       {minute} ->
                         case Y of
                           {minute} ->
                             {eQ};
                           _ ->
                             {lT}
                         end;
                       _ ->
                         case Y of
                           {minute} ->
                             {gT};
                           _ ->
                             case X of
                               {hour} ->
                                 case Y of
                                   {hour} ->
                                     {eQ};
                                   _ ->
                                     {lT}
                                 end;
                               _ ->
                                 case Y of
                                   {hour} ->
                                     {gT};
                                   _ ->
                                     case X of
                                       {day} ->
                                         case Y of
                                           {day} ->
                                             {eQ};
                                           _ ->
                                             {lT}
                                         end;
                                       _ ->
                                         case Y of
                                           {day} ->
                                             {gT};
                                           _ ->
                                             case X of
                                               {week} ->
                                                 case Y of
                                                   {week} ->
                                                     {eQ};
                                                   _ ->
                                                     {lT}
                                                 end;
                                               _ ->
                                                 case Y of
                                                   {week} ->
                                                     {gT};
                                                   _ ->
                                                     case X of
                                                       {month} ->
                                                         case Y of
                                                           {month} ->
                                                             {eQ};
                                                           _ ->
                                                             {lT}
                                                         end;
                                                       _ ->
                                                         case Y of
                                                           {month} ->
                                                             {gT};
                                                           _ ->
                                                             if
                                                               ?IS_KNOWN_TAG(year, 0, X)
                                                                 andalso ?IS_KNOWN_TAG(year, 0, Y) ->
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
         eqDurationComponent()
     end
   }.

compare() ->
  erlang:map_get(
    compare,
    (data_map_internal@ps:ordMap(ordDurationComponent()))
    (data_ord@ps:ordNumber())
  ).

semigroupDuration() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             data_map_internal@ps:unionWith(
               ordDurationComponent(),
               data_semiring@ps:numAdd(),
               V,
               V1
             )
         end
     end
   }.

monoidDuration() ->
  #{ mempty => {leaf}
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupDuration()
     end
   }.

eqDuration() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             ((eq())(X))(Y)
         end
     end
   }.

ordDuration() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             ((compare())(X))(Y)
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqDuration()
     end
   }.

hour() ->
  fun
    (V) ->
      hour(V)
  end.

hour(V) ->
  {two, {leaf}, {hour}, V, {leaf}}.

millisecond() ->
  fun
    (X) ->
      millisecond(X)
  end.

millisecond(X) ->
  {two, {leaf}, {second}, X / 1000.0, {leaf}}.

minute() ->
  fun
    (V) ->
      minute(V)
  end.

minute(V) ->
  {two, {leaf}, {minute}, V, {leaf}}.

month() ->
  fun
    (V) ->
      month(V)
  end.

month(V) ->
  {two, {leaf}, {month}, V, {leaf}}.

second() ->
  fun
    (V) ->
      second(V)
  end.

second(V) ->
  {two, {leaf}, {second}, V, {leaf}}.

week() ->
  fun
    (V) ->
      week(V)
  end.

week(V) ->
  {two, {leaf}, {week}, V, {leaf}}.

year() ->
  fun
    (V) ->
      year(V)
  end.

year(V) ->
  {two, {leaf}, {year}, V, {leaf}}.

day() ->
  fun
    (V) ->
      day(V)
  end.

day(V) ->
  {two, {leaf}, {day}, V, {leaf}}.

