-module(data_list_lazy_types@ps).
-export([ identity/0
        , identity/1
        , 'List'/0
        , 'List'/1
        , 'Nil'/0
        , 'Cons'/0
        , 'NonEmptyList'/0
        , 'NonEmptyList'/1
        , nil/0
        , newtypeNonEmptyList/0
        , newtypeList/0
        , step/0
        , step/1
        , semigroupList/0
        , monoidList/0
        , lazyList/0
        , functorList/0
        , functorNonEmptyList/0
        , eq1List/0
        , eqNonEmpty/0
        , eqNonEmpty/1
        , eq1NonEmptyList/0
        , eqList/0
        , eqList/1
        , eqNonEmptyList/0
        , eqNonEmptyList/1
        , ord1List/0
        , ordNonEmpty/0
        , ord1NonEmptyList/0
        , ordList/0
        , ordList/1
        , ordNonEmptyList/0
        , ordNonEmptyList/1
        , cons/0
        , cons/2
        , foldableList/0
        , foldableNonEmpty/0
        , extendList/0
        , extendNonEmptyList/0
        , foldableNonEmptyList/0
        , showList/0
        , showList/1
        , showNonEmptyList/0
        , showNonEmptyList/1
        , showStep/0
        , showStep/1
        , foldableWithIndexList/0
        , foldableWithIndexNonEmpty/0
        , foldableWithIndexNonEmptyList/0
        , functorWithIndexList/0
        , mapWithIndex/0
        , mapWithIndex/2
        , functorWithIndexNonEmptyList/0
        , toList/0
        , toList/1
        , semigroupNonEmptyList/0
        , traversableList/0
        , traversableNonEmpty/0
        , traversableNonEmptyList/0
        , traversableWithIndexList/0
        , traverseWithIndex/0
        , traversableWithIndexNonEmptyList/0
        , unfoldable1List/0
        , unfoldableList/0
        , unfoldr1/0
        , unfoldr1/2
        , unfoldable1NonEmptyList/0
        , comonadNonEmptyList/0
        , monadList/0
        , bindList/0
        , applyList/0
        , applicativeList/0
        , applyNonEmptyList/0
        , bindNonEmptyList/0
        , altNonEmptyList/0
        , altList/0
        , plusList/0
        , alternativeList/0
        , monadPlusList/0
        , monadZeroList/0
        , applicativeNonEmptyList/0
        , monadNonEmptyList/0
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

'List'() ->
  fun
    (X) ->
      'List'(X)
  end.

'List'(X) ->
  X.

'Nil'() ->
  {nil}.

'Cons'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {cons, Value0, Value1}
      end
  end.

'NonEmptyList'() ->
  fun
    (X) ->
      'NonEmptyList'(X)
  end.

'NonEmptyList'(X) ->
  X.

nil() ->
  data_lazy@foreign:defer(fun
    (_) ->
      {nil}
  end).

newtypeNonEmptyList() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeList() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

step() ->
  fun
    (X) ->
      step(X)
  end.

step(X) ->
  data_lazy@foreign:force(X).

semigroupList() ->
  #{ append =>
     fun
       (Xs) ->
         fun
           (Ys) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 begin
                   V = data_lazy@foreign:force(Xs),
                   case V of
                     {nil} ->
                       data_lazy@foreign:force(Ys);
                     {cons, V@1, V@2} ->
                       { cons
                       , V@1
                       , ((erlang:map_get(append, semigroupList()))(V@2))(Ys)
                       };
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end)
         end
     end
   }.

monoidList() ->
  #{ mempty => nil()
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupList()
     end
   }.

lazyList() ->
  #{ defer =>
     fun
       (F) ->
         data_lazy@foreign:defer(fun
           (X) ->
             data_lazy@foreign:force(F(X))
         end)
     end
   }.

functorList() ->
  #{ map =>
     fun
       (F) ->
         fun
           (Xs) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 begin
                   V = data_lazy@foreign:force(Xs),
                   case V of
                     {nil} ->
                       {nil};
                     {cons, V@1, V@2} ->
                       { cons
                       , F(V@1)
                       , ((erlang:map_get(map, functorList()))(F))(V@2)
                       };
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end)
         end
     end
   }.

functorNonEmptyList() ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 begin
                   V@1 = data_lazy@foreign:force(V),
                   { nonEmpty
                   , F(erlang:element(2, V@1))
                   , ((erlang:map_get(map, functorList()))(F))
                     (erlang:element(3, V@1))
                   }
                 end
             end)
         end
     end
   }.

eq1List() ->
  #{ eq1 =>
     fun
       (DictEq) ->
         fun
           (Xs) ->
             fun
               (Ys) ->
                 begin
                   Go =
                     fun
                       Go (V, V1) ->
                         case V of
                           {nil} ->
                             ?IS_KNOWN_TAG(nil, 0, V1);
                           _ ->
                             ?IS_KNOWN_TAG(cons, 2, V)
                               andalso (?IS_KNOWN_TAG(cons, 2, V1)
                                 andalso ((((erlang:map_get(eq, DictEq))
                                            (erlang:element(2, V)))
                                           (erlang:element(2, V1)))
                                   andalso begin
                                     V@1 =
                                       data_lazy@foreign:force(erlang:element(
                                                                 3,
                                                                 V
                                                               )),
                                     V1@1 =
                                       data_lazy@foreign:force(erlang:element(
                                                                 3,
                                                                 V1
                                                               )),
                                     Go(V@1, V1@1)
                                   end))
                         end
                     end,
                   V = data_lazy@foreign:force(Xs),
                   V1 = data_lazy@foreign:force(Ys),
                   Go(V, V1)
                 end
             end
         end
     end
   }.

eqNonEmpty() ->
  fun
    (DictEq) ->
      eqNonEmpty(DictEq)
  end.

eqNonEmpty(DictEq = #{ eq := DictEq@1 }) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             ((DictEq@1(erlang:element(2, X)))(erlang:element(2, Y)))
               andalso ((((erlang:map_get(eq1, eq1List()))(DictEq))
                         (erlang:element(3, X)))
                        (erlang:element(3, Y)))
         end
     end
   }.

eq1NonEmptyList() ->
  #{ eq1 =>
     fun
       (DictEq) ->
         (erlang:map_get(eq1, data_lazy@ps:eq1Lazy()))(eqNonEmpty(DictEq))
     end
   }.

eqList() ->
  fun
    (DictEq) ->
      eqList(DictEq)
  end.

eqList(DictEq) ->
  #{ eq => (erlang:map_get(eq1, eq1List()))(DictEq) }.

eqNonEmptyList() ->
  fun
    (DictEq) ->
      eqNonEmptyList(DictEq)
  end.

eqNonEmptyList(DictEq) ->
  begin
    #{ eq := V } = eqNonEmpty(DictEq),
    #{ eq =>
       fun
         (X) ->
           fun
             (Y) ->
               (V(data_lazy@foreign:force(X)))(data_lazy@foreign:force(Y))
           end
       end
     }
  end.

ord1List() ->
  #{ compare1 =>
     fun
       (DictOrd) ->
         fun
           (Xs) ->
             fun
               (Ys) ->
                 begin
                   Go =
                     fun
                       Go (V, V1) ->
                         case V of
                           {nil} ->
                             case V1 of
                               {nil} ->
                                 {eQ};
                               _ ->
                                 {lT}
                             end;
                           _ ->
                             case V1 of
                               {nil} ->
                                 {gT};
                               _ ->
                                 if
                                   ?IS_KNOWN_TAG(cons, 2, V)
                                     andalso ?IS_KNOWN_TAG(cons, 2, V1) ->
                                     begin
                                       {cons, V@1, _} = V,
                                       {cons, V1@1, _} = V1,
                                       #{ compare := DictOrd@1 } = DictOrd,
                                       V2 = (DictOrd@1(V@1))(V1@1),
                                       case V2 of
                                         {eQ} ->
                                           begin
                                             {cons, _, V@2} = V,
                                             {cons, _, V1@2} = V1,
                                             V@3 = data_lazy@foreign:force(V@2),
                                             V1@3 =
                                               data_lazy@foreign:force(V1@2),
                                             Go(V@3, V1@3)
                                           end;
                                         _ ->
                                           V2
                                       end
                                     end;
                                   true ->
                                     erlang:error({ fail
                                                  , <<"Failed pattern match">>
                                                  })
                                 end
                             end
                         end
                     end,
                   V = data_lazy@foreign:force(Xs),
                   V1 = data_lazy@foreign:force(Ys),
                   Go(V, V1)
                 end
             end
         end
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1List()
     end
   }.

ordNonEmpty() ->
  data_nonEmpty@ps:ordNonEmpty(ord1List()).

ord1NonEmptyList() ->
  #{ compare1 =>
     fun
       (DictOrd) ->
         erlang:map_get(compare, data_lazy@ps:ordLazy((ordNonEmpty())(DictOrd)))
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1NonEmptyList()
     end
   }.

ordList() ->
  fun
    (DictOrd) ->
      ordList(DictOrd)
  end.

ordList(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  #{ compare => (erlang:map_get(compare1, ord1List()))(DictOrd)
   , 'Eq0' =>
     fun
       (_) ->
         #{ eq => (erlang:map_get(eq1, eq1List()))(DictOrd@1(undefined)) }
     end
   }.

ordNonEmptyList() ->
  fun
    (DictOrd) ->
      ordNonEmptyList(DictOrd)
  end.

ordNonEmptyList(DictOrd) ->
  data_lazy@ps:ordLazy((ordNonEmpty())(DictOrd)).

cons() ->
  fun
    (X) ->
      fun
        (Xs) ->
          cons(X, Xs)
      end
  end.

cons(X, Xs) ->
  data_lazy@foreign:defer(fun
    (_) ->
      {cons, X, Xs}
  end).

foldableList() ->
  #{ foldr =>
     fun
       (Op) ->
         fun
           (Z) ->
             fun
               (Xs) ->
                 begin
                   V = foldableList(),
                   (((erlang:map_get(foldl, V))
                     (fun
                       (B) ->
                         fun
                           (A) ->
                             (Op(A))(B)
                         end
                     end))
                    (Z))
                   ((((erlang:map_get(foldl, V))
                      (fun
                        (B) ->
                          fun
                            (A) ->
                              data_lazy@foreign:defer(fun
                                (_) ->
                                  {cons, A, B}
                              end)
                          end
                      end))
                     (nil()))
                    (Xs))
                 end
             end
         end
     end
   , foldl =>
     fun
       (Op) ->
         begin
           Go =
             fun
               Go (B, Xs) ->
                 begin
                   V = data_lazy@foreign:force(Xs),
                   case V of
                     {nil} ->
                       B;
                     {cons, V@1, V@2} ->
                       begin
                         B@1 = (Op(B))(V@1),
                         Go(B@1, V@2)
                       end;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end,
           fun
             (B) ->
               fun
                 (Xs) ->
                   Go(B, Xs)
               end
           end
         end
     end
   , foldMap =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         fun
           (F) ->
             ((erlang:map_get(foldl, foldableList()))
              (fun
                (B) ->
                  fun
                    (A) ->
                      ((erlang:map_get(append, DictMonoid(undefined)))(B))(F(A))
                  end
              end))
             (DictMonoid@1)
         end
     end
   }.

foldableNonEmpty() ->
  #{ foldMap =>
     fun
       (DictMonoid = #{ 'Semigroup0' := DictMonoid@1 }) ->
         begin
           FoldMap1 = (erlang:map_get(foldMap, foldableList()))(DictMonoid),
           fun
             (F) ->
               fun
                 (V) ->
                   ((erlang:map_get(append, DictMonoid@1(undefined)))
                    (F(erlang:element(2, V))))
                   ((FoldMap1(F))(erlang:element(3, V)))
               end
           end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (V) ->
                 (((erlang:map_get(foldl, foldableList()))(F))
                  ((F(B))(erlang:element(2, V))))
                 (erlang:element(3, V))
             end
         end
     end
   , foldr =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (V) ->
                 (F(erlang:element(2, V)))
                 ((((erlang:map_get(foldr, foldableList()))(F))(B))
                  (erlang:element(3, V)))
             end
         end
     end
   }.

extendList() ->
  #{ extend =>
     fun
       (F) ->
         fun
           (L) ->
             begin
               V = nil(),
               V@1 = data_lazy@foreign:force(L),
               case V@1 of
                 {nil} ->
                   V;
                 {cons, _, V@2} ->
                   begin
                     V@3 = F(L),
                     V@4 =
                       erlang:map_get(
                         val,
                         (((erlang:map_get(foldr, foldableList()))
                           (fun
                             (A) ->
                               fun
                                 (#{ acc := V@4, val := V@5 }) ->
                                   begin
                                     Acc_ =
                                       data_lazy@foreign:defer(fun
                                         (_) ->
                                           {cons, A, V@4}
                                       end),
                                     #{ val =>
                                        begin
                                          V@6 = F(Acc_),
                                          data_lazy@foreign:defer(fun
                                            (_) ->
                                              {cons, V@6, V@5}
                                          end)
                                        end
                                      , acc => Acc_
                                      }
                                   end
                               end
                           end))
                          (#{ val => V, acc => V }))
                         (V@2)
                       ),
                     data_lazy@foreign:defer(fun
                       (_) ->
                         {cons, V@3, V@4}
                     end)
                   end;
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorList()
     end
   }.

extendNonEmptyList() ->
  #{ extend =>
     fun
       (F) ->
         fun
           (V) ->
             begin
               V@1 = erlang:element(3, data_lazy@foreign:force(V)),
               data_lazy@foreign:defer(fun
                 (_) ->
                   begin
                     V@2 = nil(),
                     { nonEmpty
                     , F(V)
                     , erlang:map_get(
                         val,
                         (((erlang:map_get(foldr, foldableList()))
                           (fun
                             (A) ->
                               fun
                                 (#{ acc := V1, val := V1@1 }) ->
                                   #{ val =>
                                      begin
                                        V@3 =
                                          F(data_lazy@foreign:defer(fun
                                              (_) ->
                                                {nonEmpty, A, V1}
                                            end)),
                                        data_lazy@foreign:defer(fun
                                          (_) ->
                                            {cons, V@3, V1@1}
                                        end)
                                      end
                                    , acc =>
                                      data_lazy@foreign:defer(fun
                                        (_) ->
                                          {cons, A, V1}
                                      end)
                                    }
                               end
                           end))
                          (#{ val => V@2, acc => V@2 }))
                         (V@1)
                       )
                     }
                   end
               end)
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorNonEmptyList()
     end
   }.

foldableNonEmptyList() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (V) ->
                 begin
                   V@1 = data_lazy@foreign:force(V),
                   (F(erlang:element(2, V@1)))
                   ((((erlang:map_get(foldr, foldableList()))(F))(B))
                    (erlang:element(3, V@1)))
                 end
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (V) ->
                 begin
                   V@1 = data_lazy@foreign:force(V),
                   (((erlang:map_get(foldl, foldableList()))(F))
                    ((F(B))(erlang:element(2, V@1))))
                   (erlang:element(3, V@1))
                 end
             end
         end
     end
   , foldMap =>
     fun
       (DictMonoid) ->
         begin
           FoldMap1 = (erlang:map_get(foldMap, foldableNonEmpty()))(DictMonoid),
           fun
             (F) ->
               fun
                 (V) ->
                   (FoldMap1(F))(data_lazy@foreign:force(V))
               end
           end
         end
     end
   }.

showList() ->
  fun
    (DictShow) ->
      showList(DictShow)
  end.

showList(DictShow) ->
  #{ show =>
     fun
       (Xs) ->
         begin
           V = data_lazy@foreign:force(Xs),
           case V of
             {nil} ->
               <<"(fromFoldable [])">>;
             {cons, V@1, V@2} ->
               begin
                 #{ show := DictShow@1 } = DictShow,
                 <<
                   "(fromFoldable [",
                   (DictShow@1(V@1))/binary,
                   ((((erlang:map_get(foldl, foldableList()))
                      (fun
                        (Shown) ->
                          fun
                            (X_) ->
                              <<Shown/binary, ",", (DictShow@1(X_))/binary>>
                          end
                      end))
                     (<<"">>))
                    (V@2))/binary,
                   "])"
                 >>
               end;
             _ ->
               erlang:error({fail, <<"Failed pattern match">>})
           end
         end
     end
   }.

showNonEmptyList() ->
  fun
    (DictShow) ->
      showNonEmptyList(DictShow)
  end.

showNonEmptyList(DictShow = #{ show := DictShow@1 }) ->
  begin
    #{ show := V } = showList(DictShow),
    #{ show =>
       fun
         (V@1) ->
           begin
             V@2 = data_lazy@foreign:force(V@1),
             <<
               "(NonEmptyList (defer \\_ -> (NonEmpty ",
               (DictShow@1(erlang:element(2, V@2)))/binary,
               " ",
               (V(erlang:element(3, V@2)))/binary,
               ")))"
             >>
           end
       end
     }
  end.

showStep() ->
  fun
    (DictShow) ->
      showStep(DictShow)
  end.

showStep(DictShow) ->
  #{ show =>
     fun
       (V) ->
         case V of
           {nil} ->
             <<"Nil">>;
           {cons, V@1, V@2} ->
             begin
               #{ show := DictShow@1 } = DictShow,
               <<
                 "(",
                 (DictShow@1(V@1))/binary,
                 " : ",
                 ((erlang:map_get(show, showList(DictShow)))(V@2))/binary,
                 ")"
               >>
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

foldableWithIndexList() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (Xs) ->
                 begin
                   V = foldableList(),
                   V@1 =
                     (((erlang:map_get(foldl, V))
                       (fun
                         (V1) ->
                           begin
                             V@1 = erlang:element(3, V1),
                             V@2 = erlang:element(2, V1),
                             fun
                               (A) ->
                                 { tuple
                                 , V@2 + 1
                                 , data_lazy@foreign:defer(fun
                                     (_) ->
                                       {cons, A, V@1}
                                   end)
                                 }
                             end
                           end
                       end))
                      ({tuple, 0, nil()}))
                     (Xs),
                   erlang:element(
                     3,
                     (((erlang:map_get(foldl, V))
                       (fun
                         (V1) ->
                           begin
                             V@2 = erlang:element(3, V1),
                             V@3 = erlang:element(2, V1),
                             fun
                               (A) ->
                                 {tuple, V@3 - 1, ((F(V@3 - 1))(A))(V@2)}
                             end
                           end
                       end))
                      ({tuple, erlang:element(2, V@1), B}))
                     (erlang:element(3, V@1))
                   )
                 end
             end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         fun
           (Acc) ->
             begin
               V =
                 ((erlang:map_get(foldl, foldableList()))
                  (fun
                    (V) ->
                      begin
                        V@1 = erlang:element(3, V),
                        V@2 = erlang:element(2, V),
                        fun
                          (A) ->
                            {tuple, V@2 + 1, ((F(V@2))(V@1))(A)}
                        end
                      end
                  end))
                 ({tuple, 0, Acc}),
               fun
                 (X) ->
                   erlang:element(3, V(X))
               end
             end
         end
     end
   , foldMapWithIndex =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         fun
           (F) ->
             ((erlang:map_get(foldlWithIndex, foldableWithIndexList()))
              (fun
                (I) ->
                  fun
                    (Acc) ->
                      begin
                        V = (erlang:map_get(append, DictMonoid(undefined)))(Acc),
                        V@1 = F(I),
                        fun
                          (X) ->
                            V(V@1(X))
                        end
                      end
                  end
              end))
             (DictMonoid@1)
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         foldableList()
     end
   }.

foldableWithIndexNonEmpty() ->
  data_nonEmpty@ps:foldableWithIndexNonEmpty(foldableWithIndexList()).

foldableWithIndexNonEmptyList() ->
  #{ foldMapWithIndex =>
     fun
       (DictMonoid) ->
         begin
           FoldMapWithIndex1 =
             (erlang:map_get(foldMapWithIndex, foldableWithIndexNonEmpty()))
             (DictMonoid),
           fun
             (F) ->
               fun
                 (V) ->
                   (FoldMapWithIndex1(fun
                      (X) ->
                        F(case X of
                          {nothing} ->
                            0;
                          {just, X@1} ->
                            1 + X@1;
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end)
                    end))
                   (data_lazy@foreign:force(V))
               end
           end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (V) ->
                 (((erlang:map_get(foldlWithIndex, foldableWithIndexNonEmpty()))
                   (fun
                     (X) ->
                       F(case X of
                         {nothing} ->
                           0;
                         {just, X@1} ->
                           1 + X@1;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end)
                   end))
                  (B))
                 (data_lazy@foreign:force(V))
             end
         end
     end
   , foldrWithIndex =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (V) ->
                 (((erlang:map_get(foldrWithIndex, foldableWithIndexNonEmpty()))
                   (fun
                     (X) ->
                       F(case X of
                         {nothing} ->
                           0;
                         {just, X@1} ->
                           1 + X@1;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end)
                   end))
                  (B))
                 (data_lazy@foreign:force(V))
             end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         foldableNonEmptyList()
     end
   }.

functorWithIndexList() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         ((erlang:map_get(foldrWithIndex, foldableWithIndexList()))
          (fun
            (I) ->
              fun
                (X) ->
                  fun
                    (Acc) ->
                      begin
                        V = (F(I))(X),
                        data_lazy@foreign:defer(fun
                          (_) ->
                            {cons, V, Acc}
                        end)
                      end
                  end
              end
          end))
         (nil())
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorList()
     end
   }.

mapWithIndex() ->
  fun
    (F) ->
      fun
        (V) ->
          mapWithIndex(F, V)
      end
  end.

mapWithIndex(F, V) ->
  { nonEmpty
  , (F({nothing}))(erlang:element(2, V))
  , ((erlang:map_get(mapWithIndex, functorWithIndexList()))
     (fun
       (X) ->
         F({just, X})
     end))
    (erlang:element(3, V))
  }.

functorWithIndexNonEmptyList() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         fun
           (V) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 mapWithIndex(
                   fun
                     (X) ->
                       F(case X of
                         {nothing} ->
                           0;
                         {just, X@1} ->
                           1 + X@1;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end)
                   end,
                   data_lazy@foreign:force(V)
                 )
             end)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorNonEmptyList()
     end
   }.

toList() ->
  fun
    (V) ->
      toList(V)
  end.

toList(V) ->
  data_lazy@foreign:defer(fun
    (_) ->
      data_lazy@foreign:force(begin
        V2 = data_lazy@foreign:force(V),
        V@1 = erlang:element(2, V2),
        V@2 = erlang:element(3, V2),
        data_lazy@foreign:defer(fun
          (_) ->
            {cons, V@1, V@2}
        end)
      end)
  end).

semigroupNonEmptyList() ->
  #{ append =>
     fun
       (V) ->
         fun
           (As_) ->
             begin
               V1 = data_lazy@foreign:force(V),
               V@1 = erlang:element(2, V1),
               V@2 = erlang:element(3, V1),
               data_lazy@foreign:defer(fun
                 (_) ->
                   { nonEmpty
                   , V@1
                   , ((erlang:map_get(append, semigroupList()))(V@2))
                     (toList(As_))
                   }
               end)
             end
         end
     end
   }.

traversableList() ->
  #{ traverse =>
     fun
       (#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
         begin
           #{ 'Functor0' := Apply0, apply := Apply0@1 } =
             DictApplicative(undefined),
           fun
             (F) ->
               ((erlang:map_get(foldr, foldableList()))
                (fun
                  (A) ->
                    fun
                      (B) ->
                        (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                                   (cons()))
                                  (F(A))))
                        (B)
                    end
                end))
               (DictApplicative@1(nil()))
           end
         end
     end
   , sequence =>
     fun
       (DictApplicative) ->
         ((erlang:map_get(traverse, traversableList()))(DictApplicative))
         (identity())
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorList()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         foldableList()
     end
   }.

traversableNonEmpty() ->
  data_nonEmpty@ps:traversableNonEmpty(traversableList()).

traversableNonEmptyList() ->
  #{ traverse =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           Traverse1 =
             (erlang:map_get(traverse, traversableNonEmpty()))(DictApplicative),
           fun
             (F) ->
               fun
                 (V) ->
                   ((erlang:map_get(
                       map,
                       (erlang:map_get(
                          'Functor0',
                          DictApplicative@1(undefined)
                        ))
                       (undefined)
                     ))
                    (fun
                      (Xxs) ->
                        data_lazy@foreign:defer(fun
                          (_) ->
                            Xxs
                        end)
                    end))
                   ((Traverse1(F))(data_lazy@foreign:force(V)))
               end
           end
         end
     end
   , sequence =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           Sequence1 =
             (erlang:map_get(sequence, traversableNonEmpty()))(DictApplicative),
           fun
             (V) ->
               ((erlang:map_get(
                   map,
                   (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                   (undefined)
                 ))
                (fun
                  (Xxs) ->
                    data_lazy@foreign:defer(fun
                      (_) ->
                        Xxs
                    end)
                end))
               (Sequence1(data_lazy@foreign:force(V)))
           end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorNonEmptyList()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         foldableNonEmptyList()
     end
   }.

traversableWithIndexList() ->
  #{ traverseWithIndex =>
     fun
       (#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
         begin
           #{ 'Functor0' := Apply0, apply := Apply0@1 } =
             DictApplicative(undefined),
           fun
             (F) ->
               ((erlang:map_get(foldrWithIndex, foldableWithIndexList()))
                (fun
                  (I) ->
                    fun
                      (A) ->
                        fun
                          (B) ->
                            (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                                       (cons()))
                                      ((F(I))(A))))
                            (B)
                        end
                    end
                end))
               (DictApplicative@1(nil()))
           end
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         functorWithIndexList()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         foldableWithIndexList()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         traversableList()
     end
   }.

traverseWithIndex() ->
  erlang:map_get(
    traverseWithIndex,
    data_nonEmpty@ps:traversableWithIndexNonEmpty(traversableWithIndexList())
  ).

traversableWithIndexNonEmptyList() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           TraverseWithIndex1 = (traverseWithIndex())(DictApplicative),
           fun
             (F) ->
               fun
                 (V) ->
                   ((erlang:map_get(
                       map,
                       (erlang:map_get(
                          'Functor0',
                          DictApplicative@1(undefined)
                        ))
                       (undefined)
                     ))
                    (fun
                      (Xxs) ->
                        data_lazy@foreign:defer(fun
                          (_) ->
                            Xxs
                        end)
                    end))
                   ((TraverseWithIndex1(fun
                       (X) ->
                         F(case X of
                           {nothing} ->
                             0;
                           {just, X@1} ->
                             1 + X@1;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end)
                     end))
                    (data_lazy@foreign:force(V)))
               end
           end
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         functorWithIndexNonEmptyList()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         foldableWithIndexNonEmptyList()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         traversableNonEmptyList()
     end
   }.

unfoldable1List() ->
  #{ unfoldr1 =>
     begin
       Go =
         fun
           Go (F, B) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 data_lazy@foreign:force(begin
                   V1 = F(B),
                   case erlang:element(3, V1) of
                     {just, _} ->
                       begin
                         V = erlang:element(2, V1),
                         V@1 =
                           begin
                             B@1 = erlang:element(2, erlang:element(3, V1)),
                             Go(F, B@1)
                           end,
                         data_lazy@foreign:defer(fun
                           (_) ->
                             {cons, V, V@1}
                         end)
                       end;
                     {nothing} ->
                       begin
                         V@2 = erlang:element(2, V1),
                         data_lazy@foreign:defer(fun
                           (_) ->
                             {cons, V@2, nil()}
                         end)
                       end;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end)
             end)
         end,
       fun
         (F) ->
           fun
             (B) ->
               Go(F, B)
           end
       end
     end
   }.

unfoldableList() ->
  #{ unfoldr =>
     begin
       Go =
         fun
           Go (F, B) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 data_lazy@foreign:force(begin
                   V1 = F(B),
                   case V1 of
                     {nothing} ->
                       nil();
                     {just, V1@1} ->
                       begin
                         V = erlang:element(2, V1@1),
                         V@1 =
                           begin
                             B@1 = erlang:element(3, V1@1),
                             Go(F, B@1)
                           end,
                         data_lazy@foreign:defer(fun
                           (_) ->
                             {cons, V, V@1}
                         end)
                       end;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end)
             end)
         end,
       fun
         (F) ->
           fun
             (B) ->
               Go(F, B)
           end
       end
     end
   , 'Unfoldable10' =>
     fun
       (_) ->
         unfoldable1List()
     end
   }.

unfoldr1() ->
  fun
    (F) ->
      fun
        (B) ->
          unfoldr1(F, B)
      end
  end.

unfoldr1(F, B) ->
  begin
    V = F(B),
    { nonEmpty
    , erlang:element(2, V)
    , ((erlang:map_get(unfoldr, unfoldableList()))
       (fun
         (V1) ->
           case V1 of
             {just, V1@1} ->
               {just, F(V1@1)};
             _ ->
               {nothing}
           end
       end))
      (erlang:element(3, V))
    }
  end.

unfoldable1NonEmptyList() ->
  #{ unfoldr1 =>
     fun
       (F) ->
         fun
           (B) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 unfoldr1(F, B)
             end)
         end
     end
   }.

comonadNonEmptyList() ->
  #{ extract =>
     fun
       (V) ->
         erlang:element(2, data_lazy@foreign:force(V))
     end
   , 'Extend0' =>
     fun
       (_) ->
         extendNonEmptyList()
     end
   }.

monadList() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeList()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindList()
     end
   }.

bindList() ->
  #{ bind =>
     fun
       (Xs) ->
         fun
           (F) ->
             data_lazy@foreign:defer(fun
               (_) ->
                 begin
                   V = data_lazy@foreign:force(Xs),
                   case V of
                     {nil} ->
                       {nil};
                     {cons, V@1, V@2} ->
                       data_lazy@foreign:force(((erlang:map_get(
                                                   append,
                                                   semigroupList()
                                                 ))
                                                (F(V@1)))
                                               (((erlang:map_get(
                                                    bind,
                                                    bindList()
                                                  ))
                                                 (V@2))
                                                (F)));
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end)
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyList()
     end
   }.

applyList() ->
  #{ apply =>
     fun
       (F) ->
         fun
           (A) ->
             ((erlang:map_get(bind, bindList()))(F))
             (fun
               (F_) ->
                 ((erlang:map_get(bind, bindList()))(A))
                 (fun
                   (A_) ->
                     (erlang:map_get(pure, applicativeList()))(F_(A_))
                 end)
             end)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorList()
     end
   }.

applicativeList() ->
  #{ pure =>
     fun
       (A) ->
         data_lazy@foreign:defer(fun
           (_) ->
             {cons, A, nil()}
         end)
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyList()
     end
   }.

applyNonEmptyList() ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             begin
               V2 = data_lazy@foreign:force(V1),
               V3 = data_lazy@foreign:force(V),
               V@1 = erlang:element(2, V2),
               V@2 = erlang:element(3, V2),
               V@3 = erlang:element(2, V3),
               V@4 = erlang:element(3, V3),
               data_lazy@foreign:defer(fun
                 (_) ->
                   begin
                     V@5 = applyList(),
                     { nonEmpty
                     , V@3(V@1)
                     , ((erlang:map_get(append, semigroupList()))
                        (((erlang:map_get(apply, V@5))(V@4))
                         (data_lazy@foreign:defer(fun
                            (_) ->
                              {cons, V@1, nil()}
                          end))))
                       (((erlang:map_get(apply, V@5))
                         (data_lazy@foreign:defer(fun
                            (_) ->
                              {cons, V@3, V@4}
                          end)))
                        (V@2))
                     }
                   end
               end)
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorNonEmptyList()
     end
   }.

bindNonEmptyList() ->
  #{ bind =>
     fun
       (V) ->
         fun
           (F) ->
             begin
               V1 = data_lazy@foreign:force(V),
               V@1 = erlang:element(3, V1),
               V2 = data_lazy@foreign:force(F(erlang:element(2, V1))),
               V@2 = erlang:element(2, V2),
               V@3 = erlang:element(3, V2),
               data_lazy@foreign:defer(fun
                 (_) ->
                   { nonEmpty
                   , V@2
                   , ((erlang:map_get(append, semigroupList()))(V@3))
                     (((erlang:map_get(bind, bindList()))(V@1))
                      (fun
                        (X) ->
                          toList(F(X))
                      end))
                   }
               end)
             end
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyNonEmptyList()
     end
   }.

altNonEmptyList() ->
  #{ alt => erlang:map_get(append, semigroupNonEmptyList())
   , 'Functor0' =>
     fun
       (_) ->
         functorNonEmptyList()
     end
   }.

altList() ->
  #{ alt => erlang:map_get(append, semigroupList())
   , 'Functor0' =>
     fun
       (_) ->
         functorList()
     end
   }.

plusList() ->
  #{ empty => nil()
   , 'Alt0' =>
     fun
       (_) ->
         altList()
     end
   }.

alternativeList() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeList()
     end
   , 'Plus1' =>
     fun
       (_) ->
         plusList()
     end
   }.

monadPlusList() ->
  #{ 'Monad0' =>
     fun
       (_) ->
         monadList()
     end
   , 'Alternative1' =>
     fun
       (_) ->
         alternativeList()
     end
   }.

monadZeroList() ->
  #{ 'Monad0' =>
     fun
       (_) ->
         monadList()
     end
   , 'Alternative1' =>
     fun
       (_) ->
         alternativeList()
     end
   , 'MonadZeroIsDeprecated2' =>
     fun
       (_) ->
         undefined
     end
   }.

applicativeNonEmptyList() ->
  #{ pure =>
     fun
       (A) ->
         data_lazy@foreign:defer(fun
           (_) ->
             {nonEmpty, A, nil()}
         end)
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyNonEmptyList()
     end
   }.

monadNonEmptyList() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeNonEmptyList()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindNonEmptyList()
     end
   }.

