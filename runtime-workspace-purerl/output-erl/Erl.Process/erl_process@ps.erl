-module(erl_process@ps).
-export([ 'ProcessTrapM'/0
        , 'ProcessTrapM'/1
        , 'ProcessM'/0
        , 'ProcessM'/1
        , showProcess/0
        , hasReceiveProcessTrapMEit/0
        , hasReceiveProcessM/0
        , unsafeRunProcessM/0
        , unsafeRunProcessM/1
        , trapExit/0
        , trapExit/1
        , toPid/0
        , toPid/1
        , spawnLink/0
        , spawnLink/1
        , spawn/0
        , spawn/1
        , sendExitSignal/0
        , sendExitSignal/2
        , send/0
        , send/2
        , selfProcessM/0
        , self/0
        , self/1
        , receiveWithTrapAndTimeout/0
        , receiveWithTrapAndTimeout/2
        , receiveWithTrap/0
        , receiveWithTimeout/0
        , receiveWithTimeout/1
        , 'receive'/0
        , 'receive'/1
        , processHasProcess/0
        , processHasPid/0
        , monadProcessTrapM/0
        , monadProcessM/0
        , monadEffectProcessTrapM/0
        , monadEffectProcessM/0
        , getProcess/0
        , getProcess/1
        , functorProcessTrapM/0
        , functorProcessM/0
        , eqProcess/0
        , bindProcessTrapM/0
        , bindProcessM/0
        , applyProcessTrapM/0
        , applyProcessM/0
        , applicativeProcessTrapM/0
        , applicativeProcessM/0
        ]).
-compile(no_auto_import).
'ProcessTrapM'() ->
  fun
    (X) ->
      'ProcessTrapM'(X)
  end.

'ProcessTrapM'(X) ->
  X.

'ProcessM'() ->
  fun
    (X) ->
      'ProcessM'(X)
  end.

'ProcessM'(X) ->
  X.

showProcess() ->
  #{ show =>
     fun
       (V) ->
         <<"(Process ", (erl_process_raw@foreign:show_(V))/binary, ")">>
     end
   }.

hasReceiveProcessTrapMEit() ->
  #{ 'receive' => erl_process_raw@foreign:receiveWithTrap()
   , receiveWithTimeout =>
     fun
       (T) ->
         fun
           (D) ->
             erl_process_raw@foreign:receiveWithTrapAndTimeout_(
               data_int@ps:round(T),
               D
             )
         end
     end
   }.

hasReceiveProcessM() ->
  #{ 'receive' => erl_process_raw@foreign:'receive'()
   , receiveWithTimeout =>
     fun
       (T) ->
         fun
           (D) ->
             erl_process_raw@foreign:receiveWithTimeout_(
               data_int@ps:round(T),
               D
             )
         end
     end
   }.

unsafeRunProcessM() ->
  fun
    (V) ->
      unsafeRunProcessM(V)
  end.

unsafeRunProcessM(V) ->
  V.

trapExit() ->
  fun
    (V) ->
      trapExit(V)
  end.

trapExit(V) ->
  begin
    V@1 = erl_process_raw@foreign:setProcessFlagTrapExit(true),
    fun
      () ->
        begin
          V@1(),
          Res = V(),
          (erl_process_raw@foreign:setProcessFlagTrapExit(false))(),
          Res
        end
    end
  end.

toPid() ->
  fun
    (V) ->
      toPid(V)
  end.

toPid(V) ->
  V.

spawnLink() ->
  fun
    (V) ->
      spawnLink(V)
  end.

spawnLink(V) ->
  begin
    V@1 = erl_process_raw@foreign:spawnLink(V),
    fun
      () ->
        V@1()
    end
  end.

spawn() ->
  fun
    (V) ->
      spawn(V)
  end.

spawn(V) ->
  begin
    V@1 = erl_process_raw@foreign:spawn(V),
    fun
      () ->
        V@1()
    end
  end.

sendExitSignal() ->
  fun
    (Reason) ->
      fun
        (V) ->
          sendExitSignal(Reason, V)
      end
  end.

sendExitSignal(Reason, V) ->
  erl_process_raw@foreign:sendExitSignal(Reason, V).

send() ->
  fun
    (P) ->
      fun
        (X) ->
          send(P, X)
      end
  end.

send(P, X) ->
  (erl_process_raw@foreign:send(P))(X).

selfProcessM() ->
  #{ self =>
     fun
       () ->
         (erl_process_raw@foreign:self())()
     end
   }.

self() ->
  fun
    (Dict) ->
      self(Dict)
  end.

self(#{ self := Dict }) ->
  Dict.

receiveWithTrapAndTimeout() ->
  fun
    (Timeout) ->
      fun
        (Default) ->
          receiveWithTrapAndTimeout(Timeout, Default)
      end
  end.

receiveWithTrapAndTimeout(Timeout, Default) ->
  erl_process_raw@foreign:receiveWithTrapAndTimeout_(
    data_int@ps:round(Timeout),
    Default
  ).

receiveWithTrap() ->
  erl_process_raw@foreign:receiveWithTrap().

receiveWithTimeout() ->
  fun
    (Dict) ->
      receiveWithTimeout(Dict)
  end.

receiveWithTimeout(#{ receiveWithTimeout := Dict }) ->
  Dict.

'receive'() ->
  fun
    (Dict) ->
      'receive'(Dict)
  end.

'receive'(#{ 'receive' := Dict }) ->
  Dict.

processHasProcess() ->
  #{ getProcess =>
     fun
       (X) ->
         X
     end
   }.

processHasPid() ->
  #{ getPid =>
     fun
       (V) ->
         V
     end
   }.

monadProcessTrapM() ->
  effect@ps:monadEffect().

monadProcessM() ->
  effect@ps:monadEffect().

monadEffectProcessTrapM() ->
  #{ liftEffect => 'ProcessTrapM'()
   , 'Monad0' =>
     fun
       (_) ->
         effect@ps:monadEffect()
     end
   }.

monadEffectProcessM() ->
  #{ liftEffect => 'ProcessM'()
   , 'Monad0' =>
     fun
       (_) ->
         effect@ps:monadEffect()
     end
   }.

getProcess() ->
  fun
    (Dict) ->
      getProcess(Dict)
  end.

getProcess(#{ getProcess := Dict }) ->
  Dict.

functorProcessTrapM() ->
  effect@ps:functorEffect().

functorProcessM() ->
  effect@ps:functorEffect().

eqProcess() ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             erl_process_raw@foreign:eqNative(A, B)
         end
     end
   }.

bindProcessTrapM() ->
  effect@ps:bindEffect().

bindProcessM() ->
  effect@ps:bindEffect().

applyProcessTrapM() ->
  effect@ps:applyEffect().

applyProcessM() ->
  effect@ps:applyEffect().

applicativeProcessTrapM() ->
  effect@ps:applicativeEffect().

applicativeProcessM() ->
  effect@ps:applicativeEffect().

