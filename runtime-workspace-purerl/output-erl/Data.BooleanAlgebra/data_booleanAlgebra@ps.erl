-module(data_booleanAlgebra@ps).
-export([ booleanAlgebraUnit/0
        , booleanAlgebraRecordNil/0
        , booleanAlgebraRecordCons/0
        , booleanAlgebraRecordCons/3
        , booleanAlgebraRecord/0
        , booleanAlgebraRecord/2
        , booleanAlgebraProxy3/0
        , booleanAlgebraProxy2/0
        , booleanAlgebraProxy/0
        , booleanAlgebraFn/0
        , booleanAlgebraFn/1
        , booleanAlgebraBoolean/0
        ]).
-compile(no_auto_import).
booleanAlgebraUnit() ->
  #{ 'HeytingAlgebra0' =>
     fun
       (_) ->
         data_heytingAlgebra@ps:heytingAlgebraUnit()
     end
   }.

booleanAlgebraRecordNil() ->
  #{ 'HeytingAlgebraRecord0' =>
     fun
       (_) ->
         data_heytingAlgebra@ps:heytingAlgebraRecordNil()
     end
   }.

booleanAlgebraRecordCons() ->
  fun
    (DictIsSymbol) ->
      fun
        (V) ->
          fun
            (DictBooleanAlgebraRecord) ->
              booleanAlgebraRecordCons(
                DictIsSymbol,
                V,
                DictBooleanAlgebraRecord
              )
          end
      end
  end.

booleanAlgebraRecordCons( DictIsSymbol
                        , _
                        , #{ 'HeytingAlgebraRecord0' := DictBooleanAlgebraRecord
                           }
                        ) ->
  begin
    HeytingAlgebraRecordCons1 =
      (((data_heytingAlgebra@ps:heytingAlgebraRecordCons())(DictIsSymbol))
       (undefined))
      (DictBooleanAlgebraRecord(undefined)),
    fun
      (#{ 'HeytingAlgebra0' := DictBooleanAlgebra }) ->
        begin
          HeytingAlgebraRecordCons2 =
            HeytingAlgebraRecordCons1(DictBooleanAlgebra(undefined)),
          #{ 'HeytingAlgebraRecord0' =>
             fun
               (_) ->
                 HeytingAlgebraRecordCons2
             end
           }
        end
    end
  end.

booleanAlgebraRecord() ->
  fun
    (V) ->
      fun
        (DictBooleanAlgebraRecord) ->
          booleanAlgebraRecord(V, DictBooleanAlgebraRecord)
      end
  end.

booleanAlgebraRecord( _
                    , #{ 'HeytingAlgebraRecord0' := DictBooleanAlgebraRecord }
                    ) ->
  begin
    #{ conjRecord := V
     , disjRecord := V@1
     , ffRecord := V@2
     , impliesRecord := V@3
     , notRecord := V@4
     , ttRecord := V@5
     } =
      DictBooleanAlgebraRecord(undefined),
    HeytingAlgebraRecord1 =
      #{ ff => (V@2({proxy}))({proxy})
       , tt => (V@5({proxy}))({proxy})
       , conj => V({proxy})
       , disj => V@1({proxy})
       , implies => V@3({proxy})
       , 'not' => V@4({proxy})
       },
    #{ 'HeytingAlgebra0' =>
       fun
         (_) ->
           HeytingAlgebraRecord1
       end
     }
  end.

booleanAlgebraProxy3() ->
  #{ 'HeytingAlgebra0' =>
     fun
       (_) ->
         data_heytingAlgebra@ps:heytingAlgebraProxy3()
     end
   }.

booleanAlgebraProxy2() ->
  #{ 'HeytingAlgebra0' =>
     fun
       (_) ->
         data_heytingAlgebra@ps:heytingAlgebraProxy2()
     end
   }.

booleanAlgebraProxy() ->
  #{ 'HeytingAlgebra0' =>
     fun
       (_) ->
         data_heytingAlgebra@ps:heytingAlgebraProxy()
     end
   }.

booleanAlgebraFn() ->
  fun
    (DictBooleanAlgebra) ->
      booleanAlgebraFn(DictBooleanAlgebra)
  end.

booleanAlgebraFn(#{ 'HeytingAlgebra0' := DictBooleanAlgebra }) ->
  begin
    #{ conj := V
     , disj := V@1
     , ff := V@2
     , implies := V@3
     , 'not' := V@4
     , tt := V@5
     } =
      DictBooleanAlgebra(undefined),
    HeytingAlgebraFunction =
      #{ ff =>
         fun
           (_) ->
             V@2
         end
       , tt =>
         fun
           (_) ->
             V@5
         end
       , implies =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (A) ->
                     (V@3(F(A)))(G(A))
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
                     (V(F(A)))(G(A))
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
                     (V@1(F(A)))(G(A))
                 end
             end
         end
       , 'not' =>
         fun
           (F) ->
             fun
               (A) ->
                 V@4(F(A))
             end
         end
       },
    #{ 'HeytingAlgebra0' =>
       fun
         (_) ->
           HeytingAlgebraFunction
       end
     }
  end.

booleanAlgebraBoolean() ->
  #{ 'HeytingAlgebra0' =>
     fun
       (_) ->
         data_heytingAlgebra@ps:heytingAlgebraBoolean()
     end
   }.

