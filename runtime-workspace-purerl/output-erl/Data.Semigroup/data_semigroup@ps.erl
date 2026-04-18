-module(data_semigroup@ps).
-export([ semigroupVoid/0
        , semigroupUnit/0
        , semigroupString/0
        , semigroupRecordNil/0
        , semigroupProxy3/0
        , semigroupProxy2/0
        , semigroupProxy/0
        , semigroupArray/0
        , appendRecord/0
        , appendRecord/1
        , semigroupRecord/0
        , semigroupRecord/2
        , append/0
        , append/1
        , semigroupFn/0
        , semigroupFn/1
        , semigroupRecordCons/0
        , semigroupRecordCons/4
        , concatString/0
        , concatArray/0
        ]).
-compile(no_auto_import).
semigroupVoid() ->
  #{ append =>
     fun
       (_) ->
         data_void@ps:absurd()
     end
   }.

semigroupUnit() ->
  #{ append =>
     fun
       (_) ->
         fun
           (_) ->
             unit
         end
     end
   }.

semigroupString() ->
  #{ append => concatString() }.

semigroupRecordNil() ->
  #{ appendRecord =>
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
   }.

semigroupProxy3() ->
  #{ append =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy3}
         end
     end
   }.

semigroupProxy2() ->
  #{ append =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy2}
         end
     end
   }.

semigroupProxy() ->
  #{ append =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   }.

semigroupArray() ->
  #{ append => concatArray() }.

appendRecord() ->
  fun
    (Dict) ->
      appendRecord(Dict)
  end.

appendRecord(#{ appendRecord := Dict }) ->
  Dict.

semigroupRecord() ->
  fun
    (V) ->
      fun
        (DictSemigroupRecord) ->
          semigroupRecord(V, DictSemigroupRecord)
      end
  end.

semigroupRecord(_, #{ appendRecord := DictSemigroupRecord }) ->
  #{ append => DictSemigroupRecord({proxy}) }.

append() ->
  fun
    (Dict) ->
      append(Dict)
  end.

append(#{ append := Dict }) ->
  Dict.

semigroupFn() ->
  fun
    (DictSemigroup) ->
      semigroupFn(DictSemigroup)
  end.

semigroupFn(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (X) ->
                 (DictSemigroup(F(X)))(G(X))
             end
         end
     end
   }.

semigroupRecordCons() ->
  fun
    (DictIsSymbol) ->
      fun
        (V) ->
          fun
            (DictSemigroupRecord) ->
              fun
                (DictSemigroup) ->
                  semigroupRecordCons(
                    DictIsSymbol,
                    V,
                    DictSemigroupRecord,
                    DictSemigroup
                  )
              end
          end
      end
  end.

semigroupRecordCons( #{ reflectSymbol := DictIsSymbol }
                   , _
                   , #{ appendRecord := DictSemigroupRecord }
                   , #{ append := DictSemigroup }
                   ) ->
  #{ appendRecord =>
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
                     (DictSemigroup(Get(Ra)))(Get(Rb)),
                     ((DictSemigroupRecord({proxy}))(Ra))(Rb)
                   )
                 end
             end
         end
     end
   }.

concatString() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_semigroup@foreign:concatString(V, V@1)
      end
  end.

concatArray() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_semigroup@foreign:concatArray(V, V@1)
      end
  end.

