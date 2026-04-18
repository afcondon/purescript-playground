-module(data_monoid@ps).
-export([ monoidUnit/0
        , monoidString/0
        , monoidRecordNil/0
        , monoidOrdering/0
        , monoidArray/0
        , memptyRecord/0
        , memptyRecord/1
        , monoidRecord/0
        , monoidRecord/2
        , mempty/0
        , mempty/1
        , monoidFn/0
        , monoidFn/1
        , monoidRecordCons/0
        , monoidRecordCons/2
        , power/0
        , power/1
        , guard/0
        , guard/1
        ]).
-compile(no_auto_import).
monoidUnit() ->
  #{ mempty => unit
   , 'Semigroup0' =>
     fun
       (_) ->
         data_semigroup@ps:semigroupUnit()
     end
   }.

monoidString() ->
  #{ mempty => <<"">>
   , 'Semigroup0' =>
     fun
       (_) ->
         data_semigroup@ps:semigroupString()
     end
   }.

monoidRecordNil() ->
  #{ memptyRecord =>
     fun
       (_) ->
         #{}
     end
   , 'SemigroupRecord0' =>
     fun
       (_) ->
         data_semigroup@ps:semigroupRecordNil()
     end
   }.

monoidOrdering() ->
  #{ mempty => {eQ}
   , 'Semigroup0' =>
     fun
       (_) ->
         data_ordering@ps:semigroupOrdering()
     end
   }.

monoidArray() ->
  #{ mempty => array:from_list([])
   , 'Semigroup0' =>
     fun
       (_) ->
         data_semigroup@ps:semigroupArray()
     end
   }.

memptyRecord() ->
  fun
    (Dict) ->
      memptyRecord(Dict)
  end.

memptyRecord(#{ memptyRecord := Dict }) ->
  Dict.

monoidRecord() ->
  fun
    (V) ->
      fun
        (DictMonoidRecord) ->
          monoidRecord(V, DictMonoidRecord)
      end
  end.

monoidRecord( _
            , #{ 'SemigroupRecord0' := DictMonoidRecord
               , memptyRecord := DictMonoidRecord@1
               }
            ) ->
  begin
    SemigroupRecord1 =
      #{ append =>
         (erlang:map_get(appendRecord, DictMonoidRecord(undefined)))({proxy})
       },
    #{ mempty => DictMonoidRecord@1({proxy})
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupRecord1
       end
     }
  end.

mempty() ->
  fun
    (Dict) ->
      mempty(Dict)
  end.

mempty(#{ mempty := Dict }) ->
  Dict.

monoidFn() ->
  fun
    (DictMonoid) ->
      monoidFn(DictMonoid)
  end.

monoidFn(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupFn =
      #{ append =>
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
       },
    #{ mempty =>
       fun
         (_) ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupFn
       end
     }
  end.

monoidRecordCons() ->
  fun
    (DictIsSymbol) ->
      fun
        (DictMonoid) ->
          monoidRecordCons(DictIsSymbol, DictMonoid)
      end
  end.

monoidRecordCons( #{ reflectSymbol := DictIsSymbol }
                , #{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }
                ) ->
  begin
    #{ append := Semigroup0 } = DictMonoid(undefined),
    fun
      (_) ->
        fun
          (#{ 'SemigroupRecord0' := DictMonoidRecord
            , memptyRecord := DictMonoidRecord@1
            }) ->
            begin
              #{ appendRecord := V } = DictMonoidRecord(undefined),
              SemigroupRecordCons1 =
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
                                   (Semigroup0(Get(Ra)))(Get(Rb)),
                                   ((V({proxy}))(Ra))(Rb)
                                 )
                               end
                           end
                       end
                   end
                 },
              #{ memptyRecord =>
                 fun
                   (_) ->
                     record_unsafe@foreign:unsafeSet(
                       DictIsSymbol({proxy}),
                       DictMonoid@1,
                       DictMonoidRecord@1({proxy})
                     )
                 end
               , 'SemigroupRecord0' =>
                 fun
                   (_) ->
                     SemigroupRecordCons1
                 end
               }
            end
        end
    end
  end.

power() ->
  fun
    (DictMonoid) ->
      power(DictMonoid)
  end.

power(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    V = DictMonoid(undefined),
    fun
      (X) ->
        begin
          Go =
            fun
              Go (P) ->
                if
                  P =< 0 ->
                    DictMonoid@1;
                  P =:= 1 ->
                    X;
                  true ->
                    begin
                      #{ append := V@1 } = V,
                      case (data_euclideanRing@foreign:intMod(P, 2)) =:= 0 of
                        true ->
                          begin
                            X_ = Go(P div 2),
                            (V@1(X_))(X_)
                          end;
                        _ ->
                          begin
                            X_@1 = Go(P div 2),
                            (V@1(X_@1))((V@1(X_@1))(X))
                          end
                      end
                    end
                end
            end,
          Go
        end
    end
  end.

guard() ->
  fun
    (DictMonoid) ->
      guard(DictMonoid)
  end.

guard(#{ mempty := DictMonoid }) ->
  fun
    (V) ->
      fun
        (V1) ->
          if
            V ->
              V1;
            true ->
              DictMonoid
          end
      end
  end.

