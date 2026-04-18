-module(data_lazy@foreign).
-export([defer/1, force/1]).

% Note that this is not in fact lazy, but a simple thunk.

defer(F) -> F.
force(F) -> F(unit).
