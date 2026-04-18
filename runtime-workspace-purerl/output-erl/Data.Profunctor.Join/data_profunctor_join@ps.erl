-module(data_profunctor_join@ps).
-export([ 'Join'/0
        , 'Join'/1
        , showJoin/0
        , showJoin/1
        , semigroupJoin/0
        , semigroupJoin/1
        , ordJoin/0
        , ordJoin/1
        , newtypeJoin/0
        , monoidJoin/0
        , monoidJoin/1
        , invariantJoin/0
        , invariantJoin/1
        , eqJoin/0
        , eqJoin/1
        ]).
-compile(no_auto_import).
'Join'() ->
  fun
    (X) ->
      'Join'(X)
  end.

'Join'(X) ->
  X.

showJoin() ->
  fun
    (DictShow) ->
      showJoin(DictShow)
  end.

showJoin(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Join ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupJoin() ->
  fun
    (DictSemigroupoid) ->
      semigroupJoin(DictSemigroupoid)
  end.

semigroupJoin(#{ compose := DictSemigroupoid }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemigroupoid(V))(V1)
         end
     end
   }.

ordJoin() ->
  fun
    (DictOrd) ->
      ordJoin(DictOrd)
  end.

ordJoin(DictOrd) ->
  DictOrd.

newtypeJoin() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidJoin() ->
  fun
    (DictCategory) ->
      monoidJoin(DictCategory)
  end.

monoidJoin(#{ 'Semigroupoid0' := DictCategory, identity := DictCategory@1 }) ->
  begin
    #{ compose := V } = DictCategory(undefined),
    SemigroupJoin1 =
      #{ append =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 (V(V@1))(V1)
             end
         end
       },
    #{ mempty => DictCategory@1
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupJoin1
       end
     }
  end.

invariantJoin() ->
  fun
    (DictProfunctor) ->
      invariantJoin(DictProfunctor)
  end.

invariantJoin(#{ dimap := DictProfunctor }) ->
  #{ imap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 ((DictProfunctor(G))(F))(V)
             end
         end
     end
   }.

eqJoin() ->
  fun
    (DictEq) ->
      eqJoin(DictEq)
  end.

eqJoin(DictEq) ->
  DictEq.

