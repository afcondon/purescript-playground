-module(data_decide@ps).
-export([ identity/0
        , identity/1
        , choosePredicate/0
        , chooseOp/0
        , chooseOp/1
        , chooseEquivalence/0
        , chooseComparison/0
        , choose/0
        , choose/1
        , chosen/0
        , chosen/1
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

choosePredicate() ->
  #{ choose =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (X) ->
                     begin
                       V@1 = F(X),
                       case V@1 of
                         {left, V@2} ->
                           V(V@2);
                         {right, V@3} ->
                           V1(V@3);
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end
                 end
             end
         end
     end
   , 'Divide0' =>
     fun
       (_) ->
         data_divide@ps:dividePredicate()
     end
   }.

chooseOp() ->
  fun
    (DictSemigroup) ->
      chooseOp(DictSemigroup)
  end.

chooseOp(DictSemigroup) ->
  begin
    DivideOp = data_divide@ps:divideOp(DictSemigroup),
    #{ choose =>
       fun
         (F) ->
           fun
             (V) ->
               fun
                 (V1) ->
                   fun
                     (X) ->
                       begin
                         V@1 = F(X),
                         case V@1 of
                           {left, V@2} ->
                             V(V@2);
                           {right, V@3} ->
                             V1(V@3);
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                       end
                   end
               end
           end
       end
     , 'Divide0' =>
       fun
         (_) ->
           DivideOp
       end
     }
  end.

chooseEquivalence() ->
  #{ choose =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (A) ->
                     fun
                       (B) ->
                         begin
                           V2 = F(A),
                           case V2 of
                             {left, _} ->
                               begin
                                 V3 = F(B),
                                 case V3 of
                                   {left, V3@1} ->
                                     begin
                                       {left, V2@1} = V2,
                                       (V(V2@1))(V3@1)
                                     end;
                                   {right, _} ->
                                     false;
                                   _ ->
                                     erlang:error({ fail
                                                  , <<"Failed pattern match">>
                                                  })
                                 end
                               end;
                             {right, _} ->
                               begin
                                 V3@2 = F(B),
                                 case V3@2 of
                                   {left, _} ->
                                     false;
                                   {right, V3@3} ->
                                     begin
                                       {right, V2@2} = V2,
                                       (V1(V2@2))(V3@3)
                                     end;
                                   _ ->
                                     erlang:error({ fail
                                                  , <<"Failed pattern match">>
                                                  })
                                 end
                               end;
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                         end
                     end
                 end
             end
         end
     end
   , 'Divide0' =>
     fun
       (_) ->
         data_divide@ps:divideEquivalence()
     end
   }.

chooseComparison() ->
  #{ choose =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (V1) ->
                 fun
                   (A) ->
                     fun
                       (B) ->
                         begin
                           V2 = F(A),
                           case V2 of
                             {left, _} ->
                               begin
                                 V3 = F(B),
                                 case V3 of
                                   {left, V3@1} ->
                                     begin
                                       {left, V2@1} = V2,
                                       (V(V2@1))(V3@1)
                                     end;
                                   {right, _} ->
                                     {lT};
                                   _ ->
                                     erlang:error({ fail
                                                  , <<"Failed pattern match">>
                                                  })
                                 end
                               end;
                             {right, _} ->
                               begin
                                 V3@2 = F(B),
                                 case V3@2 of
                                   {left, _} ->
                                     {gT};
                                   {right, V3@3} ->
                                     begin
                                       {right, V2@2} = V2,
                                       (V1(V2@2))(V3@3)
                                     end;
                                   _ ->
                                     erlang:error({ fail
                                                  , <<"Failed pattern match">>
                                                  })
                                 end
                               end;
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                         end
                     end
                 end
             end
         end
     end
   , 'Divide0' =>
     fun
       (_) ->
         data_divide@ps:divideComparison()
     end
   }.

choose() ->
  fun
    (Dict) ->
      choose(Dict)
  end.

choose(#{ choose := Dict }) ->
  Dict.

chosen() ->
  fun
    (DictDecide) ->
      chosen(DictDecide)
  end.

chosen(#{ choose := DictDecide }) ->
  DictDecide(identity()).

