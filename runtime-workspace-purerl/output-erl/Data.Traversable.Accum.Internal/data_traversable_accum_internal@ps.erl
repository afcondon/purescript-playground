-module(data_traversable_accum_internal@ps).
-export([ 'StateR'/0
        , 'StateR'/1
        , 'StateL'/0
        , 'StateL'/1
        , stateR/0
        , stateR/1
        , stateL/0
        , stateL/1
        , functorStateR/0
        , functorStateL/0
        , applyStateR/0
        , applyStateL/0
        , applicativeStateR/0
        , applicativeStateL/0
        ]).
-compile(no_auto_import).
'StateR'() ->
  fun
    (X) ->
      'StateR'(X)
  end.

'StateR'(X) ->
  X.

'StateL'() ->
  fun
    (X) ->
      'StateL'(X)
  end.

'StateL'(X) ->
  X.

stateR() ->
  fun
    (V) ->
      stateR(V)
  end.

stateR(V) ->
  V.

stateL() ->
  fun
    (V) ->
      stateL(V)
  end.

stateL(V) ->
  V.

functorStateR() ->
  #{ map =>
     fun
       (F) ->
         fun
           (K) ->
             fun
               (S) ->
                 begin
                   #{ accum := V, value := V@1 } = K(S),
                   #{ accum => V, value => F(V@1) }
                 end
             end
         end
     end
   }.

functorStateL() ->
  #{ map =>
     fun
       (F) ->
         fun
           (K) ->
             fun
               (S) ->
                 begin
                   #{ accum := V, value := V@1 } = K(S),
                   #{ accum => V, value => F(V@1) }
                 end
             end
         end
     end
   }.

applyStateR() ->
  #{ apply =>
     fun
       (F) ->
         fun
           (X) ->
             fun
               (S) ->
                 begin
                   #{ accum := V, value := V@1 } = X(S),
                   #{ accum := V1, value := V1@1 } = F(V),
                   #{ accum => V1, value => V1@1(V@1) }
                 end
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorStateR()
     end
   }.

applyStateL() ->
  #{ apply =>
     fun
       (F) ->
         fun
           (X) ->
             fun
               (S) ->
                 begin
                   #{ accum := V, value := V@1 } = F(S),
                   #{ accum := V1, value := V1@1 } = X(V),
                   #{ accum => V1, value => V@1(V1@1) }
                 end
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorStateL()
     end
   }.

applicativeStateR() ->
  #{ pure =>
     fun
       (A) ->
         fun
           (S) ->
             #{ accum => S, value => A }
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyStateR()
     end
   }.

applicativeStateL() ->
  #{ pure =>
     fun
       (A) ->
         fun
           (S) ->
             #{ accum => S, value => A }
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyStateL()
     end
   }.

