-module(control_lazy@ps).
-export([lazyUnit/0, lazyFn/0, defer/0, defer/1, fix/0, fix/2]).
-compile(no_auto_import).
lazyUnit() ->
  #{ defer =>
     fun
       (_) ->
         unit
     end
   }.

lazyFn() ->
  #{ defer =>
     fun
       (F) ->
         fun
           (X) ->
             (F(unit))(X)
         end
     end
   }.

defer() ->
  fun
    (Dict) ->
      defer(Dict)
  end.

defer(#{ defer := Dict }) ->
  Dict.

fix() ->
  fun
    (DictLazy) ->
      fun
        (F) ->
          fix(DictLazy, F)
      end
  end.

fix(#{ defer := DictLazy }, F) ->
  begin
    Go =
      fun
        Go () ->
          DictLazy(fun
            (_) ->
              F(Go())
          end)
      end,
    Go()
  end.

