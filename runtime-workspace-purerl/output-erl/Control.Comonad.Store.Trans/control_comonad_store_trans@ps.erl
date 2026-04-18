-module(control_comonad_store_trans@ps).
-export([ 'StoreT'/0
        , 'StoreT'/1
        , runStoreT/0
        , runStoreT/1
        , newtypeStoreT/0
        , functorStoreT/0
        , functorStoreT/1
        , extendStoreT/0
        , extendStoreT/1
        , comonadTransStoreT/0
        , comonadStoreT/0
        , comonadStoreT/1
        ]).
-compile(no_auto_import).
'StoreT'() ->
  fun
    (X) ->
      'StoreT'(X)
  end.

'StoreT'(X) ->
  X.

runStoreT() ->
  fun
    (V) ->
      runStoreT(V)
  end.

runStoreT(V) ->
  V.

newtypeStoreT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

functorStoreT() ->
  fun
    (DictFunctor) ->
      functorStoreT(DictFunctor)
  end.

functorStoreT(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             { tuple
             , (DictFunctor(fun
                  (H) ->
                    fun
                      (X) ->
                        F(H(X))
                    end
                end))
               (erlang:element(2, V))
             , erlang:element(3, V)
             }
         end
     end
   }.

extendStoreT() ->
  fun
    (DictExtend) ->
      extendStoreT(DictExtend)
  end.

extendStoreT(#{ 'Functor0' := DictExtend, extend := DictExtend@1 }) ->
  begin
    #{ map := V } = DictExtend(undefined),
    FunctorStoreT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 { tuple
                 , (V(fun
                      (H) ->
                        fun
                          (X) ->
                            F(H(X))
                        end
                    end))
                   (erlang:element(2, V@1))
                 , erlang:element(3, V@1)
                 }
             end
         end
       },
    #{ extend =>
       fun
         (F) ->
           fun
             (V@1) ->
               { tuple
               , (DictExtend@1(fun
                    (W_) ->
                      fun
                        (S_) ->
                          F({tuple, W_, S_})
                      end
                  end))
                 (erlang:element(2, V@1))
               , erlang:element(3, V@1)
               }
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorStoreT1
       end
     }
  end.

comonadTransStoreT() ->
  #{ lower =>
     fun
       (#{ 'Extend0' := DictComonad }) ->
         fun
           (V) ->
             begin
               V@1 = erlang:element(3, V),
               ((erlang:map_get(
                   map,
                   (erlang:map_get('Functor0', DictComonad(undefined)))
                   (undefined)
                 ))
                (fun
                  (V1) ->
                    V1(V@1)
                end))
               (erlang:element(2, V))
             end
         end
     end
   }.

comonadStoreT() ->
  fun
    (DictComonad) ->
      comonadStoreT(DictComonad)
  end.

comonadStoreT(#{ 'Extend0' := DictComonad, extract := DictComonad@1 }) ->
  begin
    #{ 'Functor0' := V, extend := V@1 } = DictComonad(undefined),
    #{ map := V@2 } = V(undefined),
    ExtendStoreT1 =
      begin
        FunctorStoreT1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@3) ->
                     { tuple
                     , (V@2(fun
                          (H) ->
                            fun
                              (X) ->
                                F(H(X))
                            end
                        end))
                       (erlang:element(2, V@3))
                     , erlang:element(3, V@3)
                     }
                 end
             end
           },
        #{ extend =>
           fun
             (F) ->
               fun
                 (V@3) ->
                   { tuple
                   , (V@1(fun
                        (W_) ->
                          fun
                            (S_) ->
                              F({tuple, W_, S_})
                          end
                      end))
                     (erlang:element(2, V@3))
                   , erlang:element(3, V@3)
                   }
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorStoreT1
           end
         }
      end,
    #{ extract =>
       fun
         (V@3) ->
           (DictComonad@1(erlang:element(2, V@3)))(erlang:element(3, V@3))
       end
     , 'Extend0' =>
       fun
         (_) ->
           ExtendStoreT1
       end
     }
  end.

