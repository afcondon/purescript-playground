-module(type_proxy@ps).
-export(['Proxy3'/0, 'Proxy2'/0, 'Proxy'/0]).
-compile(no_auto_import).
'Proxy3'() ->
  {proxy3}.

'Proxy2'() ->
  {proxy2}.

'Proxy'() ->
  {proxy}.

