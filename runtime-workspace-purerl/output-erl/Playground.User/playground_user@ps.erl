-module(playground_user@ps).
-export([ 'Add'/0
        , 'Subtract'/0
        , 'Query'/0
        , echoActor/0
        , echoActor/1
        , roundTrip/0
        , counter/0
        , counter/1
        , runCounter/0
        ]).
-compile(no_auto_import).
'Add'() ->
  fun
    (Value0) ->
      {add, Value0}
  end.

'Subtract'() ->
  fun
    (Value0) ->
      {subtract, Value0}
  end.

'Query'() ->
  fun
    (Value0) ->
      {query, Value0}
  end.

echoActor() ->
  fun
    (Parent) ->
      echoActor(Parent)
  end.

echoActor(Parent) ->
  fun
    () ->
      begin
        Msg = (erl_process_raw@foreign:'receive'())(),
        ((erl_process_raw@foreign:send(Parent))(Msg))()
      end
  end.

roundTrip() ->
  fun
    () ->
      begin
        Me = (erl_process_raw@foreign:self())(),
        Child =
          (erl_process_raw@foreign:spawn(fun
             () ->
               begin
                 Msg = (erl_process_raw@foreign:'receive'())(),
                 ((erl_process_raw@foreign:send(Me))(Msg))()
               end
           end))(),
        ((erl_process_raw@foreign:send(Child))(42))(),
        (erl_process_raw@foreign:'receive'())()
      end
  end.

counter() ->
  fun
    (N) ->
      counter(N)
  end.

counter(N) ->
  fun
    () ->
      begin
        V = (erl_process_raw@foreign:'receive'())(),
        case V of
          {add, V@1} ->
            counter(N + V@1);
          {subtract, V@2} ->
            counter(N - V@2);
          {query, V@3} ->
            (erl_process_raw@foreign:send(V@3))(N);
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end()
      end
  end.

runCounter() ->
  fun
    () ->
      begin
        Me = (erl_process_raw@foreign:self())(),
        C = (erl_process_raw@foreign:spawn(counter(0)))(),
        ((erl_process_raw@foreign:send(C))({add, 10}))(),
        ((erl_process_raw@foreign:send(C))({add, 5}))(),
        ((erl_process_raw@foreign:send(C))({subtract, 3}))(),
        ((erl_process_raw@foreign:send(C))({query, Me}))(),
        (erl_process_raw@foreign:'receive'())()
      end
  end.

