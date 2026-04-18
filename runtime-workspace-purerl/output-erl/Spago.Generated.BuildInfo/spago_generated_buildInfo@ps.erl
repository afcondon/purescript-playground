-module(spago_generated_buildInfo@ps).
-export([spagoVersion/0, pursVersion/0, packages/0]).
-compile(no_auto_import).
spagoVersion() ->
  <<"1.0.3">>.

pursVersion() ->
  <<"0.15.15">>.

packages() ->
  #{ 'playground-runtime-purerl' => <<"0.0.0">> }.

