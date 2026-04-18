-module(data_tuple@ps).
-export([ 'Tuple'/0
        , uncurry/0
        , uncurry/2
        , swap/0
        , swap/1
        , snd/0
        , snd/1
        , showTuple/0
        , showTuple/2
        , semiringTuple/0
        , semiringTuple/1
        , semigroupoidTuple/0
        , semigroupTuple/0
        , semigroupTuple/2
        , ringTuple/0
        , ringTuple/1
        , monoidTuple/0
        , monoidTuple/1
        , heytingAlgebraTuple/0
        , heytingAlgebraTuple/1
        , genericTuple/0
        , functorTuple/0
        , invariantTuple/0
        , fst/0
        , fst/1
        , lazyTuple/0
        , lazyTuple/2
        , extendTuple/0
        , eqTuple/0
        , eqTuple/2
        , ordTuple/0
        , ordTuple/1
        , eq1Tuple/0
        , eq1Tuple/1
        , ord1Tuple/0
        , ord1Tuple/1
        , curry/0
        , curry/3
        , comonadTuple/0
        , commutativeRingTuple/0
        , commutativeRingTuple/1
        , boundedTuple/0
        , boundedTuple/1
        , booleanAlgebraTuple/0
        , booleanAlgebraTuple/1
        , applyTuple/0
        , applyTuple/1
        , bindTuple/0
        , bindTuple/1
        , applicativeTuple/0
        , applicativeTuple/1
        , monadTuple/0
        , monadTuple/1
        ]).
-compile(no_auto_import).
'Tuple'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {tuple, Value0, Value1}
      end
  end.

uncurry() ->
  fun
    (F) ->
      fun
        (V) ->
          uncurry(F, V)
      end
  end.

uncurry(F, V) ->
  (F(erlang:element(2, V)))(erlang:element(3, V)).

swap() ->
  fun
    (V) ->
      swap(V)
  end.

swap(V) ->
  {tuple, erlang:element(3, V), erlang:element(2, V)}.

snd() ->
  fun
    (V) ->
      snd(V)
  end.

snd(V) ->
  erlang:element(3, V).

showTuple() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showTuple(DictShow, DictShow1)
      end
  end.

showTuple(#{ show := DictShow }, #{ show := DictShow1 }) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(Tuple ",
           (DictShow(erlang:element(2, V)))/binary,
           " ",
           (DictShow1(erlang:element(3, V)))/binary,
           ")"
         >>
     end
   }.

semiringTuple() ->
  fun
    (DictSemiring) ->
      semiringTuple(DictSemiring)
  end.

semiringTuple(#{ add := DictSemiring
               , mul := DictSemiring@1
               , one := DictSemiring@2
               , zero := DictSemiring@3
               }) ->
  fun
    (#{ add := DictSemiring1
      , mul := DictSemiring1@1
      , one := DictSemiring1@2
      , zero := DictSemiring1@3
      }) ->
      #{ add =>
         fun
           (V) ->
             fun
               (V1) ->
                 { tuple
                 , (DictSemiring(erlang:element(2, V)))(erlang:element(2, V1))
                 , (DictSemiring1(erlang:element(3, V)))(erlang:element(3, V1))
                 }
             end
         end
       , one => {tuple, DictSemiring@2, DictSemiring1@2}
       , mul =>
         fun
           (V) ->
             fun
               (V1) ->
                 { tuple
                 , (DictSemiring@1(erlang:element(2, V)))(erlang:element(2, V1))
                 , (DictSemiring1@1(erlang:element(3, V)))
                   (erlang:element(3, V1))
                 }
             end
         end
       , zero => {tuple, DictSemiring@3, DictSemiring1@3}
       }
  end.

semigroupoidTuple() ->
  #{ compose =>
     fun
       (V) ->
         fun
           (V1) ->
             {tuple, erlang:element(2, V1), erlang:element(3, V)}
         end
     end
   }.

semigroupTuple() ->
  fun
    (DictSemigroup) ->
      fun
        (DictSemigroup1) ->
          semigroupTuple(DictSemigroup, DictSemigroup1)
      end
  end.

semigroupTuple(#{ append := DictSemigroup }, #{ append := DictSemigroup1 }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             { tuple
             , (DictSemigroup(erlang:element(2, V)))(erlang:element(2, V1))
             , (DictSemigroup1(erlang:element(3, V)))(erlang:element(3, V1))
             }
         end
     end
   }.

ringTuple() ->
  fun
    (DictRing) ->
      ringTuple(DictRing)
  end.

ringTuple(#{ 'Semiring0' := DictRing, sub := DictRing@1 }) ->
  begin
    #{ add := V, mul := V@1, one := V@2, zero := V@3 } = DictRing(undefined),
    SemiringTuple1 =
      fun
        (#{ add := DictSemiring1
          , mul := DictSemiring1@1
          , one := DictSemiring1@2
          , zero := DictSemiring1@3
          }) ->
          #{ add =>
             fun
               (V@4) ->
                 fun
                   (V1) ->
                     { tuple
                     , (V(erlang:element(2, V@4)))(erlang:element(2, V1))
                     , (DictSemiring1(erlang:element(3, V@4)))
                       (erlang:element(3, V1))
                     }
                 end
             end
           , one => {tuple, V@2, DictSemiring1@2}
           , mul =>
             fun
               (V@4) ->
                 fun
                   (V1) ->
                     { tuple
                     , (V@1(erlang:element(2, V@4)))(erlang:element(2, V1))
                     , (DictSemiring1@1(erlang:element(3, V@4)))
                       (erlang:element(3, V1))
                     }
                 end
             end
           , zero => {tuple, V@3, DictSemiring1@3}
           }
      end,
    fun
      (#{ 'Semiring0' := DictRing1, sub := DictRing1@1 }) ->
        begin
          SemiringTuple2 = SemiringTuple1(DictRing1(undefined)),
          #{ sub =>
             fun
               (V@4) ->
                 fun
                   (V1) ->
                     { tuple
                     , (DictRing@1(erlang:element(2, V@4)))
                       (erlang:element(2, V1))
                     , (DictRing1@1(erlang:element(3, V@4)))
                       (erlang:element(3, V1))
                     }
                 end
             end
           , 'Semiring0' =>
             fun
               (_) ->
                 SemiringTuple2
             end
           }
        end
    end
  end.

monoidTuple() ->
  fun
    (DictMonoid) ->
      monoidTuple(DictMonoid)
  end.

monoidTuple(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    #{ append := V } = DictMonoid(undefined),
    fun
      (#{ 'Semigroup0' := DictMonoid1, mempty := DictMonoid1@1 }) ->
        begin
          #{ append := V@1 } = DictMonoid1(undefined),
          SemigroupTuple2 =
            #{ append =>
               fun
                 (V@2) ->
                   fun
                     (V1) ->
                       { tuple
                       , (V(erlang:element(2, V@2)))(erlang:element(2, V1))
                       , (V@1(erlang:element(3, V@2)))(erlang:element(3, V1))
                       }
                   end
               end
             },
          #{ mempty => {tuple, DictMonoid@1, DictMonoid1@1}
           , 'Semigroup0' =>
             fun
               (_) ->
                 SemigroupTuple2
             end
           }
        end
    end
  end.

heytingAlgebraTuple() ->
  fun
    (DictHeytingAlgebra) ->
      heytingAlgebraTuple(DictHeytingAlgebra)
  end.

heytingAlgebraTuple(#{ conj := DictHeytingAlgebra
                     , disj := DictHeytingAlgebra@1
                     , ff := DictHeytingAlgebra@2
                     , implies := DictHeytingAlgebra@3
                     , 'not' := DictHeytingAlgebra@4
                     , tt := DictHeytingAlgebra@5
                     }) ->
  fun
    (#{ conj := DictHeytingAlgebra1
      , disj := DictHeytingAlgebra1@1
      , ff := DictHeytingAlgebra1@2
      , implies := DictHeytingAlgebra1@3
      , 'not' := DictHeytingAlgebra1@4
      , tt := DictHeytingAlgebra1@5
      }) ->
      #{ tt => {tuple, DictHeytingAlgebra@5, DictHeytingAlgebra1@5}
       , ff => {tuple, DictHeytingAlgebra@2, DictHeytingAlgebra1@2}
       , implies =>
         fun
           (V) ->
             fun
               (V1) ->
                 { tuple
                 , (DictHeytingAlgebra@3(erlang:element(2, V)))
                   (erlang:element(2, V1))
                 , (DictHeytingAlgebra1@3(erlang:element(3, V)))
                   (erlang:element(3, V1))
                 }
             end
         end
       , conj =>
         fun
           (V) ->
             fun
               (V1) ->
                 { tuple
                 , (DictHeytingAlgebra(erlang:element(2, V)))
                   (erlang:element(2, V1))
                 , (DictHeytingAlgebra1(erlang:element(3, V)))
                   (erlang:element(3, V1))
                 }
             end
         end
       , disj =>
         fun
           (V) ->
             fun
               (V1) ->
                 { tuple
                 , (DictHeytingAlgebra@1(erlang:element(2, V)))
                   (erlang:element(2, V1))
                 , (DictHeytingAlgebra1@1(erlang:element(3, V)))
                   (erlang:element(3, V1))
                 }
             end
         end
       , 'not' =>
         fun
           (V) ->
             { tuple
             , DictHeytingAlgebra@4(erlang:element(2, V))
             , DictHeytingAlgebra1@4(erlang:element(3, V))
             }
         end
       }
  end.

genericTuple() ->
  #{ to =>
     fun
       (X) ->
         {tuple, erlang:element(2, X), erlang:element(3, X)}
     end
   , from =>
     fun
       (X) ->
         {product, erlang:element(2, X), erlang:element(3, X)}
     end
   }.

functorTuple() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             {tuple, erlang:element(2, M), F(erlang:element(3, M))}
         end
     end
   }.

invariantTuple() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (M) ->
                 {tuple, erlang:element(2, M), F(erlang:element(3, M))}
             end
         end
     end
   }.

fst() ->
  fun
    (V) ->
      fst(V)
  end.

fst(V) ->
  erlang:element(2, V).

lazyTuple() ->
  fun
    (DictLazy) ->
      fun
        (DictLazy1) ->
          lazyTuple(DictLazy, DictLazy1)
      end
  end.

lazyTuple(#{ defer := DictLazy }, #{ defer := DictLazy1 }) ->
  #{ defer =>
     fun
       (F) ->
         { tuple
         , DictLazy(fun
             (_) ->
               erlang:element(2, F(unit))
           end)
         , DictLazy1(fun
             (_) ->
               erlang:element(3, F(unit))
           end)
         }
     end
   }.

extendTuple() ->
  #{ extend =>
     fun
       (F) ->
         fun
           (V) ->
             {tuple, erlang:element(2, V), F(V)}
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorTuple()
     end
   }.

eqTuple() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          eqTuple(DictEq, DictEq1)
      end
  end.

eqTuple(#{ eq := DictEq }, DictEq1) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             ((DictEq(erlang:element(2, X)))(erlang:element(2, Y)))
               andalso (((erlang:map_get(eq, DictEq1))(erlang:element(3, X)))
                        (erlang:element(3, Y)))
         end
     end
   }.

ordTuple() ->
  fun
    (DictOrd) ->
      ordTuple(DictOrd)
  end.

ordTuple(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    #{ eq := V } = DictOrd(undefined),
    fun
      (DictOrd1 = #{ 'Eq0' := DictOrd1@1 }) ->
        begin
          V@1 = DictOrd1@1(undefined),
          EqTuple2 =
            #{ eq =>
               fun
                 (X) ->
                   fun
                     (Y) ->
                       ((V(erlang:element(2, X)))(erlang:element(2, Y)))
                         andalso (((erlang:map_get(eq, V@1))
                                   (erlang:element(3, X)))
                                  (erlang:element(3, Y)))
                   end
               end
             },
          #{ compare =>
             fun
               (X) ->
                 fun
                   (Y) ->
                     begin
                       V@2 =
                         (DictOrd@1(erlang:element(2, X)))(erlang:element(2, Y)),
                       case V@2 of
                         {lT} ->
                           {lT};
                         {gT} ->
                           {gT};
                         _ ->
                           begin
                             #{ compare := DictOrd1@2 } = DictOrd1,
                             (DictOrd1@2(erlang:element(3, X)))
                             (erlang:element(3, Y))
                           end
                       end
                     end
                 end
             end
           , 'Eq0' =>
             fun
               (_) ->
                 EqTuple2
             end
           }
        end
    end
  end.

eq1Tuple() ->
  fun
    (DictEq) ->
      eq1Tuple(DictEq)
  end.

eq1Tuple(#{ eq := DictEq }) ->
  #{ eq1 =>
     fun
       (DictEq1) ->
         fun
           (X) ->
             fun
               (Y) ->
                 ((DictEq(erlang:element(2, X)))(erlang:element(2, Y)))
                   andalso (((erlang:map_get(eq, DictEq1))
                             (erlang:element(3, X)))
                            (erlang:element(3, Y)))
             end
         end
     end
   }.

ord1Tuple() ->
  fun
    (DictOrd) ->
      ord1Tuple(DictOrd)
  end.

ord1Tuple(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    #{ eq := V } = DictOrd(undefined),
    Eq1Tuple1 =
      #{ eq1 =>
         fun
           (DictEq1) ->
             fun
               (X) ->
                 fun
                   (Y) ->
                     ((V(erlang:element(2, X)))(erlang:element(2, Y)))
                       andalso (((erlang:map_get(eq, DictEq1))
                                 (erlang:element(3, X)))
                                (erlang:element(3, Y)))
                 end
             end
         end
       },
    #{ compare1 =>
       fun
         (DictOrd1) ->
           fun
             (X) ->
               fun
                 (Y) ->
                   begin
                     V@1 =
                       (DictOrd@1(erlang:element(2, X)))(erlang:element(2, Y)),
                     case V@1 of
                       {lT} ->
                         {lT};
                       {gT} ->
                         {gT};
                       _ ->
                         begin
                           #{ compare := DictOrd1@1 } = DictOrd1,
                           (DictOrd1@1(erlang:element(3, X)))
                           (erlang:element(3, Y))
                         end
                     end
                   end
               end
           end
       end
     , 'Eq10' =>
       fun
         (_) ->
           Eq1Tuple1
       end
     }
  end.

curry() ->
  fun
    (F) ->
      fun
        (A) ->
          fun
            (B) ->
              curry(F, A, B)
          end
      end
  end.

curry(F, A, B) ->
  F({tuple, A, B}).

comonadTuple() ->
  #{ extract => snd()
   , 'Extend0' =>
     fun
       (_) ->
         extendTuple()
     end
   }.

commutativeRingTuple() ->
  fun
    (DictCommutativeRing) ->
      commutativeRingTuple(DictCommutativeRing)
  end.

commutativeRingTuple(#{ 'Ring0' := DictCommutativeRing }) ->
  begin
    RingTuple1 = ringTuple(DictCommutativeRing(undefined)),
    fun
      (#{ 'Ring0' := DictCommutativeRing1 }) ->
        begin
          RingTuple2 = RingTuple1(DictCommutativeRing1(undefined)),
          #{ 'Ring0' =>
             fun
               (_) ->
                 RingTuple2
             end
           }
        end
    end
  end.

boundedTuple() ->
  fun
    (DictBounded) ->
      boundedTuple(DictBounded)
  end.

boundedTuple(#{ 'Ord0' := DictBounded
              , bottom := DictBounded@1
              , top := DictBounded@2
              }) ->
  begin
    #{ 'Eq0' := V, compare := V@1 } = DictBounded(undefined),
    #{ eq := V@2 } = V(undefined),
    fun
      (#{ 'Ord0' := DictBounded1
        , bottom := DictBounded1@1
        , top := DictBounded1@2
        }) ->
        begin
          V@3 = #{ 'Eq0' := V@4 } = DictBounded1(undefined),
          V@5 = V@4(undefined),
          OrdTuple2 =
            begin
              EqTuple2 =
                #{ eq =>
                   fun
                     (X) ->
                       fun
                         (Y) ->
                           ((V@2(erlang:element(2, X)))(erlang:element(2, Y)))
                             andalso (((erlang:map_get(eq, V@5))
                                       (erlang:element(3, X)))
                                      (erlang:element(3, Y)))
                       end
                   end
                 },
              #{ compare =>
                 fun
                   (X) ->
                     fun
                       (Y) ->
                         begin
                           V@6 =
                             (V@1(erlang:element(2, X)))(erlang:element(2, Y)),
                           case V@6 of
                             {lT} ->
                               {lT};
                             {gT} ->
                               {gT};
                             _ ->
                               begin
                                 #{ compare := V@7 } = V@3,
                                 (V@7(erlang:element(3, X)))
                                 (erlang:element(3, Y))
                               end
                           end
                         end
                     end
                 end
               , 'Eq0' =>
                 fun
                   (_) ->
                     EqTuple2
                 end
               }
            end,
          #{ top => {tuple, DictBounded@2, DictBounded1@2}
           , bottom => {tuple, DictBounded@1, DictBounded1@1}
           , 'Ord0' =>
             fun
               (_) ->
                 OrdTuple2
             end
           }
        end
    end
  end.

booleanAlgebraTuple() ->
  fun
    (DictBooleanAlgebra) ->
      booleanAlgebraTuple(DictBooleanAlgebra)
  end.

booleanAlgebraTuple(#{ 'HeytingAlgebra0' := DictBooleanAlgebra }) ->
  begin
    HeytingAlgebraTuple1 = heytingAlgebraTuple(DictBooleanAlgebra(undefined)),
    fun
      (#{ 'HeytingAlgebra0' := DictBooleanAlgebra1 }) ->
        begin
          HeytingAlgebraTuple2 =
            HeytingAlgebraTuple1(DictBooleanAlgebra1(undefined)),
          #{ 'HeytingAlgebra0' =>
             fun
               (_) ->
                 HeytingAlgebraTuple2
             end
           }
        end
    end
  end.

applyTuple() ->
  fun
    (DictSemigroup) ->
      applyTuple(DictSemigroup)
  end.

applyTuple(#{ append := DictSemigroup }) ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             { tuple
             , (DictSemigroup(erlang:element(2, V)))(erlang:element(2, V1))
             , (erlang:element(3, V))(erlang:element(3, V1))
             }
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorTuple()
     end
   }.

bindTuple() ->
  fun
    (DictSemigroup) ->
      bindTuple(DictSemigroup)
  end.

bindTuple(DictSemigroup = #{ append := DictSemigroup@1 }) ->
  begin
    ApplyTuple1 = applyTuple(DictSemigroup),
    #{ bind =>
       fun
         (V) ->
           fun
             (F) ->
               begin
                 V1 = F(erlang:element(3, V)),
                 { tuple
                 , (DictSemigroup@1(erlang:element(2, V)))
                   (erlang:element(2, V1))
                 , erlang:element(3, V1)
                 }
               end
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           ApplyTuple1
       end
     }
  end.

applicativeTuple() ->
  fun
    (DictMonoid) ->
      applicativeTuple(DictMonoid)
  end.

applicativeTuple(#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  begin
    ApplyTuple1 = applyTuple(DictMonoid(undefined)),
    #{ pure => ('Tuple'())(DictMonoid@1)
     , 'Apply0' =>
       fun
         (_) ->
           ApplyTuple1
       end
     }
  end.

monadTuple() ->
  fun
    (DictMonoid) ->
      monadTuple(DictMonoid)
  end.

monadTuple(DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
  begin
    ApplicativeTuple1 = applicativeTuple(DictMonoid),
    BindTuple1 = bindTuple(DictMonoid@1(undefined)),
    #{ 'Applicative0' =>
       fun
         (_) ->
           ApplicativeTuple1
       end
     , 'Bind1' =>
       fun
         (_) ->
           BindTuple1
       end
     }
  end.

