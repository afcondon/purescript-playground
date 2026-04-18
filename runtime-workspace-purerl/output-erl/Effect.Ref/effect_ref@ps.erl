-module(effect_ref@ps).
-export([ 'modify\''/0
        , modify/0
        , modify/1
        , modify_/0
        , modify_/2
        , modifyImpl/0
        , new/0
        , newWithSelf/0
        , read/0
        , write/0
        , 'modify\''/2
        ]).
-compile(no_auto_import).
'modify\''() ->
  modifyImpl().

modify() ->
  fun
    (F) ->
      modify(F)
  end.

modify(F) ->
  (modifyImpl())
  (fun
    (S) ->
      begin
        S_ = F(S),
        #{ state => S_, value => S_ }
      end
  end).

modify_() ->
  fun
    (F) ->
      fun
        (S) ->
          modify_(F, S)
      end
  end.

modify_(F, S) ->
  begin
    V =
      effect_ref@foreign:modifyImpl(
        fun
          (S@1) ->
            begin
              S_ = F(S@1),
              #{ state => S_, value => S_ }
            end
        end,
        S
      ),
    fun
      () ->
        begin
          V(),
          unit
        end
    end
  end.

modifyImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          effect_ref@foreign:modifyImpl(V, V@1)
      end
  end.

new() ->
  fun
    (V) ->
      effect_ref@foreign:new(V)
  end.

newWithSelf() ->
  fun
    (V) ->
      effect_ref@foreign:newWithSelf(V)
  end.

read() ->
  fun
    (V) ->
      effect_ref@foreign:read(V)
  end.

write() ->
  fun
    (V) ->
      fun
        (V@1) ->
          effect_ref@foreign:write(V, V@1)
      end
  end.

'modify\''(V, V@1) ->
  effect_ref@foreign:modifyImpl(V, V@1).

