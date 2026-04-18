-module(data_functor_costar@ps).
-export([ 'Costar'/0
        , 'Costar'/1
        , semigroupoidCostar/0
        , semigroupoidCostar/1
        , profunctorCostar/0
        , profunctorCostar/1
        , strongCostar/0
        , strongCostar/1
        , newtypeCostar/0
        , hoistCostar/0
        , hoistCostar/3
        , functorCostar/0
        , invariantCostar/0
        , distributiveCostar/0
        , closedCostar/0
        , closedCostar/1
        , categoryCostar/0
        , categoryCostar/1
        , bifunctorCostar/0
        , bifunctorCostar/1
        , applyCostar/0
        , bindCostar/0
        , applicativeCostar/0
        , monadCostar/0
        ]).
-compile(no_auto_import).
'Costar'() ->
  fun
    (X) ->
      'Costar'(X)
  end.

'Costar'(X) ->
  X.

semigroupoidCostar() ->
  fun
    (DictExtend) ->
      semigroupoidCostar(DictExtend)
  end.

semigroupoidCostar(#{ extend := DictExtend }) ->
  #{ compose =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (W) ->
                 V((DictExtend(V1))(W))
             end
         end
     end
   }.

profunctorCostar() ->
  fun
    (DictFunctor) ->
      profunctorCostar(DictFunctor)
  end.

profunctorCostar(#{ map := DictFunctor }) ->
  #{ dimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 begin
                   V@1 = DictFunctor(F),
                   fun
                     (X) ->
                       G(V(V@1(X)))
                   end
                 end
             end
         end
     end
   }.

strongCostar() ->
  fun
    (DictComonad) ->
      strongCostar(DictComonad)
  end.

strongCostar(#{ 'Extend0' := DictComonad, extract := DictComonad@1 }) ->
  begin
    #{ map := Functor0 } =
      (erlang:map_get('Functor0', DictComonad(undefined)))(undefined),
    ProfunctorCostar1 =
      #{ dimap =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (V) ->
                     begin
                       V@1 = Functor0(F),
                       fun
                         (X) ->
                           G(V(V@1(X)))
                       end
                     end
                 end
             end
         end
       },
    #{ first =>
       fun
         (V) ->
           fun
             (X) ->
               { tuple
               , V((Functor0(data_tuple@ps:fst()))(X))
               , erlang:element(3, DictComonad@1(X))
               }
           end
       end
     , second =>
       fun
         (V) ->
           fun
             (X) ->
               { tuple
               , erlang:element(2, DictComonad@1(X))
               , V((Functor0(data_tuple@ps:snd()))(X))
               }
           end
       end
     , 'Profunctor0' =>
       fun
         (_) ->
           ProfunctorCostar1
       end
     }
  end.

newtypeCostar() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

hoistCostar() ->
  fun
    (F) ->
      fun
        (V) ->
          fun
            (X) ->
              hoistCostar(F, V, X)
          end
      end
  end.

hoistCostar(F, V, X) ->
  V(F(X)).

functorCostar() ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             fun
               (X) ->
                 F(V(X))
             end
         end
     end
   }.

invariantCostar() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V) ->
                 fun
                   (X) ->
                     F(V(X))
                 end
             end
         end
     end
   }.

distributiveCostar() ->
  #{ distribute =>
     fun
       (#{ map := DictFunctor }) ->
         fun
           (F) ->
             fun
               (A) ->
                 (DictFunctor(fun
                    (V) ->
                      V(A)
                  end))
                 (F)
             end
         end
     end
   , collect =>
     fun
       (DictFunctor = #{ map := DictFunctor@1 }) ->
         fun
           (F) ->
             begin
               V =
                 (erlang:map_get(distribute, distributiveCostar()))(DictFunctor),
               V@1 = DictFunctor@1(F),
               fun
                 (X) ->
                   V(V@1(X))
               end
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorCostar()
     end
   }.

closedCostar() ->
  fun
    (DictFunctor) ->
      closedCostar(DictFunctor)
  end.

closedCostar(#{ map := DictFunctor }) ->
  begin
    ProfunctorCostar1 =
      #{ dimap =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (V) ->
                     begin
                       V@1 = DictFunctor(F),
                       fun
                         (X) ->
                           G(V(V@1(X)))
                       end
                     end
                 end
             end
         end
       },
    #{ closed =>
       fun
         (V) ->
           fun
             (G) ->
               fun
                 (X) ->
                   V((DictFunctor(fun
                        (V1) ->
                          V1(X)
                      end))
                     (G))
               end
           end
       end
     , 'Profunctor0' =>
       fun
         (_) ->
           ProfunctorCostar1
       end
     }
  end.

categoryCostar() ->
  fun
    (DictComonad) ->
      categoryCostar(DictComonad)
  end.

categoryCostar(#{ 'Extend0' := DictComonad, extract := DictComonad@1 }) ->
  begin
    #{ extend := V } = DictComonad(undefined),
    SemigroupoidCostar1 =
      #{ compose =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 fun
                   (W) ->
                     V@1((V(V1))(W))
                 end
             end
         end
       },
    #{ identity => DictComonad@1
     , 'Semigroupoid0' =>
       fun
         (_) ->
           SemigroupoidCostar1
       end
     }
  end.

bifunctorCostar() ->
  fun
    (DictContravariant) ->
      bifunctorCostar(DictContravariant)
  end.

bifunctorCostar(#{ cmap := DictContravariant }) ->
  #{ bimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 begin
                   V@1 = DictContravariant(F),
                   fun
                     (X) ->
                       G(V(V@1(X)))
                   end
                 end
             end
         end
     end
   }.

applyCostar() ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (A) ->
                 (V(A))(V1(A))
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorCostar()
     end
   }.

bindCostar() ->
  #{ bind =>
     fun
       (V) ->
         fun
           (F) ->
             fun
               (X) ->
                 (F(V(X)))(X)
             end
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyCostar()
     end
   }.

applicativeCostar() ->
  #{ pure =>
     fun
       (A) ->
         fun
           (_) ->
             A
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyCostar()
     end
   }.

monadCostar() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeCostar()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindCostar()
     end
   }.

