-module(data_functorWithIndex@ps).
-export([ mapWithIndex/0
        , mapWithIndex/1
        , mapDefault/0
        , mapDefault/2
        , functorWithIndexTuple/0
        , functorWithIndexProduct/0
        , functorWithIndexProduct/1
        , functorWithIndexMultiplicative/0
        , functorWithIndexMaybe/0
        , functorWithIndexLast/0
        , functorWithIndexIdentity/0
        , functorWithIndexFirst/0
        , functorWithIndexEither/0
        , functorWithIndexDual/0
        , functorWithIndexDisj/0
        , functorWithIndexCoproduct/0
        , functorWithIndexCoproduct/1
        , functorWithIndexConst/0
        , functorWithIndexConj/0
        , functorWithIndexCompose/0
        , functorWithIndexCompose/1
        , functorWithIndexArray/0
        , functorWithIndexApp/0
        , functorWithIndexApp/1
        , functorWithIndexAdditive/0
        , mapWithIndexArray/0
        ]).
-compile(no_auto_import).
mapWithIndex() ->
  fun
    (Dict) ->
      mapWithIndex(Dict)
  end.

mapWithIndex(#{ mapWithIndex := Dict }) ->
  Dict.

mapDefault() ->
  fun
    (DictFunctorWithIndex) ->
      fun
        (F) ->
          mapDefault(DictFunctorWithIndex, F)
      end
  end.

mapDefault(#{ mapWithIndex := DictFunctorWithIndex }, F) ->
  DictFunctorWithIndex(fun
    (_) ->
      F
  end).

functorWithIndexTuple() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (M) ->
               {tuple, erlang:element(2, M), V(erlang:element(3, M))}
           end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_tuple@ps:functorTuple()
     end
   }.

functorWithIndexProduct() ->
  fun
    (DictFunctorWithIndex) ->
      functorWithIndexProduct(DictFunctorWithIndex)
  end.

functorWithIndexProduct(#{ 'Functor0' := DictFunctorWithIndex
                         , mapWithIndex := DictFunctorWithIndex@1
                         }) ->
  begin
    #{ map := V } = DictFunctorWithIndex(undefined),
    fun
      (#{ 'Functor0' := DictFunctorWithIndex1
        , mapWithIndex := DictFunctorWithIndex1@1
        }) ->
        begin
          #{ map := V@1 } = DictFunctorWithIndex1(undefined),
          FunctorProduct1 =
            #{ map =>
               fun
                 (F) ->
                   fun
                     (V@2) ->
                       { tuple
                       , (V(F))(erlang:element(2, V@2))
                       , (V@1(F))(erlang:element(3, V@2))
                       }
                   end
               end
             },
          #{ mapWithIndex =>
             fun
               (F) ->
                 fun
                   (V@2) ->
                     { tuple
                     , (DictFunctorWithIndex@1(fun
                          (X) ->
                            F({left, X})
                        end))
                       (erlang:element(2, V@2))
                     , (DictFunctorWithIndex1@1(fun
                          (X) ->
                            F({right, X})
                        end))
                       (erlang:element(3, V@2))
                     }
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorProduct1
             end
           }
        end
    end
  end.

functorWithIndexMultiplicative() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_multiplicative@ps:functorMultiplicative()
     end
   }.

functorWithIndexMaybe() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (V1) ->
               case V1 of
                 {just, V1@1} ->
                   {just, V(V1@1)};
                 _ ->
                   {nothing}
               end
           end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_maybe@ps:functorMaybe()
     end
   }.

functorWithIndexLast() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (V1) ->
               case V1 of
                 {just, V1@1} ->
                   {just, V(V1@1)};
                 _ ->
                   {nothing}
               end
           end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_maybe@ps:functorMaybe()
     end
   }.

functorWithIndexIdentity() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         fun
           (V) ->
             (F(unit))(V)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_identity@ps:functorIdentity()
     end
   }.

functorWithIndexFirst() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (V1) ->
               case V1 of
                 {just, V1@1} ->
                   {just, V(V1@1)};
                 _ ->
                   {nothing}
               end
           end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_maybe@ps:functorMaybe()
     end
   }.

functorWithIndexEither() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         begin
           V = F(unit),
           fun
             (M) ->
               case M of
                 {left, M@1} ->
                   {left, M@1};
                 {right, M@2} ->
                   {right, V(M@2)};
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
           end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_either@ps:functorEither()
     end
   }.

functorWithIndexDual() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_dual@ps:functorDual()
     end
   }.

functorWithIndexDisj() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_disj@ps:functorDisj()
     end
   }.

functorWithIndexCoproduct() ->
  fun
    (DictFunctorWithIndex) ->
      functorWithIndexCoproduct(DictFunctorWithIndex)
  end.

functorWithIndexCoproduct(#{ 'Functor0' := DictFunctorWithIndex
                           , mapWithIndex := DictFunctorWithIndex@1
                           }) ->
  begin
    #{ map := V } = DictFunctorWithIndex(undefined),
    fun
      (#{ 'Functor0' := DictFunctorWithIndex1
        , mapWithIndex := DictFunctorWithIndex1@1
        }) ->
        begin
          #{ map := V@1 } = DictFunctorWithIndex1(undefined),
          FunctorCoproduct1 =
            #{ map =>
               fun
                 (F) ->
                   fun
                     (V@2) ->
                       begin
                         V@3 = V(F),
                         V@4 = V@1(F),
                         case V@2 of
                           {left, V@5} ->
                             {left, V@3(V@5)};
                           {right, V@6} ->
                             {right, V@4(V@6)};
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                       end
                   end
               end
             },
          #{ mapWithIndex =>
             fun
               (F) ->
                 fun
                   (V@2) ->
                     begin
                       V@3 =
                         DictFunctorWithIndex@1(fun
                           (X) ->
                             F({left, X})
                         end),
                       V@4 =
                         DictFunctorWithIndex1@1(fun
                           (X) ->
                             F({right, X})
                         end),
                       case V@2 of
                         {left, V@5} ->
                           {left, V@3(V@5)};
                         {right, V@6} ->
                           {right, V@4(V@6)};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorCoproduct1
             end
           }
        end
    end
  end.

functorWithIndexConst() ->
  #{ mapWithIndex =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_const@ps:functorConst()
     end
   }.

functorWithIndexConj() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_conj@ps:functorConj()
     end
   }.

functorWithIndexCompose() ->
  fun
    (DictFunctorWithIndex) ->
      functorWithIndexCompose(DictFunctorWithIndex)
  end.

functorWithIndexCompose(#{ 'Functor0' := DictFunctorWithIndex
                         , mapWithIndex := DictFunctorWithIndex@1
                         }) ->
  begin
    #{ map := V } = DictFunctorWithIndex(undefined),
    fun
      (#{ 'Functor0' := DictFunctorWithIndex1
        , mapWithIndex := DictFunctorWithIndex1@1
        }) ->
        begin
          #{ map := V@1 } = DictFunctorWithIndex1(undefined),
          FunctorCompose1 =
            #{ map =>
               fun
                 (F) ->
                   fun
                     (V@2) ->
                       (V(V@1(F)))(V@2)
                   end
               end
             },
          #{ mapWithIndex =>
             fun
               (F) ->
                 fun
                   (V@2) ->
                     (DictFunctorWithIndex@1(fun
                        (X) ->
                          DictFunctorWithIndex1@1(fun
                            (B) ->
                              F({tuple, X, B})
                          end)
                      end))
                     (V@2)
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorCompose1
             end
           }
        end
    end
  end.

functorWithIndexArray() ->
  #{ mapWithIndex => mapWithIndexArray()
   , 'Functor0' =>
     fun
       (_) ->
         data_functor@ps:functorArray()
     end
   }.

functorWithIndexApp() ->
  fun
    (DictFunctorWithIndex) ->
      functorWithIndexApp(DictFunctorWithIndex)
  end.

functorWithIndexApp(#{ 'Functor0' := DictFunctorWithIndex
                     , mapWithIndex := DictFunctorWithIndex@1
                     }) ->
  begin
    V = DictFunctorWithIndex(undefined),
    #{ mapWithIndex =>
       fun
         (F) ->
           fun
             (V@1) ->
               (DictFunctorWithIndex@1(F))(V@1)
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           V
       end
     }
  end.

functorWithIndexAdditive() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         F(unit)
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_monoid_additive@ps:functorAdditive()
     end
   }.

mapWithIndexArray() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_functorWithIndex@foreign:mapWithIndexArray(V, V@1)
      end
  end.

