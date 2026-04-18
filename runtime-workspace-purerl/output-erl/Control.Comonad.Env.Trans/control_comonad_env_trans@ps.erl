-module(control_comonad_env_trans@ps).
-export([ 'EnvT'/0
        , 'EnvT'/1
        , withEnvT/0
        , withEnvT/2
        , runEnvT/0
        , runEnvT/1
        , newtypeEnvT/0
        , mapEnvT/0
        , mapEnvT/2
        , functorEnvT/0
        , functorEnvT/1
        , foldableEnvT/0
        , foldableEnvT/1
        , traversableEnvT/0
        , traversableEnvT/1
        , extendEnvT/0
        , extendEnvT/1
        , comonadTransEnvT/0
        , comonadEnvT/0
        , comonadEnvT/1
        ]).
-compile(no_auto_import).
'EnvT'() ->
  fun
    (X) ->
      'EnvT'(X)
  end.

'EnvT'(X) ->
  X.

withEnvT() ->
  fun
    (F) ->
      fun
        (V) ->
          withEnvT(F, V)
      end
  end.

withEnvT(F, V) ->
  {tuple, F(erlang:element(2, V)), erlang:element(3, V)}.

runEnvT() ->
  fun
    (V) ->
      runEnvT(V)
  end.

runEnvT(V) ->
  V.

newtypeEnvT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

mapEnvT() ->
  fun
    (F) ->
      fun
        (V) ->
          mapEnvT(F, V)
      end
  end.

mapEnvT(F, V) ->
  {tuple, erlang:element(2, V), F(erlang:element(3, V))}.

functorEnvT() ->
  fun
    (DictFunctor) ->
      functorEnvT(DictFunctor)
  end.

functorEnvT(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             { tuple
             , erlang:element(2, V)
             , (DictFunctor(F))(erlang:element(3, V))
             }
         end
     end
   }.

foldableEnvT() ->
  fun
    (DictFoldable) ->
      foldableEnvT(DictFoldable)
  end.

foldableEnvT(#{ foldMap := DictFoldable
              , foldl := DictFoldable@1
              , foldr := DictFoldable@2
              }) ->
  #{ foldl =>
     fun
       (Fn) ->
         fun
           (A) ->
             fun
               (V) ->
                 ((DictFoldable@1(Fn))(A))(erlang:element(3, V))
             end
         end
     end
   , foldr =>
     fun
       (Fn) ->
         fun
           (A) ->
             fun
               (V) ->
                 ((DictFoldable@2(Fn))(A))(erlang:element(3, V))
             end
         end
     end
   , foldMap =>
     fun
       (DictMonoid) ->
         begin
           FoldMap1 = DictFoldable(DictMonoid),
           fun
             (Fn) ->
               fun
                 (V) ->
                   (FoldMap1(Fn))(erlang:element(3, V))
               end
           end
         end
     end
   }.

traversableEnvT() ->
  fun
    (DictTraversable) ->
      traversableEnvT(DictTraversable)
  end.

traversableEnvT(#{ 'Foldable1' := DictTraversable
                 , 'Functor0' := DictTraversable@1
                 , sequence := DictTraversable@2
                 , traverse := DictTraversable@3
                 }) ->
  begin
    #{ map := V } = DictTraversable@1(undefined),
    FunctorEnvT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 {tuple, erlang:element(2, V@1), (V(F))(erlang:element(3, V@1))}
             end
         end
       },
    #{ foldMap := V@1, foldl := V@2, foldr := V@3 } = DictTraversable(undefined),
    FoldableEnvT1 =
      #{ foldl =>
         fun
           (Fn) ->
             fun
               (A) ->
                 fun
                   (V@4) ->
                     ((V@2(Fn))(A))(erlang:element(3, V@4))
                 end
             end
         end
       , foldr =>
         fun
           (Fn) ->
             fun
               (A) ->
                 fun
                   (V@4) ->
                     ((V@3(Fn))(A))(erlang:element(3, V@4))
                 end
             end
         end
       , foldMap =>
         fun
           (DictMonoid) ->
             begin
               FoldMap1 = V@1(DictMonoid),
               fun
                 (Fn) ->
                   fun
                     (V@4) ->
                       (FoldMap1(Fn))(erlang:element(3, V@4))
                   end
               end
             end
         end
       },
    #{ sequence =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Sequence1 = DictTraversable@2(DictApplicative),
             fun
               (V@4) ->
                 ((erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined)
                   ))
                  ((data_tuple@ps:'Tuple'())(erlang:element(2, V@4))))
                 (Sequence1(erlang:element(3, V@4)))
             end
           end
       end
     , traverse =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             Traverse1 = DictTraversable@3(DictApplicative),
             fun
               (F) ->
                 fun
                   (V@4) ->
                     ((erlang:map_get(
                         map,
                         (erlang:map_get(
                            'Functor0',
                            DictApplicative@1(undefined)
                          ))
                         (undefined)
                       ))
                      ((data_tuple@ps:'Tuple'())(erlang:element(2, V@4))))
                     ((Traverse1(F))(erlang:element(3, V@4)))
                 end
             end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorEnvT1
       end
     , 'Foldable1' =>
       fun
         (_) ->
           FoldableEnvT1
       end
     }
  end.

extendEnvT() ->
  fun
    (DictExtend) ->
      extendEnvT(DictExtend)
  end.

extendEnvT(#{ 'Functor0' := DictExtend, extend := DictExtend@1 }) ->
  begin
    #{ map := Functor0 } = DictExtend(undefined),
    FunctorEnvT1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V) ->
                 { tuple
                 , erlang:element(2, V)
                 , (Functor0(F))(erlang:element(3, V))
                 }
             end
         end
       },
    #{ extend =>
       fun
         (F) ->
           fun
             (V) ->
               { tuple
               , erlang:element(2, V)
               , (Functor0(F))
                 ((DictExtend@1((data_tuple@ps:'Tuple'())(erlang:element(2, V))))
                  (erlang:element(3, V)))
               }
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorEnvT1
       end
     }
  end.

comonadTransEnvT() ->
  #{ lower =>
     fun
       (_) ->
         fun
           (V) ->
             erlang:element(3, V)
         end
     end
   }.

comonadEnvT() ->
  fun
    (DictComonad) ->
      comonadEnvT(DictComonad)
  end.

comonadEnvT(#{ 'Extend0' := DictComonad, extract := DictComonad@1 }) ->
  begin
    ExtendEnvT1 = extendEnvT(DictComonad(undefined)),
    #{ extract =>
       fun
         (V) ->
           DictComonad@1(erlang:element(3, V))
       end
     , 'Extend0' =>
       fun
         (_) ->
           ExtendEnvT1
       end
     }
  end.

