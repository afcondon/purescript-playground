-module(data_semiring@ps).
-export([ zeroRecord/0
        , zeroRecord/1
        , zero/0
        , zero/1
        , semiringUnit/0
        , semiringRecordNil/0
        , semiringProxy3/0
        , semiringProxy2/0
        , semiringProxy/0
        , semiringNumber/0
        , semiringInt/0
        , oneRecord/0
        , oneRecord/1
        , one/0
        , one/1
        , mulRecord/0
        , mulRecord/1
        , mul/0
        , mul/1
        , addRecord/0
        , addRecord/1
        , semiringRecord/0
        , semiringRecord/2
        , add/0
        , add/1
        , semiringFn/0
        , semiringFn/1
        , semiringRecordCons/0
        , semiringRecordCons/4
        , intAdd/0
        , intMul/0
        , numAdd/0
        , numMul/0
        ]).
-compile(no_auto_import).
zeroRecord() ->
  fun
    (Dict) ->
      zeroRecord(Dict)
  end.

zeroRecord(#{ zeroRecord := Dict }) ->
  Dict.

zero() ->
  fun
    (Dict) ->
      zero(Dict)
  end.

zero(#{ zero := Dict }) ->
  Dict.

semiringUnit() ->
  #{ add =>
     fun
       (_) ->
         fun
           (_) ->
             unit
         end
     end
   , zero => unit
   , mul =>
     fun
       (_) ->
         fun
           (_) ->
             unit
         end
     end
   , one => unit
   }.

semiringRecordNil() ->
  #{ addRecord =>
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
   , mulRecord =>
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
   , oneRecord =>
     fun
       (_) ->
         fun
           (_) ->
             #{}
         end
     end
   , zeroRecord =>
     fun
       (_) ->
         fun
           (_) ->
             #{}
         end
     end
   }.

semiringProxy3() ->
  #{ add =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy3}
         end
     end
   , mul =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy3}
         end
     end
   , one => {proxy3}
   , zero => {proxy3}
   }.

semiringProxy2() ->
  #{ add =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy2}
         end
     end
   , mul =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy2}
         end
     end
   , one => {proxy2}
   , zero => {proxy2}
   }.

semiringProxy() ->
  #{ add =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   , mul =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   , one => {proxy}
   , zero => {proxy}
   }.

semiringNumber() ->
  #{ add => numAdd(), zero => 0.0, mul => numMul(), one => 1.0 }.

semiringInt() ->
  #{ add => intAdd(), zero => 0, mul => intMul(), one => 1 }.

oneRecord() ->
  fun
    (Dict) ->
      oneRecord(Dict)
  end.

oneRecord(#{ oneRecord := Dict }) ->
  Dict.

one() ->
  fun
    (Dict) ->
      one(Dict)
  end.

one(#{ one := Dict }) ->
  Dict.

mulRecord() ->
  fun
    (Dict) ->
      mulRecord(Dict)
  end.

mulRecord(#{ mulRecord := Dict }) ->
  Dict.

mul() ->
  fun
    (Dict) ->
      mul(Dict)
  end.

mul(#{ mul := Dict }) ->
  Dict.

addRecord() ->
  fun
    (Dict) ->
      addRecord(Dict)
  end.

addRecord(#{ addRecord := Dict }) ->
  Dict.

semiringRecord() ->
  fun
    (V) ->
      fun
        (DictSemiringRecord) ->
          semiringRecord(V, DictSemiringRecord)
      end
  end.

semiringRecord( _
              , #{ addRecord := DictSemiringRecord
                 , mulRecord := DictSemiringRecord@1
                 , oneRecord := DictSemiringRecord@2
                 , zeroRecord := DictSemiringRecord@3
                 }
              ) ->
  #{ add => DictSemiringRecord({proxy})
   , mul => DictSemiringRecord@1({proxy})
   , one => (DictSemiringRecord@2({proxy}))({proxy})
   , zero => (DictSemiringRecord@3({proxy}))({proxy})
   }.

add() ->
  fun
    (Dict) ->
      add(Dict)
  end.

add(#{ add := Dict }) ->
  Dict.

semiringFn() ->
  fun
    (DictSemiring) ->
      semiringFn(DictSemiring)
  end.

semiringFn(#{ add := DictSemiring
            , mul := DictSemiring@1
            , one := DictSemiring@2
            , zero := DictSemiring@3
            }) ->
  #{ add =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (X) ->
                 (DictSemiring(F(X)))(G(X))
             end
         end
     end
   , zero =>
     fun
       (_) ->
         DictSemiring@3
     end
   , mul =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (X) ->
                 (DictSemiring@1(F(X)))(G(X))
             end
         end
     end
   , one =>
     fun
       (_) ->
         DictSemiring@2
     end
   }.

semiringRecordCons() ->
  fun
    (DictIsSymbol) ->
      fun
        (V) ->
          fun
            (DictSemiringRecord) ->
              fun
                (DictSemiring) ->
                  semiringRecordCons(
                    DictIsSymbol,
                    V,
                    DictSemiringRecord,
                    DictSemiring
                  )
              end
          end
      end
  end.

semiringRecordCons( #{ reflectSymbol := DictIsSymbol }
                  , _
                  , #{ addRecord := DictSemiringRecord
                     , mulRecord := DictSemiringRecord@1
                     , oneRecord := DictSemiringRecord@2
                     , zeroRecord := DictSemiringRecord@3
                     }
                  , #{ add := DictSemiring
                     , mul := DictSemiring@1
                     , one := DictSemiring@2
                     , zero := DictSemiring@3
                     }
                  ) ->
  #{ addRecord =>
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
                     (DictSemiring(Get(Ra)))(Get(Rb)),
                     ((DictSemiringRecord({proxy}))(Ra))(Rb)
                   )
                 end
             end
         end
     end
   , mulRecord =>
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
                     (DictSemiring@1(Get(Ra)))(Get(Rb)),
                     ((DictSemiringRecord@1({proxy}))(Ra))(Rb)
                   )
                 end
             end
         end
     end
   , oneRecord =>
     fun
       (_) ->
         fun
           (_) ->
             record_unsafe@foreign:unsafeSet(
               DictIsSymbol({proxy}),
               DictSemiring@2,
               (DictSemiringRecord@2({proxy}))({proxy})
             )
         end
     end
   , zeroRecord =>
     fun
       (_) ->
         fun
           (_) ->
             record_unsafe@foreign:unsafeSet(
               DictIsSymbol({proxy}),
               DictSemiring@3,
               (DictSemiringRecord@3({proxy}))({proxy})
             )
         end
     end
   }.

intAdd() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_semiring@foreign:intAdd(V, V@1)
      end
  end.

intMul() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_semiring@foreign:intMul(V, V@1)
      end
  end.

numAdd() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_semiring@foreign:numAdd(V, V@1)
      end
  end.

numMul() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_semiring@foreign:numMul(V, V@1)
      end
  end.

