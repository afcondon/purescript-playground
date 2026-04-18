-module(control_monad_state_class@ps).
-export([ state/0
        , state/1
        , put/0
        , put/2
        , modify_/0
        , modify_/2
        , modify/0
        , modify/2
        , gets/0
        , gets/2
        , get/0
        , get/1
        ]).
-compile(no_auto_import).
state() ->
  fun
    (Dict) ->
      state(Dict)
  end.

state(#{ state := Dict }) ->
  Dict.

put() ->
  fun
    (DictMonadState) ->
      fun
        (S) ->
          put(DictMonadState, S)
      end
  end.

put(#{ state := DictMonadState }, S) ->
  DictMonadState(fun
    (_) ->
      {tuple, unit, S}
  end).

modify_() ->
  fun
    (DictMonadState) ->
      fun
        (F) ->
          modify_(DictMonadState, F)
      end
  end.

modify_(#{ state := DictMonadState }, F) ->
  DictMonadState(fun
    (S) ->
      {tuple, unit, F(S)}
  end).

modify() ->
  fun
    (DictMonadState) ->
      fun
        (F) ->
          modify(DictMonadState, F)
      end
  end.

modify(#{ state := DictMonadState }, F) ->
  DictMonadState(fun
    (S) ->
      begin
        S_ = F(S),
        {tuple, S_, S_}
      end
  end).

gets() ->
  fun
    (DictMonadState) ->
      fun
        (F) ->
          gets(DictMonadState, F)
      end
  end.

gets(#{ state := DictMonadState }, F) ->
  DictMonadState(fun
    (S) ->
      {tuple, F(S), S}
  end).

get() ->
  fun
    (DictMonadState) ->
      get(DictMonadState)
  end.

get(#{ state := DictMonadState }) ->
  DictMonadState(fun
    (S) ->
      {tuple, S, S}
  end).

