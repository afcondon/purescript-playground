-module(data_commutativeRing@ps).
-export([ commutativeRingUnit/0
        , commutativeRingRecordNil/0
        , commutativeRingRecordCons/0
        , commutativeRingRecordCons/3
        , commutativeRingRecord/0
        , commutativeRingRecord/2
        , commutativeRingProxy3/0
        , commutativeRingProxy2/0
        , commutativeRingProxy/0
        , commutativeRingNumber/0
        , commutativeRingInt/0
        , commutativeRingFn/0
        , commutativeRingFn/1
        ]).
-compile(no_auto_import).
commutativeRingUnit() ->
  #{ 'Ring0' =>
     fun
       (_) ->
         data_ring@ps:ringUnit()
     end
   }.

commutativeRingRecordNil() ->
  #{ 'RingRecord0' =>
     fun
       (_) ->
         data_ring@ps:ringRecordNil()
     end
   }.

commutativeRingRecordCons() ->
  fun
    (DictIsSymbol) ->
      fun
        (V) ->
          fun
            (DictCommutativeRingRecord) ->
              commutativeRingRecordCons(
                DictIsSymbol,
                V,
                DictCommutativeRingRecord
              )
          end
      end
  end.

commutativeRingRecordCons( DictIsSymbol
                         , _
                         , #{ 'RingRecord0' := DictCommutativeRingRecord }
                         ) ->
  begin
    RingRecordCons1 =
      data_ring@ps:ringRecordCons(
        DictIsSymbol,
        undefined,
        DictCommutativeRingRecord(undefined)
      ),
    fun
      (#{ 'Ring0' := DictCommutativeRing }) ->
        begin
          RingRecordCons2 = RingRecordCons1(DictCommutativeRing(undefined)),
          #{ 'RingRecord0' =>
             fun
               (_) ->
                 RingRecordCons2
             end
           }
        end
    end
  end.

commutativeRingRecord() ->
  fun
    (V) ->
      fun
        (DictCommutativeRingRecord) ->
          commutativeRingRecord(V, DictCommutativeRingRecord)
      end
  end.

commutativeRingRecord(_, #{ 'RingRecord0' := DictCommutativeRingRecord }) ->
  begin
    #{ 'SemiringRecord0' := V, subRecord := V@1 } =
      DictCommutativeRingRecord(undefined),
    #{ addRecord := V@2, mulRecord := V@3, oneRecord := V@4, zeroRecord := V@5 } =
      V(undefined),
    RingRecord1 =
      begin
        SemiringRecord1 =
          #{ add => V@2({proxy})
           , mul => V@3({proxy})
           , one => (V@4({proxy}))({proxy})
           , zero => (V@5({proxy}))({proxy})
           },
        #{ sub => V@1({proxy})
         , 'Semiring0' =>
           fun
             (_) ->
               SemiringRecord1
           end
         }
      end,
    #{ 'Ring0' =>
       fun
         (_) ->
           RingRecord1
       end
     }
  end.

commutativeRingProxy3() ->
  #{ 'Ring0' =>
     fun
       (_) ->
         data_ring@ps:ringProxy3()
     end
   }.

commutativeRingProxy2() ->
  #{ 'Ring0' =>
     fun
       (_) ->
         data_ring@ps:ringProxy2()
     end
   }.

commutativeRingProxy() ->
  #{ 'Ring0' =>
     fun
       (_) ->
         data_ring@ps:ringProxy()
     end
   }.

commutativeRingNumber() ->
  #{ 'Ring0' =>
     fun
       (_) ->
         data_ring@ps:ringNumber()
     end
   }.

commutativeRingInt() ->
  #{ 'Ring0' =>
     fun
       (_) ->
         data_ring@ps:ringInt()
     end
   }.

commutativeRingFn() ->
  fun
    (DictCommutativeRing) ->
      commutativeRingFn(DictCommutativeRing)
  end.

commutativeRingFn(#{ 'Ring0' := DictCommutativeRing }) ->
  begin
    #{ 'Semiring0' := V, sub := V@1 } = DictCommutativeRing(undefined),
    #{ add := V@2, mul := V@3, one := V@4, zero := V@5 } = V(undefined),
    RingFn =
      begin
        SemiringFn =
          #{ add =>
             fun
               (F) ->
                 fun
                   (G) ->
                     fun
                       (X) ->
                         (V@2(F(X)))(G(X))
                     end
                 end
             end
           , zero =>
             fun
               (_) ->
                 V@5
             end
           , mul =>
             fun
               (F) ->
                 fun
                   (G) ->
                     fun
                       (X) ->
                         (V@3(F(X)))(G(X))
                     end
                 end
             end
           , one =>
             fun
               (_) ->
                 V@4
             end
           },
        #{ sub =>
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
         , 'Semiring0' =>
           fun
             (_) ->
               SemiringFn
           end
         }
      end,
    #{ 'Ring0' =>
       fun
         (_) ->
           RingFn
       end
     }
  end.

