-module(data_functor_product@ps).
-export([ 'Product'/0
        , 'Product'/1
        , showProduct/0
        , showProduct/2
        , product/0
        , product/2
        , newtypeProduct/0
        , functorProduct/0
        , functorProduct/2
        , eq1Product/0
        , eq1Product/2
        , eqProduct/0
        , eqProduct/3
        , ord1Product/0
        , ord1Product/1
        , ordProduct/0
        , ordProduct/1
        , bihoistProduct/0
        , bihoistProduct/3
        , applyProduct/0
        , applyProduct/1
        , bindProduct/0
        , bindProduct/1
        , applicativeProduct/0
        , applicativeProduct/1
        , monadProduct/0
        , monadProduct/1
        ]).
-compile(no_auto_import).
'Product'() ->
  fun
    (X) ->
      'Product'(X)
  end.

'Product'(X) ->
  X.

showProduct() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showProduct(DictShow, DictShow1)
      end
  end.

showProduct(#{ show := DictShow }, #{ show := DictShow1 }) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(product ",
           (DictShow(erlang:element(2, V)))/binary,
           " ",
           (DictShow1(erlang:element(3, V)))/binary,
           ")"
         >>
     end
   }.

product() ->
  fun
    (Fa) ->
      fun
        (Ga) ->
          product(Fa, Ga)
      end
  end.

product(Fa, Ga) ->
  {tuple, Fa, Ga}.

newtypeProduct() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

functorProduct() ->
  fun
    (DictFunctor) ->
      fun
        (DictFunctor1) ->
          functorProduct(DictFunctor, DictFunctor1)
      end
  end.

functorProduct(#{ map := DictFunctor }, #{ map := DictFunctor1 }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             { tuple
             , (DictFunctor(F))(erlang:element(2, V))
             , (DictFunctor1(F))(erlang:element(3, V))
             }
         end
     end
   }.

eq1Product() ->
  fun
    (DictEq1) ->
      fun
        (DictEq11) ->
          eq1Product(DictEq1, DictEq11)
      end
  end.

eq1Product(#{ eq1 := DictEq1 }, #{ eq1 := DictEq11 }) ->
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
                   ((Eq12(erlang:element(2, V)))(erlang:element(2, V1)))
                     andalso ((Eq13(erlang:element(3, V)))
                              (erlang:element(3, V1)))
               end
           end
         end
     end
   }.

eqProduct() ->
  fun
    (DictEq1) ->
      fun
        (DictEq11) ->
          fun
            (DictEq) ->
              eqProduct(DictEq1, DictEq11, DictEq)
          end
      end
  end.

eqProduct(#{ eq1 := DictEq1 }, #{ eq1 := DictEq11 }, DictEq) ->
  #{ eq =>
     begin
       Eq12 = DictEq1(DictEq),
       Eq13 = DictEq11(DictEq),
       fun
         (V) ->
           fun
             (V1) ->
               ((Eq12(erlang:element(2, V)))(erlang:element(2, V1)))
                 andalso ((Eq13(erlang:element(3, V)))(erlang:element(3, V1)))
           end
       end
     end
   }.

ord1Product() ->
  fun
    (DictOrd1) ->
      ord1Product(DictOrd1)
  end.

ord1Product(#{ 'Eq10' := DictOrd1, compare1 := DictOrd1@1 }) ->
  begin
    #{ eq1 := V } = DictOrd1(undefined),
    fun
      (#{ 'Eq10' := DictOrd11, compare1 := DictOrd11@1 }) ->
        begin
          #{ eq1 := V@1 } = DictOrd11(undefined),
          Eq1Product2 =
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
                             ((Eq12(erlang:element(2, V@2)))
                              (erlang:element(2, V1)))
                               andalso ((Eq13(erlang:element(3, V@2)))
                                        (erlang:element(3, V1)))
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
                           begin
                             V2 =
                               (Compare12(erlang:element(2, V@2)))
                               (erlang:element(2, V1)),
                             case V2 of
                               {eQ} ->
                                 (Compare13(erlang:element(3, V@2)))
                                 (erlang:element(3, V1));
                               _ ->
                                 V2
                             end
                           end
                       end
                   end
                 end
             end
           , 'Eq10' =>
             fun
               (_) ->
                 Eq1Product2
             end
           }
        end
    end
  end.

ordProduct() ->
  fun
    (DictOrd1) ->
      ordProduct(DictOrd1)
  end.

ordProduct(DictOrd1 = #{ 'Eq10' := DictOrd1@1 }) ->
  begin
    Ord1Product1 = ord1Product(DictOrd1),
    #{ eq1 := V } = DictOrd1@1(undefined),
    fun
      (DictOrd11 = #{ 'Eq10' := DictOrd11@1 }) ->
        begin
          #{ eq1 := V@1 } = DictOrd11@1(undefined),
          fun
            (DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
              begin
                V@2 = DictOrd@1(undefined),
                EqProduct3 =
                  #{ eq =>
                     begin
                       Eq12 = V(V@2),
                       Eq13 = V@1(V@2),
                       fun
                         (V@3) ->
                           fun
                             (V1) ->
                               ((Eq12(erlang:element(2, V@3)))
                                (erlang:element(2, V1)))
                                 andalso ((Eq13(erlang:element(3, V@3)))
                                          (erlang:element(3, V1)))
                           end
                       end
                     end
                   },
                #{ compare =>
                   (erlang:map_get(compare1, Ord1Product1(DictOrd11)))(DictOrd)
                 , 'Eq0' =>
                   fun
                     (_) ->
                       EqProduct3
                   end
                 }
              end
          end
        end
    end
  end.

bihoistProduct() ->
  fun
    (NatF) ->
      fun
        (NatG) ->
          fun
            (V) ->
              bihoistProduct(NatF, NatG, V)
          end
      end
  end.

bihoistProduct(NatF, NatG, V) ->
  {tuple, NatF(erlang:element(2, V)), NatG(erlang:element(3, V))}.

applyProduct() ->
  fun
    (DictApply) ->
      applyProduct(DictApply)
  end.

applyProduct(#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
  begin
    #{ map := V } = DictApply(undefined),
    fun
      (#{ 'Functor0' := DictApply1, apply := DictApply1@1 }) ->
        begin
          #{ map := V@1 } = DictApply1(undefined),
          FunctorProduct2 =
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
          #{ apply =>
             fun
               (V@2) ->
                 fun
                   (V1) ->
                     { tuple
                     , (DictApply@1(erlang:element(2, V@2)))
                       (erlang:element(2, V1))
                     , (DictApply1@1(erlang:element(3, V@2)))
                       (erlang:element(3, V1))
                     }
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorProduct2
             end
           }
        end
    end
  end.

bindProduct() ->
  fun
    (DictBind) ->
      bindProduct(DictBind)
  end.

bindProduct(#{ 'Apply0' := DictBind, bind := DictBind@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictBind(undefined),
    #{ map := V@2 } = V(undefined),
    fun
      (#{ 'Apply0' := DictBind1, bind := DictBind1@1 }) ->
        begin
          #{ 'Functor0' := V@3, apply := V@4 } = DictBind1(undefined),
          #{ map := V@5 } = V@3(undefined),
          ApplyProduct2 =
            begin
              FunctorProduct2 =
                #{ map =>
                   fun
                     (F) ->
                       fun
                         (V@6) ->
                           { tuple
                           , (V@2(F))(erlang:element(2, V@6))
                           , (V@5(F))(erlang:element(3, V@6))
                           }
                       end
                   end
                 },
              #{ apply =>
                 fun
                   (V@6) ->
                     fun
                       (V1) ->
                         { tuple
                         , (V@1(erlang:element(2, V@6)))(erlang:element(2, V1))
                         , (V@4(erlang:element(3, V@6)))(erlang:element(3, V1))
                         }
                     end
                 end
               , 'Functor0' =>
                 fun
                   (_) ->
                     FunctorProduct2
                 end
               }
            end,
          #{ bind =>
             fun
               (V@6) ->
                 fun
                   (F) ->
                     { tuple
                     , (DictBind@1(erlang:element(2, V@6)))
                       (fun
                         (X) ->
                           erlang:element(2, F(X))
                       end)
                     , (DictBind1@1(erlang:element(3, V@6)))
                       (fun
                         (X) ->
                           erlang:element(3, F(X))
                       end)
                     }
                 end
             end
           , 'Apply0' =>
             fun
               (_) ->
                 ApplyProduct2
             end
           }
        end
    end
  end.

applicativeProduct() ->
  fun
    (DictApplicative) ->
      applicativeProduct(DictApplicative)
  end.

applicativeProduct(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    #{ map := V@2 } = V(undefined),
    fun
      (#{ 'Apply0' := DictApplicative1, pure := DictApplicative1@1 }) ->
        begin
          #{ 'Functor0' := V@3, apply := V@4 } = DictApplicative1(undefined),
          #{ map := V@5 } = V@3(undefined),
          ApplyProduct2 =
            begin
              FunctorProduct2 =
                #{ map =>
                   fun
                     (F) ->
                       fun
                         (V@6) ->
                           { tuple
                           , (V@2(F))(erlang:element(2, V@6))
                           , (V@5(F))(erlang:element(3, V@6))
                           }
                       end
                   end
                 },
              #{ apply =>
                 fun
                   (V@6) ->
                     fun
                       (V1) ->
                         { tuple
                         , (V@1(erlang:element(2, V@6)))(erlang:element(2, V1))
                         , (V@4(erlang:element(3, V@6)))(erlang:element(3, V1))
                         }
                     end
                 end
               , 'Functor0' =>
                 fun
                   (_) ->
                     FunctorProduct2
                 end
               }
            end,
          #{ pure =>
             fun
               (A) ->
                 {tuple, DictApplicative@1(A), DictApplicative1@1(A)}
             end
           , 'Apply0' =>
             fun
               (_) ->
                 ApplyProduct2
             end
           }
        end
    end
  end.

monadProduct() ->
  fun
    (DictMonad) ->
      monadProduct(DictMonad)
  end.

monadProduct(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
  begin
    ApplicativeProduct1 = applicativeProduct(DictMonad(undefined)),
    BindProduct1 = bindProduct(DictMonad@1(undefined)),
    fun
      (#{ 'Applicative0' := DictMonad1, 'Bind1' := DictMonad1@1 }) ->
        begin
          ApplicativeProduct2 = ApplicativeProduct1(DictMonad1(undefined)),
          BindProduct2 = BindProduct1(DictMonad1@1(undefined)),
          #{ 'Applicative0' =>
             fun
               (_) ->
                 ApplicativeProduct2
             end
           , 'Bind1' =>
             fun
               (_) ->
                 BindProduct2
             end
           }
        end
    end
  end.

