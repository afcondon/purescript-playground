-module(data_functor_coproduct@ps).
-export([ 'Coproduct'/0
        , 'Coproduct'/1
        , showCoproduct/0
        , showCoproduct/2
        , right/0
        , right/1
        , newtypeCoproduct/0
        , left/0
        , left/1
        , functorCoproduct/0
        , functorCoproduct/2
        , eq1Coproduct/0
        , eq1Coproduct/2
        , eqCoproduct/0
        , eqCoproduct/3
        , ord1Coproduct/0
        , ord1Coproduct/1
        , ordCoproduct/0
        , ordCoproduct/1
        , coproduct/0
        , coproduct/3
        , extendCoproduct/0
        , extendCoproduct/1
        , comonadCoproduct/0
        , comonadCoproduct/1
        , bihoistCoproduct/0
        , bihoistCoproduct/3
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'Coproduct'() ->
  fun
    (X) ->
      'Coproduct'(X)
  end.

'Coproduct'(X) ->
  X.

showCoproduct() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showCoproduct(DictShow, DictShow1)
      end
  end.

showCoproduct(DictShow, DictShow1) ->
  #{ show =>
     fun
       (V) ->
         case V of
           {left, V@1} ->
             begin
               #{ show := DictShow@1 } = DictShow,
               <<"(left ", (DictShow@1(V@1))/binary, ")">>
             end;
           {right, V@2} ->
             begin
               #{ show := DictShow1@1 } = DictShow1,
               <<"(right ", (DictShow1@1(V@2))/binary, ")">>
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

right() ->
  fun
    (Ga) ->
      right(Ga)
  end.

right(Ga) ->
  {right, Ga}.

newtypeCoproduct() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

left() ->
  fun
    (Fa) ->
      left(Fa)
  end.

left(Fa) ->
  {left, Fa}.

functorCoproduct() ->
  fun
    (DictFunctor) ->
      fun
        (DictFunctor1) ->
          functorCoproduct(DictFunctor, DictFunctor1)
      end
  end.

functorCoproduct(#{ map := DictFunctor }, #{ map := DictFunctor1 }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             begin
               V@1 = DictFunctor(F),
               V@2 = DictFunctor1(F),
               case V of
                 {left, V@3} ->
                   {left, V@1(V@3)};
                 {right, V@4} ->
                   {right, V@2(V@4)};
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
             end
         end
     end
   }.

eq1Coproduct() ->
  fun
    (DictEq1) ->
      fun
        (DictEq11) ->
          eq1Coproduct(DictEq1, DictEq11)
      end
  end.

eq1Coproduct(#{ eq1 := DictEq1 }, #{ eq1 := DictEq11 }) ->
  #{ eq1 =>
     fun
       (DictEq) ->
         begin
           Eq12 = DictEq1(DictEq),
           Eq13 = DictEq11(DictEq),
           fun
             (V) ->
               fun
                 (V1) ->
                   case V of
                     {left, _} ->
                       ?IS_KNOWN_TAG(left, 1, V1)
                         andalso ((Eq12(erlang:element(2, V)))
                                  (erlang:element(2, V1)));
                     _ ->
                       ?IS_KNOWN_TAG(right, 1, V)
                         andalso (?IS_KNOWN_TAG(right, 1, V1)
                           andalso ((Eq13(erlang:element(2, V)))
                                    (erlang:element(2, V1))))
                   end
               end
           end
         end
     end
   }.

eqCoproduct() ->
  fun
    (DictEq1) ->
      fun
        (DictEq11) ->
          fun
            (DictEq) ->
              eqCoproduct(DictEq1, DictEq11, DictEq)
          end
      end
  end.

eqCoproduct(#{ eq1 := DictEq1 }, #{ eq1 := DictEq11 }, DictEq) ->
  #{ eq =>
     begin
       Eq12 = DictEq1(DictEq),
       Eq13 = DictEq11(DictEq),
       fun
         (V) ->
           fun
             (V1) ->
               case V of
                 {left, _} ->
                   ?IS_KNOWN_TAG(left, 1, V1)
                     andalso ((Eq12(erlang:element(2, V)))
                              (erlang:element(2, V1)));
                 _ ->
                   ?IS_KNOWN_TAG(right, 1, V)
                     andalso (?IS_KNOWN_TAG(right, 1, V1)
                       andalso ((Eq13(erlang:element(2, V)))
                                (erlang:element(2, V1))))
               end
           end
       end
     end
   }.

ord1Coproduct() ->
  fun
    (DictOrd1) ->
      ord1Coproduct(DictOrd1)
  end.

ord1Coproduct(#{ 'Eq10' := DictOrd1, compare1 := DictOrd1@1 }) ->
  begin
    #{ eq1 := V } = DictOrd1(undefined),
    fun
      (#{ 'Eq10' := DictOrd11, compare1 := DictOrd11@1 }) ->
        begin
          #{ eq1 := V@1 } = DictOrd11(undefined),
          Eq1Coproduct2 =
            #{ eq1 =>
               fun
                 (DictEq) ->
                   begin
                     Eq12 = V(DictEq),
                     Eq13 = V@1(DictEq),
                     fun
                       (V@2) ->
                         fun
                           (V1) ->
                             case V@2 of
                               {left, _} ->
                                 ?IS_KNOWN_TAG(left, 1, V1)
                                   andalso ((Eq12(erlang:element(2, V@2)))
                                            (erlang:element(2, V1)));
                               _ ->
                                 ?IS_KNOWN_TAG(right, 1, V@2)
                                   andalso (?IS_KNOWN_TAG(right, 1, V1)
                                     andalso ((Eq13(erlang:element(2, V@2)))
                                              (erlang:element(2, V1))))
                             end
                         end
                     end
                   end
               end
             },
          #{ compare1 =>
             fun
               (DictOrd) ->
                 begin
                   Compare12 = DictOrd1@1(DictOrd),
                   Compare13 = DictOrd11@1(DictOrd),
                   fun
                     (V@2) ->
                       fun
                         (V1) ->
                           case V@2 of
                             {left, _} ->
                               case V1 of
                                 {left, V1@1} ->
                                   begin
                                     {left, V@3} = V@2,
                                     (Compare12(V@3))(V1@1)
                                   end;
                                 _ ->
                                   {lT}
                               end;
                             _ ->
                               case V1 of
                                 {left, _} ->
                                   {gT};
                                 _ ->
                                   if
                                     ?IS_KNOWN_TAG(right, 1, V@2)
                                       andalso ?IS_KNOWN_TAG(right, 1, V1) ->
                                       begin
                                         {right, V@4} = V@2,
                                         {right, V1@2} = V1,
                                         (Compare13(V@4))(V1@2)
                                       end;
                                     true ->
                                       erlang:error({ fail
                                                    , <<"Failed pattern match">>
                                                    })
                                   end
                               end
                           end
                       end
                   end
                 end
             end
           , 'Eq10' =>
             fun
               (_) ->
                 Eq1Coproduct2
             end
           }
        end
    end
  end.

ordCoproduct() ->
  fun
    (DictOrd1) ->
      ordCoproduct(DictOrd1)
  end.

ordCoproduct(DictOrd1 = #{ 'Eq10' := DictOrd1@1 }) ->
  begin
    Ord1Coproduct1 = ord1Coproduct(DictOrd1),
    #{ eq1 := V } = DictOrd1@1(undefined),
    fun
      (DictOrd11 = #{ 'Eq10' := DictOrd11@1 }) ->
        begin
          #{ eq1 := V@1 } = DictOrd11@1(undefined),
          fun
            (DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
              begin
                V@2 = DictOrd@1(undefined),
                EqCoproduct3 =
                  #{ eq =>
                     begin
                       Eq12 = V(V@2),
                       Eq13 = V@1(V@2),
                       fun
                         (V@3) ->
                           fun
                             (V1) ->
                               case V@3 of
                                 {left, _} ->
                                   ?IS_KNOWN_TAG(left, 1, V1)
                                     andalso ((Eq12(erlang:element(2, V@3)))
                                              (erlang:element(2, V1)));
                                 _ ->
                                   ?IS_KNOWN_TAG(right, 1, V@3)
                                     andalso (?IS_KNOWN_TAG(right, 1, V1)
                                       andalso ((Eq13(erlang:element(2, V@3)))
                                                (erlang:element(2, V1))))
                               end
                           end
                       end
                     end
                   },
                #{ compare =>
                   (erlang:map_get(compare1, Ord1Coproduct1(DictOrd11)))
                   (DictOrd)
                 , 'Eq0' =>
                   fun
                     (_) ->
                       EqCoproduct3
                   end
                 }
              end
          end
        end
    end
  end.

coproduct() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              coproduct(V, V1, V2)
          end
      end
  end.

coproduct(V, V1, V2) ->
  case V2 of
    {left, V2@1} ->
      V(V2@1);
    {right, V2@2} ->
      V1(V2@2);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

extendCoproduct() ->
  fun
    (DictExtend) ->
      extendCoproduct(DictExtend)
  end.

extendCoproduct(#{ 'Functor0' := DictExtend, extend := DictExtend@1 }) ->
  begin
    #{ map := V } = DictExtend(undefined),
    fun
      (#{ 'Functor0' := DictExtend1, extend := DictExtend1@1 }) ->
        begin
          #{ map := V@1 } = DictExtend1(undefined),
          FunctorCoproduct2 =
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
          #{ extend =>
             fun
               (F) ->
                 begin
                   V@2 =
                     DictExtend@1(fun
                       (X) ->
                         F({left, X})
                     end),
                   V@3 =
                     DictExtend1@1(fun
                       (X) ->
                         F({right, X})
                     end),
                   fun
                     (V2) ->
                       case V2 of
                         {left, V2@1} ->
                           {left, V@2(V2@1)};
                         {right, V2@2} ->
                           {right, V@3(V2@2)};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorCoproduct2
             end
           }
        end
    end
  end.

comonadCoproduct() ->
  fun
    (DictComonad) ->
      comonadCoproduct(DictComonad)
  end.

comonadCoproduct(DictComonad = #{ 'Extend0' := DictComonad@1 }) ->
  begin
    ExtendCoproduct1 = extendCoproduct(DictComonad@1(undefined)),
    fun
      (DictComonad1 = #{ 'Extend0' := DictComonad1@1 }) ->
        begin
          ExtendCoproduct2 = ExtendCoproduct1(DictComonad1@1(undefined)),
          #{ extract =>
             fun
               (V2) ->
                 case V2 of
                   {left, V2@1} ->
                     begin
                       #{ extract := DictComonad@2 } = DictComonad,
                       DictComonad@2(V2@1)
                     end;
                   {right, V2@2} ->
                     begin
                       #{ extract := DictComonad1@2 } = DictComonad1,
                       DictComonad1@2(V2@2)
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
           , 'Extend0' =>
             fun
               (_) ->
                 ExtendCoproduct2
             end
           }
        end
    end
  end.

bihoistCoproduct() ->
  fun
    (NatF) ->
      fun
        (NatG) ->
          fun
            (V) ->
              bihoistCoproduct(NatF, NatG, V)
          end
      end
  end.

bihoistCoproduct(NatF, NatG, V) ->
  case V of
    {left, V@1} ->
      {left, NatF(V@1)};
    {right, V@2} ->
      {right, NatG(V@2)};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

