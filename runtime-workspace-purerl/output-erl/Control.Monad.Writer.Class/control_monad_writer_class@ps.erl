-module(control_monad_writer_class@ps).
-export([ tell/0
        , tell/1
        , pass/0
        , pass/1
        , listen/0
        , listen/1
        , listens/0
        , listens/1
        , censor/0
        , censor/1
        ]).
-compile(no_auto_import).
tell() ->
  fun
    (Dict) ->
      tell(Dict)
  end.

tell(#{ tell := Dict }) ->
  Dict.

pass() ->
  fun
    (Dict) ->
      pass(Dict)
  end.

pass(#{ pass := Dict }) ->
  Dict.

listen() ->
  fun
    (Dict) ->
      listen(Dict)
  end.

listen(#{ listen := Dict }) ->
  Dict.

listens() ->
  fun
    (DictMonadWriter) ->
      listens(DictMonadWriter)
  end.

listens(#{ 'MonadTell1' := DictMonadWriter, listen := DictMonadWriter@1 }) ->
  begin
    #{ 'Applicative0' := Monad1, 'Bind1' := Monad1@1 } =
      (erlang:map_get('Monad1', DictMonadWriter(undefined)))(undefined),
    fun
      (F) ->
        fun
          (M) ->
            ((erlang:map_get(bind, Monad1@1(undefined)))(DictMonadWriter@1(M)))
            (fun
              (V) ->
                (erlang:map_get(pure, Monad1(undefined)))
                ({tuple, erlang:element(2, V), F(erlang:element(3, V))})
            end)
        end
    end
  end.

censor() ->
  fun
    (DictMonadWriter) ->
      censor(DictMonadWriter)
  end.

censor(#{ 'MonadTell1' := DictMonadWriter, pass := DictMonadWriter@1 }) ->
  begin
    #{ 'Applicative0' := Monad1, 'Bind1' := Monad1@1 } =
      (erlang:map_get('Monad1', DictMonadWriter(undefined)))(undefined),
    fun
      (F) ->
        fun
          (M) ->
            DictMonadWriter@1(((erlang:map_get(bind, Monad1@1(undefined)))(M))
                              (fun
                                (A) ->
                                  (erlang:map_get(pure, Monad1(undefined)))
                                  ({tuple, A, F})
                              end))
        end
    end
  end.

