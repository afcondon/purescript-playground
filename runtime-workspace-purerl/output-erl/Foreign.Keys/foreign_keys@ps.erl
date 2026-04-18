-module(foreign_keys@ps).
-export([keys/0, keys/2, unsafeKeys/0]).
-compile(no_auto_import).
keys() ->
  fun
    (DictMonad) ->
      fun
        (Value) ->
          keys(DictMonad, Value)
      end
  end.

keys(DictMonad, Value) ->
  case foreign@foreign:isNull(Value) of
    true ->
      (erlang:map_get(
         throwError,
         control_monad_except_trans@ps:monadThrowExceptT(DictMonad)
       ))
      ({nonEmpty, {typeMismatch, <<"object">>, <<"null">>}, {nil}});
    _ ->
      case foreign@foreign:isUndefined(Value) of
        true ->
          (erlang:map_get(
             throwError,
             control_monad_except_trans@ps:monadThrowExceptT(DictMonad)
           ))
          ({nonEmpty, {typeMismatch, <<"object">>, <<"undefined">>}, {nil}});
        _ ->
          case (foreign@foreign:typeOf(Value)) =:= <<"object">> of
            true ->
              (erlang:map_get(
                 pure,
                 control_monad_except_trans@ps:applicativeExceptT(DictMonad)
               ))
              (foreign_keys@foreign:unsafeKeys(Value));
            _ ->
              (erlang:map_get(
                 throwError,
                 control_monad_except_trans@ps:monadThrowExceptT(DictMonad)
               ))
              ({ nonEmpty
               , {typeMismatch, <<"object">>, foreign@foreign:typeOf(Value)}
               , {nil}
               })
          end
      end
  end.

unsafeKeys() ->
  fun
    (V) ->
      foreign_keys@foreign:unsafeKeys(V)
  end.

