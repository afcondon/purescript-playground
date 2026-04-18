-module(data_ord@ps).
-export([ ordVoid/0
        , ordUnit/0
        , ordString/0
        , ordRecordNil/0
        , ordProxy3/0
        , ordProxy2/0
        , ordProxy/0
        , ordOrdering/0
        , ordNumber/0
        , ordInt/0
        , ordChar/0
        , ordBoolean/0
        , compareRecord/0
        , compareRecord/1
        , ordRecord/0
        , ordRecord/2
        , compare1/0
        , compare1/1
        , compare/0
        , compare/1
        , comparing/0
        , comparing/4
        , greaterThan/0
        , greaterThan/3
        , greaterThanOrEq/0
        , greaterThanOrEq/3
        , signum/0
        , signum/2
        , lessThan/0
        , lessThan/3
        , lessThanOrEq/0
        , lessThanOrEq/3
        , max/0
        , max/3
        , min/0
        , min/3
        , ordArray/0
        , ordArray/1
        , ord1Array/0
        , ordRecordCons/0
        , ordRecordCons/1
        , clamp/0
        , clamp/4
        , between/0
        , between/4
        , abs/0
        , abs/2
        , ordBooleanImpl/0
        , ordIntImpl/0
        , ordNumberImpl/0
        , ordStringImpl/0
        , ordCharImpl/0
        , ordArrayImpl/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
ordVoid() ->
  #{ compare =>
     fun
       (_) ->
         fun
           (_) ->
             {eQ}
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqVoid()
     end
   }.

ordUnit() ->
  #{ compare =>
     fun
       (_) ->
         fun
           (_) ->
             {eQ}
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqUnit()
     end
   }.

ordString() ->
  #{ compare => (((ordStringImpl())({lT}))({eQ}))({gT})
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqString()
     end
   }.

ordRecordNil() ->
  #{ compareRecord =>
     fun
       (_) ->
         fun
           (_) ->
             fun
               (_) ->
                 {eQ}
             end
         end
     end
   , 'EqRecord0' =>
     fun
       (_) ->
         data_eq@ps:eqRowNil()
     end
   }.

ordProxy3() ->
  #{ compare =>
     fun
       (_) ->
         fun
           (_) ->
             {eQ}
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqProxy3()
     end
   }.

ordProxy2() ->
  #{ compare =>
     fun
       (_) ->
         fun
           (_) ->
             {eQ}
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqProxy2()
     end
   }.

ordProxy() ->
  #{ compare =>
     fun
       (_) ->
         fun
           (_) ->
             {eQ}
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqProxy()
     end
   }.

ordOrdering() ->
  #{ compare =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {lT} ->
                 case V1 of
                   {lT} ->
                     {eQ};
                   _ ->
                     {lT}
                 end;
               {eQ} ->
                 case V1 of
                   {eQ} ->
                     {eQ};
                   {lT} ->
                     {gT};
                   {gT} ->
                     {lT};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end;
               {gT} ->
                 case V1 of
                   {gT} ->
                     {eQ};
                   _ ->
                     {gT}
                 end;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         data_ordering@ps:eqOrdering()
     end
   }.

ordNumber() ->
  #{ compare => (((ordNumberImpl())({lT}))({eQ}))({gT})
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqNumber()
     end
   }.

ordInt() ->
  #{ compare => (((ordIntImpl())({lT}))({eQ}))({gT})
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqInt()
     end
   }.

ordChar() ->
  #{ compare => (((ordCharImpl())({lT}))({eQ}))({gT})
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqChar()
     end
   }.

ordBoolean() ->
  #{ compare => (((ordBooleanImpl())({lT}))({eQ}))({gT})
   , 'Eq0' =>
     fun
       (_) ->
         data_eq@ps:eqBoolean()
     end
   }.

compareRecord() ->
  fun
    (Dict) ->
      compareRecord(Dict)
  end.

compareRecord(#{ compareRecord := Dict }) ->
  Dict.

ordRecord() ->
  fun
    (V) ->
      fun
        (DictOrdRecord) ->
          ordRecord(V, DictOrdRecord)
      end
  end.

ordRecord( _
         , #{ 'EqRecord0' := DictOrdRecord, compareRecord := DictOrdRecord@1 }
         ) ->
  begin
    EqRec1 =
      #{ eq => (erlang:map_get(eqRecord, DictOrdRecord(undefined)))({proxy}) },
    #{ compare => DictOrdRecord@1({proxy})
     , 'Eq0' =>
       fun
         (_) ->
           EqRec1
       end
     }
  end.

compare1() ->
  fun
    (Dict) ->
      compare1(Dict)
  end.

compare1(#{ compare1 := Dict }) ->
  Dict.

compare() ->
  fun
    (Dict) ->
      compare(Dict)
  end.

compare(#{ compare := Dict }) ->
  Dict.

comparing() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          fun
            (X) ->
              fun
                (Y) ->
                  comparing(DictOrd, F, X, Y)
              end
          end
      end
  end.

comparing(#{ compare := DictOrd }, F, X, Y) ->
  (DictOrd(F(X)))(F(Y)).

greaterThan() ->
  fun
    (DictOrd) ->
      fun
        (A1) ->
          fun
            (A2) ->
              greaterThan(DictOrd, A1, A2)
          end
      end
  end.

greaterThan(#{ compare := DictOrd }, A1, A2) ->
  begin
    V = (DictOrd(A1))(A2),
    ?IS_KNOWN_TAG(gT, 0, V)
  end.

greaterThanOrEq() ->
  fun
    (DictOrd) ->
      fun
        (A1) ->
          fun
            (A2) ->
              greaterThanOrEq(DictOrd, A1, A2)
          end
      end
  end.

greaterThanOrEq(#{ compare := DictOrd }, A1, A2) ->
  not begin
    V = (DictOrd(A1))(A2),
    ?IS_KNOWN_TAG(lT, 0, V)
  end.

signum() ->
  fun
    (DictOrd) ->
      fun
        (DictRing) ->
          signum(DictOrd, DictRing)
      end
  end.

signum(#{ compare := DictOrd }, DictRing = #{ 'Semiring0' := DictRing@1 }) ->
  begin
    #{ one := Semiring0, zero := Semiring0@1 } = DictRing@1(undefined),
    Zero = erlang:map_get(zero, DictRing@1(undefined)),
    fun
      (X) ->
        case not begin
            V = (DictOrd(X))(Semiring0@1),
            ?IS_KNOWN_TAG(lT, 0, V)
          end of
          true ->
            Semiring0;
          _ ->
            begin
              #{ sub := DictRing@2 } = DictRing,
              (DictRing@2(Zero))(Semiring0)
            end
        end
    end
  end.

lessThan() ->
  fun
    (DictOrd) ->
      fun
        (A1) ->
          fun
            (A2) ->
              lessThan(DictOrd, A1, A2)
          end
      end
  end.

lessThan(#{ compare := DictOrd }, A1, A2) ->
  begin
    V = (DictOrd(A1))(A2),
    ?IS_KNOWN_TAG(lT, 0, V)
  end.

lessThanOrEq() ->
  fun
    (DictOrd) ->
      fun
        (A1) ->
          fun
            (A2) ->
              lessThanOrEq(DictOrd, A1, A2)
          end
      end
  end.

lessThanOrEq(#{ compare := DictOrd }, A1, A2) ->
  not begin
    V = (DictOrd(A1))(A2),
    ?IS_KNOWN_TAG(gT, 0, V)
  end.

max() ->
  fun
    (DictOrd) ->
      fun
        (X) ->
          fun
            (Y) ->
              max(DictOrd, X, Y)
          end
      end
  end.

max(#{ compare := DictOrd }, X, Y) ->
  begin
    V = (DictOrd(X))(Y),
    case V of
      {lT} ->
        Y;
      {eQ} ->
        X;
      {gT} ->
        X;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

min() ->
  fun
    (DictOrd) ->
      fun
        (X) ->
          fun
            (Y) ->
              min(DictOrd, X, Y)
          end
      end
  end.

min(#{ compare := DictOrd }, X, Y) ->
  begin
    V = (DictOrd(X))(Y),
    case V of
      {lT} ->
        X;
      {eQ} ->
        X;
      {gT} ->
        Y;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

ordArray() ->
  fun
    (DictOrd) ->
      ordArray(DictOrd)
  end.

ordArray(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    EqArray =
      #{ eq =>
         (data_eq@ps:eqArrayImpl())(erlang:map_get(eq, DictOrd(undefined)))
       },
    #{ compare =>
       fun
         (Xs) ->
           fun
             (Ys) ->
               ((erlang:map_get(compare, ordInt()))(0))
               (((data_ord@foreign:ordArrayImpl(fun
                    (X) ->
                      fun
                        (Y) ->
                          begin
                            V = (DictOrd@1(X))(Y),
                            case V of
                              {eQ} ->
                                0;
                              {lT} ->
                                1;
                              {gT} ->
                                -1;
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end
                          end
                      end
                  end))
                 (Xs))
                (Ys))
           end
       end
     , 'Eq0' =>
       fun
         (_) ->
           EqArray
       end
     }
  end.

ord1Array() ->
  #{ compare1 =>
     fun
       (DictOrd) ->
         erlang:map_get(compare, ordArray(DictOrd))
     end
   , 'Eq10' =>
     fun
       (_) ->
         data_eq@ps:eq1Array()
     end
   }.

ordRecordCons() ->
  fun
    (DictOrdRecord) ->
      ordRecordCons(DictOrdRecord)
  end.

ordRecordCons(DictOrdRecord = #{ 'EqRecord0' := DictOrdRecord@1 }) ->
  begin
    EqRowCons =
      ((data_eq@ps:eqRowCons())(DictOrdRecord@1(undefined)))(undefined),
    fun
      (_) ->
        fun
          (DictIsSymbol = #{ reflectSymbol := DictIsSymbol@1 }) ->
            begin
              EqRowCons1 = EqRowCons(DictIsSymbol),
              fun
                (#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
                  begin
                    EqRowCons2 = EqRowCons1(DictOrd(undefined)),
                    #{ compareRecord =>
                       fun
                         (_) ->
                           fun
                             (Ra) ->
                               fun
                                 (Rb) ->
                                   begin
                                     Key = DictIsSymbol@1({proxy}),
                                     Left =
                                       (DictOrd@1(record_unsafe@foreign:unsafeGet(
                                                    Key,
                                                    Ra
                                                  )))
                                       (record_unsafe@foreign:unsafeGet(Key, Rb)),
                                     if
                                       ?IS_KNOWN_TAG(lT, 0, Left)
                                         orelse (?IS_KNOWN_TAG(gT, 0, Left)
                                           orelse (not ?IS_KNOWN_TAG(eQ, 0, Left))) ->
                                         Left;
                                       true ->
                                         begin
                                           #{ compareRecord := DictOrdRecord@2 } =
                                             DictOrdRecord,
                                           ((DictOrdRecord@2({proxy}))(Ra))(Rb)
                                         end
                                     end
                                   end
                               end
                           end
                       end
                     , 'EqRecord0' =>
                       fun
                         (_) ->
                           EqRowCons2
                       end
                     }
                  end
              end
            end
        end
    end
  end.

clamp() ->
  fun
    (DictOrd) ->
      fun
        (Low) ->
          fun
            (Hi) ->
              fun
                (X) ->
                  clamp(DictOrd, Low, Hi, X)
              end
          end
      end
  end.

clamp(#{ compare := DictOrd }, Low, Hi, X) ->
  begin
    V = (DictOrd(Low))(X),
    V@1 =
      case V of
        {lT} ->
          X;
        {eQ} ->
          Low;
        {gT} ->
          Low;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end,
    V@2 = (DictOrd(Hi))(V@1),
    case V@2 of
      {lT} ->
        Hi;
      {eQ} ->
        Hi;
      {gT} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

between() ->
  fun
    (DictOrd) ->
      fun
        (Low) ->
          fun
            (Hi) ->
              fun
                (X) ->
                  between(DictOrd, Low, Hi, X)
              end
          end
      end
  end.

between(DictOrd = #{ compare := DictOrd@1 }, Low, Hi, X) ->
  begin
    V = (DictOrd@1(X))(Low),
    case ?IS_KNOWN_TAG(lT, 0, V) of
      true ->
        false;
      _ ->
        begin
          #{ compare := DictOrd@2 } = DictOrd,
          not begin
            V@1 = (DictOrd@2(X))(Hi),
            ?IS_KNOWN_TAG(gT, 0, V@1)
          end
        end
    end
  end.

abs() ->
  fun
    (DictOrd) ->
      fun
        (DictRing) ->
          abs(DictOrd, DictRing)
      end
  end.

abs(#{ compare := DictOrd }, DictRing = #{ 'Semiring0' := DictRing@1 }) ->
  begin
    Zero = erlang:map_get(zero, DictRing@1(undefined)),
    Zero@1 = erlang:map_get(zero, DictRing@1(undefined)),
    fun
      (X) ->
        case not begin
            V = (DictOrd(X))(Zero),
            ?IS_KNOWN_TAG(lT, 0, V)
          end of
          true ->
            X;
          _ ->
            begin
              #{ sub := DictRing@2 } = DictRing,
              (DictRing@2(Zero@1))(X)
            end
        end
    end
  end.

ordBooleanImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      data_ord@foreign:ordBooleanImpl(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

ordIntImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      data_ord@foreign:ordIntImpl(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

ordNumberImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      data_ord@foreign:ordNumberImpl(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

ordStringImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      data_ord@foreign:ordStringImpl(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

ordCharImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      data_ord@foreign:ordCharImpl(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

ordArrayImpl() ->
  fun
    (V) ->
      data_ord@foreign:ordArrayImpl(V)
  end.

