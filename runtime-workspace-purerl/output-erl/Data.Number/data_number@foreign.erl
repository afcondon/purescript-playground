-module(data_number@foreign).

-export([isFinite/1, fromStringImpl/0]).

isFinite(_) -> true.

fromStringImpl() -> fun(Str, _IsFinite, Just, Nothing) ->
  case string:to_float(Str) of
    {F, _} when is_float(F) -> Just(F);
    {error, _} ->
      case string:to_integer(Str) of
        {N, _} when is_integer(N) -> Just(float(N));
        {error, _} -> Nothing
      end
    end
  end.