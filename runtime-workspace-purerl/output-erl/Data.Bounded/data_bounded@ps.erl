-module(data_bounded@ps).
-export([ topRecord/0
        , topRecord/1
        , top/0
        , top/1
        , boundedUnit/0
        , boundedRecordNil/0
        , boundedProxy3/0
        , boundedProxy2/0
        , boundedProxy/0
        , boundedOrdering/0
        , boundedChar/0
        , boundedBoolean/0
        , bottomRecord/0
        , bottomRecord/1
        , boundedRecord/0
        , boundedRecord/2
        , bottom/0
        , bottom/1
        , boundedRecordCons/0
        , boundedRecordCons/2
        , topChar/0
        , bottomChar/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
topRecord() ->
  fun
    (Dict) ->
      topRecord(Dict)
  end.

topRecord(#{ topRecord := Dict }) ->
  Dict.

top() ->
  fun
    (Dict) ->
      top(Dict)
  end.

top(#{ top := Dict }) ->
  Dict.

boundedUnit() ->
  #{ top => unit
   , bottom => unit
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordUnit()
     end
   }.

boundedRecordNil() ->
  #{ topRecord =>
     fun
       (_) ->
         fun
           (_) ->
             #{}
         end
     end
   , bottomRecord =>
     fun
       (_) ->
         fun
           (_) ->
             #{}
         end
     end
   , 'OrdRecord0' =>
     fun
       (_) ->
         data_ord@ps:ordRecordNil()
     end
   }.

boundedProxy3() ->
  #{ bottom => {proxy3}
   , top => {proxy3}
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordProxy3()
     end
   }.

boundedProxy2() ->
  #{ bottom => {proxy2}
   , top => {proxy2}
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordProxy2()
     end
   }.

boundedProxy() ->
  #{ bottom => {proxy}
   , top => {proxy}
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordProxy()
     end
   }.

boundedOrdering() ->
  #{ top => {gT}
   , bottom => {lT}
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordOrdering()
     end
   }.

boundedChar() ->
  #{ top => data_bounded@foreign:topChar()
   , bottom => data_bounded@foreign:bottomChar()
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordChar()
     end
   }.

boundedBoolean() ->
  #{ top => true
   , bottom => false
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordBoolean()
     end
   }.

bottomRecord() ->
  fun
    (Dict) ->
      bottomRecord(Dict)
  end.

bottomRecord(#{ bottomRecord := Dict }) ->
  Dict.

boundedRecord() ->
  fun
    (V) ->
      fun
        (DictBoundedRecord) ->
          boundedRecord(V, DictBoundedRecord)
      end
  end.

boundedRecord( _
             , #{ 'OrdRecord0' := DictBoundedRecord
                , bottomRecord := DictBoundedRecord@1
                , topRecord := DictBoundedRecord@2
                }
             ) ->
  begin
    #{ 'EqRecord0' := V, compareRecord := V@1 } = DictBoundedRecord(undefined),
    EqRec1 = #{ eq => (erlang:map_get(eqRecord, V(undefined)))({proxy}) },
    OrdRecord1 =
      #{ compare => V@1({proxy})
       , 'Eq0' =>
         fun
           (_) ->
             EqRec1
         end
       },
    #{ top => (DictBoundedRecord@2({proxy}))({proxy})
     , bottom => (DictBoundedRecord@1({proxy}))({proxy})
     , 'Ord0' =>
       fun
         (_) ->
           OrdRecord1
       end
     }
  end.

bottom() ->
  fun
    (Dict) ->
      bottom(Dict)
  end.

bottom(#{ bottom := Dict }) ->
  Dict.

boundedRecordCons() ->
  fun
    (DictIsSymbol) ->
      fun
        (DictBounded) ->
          boundedRecordCons(DictIsSymbol, DictBounded)
      end
  end.

boundedRecordCons( #{ reflectSymbol := DictIsSymbol }
                 , #{ 'Ord0' := DictBounded
                    , bottom := DictBounded@1
                    , top := DictBounded@2
                    }
                 ) ->
  begin
    #{ 'Eq0' := Ord0, compare := Ord0@1 } = DictBounded(undefined),
    fun
      (_) ->
        fun
          (_) ->
            fun
              (#{ 'OrdRecord0' := DictBoundedRecord
                , bottomRecord := DictBoundedRecord@1
                , topRecord := DictBoundedRecord@2
                }) ->
                begin
                  V = #{ 'EqRecord0' := V@1 } = DictBoundedRecord(undefined),
                  V@2 = V@1(undefined),
                  #{ eq := V@3 } = Ord0(undefined),
                  OrdRecordCons =
                    begin
                      EqRowCons2 =
                        #{ eqRecord =>
                           fun
                             (_) ->
                               fun
                                 (Ra) ->
                                   fun
                                     (Rb) ->
                                       begin
                                         Get =
                                           (record_unsafe@ps:unsafeGet())
                                           (DictIsSymbol({proxy})),
                                         ((V@3(Get(Ra)))(Get(Rb)))
                                           andalso ((((erlang:map_get(
                                                         eqRecord,
                                                         V@2
                                                       ))
                                                      ({proxy}))
                                                     (Ra))
                                                    (Rb))
                                       end
                                   end
                               end
                           end
                         },
                      #{ compareRecord =>
                         fun
                           (_) ->
                             fun
                               (Ra) ->
                                 fun
                                   (Rb) ->
                                     begin
                                       Key = DictIsSymbol({proxy}),
                                       Left =
                                         (Ord0@1(record_unsafe@foreign:unsafeGet(
                                                   Key,
                                                   Ra
                                                 )))
                                         (record_unsafe@foreign:unsafeGet(
                                            Key,
                                            Rb
                                          )),
                                       if
                                         ?IS_KNOWN_TAG(lT, 0, Left)
                                           orelse (?IS_KNOWN_TAG(gT, 0, Left)
                                             orelse (not ?IS_KNOWN_TAG(eQ, 0, Left))) ->
                                           Left;
                                         true ->
                                           begin
                                             #{ compareRecord := V@4 } = V,
                                             ((V@4({proxy}))(Ra))(Rb)
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
                    end,
                  #{ topRecord =>
                     fun
                       (_) ->
                         fun
                           (RowProxy) ->
                             record_unsafe@foreign:unsafeSet(
                               DictIsSymbol({proxy}),
                               DictBounded@2,
                               (DictBoundedRecord@2({proxy}))(RowProxy)
                             )
                         end
                     end
                   , bottomRecord =>
                     fun
                       (_) ->
                         fun
                           (RowProxy) ->
                             record_unsafe@foreign:unsafeSet(
                               DictIsSymbol({proxy}),
                               DictBounded@1,
                               (DictBoundedRecord@1({proxy}))(RowProxy)
                             )
                         end
                     end
                   , 'OrdRecord0' =>
                     fun
                       (_) ->
                         OrdRecordCons
                     end
                   }
                end
            end
        end
    end
  end.

topChar() ->
  data_bounded@foreign:topChar().

bottomChar() ->
  data_bounded@foreign:bottomChar().

