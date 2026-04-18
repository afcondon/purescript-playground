-module(data_string_regex_flags@ps).
-export([ guard/0
        , eq/0
        , 'RegexFlags'/0
        , unicode/0
        , sticky/0
        , showRegexFlags/0
        , semigroupRegexFlags/0
        , noFlags/0
        , multiline/0
        , monoidRegexFlags/0
        , ignoreCase/0
        , global/0
        , eqRegexFlags/0
        , dotAll/0
        , eq/2
        ]).
-compile(no_auto_import).
guard() ->
  control_alternative@ps:guard(control_alternative@ps:alternativeArray()).

eq() ->
  (data_eq@ps:eqArrayImpl())(data_eq@ps:eqStringImpl()).

'RegexFlags'() ->
  fun
    (Value0) ->
      {regexFlags, Value0}
  end.

unicode() ->
  { regexFlags
  , #{ global => false
     , ignoreCase => false
     , multiline => false
     , dotAll => false
     , sticky => false
     , unicode => true
     }
  }.

sticky() ->
  { regexFlags
  , #{ global => false
     , ignoreCase => false
     , multiline => false
     , dotAll => false
     , sticky => true
     , unicode => false
     }
  }.

showRegexFlags() ->
  #{ show =>
     fun
       (V) ->
         begin
           V@1 = guard(),
           UsedFlags =
             data_semigroup@foreign:concatArray(
               data_semigroup@foreign:concatArray(
                 data_semigroup@foreign:concatArray(
                   data_semigroup@foreign:concatArray(
                     data_semigroup@foreign:concatArray(
                       data_semigroup@foreign:concatArray(
                         array:from_list([]),
                         data_functor@foreign:arrayMap(
                           fun
                             (_) ->
                               <<"global">>
                           end,
                           V@1(erlang:map_get(global, erlang:element(2, V)))
                         )
                       ),
                       data_functor@foreign:arrayMap(
                         fun
                           (_) ->
                             <<"ignoreCase">>
                         end,
                         V@1(erlang:map_get(ignoreCase, erlang:element(2, V)))
                       )
                     ),
                     data_functor@foreign:arrayMap(
                       fun
                         (_) ->
                           <<"multiline">>
                       end,
                       V@1(erlang:map_get(multiline, erlang:element(2, V)))
                     )
                   ),
                   data_functor@foreign:arrayMap(
                     fun
                       (_) ->
                         <<"dotAll">>
                     end,
                     V@1(erlang:map_get(dotAll, erlang:element(2, V)))
                   )
                 ),
                 data_functor@foreign:arrayMap(
                   fun
                     (_) ->
                       <<"sticky">>
                   end,
                   V@1(erlang:map_get(sticky, erlang:element(2, V)))
                 )
               ),
               data_functor@foreign:arrayMap(
                 fun
                   (_) ->
                     <<"unicode">>
                 end,
                 V@1(erlang:map_get(unicode, erlang:element(2, V)))
               )
             ),
           case eq(UsedFlags, array:from_list([])) of
             true ->
               <<"noFlags">>;
             _ ->
               <<
                 "(",
                 (data_string_common@foreign:joinWith(<<" <> ">>, UsedFlags))/binary,
                 ")"
               >>
           end
         end
     end
   }.

semigroupRegexFlags() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             { regexFlags
             , #{ global =>
                  (erlang:map_get(global, erlang:element(2, V)))
                    orelse (erlang:map_get(global, erlang:element(2, V1)))
                , ignoreCase =>
                  (erlang:map_get(ignoreCase, erlang:element(2, V)))
                    orelse (erlang:map_get(ignoreCase, erlang:element(2, V1)))
                , multiline =>
                  (erlang:map_get(multiline, erlang:element(2, V)))
                    orelse (erlang:map_get(multiline, erlang:element(2, V1)))
                , dotAll =>
                  (erlang:map_get(dotAll, erlang:element(2, V)))
                    orelse (erlang:map_get(dotAll, erlang:element(2, V1)))
                , sticky =>
                  (erlang:map_get(sticky, erlang:element(2, V)))
                    orelse (erlang:map_get(sticky, erlang:element(2, V1)))
                , unicode =>
                  (erlang:map_get(unicode, erlang:element(2, V)))
                    orelse (erlang:map_get(unicode, erlang:element(2, V1)))
                }
             }
         end
     end
   }.

noFlags() ->
  { regexFlags
  , #{ global => false
     , ignoreCase => false
     , multiline => false
     , dotAll => false
     , sticky => false
     , unicode => false
     }
  }.

multiline() ->
  { regexFlags
  , #{ global => false
     , ignoreCase => false
     , multiline => true
     , dotAll => false
     , sticky => false
     , unicode => false
     }
  }.

monoidRegexFlags() ->
  #{ mempty => noFlags()
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupRegexFlags()
     end
   }.

ignoreCase() ->
  { regexFlags
  , #{ global => false
     , ignoreCase => true
     , multiline => false
     , dotAll => false
     , sticky => false
     , unicode => false
     }
  }.

global() ->
  { regexFlags
  , #{ global => true
     , ignoreCase => false
     , multiline => false
     , dotAll => false
     , sticky => false
     , unicode => false
     }
  }.

eqRegexFlags() ->
  #{ eq =>
     fun
       (V) ->
         fun
           (V1) ->
             ((erlang:map_get(global, erlang:element(2, V)))
               =:= (erlang:map_get(global, erlang:element(2, V1))))
               andalso (((erlang:map_get(ignoreCase, erlang:element(2, V)))
                 =:= (erlang:map_get(ignoreCase, erlang:element(2, V1))))
                 andalso (((erlang:map_get(multiline, erlang:element(2, V)))
                   =:= (erlang:map_get(multiline, erlang:element(2, V1))))
                   andalso (((erlang:map_get(dotAll, erlang:element(2, V)))
                     =:= (erlang:map_get(dotAll, erlang:element(2, V1))))
                     andalso (((erlang:map_get(sticky, erlang:element(2, V)))
                       =:= (erlang:map_get(sticky, erlang:element(2, V1))))
                       andalso ((erlang:map_get(unicode, erlang:element(2, V)))
                         =:= (erlang:map_get(unicode, erlang:element(2, V1))))))))
         end
     end
   }.

dotAll() ->
  { regexFlags
  , #{ global => false
     , ignoreCase => false
     , multiline => false
     , dotAll => true
     , sticky => false
     , unicode => false
     }
  }.

eq(V, V@1) ->
  data_eq@foreign:eqArrayImpl(data_eq@ps:eqStringImpl(), V, V@1).

