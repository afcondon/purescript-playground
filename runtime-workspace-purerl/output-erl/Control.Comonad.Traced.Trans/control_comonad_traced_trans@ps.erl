-module(control_comonad_traced_trans@ps).
-export([ 'TracedT'/0
        , 'TracedT'/1
        , runTracedT/0
        , runTracedT/1
        , newtypeTracedT/0
        , functorTracedT/0
        , functorTracedT/1
        , extendTracedT/0
        , extendTracedT/1
        , comonadTransTracedT/0
        , comonadTransTracedT/1
        , comonadTracedT/0
        , comonadTracedT/1
        ]).
-compile(no_auto_import).
'TracedT'() ->
  fun
    (X) ->
      'TracedT'(X)
  end.

'TracedT'(X) ->
  X.

runTracedT() ->
  fun
    (V) ->
      runTracedT(V)
  end.

runTracedT(V) ->
  V.

newtypeTracedT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

functorTracedT() ->
  fun
    (DictFunctor) ->
      functorTracedT(DictFunctor)
  end.

functorTracedT(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             (DictFunctor(fun
                (G) ->
                  fun
                    (T) ->
                      F(G(T))
                  end
              end))
             (V)
         end
     end
   }.

extendTracedT() ->
  fun
    (DictExtend) ->
      extendTracedT(DictExtend)
  end.

extendTracedT(#{ 'Functor0' := DictExtend, extend := DictExtend@1 }) ->
  begin
    #{ map := Functor0 } = DictExtend(undefined),
    FunctorTracedT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V) ->
                 (Functor0(fun
                    (G) ->
                      fun
                        (T) ->
                          F(G(T))
                      end
                  end))
                 (V)
             end
         end
       },
    fun
      (#{ append := DictSemigroup }) ->
        #{ extend =>
           fun
             (F) ->
               fun
                 (V) ->
                   (DictExtend@1(fun
                      (W_) ->
                        fun
                          (T) ->
                            F((Functor0(fun
                                 (H) ->
                                   fun
                                     (T_) ->
                                       H((DictSemigroup(T))(T_))
                                   end
                               end))
                              (W_))
                        end
                    end))
                   (V)
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               FunctorTracedT1
           end
         }
    end
  end.

comonadTransTracedT() ->
  fun
    (DictMonoid) ->
      comonadTransTracedT(DictMonoid)
  end.

comonadTransTracedT(#{ mempty := DictMonoid }) ->
  #{ lower =>
     fun
       (#{ 'Extend0' := DictComonad }) ->
         fun
           (V) ->
             ((erlang:map_get(
                 map,
                 (erlang:map_get('Functor0', DictComonad(undefined)))(undefined)
               ))
              (fun
                (F) ->
                  F(DictMonoid)
              end))
             (V)
         end
     end
   }.

comonadTracedT() ->
  fun
    (DictComonad) ->
      comonadTracedT(DictComonad)
  end.

comonadTracedT(#{ 'Extend0' := DictComonad, extract := DictComonad@1 }) ->
  begin
    #{ 'Functor0' := V, extend := V@1 } = DictComonad(undefined),
    #{ map := Functor0 } = V(undefined),
    ExtendTracedT1 =
      begin
        FunctorTracedT1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@2) ->
                     (Functor0(fun
                        (G) ->
                          fun
                            (T) ->
                              F(G(T))
                          end
                      end))
                     (V@2)
                 end
             end
           },
        fun
          (#{ append := DictSemigroup }) ->
            #{ extend =>
               fun
                 (F) ->
                   fun
                     (V@2) ->
                       (V@1(fun
                          (W_) ->
                            fun
                              (T) ->
                                F((Functor0(fun
                                     (H) ->
                                       fun
                                         (T_) ->
                                           H((DictSemigroup(T))(T_))
                                       end
                                   end))
                                  (W_))
                            end
                        end))
                       (V@2)
                   end
               end
             , 'Functor0' =>
               fun
                 (_) ->
                   FunctorTracedT1
               end
             }
        end
      end,
    fun
      (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
        begin
          ExtendTracedT2 = ExtendTracedT1(DictMonoid(undefined)),
          #{ extract =>
             fun
               (V@2) ->
                 (DictComonad@1(V@2))(DictMonoid@1)
             end
           , 'Extend0' =>
             fun
               (_) ->
                 ExtendTracedT2
             end
           }
        end
    end
  end.

