-module(control_monad_gen@ps).
-export([ 'monoidAdditive.semigroupAdditive1'/0
        , monoidAdditive/0
        , 'Cons'/0
        , 'Nil'/0
        , unfoldable/0
        , unfoldable/2
        , semigroupFreqSemigroup/0
        , fromIndex/0
        , fromIndex/1
        , oneOf/0
        , oneOf/2
        , freqSemigroup/0
        , freqSemigroup/1
        , frequency/0
        , frequency/2
        , filtered/0
        , filtered/2
        , suchThat/0
        , suchThat/2
        , elements/0
        , elements/1
        , choose/0
        , choose/1
        ]).
-compile(no_auto_import).
'monoidAdditive.semigroupAdditive1'() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             V + V1
         end
     end
   }.

monoidAdditive() ->
  #{ mempty => 0.0
   , 'Semigroup0' =>
     fun
       (_) ->
         'monoidAdditive.semigroupAdditive1'()
     end
   }.

'Cons'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {cons, Value0, Value1}
      end
  end.

'Nil'() ->
  {nil}.

unfoldable() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          unfoldable(DictMonadRec, DictMonadGen)
      end
  end.

unfoldable( #{ tailRecM := DictMonadRec }
          , #{ 'Monad0' := DictMonadGen, sized := DictMonadGen@1 }
          ) ->
  begin
    #{ 'Applicative0' := Monad0, 'Bind1' := Monad0@1 } = DictMonadGen(undefined),
    #{ pure := V } = Monad0(undefined),
    Bind1 = #{ 'Apply0' := Bind1@1 } = Monad0@1(undefined),
    fun
      (#{ unfoldr := DictUnfoldable }) ->
        fun
          (Gen) ->
            ((erlang:map_get(
                map,
                (erlang:map_get('Functor0', Bind1@1(undefined)))(undefined)
              ))
             (DictUnfoldable(fun
                (V@1) ->
                  case V@1 of
                    {nil} ->
                      {nothing};
                    {cons, V@2, V@3} ->
                      {just, {tuple, V@2, V@3}};
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
              end)))
            (DictMonadGen@1(begin
               V@1 =
                 DictMonadRec(fun
                   (V@1) ->
                     if
                       (erlang:element(3, V@1)) =< 0 ->
                         V({done, erlang:element(2, V@1)});
                       true ->
                         begin
                           #{ bind := Bind1@2 } = Bind1,
                           V@2 = erlang:element(2, V@1),
                           V@3 = erlang:element(3, V@1),
                           (Bind1@2(Gen))
                           (fun
                             (X) ->
                               V({loop, {tuple, {cons, X, V@2}, V@3 - 1}})
                           end)
                         end
                     end
                 end),
               V@2 = (data_tuple@ps:'Tuple'())({nil}),
               fun
                 (X) ->
                   V@1(V@2(X))
               end
             end))
        end
    end
  end.

semigroupFreqSemigroup() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (Pos) ->
                 begin
                   V2 = V(Pos),
                   case erlang:element(2, V2) of
                     {just, _} ->
                       V1(erlang:element(2, erlang:element(2, V2)));
                     _ ->
                       V2
                   end
                 end
             end
         end
     end
   }.

fromIndex() ->
  fun
    (DictFoldable1) ->
      fromIndex(DictFoldable1)
  end.

fromIndex(#{ 'Foldable0' := DictFoldable1, foldMap1 := DictFoldable1@1 }) ->
  begin
    FoldMap1 = DictFoldable1@1(data_semigroup_last@ps:semigroupLast()),
    fun
      (I) ->
        fun
          (Xs) ->
            begin
              Go =
                fun
                  Go (V, V1) ->
                    case V1 of
                      {cons, _, _} ->
                        case erlang:element(3, V1) of
                          {nil} ->
                            erlang:element(2, V1);
                          _ ->
                            if
                              V =< 0 ->
                                erlang:element(2, V1);
                              true ->
                                begin
                                  V@1 = V - 1,
                                  V1@1 = erlang:element(3, V1),
                                  Go(V@1, V1@1)
                                end
                            end
                        end;
                      {nil} ->
                        (FoldMap1(data_semigroup_last@ps:'Last'()))(Xs);
                      _ ->
                        erlang:error({fail, <<"Failed pattern match">>})
                    end
                end,
              V1 =
                (((erlang:map_get(foldr, DictFoldable1(undefined)))('Cons'()))
                 ({nil}))
                (Xs),
              Go(I, V1)
            end
        end
    end
  end.

oneOf() ->
  fun
    (DictMonadGen) ->
      fun
        (DictFoldable1) ->
          oneOf(DictMonadGen, DictFoldable1)
      end
  end.

oneOf( #{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }
     , DictFoldable1 = #{ 'Foldable0' := DictFoldable1@1 }
     ) ->
  begin
    Length =
      ((erlang:map_get(foldl, DictFoldable1@1(undefined)))
       (fun
         (C) ->
           fun
             (_) ->
               1 + C
           end
       end))
      (0),
    FromIndex1 = fromIndex(DictFoldable1),
    fun
      (Xs) ->
        ((erlang:map_get(
            bind,
            (erlang:map_get('Bind1', DictMonadGen(undefined)))(undefined)
          ))
         ((DictMonadGen@1(0))((Length(Xs)) - 1)))
        (fun
          (N) ->
            (FromIndex1(N))(Xs)
        end)
    end
  end.

freqSemigroup() ->
  fun
    (V) ->
      freqSemigroup(V)
  end.

freqSemigroup(V) ->
  begin
    V@1 = erlang:element(2, V),
    V@2 = erlang:element(3, V),
    fun
      (Pos) ->
        if
          Pos >= V@1 ->
            {tuple, {just, Pos - V@1}, V@2};
          true ->
            {tuple, {nothing}, V@2}
        end
    end
  end.

frequency() ->
  fun
    (DictMonadGen) ->
      fun
        (DictFoldable1) ->
          frequency(DictMonadGen, DictFoldable1)
      end
  end.

frequency( #{ 'Monad0' := DictMonadGen, chooseFloat := DictMonadGen@1 }
         , #{ 'Foldable0' := DictFoldable1, foldMap1 := DictFoldable1@1 }
         ) ->
  begin
    FoldMap =
      (erlang:map_get(foldMap, DictFoldable1(undefined)))(monoidAdditive()),
    FoldMap1 = DictFoldable1@1(semigroupFreqSemigroup()),
    fun
      (Xs) ->
        ((erlang:map_get(
            bind,
            (erlang:map_get('Bind1', DictMonadGen(undefined)))(undefined)
          ))
         ((DictMonadGen@1(0.0))((FoldMap(data_tuple@ps:fst()))(Xs))))
        (begin
          V = (FoldMap1(freqSemigroup()))(Xs),
          fun
            (X) ->
              erlang:element(3, V(X))
          end
        end)
    end
  end.

filtered() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          filtered(DictMonadRec, DictMonadGen)
      end
  end.

filtered(#{ tailRecM := DictMonadRec }, #{ 'Monad0' := DictMonadGen }) ->
  begin
    #{ map := V } =
      (erlang:map_get(
         'Functor0',
         (erlang:map_get(
            'Apply0',
            (erlang:map_get('Bind1', DictMonadGen(undefined)))(undefined)
          ))
         (undefined)
       ))
      (undefined),
    fun
      (Gen) ->
        (DictMonadRec(fun
           (_) ->
             (V(fun
                (A) ->
                  case A of
                    {nothing} ->
                      {loop, unit};
                    {just, A@1} ->
                      {done, A@1};
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
              end))
             (Gen)
         end))
        (unit)
    end
  end.

suchThat() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          suchThat(DictMonadRec, DictMonadGen)
      end
  end.

suchThat(DictMonadRec, DictMonadGen = #{ 'Monad0' := DictMonadGen@1 }) ->
  begin
    Filtered2 = filtered(DictMonadRec, DictMonadGen),
    #{ map := V } =
      (erlang:map_get(
         'Functor0',
         (erlang:map_get(
            'Apply0',
            (erlang:map_get('Bind1', DictMonadGen@1(undefined)))(undefined)
          ))
         (undefined)
       ))
      (undefined),
    fun
      (Gen) ->
        fun
          (Pred) ->
            Filtered2((V(fun
                         (A) ->
                           case Pred(A) of
                             true ->
                               {just, A};
                             _ ->
                               {nothing}
                           end
                       end))
                      (Gen))
        end
    end
  end.

elements() ->
  fun
    (DictMonadGen) ->
      elements(DictMonadGen)
  end.

elements(#{ 'Monad0' := DictMonadGen, chooseInt := DictMonadGen@1 }) ->
  begin
    #{ 'Applicative0' := Monad0, 'Bind1' := Monad0@1 } = DictMonadGen(undefined),
    fun
      (DictFoldable1 = #{ 'Foldable0' := DictFoldable1@1 }) ->
        begin
          Length =
            ((erlang:map_get(foldl, DictFoldable1@1(undefined)))
             (fun
               (C) ->
                 fun
                   (_) ->
                     1 + C
                 end
             end))
            (0),
          FromIndex1 = fromIndex(DictFoldable1),
          fun
            (Xs) ->
              ((erlang:map_get(bind, Monad0@1(undefined)))
               ((DictMonadGen@1(0))((Length(Xs)) - 1)))
              (fun
                (N) ->
                  (erlang:map_get(pure, Monad0(undefined)))((FromIndex1(N))(Xs))
              end)
          end
        end
    end
  end.

choose() ->
  fun
    (DictMonadGen) ->
      choose(DictMonadGen)
  end.

choose(#{ 'Monad0' := DictMonadGen, chooseBool := DictMonadGen@1 }) ->
  fun
    (GenA) ->
      fun
        (GenB) ->
          ((erlang:map_get(
              bind,
              (erlang:map_get('Bind1', DictMonadGen(undefined)))(undefined)
            ))
           (DictMonadGen@1))
          (fun
            (V) ->
              if
                V ->
                  GenA;
                true ->
                  GenB
              end
          end)
      end
  end.

