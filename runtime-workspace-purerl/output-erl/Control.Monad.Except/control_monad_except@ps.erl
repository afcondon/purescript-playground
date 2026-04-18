-module(control_monad_except@ps).
-export([ withExcept/0
        , withExcept/2
        , runExcept/0
        , runExcept/1
        , mapExcept/0
        , mapExcept/2
        ]).
-compile(no_auto_import).
withExcept() ->
  fun
    (F) ->
      fun
        (V) ->
          withExcept(F, V)
      end
  end.

withExcept(F, V) ->
  case V of
    {right, V@1} ->
      {right, V@1};
    {left, V@2} ->
      {left, F(V@2)};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

runExcept() ->
  fun
    (X) ->
      runExcept(X)
  end.

runExcept(X) ->
  X.

mapExcept() ->
  fun
    (F) ->
      fun
        (V) ->
          mapExcept(F, V)
      end
  end.

mapExcept(F, V) ->
  F(V).

