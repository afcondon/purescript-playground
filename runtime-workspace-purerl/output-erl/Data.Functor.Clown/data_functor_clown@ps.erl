-module(data_functor_clown@ps).
-export([ 'Clown'/0
        , 'Clown'/1
        , showClown/0
        , showClown/1
        , profunctorClown/0
        , profunctorClown/1
        , ordClown/0
        , ordClown/1
        , newtypeClown/0
        , hoistClown/0
        , hoistClown/2
        , functorClown/0
        , eqClown/0
        , eqClown/1
        , bifunctorClown/0
        , bifunctorClown/1
        , biapplyClown/0
        , biapplyClown/1
        , biapplicativeClown/0
        , biapplicativeClown/1
        ]).
-compile(no_auto_import).
'Clown'() ->
  fun
    (X) ->
      'Clown'(X)
  end.

'Clown'(X) ->
  X.

showClown() ->
  fun
    (DictShow) ->
      showClown(DictShow)
  end.

showClown(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Clown ", (DictShow(V))/binary, ")">>
     end
   }.

profunctorClown() ->
  fun
    (DictContravariant) ->
      profunctorClown(DictContravariant)
  end.

profunctorClown(#{ cmap := DictContravariant }) ->
  #{ dimap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V1) ->
                 (DictContravariant(F))(V1)
             end
         end
     end
   }.

ordClown() ->
  fun
    (DictOrd) ->
      ordClown(DictOrd)
  end.

ordClown(DictOrd) ->
  DictOrd.

newtypeClown() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

hoistClown() ->
  fun
    (F) ->
      fun
        (V) ->
          hoistClown(F, V)
      end
  end.

hoistClown(F, V) ->
  F(V).

functorClown() ->
  #{ map =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   }.

eqClown() ->
  fun
    (DictEq) ->
      eqClown(DictEq)
  end.

eqClown(DictEq) ->
  DictEq.

bifunctorClown() ->
  fun
    (DictFunctor) ->
      bifunctorClown(DictFunctor)
  end.

bifunctorClown(#{ map := DictFunctor }) ->
  #{ bimap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V1) ->
                 (DictFunctor(F))(V1)
             end
         end
     end
   }.

biapplyClown() ->
  fun
    (DictApply) ->
      biapplyClown(DictApply)
  end.

biapplyClown(#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
  begin
    #{ map := V } = DictApply(undefined),
    BifunctorClown1 =
      #{ bimap =>
         fun
           (F) ->
             fun
               (_) ->
                 fun
                   (V1) ->
                     (V(F))(V1)
                 end
             end
         end
       },
    #{ biapply =>
       fun
         (V@1) ->
           fun
             (V1) ->
               (DictApply@1(V@1))(V1)
           end
       end
     , 'Bifunctor0' =>
       fun
         (_) ->
           BifunctorClown1
       end
     }
  end.

biapplicativeClown() ->
  fun
    (DictApplicative) ->
      biapplicativeClown(DictApplicative)
  end.

biapplicativeClown(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    #{ map := V@2 } = V(undefined),
    BiapplyClown1 =
      begin
        BifunctorClown1 =
          #{ bimap =>
             fun
               (F) ->
                 fun
                   (_) ->
                     fun
                       (V1) ->
                         (V@2(F))(V1)
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
               BifunctorClown1
           end
         }
      end,
    #{ bipure =>
       fun
         (A) ->
           fun
             (_) ->
               DictApplicative@1(A)
           end
       end
     , 'Biapply0' =>
       fun
         (_) ->
           BiapplyClown1
       end
     }
  end.

