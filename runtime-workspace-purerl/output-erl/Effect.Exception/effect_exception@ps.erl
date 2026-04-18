-module(effect_exception@ps).
-export([ 'try'/0
        , 'try'/1
        , throw/0
        , throw/1
        , stack/0
        , showError/0
        , showErrorImpl/0
        , error/0
        , message/0
        , name/0
        , stackImpl/0
        , throwException/0
        , catchException/0
        , stack/1
        ]).
-compile(no_auto_import).
'try'() ->
  fun
    (Action) ->
      'try'(Action)
  end.

'try'(Action) ->
  effect_exception@foreign:catchException(
    fun
      (X) ->
        fun
          () ->
            {left, X}
        end
    end,
    fun
      () ->
        begin
          A_ = Action(),
          {right, A_}
        end
    end
  ).

throw() ->
  fun
    (X) ->
      throw(X)
  end.

throw(X) ->
  fun
    () ->
      erlang:error(effect_exception@foreign:error(X))
  end.

stack() ->
  ((stackImpl())(data_maybe@ps:'Just'()))({nothing}).

showError() ->
  #{ show => showErrorImpl() }.

showErrorImpl() ->
  fun
    (V) ->
      effect_exception@foreign:showErrorImpl(V)
  end.

error() ->
  fun
    (V) ->
      effect_exception@foreign:error(V)
  end.

message() ->
  fun
    (V) ->
      effect_exception@foreign:message(V)
  end.

name() ->
  fun
    (V) ->
      effect_exception@foreign:name(V)
  end.

stackImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              effect_exception@foreign:stackImpl(V, V@1, V@2)
          end
      end
  end.

throwException() ->
  fun
    (V) ->
      effect_exception@foreign:throwException(V)
  end.

catchException() ->
  fun
    (V) ->
      fun
        (V@1) ->
          effect_exception@foreign:catchException(V, V@1)
      end
  end.

stack(V) ->
  effect_exception@foreign:stackImpl(data_maybe@ps:'Just'(), {nothing}, V).

