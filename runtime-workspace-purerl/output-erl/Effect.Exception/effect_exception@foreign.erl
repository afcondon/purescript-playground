-module(effect_exception@foreign).
-export([showErrorImpl/1,error/1,message/1,name/1,stackImpl/3,throwException/1,catchException/2]).

showErrorImpl(E) -> message(E).

error(S) -> S.

message(E) when is_binary(E) -> E;
message(E) -> unicode:characters_to_binary(io_lib:format("~p", [E]), utf8).

name(_E) -> <<"Error">>.

stackImpl(_Just,Nothing,_E) -> Nothing.

throwException(E) -> fun() ->
  erlang:error(E)
end.

catchException(C,T) -> fun () ->
  try T()
  catch error:Reason -> (C(Reason))()
  end
end.
