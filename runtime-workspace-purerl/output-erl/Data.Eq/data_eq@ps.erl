-module(data_eq@ps).
-export([ eqVoid/0
        , eqUnit/0
        , eqString/0
        , eqRowNil/0
        , eqRecord/0
        , eqRecord/1
        , eqRec/0
        , eqRec/2
        , eqProxy3/0
        , eqProxy2/0
        , eqProxy/0
        , eqNumber/0
        , eqInt/0
        , eqChar/0
        , eqBoolean/0
        , eq1/0
        , eq1/1
        , eq/0
        , eq/1
        , eqArray/0
        , eqArray/1
        , eq1Array/0
        , eqRowCons/0
        , eqRowCons/4
        , notEq/0
        , notEq/3
        , notEq1/0
        , notEq1/2
        , eqBooleanImpl/0
        , eqIntImpl/0
        , eqNumberImpl/0
        , eqCharImpl/0
        , eqStringImpl/0
        , eqArrayImpl/0
        ]).
-compile(no_auto_import).
eqVoid() ->
  #{ eq =>
     fun
       (_) ->
         fun
           (_) ->
             true
         end
     end
   }.

eqUnit() ->
  #{ eq =>
     fun
       (_) ->
         fun
           (_) ->
             true
         end
     end
   }.

eqString() ->
  #{ eq => eqStringImpl() }.

eqRowNil() ->
  #{ eqRecord =>
     fun
       (_) ->
         fun
           (_) ->
             fun
               (_) ->
                 true
             end
         end
     end
   }.

eqRecord() ->
  fun
    (Dict) ->
      eqRecord(Dict)
  end.

eqRecord(#{ eqRecord := Dict }) ->
  Dict.

eqRec() ->
  fun
    (V) ->
      fun
        (DictEqRecord) ->
          eqRec(V, DictEqRecord)
      end
  end.

eqRec(_, #{ eqRecord := DictEqRecord }) ->
  #{ eq => DictEqRecord({proxy}) }.

eqProxy3() ->
  #{ eq =>
     fun
       (_) ->
         fun
           (_) ->
             true
         end
     end
   }.

eqProxy2() ->
  #{ eq =>
     fun
       (_) ->
         fun
           (_) ->
             true
         end
     end
   }.

eqProxy() ->
  #{ eq =>
     fun
       (_) ->
         fun
           (_) ->
             true
         end
     end
   }.

eqNumber() ->
  #{ eq => eqNumberImpl() }.

eqInt() ->
  #{ eq => eqIntImpl() }.

eqChar() ->
  #{ eq => eqCharImpl() }.

eqBoolean() ->
  #{ eq => eqBooleanImpl() }.

eq1() ->
  fun
    (Dict) ->
      eq1(Dict)
  end.

eq1(#{ eq1 := Dict }) ->
  Dict.

eq() ->
  fun
    (Dict) ->
      eq(Dict)
  end.

eq(#{ eq := Dict }) ->
  Dict.

eqArray() ->
  fun
    (DictEq) ->
      eqArray(DictEq)
  end.

eqArray(#{ eq := DictEq }) ->
  #{ eq => (eqArrayImpl())(DictEq) }.

eq1Array() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         (eqArrayImpl())(DictEq)
     end
   }.

eqRowCons() ->
  fun
    (DictEqRecord) ->
      fun
        (V) ->
          fun
            (DictIsSymbol) ->
              fun
                (DictEq) ->
                  eqRowCons(DictEqRecord, V, DictIsSymbol, DictEq)
              end
          end
      end
  end.

eqRowCons( DictEqRecord
         , _
         , #{ reflectSymbol := DictIsSymbol }
         , #{ eq := DictEq }
         ) ->
  #{ eqRecord =>
     fun
       (_) ->
         fun
           (Ra) ->
             fun
               (Rb) ->
                 begin
                   Get = (record_unsafe@ps:unsafeGet())(DictIsSymbol({proxy})),
                   ((DictEq(Get(Ra)))(Get(Rb)))
                     andalso ((((erlang:map_get(eqRecord, DictEqRecord))
                                ({proxy}))
                               (Ra))
                              (Rb))
                 end
             end
         end
     end
   }.

notEq() ->
  fun
    (DictEq) ->
      fun
        (X) ->
          fun
            (Y) ->
              notEq(DictEq, X, Y)
          end
      end
  end.

notEq(#{ eq := DictEq }, X, Y) ->
  not ((DictEq(X))(Y)).

notEq1() ->
  fun
    (DictEq1) ->
      fun
        (DictEq) ->
          notEq1(DictEq1, DictEq)
      end
  end.

notEq1(#{ eq1 := DictEq1 }, DictEq) ->
  begin
    Eq12 = DictEq1(DictEq),
    fun
      (X) ->
        fun
          (Y) ->
            not ((Eq12(X))(Y))
        end
    end
  end.

eqBooleanImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_eq@foreign:eqBooleanImpl(V, V@1)
      end
  end.

eqIntImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_eq@foreign:eqIntImpl(V, V@1)
      end
  end.

eqNumberImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_eq@foreign:eqNumberImpl(V, V@1)
      end
  end.

eqCharImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_eq@foreign:eqCharImpl(V, V@1)
      end
  end.

eqStringImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_eq@foreign:eqStringImpl(V, V@1)
      end
  end.

eqArrayImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_eq@foreign:eqArrayImpl(V, V@1, V@2)
          end
      end
  end.

