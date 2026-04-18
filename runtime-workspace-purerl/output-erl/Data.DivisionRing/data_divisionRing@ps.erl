-module(data_divisionRing@ps).
-export([ recip/0
        , recip/1
        , rightDiv/0
        , rightDiv/3
        , leftDiv/0
        , leftDiv/3
        , divisionringNumber/0
        ]).
-compile(no_auto_import).
recip() ->
  fun
    (Dict) ->
      recip(Dict)
  end.

recip(#{ recip := Dict }) ->
  Dict.

rightDiv() ->
  fun
    (DictDivisionRing) ->
      fun
        (A) ->
          fun
            (B) ->
              rightDiv(DictDivisionRing, A, B)
          end
      end
  end.

rightDiv(#{ 'Ring0' := DictDivisionRing, recip := DictDivisionRing@1 }, A, B) ->
  ((erlang:map_get(
      mul,
      (erlang:map_get('Semiring0', DictDivisionRing(undefined)))(undefined)
    ))
   (A))
  (DictDivisionRing@1(B)).

leftDiv() ->
  fun
    (DictDivisionRing) ->
      fun
        (A) ->
          fun
            (B) ->
              leftDiv(DictDivisionRing, A, B)
          end
      end
  end.

leftDiv(#{ 'Ring0' := DictDivisionRing, recip := DictDivisionRing@1 }, A, B) ->
  ((erlang:map_get(
      mul,
      (erlang:map_get('Semiring0', DictDivisionRing(undefined)))(undefined)
    ))
   (DictDivisionRing@1(B)))
  (A).

divisionringNumber() ->
  #{ recip =>
     fun
       (X) ->
         1.0 / X
     end
   , 'Ring0' =>
     fun
       (_) ->
         data_ring@ps:ringNumber()
     end
   }.

