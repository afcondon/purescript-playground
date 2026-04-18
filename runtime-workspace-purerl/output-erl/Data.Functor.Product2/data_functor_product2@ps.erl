-module(data_functor_product2@ps).
-export([ 'Product2'/0
        , showProduct2/0
        , showProduct2/2
        , profunctorProduct2/0
        , profunctorProduct2/2
        , functorProduct2/0
        , functorProduct2/2
        , eqProduct2/0
        , eqProduct2/2
        , ordProduct2/0
        , ordProduct2/1
        , bifunctorProduct2/0
        , bifunctorProduct2/2
        , biapplyProduct2/0
        , biapplyProduct2/1
        , biapplicativeProduct2/0
        , biapplicativeProduct2/1
        ]).
-compile(no_auto_import).
'Product2'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {product2, Value0, Value1}
      end
  end.

showProduct2() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showProduct2(DictShow, DictShow1)
      end
  end.

showProduct2(#{ show := DictShow }, #{ show := DictShow1 }) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(Product2 ",
           (DictShow(erlang:element(2, V)))/binary,
           " ",
           (DictShow1(erlang:element(3, V)))/binary,
           ")"
         >>
     end
   }.

profunctorProduct2() ->
  fun
    (DictProfunctor) ->
      fun
        (DictProfunctor1) ->
          profunctorProduct2(DictProfunctor, DictProfunctor1)
      end
  end.

profunctorProduct2(#{ dimap := DictProfunctor }, #{ dimap := DictProfunctor1 }) ->
  #{ dimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 { product2
                 , ((DictProfunctor(F))(G))(erlang:element(2, V))
                 , ((DictProfunctor1(F))(G))(erlang:element(3, V))
                 }
             end
         end
     end
   }.

functorProduct2() ->
  fun
    (DictFunctor) ->
      fun
        (DictFunctor1) ->
          functorProduct2(DictFunctor, DictFunctor1)
      end
  end.

functorProduct2(#{ map := DictFunctor }, #{ map := DictFunctor1 }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             { product2
             , (DictFunctor(F))(erlang:element(2, V))
             , (DictFunctor1(F))(erlang:element(3, V))
             }
         end
     end
   }.

eqProduct2() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          eqProduct2(DictEq, DictEq1)
      end
  end.

eqProduct2(#{ eq := DictEq }, DictEq1) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             ((DictEq(erlang:element(2, X)))(erlang:element(2, Y)))
               andalso (((erlang:map_get(eq, DictEq1))(erlang:element(3, X)))
                        (erlang:element(3, Y)))
         end
     end
   }.

ordProduct2() ->
  fun
    (DictOrd) ->
      ordProduct2(DictOrd)
  end.

ordProduct2(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    #{ eq := V } = DictOrd(undefined),
    fun
      (DictOrd1 = #{ 'Eq0' := DictOrd1@1 }) ->
        begin
          V@1 = DictOrd1@1(undefined),
          EqProduct22 =
            #{ eq =>
               fun
                 (X) ->
                   fun
                     (Y) ->
                       ((V(erlang:element(2, X)))(erlang:element(2, Y)))
                         andalso (((erlang:map_get(eq, V@1))
                                   (erlang:element(3, X)))
                                  (erlang:element(3, Y)))
                   end
               end
             },
          #{ compare =>
             fun
               (X) ->
                 fun
                   (Y) ->
                     begin
                       V@2 =
                         (DictOrd@1(erlang:element(2, X)))(erlang:element(2, Y)),
                       case V@2 of
                         {lT} ->
                           {lT};
                         {gT} ->
                           {gT};
                         _ ->
                           begin
                             #{ compare := DictOrd1@2 } = DictOrd1,
                             (DictOrd1@2(erlang:element(3, X)))
                             (erlang:element(3, Y))
                           end
                       end
                     end
                 end
             end
           , 'Eq0' =>
             fun
               (_) ->
                 EqProduct22
             end
           }
        end
    end
  end.

bifunctorProduct2() ->
  fun
    (DictBifunctor) ->
      fun
        (DictBifunctor1) ->
          bifunctorProduct2(DictBifunctor, DictBifunctor1)
      end
  end.

bifunctorProduct2(#{ bimap := DictBifunctor }, #{ bimap := DictBifunctor1 }) ->
  #{ bimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 { product2
                 , ((DictBifunctor(F))(G))(erlang:element(2, V))
                 , ((DictBifunctor1(F))(G))(erlang:element(3, V))
                 }
             end
         end
     end
   }.

biapplyProduct2() ->
  fun
    (DictBiapply) ->
      biapplyProduct2(DictBiapply)
  end.

biapplyProduct2(#{ 'Bifunctor0' := DictBiapply, biapply := DictBiapply@1 }) ->
  begin
    #{ bimap := V } = DictBiapply(undefined),
    fun
      (#{ 'Bifunctor0' := DictBiapply1, biapply := DictBiapply1@1 }) ->
        begin
          #{ bimap := V@1 } = DictBiapply1(undefined),
          BifunctorProduct22 =
            #{ bimap =>
               fun
                 (F) ->
                   fun
                     (G) ->
                       fun
                         (V@2) ->
                           { product2
                           , ((V(F))(G))(erlang:element(2, V@2))
                           , ((V@1(F))(G))(erlang:element(3, V@2))
                           }
                       end
                   end
               end
             },
          #{ biapply =>
             fun
               (V@2) ->
                 fun
                   (V1) ->
                     { product2
                     , (DictBiapply@1(erlang:element(2, V@2)))
                       (erlang:element(2, V1))
                     , (DictBiapply1@1(erlang:element(3, V@2)))
                       (erlang:element(3, V1))
                     }
                 end
             end
           , 'Bifunctor0' =>
             fun
               (_) ->
                 BifunctorProduct22
             end
           }
        end
    end
  end.

biapplicativeProduct2() ->
  fun
    (DictBiapplicative) ->
      biapplicativeProduct2(DictBiapplicative)
  end.

biapplicativeProduct2(#{ 'Biapply0' := DictBiapplicative
                       , bipure := DictBiapplicative@1
                       }) ->
  begin
    #{ 'Bifunctor0' := V, biapply := V@1 } = DictBiapplicative(undefined),
    #{ bimap := V@2 } = V(undefined),
    fun
      (#{ 'Biapply0' := DictBiapplicative1, bipure := DictBiapplicative1@1 }) ->
        begin
          #{ 'Bifunctor0' := V@3, biapply := V@4 } =
            DictBiapplicative1(undefined),
          #{ bimap := V@5 } = V@3(undefined),
          BiapplyProduct22 =
            begin
              BifunctorProduct22 =
                #{ bimap =>
                   fun
                     (F) ->
                       fun
                         (G) ->
                           fun
                             (V@6) ->
                               { product2
                               , ((V@2(F))(G))(erlang:element(2, V@6))
                               , ((V@5(F))(G))(erlang:element(3, V@6))
                               }
                           end
                       end
                   end
                 },
              #{ biapply =>
                 fun
                   (V@6) ->
                     fun
                       (V1) ->
                         { product2
                         , (V@1(erlang:element(2, V@6)))(erlang:element(2, V1))
                         , (V@4(erlang:element(3, V@6)))(erlang:element(3, V1))
                         }
                     end
                 end
               , 'Bifunctor0' =>
                 fun
                   (_) ->
                     BifunctorProduct22
                 end
               }
            end,
          #{ bipure =>
             fun
               (A) ->
                 fun
                   (B) ->
                     { product2
                     , (DictBiapplicative@1(A))(B)
                     , (DictBiapplicative1@1(A))(B)
                     }
                 end
             end
           , 'Biapply0' =>
             fun
               (_) ->
                 BiapplyProduct22
             end
           }
        end
    end
  end.

