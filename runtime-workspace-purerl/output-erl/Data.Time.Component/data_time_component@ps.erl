-module(data_time_component@ps).
-export([ showSecond/0
        , showMinute/0
        , showMillisecond/0
        , showHour/0
        , ordSecond/0
        , ordMinute/0
        , ordMillisecond/0
        , ordHour/0
        , eqSecond/0
        , eqMinute/0
        , eqMillisecond/0
        , eqHour/0
        , boundedSecond/0
        , boundedMinute/0
        , boundedMillisecond/0
        , boundedHour/0
        , boundedEnumSecond/0
        , enumSecond/0
        , boundedEnumMinute/0
        , enumMinute/0
        , boundedEnumMillisecond/0
        , enumMillisecond/0
        , boundedEnumHour/0
        , enumHour/0
        ]).
-compile(no_auto_import).
showSecond() ->
  #{ show =>
     fun
       (V) ->
         <<"(Second ", (data_show@foreign:showIntImpl(V))/binary, ")">>
     end
   }.

showMinute() ->
  #{ show =>
     fun
       (V) ->
         <<"(Minute ", (data_show@foreign:showIntImpl(V))/binary, ")">>
     end
   }.

showMillisecond() ->
  #{ show =>
     fun
       (V) ->
         <<"(Millisecond ", (data_show@foreign:showIntImpl(V))/binary, ")">>
     end
   }.

showHour() ->
  #{ show =>
     fun
       (V) ->
         <<"(Hour ", (data_show@foreign:showIntImpl(V))/binary, ")">>
     end
   }.

ordSecond() ->
  data_ord@ps:ordInt().

ordMinute() ->
  data_ord@ps:ordInt().

ordMillisecond() ->
  data_ord@ps:ordInt().

ordHour() ->
  data_ord@ps:ordInt().

eqSecond() ->
  data_eq@ps:eqInt().

eqMinute() ->
  data_eq@ps:eqInt().

eqMillisecond() ->
  data_eq@ps:eqInt().

eqHour() ->
  data_eq@ps:eqInt().

boundedSecond() ->
  #{ bottom => 0
   , top => 59
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordInt()
     end
   }.

boundedMinute() ->
  #{ bottom => 0
   , top => 59
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordInt()
     end
   }.

boundedMillisecond() ->
  #{ bottom => 0
   , top => 999
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordInt()
     end
   }.

boundedHour() ->
  #{ bottom => 0
   , top => 23
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordInt()
     end
   }.

boundedEnumSecond() ->
  #{ cardinality => 60
   , toEnum =>
     fun
       (N) ->
         if
           (N >= 0) andalso (N =< 59) ->
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
         boundedSecond()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumSecond()
     end
   }.

enumSecond() ->
  #{ succ =>
     fun
       (X) ->
         begin
           V = X + 1,
           if
             (V >= 0) andalso (V =< 59) ->
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
             (V >= 0) andalso (V =< 59) ->
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

boundedEnumMinute() ->
  #{ cardinality => 60
   , toEnum =>
     fun
       (N) ->
         if
           (N >= 0) andalso (N =< 59) ->
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
         boundedMinute()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumMinute()
     end
   }.

enumMinute() ->
  #{ succ =>
     fun
       (X) ->
         begin
           V = X + 1,
           if
             (V >= 0) andalso (V =< 59) ->
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
             (V >= 0) andalso (V =< 59) ->
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

boundedEnumMillisecond() ->
  #{ cardinality => 1000
   , toEnum =>
     fun
       (N) ->
         if
           (N >= 0) andalso (N =< 999) ->
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
         boundedMillisecond()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumMillisecond()
     end
   }.

enumMillisecond() ->
  #{ succ =>
     fun
       (X) ->
         begin
           V = X + 1,
           if
             (V >= 0) andalso (V =< 999) ->
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
             (V >= 0) andalso (V =< 999) ->
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

boundedEnumHour() ->
  #{ cardinality => 24
   , toEnum =>
     fun
       (N) ->
         if
           (N >= 0) andalso (N =< 23) ->
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
         boundedHour()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumHour()
     end
   }.

enumHour() ->
  #{ succ =>
     fun
       (X) ->
         begin
           V = X + 1,
           if
             (V >= 0) andalso (V =< 23) ->
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
             (V >= 0) andalso (V =< 23) ->
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

