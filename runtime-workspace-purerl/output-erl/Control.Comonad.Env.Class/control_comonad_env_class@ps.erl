-module(control_comonad_env_class@ps).
-export([ local/0
        , local/1
        , comonadAskTuple/0
        , comonadEnvTuple/0
        , comonadAskEnvT/0
        , comonadAskEnvT/1
        , comonadEnvEnvT/0
        , comonadEnvEnvT/1
        , ask/0
        , ask/1
        , asks/0
        , asks/3
        ]).
-compile(no_auto_import).
local() ->
  fun
    (Dict) ->
      local(Dict)
  end.

local(#{ local := Dict }) ->
  Dict.

comonadAskTuple() ->
  #{ ask => data_tuple@ps:fst()
   , 'Comonad0' =>
     fun
       (_) ->
         data_tuple@ps:comonadTuple()
     end
   }.

comonadEnvTuple() ->
  #{ local =>
     fun
       (F) ->
         fun
           (V) ->
             {tuple, F(erlang:element(2, V)), erlang:element(3, V)}
         end
     end
   , 'ComonadAsk0' =>
     fun
       (_) ->
         comonadAskTuple()
     end
   }.

comonadAskEnvT() ->
  fun
    (DictComonad) ->
      comonadAskEnvT(DictComonad)
  end.

comonadAskEnvT(DictComonad) ->
  begin
    ComonadEnvT = control_comonad_env_trans@ps:comonadEnvT(DictComonad),
    #{ ask =>
       fun
         (V) ->
           erlang:element(2, V)
       end
     , 'Comonad0' =>
       fun
         (_) ->
           ComonadEnvT
       end
     }
  end.

comonadEnvEnvT() ->
  fun
    (DictComonad) ->
      comonadEnvEnvT(DictComonad)
  end.

comonadEnvEnvT(DictComonad) ->
  begin
    ComonadEnvT = control_comonad_env_trans@ps:comonadEnvT(DictComonad),
    #{ local =>
       fun
         (F) ->
           fun
             (V) ->
               {tuple, F(erlang:element(2, V)), erlang:element(3, V)}
           end
       end
     , 'ComonadAsk0' =>
       fun
         (_) ->
           #{ ask =>
              fun
                (V) ->
                  erlang:element(2, V)
              end
            , 'Comonad0' =>
              fun
                (_) ->
                  ComonadEnvT
              end
            }
       end
     }
  end.

ask() ->
  fun
    (Dict) ->
      ask(Dict)
  end.

ask(#{ ask := Dict }) ->
  Dict.

asks() ->
  fun
    (DictComonadAsk) ->
      fun
        (F) ->
          fun
            (X) ->
              asks(DictComonadAsk, F, X)
          end
      end
  end.

asks(#{ ask := DictComonadAsk }, F, X) ->
  F(DictComonadAsk(X)).

