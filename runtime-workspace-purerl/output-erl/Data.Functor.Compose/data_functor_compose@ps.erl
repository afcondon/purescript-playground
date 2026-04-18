-module(data_functor_compose@ps).
-export([ 'Compose'/0
        , 'Compose'/1
        , showCompose/0
        , showCompose/1
        , newtypeCompose/0
        , functorCompose/0
        , functorCompose/2
        , eqCompose/0
        , eqCompose/3
        , ordCompose/0
        , ordCompose/1
        , eq1Compose/0
        , eq1Compose/2
        , ord1Compose/0
        , ord1Compose/1
        , bihoistCompose/0
        , bihoistCompose/4
        , applyCompose/0
        , applyCompose/1
        , applicativeCompose/0
        , applicativeCompose/1
        , altCompose/0
        , altCompose/1
        , plusCompose/0
        , plusCompose/1
        , alternativeCompose/0
        , alternativeCompose/1
        ]).
-compile(no_auto_import).
'Compose'() ->
  fun
    (X) ->
      'Compose'(X)
  end.

'Compose'(X) ->
  X.

showCompose() ->
  fun
    (DictShow) ->
      showCompose(DictShow)
  end.

showCompose(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Compose ", (DictShow(V))/binary, ")">>
     end
   }.

newtypeCompose() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

functorCompose() ->
  fun
    (DictFunctor) ->
      fun
        (DictFunctor1) ->
          functorCompose(DictFunctor, DictFunctor1)
      end
  end.

functorCompose(#{ map := DictFunctor }, #{ map := DictFunctor1 }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             (DictFunctor(DictFunctor1(F)))(V)
         end
     end
   }.

eqCompose() ->
  fun
    (DictEq1) ->
      fun
        (DictEq11) ->
          fun
            (DictEq) ->
              eqCompose(DictEq1, DictEq11, DictEq)
          end
      end
  end.

eqCompose(#{ eq1 := DictEq1 }, #{ eq1 := DictEq11 }, DictEq) ->
  begin
    Eq11@1 =
      DictEq1(begin
        Eq11 = DictEq11(DictEq),
        #{ eq =>
           fun
             (X) ->
               fun
                 (Y) ->
                   (Eq11(X))(Y)
               end
           end
         }
      end),
    #{ eq =>
       fun
         (V) ->
           fun
             (V1) ->
               (Eq11@1(V))(V1)
           end
       end
     }
  end.

ordCompose() ->
  fun
    (DictOrd1) ->
      ordCompose(DictOrd1)
  end.

ordCompose(#{ 'Eq10' := DictOrd1, compare1 := DictOrd1@1 }) ->
  begin
    #{ eq1 := V } = DictOrd1(undefined),
    fun
      (#{ 'Eq10' := DictOrd11, compare1 := DictOrd11@1 }) ->
        begin
          #{ eq1 := V@1 } = DictOrd11(undefined),
          #{ eq1 := V@2 } = DictOrd11(undefined),
          fun
            (DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
              begin
                Compare11@1 =
                  DictOrd1@1(begin
                    Compare11 = DictOrd11@1(DictOrd),
                    Eq11 = V@1(DictOrd@1(undefined)),
                    EqApp2 =
                      #{ eq =>
                         fun
                           (X) ->
                             fun
                               (Y) ->
                                 (Eq11(X))(Y)
                             end
                         end
                       },
                    #{ compare =>
                       fun
                         (X) ->
                           fun
                             (Y) ->
                               (Compare11(X))(Y)
                           end
                       end
                     , 'Eq0' =>
                       fun
                         (_) ->
                           EqApp2
                       end
                     }
                  end),
                Eq11@2 =
                  V(begin
                    Eq11@1 = V@2(DictOrd@1(undefined)),
                    #{ eq =>
                       fun
                         (X) ->
                           fun
                             (Y) ->
                               (Eq11@1(X))(Y)
                           end
                       end
                     }
                  end),
                EqCompose3 =
                  #{ eq =>
                     fun
                       (V@3) ->
                         fun
                           (V1) ->
                             (Eq11@2(V@3))(V1)
                         end
                     end
                   },
                #{ compare =>
                   fun
                     (V@3) ->
                       fun
                         (V1) ->
                           (Compare11@1(V@3))(V1)
                       end
                   end
                 , 'Eq0' =>
                   fun
                     (_) ->
                       EqCompose3
                   end
                 }
              end
          end
        end
    end
  end.

eq1Compose() ->
  fun
    (DictEq1) ->
      fun
        (DictEq11) ->
          eq1Compose(DictEq1, DictEq11)
      end
  end.

eq1Compose(#{ eq1 := DictEq1 }, #{ eq1 := DictEq11 }) ->
  #{ eq1 =>
     fun
       (DictEq) ->
         DictEq1(begin
           Eq11 = DictEq11(DictEq),
           #{ eq =>
              fun
                (X) ->
                  fun
                    (Y) ->
                      (Eq11(X))(Y)
                  end
              end
            }
         end)
     end
   }.

ord1Compose() ->
  fun
    (DictOrd1) ->
      ord1Compose(DictOrd1)
  end.

ord1Compose(DictOrd1 = #{ 'Eq10' := DictOrd1@1 }) ->
  begin
    OrdCompose1 = ordCompose(DictOrd1),
    #{ eq1 := V } = DictOrd1@1(undefined),
    fun
      (DictOrd11 = #{ 'Eq10' := DictOrd11@1 }) ->
        begin
          OrdCompose2 = OrdCompose1(DictOrd11),
          #{ eq1 := V@1 } = DictOrd11@1(undefined),
          Eq1Compose2 =
            #{ eq1 =>
               fun
                 (DictEq) ->
                   V(begin
                     Eq11 = V@1(DictEq),
                     #{ eq =>
                        fun
                          (X) ->
                            fun
                              (Y) ->
                                (Eq11(X))(Y)
                            end
                        end
                      }
                   end)
               end
             },
          #{ compare1 =>
             fun
               (DictOrd) ->
                 erlang:map_get(compare, OrdCompose2(DictOrd))
             end
           , 'Eq10' =>
             fun
               (_) ->
                 Eq1Compose2
             end
           }
        end
    end
  end.

bihoistCompose() ->
  fun
    (DictFunctor) ->
      fun
        (NatF) ->
          fun
            (NatG) ->
              fun
                (V) ->
                  bihoistCompose(DictFunctor, NatF, NatG, V)
              end
          end
      end
  end.

bihoistCompose(#{ map := DictFunctor }, NatF, NatG, V) ->
  NatF((DictFunctor(NatG))(V)).

applyCompose() ->
  fun
    (DictApply) ->
      applyCompose(DictApply)
  end.

applyCompose(#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
  begin
    #{ map := Functor0 } = DictApply(undefined),
    fun
      (#{ 'Functor0' := DictApply1, apply := DictApply1@1 }) ->
        begin
          #{ map := V } = DictApply1(undefined),
          FunctorCompose2 =
            #{ map =>
               fun
                 (F) ->
                   fun
                     (V@1) ->
                       (Functor0(V(F)))(V@1)
                   end
               end
             },
          #{ apply =>
             fun
               (V@1) ->
                 fun
                   (V1) ->
                     (DictApply@1((Functor0(DictApply1@1))(V@1)))(V1)
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorCompose2
             end
           }
        end
    end
  end.

applicativeCompose() ->
  fun
    (DictApplicative) ->
      applicativeCompose(DictApplicative)
  end.

applicativeCompose(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    #{ 'Functor0' := V, apply := V@1 } = DictApplicative(undefined),
    #{ map := Functor0 } = V(undefined),
    fun
      (#{ 'Apply0' := DictApplicative1, pure := DictApplicative1@1 }) ->
        begin
          #{ 'Functor0' := V@2, apply := V@3 } = DictApplicative1(undefined),
          ApplyCompose2 =
            begin
              #{ map := V@4 } = V@2(undefined),
              FunctorCompose2 =
                #{ map =>
                   fun
                     (F) ->
                       fun
                         (V@5) ->
                           (Functor0(V@4(F)))(V@5)
                       end
                   end
                 },
              #{ apply =>
                 fun
                   (V@5) ->
                     fun
                       (V1) ->
                         (V@1((Functor0(V@3))(V@5)))(V1)
                     end
                 end
               , 'Functor0' =>
                 fun
                   (_) ->
                     FunctorCompose2
                 end
               }
            end,
          #{ pure =>
             fun
               (X) ->
                 DictApplicative@1(DictApplicative1@1(X))
             end
           , 'Apply0' =>
             fun
               (_) ->
                 ApplyCompose2
             end
           }
        end
    end
  end.

altCompose() ->
  fun
    (DictAlt) ->
      altCompose(DictAlt)
  end.

altCompose(#{ 'Functor0' := DictAlt, alt := DictAlt@1 }) ->
  begin
    #{ map := V } = DictAlt(undefined),
    fun
      (#{ map := DictFunctor }) ->
        begin
          FunctorCompose2 =
            #{ map =>
               fun
                 (F) ->
                   fun
                     (V@1) ->
                       (V(DictFunctor(F)))(V@1)
                   end
               end
             },
          #{ alt =>
             fun
               (V@1) ->
                 fun
                   (V1) ->
                     (DictAlt@1(V@1))(V1)
                 end
             end
           , 'Functor0' =>
             fun
               (_) ->
                 FunctorCompose2
             end
           }
        end
    end
  end.

plusCompose() ->
  fun
    (DictPlus) ->
      plusCompose(DictPlus)
  end.

plusCompose(#{ 'Alt0' := DictPlus, empty := DictPlus@1 }) ->
  begin
    #{ 'Functor0' := V, alt := V@1 } = DictPlus(undefined),
    #{ map := V@2 } = V(undefined),
    fun
      (#{ map := DictFunctor }) ->
        begin
          FunctorCompose2 =
            #{ map =>
               fun
                 (F) ->
                   fun
                     (V@3) ->
                       (V@2(DictFunctor(F)))(V@3)
                   end
               end
             },
          AltCompose2 =
            #{ alt =>
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
                   FunctorCompose2
               end
             },
          #{ empty => DictPlus@1
           , 'Alt0' =>
             fun
               (_) ->
                 AltCompose2
             end
           }
        end
    end
  end.

alternativeCompose() ->
  fun
    (DictAlternative) ->
      alternativeCompose(DictAlternative)
  end.

alternativeCompose(#{ 'Applicative0' := DictAlternative
                    , 'Plus1' := DictAlternative@1
                    }) ->
  begin
    ApplicativeCompose1 = applicativeCompose(DictAlternative(undefined)),
    #{ 'Alt0' := V, empty := V@1 } = DictAlternative@1(undefined),
    PlusCompose1 =
      begin
        #{ 'Functor0' := V@2, alt := V@3 } = V(undefined),
        #{ map := V@4 } = V@2(undefined),
        fun
          (#{ map := DictFunctor }) ->
            begin
              FunctorCompose2 =
                #{ map =>
                   fun
                     (F) ->
                       fun
                         (V@5) ->
                           (V@4(DictFunctor(F)))(V@5)
                       end
                   end
                 },
              AltCompose2 =
                #{ alt =>
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
                       FunctorCompose2
                   end
                 },
              #{ empty => V@1
               , 'Alt0' =>
                 fun
                   (_) ->
                     AltCompose2
                 end
               }
            end
        end
      end,
    fun
      (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
        begin
          ApplicativeCompose2 = ApplicativeCompose1(DictApplicative),
          PlusCompose2 =
            PlusCompose1((erlang:map_get(
                            'Functor0',
                            DictApplicative@1(undefined)
                          ))
                         (undefined)),
          #{ 'Applicative0' =>
             fun
               (_) ->
                 ApplicativeCompose2
             end
           , 'Plus1' =>
             fun
               (_) ->
                 PlusCompose2
             end
           }
        end
    end
  end.

