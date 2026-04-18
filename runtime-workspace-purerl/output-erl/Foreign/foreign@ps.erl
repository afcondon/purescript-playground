-module(foreign@ps).
-export([ 'ForeignError'/0
        , 'TypeMismatch'/0
        , 'ErrorAtIndex'/0
        , 'ErrorAtProperty'/0
        , unsafeToForeign/0
        , unsafeFromForeign/0
        , showForeignError/0
        , renderForeignError/0
        , renderForeignError/1
        , readUndefined/0
        , readUndefined/1
        , readNullOrUndefined/0
        , readNullOrUndefined/1
        , readNull/0
        , readNull/1
        , fail/0
        , fail/2
        , readArray/0
        , readArray/2
        , unsafeReadTagged/0
        , unsafeReadTagged/3
        , readBoolean/0
        , readBoolean/1
        , readInt/0
        , readInt/1
        , readChar/0
        , readChar/2
        , readNumber/0
        , readNumber/1
        , readString/0
        , readString/1
        , eqForeignError/0
        , ordForeignError/0
        , typeOf/0
        , tagOf/0
        , isNull/0
        , isUndefined/0
        , isArray/0
        , unsafeToForeign/1
        , unsafeFromForeign/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'ForeignError'() ->
  fun
    (Value0) ->
      {foreignError, Value0}
  end.

'TypeMismatch'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {typeMismatch, Value0, Value1}
      end
  end.

'ErrorAtIndex'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {errorAtIndex, Value0, Value1}
      end
  end.

'ErrorAtProperty'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {errorAtProperty, Value0, Value1}
      end
  end.

unsafeToForeign() ->
  unsafe_coerce@ps:unsafeCoerce().

unsafeFromForeign() ->
  unsafe_coerce@ps:unsafeCoerce().

showForeignError() ->
  #{ show =>
     fun
       (V) ->
         case V of
           {foreignError, V@1} ->
             <<
               "(ForeignError ",
               (data_show@foreign:showStringImpl(V@1))/binary,
               ")"
             >>;
           {errorAtIndex, V@2, V@3} ->
             <<
               "(ErrorAtIndex ",
               (data_show@foreign:showIntImpl(V@2))/binary,
               " ",
               ((erlang:map_get(show, showForeignError()))(V@3))/binary,
               ")"
             >>;
           {errorAtProperty, V@4, V@5} ->
             <<
               "(ErrorAtProperty ",
               (data_show@foreign:showStringImpl(V@4))/binary,
               " ",
               ((erlang:map_get(show, showForeignError()))(V@5))/binary,
               ")"
             >>;
           {typeMismatch, V@6, V@7} ->
             <<
               "(TypeMismatch ",
               (data_show@foreign:showStringImpl(V@6))/binary,
               " ",
               (data_show@foreign:showStringImpl(V@7))/binary,
               ")"
             >>;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

renderForeignError() ->
  fun
    (V) ->
      renderForeignError(V)
  end.

renderForeignError(V) ->
  case V of
    {foreignError, V@1} ->
      V@1;
    {errorAtIndex, V@2, V@3} ->
      <<
        "Error at array index ",
        (data_show@foreign:showIntImpl(V@2))/binary,
        ": ",
        (renderForeignError(V@3))/binary
      >>;
    {errorAtProperty, V@4, V@5} ->
      <<
        "Error at property ",
        (data_show@foreign:showStringImpl(V@4))/binary,
        ": ",
        (renderForeignError(V@5))/binary
      >>;
    {typeMismatch, V@6, V@7} ->
      <<"Type mismatch: expected ", V@6/binary, ", found ", V@7/binary>>;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

readUndefined() ->
  fun
    (DictMonad) ->
      readUndefined(DictMonad)
  end.

readUndefined(DictMonad) ->
  begin
    #{ pure := V } = control_monad_except_trans@ps:applicativeExceptT(DictMonad),
    fun
      (Value) ->
        case foreign@foreign:isUndefined(Value) of
          true ->
            V({nothing});
          _ ->
            V({just, Value})
        end
    end
  end.

readNullOrUndefined() ->
  fun
    (DictMonad) ->
      readNullOrUndefined(DictMonad)
  end.

readNullOrUndefined(DictMonad) ->
  begin
    #{ pure := V } = control_monad_except_trans@ps:applicativeExceptT(DictMonad),
    fun
      (Value) ->
        case (foreign@foreign:isNull(Value))
            orelse (foreign@foreign:isUndefined(Value)) of
          true ->
            V({nothing});
          _ ->
            V({just, Value})
        end
    end
  end.

readNull() ->
  fun
    (DictMonad) ->
      readNull(DictMonad)
  end.

readNull(DictMonad) ->
  begin
    #{ pure := V } = control_monad_except_trans@ps:applicativeExceptT(DictMonad),
    fun
      (Value) ->
        case foreign@foreign:isNull(Value) of
          true ->
            V({nothing});
          _ ->
            V({just, Value})
        end
    end
  end.

fail() ->
  fun
    (DictMonad) ->
      fun
        (X) ->
          fail(DictMonad, X)
      end
  end.

fail(DictMonad, X) ->
  (erlang:map_get(
     throwError,
     control_monad_except_trans@ps:monadThrowExceptT(DictMonad)
   ))
  ({nonEmpty, X, {nil}}).

readArray() ->
  fun
    (DictMonad) ->
      fun
        (Value) ->
          readArray(DictMonad, Value)
      end
  end.

readArray(DictMonad, Value) ->
  case foreign@foreign:isArray(Value) of
    true ->
      (erlang:map_get(
         pure,
         control_monad_except_trans@ps:applicativeExceptT(DictMonad)
       ))
      (Value);
    _ ->
      (erlang:map_get(
         throwError,
         control_monad_except_trans@ps:monadThrowExceptT(DictMonad)
       ))
      ({ nonEmpty
       , {typeMismatch, <<"array">>, foreign@foreign:tagOf(Value)}
       , {nil}
       })
  end.

unsafeReadTagged() ->
  fun
    (DictMonad) ->
      fun
        (Tag) ->
          fun
            (Value) ->
              unsafeReadTagged(DictMonad, Tag, Value)
          end
      end
  end.

unsafeReadTagged(DictMonad, Tag, Value) ->
  case (foreign@foreign:tagOf(Value)) =:= Tag of
    true ->
      (erlang:map_get(
         pure,
         control_monad_except_trans@ps:applicativeExceptT(DictMonad)
       ))
      (Value);
    _ ->
      (erlang:map_get(
         throwError,
         control_monad_except_trans@ps:monadThrowExceptT(DictMonad)
       ))
      ({nonEmpty, {typeMismatch, Tag, foreign@foreign:tagOf(Value)}, {nil}})
  end.

readBoolean() ->
  fun
    (DictMonad) ->
      readBoolean(DictMonad)
  end.

readBoolean(DictMonad) ->
  ((unsafeReadTagged())(DictMonad))(<<"boolean">>).

readInt() ->
  fun
    (DictMonad) ->
      readInt(DictMonad)
  end.

readInt(DictMonad) ->
  ((unsafeReadTagged())(DictMonad))(<<"integer">>).

readChar() ->
  fun
    (DictMonad) ->
      fun
        (Value) ->
          readChar(DictMonad, Value)
      end
  end.

readChar(DictMonad = #{ 'Bind1' := DictMonad@1 }, Value) ->
  begin
    Error =
      { left
      , { nonEmpty
        , {typeMismatch, <<"Char">>, foreign@foreign:tagOf(Value)}
        , {nil}
        }
      },
    ((erlang:map_get(
        map,
        (erlang:map_get(
           'Functor0',
           (erlang:map_get('Apply0', DictMonad@1(undefined)))(undefined)
         ))
        (undefined)
      ))
     (fun
       (V2) ->
         case V2 of
           {left, _} ->
             Error;
           {right, V2@1} ->
             {right, data_enum@foreign:fromCharCode(V2@1)};
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end))
    (unsafeReadTagged(DictMonad, <<"integer">>, Value))
  end.

readNumber() ->
  fun
    (DictMonad) ->
      readNumber(DictMonad)
  end.

readNumber(DictMonad) ->
  ((unsafeReadTagged())(DictMonad))(<<"float">>).

readString() ->
  fun
    (DictMonad) ->
      readString(DictMonad)
  end.

readString(DictMonad) ->
  ((unsafeReadTagged())(DictMonad))(<<"binary">>).

eqForeignError() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {foreignError, _} ->
                 ?IS_KNOWN_TAG(foreignError, 1, Y)
                   andalso ((erlang:element(2, X)) =:= (erlang:element(2, Y)));
               {typeMismatch, _, _} ->
                 ?IS_KNOWN_TAG(typeMismatch, 2, Y)
                   andalso (((erlang:element(2, X)) =:= (erlang:element(2, Y)))
                     andalso ((erlang:element(3, X)) =:= (erlang:element(3, Y))));
               {errorAtIndex, _, _} ->
                 ?IS_KNOWN_TAG(errorAtIndex, 2, Y)
                   andalso (((erlang:element(2, X)) =:= (erlang:element(2, Y)))
                     andalso (((erlang:map_get(eq, eqForeignError()))
                               (erlang:element(3, X)))
                              (erlang:element(3, Y))));
               _ ->
                 ?IS_KNOWN_TAG(errorAtProperty, 2, X)
                   andalso (?IS_KNOWN_TAG(errorAtProperty, 2, Y)
                     andalso (((erlang:element(2, X))
                       =:= (erlang:element(2, Y)))
                       andalso (((erlang:map_get(eq, eqForeignError()))
                                 (erlang:element(3, X)))
                                (erlang:element(3, Y)))))
             end
         end
     end
   }.

ordForeignError() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {foreignError, _} ->
                 case Y of
                   {foreignError, Y@1} ->
                     begin
                       {foreignError, X@1} = X,
                       ((erlang:map_get(compare, data_ord@ps:ordString()))(X@1))
                       (Y@1)
                     end;
                   _ ->
                     {lT}
                 end;
               _ ->
                 case Y of
                   {foreignError, _} ->
                     {gT};
                   _ ->
                     case X of
                       {typeMismatch, _, _} ->
                         case Y of
                           {typeMismatch, Y@2, _} ->
                             begin
                               {typeMismatch, X@2, _} = X,
                               V =
                                 ((erlang:map_get(
                                     compare,
                                     data_ord@ps:ordString()
                                   ))
                                  (X@2))
                                 (Y@2),
                               case V of
                                 {lT} ->
                                   {lT};
                                 {gT} ->
                                   {gT};
                                 _ ->
                                   begin
                                     {typeMismatch, _, Y@3} = Y,
                                     {typeMismatch, _, X@3} = X,
                                     ((erlang:map_get(
                                         compare,
                                         data_ord@ps:ordString()
                                       ))
                                      (X@3))
                                     (Y@3)
                                   end
                               end
                             end;
                           _ ->
                             {lT}
                         end;
                       _ ->
                         case Y of
                           {typeMismatch, _, _} ->
                             {gT};
                           _ ->
                             case X of
                               {errorAtIndex, _, _} ->
                                 case Y of
                                   {errorAtIndex, Y@4, _} ->
                                     begin
                                       {errorAtIndex, X@4, _} = X,
                                       V@1 =
                                         ((erlang:map_get(
                                             compare,
                                             data_ord@ps:ordInt()
                                           ))
                                          (X@4))
                                         (Y@4),
                                       case V@1 of
                                         {lT} ->
                                           {lT};
                                         {gT} ->
                                           {gT};
                                         _ ->
                                           begin
                                             {errorAtIndex, _, Y@5} = Y,
                                             {errorAtIndex, _, X@5} = X,
                                             ((erlang:map_get(
                                                 compare,
                                                 ordForeignError()
                                               ))
                                              (X@5))
                                             (Y@5)
                                           end
                                       end
                                     end;
                                   _ ->
                                     {lT}
                                 end;
                               _ ->
                                 case Y of
                                   {errorAtIndex, _, _} ->
                                     {gT};
                                   _ ->
                                     if
                                       ?IS_KNOWN_TAG(errorAtProperty, 2, X)
                                         andalso ?IS_KNOWN_TAG(errorAtProperty, 2, Y) ->
                                         begin
                                           {errorAtProperty, Y@6, _} = Y,
                                           {errorAtProperty, X@6, _} = X,
                                           V@2 =
                                             ((erlang:map_get(
                                                 compare,
                                                 data_ord@ps:ordString()
                                               ))
                                              (X@6))
                                             (Y@6),
                                           case V@2 of
                                             {lT} ->
                                               {lT};
                                             {gT} ->
                                               {gT};
                                             _ ->
                                               begin
                                                 {errorAtProperty, _, Y@7} = Y,
                                                 {errorAtProperty, _, X@7} = X,
                                                 ((erlang:map_get(
                                                     compare,
                                                     ordForeignError()
                                                   ))
                                                  (X@7))
                                                 (Y@7)
                                               end
                                           end
                                         end;
                                       true ->
                                         erlang:error({ fail
                                                      , <<
                                                          "Failed pattern match"
                                                        >>
                                                      })
                                     end
                                 end
                             end
                         end
                     end
                 end
             end
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqForeignError()
     end
   }.

typeOf() ->
  fun
    (V) ->
      foreign@foreign:typeOf(V)
  end.

tagOf() ->
  fun
    (V) ->
      foreign@foreign:tagOf(V)
  end.

isNull() ->
  fun
    (V) ->
      foreign@foreign:isNull(V)
  end.

isUndefined() ->
  fun
    (V) ->
      foreign@foreign:isUndefined(V)
  end.

isArray() ->
  fun
    (V) ->
      foreign@foreign:isArray(V)
  end.

unsafeToForeign(V) ->
  V.

unsafeFromForeign(V) ->
  V.

