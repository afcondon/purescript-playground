-module(erl_process_raw@ps).
-export([ 'Normal'/0
        , 'Killed'/0
        , 'Other'/0
        , 'ExitReason'/0
        , showPid/0
        , receiveWithTrapAndTimeout/0
        , receiveWithTrapAndTimeout/1
        , receiveWithTimeout/0
        , receiveWithTimeout/1
        , pidHasPid/0
        , getPid/0
        , getPid/1
        , eqPid/0
        , eqNative/0
        , spawn/0
        , spawnLink/0
        , send/0
        , 'receive'/0
        , receiveWithTimeout_/0
        , receiveWithTrap/0
        , receiveWithTrapAndTimeout_/0
        , self/0
        , setProcessFlagTrapExit/0
        , exit/0
        , sendExitSignal/0
        , unlink/0
        , show_/0
        ]).
-compile(no_auto_import).
'Normal'() ->
  {normal}.

'Killed'() ->
  {killed}.

'Other'() ->
  fun
    (Value0) ->
      {other, Value0}
  end.

'ExitReason'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {exitReason, Value0, Value1}
      end
  end.

showPid() ->
  #{ show => show_() }.

receiveWithTrapAndTimeout() ->
  fun
    (V) ->
      receiveWithTrapAndTimeout(V)
  end.

receiveWithTrapAndTimeout(V) ->
  (receiveWithTrapAndTimeout_())(data_int@ps:round(V)).

receiveWithTimeout() ->
  fun
    (V) ->
      receiveWithTimeout(V)
  end.

receiveWithTimeout(V) ->
  (receiveWithTimeout_())(data_int@ps:round(V)).

pidHasPid() ->
  #{ getPid =>
     fun
       (X) ->
         X
     end
   }.

getPid() ->
  fun
    (Dict) ->
      getPid(Dict)
  end.

getPid(#{ getPid := Dict }) ->
  Dict.

eqPid() ->
  #{ eq => eqNative() }.

eqNative() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_process_raw@foreign:eqNative(V, V@1)
      end
  end.

spawn() ->
  fun
    (V) ->
      erl_process_raw@foreign:spawn(V)
  end.

spawnLink() ->
  fun
    (V) ->
      erl_process_raw@foreign:spawnLink(V)
  end.

send() ->
  fun
    (V) ->
      erl_process_raw@foreign:send(V)
  end.

'receive'() ->
  erl_process_raw@foreign:'receive'().

receiveWithTimeout_() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_process_raw@foreign:receiveWithTimeout_(V, V@1)
      end
  end.

receiveWithTrap() ->
  erl_process_raw@foreign:receiveWithTrap().

receiveWithTrapAndTimeout_() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_process_raw@foreign:receiveWithTrapAndTimeout_(V, V@1)
      end
  end.

self() ->
  erl_process_raw@foreign:self().

setProcessFlagTrapExit() ->
  fun
    (V) ->
      erl_process_raw@foreign:setProcessFlagTrapExit(V)
  end.

exit() ->
  fun
    (V) ->
      erl_process_raw@foreign:exit(V)
  end.

sendExitSignal() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_process_raw@foreign:sendExitSignal(V, V@1)
      end
  end.

unlink() ->
  fun
    (V) ->
      erl_process_raw@foreign:unlink(V)
  end.

show_() ->
  fun
    (V) ->
      erl_process_raw@foreign:show_(V)
  end.

