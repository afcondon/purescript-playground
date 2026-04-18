-module(data_show@ps).
-export([ showString/0
        , showRecordFieldsNil/0
        , showRecordFields/0
        , showRecordFields/1
        , showRecord/0
        , showRecord/2
        , showProxy3/0
        , showProxy2/0
        , showProxy/0
        , showNumber/0
        , showInt/0
        , showChar/0
        , showBoolean/0
        , show/0
        , show/1
        , showArray/0
        , showArray/1
        , showRecordFieldsCons/0
        , showRecordFieldsCons/3
        , showIntImpl/0
        , showNumberImpl/0
        , showCharImpl/0
        , showStringImpl/0
        , showArrayImpl/0
        , cons/0
        , join/0
        ]).
-compile(no_auto_import).
showString() ->
  #{ show => showStringImpl() }.

showRecordFieldsNil() ->
  #{ showRecordFields =>
     fun
       (_) ->
         fun
           (_) ->
             array:from_list([])
         end
     end
   }.

showRecordFields() ->
  fun
    (Dict) ->
      showRecordFields(Dict)
  end.

showRecordFields(#{ showRecordFields := Dict }) ->
  Dict.

showRecord() ->
  fun
    (V) ->
      fun
        (DictShowRecordFields) ->
          showRecord(V, DictShowRecordFields)
      end
  end.

showRecord(_, #{ showRecordFields := DictShowRecordFields }) ->
  #{ show =>
     fun
       (Record) ->
         begin
           V = (DictShowRecordFields({proxy}))(Record),
           case (array:size(V)) =:= 0 of
             true ->
               <<"{}">>;
             _ ->
               data_show@foreign:join(
                 <<" ">>,
                 array:from_list([ <<"{">>
                                 , data_show@foreign:join(<<", ">>, V)
                                 , <<"}">>
                                 ])
               )
           end
         end
     end
   }.

showProxy3() ->
  #{ show =>
     fun
       (_) ->
         <<"Proxy3">>
     end
   }.

showProxy2() ->
  #{ show =>
     fun
       (_) ->
         <<"Proxy2">>
     end
   }.

showProxy() ->
  #{ show =>
     fun
       (_) ->
         <<"Proxy">>
     end
   }.

showNumber() ->
  #{ show => showNumberImpl() }.

showInt() ->
  #{ show => showIntImpl() }.

showChar() ->
  #{ show => showCharImpl() }.

showBoolean() ->
  #{ show =>
     fun
       (V) ->
         if
           V ->
             <<"true">>;
           true ->
             <<"false">>
         end
     end
   }.

show() ->
  fun
    (Dict) ->
      show(Dict)
  end.

show(#{ show := Dict }) ->
  Dict.

showArray() ->
  fun
    (DictShow) ->
      showArray(DictShow)
  end.

showArray(#{ show := DictShow }) ->
  #{ show => (showArrayImpl())(DictShow) }.

showRecordFieldsCons() ->
  fun
    (DictIsSymbol) ->
      fun
        (DictShowRecordFields) ->
          fun
            (DictShow) ->
              showRecordFieldsCons(DictIsSymbol, DictShowRecordFields, DictShow)
          end
      end
  end.

showRecordFieldsCons( #{ reflectSymbol := DictIsSymbol }
                    , #{ showRecordFields := DictShowRecordFields }
                    , #{ show := DictShow }
                    ) ->
  #{ showRecordFields =>
     fun
       (_) ->
         fun
           (Record) ->
             begin
               Key = DictIsSymbol({proxy}),
               data_show@foreign:cons(
                 data_show@foreign:join(
                   <<": ">>,
                   array:from_list([ Key
                                   , DictShow(record_unsafe@foreign:unsafeGet(
                                                Key,
                                                Record
                                              ))
                                   ])
                 ),
                 (DictShowRecordFields({proxy}))(Record)
               )
             end
         end
     end
   }.

showIntImpl() ->
  fun
    (V) ->
      data_show@foreign:showIntImpl(V)
  end.

showNumberImpl() ->
  fun
    (V) ->
      data_show@foreign:showNumberImpl(V)
  end.

showCharImpl() ->
  fun
    (V) ->
      data_show@foreign:showCharImpl(V)
  end.

showStringImpl() ->
  fun
    (V) ->
      data_show@foreign:showStringImpl(V)
  end.

showArrayImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_show@foreign:showArrayImpl(V, V@1)
      end
  end.

cons() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_show@foreign:cons(V, V@1)
      end
  end.

join() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_show@foreign:join(V, V@1)
      end
  end.

