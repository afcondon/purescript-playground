-module(data_bifunctor_join@ps).
-export([ 'Join'/0
        , 'Join'/1
        , showJoin/0
        , showJoin/1
        , ordJoin/0
        , ordJoin/1
        , newtypeJoin/0
        , eqJoin/0
        , eqJoin/1
        , bifunctorJoin/0
        , bifunctorJoin/1
        , biapplyJoin/0
        , biapplyJoin/1
        , biapplicativeJoin/0
        , biapplicativeJoin/1
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

eqJoin() ->
  fun
    (DictEq) ->
      eqJoin(DictEq)
  end.

eqJoin(DictEq) ->
  DictEq.

bifunctorJoin() ->
  fun
    (DictBifunctor) ->
      bifunctorJoin(DictBifunctor)
  end.

bifunctorJoin(#{ bimap := DictBifunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             ((DictBifunctor(F))(F))(V)
         end
     end
   }.

biapplyJoin() ->
  fun
    (DictBiapply) ->
      biapplyJoin(DictBiapply)
  end.

biapplyJoin(#{ 'Bifunctor0' := DictBiapply, biapply := DictBiapply@1 }) ->
  begin
    #{ bimap := V } = DictBiapply(undefined),
    BifunctorJoin1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 ((V(F))(F))(V@1)
             end
         end
       },
    #{ apply =>
       fun
         (V@1) ->
           fun
             (V1) ->
               (DictBiapply@1(V@1))(V1)
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           BifunctorJoin1
       end
     }
  end.

biapplicativeJoin() ->
  fun
    (DictBiapplicative) ->
      biapplicativeJoin(DictBiapplicative)
  end.

biapplicativeJoin(#{ 'Biapply0' := DictBiapplicative
                   , bipure := DictBiapplicative@1
                   }) ->
  begin
    #{ 'Bifunctor0' := V, biapply := V@1 } = DictBiapplicative(undefined),
    #{ bimap := V@2 } = V(undefined),
    BiapplyJoin1 =
      begin
        BifunctorJoin1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@3) ->
                     ((V@2(F))(F))(V@3)
                 end
             end
           },
        #{ apply =>
           fun
             (V@3) ->
               fun
                 (V1) ->
                   (V@1(V@3))(V1)
               end
           end
         , 'Functor0' =>
           fun
             (_) ->
               BifunctorJoin1
           end
         }
      end,
    #{ pure =>
       fun
         (A) ->
           (DictBiapplicative@1(A))(A)
       end
     , 'Apply0' =>
       fun
         (_) ->
           BiapplyJoin1
       end
     }
  end.

