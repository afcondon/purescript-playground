-module(data_list_types@ps).
-export([ identity/0
        , identity/1
        , 'Nil'/0
        , 'Cons'/0
        , 'NonEmptyList'/0
        , 'NonEmptyList'/1
        , toList/0
        , toList/1
        , newtypeNonEmptyList/0
        , nelCons/0
        , nelCons/2
        , listMap/0
        , listMap/1
        , functorList/0
        , functorNonEmptyList/0
        , foldableList/0
        , foldableNonEmptyList/0
        , foldableWithIndexList/0
        , foldableWithIndexNonEmpty/0
        , foldableWithIndexNonEmptyList/0
        , functorWithIndexList/0
        , mapWithIndex/0
        , mapWithIndex/2
        , functorWithIndexNonEmptyList/0
        , semigroupList/0
        , monoidList/0
        , semigroupNonEmptyList/0
        , showList/0
        , showList/1
        , showNonEmptyList/0
        , showNonEmptyList/1
        , traversableList/0
        , traversableNonEmptyList/0
        , traversableWithIndexList/0
        , traverseWithIndex/0
        , traversableWithIndexNonEmptyList/0
        , unfoldable1List/0
        , unfoldableList/0
        , unfoldable1NonEmptyList/0
        , foldable1NonEmptyList/0
        , extendNonEmptyList/0
        , extendList/0
        , eq1List/0
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
        , comonadNonEmptyList/0
        , applyList/0
        , applyNonEmptyList/0
        , bindList/0
        , bindNonEmptyList/0
        , applicativeList/0
        , monadList/0
        , altNonEmptyList/0
        , altList/0
        , plusList/0
        , alternativeList/0
        , monadPlusList/0
        , monadZeroList/0
        , applicativeNonEmptyList/0
        , monadNonEmptyList/0
        , traversable1NonEmptyList/0
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

toList() ->
  fun
    (V) ->
      toList(V)
  end.

toList(V) ->
  {cons, erlang:element(2, V), erlang:element(3, V)}.

newtypeNonEmptyList() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

nelCons() ->
  fun
    (A) ->
      fun
        (V) ->
          nelCons(A, V)
      end
  end.

nelCons(A, V) ->
  {nonEmpty, A, {cons, erlang:element(2, V), erlang:element(3, V)}}.

listMap() ->
  fun
    (F) ->
      listMap(F)
  end.

listMap(F) ->
  begin
    ChunkedRevMap =
      fun
        ChunkedRevMap (V, V1) ->
          if
            ?IS_KNOWN_TAG(cons, 2, V1)
              andalso (?IS_KNOWN_TAG(cons, 2, erlang:element(3, V1))
                andalso ?IS_KNOWN_TAG(cons, 2, erlang:element(
                                                 3,
                                                 erlang:element(3, V1)
                                               ))) ->
              begin
                {cons, _, {cons, _, {cons, _, V1@1}}} = V1,
                V@1 = {cons, V1, V},
                ChunkedRevMap(V@1, V1@1)
              end;
            true ->
              begin
                ReverseUnrolledMap =
                  fun
                    ReverseUnrolledMap (V2, V3) ->
                      if
                        ?IS_KNOWN_TAG(cons, 2, V2)
                          andalso (?IS_KNOWN_TAG(cons, 2, erlang:element(2, V2))
                            andalso (?IS_KNOWN_TAG(cons, 2, erlang:element(
                                                              3,
                                                              erlang:element(
                                                                2,
                                                                V2
                                                              )
                                                            ))
                              andalso ?IS_KNOWN_TAG(cons, 2, erlang:element(
                                                               3,
                                                               erlang:element(
                                                                 3,
                                                                 erlang:element(
                                                                   2,
                                                                   V2
                                                                 )
                                                               )
                                                             )))) ->
                          begin
                            { cons
                            , {cons, V2@1, {cons, V2@2, {cons, V2@3, _}}}
                            , V2@4
                            } =
                              V2,
                            V3@1 =
                              { cons
                              , F(V2@1)
                              , {cons, F(V2@2), {cons, F(V2@3), V3}}
                              },
                            ReverseUnrolledMap(V2@4, V3@1)
                          end;
                        true ->
                          V3
                      end
                  end,
                V3 =
                  case V1 of
                    {cons, _, _} ->
                      case erlang:element(3, V1) of
                        {cons, _, _} ->
                          case erlang:element(3, erlang:element(3, V1)) of
                            {nil} ->
                              begin
                                {cons, V1@2, {cons, V1@3, _}} = V1,
                                {cons, F(V1@2), {cons, F(V1@3), {nil}}}
                              end;
                            _ ->
                              {nil}
                          end;
                        {nil} ->
                          begin
                            {cons, V1@4, _} = V1,
                            {cons, F(V1@4), {nil}}
                          end;
                        _ ->
                          {nil}
                      end;
                    _ ->
                      {nil}
                  end,
                ReverseUnrolledMap(V, V3)
              end
          end
      end,
    V = {nil},
    fun
      (V1) ->
        ChunkedRevMap(V, V1)
    end
  end.

functorList() ->
  #{ map => listMap() }.

functorNonEmptyList() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             { nonEmpty
             , F(erlang:element(2, M))
             , (listMap(F))(erlang:element(3, M))
             }
         end
     end
   }.

foldableList() ->
  #{ foldr =>
     fun
       (F) ->
         fun
           (B) ->
             begin
               V =
                 ((erlang:map_get(foldl, foldableList()))
                  (fun
                    (B@1) ->
                      fun
                        (A) ->
                          (F(A))(B@1)
                      end
                  end))
                 (B),
               Go =
                 fun
                   Go (V@1, V1) ->
                     case V1 of
                       {nil} ->
                         V@1;
                       {cons, V1@1, V1@2} ->
                         begin
                           V@2 = {cons, V1@1, V@1},
                           Go(V@2, V1@2)
                         end;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end,
               V@2 =
                 begin
                   V@1 = {nil},
                   fun
                     (V1) ->
                       Go(V@1, V1)
                   end
                 end,
               fun
                 (X) ->
                   V(V@2(X))
               end
             end
         end
     end
   , foldl =>
     fun
       (F) ->
         begin
           Go =
             fun
               Go (B, V) ->
                 case V of
                   {nil} ->
                     B;
                   {cons, V@1, V@2} ->
                     begin
                       B@1 = (F(B))(V@1),
                       Go(B@1, V@2)
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end,
           fun
             (B) ->
               fun
                 (V) ->
                   Go(B, V)
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
                (Acc) ->
                  begin
                    V = (erlang:map_get(append, DictMonoid(undefined)))(Acc),
                    fun
                      (X) ->
                        V(F(X))
                    end
                  end
              end))
             (DictMonoid@1)
         end
     end
   }.

foldableNonEmptyList() ->
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
                 begin
                   Go =
                     fun
                       Go (B@1, V@1) ->
                         case V@1 of
                           {nil} ->
                             B@1;
                           {cons, V@2, V@3} ->
                             begin
                               B@2 = (F(B@1))(V@2),
                               Go(B@2, V@3)
                             end;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end,
                   B@1 = (F(B))(erlang:element(2, V)),
                   V@1 = erlang:element(3, V),
                   Go(B@1, V@1)
                 end
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

foldableWithIndexList() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         fun
           (B) ->
             fun
               (Xs) ->
                 begin
                   Go =
                     fun
                       Go (B@1, V) ->
                         case V of
                           {nil} ->
                             B@1;
                           {cons, V@1, V@2} ->
                             begin
                               B@2 =
                                 { tuple
                                 , (erlang:element(2, B@1)) + 1
                                 , {cons, V@1, erlang:element(3, B@1)}
                                 },
                               Go(B@2, V@2)
                             end;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end,
                   V =
                     begin
                       B@1 = {tuple, 0, {nil}},
                       Go(B@1, Xs)
                     end,
                   Go@1 =
                     fun
                       Go@1 (B@2, V@1) ->
                         case V@1 of
                           {nil} ->
                             B@2;
                           {cons, V@2, V@3} ->
                             begin
                               B@3 =
                                 { tuple
                                 , (erlang:element(2, B@2)) - 1
                                 , ((F((erlang:element(2, B@2)) - 1))(V@2))
                                   (erlang:element(3, B@2))
                                 },
                               Go@1(B@3, V@3)
                             end;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end,
                   erlang:element(
                     3,
                     begin
                       B@2 = {tuple, erlang:element(2, V), B},
                       V@1 = erlang:element(3, V),
                       Go@1(B@2, V@1)
                     end
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
               Go =
                 fun
                   Go (B, V) ->
                     case V of
                       {nil} ->
                         B;
                       {cons, V@1, V@2} ->
                         begin
                           B@1 =
                             { tuple
                             , (erlang:element(2, B)) + 1
                             , ((F(erlang:element(2, B)))(erlang:element(3, B)))
                               (V@1)
                             },
                           Go(B@1, V@2)
                         end;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end,
               V =
                 begin
                   B = {tuple, 0, Acc},
                   fun
                     (V) ->
                       Go(B, V)
                   end
                 end,
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
                   (V)
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
                 (V)
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
                 (V)
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
                      {cons, (F(I))(X), Acc}
                  end
              end
          end))
         ({nil})
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
  , (((erlang:map_get(foldrWithIndex, foldableWithIndexList()))
      (fun
        (I) ->
          fun
            (X) ->
              fun
                (Acc) ->
                  {cons, (F({just, I}))(X), Acc}
              end
          end
      end))
     ({nil}))
    (erlang:element(3, V))
  }.

functorWithIndexNonEmptyList() ->
  #{ mapWithIndex =>
     fun
       (Fn) ->
         fun
           (V) ->
             mapWithIndex(
               fun
                 (X) ->
                   Fn(case X of
                     {nothing} ->
                       0;
                     {just, X@1} ->
                       1 + X@1;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end)
               end,
               V
             )
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorNonEmptyList()
     end
   }.

semigroupList() ->
  #{ append =>
     fun
       (Xs) ->
         fun
           (Ys) ->
             (((erlang:map_get(foldr, foldableList()))('Cons'()))(Ys))(Xs)
         end
     end
   }.

monoidList() ->
  #{ mempty => {nil}
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupList()
     end
   }.

semigroupNonEmptyList() ->
  #{ append =>
     fun
       (V) ->
         fun
           (As_) ->
             { nonEmpty
             , erlang:element(2, V)
             , (((erlang:map_get(foldr, foldableList()))('Cons'()))
                ({cons, erlang:element(2, As_), erlang:element(3, As_)}))
               (erlang:element(3, V))
             }
         end
     end
   }.

showList() ->
  fun
    (DictShow) ->
      showList(DictShow)
  end.

showList(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         case V of
           {nil} ->
             <<"Nil">>;
           _ ->
             begin
               Go =
                 fun
                   Go (B, V@1) ->
                     case V@1 of
                       {nil} ->
                         B;
                       {cons, V@2, V@3} ->
                         begin
                           B@1 =
                             if
                               erlang:map_get(init, B) ->
                                 #{ init => false, acc => V@2 };
                               true ->
                                 #{ init => false
                                  , acc =>
                                    <<
                                      (erlang:map_get(acc, B))/binary,
                                      " : ",
                                      V@2/binary
                                    >>
                                  }
                             end,
                           Go(B@1, V@3)
                         end;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end,
               <<
                 "(",
                 (erlang:map_get(
                    acc,
                    begin
                      B = #{ init => true, acc => <<"">> },
                      V@1 = (listMap(DictShow))(V),
                      Go(B, V@1)
                    end
                  ))/binary,
                 " : Nil)"
               >>
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
           <<
             "(NonEmptyList (NonEmpty ",
             (DictShow@1(erlang:element(2, V@1)))/binary,
             " ",
             (V(erlang:element(3, V@1)))/binary,
             "))"
           >>
       end
     }
  end.

traversableList() ->
  #{ traverse =>
     fun
       (#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
         begin
           Apply0 = #{ 'Functor0' := Apply0@1 } = DictApplicative(undefined),
           fun
             (F) ->
               begin
                 V =
                   (erlang:map_get(map, Apply0@1(undefined)))
                   (begin
                     Go =
                       fun
                         Go (B, V) ->
                           case V of
                             {nil} ->
                               B;
                             {cons, V@1, V@2} ->
                               begin
                                 B@1 = {cons, V@1, B},
                                 Go(B@1, V@2)
                               end;
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                       end,
                     B = {nil},
                     fun
                       (V) ->
                         Go(B, V)
                     end
                   end),
                 Go@1 =
                   fun
                     Go@1 (B@1, V@1) ->
                       case V@1 of
                         {nil} ->
                           B@1;
                         {cons, V@2, V@3} ->
                           begin
                             #{ 'Functor0' := Apply0@2, apply := Apply0@3 } =
                               Apply0,
                             B@2 =
                               (Apply0@3(((erlang:map_get(
                                             map,
                                             Apply0@2(undefined)
                                           ))
                                          (fun
                                            (B@2) ->
                                              fun
                                                (A) ->
                                                  {cons, A, B@2}
                                              end
                                          end))
                                         (B@1)))
                               (F(V@2)),
                             Go@1(B@2, V@3)
                           end;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end,
                 V@1 =
                   begin
                     B@1 = DictApplicative@1({nil}),
                     fun
                       (V@1) ->
                         Go@1(B@1, V@1)
                     end
                   end,
                 fun
                   (X) ->
                     V(V@1(X))
                 end
               end
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

traversableNonEmptyList() ->
  data_nonEmpty@ps:traversableNonEmpty(traversableList()).

traversableWithIndexList() ->
  #{ traverseWithIndex =>
     fun
       (#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }) ->
         begin
           Apply0 = #{ 'Functor0' := Apply0@1 } = DictApplicative(undefined),
           fun
             (F) ->
               begin
                 V =
                   (erlang:map_get(map, Apply0@1(undefined)))
                   (begin
                     Go =
                       fun
                         Go (B, V) ->
                           case V of
                             {nil} ->
                               B;
                             {cons, V@1, V@2} ->
                               begin
                                 B@1 = {cons, V@1, B},
                                 Go(B@1, V@2)
                               end;
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                       end,
                     B = {nil},
                     fun
                       (V) ->
                         Go(B, V)
                     end
                   end),
                 Go@1 =
                   fun
                     Go@1 (B@1, V@1) ->
                       case V@1 of
                         {nil} ->
                           B@1;
                         {cons, V@2, V@3} ->
                           begin
                             #{ 'Functor0' := Apply0@2, apply := Apply0@3 } =
                               Apply0,
                             B@2 =
                               { tuple
                               , (erlang:element(2, B@1)) + 1
                               , (Apply0@3(((erlang:map_get(
                                               map,
                                               Apply0@2(undefined)
                                             ))
                                            (fun
                                              (B@2) ->
                                                fun
                                                  (A) ->
                                                    {cons, A, B@2}
                                                end
                                            end))
                                           (erlang:element(3, B@1))))
                                 ((F(erlang:element(2, B@1)))(V@2))
                               },
                             Go@1(B@2, V@3)
                           end;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end,
                 V@1 =
                   begin
                     B@1 = {tuple, 0, DictApplicative@1({nil})},
                     fun
                       (V@1) ->
                         Go@1(B@1, V@1)
                     end
                   end,
                 fun
                   (X) ->
                     V(erlang:element(3, V@1(X)))
                 end
               end
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
                    ('NonEmptyList'()))
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
                    (V))
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
     fun
       (F) ->
         fun
           (B) ->
             begin
               Go =
                 fun
                   Go (Source, Memo) ->
                     begin
                       V = F(Source),
                       case erlang:element(3, V) of
                         {just, _} ->
                           begin
                             Source@1 = erlang:element(2, erlang:element(3, V)),
                             Memo@1 = {cons, erlang:element(2, V), Memo},
                             Go(Source@1, Memo@1)
                           end;
                         {nothing} ->
                           begin
                             Go@1 =
                               fun
                                 Go@1 (B@1, V@1) ->
                                   case V@1 of
                                     {nil} ->
                                       B@1;
                                     {cons, V@2, V@3} ->
                                       begin
                                         B@2 = {cons, V@2, B@1},
                                         Go@1(B@2, V@3)
                                       end;
                                     _ ->
                                       erlang:error({ fail
                                                    , <<"Failed pattern match">>
                                                    })
                                   end
                               end,
                             B@1 = {nil},
                             V@1 = {cons, erlang:element(2, V), Memo},
                             Go@1(B@1, V@1)
                           end;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end
                 end,
               Memo = {nil},
               Go(B, Memo)
             end
         end
     end
   }.

unfoldableList() ->
  #{ unfoldr =>
     fun
       (F) ->
         fun
           (B) ->
             begin
               Go =
                 fun
                   Go (Source, Memo) ->
                     begin
                       V = F(Source),
                       case V of
                         {nothing} ->
                           begin
                             Go@1 =
                               fun
                                 Go@1 (B@1, V@1) ->
                                   case V@1 of
                                     {nil} ->
                                       B@1;
                                     {cons, V@2, V@3} ->
                                       begin
                                         B@2 = {cons, V@2, B@1},
                                         Go@1(B@2, V@3)
                                       end;
                                     _ ->
                                       erlang:error({ fail
                                                    , <<"Failed pattern match">>
                                                    })
                                   end
                               end,
                             B@1 = {nil},
                             Go@1(B@1, Memo)
                           end;
                         {just, V@1} ->
                           begin
                             Source@1 = erlang:element(3, V@1),
                             Memo@1 = {cons, erlang:element(2, V@1), Memo},
                             Go(Source@1, Memo@1)
                           end;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end
                 end,
               Memo = {nil},
               Go(B, Memo)
             end
         end
     end
   , 'Unfoldable10' =>
     fun
       (_) ->
         unfoldable1List()
     end
   }.

unfoldable1NonEmptyList() ->
  #{ unfoldr1 =>
     fun
       (F) ->
         fun
           (B) ->
             begin
               V = F(B),
               { nonEmpty
               , erlang:element(2, V)
               , begin
                   Go =
                     fun
                       Go (Source, Memo) ->
                         case Source of
                           {just, Source@1} ->
                             begin
                               Source@2 = erlang:element(3, F(Source@1)),
                               Memo@1 =
                                 {cons, erlang:element(2, F(Source@1)), Memo},
                               Go(Source@2, Memo@1)
                             end;
                           _ ->
                             begin
                               Go@1 =
                                 fun
                                   Go@1 (B@1, V@1) ->
                                     case V@1 of
                                       {nil} ->
                                         B@1;
                                       {cons, V@2, V@3} ->
                                         begin
                                           B@2 = {cons, V@2, B@1},
                                           Go@1(B@2, V@3)
                                         end;
                                       _ ->
                                         erlang:error({ fail
                                                      , <<
                                                          "Failed pattern match"
                                                        >>
                                                      })
                                     end
                                 end,
                               B@1 = {nil},
                               Go@1(B@1, Memo)
                             end
                         end
                     end,
                   Source = erlang:element(3, V),
                   Memo = {nil},
                   Go(Source, Memo)
                 end
               }
             end
         end
     end
   }.

foldable1NonEmptyList() ->
  data_nonEmpty@ps:foldable1NonEmpty(foldableList()).

extendNonEmptyList() ->
  #{ extend =>
     fun
       (F) ->
         fun
           (V) ->
             { nonEmpty
             , F(V)
             , erlang:map_get(
                 val,
                 (((erlang:map_get(foldr, foldableList()))
                   (fun
                     (A) ->
                       fun
                         (#{ acc := V1, val := V1@1 }) ->
                           #{ val => {cons, F({nonEmpty, A, V1}), V1@1}
                            , acc => {cons, A, V1}
                            }
                       end
                   end))
                  (#{ val => {nil}, acc => {nil} }))
                 (erlang:element(3, V))
               )
             }
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorNonEmptyList()
     end
   }.

extendList() ->
  #{ extend =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {nil} ->
                 {nil};
               {cons, _, V1@1} ->
                 { cons
                 , V(V1)
                 , erlang:map_get(
                     val,
                     (((erlang:map_get(foldr, foldableList()))
                       (fun
                         (A_) ->
                           fun
                             (#{ acc := V2, val := V2@1 }) ->
                               #{ val => {cons, V({cons, A_, V2}), V2@1}
                                , acc => {cons, A_, V2}
                                }
                           end
                       end))
                      (#{ val => {nil}, acc => {nil} }))
                     (V1@1)
                   )
                 };
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorList()
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
                       Go (V, V1, V2) ->
                         if
                           not V2 ->
                             false;
                           ?IS_KNOWN_TAG(nil, 0, V) ->
                             ?IS_KNOWN_TAG(nil, 0, V1) andalso V2;
                           true ->
                             ?IS_KNOWN_TAG(cons, 2, V)
                               andalso (?IS_KNOWN_TAG(cons, 2, V1)
                                 andalso (begin
                                            V@1 = erlang:element(3, V),
                                            V1@1 = erlang:element(3, V1),
                                            fun
                                              (V2@1) ->
                                                Go(V@1, V1@1, V2@1)
                                            end
                                          end
                                          (V2
                                            andalso (((erlang:map_get(
                                                         eq,
                                                         DictEq
                                                       ))
                                                      (erlang:element(2, V1)))
                                                     (erlang:element(2, V))))))
                         end
                     end,
                   (fun
                     (V2) ->
                       Go(Xs, Ys, V2)
                   end)
                   (true)
                 end
             end
         end
     end
   }.

eq1NonEmptyList() ->
  #{ eq1 =>
     fun
       (#{ eq := DictEq }) ->
         fun
           (X) ->
             fun
               (Y) ->
                 ((DictEq(erlang:element(2, X)))(erlang:element(2, Y)))
                   andalso begin
                     Go =
                       fun
                         Go (V, V1, V2) ->
                           if
                             not V2 ->
                               false;
                             ?IS_KNOWN_TAG(nil, 0, V) ->
                               ?IS_KNOWN_TAG(nil, 0, V1) andalso V2;
                             true ->
                               ?IS_KNOWN_TAG(cons, 2, V)
                                 andalso (?IS_KNOWN_TAG(cons, 2, V1)
                                   andalso (begin
                                              V@1 = erlang:element(3, V),
                                              V1@1 = erlang:element(3, V1),
                                              fun
                                                (V2@1) ->
                                                  Go(V@1, V1@1, V2@1)
                                              end
                                            end
                                            (V2
                                              andalso ((DictEq(erlang:element(
                                                                 2,
                                                                 V1
                                                               )))
                                                       (erlang:element(2, V))))))
                           end
                       end,
                     begin
                       V = erlang:element(3, X),
                       V1 = erlang:element(3, Y),
                       fun
                         (V2) ->
                           Go(V, V1, V2)
                       end
                     end
                     (true)
                   end
             end
         end
     end
   }.

eqList() ->
  fun
    (DictEq) ->
      eqList(DictEq)
  end.

eqList(DictEq) ->
  #{ eq =>
     fun
       (Xs) ->
         fun
           (Ys) ->
             begin
               Go =
                 fun
                   Go (V, V1, V2) ->
                     if
                       not V2 ->
                         false;
                       ?IS_KNOWN_TAG(nil, 0, V) ->
                         ?IS_KNOWN_TAG(nil, 0, V1) andalso V2;
                       true ->
                         ?IS_KNOWN_TAG(cons, 2, V)
                           andalso (?IS_KNOWN_TAG(cons, 2, V1)
                             andalso (begin
                                        V@1 = erlang:element(3, V),
                                        V1@1 = erlang:element(3, V1),
                                        fun
                                          (V2@1) ->
                                            Go(V@1, V1@1, V2@1)
                                        end
                                      end
                                      (V2
                                        andalso (((erlang:map_get(eq, DictEq))
                                                  (erlang:element(2, V1)))
                                                 (erlang:element(2, V))))))
                     end
                 end,
               (fun
                 (V2) ->
                   Go(Xs, Ys, V2)
               end)
               (true)
             end
         end
     end
   }.

eqNonEmptyList() ->
  fun
    (DictEq) ->
      eqNonEmptyList(DictEq)
  end.

eqNonEmptyList(#{ eq := DictEq }) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             ((DictEq(erlang:element(2, X)))(erlang:element(2, Y)))
               andalso begin
                 Go =
                   fun
                     Go (V, V1, V2) ->
                       if
                         not V2 ->
                           false;
                         ?IS_KNOWN_TAG(nil, 0, V) ->
                           ?IS_KNOWN_TAG(nil, 0, V1) andalso V2;
                         true ->
                           ?IS_KNOWN_TAG(cons, 2, V)
                             andalso (?IS_KNOWN_TAG(cons, 2, V1)
                               andalso (begin
                                          V@1 = erlang:element(3, V),
                                          V1@1 = erlang:element(3, V1),
                                          fun
                                            (V2@1) ->
                                              Go(V@1, V1@1, V2@1)
                                          end
                                        end
                                        (V2
                                          andalso ((DictEq(erlang:element(2, V1)))
                                                   (erlang:element(2, V))))))
                       end
                   end,
                 begin
                   V = erlang:element(3, X),
                   V1 = erlang:element(3, Y),
                   fun
                     (V2) ->
                       Go(V, V1, V2)
                   end
                 end
                 (true)
               end
         end
     end
   }.

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
                                             Go(V@2, V1@2)
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
                   Go(Xs, Ys)
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
  data_nonEmpty@ps:ord1NonEmpty(ord1List()).

ordList() ->
  fun
    (DictOrd) ->
      ordList(DictOrd)
  end.

ordList(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    V = DictOrd@1(undefined),
    EqList1 =
      #{ eq =>
         fun
           (Xs) ->
             fun
               (Ys) ->
                 begin
                   Go =
                     fun
                       Go (V@1, V1, V2) ->
                         if
                           not V2 ->
                             false;
                           ?IS_KNOWN_TAG(nil, 0, V@1) ->
                             ?IS_KNOWN_TAG(nil, 0, V1) andalso V2;
                           true ->
                             ?IS_KNOWN_TAG(cons, 2, V@1)
                               andalso (?IS_KNOWN_TAG(cons, 2, V1)
                                 andalso (begin
                                            V@2 = erlang:element(3, V@1),
                                            V1@1 = erlang:element(3, V1),
                                            fun
                                              (V2@1) ->
                                                Go(V@2, V1@1, V2@1)
                                            end
                                          end
                                          (V2
                                            andalso (((erlang:map_get(eq, V))
                                                      (erlang:element(2, V1)))
                                                     (erlang:element(2, V@1))))))
                         end
                     end,
                   (fun
                     (V2) ->
                       Go(Xs, Ys, V2)
                   end)
                   (true)
                 end
             end
         end
       },
    #{ compare =>
       fun
         (Xs) ->
           fun
             (Ys) ->
               begin
                 Go =
                   fun
                     Go (V@1, V1) ->
                       case V@1 of
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
                                 ?IS_KNOWN_TAG(cons, 2, V@1)
                                   andalso ?IS_KNOWN_TAG(cons, 2, V1) ->
                                   begin
                                     {cons, V@2, _} = V@1,
                                     {cons, V1@1, _} = V1,
                                     #{ compare := DictOrd@2 } = DictOrd,
                                     V2 = (DictOrd@2(V@2))(V1@1),
                                     case V2 of
                                       {eQ} ->
                                         begin
                                           {cons, _, V@3} = V@1,
                                           {cons, _, V1@2} = V1,
                                           Go(V@3, V1@2)
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
                 Go(Xs, Ys)
               end
           end
       end
     , 'Eq0' =>
       fun
         (_) ->
           EqList1
       end
     }
  end.

ordNonEmptyList() ->
  fun
    (DictOrd) ->
      ordNonEmptyList(DictOrd)
  end.

ordNonEmptyList(DictOrd) ->
  (ordNonEmpty())(DictOrd).

comonadNonEmptyList() ->
  #{ extract =>
     fun
       (V) ->
         erlang:element(2, V)
     end
   , 'Extend0' =>
     fun
       (_) ->
         extendNonEmptyList()
     end
   }.

applyList() ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {nil} ->
                 {nil};
               {cons, V@1, V@2} ->
                 (((erlang:map_get(foldr, foldableList()))('Cons'()))
                  (((erlang:map_get(apply, applyList()))(V@2))(V1)))
                 ((listMap(V@1))(V1));
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorList()
     end
   }.

applyNonEmptyList() ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             begin
               V@1 = applyList(),
               { nonEmpty
               , (erlang:element(2, V))(erlang:element(2, V1))
               , (((erlang:map_get(foldr, foldableList()))('Cons'()))
                  (((erlang:map_get(apply, V@1))
                    ({cons, erlang:element(2, V), erlang:element(3, V)}))
                   (erlang:element(3, V1))))
                 (((erlang:map_get(apply, V@1))(erlang:element(3, V)))
                  ({cons, erlang:element(2, V1), {nil}}))
               }
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorNonEmptyList()
     end
   }.

bindList() ->
  #{ bind =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {nil} ->
                 {nil};
               {cons, V@1, V@2} ->
                 (((erlang:map_get(foldr, foldableList()))('Cons'()))
                  (((erlang:map_get(bind, bindList()))(V@2))(V1)))
                 (V1(V@1));
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyList()
     end
   }.

bindNonEmptyList() ->
  #{ bind =>
     fun
       (V) ->
         fun
           (F) ->
             begin
               V1 = F(erlang:element(2, V)),
               { nonEmpty
               , erlang:element(2, V1)
               , (((erlang:map_get(foldr, foldableList()))('Cons'()))
                  (((erlang:map_get(bind, bindList()))(erlang:element(3, V)))
                   (fun
                     (X) ->
                       begin
                         V@1 = F(X),
                         {cons, erlang:element(2, V@1), erlang:element(3, V@1)}
                       end
                   end)))
                 (erlang:element(3, V1))
               }
             end
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyNonEmptyList()
     end
   }.

applicativeList() ->
  #{ pure =>
     fun
       (A) ->
         {cons, A, {nil}}
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyList()
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
  #{ empty => {nil}
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
       (X) ->
         {nonEmpty, X, {nil}}
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

traversable1NonEmptyList() ->
  #{ traverse1 =>
     fun
       (DictApply = #{ 'Functor0' := DictApply@1 }) ->
         begin
           #{ map := Functor0 } = DictApply@1(undefined),
           fun
             (F) ->
               fun
                 (V) ->
                   (Functor0(fun
                      (V1) ->
                        begin
                          Go =
                            fun
                              Go (B, V@1) ->
                                case V@1 of
                                  {nil} ->
                                    B;
                                  {cons, V@2, V@3} ->
                                    begin
                                      B@1 =
                                        { nonEmpty
                                        , V@2
                                        , { cons
                                          , erlang:element(2, B)
                                          , erlang:element(3, B)
                                          }
                                        },
                                      Go(B@1, V@3)
                                    end;
                                  _ ->
                                    erlang:error({ fail
                                                 , <<"Failed pattern match">>
                                                 })
                                end
                            end,
                          B = {nonEmpty, erlang:element(2, V1), {nil}},
                          V@1 = erlang:element(3, V1),
                          Go(B, V@1)
                        end
                    end))
                   (begin
                     Go =
                       fun
                         Go (B, V@1) ->
                           case V@1 of
                             {nil} ->
                               B;
                             {cons, V@2, V@3} ->
                               begin
                                 #{ 'Functor0' := DictApply@2
                                  , apply := DictApply@3
                                  } =
                                   DictApply,
                                 B@1 =
                                   (DictApply@3(((erlang:map_get(
                                                    map,
                                                    DictApply@2(undefined)
                                                  ))
                                                 (fun
                                                   (B@1) ->
                                                     fun
                                                       (A) ->
                                                         { nonEmpty
                                                         , A
                                                         , { cons
                                                           , erlang:element(
                                                               2,
                                                               B@1
                                                             )
                                                           , erlang:element(
                                                               3,
                                                               B@1
                                                             )
                                                           }
                                                         }
                                                     end
                                                 end))
                                                (B)))
                                   (F(V@2)),
                                 Go(B@1, V@3)
                               end;
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                       end,
                     B =
                       (Functor0(erlang:map_get(pure, applicativeNonEmptyList())))
                       (F(erlang:element(2, V))),
                     V@1 = erlang:element(3, V),
                     Go(B, V@1)
                   end)
               end
           end
         end
     end
   , sequence1 =>
     fun
       (DictApply) ->
         ((erlang:map_get(traverse1, traversable1NonEmptyList()))(DictApply))
         (identity())
     end
   , 'Foldable10' =>
     fun
       (_) ->
         foldable1NonEmptyList()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         traversableNonEmptyList()
     end
   }.

