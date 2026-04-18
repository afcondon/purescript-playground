-module(data_interval_duration_iso@ps).
-export([ foldMap1/0
        , foldMap2/0
        , 'fold.semigroupFn'/0
        , fold/0
        , 'IsEmpty'/0
        , 'InvalidWeekComponentUsage'/0
        , 'ContainsNegativeValue'/0
        , 'InvalidFractionalUse'/0
        , unIsoDuration/0
        , unIsoDuration/1
        , showIsoDuration/0
        , showError/0
        , prettyError/0
        , prettyError/1
        , eqIsoDuration/0
        , ordIsoDuration/0
        , eqError/0
        , ordError/0
        , checkWeekUsage/0
        , checkWeekUsage/1
        , checkNegativeValues/0
        , checkNegativeValues/1
        , checkFractionalUse/0
        , checkFractionalUse/1
        , checkEmptiness/0
        , checkEmptiness/1
        , checkValidIsoDuration/0
        , checkValidIsoDuration/1
        , mkIsoDuration/0
        , mkIsoDuration/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
foldMap1() ->
  (erlang:map_get(foldMap, data_list_types@ps:foldableList()))
  (data_list_types@ps:monoidList()).

foldMap2() ->
  (erlang:map_get(foldMap, data_list_types@ps:foldableList()))
  (begin
    SemigroupAdditive1 =
      #{ append =>
         fun
           (V) ->
             fun
               (V1) ->
                 V + V1
             end
         end
       },
    #{ mempty => 0.0
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupAdditive1
       end
     }
  end).

'fold.semigroupFn'() ->
  #{ append =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (X) ->
                 (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
                   (data_list_types@ps:'Cons'()))
                  (G(X)))
                 (F(X))
             end
         end
     end
   }.

fold() ->
  ((erlang:map_get(foldMap, data_foldable@ps:foldableArray()))
   (#{ mempty =>
       fun
         (_) ->
           {nil}
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           'fold.semigroupFn'()
       end
     }))
  (data_foldable@ps:identity()).

'IsEmpty'() ->
  {isEmpty}.

'InvalidWeekComponentUsage'() ->
  {invalidWeekComponentUsage}.

'ContainsNegativeValue'() ->
  fun
    (Value0) ->
      {containsNegativeValue, Value0}
  end.

'InvalidFractionalUse'() ->
  fun
    (Value0) ->
      {invalidFractionalUse, Value0}
  end.

unIsoDuration() ->
  fun
    (V) ->
      unIsoDuration(V)
  end.

unIsoDuration(V) ->
  V.

showIsoDuration() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(IsoDuration (Duration ",
           ((data_interval_duration@ps:show())(V))/binary,
           "))"
         >>
     end
   }.

showError() ->
  #{ show =>
     fun
       (V) ->
         case V of
           {isEmpty} ->
             <<"(IsEmpty)">>;
           {invalidWeekComponentUsage} ->
             <<"(InvalidWeekComponentUsage)">>;
           {containsNegativeValue, V@1} ->
             case V@1 of
               {minute} ->
                 <<"(ContainsNegativeValue Minute)">>;
               {second} ->
                 <<"(ContainsNegativeValue Second)">>;
               {hour} ->
                 <<"(ContainsNegativeValue Hour)">>;
               {day} ->
                 <<"(ContainsNegativeValue Day)">>;
               {week} ->
                 <<"(ContainsNegativeValue Week)">>;
               {month} ->
                 <<"(ContainsNegativeValue Month)">>;
               {year} ->
                 <<"(ContainsNegativeValue Year)">>;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end;
           {invalidFractionalUse, V@2} ->
             case V@2 of
               {minute} ->
                 <<"(InvalidFractionalUse Minute)">>;
               {second} ->
                 <<"(InvalidFractionalUse Second)">>;
               {hour} ->
                 <<"(InvalidFractionalUse Hour)">>;
               {day} ->
                 <<"(InvalidFractionalUse Day)">>;
               {week} ->
                 <<"(InvalidFractionalUse Week)">>;
               {month} ->
                 <<"(InvalidFractionalUse Month)">>;
               {year} ->
                 <<"(InvalidFractionalUse Year)">>;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

prettyError() ->
  fun
    (V) ->
      prettyError(V)
  end.

prettyError(V) ->
  case V of
    {isEmpty} ->
      <<"Duration is empty (has no components)">>;
    {invalidWeekComponentUsage} ->
      <<"Week component of Duration is used with other components">>;
    {containsNegativeValue, V@1} ->
      case V@1 of
        {minute} ->
          <<"Component `Minute` contains negative value">>;
        {second} ->
          <<"Component `Second` contains negative value">>;
        {hour} ->
          <<"Component `Hour` contains negative value">>;
        {day} ->
          <<"Component `Day` contains negative value">>;
        {week} ->
          <<"Component `Week` contains negative value">>;
        {month} ->
          <<"Component `Month` contains negative value">>;
        {year} ->
          <<"Component `Year` contains negative value">>;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    {invalidFractionalUse, V@2} ->
      case V@2 of
        {minute} ->
          <<"Invalid usage of Fractional value at component `Minute`">>;
        {second} ->
          <<"Invalid usage of Fractional value at component `Second`">>;
        {hour} ->
          <<"Invalid usage of Fractional value at component `Hour`">>;
        {day} ->
          <<"Invalid usage of Fractional value at component `Day`">>;
        {week} ->
          <<"Invalid usage of Fractional value at component `Week`">>;
        {month} ->
          <<"Invalid usage of Fractional value at component `Month`">>;
        {year} ->
          <<"Invalid usage of Fractional value at component `Year`">>;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

eqIsoDuration() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             ((data_interval_duration@ps:eq())(X))(Y)
         end
     end
   }.

ordIsoDuration() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             ((data_interval_duration@ps:compare())(X))(Y)
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqIsoDuration()
     end
   }.

eqError() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {isEmpty} ->
                 ?IS_KNOWN_TAG(isEmpty, 0, Y);
               {invalidWeekComponentUsage} ->
                 ?IS_KNOWN_TAG(invalidWeekComponentUsage, 0, Y);
               {containsNegativeValue, _} ->
                 ?IS_KNOWN_TAG(containsNegativeValue, 1, Y)
                   andalso case erlang:element(2, X) of
                     {second} ->
                       ?IS_KNOWN_TAG(second, 0, erlang:element(2, Y));
                     {minute} ->
                       ?IS_KNOWN_TAG(minute, 0, erlang:element(2, Y));
                     {hour} ->
                       ?IS_KNOWN_TAG(hour, 0, erlang:element(2, Y));
                     {day} ->
                       ?IS_KNOWN_TAG(day, 0, erlang:element(2, Y));
                     {week} ->
                       ?IS_KNOWN_TAG(week, 0, erlang:element(2, Y));
                     {month} ->
                       ?IS_KNOWN_TAG(month, 0, erlang:element(2, Y));
                     _ ->
                       ?IS_KNOWN_TAG(year, 0, erlang:element(2, X))
                         andalso ?IS_KNOWN_TAG(year, 0, erlang:element(2, Y))
                   end;
               _ ->
                 ?IS_KNOWN_TAG(invalidFractionalUse, 1, X)
                   andalso (?IS_KNOWN_TAG(invalidFractionalUse, 1, Y)
                     andalso case erlang:element(2, X) of
                       {second} ->
                         ?IS_KNOWN_TAG(second, 0, erlang:element(2, Y));
                       {minute} ->
                         ?IS_KNOWN_TAG(minute, 0, erlang:element(2, Y));
                       {hour} ->
                         ?IS_KNOWN_TAG(hour, 0, erlang:element(2, Y));
                       {day} ->
                         ?IS_KNOWN_TAG(day, 0, erlang:element(2, Y));
                       {week} ->
                         ?IS_KNOWN_TAG(week, 0, erlang:element(2, Y));
                       {month} ->
                         ?IS_KNOWN_TAG(month, 0, erlang:element(2, Y));
                       _ ->
                         ?IS_KNOWN_TAG(year, 0, erlang:element(2, X))
                           andalso ?IS_KNOWN_TAG(year, 0, erlang:element(2, Y))
                     end)
             end
         end
     end
   }.

ordError() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {isEmpty} ->
                 case Y of
                   {isEmpty} ->
                     {eQ};
                   _ ->
                     {lT}
                 end;
               _ ->
                 case Y of
                   {isEmpty} ->
                     {gT};
                   _ ->
                     case X of
                       {invalidWeekComponentUsage} ->
                         case Y of
                           {invalidWeekComponentUsage} ->
                             {eQ};
                           _ ->
                             {lT}
                         end;
                       _ ->
                         case Y of
                           {invalidWeekComponentUsage} ->
                             {gT};
                           _ ->
                             case X of
                               {containsNegativeValue, _} ->
                                 case Y of
                                   {containsNegativeValue, _} ->
                                     case erlang:element(2, X) of
                                       {second} ->
                                         case erlang:element(2, Y) of
                                           {second} ->
                                             {eQ};
                                           _ ->
                                             {lT}
                                         end;
                                       _ ->
                                         case erlang:element(2, Y) of
                                           {second} ->
                                             {gT};
                                           _ ->
                                             case erlang:element(2, X) of
                                               {minute} ->
                                                 case erlang:element(2, Y) of
                                                   {minute} ->
                                                     {eQ};
                                                   _ ->
                                                     {lT}
                                                 end;
                                               _ ->
                                                 case erlang:element(2, Y) of
                                                   {minute} ->
                                                     {gT};
                                                   _ ->
                                                     case erlang:element(2, X) of
                                                       {hour} ->
                                                         case erlang:element(
                                                                2,
                                                                Y
                                                              ) of
                                                           {hour} ->
                                                             {eQ};
                                                           _ ->
                                                             {lT}
                                                         end;
                                                       _ ->
                                                         case erlang:element(
                                                                2,
                                                                Y
                                                              ) of
                                                           {hour} ->
                                                             {gT};
                                                           _ ->
                                                             case erlang:element(
                                                                    2,
                                                                    X
                                                                  ) of
                                                               {day} ->
                                                                 case erlang:element(
                                                                        2,
                                                                        Y
                                                                      ) of
                                                                   {day} ->
                                                                     {eQ};
                                                                   _ ->
                                                                     {lT}
                                                                 end;
                                                               _ ->
                                                                 case erlang:element(
                                                                        2,
                                                                        Y
                                                                      ) of
                                                                   {day} ->
                                                                     {gT};
                                                                   _ ->
                                                                     case erlang:element(
                                                                            2,
                                                                            X
                                                                          ) of
                                                                       {week} ->
                                                                         case erlang:element(
                                                                                2,
                                                                                Y
                                                                              ) of
                                                                           {week} ->
                                                                             {eQ};
                                                                           _ ->
                                                                             {lT}
                                                                         end;
                                                                       _ ->
                                                                         case erlang:element(
                                                                                2,
                                                                                Y
                                                                              ) of
                                                                           {week} ->
                                                                             {gT};
                                                                           _ ->
                                                                             case erlang:element(
                                                                                    2,
                                                                                    X
                                                                                  ) of
                                                                               {month} ->
                                                                                 case erlang:element(
                                                                                        2,
                                                                                        Y
                                                                                      ) of
                                                                                   {month} ->
                                                                                     {eQ};
                                                                                   _ ->
                                                                                     {lT}
                                                                                 end;
                                                                               _ ->
                                                                                 case erlang:element(
                                                                                        2,
                                                                                        Y
                                                                                      ) of
                                                                                   {month} ->
                                                                                     {gT};
                                                                                   _ ->
                                                                                     if
                                                                                       ?IS_KNOWN_TAG(year, 0, erlang:element(
                                                                                                                2,
                                                                                                                X
                                                                                                              ))
                                                                                         andalso ?IS_KNOWN_TAG(year, 0, erlang:element(
                                                                                                                          2,
                                                                                                                          Y
                                                                                                                        )) ->
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
                                     end;
                                   _ ->
                                     {lT}
                                 end;
                               _ ->
                                 case Y of
                                   {containsNegativeValue, _} ->
                                     {gT};
                                   _ ->
                                     if
                                       ?IS_KNOWN_TAG(invalidFractionalUse, 1, X)
                                         andalso ?IS_KNOWN_TAG(invalidFractionalUse, 1, Y) ->
                                         case erlang:element(2, X) of
                                           {second} ->
                                             case erlang:element(2, Y) of
                                               {second} ->
                                                 {eQ};
                                               _ ->
                                                 {lT}
                                             end;
                                           _ ->
                                             case erlang:element(2, Y) of
                                               {second} ->
                                                 {gT};
                                               _ ->
                                                 case erlang:element(2, X) of
                                                   {minute} ->
                                                     case erlang:element(2, Y) of
                                                       {minute} ->
                                                         {eQ};
                                                       _ ->
                                                         {lT}
                                                     end;
                                                   _ ->
                                                     case erlang:element(2, Y) of
                                                       {minute} ->
                                                         {gT};
                                                       _ ->
                                                         case erlang:element(
                                                                2,
                                                                X
                                                              ) of
                                                           {hour} ->
                                                             case erlang:element(
                                                                    2,
                                                                    Y
                                                                  ) of
                                                               {hour} ->
                                                                 {eQ};
                                                               _ ->
                                                                 {lT}
                                                             end;
                                                           _ ->
                                                             case erlang:element(
                                                                    2,
                                                                    Y
                                                                  ) of
                                                               {hour} ->
                                                                 {gT};
                                                               _ ->
                                                                 case erlang:element(
                                                                        2,
                                                                        X
                                                                      ) of
                                                                   {day} ->
                                                                     case erlang:element(
                                                                            2,
                                                                            Y
                                                                          ) of
                                                                       {day} ->
                                                                         {eQ};
                                                                       _ ->
                                                                         {lT}
                                                                     end;
                                                                   _ ->
                                                                     case erlang:element(
                                                                            2,
                                                                            Y
                                                                          ) of
                                                                       {day} ->
                                                                         {gT};
                                                                       _ ->
                                                                         case erlang:element(
                                                                                2,
                                                                                X
                                                                              ) of
                                                                           {week} ->
                                                                             case erlang:element(
                                                                                    2,
                                                                                    Y
                                                                                  ) of
                                                                               {week} ->
                                                                                 {eQ};
                                                                               _ ->
                                                                                 {lT}
                                                                             end;
                                                                           _ ->
                                                                             case erlang:element(
                                                                                    2,
                                                                                    Y
                                                                                  ) of
                                                                               {week} ->
                                                                                 {gT};
                                                                               _ ->
                                                                                 case erlang:element(
                                                                                        2,
                                                                                        X
                                                                                      ) of
                                                                                   {month} ->
                                                                                     case erlang:element(
                                                                                            2,
                                                                                            Y
                                                                                          ) of
                                                                                       {month} ->
                                                                                         {eQ};
                                                                                       _ ->
                                                                                         {lT}
                                                                                     end;
                                                                                   _ ->
                                                                                     case erlang:element(
                                                                                            2,
                                                                                            Y
                                                                                          ) of
                                                                                       {month} ->
                                                                                         {gT};
                                                                                       _ ->
                                                                                         if
                                                                                           ?IS_KNOWN_TAG(year, 0, erlang:element(
                                                                                                                    2,
                                                                                                                    X
                                                                                                                  ))
                                                                                             andalso ?IS_KNOWN_TAG(year, 0, erlang:element(
                                                                                                                              2,
                                                                                                                              Y
                                                                                                                            )) ->
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
                                         end;
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
   , 'Eq0' =>
     fun
       (_) ->
         eqError()
     end
   }.

checkWeekUsage() ->
  fun
    (V) ->
      checkWeekUsage(V)
  end.

checkWeekUsage(#{ asMap := V }) ->
  begin
    V@1 =
      (data_map_internal@ps:lookup(
         data_interval_duration@ps:ordDurationComponent(),
         {week}
       ))
      (V),
    case case V@1 of
        {nothing} ->
          false;
        {just, _} ->
          true;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end
        andalso ((data_map_internal@ps:size(V)) > 1) of
      true ->
        {cons, {invalidWeekComponentUsage}, {nil}};
      _ ->
        {nil}
    end
  end.

checkNegativeValues() ->
  fun
    (V) ->
      checkNegativeValues(V)
  end.

checkNegativeValues(#{ asList := V }) ->
  ((foldMap1())
   (fun
     (V1) ->
       if
         (erlang:element(3, V1)) >= 0.0 ->
           {nil};
         true ->
           {cons, {containsNegativeValue, erlang:element(2, V1)}, {nil}}
       end
   end))
  (V).

checkFractionalUse() ->
  fun
    (V) ->
      checkFractionalUse(V)
  end.

checkFractionalUse(#{ asList := V }) ->
  begin
    V@1 = #{ rest := V@2 } =
      data_list@ps:span(
        fun
          (X) ->
            (math@foreign:floor(erlang:element(3, X)))
              =:= (erlang:element(3, X))
        end,
        V
      ),
    case ?IS_KNOWN_TAG(cons, 2, V@2)
        andalso ((((foldMap2())
                   (fun
                     (X) ->
                       math@foreign:abs(erlang:element(3, X))
                   end))
                  (erlang:element(3, V@2)))
          > 0.0) of
      true ->
        begin
          #{ rest := {cons, V@3, _} } = V@1,
          {cons, {invalidFractionalUse, erlang:element(2, V@3)}, {nil}}
        end;
      _ ->
        {nil}
    end
  end.

checkEmptiness() ->
  fun
    (V) ->
      checkEmptiness(V)
  end.

checkEmptiness(V) ->
  case erlang:map_get(asList, V) of
    {nil} ->
      {cons, {isEmpty}, {nil}};
    _ ->
      {nil}
  end.

checkValidIsoDuration() ->
  fun
    (V) ->
      checkValidIsoDuration(V)
  end.

checkValidIsoDuration(V) ->
  ((fold())
   (array:from_list([ checkWeekUsage()
                    , checkEmptiness()
                    , checkFractionalUse()
                    , checkNegativeValues()
                    ])))
  (#{ asList =>
      data_list@ps:reverse(data_map_internal@ps:toUnfoldable(
                             data_list_types@ps:unfoldableList(),
                             V
                           ))
    , asMap => V
    }).

mkIsoDuration() ->
  fun
    (D) ->
      mkIsoDuration(D)
  end.

mkIsoDuration(D) ->
  begin
    V = checkValidIsoDuration(D),
    case V of
      {nil} ->
        {right, D};
      {cons, V@1, V@2} ->
        {left, {nonEmpty, V@1, V@2}};
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

