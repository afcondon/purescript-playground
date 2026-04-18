-module(data_list_partial@ps).
-export([tail/0, tail/2, last/0, last/2, init/0, init/2, head/0, head/2]).
-compile(no_auto_import).
tail() ->
  fun
    (V) ->
      fun
        (V@1) ->
          tail(V, V@1)
      end
  end.

tail(_, V = {cons, _, V@1}) ->
  case V of
    {cons, _, _} ->
      V@1;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

last() ->
  fun
    (V) ->
      fun
        (V@1) ->
          last(V, V@1)
      end
  end.

last(_, V = {cons, _, V@1}) ->
  case V of
    {cons, _, _} ->
      case V@1 of
        {nil} ->
          erlang:element(2, V);
        _ ->
          last(undefined, V@1)
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

init() ->
  fun
    (V) ->
      fun
        (V@1) ->
          init(V, V@1)
      end
  end.

init(_, V = {cons, _, V@1}) ->
  case V of
    {cons, _, _} ->
      case V@1 of
        {nil} ->
          {nil};
        _ ->
          {cons, erlang:element(2, V), init(undefined, V@1)}
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

head() ->
  fun
    (V) ->
      fun
        (V@1) ->
          head(V, V@1)
      end
  end.

head(_, V = {cons, V@1, _}) ->
  case V of
    {cons, _, _} ->
      V@1;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

