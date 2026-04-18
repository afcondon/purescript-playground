-module(control_monad_list_trans@ps).
-export([ identity/0
        , identity/1
        , 'Yield'/0
        , 'Skip'/0
        , 'Done'/0
        , 'ListT'/0
        , 'ListT'/1
        , wrapLazy/0
        , wrapLazy/2
        , wrapEffect/0
        , wrapEffect/2
        , unfold/0
        , unfold/3
        , uncons/0
        , uncons/1
        , tail/0
        , tail/1
        , takeWhile/0
        , takeWhile/1
        , scanl/0
        , scanl/4
        , 'prepend\''/0
        , 'prepend\''/3
        , prepend/0
        , prepend/3
        , nil/0
        , nil/1
        , singleton/0
        , singleton/1
        , take/0
        , take/1
        , 'zipWith\''/0
        , 'zipWith\''/1
        , zipWith/0
        , zipWith/1
        , newtypeListT/0
        , mapMaybe/0
        , mapMaybe/3
        , iterate/0
        , iterate/3
        , repeat/0
        , repeat/1
        , head/0
        , head/1
        , functorListT/0
        , functorListT/1
        , fromEffect/0
        , fromEffect/1
        , monadTransListT/0
        , 'foldlRec\''/0
        , 'foldlRec\''/1
        , runListTRec/0
        , runListTRec/1
        , foldlRec/0
        , foldlRec/1
        , 'foldl\''/0
        , 'foldl\''/1
        , runListT/0
        , runListT/1
        , foldl/0
        , foldl/1
        , filter/0
        , filter/3
        , dropWhile/0
        , dropWhile/1
        , drop/0
        , drop/1
        , cons/0
        , cons/3
        , unfoldable1ListT/0
        , unfoldable1ListT/1
        , unfoldableListT/0
        , unfoldableListT/1
        , semigroupListT/0
        , semigroupListT/1
        , concat/0
        , concat/1
        , monoidListT/0
        , monoidListT/1
        , catMaybes/0
        , catMaybes/1
        , monadListT/0
        , monadListT/1
        , bindListT/0
        , bindListT/1
        , applyListT/0
        , applyListT/1
        , applicativeListT/0
        , applicativeListT/1
        , monadEffectListT/0
        , monadEffectListT/1
        , altListT/0
        , altListT/1
        , plusListT/0
        , plusListT/1
        , alternativeListT/0
        , alternativeListT/1
        , monadPlusListT/0
        , monadPlusListT/1
        , monadZeroListT/0
        , monadZeroListT/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

'Yield'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {yield, Value0, Value1}
      end
  end.

'Skip'() ->
  fun
    (Value0) ->
      {skip, Value0}
  end.

'Done'() ->
  {done}.

'ListT'() ->
  fun
    (X) ->
      'ListT'(X)
  end.

'ListT'(X) ->
  X.

wrapLazy() ->
  fun
    (DictApplicative) ->
      fun
        (V) ->
          wrapLazy(DictApplicative, V)
      end
  end.

wrapLazy(#{ pure := DictApplicative }, V) ->
  DictApplicative({skip, V}).

wrapEffect() ->
  fun
    (DictFunctor) ->
      fun
        (V) ->
          wrapEffect(DictFunctor, V)
      end
  end.

wrapEffect(#{ map := DictFunctor }, V) ->
  (DictFunctor(fun
     (X) ->
       { skip
       , data_lazy@foreign:defer(fun
           (_) ->
             X
         end)
       }
   end))
  (V).

unfold() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (Z) ->
              unfold(DictMonad, F, Z)
          end
      end
  end.

unfold(DictMonad = #{ 'Bind1' := DictMonad@1 }, F, Z) ->
  ((erlang:map_get(
      map,
      (erlang:map_get(
         'Functor0',
         (erlang:map_get('Apply0', DictMonad@1(undefined)))(undefined)
       ))
      (undefined)
    ))
   (fun
     (V) ->
       case V of
         {just, V@1} ->
           begin
             V@2 = erlang:element(2, V@1),
             { yield
             , erlang:element(3, V@1)
             , data_lazy@foreign:defer(fun
                 (_) ->
                   unfold(DictMonad, F, V@2)
               end)
             }
           end;
         {nothing} ->
           {done};
         _ ->
           erlang:error({fail, <<"Failed pattern match">>})
       end
   end))
  (F(Z)).

uncons() ->
  fun
    (DictMonad) ->
      uncons(DictMonad)
  end.

uncons(DictMonad = #{ 'Applicative0' := DictMonad@1, 'Bind1' := DictMonad@2 }) ->
  begin
    V = DictMonad@1(undefined),
    fun
      (V@1) ->
        ((erlang:map_get(bind, DictMonad@2(undefined)))(V@1))
        (fun
          (V1) ->
            case V1 of
              {yield, V1@1, V1@2} ->
                begin
                  #{ pure := V@2 } = V,
                  V@2({just, {tuple, V1@1, data_lazy@foreign:force(V1@2)}})
                end;
              {skip, V1@3} ->
                (uncons(DictMonad))(data_lazy@foreign:force(V1@3));
              {done} ->
                begin
                  #{ pure := V@3 } = V,
                  V@3({nothing})
                end;
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
        end)
    end
  end.

tail() ->
  fun
    (DictMonad) ->
      tail(DictMonad)
  end.

tail(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    Uncons1 = uncons(DictMonad),
    fun
      (L) ->
        ((erlang:map_get(
            map,
            (erlang:map_get(
               'Functor0',
               (erlang:map_get('Apply0', DictMonad@1(undefined)))(undefined)
             ))
            (undefined)
          ))
         (fun
           (V1) ->
             case V1 of
               {just, V1@1} ->
                 {just, erlang:element(3, V1@1)};
               _ ->
                 {nothing}
             end
         end))
        (Uncons1(L))
    end
  end.

takeWhile() ->
  fun
    (DictApplicative) ->
      takeWhile(DictApplicative)
  end.

takeWhile(DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
  begin
    #{ map := V } =
      (erlang:map_get('Functor0', DictApplicative@1(undefined)))(undefined),
    fun
      (F) ->
        fun
          (V@1) ->
            (V(fun
               (V@2) ->
                 case V@2 of
                   {yield, V@3, _} ->
                     case F(V@3) of
                       true ->
                         begin
                           {yield, V@4, V@5} = V@2,
                           { yield
                           , V@4
                           , begin
                               V@6 = (takeWhile(DictApplicative))(F),
                               data_lazy@foreign:defer(fun
                                 (_) ->
                                   V@6(data_lazy@foreign:force(V@5))
                               end)
                             end
                           }
                         end;
                       _ ->
                         {done}
                     end;
                   {skip, V@7} ->
                     { skip
                     , begin
                         V@8 = (takeWhile(DictApplicative))(F),
                         data_lazy@foreign:defer(fun
                           (_) ->
                             V@8(data_lazy@foreign:force(V@7))
                         end)
                       end
                     };
                   {done} ->
                     {done};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end))
            (V@1)
        end
    end
  end.

scanl() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (B) ->
              fun
                (L) ->
                  scanl(DictMonad, F, B, L)
              end
          end
      end
  end.

scanl(DictMonad = #{ 'Bind1' := DictMonad@1 }, F, B, L) ->
  unfold(
    DictMonad,
    fun
      (V) ->
        begin
          V@1 = erlang:element(2, V),
          ((erlang:map_get(
              map,
              (erlang:map_get(
                 'Functor0',
                 (erlang:map_get('Apply0', DictMonad@1(undefined)))(undefined)
               ))
              (undefined)
            ))
           (fun
             (V1) ->
               case V1 of
                 {yield, V1@1, V1@2} ->
                   { just
                   , { tuple
                     , {tuple, (F(V@1))(V1@1), data_lazy@foreign:force(V1@2)}
                     , V@1
                     }
                   };
                 {skip, V1@3} ->
                   { just
                   , {tuple, {tuple, V@1, data_lazy@foreign:force(V1@3)}, V@1}
                   };
                 {done} ->
                   {nothing};
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
           end))
          (erlang:element(3, V))
        end
    end,
    {tuple, B, L}
  ).

'prepend\''() ->
  fun
    (DictApplicative) ->
      fun
        (H) ->
          fun
            (T) ->
              'prepend\''(DictApplicative, H, T)
          end
      end
  end.

'prepend\''(#{ pure := DictApplicative }, H, T) ->
  DictApplicative({yield, H, T}).

prepend() ->
  fun
    (DictApplicative) ->
      fun
        (H) ->
          fun
            (T) ->
              prepend(DictApplicative, H, T)
          end
      end
  end.

prepend(#{ pure := DictApplicative }, H, T) ->
  DictApplicative({ yield
                  , H
                  , data_lazy@foreign:defer(fun
                      (_) ->
                        T
                    end)
                  }).

nil() ->
  fun
    (DictApplicative) ->
      nil(DictApplicative)
  end.

nil(#{ pure := DictApplicative }) ->
  DictApplicative({done}).

singleton() ->
  fun
    (DictApplicative) ->
      singleton(DictApplicative)
  end.

singleton(#{ pure := DictApplicative }) ->
  begin
    Nil1 = DictApplicative({done}),
    fun
      (A) ->
        DictApplicative({ yield
                        , A
                        , data_lazy@foreign:defer(fun
                            (_) ->
                              Nil1
                          end)
                        })
    end
  end.

take() ->
  fun
    (DictApplicative) ->
      take(DictApplicative)
  end.

take(DictApplicative = #{ 'Apply0' := DictApplicative@1
                        , pure := DictApplicative@2
                        }) ->
  begin
    Nil1 = DictApplicative@2({done}),
    V = (erlang:map_get('Functor0', DictApplicative@1(undefined)))(undefined),
    fun
      (V@1) ->
        fun
          (V1) ->
            if
              V@1 =:= 0 ->
                Nil1;
              true ->
                begin
                  #{ map := V@2 } = V,
                  (V@2(fun
                     (V2) ->
                       case V2 of
                         {yield, V2@1, V2@2} ->
                           { yield
                           , V2@1
                           , begin
                               V@3 = (take(DictApplicative))(V@1 - 1),
                               data_lazy@foreign:defer(fun
                                 (_) ->
                                   V@3(data_lazy@foreign:force(V2@2))
                               end)
                             end
                           };
                         {skip, V2@3} ->
                           { skip
                           , begin
                               V@4 = (take(DictApplicative))(V@1),
                               data_lazy@foreign:defer(fun
                                 (_) ->
                                   V@4(data_lazy@foreign:force(V2@3))
                               end)
                             end
                           };
                         {done} ->
                           {done};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end))
                  (V1)
                end
            end
        end
    end
  end.

'zipWith\''() ->
  fun
    (DictMonad) ->
      'zipWith\''(DictMonad)
  end.

'zipWith\''(DictMonad = #{ 'Applicative0' := DictMonad@1
                         , 'Bind1' := DictMonad@2
                         }) ->
  begin
    #{ pure := Applicative0 } = DictMonad@1(undefined),
    Nil1 = Applicative0({done}),
    #{ 'Apply0' := Bind1, bind := Bind1@1 } = DictMonad@2(undefined),
    Functor0 = #{ map := Functor0@1 } =
      (erlang:map_get('Functor0', Bind1(undefined)))(undefined),
    Uncons1 = uncons(DictMonad),
    fun
      (F) ->
        fun
          (Fa) ->
            fun
              (Fb) ->
                (Functor0@1(fun
                   (X) ->
                     { skip
                     , data_lazy@foreign:defer(fun
                         (_) ->
                           X
                       end)
                     }
                 end))
                ((Bind1@1(Uncons1(Fa)))
                 (fun
                   (Ua) ->
                     (Bind1@1(Uncons1(Fb)))
                     (fun
                       (Ub) ->
                         case Ub of
                           {nothing} ->
                             Applicative0(Nil1);
                           _ ->
                             case Ua of
                               {nothing} ->
                                 Applicative0(Nil1);
                               _ ->
                                 if
                                   ?IS_KNOWN_TAG(just, 1, Ua)
                                     andalso ?IS_KNOWN_TAG(just, 1, Ub) ->
                                     begin
                                       {just, Ub@1} = Ub,
                                       {just, Ua@1} = Ua,
                                       #{ map := Functor0@2 } = Functor0,
                                       V = erlang:element(3, Ua@1),
                                       V@1 = erlang:element(3, Ub@1),
                                       (Functor0@2(begin
                                          V@2 =
                                            data_lazy@foreign:defer(fun
                                              (_) ->
                                                ((('zipWith\''(DictMonad))(F))
                                                 (V))
                                                (V@1)
                                            end),
                                          fun
                                            (A) ->
                                              Applicative0({yield, A, V@2})
                                          end
                                        end))
                                       ((F(erlang:element(2, Ua@1)))
                                        (erlang:element(2, Ub@1)))
                                     end;
                                   true ->
                                     erlang:error({ fail
                                                  , <<"Failed pattern match">>
                                                  })
                                 end
                             end
                         end
                     end)
                 end))
            end
        end
    end
  end.

zipWith() ->
  fun
    (DictMonad) ->
      zipWith(DictMonad)
  end.

zipWith(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    ZipWith_ = 'zipWith\''(DictMonad),
    fun
      (F) ->
        ZipWith_(fun
          (A) ->
            fun
              (B) ->
                (erlang:map_get(pure, DictMonad@1(undefined)))((F(A))(B))
            end
        end)
    end
  end.

newtypeListT() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

mapMaybe() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (V) ->
              mapMaybe(DictFunctor, F, V)
          end
      end
  end.

mapMaybe(DictFunctor = #{ map := DictFunctor@1 }, F, V) ->
  (DictFunctor@1(fun
     (V@1) ->
       case V@1 of
         {yield, V@2, V@3} ->
           begin
             V@4 = F(V@2),
             case V@4 of
               {just, V@5} ->
                 { yield
                 , V@5
                 , begin
                     V@6 = ((mapMaybe())(DictFunctor))(F),
                     data_lazy@foreign:defer(fun
                       (_) ->
                         V@6(data_lazy@foreign:force(V@3))
                     end)
                   end
                 };
               _ ->
                 { skip
                 , begin
                     V@7 = ((mapMaybe())(DictFunctor))(F),
                     data_lazy@foreign:defer(fun
                       (_) ->
                         V@7(data_lazy@foreign:force(V@3))
                     end)
                   end
                 }
             end
           end;
         {skip, V@8} ->
           { skip
           , begin
               V@9 = ((mapMaybe())(DictFunctor))(F),
               data_lazy@foreign:defer(fun
                 (_) ->
                   V@9(data_lazy@foreign:force(V@8))
               end)
             end
           };
         {done} ->
           {done};
         _ ->
           erlang:error({fail, <<"Failed pattern match">>})
       end
   end))
  (V).

iterate() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (A) ->
              iterate(DictMonad, F, A)
          end
      end
  end.

iterate(DictMonad = #{ 'Applicative0' := DictMonad@1 }, F, A) ->
  unfold(
    DictMonad,
    fun
      (X) ->
        (erlang:map_get(pure, DictMonad@1(undefined)))({just, {tuple, F(X), X}})
    end,
    A
  ).

repeat() ->
  fun
    (DictMonad) ->
      repeat(DictMonad)
  end.

repeat(DictMonad) ->
  ((iterate())(DictMonad))(identity()).

head() ->
  fun
    (DictMonad) ->
      head(DictMonad)
  end.

head(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    Uncons1 = uncons(DictMonad),
    fun
      (L) ->
        ((erlang:map_get(
            map,
            (erlang:map_get(
               'Functor0',
               (erlang:map_get('Apply0', DictMonad@1(undefined)))(undefined)
             ))
            (undefined)
          ))
         (fun
           (V1) ->
             case V1 of
               {just, V1@1} ->
                 {just, erlang:element(2, V1@1)};
               _ ->
                 {nothing}
             end
         end))
        (Uncons1(L))
    end
  end.

functorListT() ->
  fun
    (DictFunctor) ->
      functorListT(DictFunctor)
  end.

functorListT(DictFunctor = #{ map := DictFunctor@1 }) ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             (DictFunctor@1(fun
                (V@1) ->
                  case V@1 of
                    {yield, V@2, V@3} ->
                      { yield
                      , F(V@2)
                      , begin
                          V@4 =
                            (erlang:map_get(map, functorListT(DictFunctor)))(F),
                          data_lazy@foreign:defer(fun
                            (_) ->
                              V@4(data_lazy@foreign:force(V@3))
                          end)
                        end
                      };
                    {skip, V@5} ->
                      { skip
                      , begin
                          V@6 =
                            (erlang:map_get(map, functorListT(DictFunctor)))(F),
                          data_lazy@foreign:defer(fun
                            (_) ->
                              V@6(data_lazy@foreign:force(V@5))
                          end)
                        end
                      };
                    {done} ->
                      {done};
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
              end))
             (V)
         end
     end
   }.

fromEffect() ->
  fun
    (DictApplicative) ->
      fromEffect(DictApplicative)
  end.

fromEffect(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
  begin
    Nil1 = DictApplicative@1({done}),
    fun
      (Fa) ->
        ((erlang:map_get(
            map,
            (erlang:map_get('Functor0', DictApplicative(undefined)))(undefined)
          ))
         (begin
           V =
             data_lazy@foreign:defer(fun
               (_) ->
                 Nil1
             end),
           fun
             (A) ->
               {yield, A, V}
           end
         end))
        (Fa)
    end
  end.

monadTransListT() ->
  #{ lift =>
     fun
       (#{ 'Applicative0' := DictMonad }) ->
         fromEffect(DictMonad(undefined))
     end
   }.

'foldlRec\''() ->
  fun
    (DictMonadRec) ->
      'foldlRec\''(DictMonadRec)
  end.

'foldlRec\''(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadRec(undefined),
    #{ pure := V } = Monad0@1(undefined),
    V@1 = #{ bind := V@2 } = Monad0@2(undefined),
    Uncons1 = uncons(Monad0),
    fun
      (F) ->
        fun
          (A) ->
            fun
              (B) ->
                (DictMonadRec@1(fun
                   (#{ a := O, b := O@1 }) ->
                     (V@2(Uncons1(O@1)))
                     (fun
                       (V@3) ->
                         case V@3 of
                           {nothing} ->
                             V({done, O});
                           {just, V@4} ->
                             begin
                               #{ bind := V@5 } = V@1,
                               V@6 = erlang:element(3, V@4),
                               (V@5((F(O))(erlang:element(2, V@4))))
                               (fun
                                 (B_) ->
                                   V({loop, #{ a => B_, b => V@6 }})
                               end)
                             end;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end)
                 end))
                (#{ a => A, b => B })
            end
        end
    end
  end.

runListTRec() ->
  fun
    (DictMonadRec) ->
      runListTRec(DictMonadRec)
  end.

runListTRec(DictMonadRec = #{ 'Monad0' := DictMonadRec@1 }) ->
  (('foldlRec\''(DictMonadRec))
   (fun
     (_) ->
       fun
         (_) ->
           (erlang:map_get(
              pure,
              (erlang:map_get('Applicative0', DictMonadRec@1(undefined)))
              (undefined)
            ))
           (unit)
       end
   end))
  (unit).

foldlRec() ->
  fun
    (DictMonadRec) ->
      foldlRec(DictMonadRec)
  end.

foldlRec(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1, 'Bind1' := Monad0@2 } =
      DictMonadRec(undefined),
    #{ pure := V } = Monad0@1(undefined),
    Uncons1 = uncons(Monad0),
    fun
      (F) ->
        fun
          (A) ->
            fun
              (B) ->
                (DictMonadRec@1(fun
                   (#{ a := O, b := O@1 }) ->
                     ((erlang:map_get(bind, Monad0@2(undefined)))(Uncons1(O@1)))
                     (fun
                       (V@1) ->
                         case V@1 of
                           {nothing} ->
                             V({done, O});
                           {just, V@2} ->
                             V({ loop
                               , #{ a => (F(O))(erlang:element(2, V@2))
                                  , b => erlang:element(3, V@2)
                                  }
                               });
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end)
                 end))
                (#{ a => A, b => B })
            end
        end
    end
  end.

'foldl\''() ->
  fun
    (DictMonad) ->
      'foldl\''(DictMonad)
  end.

'foldl\''(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    V = #{ bind := V@1 } = DictMonad@1(undefined),
    Uncons1 = uncons(DictMonad),
    fun
      (F) ->
        begin
          Loop =
            fun
              Loop (B, L) ->
                (V@1(Uncons1(L)))
                (fun
                  (V@2) ->
                    case V@2 of
                      {nothing} ->
                        begin
                          #{ 'Applicative0' := DictMonad@2 } = DictMonad,
                          (erlang:map_get(pure, DictMonad@2(undefined)))(B)
                        end;
                      {just, V@3} ->
                        begin
                          #{ bind := V@4 } = V,
                          V@5 = erlang:element(3, V@3),
                          (V@4((F(B))(erlang:element(2, V@3))))
                          (fun
                            (A) ->
                              Loop(A, V@5)
                          end)
                        end;
                      _ ->
                        erlang:error({fail, <<"Failed pattern match">>})
                    end
                end)
            end,
          fun
            (B) ->
              fun
                (L) ->
                  Loop(B, L)
              end
          end
        end
    end
  end.

runListT() ->
  fun
    (DictMonad) ->
      runListT(DictMonad)
  end.

runListT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  (('foldl\''(DictMonad))
   (fun
     (_) ->
       fun
         (_) ->
           (erlang:map_get(pure, DictMonad@1(undefined)))(unit)
       end
   end))
  (unit).

foldl() ->
  fun
    (DictMonad) ->
      foldl(DictMonad)
  end.

foldl(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    Uncons1 = uncons(DictMonad),
    fun
      (F) ->
        begin
          Loop =
            fun
              Loop (B, L) ->
                ((erlang:map_get(bind, DictMonad@1(undefined)))(Uncons1(L)))
                (fun
                  (V) ->
                    case V of
                      {nothing} ->
                        begin
                          #{ 'Applicative0' := DictMonad@2 } = DictMonad,
                          (erlang:map_get(pure, DictMonad@2(undefined)))(B)
                        end;
                      {just, V@1} ->
                        begin
                          B@1 = (F(B))(erlang:element(2, V@1)),
                          L@1 = erlang:element(3, V@1),
                          Loop(B@1, L@1)
                        end;
                      _ ->
                        erlang:error({fail, <<"Failed pattern match">>})
                    end
                end)
            end,
          fun
            (B) ->
              fun
                (L) ->
                  Loop(B, L)
              end
          end
        end
    end
  end.

filter() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (V) ->
              filter(DictFunctor, F, V)
          end
      end
  end.

filter(DictFunctor = #{ map := DictFunctor@1 }, F, V) ->
  (DictFunctor@1(fun
     (V@1) ->
       case V@1 of
         {yield, V@2, V@3} ->
           begin
             V@4 = ((filter())(DictFunctor))(F),
             S_ =
               data_lazy@foreign:defer(fun
                 (_) ->
                   V@4(data_lazy@foreign:force(V@3))
               end),
             case F(V@2) of
               true ->
                 begin
                   {yield, V@5, _} = V@1,
                   {yield, V@5, S_}
                 end;
               _ ->
                 {skip, S_}
             end
           end;
         {skip, V@6} ->
           { skip
           , begin
               V@7 = ((filter())(DictFunctor))(F),
               data_lazy@foreign:defer(fun
                 (_) ->
                   V@7(data_lazy@foreign:force(V@6))
               end)
             end
           };
         {done} ->
           {done};
         _ ->
           erlang:error({fail, <<"Failed pattern match">>})
       end
   end))
  (V).

dropWhile() ->
  fun
    (DictApplicative) ->
      dropWhile(DictApplicative)
  end.

dropWhile(DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
  begin
    #{ map := V } =
      (erlang:map_get('Functor0', DictApplicative@1(undefined)))(undefined),
    fun
      (F) ->
        fun
          (V@1) ->
            (V(fun
               (V@2) ->
                 case V@2 of
                   {yield, V@3, V@4} ->
                     case F(V@3) of
                       true ->
                         { skip
                         , begin
                             V@5 = (dropWhile(DictApplicative))(F),
                             data_lazy@foreign:defer(fun
                               (_) ->
                                 V@5(data_lazy@foreign:force(V@4))
                             end)
                           end
                         };
                       _ ->
                         {yield, V@3, V@4}
                     end;
                   {skip, V@6} ->
                     { skip
                     , begin
                         V@7 = (dropWhile(DictApplicative))(F),
                         data_lazy@foreign:defer(fun
                           (_) ->
                             V@7(data_lazy@foreign:force(V@6))
                         end)
                       end
                     };
                   {done} ->
                     {done};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end))
            (V@1)
        end
    end
  end.

drop() ->
  fun
    (DictApplicative) ->
      drop(DictApplicative)
  end.

drop(DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
  begin
    V = (erlang:map_get('Functor0', DictApplicative@1(undefined)))(undefined),
    fun
      (V@1) ->
        fun
          (V1) ->
            if
              V@1 =:= 0 ->
                V1;
              true ->
                begin
                  #{ map := V@2 } = V,
                  (V@2(fun
                     (V2) ->
                       case V2 of
                         {yield, _, V2@1} ->
                           { skip
                           , begin
                               V@3 = (drop(DictApplicative))(V@1 - 1),
                               data_lazy@foreign:defer(fun
                                 (_) ->
                                   V@3(data_lazy@foreign:force(V2@1))
                               end)
                             end
                           };
                         {skip, V2@2} ->
                           { skip
                           , begin
                               V@4 = (drop(DictApplicative))(V@1),
                               data_lazy@foreign:defer(fun
                                 (_) ->
                                   V@4(data_lazy@foreign:force(V2@2))
                               end)
                             end
                           };
                         {done} ->
                           {done};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end))
                  (V1)
                end
            end
        end
    end
  end.

cons() ->
  fun
    (DictApplicative) ->
      fun
        (Lh) ->
          fun
            (T) ->
              cons(DictApplicative, Lh, T)
          end
      end
  end.

cons(#{ pure := DictApplicative }, Lh, T) ->
  DictApplicative({yield, data_lazy@foreign:force(Lh), T}).

unfoldable1ListT() ->
  fun
    (DictMonad) ->
      unfoldable1ListT(DictMonad)
  end.

unfoldable1ListT(#{ 'Applicative0' := DictMonad }) ->
  begin
    Applicative0 = DictMonad(undefined),
    Singleton1 = singleton(Applicative0),
    #{ unfoldr1 =>
       fun
         (F) ->
           fun
             (B) ->
               begin
                 Go =
                   fun
                     Go (V) ->
                       case erlang:element(3, V) of
                         {nothing} ->
                           Singleton1(erlang:element(2, V));
                         {just, _} ->
                           begin
                             #{ pure := Applicative0@1 } = Applicative0,
                             V@1 = erlang:element(2, V),
                             V@2 = erlang:element(2, erlang:element(3, V)),
                             Applicative0@1({ yield
                                            , data_lazy@foreign:force(data_lazy@foreign:defer(fun
                                                                        (_) ->
                                                                          V@1
                                                                      end))
                                            , data_lazy@foreign:defer(fun
                                                (_) ->
                                                  Go(F(V@2))
                                              end)
                                            })
                           end;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end,
                 Go(F(B))
               end
           end
       end
     }
  end.

unfoldableListT() ->
  fun
    (DictMonad) ->
      unfoldableListT(DictMonad)
  end.

unfoldableListT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    Applicative0 = #{ pure := Applicative0@1 } = DictMonad@1(undefined),
    Nil1 = Applicative0@1({done}),
    Unfoldable1ListT1 = unfoldable1ListT(DictMonad),
    #{ unfoldr =>
       fun
         (F) ->
           fun
             (B) ->
               begin
                 Go =
                   fun
                     Go (V) ->
                       case V of
                         {nothing} ->
                           Nil1;
                         {just, V@1} ->
                           begin
                             #{ pure := Applicative0@2 } = Applicative0,
                             V@2 = erlang:element(2, V@1),
                             V@3 = erlang:element(3, V@1),
                             Applicative0@2({ yield
                                            , data_lazy@foreign:force(data_lazy@foreign:defer(fun
                                                                        (_) ->
                                                                          V@2
                                                                      end))
                                            , data_lazy@foreign:defer(fun
                                                (_) ->
                                                  Go(F(V@3))
                                              end)
                                            })
                           end;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end,
                 Go(F(B))
               end
           end
       end
     , 'Unfoldable10' =>
       fun
         (_) ->
           Unfoldable1ListT1
       end
     }
  end.

semigroupListT() ->
  fun
    (DictApplicative) ->
      semigroupListT(DictApplicative)
  end.

semigroupListT(DictApplicative) ->
  #{ append => concat(DictApplicative) }.

concat() ->
  fun
    (DictApplicative) ->
      concat(DictApplicative)
  end.

concat(DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
  begin
    #{ map := V } =
      (erlang:map_get('Functor0', DictApplicative@1(undefined)))(undefined),
    fun
      (X) ->
        fun
          (Y) ->
            (V(fun
               (V@1) ->
                 case V@1 of
                   {yield, V@2, V@3} ->
                     { yield
                     , V@2
                     , data_lazy@foreign:defer(fun
                         (_) ->
                           ((concat(DictApplicative))
                            (data_lazy@foreign:force(V@3)))
                           (Y)
                       end)
                     };
                   {skip, V@4} ->
                     { skip
                     , data_lazy@foreign:defer(fun
                         (_) ->
                           ((concat(DictApplicative))
                            (data_lazy@foreign:force(V@4)))
                           (Y)
                       end)
                     };
                   {done} ->
                     { skip
                     , data_lazy@foreign:defer(fun
                         (_) ->
                           Y
                       end)
                     };
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end))
            (X)
        end
    end
  end.

monoidListT() ->
  fun
    (DictApplicative) ->
      monoidListT(DictApplicative)
  end.

monoidListT(DictApplicative = #{ pure := DictApplicative@1 }) ->
  begin
    SemigroupListT1 = #{ append => concat(DictApplicative) },
    #{ mempty => DictApplicative@1({done})
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupListT1
       end
     }
  end.

catMaybes() ->
  fun
    (DictFunctor) ->
      catMaybes(DictFunctor)
  end.

catMaybes(DictFunctor) ->
  ((mapMaybe())(DictFunctor))(identity()).

monadListT() ->
  fun
    (DictMonad) ->
      monadListT(DictMonad)
  end.

monadListT(DictMonad) ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeListT(DictMonad)
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindListT(DictMonad)
     end
   }.

bindListT() ->
  fun
    (DictMonad) ->
      bindListT(DictMonad)
  end.

bindListT(DictMonad = #{ 'Applicative0' := DictMonad@1, 'Bind1' := DictMonad@2 }) ->
  begin
    Append = concat(DictMonad@1(undefined)),
    #{ map := V } =
      (erlang:map_get(
         'Functor0',
         (erlang:map_get('Apply0', DictMonad@2(undefined)))(undefined)
       ))
      (undefined),
    #{ bind =>
       fun
         (Fa) ->
           fun
             (F) ->
               (V(fun
                  (V@1) ->
                    case V@1 of
                      {yield, V@2, V@3} ->
                        { skip
                        , data_lazy@foreign:defer(fun
                            (_) ->
                              (Append(F(V@2)))
                              (((erlang:map_get(bind, bindListT(DictMonad)))
                                (data_lazy@foreign:force(V@3)))
                               (F))
                          end)
                        };
                      {skip, V@4} ->
                        { skip
                        , data_lazy@foreign:defer(fun
                            (_) ->
                              ((erlang:map_get(bind, bindListT(DictMonad)))
                               (data_lazy@foreign:force(V@4)))
                              (F)
                          end)
                        };
                      {done} ->
                        {done};
                      _ ->
                        erlang:error({fail, <<"Failed pattern match">>})
                    end
                end))
               (Fa)
           end
       end
     , 'Apply0' =>
       fun
         (_) ->
           applyListT(DictMonad)
       end
     }
  end.

applyListT() ->
  fun
    (DictMonad) ->
      applyListT(DictMonad)
  end.

applyListT(DictMonad = #{ 'Bind1' := DictMonad@1 }) ->
  begin
    FunctorListT1 =
      functorListT((erlang:map_get(
                      'Functor0',
                      (erlang:map_get('Apply0', DictMonad@1(undefined)))
                      (undefined)
                    ))
                   (undefined)),
    #{ apply =>
       begin
         #{ bind := V } = bindListT(DictMonad),
         fun
           (F) ->
             fun
               (A) ->
                 (V(F))
                 (fun
                   (F_) ->
                     (V(A))
                     (fun
                       (A_) ->
                         (erlang:map_get(pure, applicativeListT(DictMonad)))
                         (F_(A_))
                     end)
                 end)
             end
         end
       end
     , 'Functor0' =>
       fun
         (_) ->
           FunctorListT1
       end
     }
  end.

applicativeListT() ->
  fun
    (DictMonad) ->
      applicativeListT(DictMonad)
  end.

applicativeListT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  #{ pure => singleton(DictMonad@1(undefined))
   , 'Apply0' =>
     fun
       (_) ->
         applyListT(DictMonad)
     end
   }.

monadEffectListT() ->
  fun
    (DictMonadEffect) ->
      monadEffectListT(DictMonadEffect)
  end.

monadEffectListT(#{ 'Monad0' := DictMonadEffect
                  , liftEffect := DictMonadEffect@1
                  }) ->
  begin
    Monad0 = #{ 'Applicative0' := Monad0@1 } = DictMonadEffect(undefined),
    MonadListT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             #{ pure => singleton(Monad0@1(undefined))
              , 'Apply0' =>
                fun
                  (_) ->
                    applyListT(Monad0)
                end
              }
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindListT(Monad0)
         end
       },
    #{ liftEffect =>
       begin
         V = fromEffect(Monad0@1(undefined)),
         fun
           (X) ->
             V(DictMonadEffect@1(X))
         end
       end
     , 'Monad0' =>
       fun
         (_) ->
           MonadListT1
       end
     }
  end.

altListT() ->
  fun
    (DictApplicative) ->
      altListT(DictApplicative)
  end.

altListT(DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
  begin
    FunctorListT1 =
      functorListT((erlang:map_get('Functor0', DictApplicative@1(undefined)))
                   (undefined)),
    #{ alt => concat(DictApplicative)
     , 'Functor0' =>
       fun
         (_) ->
           FunctorListT1
       end
     }
  end.

plusListT() ->
  fun
    (DictMonad) ->
      plusListT(DictMonad)
  end.

plusListT(#{ 'Applicative0' := DictMonad }) ->
  begin
    Applicative0 = #{ pure := Applicative0@1 } = DictMonad(undefined),
    AltListT1 = altListT(Applicative0),
    #{ empty => Applicative0@1({done})
     , 'Alt0' =>
       fun
         (_) ->
           AltListT1
       end
     }
  end.

alternativeListT() ->
  fun
    (DictMonad) ->
      alternativeListT(DictMonad)
  end.

alternativeListT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    ApplicativeListT1 =
      #{ pure => singleton(DictMonad@1(undefined))
       , 'Apply0' =>
         fun
           (_) ->
             applyListT(DictMonad)
         end
       },
    PlusListT1 = plusListT(DictMonad),
    #{ 'Applicative0' =>
       fun
         (_) ->
           ApplicativeListT1
       end
     , 'Plus1' =>
       fun
         (_) ->
           PlusListT1
       end
     }
  end.

monadPlusListT() ->
  fun
    (DictMonad) ->
      monadPlusListT(DictMonad)
  end.

monadPlusListT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    MonadListT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             #{ pure => singleton(DictMonad@1(undefined))
              , 'Apply0' =>
                fun
                  (_) ->
                    applyListT(DictMonad)
                end
              }
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindListT(DictMonad)
         end
       },
    AlternativeListT1 = alternativeListT(DictMonad),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadListT1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeListT1
       end
     }
  end.

monadZeroListT() ->
  fun
    (DictMonad) ->
      monadZeroListT(DictMonad)
  end.

monadZeroListT(DictMonad = #{ 'Applicative0' := DictMonad@1 }) ->
  begin
    MonadListT1 =
      #{ 'Applicative0' =>
         fun
           (_) ->
             #{ pure => singleton(DictMonad@1(undefined))
              , 'Apply0' =>
                fun
                  (_) ->
                    applyListT(DictMonad)
                end
              }
         end
       , 'Bind1' =>
         fun
           (_) ->
             bindListT(DictMonad)
         end
       },
    AlternativeListT1 = alternativeListT(DictMonad),
    #{ 'Monad0' =>
       fun
         (_) ->
           MonadListT1
       end
     , 'Alternative1' =>
       fun
         (_) ->
           AlternativeListT1
       end
     , 'MonadZeroIsDeprecated2' =>
       fun
         (_) ->
           undefined
       end
     }
  end.

