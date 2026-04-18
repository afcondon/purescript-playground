-module(foreign_index@ps).
-export([ unsafeReadProp/0
        , unsafeReadProp/1
        , readProp/0
        , readProp/1
        , readIndex/0
        , readIndex/1
        , ix/0
        , ix/1
        , index/0
        , index/1
        , indexableExceptT/0
        , indexableExceptT/1
        , indexableForeign/0
        , indexableForeign/1
        , hasPropertyImpl/0
        , hasPropertyImpl/2
        , hasProperty/0
        , hasProperty/1
        , hasOwnPropertyImpl/0
        , hasOwnPropertyImpl/2
        , indexInt/0
        , indexInt/1
        , indexString/0
        , indexString/1
        , hasOwnProperty/0
        , hasOwnProperty/1
        , errorAt/0
        , errorAt/1
        , unsafeReadPropImpl/0
        , unsafeHasOwnProperty/0
        , unsafeHasProperty/0
        ]).
-compile(no_auto_import).
unsafeReadProp() ->
  fun
    (DictMonad) ->
      unsafeReadProp(DictMonad)
  end.

unsafeReadProp(DictMonad) ->
  begin
    Pure =
      erlang:map_get(
        pure,
        control_monad_except_trans@ps:applicativeExceptT(DictMonad)
      ),
    fun
      (K) ->
        fun
          (Value) ->
            (foreign_index@foreign:unsafeReadPropImpl())
            (
              (erlang:map_get(
                 throwError,
                 control_monad_except_trans@ps:monadThrowExceptT(DictMonad)
               ))
              ({ nonEmpty
               , {typeMismatch, <<"object">>, foreign@foreign:typeOf(Value)}
               , {nil}
               }),
              Pure,
              K,
              Value
            )
        end
    end
  end.

readProp() ->
  fun
    (DictMonad) ->
      readProp(DictMonad)
  end.

readProp(DictMonad) ->
  unsafeReadProp(DictMonad).

readIndex() ->
  fun
    (DictMonad) ->
      readIndex(DictMonad)
  end.

readIndex(DictMonad) ->
  unsafeReadProp(DictMonad).

ix() ->
  fun
    (Dict) ->
      ix(Dict)
  end.

ix(#{ ix := Dict }) ->
  Dict.

index() ->
  fun
    (Dict) ->
      index(Dict)
  end.

index(#{ index := Dict }) ->
  Dict.

indexableExceptT() ->
  fun
    (DictMonad) ->
      indexableExceptT(DictMonad)
  end.

indexableExceptT(DictMonad) ->
  begin
    #{ bind := V } = control_monad_except_trans@ps:bindExceptT(DictMonad),
    #{ ix =>
       fun
         (#{ index := DictIndex }) ->
           fun
             (F) ->
               fun
                 (I) ->
                   (V(F))
                   (fun
                     (A) ->
                       (DictIndex(A))(I)
                   end)
               end
           end
       end
     }
  end.

indexableForeign() ->
  fun
    (DictMonad) ->
      indexableForeign(DictMonad)
  end.

indexableForeign(_) ->
  #{ ix =>
     fun
       (#{ index := DictIndex }) ->
         DictIndex
     end
   }.

hasPropertyImpl() ->
  fun
    (V) ->
      fun
        (V1) ->
          hasPropertyImpl(V, V1)
      end
  end.

hasPropertyImpl(V, V1) ->
  case foreign@foreign:isNull(V1) of
    true ->
      false;
    _ ->
      case foreign@foreign:isUndefined(V1) of
        true ->
          false;
        _ ->
          (((foreign@foreign:typeOf(V1)) =:= <<"object">>)
            orelse (((foreign@foreign:typeOf(V1)) =:= <<"function">>)
              orelse ((foreign@foreign:typeOf(V1)) =:= <<"map">>)))
            andalso ((foreign_index@foreign:unsafeHasProperty())(V, V1))
      end
  end.

hasProperty() ->
  fun
    (Dict) ->
      hasProperty(Dict)
  end.

hasProperty(#{ hasProperty := Dict }) ->
  Dict.

hasOwnPropertyImpl() ->
  fun
    (V) ->
      fun
        (V1) ->
          hasOwnPropertyImpl(V, V1)
      end
  end.

hasOwnPropertyImpl(V, V1) ->
  case foreign@foreign:isNull(V1) of
    true ->
      false;
    _ ->
      case foreign@foreign:isUndefined(V1) of
        true ->
          false;
        _ ->
          (((foreign@foreign:typeOf(V1)) =:= <<"object">>)
            orelse (((foreign@foreign:typeOf(V1)) =:= <<"function">>)
              orelse ((foreign@foreign:typeOf(V1)) =:= <<"map">>)))
            andalso ((foreign_index@foreign:unsafeHasOwnProperty())(V, V1))
      end
  end.

indexInt() ->
  fun
    (DictMonad) ->
      indexInt(DictMonad)
  end.

indexInt(DictMonad) ->
  #{ index =>
     begin
       V = unsafeReadProp(DictMonad),
       fun
         (B) ->
           fun
             (A) ->
               (V(A))(B)
           end
       end
     end
   , hasProperty => hasPropertyImpl()
   , hasOwnProperty => hasOwnPropertyImpl()
   , errorAt => foreign@ps:'ErrorAtIndex'()
   }.

indexString() ->
  fun
    (DictMonad) ->
      indexString(DictMonad)
  end.

indexString(DictMonad) ->
  #{ index =>
     begin
       V = unsafeReadProp(DictMonad),
       fun
         (B) ->
           fun
             (A) ->
               (V(A))(B)
           end
       end
     end
   , hasProperty => hasPropertyImpl()
   , hasOwnProperty => hasOwnPropertyImpl()
   , errorAt => foreign@ps:'ErrorAtProperty'()
   }.

hasOwnProperty() ->
  fun
    (Dict) ->
      hasOwnProperty(Dict)
  end.

hasOwnProperty(#{ hasOwnProperty := Dict }) ->
  Dict.

errorAt() ->
  fun
    (Dict) ->
      errorAt(Dict)
  end.

errorAt(#{ errorAt := Dict }) ->
  Dict.

unsafeReadPropImpl() ->
  foreign_index@foreign:unsafeReadPropImpl().

unsafeHasOwnProperty() ->
  foreign_index@foreign:unsafeHasOwnProperty().

unsafeHasProperty() ->
  foreign_index@foreign:unsafeHasProperty().

