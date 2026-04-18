-module(data_number_format@foreign).

-export([toPrecisionNative/2, toFixedNative/2, toExponentialNative/2, toString/1]).

toPrecisionNative(Precision, N) -> 
  case Precision =< 1 of
    true -> integer_to_binary(round(N));
    false ->
      unicode:characters_to_binary(io_lib:format("~.*g", [Precision, N]), utf8)
  end.
toFixedNative(Digits, N) -> float_to_binary(N, [{decimals, Digits}]).

%% Digits after the . vs erlang's total digits
toExponentialNative(Digits, N) -> 
  case Digits =< 0 of
    true ->
      unicode:characters_to_binary(io_lib:format("~Be+0", [round(N)]));
    false ->
      unicode:characters_to_binary(io_lib:format("~.*e", [1+Digits, N]), utf8)
  end.

toString(Num) -> unicode:characters_to_binary(io_lib:format("~g", [Num]), utf8).
