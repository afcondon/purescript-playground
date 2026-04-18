-module(control_alternative@ps).
-export([guard/0, guard/1, alternativeArray/0]).
-compile(no_auto_import).
guard() ->
  fun
    (DictAlternative) ->
      guard(DictAlternative)
  end.

guard(DictAlternative = #{ 'Plus1' := DictAlternative@1 }) ->
  begin
    Empty = erlang:map_get(empty, DictAlternative@1(undefined)),
    fun
      (V) ->
        if
          V ->
            begin
              #{ 'Applicative0' := DictAlternative@2 } = DictAlternative,
              (erlang:map_get(pure, DictAlternative@2(undefined)))(unit)
            end;
          true ->
            Empty
        end
    end
  end.

alternativeArray() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         control_applicative@ps:applicativeArray()
     end
   , 'Plus1' =>
     fun
       (_) ->
         control_plus@ps:plusArray()
     end
   }.

