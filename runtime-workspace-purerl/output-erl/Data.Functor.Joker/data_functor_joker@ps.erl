-module(data_functor_joker@ps).
-export([ 'Joker'/0
        , 'Joker'/1
        , showJoker/0
        , showJoker/1
        , profunctorJoker/0
        , profunctorJoker/1
        , ordJoker/0
        , ordJoker/1
        , newtypeJoker/0
        , hoistJoker/0
        , hoistJoker/2
        , functorJoker/0
        , functorJoker/1
        , eqJoker/0
        , eqJoker/1
        , choiceJoker/0
        , choiceJoker/1
        , bifunctorJoker/0
        , bifunctorJoker/1
        , biapplyJoker/0
        , biapplyJoker/1
        , biapplicativeJoker/0
        , biapplicativeJoker/1
        , applyJoker/0
        , applyJoker/1
        , bindJoker/0
        , bindJoker/1
        , applicativeJoker/0
        , applicativeJoker/1
        , monadJoker/0
        , monadJoker/1
        ]).
-compile(no_auto_import).
'Joker'() ->
  fun
    (X) ->
      'Joker'(X)
  end.

'Joker'(X) ->
  X.

showJoker() ->
  fun
    (DictShow) ->
      showJoker(DictShow)
  end.

showJoker(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Joker ", (DictShow(V))/binary, ")">>
     end
   }.

profunctorJoker() ->
  fun
    (DictFunctor) ->
      profunctorJoker(DictFunctor)
  end.

profunctorJoker(#{ map := DictFunctor }) ->
  #{ dimap =>
     fun
       (_) ->
         fun
           (G) ->
             fun
               (V1) ->
                 (DictFunctor(G))(V1)
             end
         end
     end
   }.

ordJoker() ->
  fun
    (DictOrd) ->
      ordJoker(DictOrd)
  end.

ordJoker(DictOrd) ->
  DictOrd.

newtypeJoker() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

hoistJoker() ->
  fun
    (F) ->
      fun
        (V) ->
          hoistJoker(F, V)
      end
  end.

hoistJoker(F, V) ->
  F(V).

functorJoker() ->
  fun
    (DictFunctor) ->
      functorJoker(DictFunctor)
  end.

functorJoker(#{ map := DictFunctor }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             (DictFunctor(F))(V)
         end
     end
   }.

eqJoker() ->
  fun
    (DictEq) ->
      eqJoker(DictEq)
  end.

eqJoker(DictEq) ->
  DictEq.

choiceJoker() ->
  fun
    (DictFunctor) ->
      choiceJoker(DictFunctor)
  end.

choiceJoker(#{ map := DictFunctor }) ->
  begin
    ProfunctorJoker1 =
      #{ dimap =>
         fun
           (_) ->
             fun
               (G) ->
                 fun
                   (V1) ->
                     (DictFunctor(G))(V1)
                 end
             end
         end
       },
    #{ left =>
       fun
         (V) ->
           (DictFunctor(data_either@ps:'Left'()))(V)
       end
     , right =>
       fun
         (V) ->
           (DictFunctor(data_either@ps:'Right'()))(V)
       end
     , 'Profunctor0' =>
       fun
         (_) ->
           ProfunctorJoker1
       end
     }
  end.

bifunctorJoker() ->
  fun
    (DictFunctor) ->
      bifunctorJoker(DictFunctor)
  end.

bifunctorJoker(#{ map := DictFunctor }) ->
  #{ bimap =>
     fun
       (_) ->
         fun
           (G) ->
             fun
               (V1) ->
                 (DictFunctor(G))(V1)
             end
         end
     end
   }.

biapplyJoker() ->
  fun
    (DictApply) ->
      biapplyJoker(DictApply)
  end.

biapplyJoker(#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
  begin
    #{ map := V } = DictApply(undefined),
    BifunctorJoker1 =
      #{ bimap =>
         fun
           (_) ->
             fun
               (G) ->
                 fun
                   (V1) ->
                     (V(G))(V1)
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
           BifunctorJoker1
       end
     }
  end.

biapplicativeJoker() ->
  fun
    (DictApplicative) ->
      biapplicativeJoker(DictApplicative)
  end.

biapplicativeJoker(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    #{ map := V@2 } = V(undefined),
    BiapplyJoker1 =
      begin
        BifunctorJoker1 =
          #{ bimap =>
             fun
               (_) ->
                 fun
                   (G) ->
                     fun
                       (V1) ->
                         (V@2(G))(V1)
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
               BifunctorJoker1
           end
         }
      end,
    #{ bipure =>
       fun
         (_) ->
           fun
             (B) ->
               DictApplicative@1(B)
           end
       end
     , 'Biapply0' =>
       fun
         (_) ->
           BiapplyJoker1
       end
     }
  end.

applyJoker() ->
  fun
    (DictApply) ->
      applyJoker(DictApply)
  end.

applyJoker(#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
  begin
    #{ map := V } = DictApply(undefined),
    FunctorJoker1 =
      #{ map =>
         fun
           (F) ->
             fun
               (V@1) ->
                 (V(F))(V@1)
             end
         end
       },
    #{ apply =>
       fun
         (V@1) ->
           fun
             (V1) ->
               (DictApply@1(V@1))(V1)
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorJoker1
       end
     }
  end.

bindJoker() ->
  fun
    (DictBind) ->
      bindJoker(DictBind)
  end.

bindJoker(#{ 'Apply0' := DictBind, bind := DictBind@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictBind(undefined),
    #{ map := V@2 } = V(undefined),
    ApplyJoker1 =
      begin
        FunctorJoker1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@3) ->
                     (V@2(F))(V@3)
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
               FunctorJoker1
           end
         }
      end,
    #{ bind =>
       fun
         (V@3) ->
           fun
             (Amb) ->
               (DictBind@1(V@3))
               (fun
                 (X) ->
                   Amb(X)
               end)
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyJoker1
       end
     }
  end.

applicativeJoker() ->
  fun
    (DictApplicative) ->
      applicativeJoker(DictApplicative)
  end.

applicativeJoker(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    #{ map := V@2 } = V(undefined),
    ApplyJoker1 =
      begin
        FunctorJoker1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@3) ->
                     (V@2(F))(V@3)
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
               FunctorJoker1
           end
         }
      end,
    #{ pure =>
       fun
         (X) ->
           DictApplicative@1(X)
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyJoker1
       end
     }
  end.

monadJoker() ->
  fun
    (DictMonad) ->
      monadJoker(DictMonad)
  end.

monadJoker(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
  begin
    #{ 'Apply0' := V, pure := V@1 } = DictMonad(undefined),
    #{ 'Functor0' := V@2, apply := V@3 } = V(undefined),
    ApplicativeJoker1 =
      begin
        #{ map := V@4 } = V@2(undefined),
        FunctorJoker1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@5) ->
                     (V@4(F))(V@5)
                 end
             end
           },
        ApplyJoker1 =
          #{ apply =>
             fun
               (V@5) ->
                 fun
                   (V1) ->
                     (V@3(V@5))(V1)
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorJoker1
             end
           },
        #{ pure =>
           fun
             (X) ->
               V@1(X)
           end
         , 'Apply0' =>
           fun
             (_) ->
               ApplyJoker1
           end
         }
      end,
    #{ 'Apply0' := V@5, bind := V@6 } = DictMonad@1(undefined),
    #{ 'Functor0' := V@7, apply := V@8 } = V@5(undefined),
    BindJoker1 =
      begin
        #{ map := V@9 } = V@7(undefined),
        FunctorJoker1@1 =
          #{ map =>
             fun
               (F) ->
                 fun
                   (V@10) ->
                     (V@9(F))(V@10)
                 end
             end
           },
        ApplyJoker1@1 =
          #{ apply =>
             fun
               (V@10) ->
                 fun
                   (V1) ->
                     (V@8(V@10))(V1)
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorJoker1@1
             end
           },
        #{ bind =>
           fun
             (V@10) ->
               fun
                 (Amb) ->
                   (V@6(V@10))
                   (fun
                     (X) ->
                       Amb(X)
                   end)
               end
           end
         , 'Apply0' =>
           fun
             (_) ->
               ApplyJoker1@1
           end
         }
      end,
    #{ 'Applicative0' =>
       fun
         (_) ->
           ApplicativeJoker1
       end
     , 'Bind1' =>
       fun
         (_) ->
           BindJoker1
       end
     }
  end.

