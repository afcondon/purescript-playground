-module(effect@ps).
-export([ monadEffect/0
        , bindEffect/0
        , applyEffect/0
        , applicativeEffect/0
        , functorEffect/0
        , semigroupEffect/0
        , semigroupEffect/1
        , monoidEffect/0
        , monoidEffect/1
        , pureE/0
        , bindE/0
        , untilE/0
        , whileE/0
        , forE/0
        , foreachE/0
        ]).
-compile(no_auto_import).
monadEffect() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeEffect()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindEffect()
     end
   }.

bindEffect() ->
  #{ bind => bindE()
   , 'Apply0' =>
     fun
       (_) ->
         applyEffect()
     end
   }.

applyEffect() ->
  #{ apply =>
     fun
       (F) ->
         fun
           (A) ->
             fun
               () ->
                 begin
                   F_ = F(),
                   A_ = A(),
                   ((erlang:map_get(pure, applicativeEffect()))(F_(A_)))()
                 end
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorEffect()
     end
   }.

applicativeEffect() ->
  #{ pure => pureE()
   , 'Apply0' =>
     fun
       (_) ->
         applyEffect()
     end
   }.

functorEffect() ->
  #{ map =>
     fun
       (F) ->
         fun
           (A) ->
             fun
               () ->
                 begin
                   A_ = A(),
                   F(A_)
                 end
             end
         end
     end
   }.

semigroupEffect() ->
  fun
    (DictSemigroup) ->
      semigroupEffect(DictSemigroup)
  end.

semigroupEffect(#{ append := DictSemigroup }) ->
  #{ append =>
     fun
       (A) ->
         fun
           (B) ->
             fun
               () ->
                 begin
                   A_ = A(),
                   A_@1 = B(),
                   (DictSemigroup(A_))(A_@1)
                 end
             end
         end
     end
   }.

monoidEffect() ->
  fun
    (DictMonoid) ->
      monoidEffect(DictMonoid)
  end.

monoidEffect(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    SemigroupEffect1 =
      #{ append =>
         fun
           (A) ->
             fun
               (B) ->
                 fun
                   () ->
                     begin
                       A_ = A(),
                       A_@1 = B(),
                       (V(A_))(A_@1)
                     end
                 end
             end
         end
       },
    #{ mempty =>
       fun
         () ->
           DictMonoid@1
       end
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupEffect1
       end
     }
  end.

pureE() ->
  fun
    (V) ->
      effect@foreign:pureE(V)
  end.

bindE() ->
  fun
    (V) ->
      effect@foreign:bindE(V)
  end.

untilE() ->
  fun
    (V) ->
      effect@foreign:untilE(V)
  end.

whileE() ->
  fun
    (V) ->
      effect@foreign:whileE(V)
  end.

forE() ->
  fun
    (V) ->
      effect@foreign:forE(V)
  end.

foreachE() ->
  fun
    (V) ->
      effect@foreign:foreachE(V)
  end.

