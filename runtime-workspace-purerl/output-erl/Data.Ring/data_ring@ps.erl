-module(data_ring@ps).
-export([ subRecord/0
        , subRecord/1
        , sub/0
        , sub/1
        , ringUnit/0
        , ringRecordNil/0
        , ringRecordCons/0
        , ringRecordCons/3
        , ringRecord/0
        , ringRecord/2
        , ringProxy3/0
        , ringProxy2/0
        , ringProxy/0
        , ringNumber/0
        , ringInt/0
        , ringFn/0
        , ringFn/1
        , negate/0
        , negate/1
        , intSub/0
        , numSub/0
        ]).
-compile(no_auto_import).
subRecord() ->
  fun
    (Dict) ->
      subRecord(Dict)
  end.

subRecord(#{ subRecord := Dict }) ->
  Dict.

sub() ->
  fun
    (Dict) ->
      sub(Dict)
  end.

sub(#{ sub := Dict }) ->
  Dict.

ringUnit() ->
  #{ sub =>
     fun
       (_) ->
         fun
           (_) ->
             unit
         end
     end
   , 'Semiring0' =>
     fun
       (_) ->
         data_semiring@ps:semiringUnit()
     end
   }.

ringRecordNil() ->
  #{ subRecord =>
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
   , 'SemiringRecord0' =>
     fun
       (_) ->
         data_semiring@ps:semiringRecordNil()
     end
   }.

ringRecordCons() ->
  fun
    (DictIsSymbol) ->
      fun
        (V) ->
          fun
            (DictRingRecord) ->
              ringRecordCons(DictIsSymbol, V, DictRingRecord)
          end
      end
  end.

ringRecordCons( DictIsSymbol = #{ reflectSymbol := DictIsSymbol@1 }
              , _
              , #{ 'SemiringRecord0' := DictRingRecord
                 , subRecord := DictRingRecord@1
                 }
              ) ->
  begin
    SemiringRecordCons1 =
      (((data_semiring@ps:semiringRecordCons())(DictIsSymbol))(undefined))
      (DictRingRecord(undefined)),
    fun
      (#{ 'Semiring0' := DictRing, sub := DictRing@1 }) ->
        begin
          SemiringRecordCons2 = SemiringRecordCons1(DictRing(undefined)),
          #{ subRecord =>
             fun
               (_) ->
                 fun
                   (Ra) ->
                     fun
                       (Rb) ->
                         begin
                           Key = DictIsSymbol@1({proxy}),
                           Get = (record_unsafe@ps:unsafeGet())(Key),
                           record_unsafe@foreign:unsafeSet(
                             Key,
                             (DictRing@1(Get(Ra)))(Get(Rb)),
                             ((DictRingRecord@1({proxy}))(Ra))(Rb)
                           )
                         end
                     end
                 end
             end
           , 'SemiringRecord0' =>
             fun
               (_) ->
                 SemiringRecordCons2
             end
           }
        end
    end
  end.

ringRecord() ->
  fun
    (V) ->
      fun
        (DictRingRecord) ->
          ringRecord(V, DictRingRecord)
      end
  end.

ringRecord( _
          , #{ 'SemiringRecord0' := DictRingRecord
             , subRecord := DictRingRecord@1
             }
          ) ->
  begin
    #{ addRecord := V, mulRecord := V@1, oneRecord := V@2, zeroRecord := V@3 } =
      DictRingRecord(undefined),
    SemiringRecord1 =
      #{ add => V({proxy})
       , mul => V@1({proxy})
       , one => (V@2({proxy}))({proxy})
       , zero => (V@3({proxy}))({proxy})
       },
    #{ sub => DictRingRecord@1({proxy})
     , 'Semiring0' =>
       fun
         (_) ->
           SemiringRecord1
       end
     }
  end.

ringProxy3() ->
  #{ sub =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy3}
         end
     end
   , 'Semiring0' =>
     fun
       (_) ->
         data_semiring@ps:semiringProxy3()
     end
   }.

ringProxy2() ->
  #{ sub =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy2}
         end
     end
   , 'Semiring0' =>
     fun
       (_) ->
         data_semiring@ps:semiringProxy2()
     end
   }.

ringProxy() ->
  #{ sub =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   , 'Semiring0' =>
     fun
       (_) ->
         data_semiring@ps:semiringProxy()
     end
   }.

ringNumber() ->
  #{ sub => numSub()
   , 'Semiring0' =>
     fun
       (_) ->
         data_semiring@ps:semiringNumber()
     end
   }.

ringInt() ->
  #{ sub => intSub()
   , 'Semiring0' =>
     fun
       (_) ->
         data_semiring@ps:semiringInt()
     end
   }.

ringFn() ->
  fun
    (DictRing) ->
      ringFn(DictRing)
  end.

ringFn(#{ 'Semiring0' := DictRing, sub := DictRing@1 }) ->
  begin
    #{ add := V, mul := V@1, one := V@2, zero := V@3 } = DictRing(undefined),
    SemiringFn =
      #{ add =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (X) ->
                     (V(F(X)))(G(X))
                 end
             end
         end
       , zero =>
         fun
           (_) ->
             V@3
         end
       , mul =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (X) ->
                     (V@1(F(X)))(G(X))
                 end
             end
         end
       , one =>
         fun
           (_) ->
             V@2
         end
       },
    #{ sub =>
       fun
         (F) ->
           fun
             (G) ->
               fun
                 (X) ->
                   (DictRing@1(F(X)))(G(X))
               end
           end
       end
     , 'Semiring0' =>
       fun
         (_) ->
           SemiringFn
       end
     }
  end.

negate() ->
  fun
    (DictRing) ->
      negate(DictRing)
  end.

negate(#{ 'Semiring0' := DictRing, sub := DictRing@1 }) ->
  begin
    Zero = erlang:map_get(zero, DictRing(undefined)),
    fun
      (A) ->
        (DictRing@1(Zero))(A)
    end
  end.

intSub() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_ring@foreign:intSub(V, V@1)
      end
  end.

numSub() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_ring@foreign:numSub(V, V@1)
      end
  end.

