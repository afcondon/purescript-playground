-module(data_string_regex_unsafe@ps).
-export([unsafeRegex/0, unsafeRegex/2]).
-compile(no_auto_import).
unsafeRegex() ->
  fun
    (S) ->
      fun
        (F) ->
          unsafeRegex(S, F)
      end
  end.

unsafeRegex(S, F) ->
  begin
    V = data_string_regex@ps:regex(S, F),
    case V of
      {left, V@1} ->
        erlang:error(V@1);
      {right, V@2} ->
        V@2;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

