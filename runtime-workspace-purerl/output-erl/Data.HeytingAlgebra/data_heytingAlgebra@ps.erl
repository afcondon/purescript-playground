-module(data_heytingAlgebra@ps).
-export([ ttRecord/0
        , ttRecord/1
        , tt/0
        , tt/1
        , notRecord/0
        , notRecord/1
        , 'not'/0
        , 'not'/1
        , impliesRecord/0
        , impliesRecord/1
        , implies/0
        , implies/1
        , heytingAlgebraUnit/0
        , heytingAlgebraRecordNil/0
        , heytingAlgebraProxy3/0
        , heytingAlgebraProxy2/0
        , heytingAlgebraProxy/0
        , ffRecord/0
        , ffRecord/1
        , ff/0
        , ff/1
        , disjRecord/0
        , disjRecord/1
        , disj/0
        , disj/1
        , heytingAlgebraBoolean/0
        , conjRecord/0
        , conjRecord/1
        , heytingAlgebraRecord/0
        , heytingAlgebraRecord/2
        , conj/0
        , conj/1
        , heytingAlgebraFunction/0
        , heytingAlgebraFunction/1
        , heytingAlgebraRecordCons/0
        , heytingAlgebraRecordCons/4
        , boolConj/0
        , boolDisj/0
        , boolNot/0
        ]).
-compile(no_auto_import).
ttRecord() ->
  fun
    (Dict) ->
      ttRecord(Dict)
  end.

ttRecord(#{ ttRecord := Dict }) ->
  Dict.

tt() ->
  fun
    (Dict) ->
      tt(Dict)
  end.

tt(#{ tt := Dict }) ->
  Dict.

notRecord() ->
  fun
    (Dict) ->
      notRecord(Dict)
  end.

notRecord(#{ notRecord := Dict }) ->
  Dict.

'not'() ->
  fun
    (Dict) ->
      'not'(Dict)
  end.

'not'(#{ 'not' := Dict }) ->
  Dict.

impliesRecord() ->
  fun
    (Dict) ->
      impliesRecord(Dict)
  end.

impliesRecord(#{ impliesRecord := Dict }) ->
  Dict.

implies() ->
  fun
    (Dict) ->
      implies(Dict)
  end.

implies(#{ implies := Dict }) ->
  Dict.

heytingAlgebraUnit() ->
  #{ ff => unit
   , tt => unit
   , implies =>
     fun
       (_) ->
         fun
           (_) ->
             unit
         end
     end
   , conj =>
     fun
       (_) ->
         fun
           (_) ->
             unit
         end
     end
   , disj =>
     fun
       (_) ->
         fun
           (_) ->
             unit
         end
     end
   , 'not' =>
     fun
       (_) ->
         unit
     end
   }.

heytingAlgebraRecordNil() ->
  #{ conjRecord =>
     fun
       (_) ->
         fun
           (_) ->
             fun
               (_) ->
                 #{}
             end
         end
     end
   , disjRecord =>
     fun
       (_) ->
         fun
           (_) ->
             fun
               (_) ->
                 #{}
             end
         end
     end
   , ffRecord =>
     fun
       (_) ->
         fun
           (_) ->
             #{}
         end
     end
   , impliesRecord =>
     fun
       (_) ->
         fun
           (_) ->
             fun
               (_) ->
                 #{}
             end
         end
     end
   , notRecord =>
     fun
       (_) ->
         fun
           (_) ->
             #{}
         end
     end
   , ttRecord =>
     fun
       (_) ->
         fun
           (_) ->
             #{}
         end
     end
   }.

heytingAlgebraProxy3() ->
  #{ conj =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy3}
         end
     end
   , disj =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy3}
         end
     end
   , implies =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy3}
         end
     end
   , ff => {proxy3}
   , 'not' =>
     fun
       (_) ->
         {proxy3}
     end
   , tt => {proxy3}
   }.

heytingAlgebraProxy2() ->
  #{ conj =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy2}
         end
     end
   , disj =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy2}
         end
     end
   , implies =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy2}
         end
     end
   , ff => {proxy2}
   , 'not' =>
     fun
       (_) ->
         {proxy2}
     end
   , tt => {proxy2}
   }.

heytingAlgebraProxy() ->
  #{ conj =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   , disj =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   , implies =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   , ff => {proxy}
   , 'not' =>
     fun
       (_) ->
         {proxy}
     end
   , tt => {proxy}
   }.

ffRecord() ->
  fun
    (Dict) ->
      ffRecord(Dict)
  end.

ffRecord(#{ ffRecord := Dict }) ->
  Dict.

ff() ->
  fun
    (Dict) ->
      ff(Dict)
  end.

ff(#{ ff := Dict }) ->
  Dict.

disjRecord() ->
  fun
    (Dict) ->
      disjRecord(Dict)
  end.

disjRecord(#{ disjRecord := Dict }) ->
  Dict.

disj() ->
  fun
    (Dict) ->
      disj(Dict)
  end.

disj(#{ disj := Dict }) ->
  Dict.

heytingAlgebraBoolean() ->
  #{ ff => false
   , tt => true
   , implies =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               V = heytingAlgebraBoolean(),
               ((erlang:map_get(disj, V))((erlang:map_get('not', V))(A)))(B)
             end
         end
     end
   , conj => boolConj()
   , disj => boolDisj()
   , 'not' => boolNot()
   }.

conjRecord() ->
  fun
    (Dict) ->
      conjRecord(Dict)
  end.

conjRecord(#{ conjRecord := Dict }) ->
  Dict.

heytingAlgebraRecord() ->
  fun
    (V) ->
      fun
        (DictHeytingAlgebraRecord) ->
          heytingAlgebraRecord(V, DictHeytingAlgebraRecord)
      end
  end.

heytingAlgebraRecord( _
                    , #{ conjRecord := DictHeytingAlgebraRecord
                       , disjRecord := DictHeytingAlgebraRecord@1
                       , ffRecord := DictHeytingAlgebraRecord@2
                       , impliesRecord := DictHeytingAlgebraRecord@3
                       , notRecord := DictHeytingAlgebraRecord@4
                       , ttRecord := DictHeytingAlgebraRecord@5
                       }
                    ) ->
  #{ ff => (DictHeytingAlgebraRecord@2({proxy}))({proxy})
   , tt => (DictHeytingAlgebraRecord@5({proxy}))({proxy})
   , conj => DictHeytingAlgebraRecord({proxy})
   , disj => DictHeytingAlgebraRecord@1({proxy})
   , implies => DictHeytingAlgebraRecord@3({proxy})
   , 'not' => DictHeytingAlgebraRecord@4({proxy})
   }.

conj() ->
  fun
    (Dict) ->
      conj(Dict)
  end.

conj(#{ conj := Dict }) ->
  Dict.

heytingAlgebraFunction() ->
  fun
    (DictHeytingAlgebra) ->
      heytingAlgebraFunction(DictHeytingAlgebra)
  end.

heytingAlgebraFunction(#{ conj := DictHeytingAlgebra
                        , disj := DictHeytingAlgebra@1
                        , ff := DictHeytingAlgebra@2
                        , implies := DictHeytingAlgebra@3
                        , 'not' := DictHeytingAlgebra@4
                        , tt := DictHeytingAlgebra@5
                        }) ->
  #{ ff =>
     fun
       (_) ->
         DictHeytingAlgebra@2
     end
   , tt =>
     fun
       (_) ->
         DictHeytingAlgebra@5
     end
   , implies =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (A) ->
                 (DictHeytingAlgebra@3(F(A)))(G(A))
             end
         end
     end
   , conj =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (A) ->
                 (DictHeytingAlgebra(F(A)))(G(A))
             end
         end
     end
   , disj =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (A) ->
                 (DictHeytingAlgebra@1(F(A)))(G(A))
             end
         end
     end
   , 'not' =>
     fun
       (F) ->
         fun
           (A) ->
             DictHeytingAlgebra@4(F(A))
         end
     end
   }.

heytingAlgebraRecordCons() ->
  fun
    (DictIsSymbol) ->
      fun
        (V) ->
          fun
            (DictHeytingAlgebraRecord) ->
              fun
                (DictHeytingAlgebra) ->
                  heytingAlgebraRecordCons(
                    DictIsSymbol,
                    V,
                    DictHeytingAlgebraRecord,
                    DictHeytingAlgebra
                  )
              end
          end
      end
  end.

heytingAlgebraRecordCons( #{ reflectSymbol := DictIsSymbol }
                        , _
                        , #{ conjRecord := DictHeytingAlgebraRecord
                           , disjRecord := DictHeytingAlgebraRecord@1
                           , ffRecord := DictHeytingAlgebraRecord@2
                           , impliesRecord := DictHeytingAlgebraRecord@3
                           , notRecord := DictHeytingAlgebraRecord@4
                           , ttRecord := DictHeytingAlgebraRecord@5
                           }
                        , #{ conj := DictHeytingAlgebra
                           , disj := DictHeytingAlgebra@1
                           , ff := DictHeytingAlgebra@2
                           , implies := DictHeytingAlgebra@3
                           , 'not' := DictHeytingAlgebra@4
                           , tt := DictHeytingAlgebra@5
                           }
                        ) ->
  #{ conjRecord =>
     fun
       (_) ->
         fun
           (Ra) ->
             fun
               (Rb) ->
                 begin
                   Key = DictIsSymbol({proxy}),
                   Get = (record_unsafe@ps:unsafeGet())(Key),
                   record_unsafe@foreign:unsafeSet(
                     Key,
                     (DictHeytingAlgebra(Get(Ra)))(Get(Rb)),
                     ((DictHeytingAlgebraRecord({proxy}))(Ra))(Rb)
                   )
                 end
             end
         end
     end
   , disjRecord =>
     fun
       (_) ->
         fun
           (Ra) ->
             fun
               (Rb) ->
                 begin
                   Key = DictIsSymbol({proxy}),
                   Get = (record_unsafe@ps:unsafeGet())(Key),
                   record_unsafe@foreign:unsafeSet(
                     Key,
                     (DictHeytingAlgebra@1(Get(Ra)))(Get(Rb)),
                     ((DictHeytingAlgebraRecord@1({proxy}))(Ra))(Rb)
                   )
                 end
             end
         end
     end
   , impliesRecord =>
     fun
       (_) ->
         fun
           (Ra) ->
             fun
               (Rb) ->
                 begin
                   Key = DictIsSymbol({proxy}),
                   Get = (record_unsafe@ps:unsafeGet())(Key),
                   record_unsafe@foreign:unsafeSet(
                     Key,
                     (DictHeytingAlgebra@3(Get(Ra)))(Get(Rb)),
                     ((DictHeytingAlgebraRecord@3({proxy}))(Ra))(Rb)
                   )
                 end
             end
         end
     end
   , ffRecord =>
     fun
       (_) ->
         fun
           (Row) ->
             record_unsafe@foreign:unsafeSet(
               DictIsSymbol({proxy}),
               DictHeytingAlgebra@2,
               (DictHeytingAlgebraRecord@2({proxy}))(Row)
             )
         end
     end
   , notRecord =>
     fun
       (_) ->
         fun
           (Row) ->
             begin
               Key = DictIsSymbol({proxy}),
               record_unsafe@foreign:unsafeSet(
                 Key,
                 DictHeytingAlgebra@4(record_unsafe@foreign:unsafeGet(Key, Row)),
                 (DictHeytingAlgebraRecord@4({proxy}))(Row)
               )
             end
         end
     end
   , ttRecord =>
     fun
       (_) ->
         fun
           (Row) ->
             record_unsafe@foreign:unsafeSet(
               DictIsSymbol({proxy}),
               DictHeytingAlgebra@5,
               (DictHeytingAlgebraRecord@5({proxy}))(Row)
             )
         end
     end
   }.

boolConj() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_heytingAlgebra@foreign:boolConj(V, V@1)
      end
  end.

boolDisj() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_heytingAlgebra@foreign:boolDisj(V, V@1)
      end
  end.

boolNot() ->
  fun
    (V) ->
      data_heytingAlgebra@foreign:boolNot(V)
  end.

