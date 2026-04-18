-module(control_monad_reader_class@ps).
-export([ monadAskFun/0
        , monadReaderFun/0
        , local/0
        , local/1
        , ask/0
        , ask/1
        , asks/0
        , asks/1
        ]).
-compile(no_auto_import).
monadAskFun() ->
  #{ ask =>
     fun
       (X) ->
         X
     end
   , 'Monad0' =>
     fun
       (_) ->
         control_monad@ps:monadFn()
     end
   }.

monadReaderFun() ->
  #{ local =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (X) ->
                 G(F(X))
             end
         end
     end
   , 'MonadAsk0' =>
     fun
       (_) ->
         monadAskFun()
     end
   }.

local() ->
  fun
    (Dict) ->
      local(Dict)
  end.

local(#{ local := Dict }) ->
  Dict.

ask() ->
  fun
    (Dict) ->
      ask(Dict)
  end.

ask(#{ ask := Dict }) ->
  Dict.

asks() ->
  fun
    (DictMonadAsk) ->
      asks(DictMonadAsk)
  end.

asks(#{ 'Monad0' := DictMonadAsk, ask := DictMonadAsk@1 }) ->
  fun
    (F) ->
      ((erlang:map_get(
          map,
          (erlang:map_get(
             'Functor0',
             (erlang:map_get(
                'Apply0',
                (erlang:map_get('Bind1', DictMonadAsk(undefined)))(undefined)
              ))
             (undefined)
           ))
          (undefined)
        ))
       (F))
      (DictMonadAsk@1)
  end.

