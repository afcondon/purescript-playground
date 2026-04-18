-module(data_functor_flip@ps).
-export([ 'Flip'/0
        , 'Flip'/1
        , showFlip/0
        , showFlip/1
        , semigroupoidFlip/0
        , semigroupoidFlip/1
        , ordFlip/0
        , ordFlip/1
        , newtypeFlip/0
        , functorFlip/0
        , functorFlip/1
        , eqFlip/0
        , eqFlip/1
        , contravariantFlip/0
        , contravariantFlip/1
        , categoryFlip/0
        , categoryFlip/1
        , bifunctorFlip/0
        , bifunctorFlip/1
        , biapplyFlip/0
        , biapplyFlip/1
        , biapplicativeFlip/0
        , biapplicativeFlip/1
        ]).
-compile(no_auto_import).
'Flip'() ->
  fun
    (X) ->
      'Flip'(X)
  end.

'Flip'(X) ->
  X.

showFlip() ->
  fun
    (DictShow) ->
      showFlip(DictShow)
  end.

showFlip(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Flip ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupoidFlip() ->
  fun
    (DictSemigroupoid) ->
      semigroupoidFlip(DictSemigroupoid)
  end.

semigroupoidFlip(#{ compose := DictSemigroupoid }) ->
  #{ compose =>
     fun
       (V) ->
         fun
           (V1) ->
             (DictSemigroupoid(V1))(V)
         end
     end
   }.

ordFlip() ->
  fun
    (DictOrd) ->
      ordFlip(DictOrd)
  end.

ordFlip(DictOrd) ->
  DictOrd.

newtypeFlip() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

functorFlip() ->
  fun
    (DictBifunctor) ->
      functorFlip(DictBifunctor)
  end.

functorFlip(#{ bimap := DictBifunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             ((DictBifunctor(F))(data_bifunctor@ps:identity()))(V)
         end
     end
   }.

eqFlip() ->
  fun
    (DictEq) ->
      eqFlip(DictEq)
  end.

eqFlip(DictEq) ->
  DictEq.

contravariantFlip() ->
  fun
    (DictProfunctor) ->
      contravariantFlip(DictProfunctor)
  end.

contravariantFlip(#{ dimap := DictProfunctor }) ->
  #{ cmap =>
     fun
       (F) ->
         fun
           (V) ->
             ((DictProfunctor(F))(data_profunctor@ps:identity()))(V)
         end
     end
   }.

categoryFlip() ->
  fun
    (DictCategory) ->
      categoryFlip(DictCategory)
  end.

categoryFlip(#{ 'Semigroupoid0' := DictCategory, identity := DictCategory@1 }) ->
  begin
    #{ compose := V } = DictCategory(undefined),
    SemigroupoidFlip1 =
      #{ compose =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 (V(V1))(V@1)
             end
         end
       },
    #{ identity => DictCategory@1
     , 'Semigroupoid0' =>
       fun
         (_) ->
           SemigroupoidFlip1
       end
     }
  end.

bifunctorFlip() ->
  fun
    (DictBifunctor) ->
      bifunctorFlip(DictBifunctor)
  end.

bifunctorFlip(#{ bimap := DictBifunctor }) ->
  #{ bimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 ((DictBifunctor(G))(F))(V)
             end
         end
     end
   }.

biapplyFlip() ->
  fun
    (DictBiapply) ->
      biapplyFlip(DictBiapply)
  end.

biapplyFlip(#{ 'Bifunctor0' := DictBiapply, biapply := DictBiapply@1 }) ->
  begin
    #{ bimap := V } = DictBiapply(undefined),
    BifunctorFlip1 =
      #{ bimap =>
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (V@1) ->
                     ((V(G))(F))(V@1)
                 end
             end
         end
       },
    #{ biapply =>
       fun
         (V@1) ->
           fun
             (V1) ->
               (DictBiapply@1(V@1))(V1)
           end
       end
     , 'Bifunctor0' =>
       fun
         (_) ->
           BifunctorFlip1
       end
     }
  end.

biapplicativeFlip() ->
  fun
    (DictBiapplicative) ->
      biapplicativeFlip(DictBiapplicative)
  end.

biapplicativeFlip(#{ 'Biapply0' := DictBiapplicative
                   , bipure := DictBiapplicative@1
                   }) ->
  begin
    #{ 'Bifunctor0' := V, biapply := V@1 } = DictBiapplicative(undefined),
    #{ bimap := V@2 } = V(undefined),
    BiapplyFlip1 =
      begin
        BifunctorFlip1 =
          #{ bimap =>
             fun
               (F) ->
                 fun
                   (G) ->
                     fun
                       (V@3) ->
                         ((V@2(G))(F))(V@3)
                     end
                 end
             end
           },
        #{ biapply =>
           fun
             (V@3) ->
               fun
                 (V1) ->
                   (V@1(V@3))(V1)
               end
           end
         , 'Bifunctor0' =>
           fun
             (_) ->
               BifunctorFlip1
           end
         }
      end,
    #{ bipure =>
       fun
         (A) ->
           fun
             (B) ->
               (DictBiapplicative@1(B))(A)
           end
       end
     , 'Biapply0' =>
       fun
         (_) ->
           BiapplyFlip1
       end
     }
  end.

