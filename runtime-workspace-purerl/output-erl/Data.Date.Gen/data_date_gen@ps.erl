-module(data_date_gen@ps).
-export([genDate/0, genDate/1]).
-compile(no_auto_import).
genDate() ->
  fun
    (DictMonadGen) ->
      genDate(DictMonadGen)
  end.

genDate(#{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }) ->
  begin
    #{ 'Applicative0' := Monad0, 'Bind1' := Monad0@1 } = DictMonadGen(undefined),
    #{ 'Apply0' := Bind1, bind := Bind1@1 } = Monad0@1(undefined),
    (Bind1@1(((erlang:map_get(
                 map,
                 (erlang:map_get(
                    'Functor0',
                    (erlang:map_get(
                       'Apply0',
                       (erlang:map_get('Bind1', DictMonadGen(undefined)))
                       (undefined)
                     ))
                    (undefined)
                  ))
                 (undefined)
               ))
              (fun
                (X) ->
                  if
                    (X >= 0) andalso (X =< 275759) ->
                      X;
                    true ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
              end))
             ((DictMonadGen@1(1900))(2100))))
    (fun
      (Year) ->
        (Bind1@1(((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', Bind1(undefined)))(undefined)
                   ))
                  (fun
                    (X) ->
                      data_int@foreign:toNumber(X)
                  end))
                 ((DictMonadGen@1(0))
                  (case data_date@ps:isLeapYear(Year) of
                    true ->
                      365;
                    _ ->
                      364
                  end))))
        (fun
          (Days) ->
            (erlang:map_get(pure, Monad0(undefined)))
            (begin
              V = data_date@ps:exactDate(Year, {january}, 1),
              V@2 = {just, V@3} =
                case V of
                  {just, V@1} ->
                    data_date@ps:adjust(Days, V@1);
                  {nothing} ->
                    {nothing};
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end,
              case V@2 of
                {just, _} ->
                  V@3;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
            end)
        end)
    end)
  end.

