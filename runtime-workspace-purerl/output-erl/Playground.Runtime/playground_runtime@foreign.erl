-module(playground_runtime@foreign).

-export([
    '_emitLine'/1,
    '_formatFloat'/1,
    done/0
]).

%% _emitLine :: String -> Effect Unit
%% Writes a JSONL message to stdout and yields unit.
'_emitLine'(Line) ->
    fun() ->
        io:put_chars(Line),
        io:nl(),
        unit
    end.

%% _formatFloat :: Number -> String
%% Compact decimal formatting for non-integer floats. 12 digits of
%% precision, trailing zeros removed, no scientific notation.
'_formatFloat'(N) ->
    erlang:float_to_binary(N, [{decimals, 12}, compact]).

%% done :: Effect Unit
%% Signals the host (parent node process) that the bundle's emissions
%% are complete.
done() ->
    fun() ->
        io:put_chars(<<"{\"type\":\"done\"}">>),
        io:nl(),
        unit
    end.

