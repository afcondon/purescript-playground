-module(erl_data_list_types@ps).
-export([ identity/0
        , identity/1
        , 'NonEmptyList'/0
        , 'NonEmptyList'/1
        , uncons/0
        , toList/0
        , toList/1
        , semigroupList/0
        , semigroupNonEmptyList/0
        , newtypeNonEmptyList/0
        , nelCons/0
        , nelCons/2
        , monoidList/0
        , functorList/0
        , functorNonEmptyList/0
        , foldableList/0
        , intercalate/0
        , intercalate/2
        , foldableNonEmptyList/0
        , functorWithIndexList/0
        , mapWithIndex1/0
        , mapWithIndex1/2
        , foldableWithIndexList/0
        , foldableWithIndexNonEmpty/0
        , foldableWithIndexNonEmptyList/0
        , functorWithIndexNonEmptyList/0
        , mapMaybe/0
        , mapMaybe/1
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
        , eq1List/0
        , eqNonEmpty/0
        , eqNonEmpty/1
        , eqList/0
        , eqList/1
        , eqNonEmptyList/0
        , eqNonEmptyList/1
        , ord1List/0
        , ordNonEmpty/0
        , ordList/0
        , ordList/1
        , ordNonEmptyList/0
        , ordNonEmptyList/1
        , compactableList/0
        , filterableList/0
        , witherableList/0
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
        , applicativeNonEmptyList/0
        , monadNonEmptyList/0
        , traversable1NonEmptyList/0
        , nil/0
        , cons/0
        , unconsImpl/0
        , null/0
        , filter/0
        , mapImpl/0
        , appendImpl/0
        , foldlImpl/0
        , foldrImpl/0
        , uncons/1
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

'NonEmptyList'() ->
  fun
    (X) ->
      'NonEmptyList'(X)
  end.

'NonEmptyList'(X) ->
  X.

uncons() ->
  ((unconsImpl())(data_maybe@ps:'Just'()))({nothing}).

toList() ->
  fun
    (V) ->
      toList(V)
  end.

toList(V) ->
  [ erlang:element(2, V) | erlang:element(3, V) ].

semigroupList() ->
  #{ append => appendImpl() }.

semigroupNonEmptyList() ->
  #{ append =>
     fun
       (V) ->
         fun
           (As_) ->
             { nonEmpty
             , erlang:element(2, V)
             , (erlang:element(3, V))
                 ++ [ erlang:element(2, As_) | erlang:element(3, As_) ]
             }
         end
     end
   }.

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
  {nonEmpty, A, [ erlang:element(2, V) | erlang:element(3, V) ]}.

monoidList() ->
  #{ mempty => []
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupList()
     end
   }.

functorList() ->
  #{ map => mapImpl() }.

functorNonEmptyList() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             { nonEmpty
             , F(erlang:element(2, M))
             , lists:map(F, erlang:element(3, M))
             }
         end
     end
   }.

foldableList() ->
  #{ foldr => foldrImpl()
   , foldl => foldlImpl()
   , foldMap =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         fun
           (F) ->
             ((erlang:map_get(foldr, foldableList()))
              (fun
                (X) ->
                  fun
                    (Acc) ->
                      ((erlang:map_get(append, DictMonoid(undefined)))(F(X)))
                      (Acc)
                  end
              end))
             (DictMonoid@1)
         end
     end
   }.

intercalate() ->
  fun
    (Sep) ->
      fun
        (Xs) ->
          intercalate(Sep, Xs)
      end
  end.

intercalate(Sep, Xs) ->
  erlang:map_get(
    acc,
    erl_data_list_types@foreign:foldlImpl(
      fun
        (V) ->
          fun
            (V1) ->
              if
                erlang:map_get(init, V) ->
                  #{ init => false, acc => V1 };
                true ->
                  #{ init => false
                   , acc =>
                     <<(erlang:map_get(acc, V))/binary, Sep/binary, V1/binary>>
                   }
              end
          end
      end,
      #{ init => true, acc => <<"">> },
      Xs
    )
  ).

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
                 erl_data_list_types@foreign:foldlImpl(
                   F,
                   (F(B))(erlang:element(2, V)),
                   erlang:element(3, V)
                 )
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
                 (erl_data_list_types@foreign:foldrImpl(
                    F,
                    B,
                    erlang:element(3, V)
                  ))
             end
         end
     end
   }.

functorWithIndexList() ->
  #{ mapWithIndex =>
     fun
       (F) ->
         fun
           (Lst) ->
             begin
               Go =
                 fun
                   Go (N, L, Acc) ->
                     begin
                       V = uncons(L),
                       case V of
                         {nothing} ->
                           Acc;
                         {just, #{ head := V@1, tail := V@2 }} ->
                           begin
                             N@1 = N + 1,
                             fun
                               (Acc@1) ->
                                 Go(N@1, V@2, Acc@1)
                             end
                           end
                           ([ (F(N))(V@1) | Acc ]);
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end
                 end,
               erl_data_list_types@foreign:foldlImpl(
                 fun
                   (B) ->
                     fun
                       (A) ->
                         [ A | B ]
                     end
                 end,
                 [],
                 begin
                   N = 0,
                   fun
                     (Acc) ->
                       Go(N, Lst, Acc)
                   end
                 end
                 ([])
               )
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorList()
     end
   }.

mapWithIndex1() ->
  fun
    (F) ->
      fun
        (V) ->
          mapWithIndex1(F, V)
      end
  end.

mapWithIndex1(F, V) ->
  { nonEmpty
  , (F({nothing}))(erlang:element(2, V))
  , ((erlang:map_get(mapWithIndex, functorWithIndexList()))
     (fun
       (X) ->
         F({just, X})
     end))
    (erlang:element(3, V))
  }.

foldableWithIndexList() ->
  #{ foldrWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (Lst) ->
                 erl_data_list_types@foreign:foldrImpl(
                   fun
                     (V) ->
                       begin
                         V@1 = erlang:element(2, V),
                         V@2 = erlang:element(3, V),
                         fun
                           (Y) ->
                             ((F(V@1))(V@2))(Y)
                         end
                       end
                   end,
                   Z,
                   ((erlang:map_get(mapWithIndex, functorWithIndexList()))
                    (data_tuple@ps:'Tuple'()))
                   (Lst)
                 )
             end
         end
     end
   , foldlWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (Lst) ->
                 erl_data_list_types@foreign:foldlImpl(
                   fun
                     (Y) ->
                       fun
                         (V) ->
                           ((F(erlang:element(2, V)))(Y))(erlang:element(3, V))
                       end
                   end,
                   Z,
                   ((erlang:map_get(mapWithIndex, functorWithIndexList()))
                    (data_tuple@ps:'Tuple'()))
                   (Lst)
                 )
             end
         end
     end
   , foldMapWithIndex =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         fun
           (F) ->
             ((erlang:map_get(foldrWithIndex, foldableWithIndexList()))
              (fun
                (I) ->
                  fun
                    (X) ->
                      fun
                        (Acc) ->
                          ((erlang:map_get(append, DictMonoid(undefined)))
                           ((F(I))(X)))
                          (Acc)
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

functorWithIndexNonEmptyList() ->
  #{ mapWithIndex =>
     fun
       (Fn) ->
         fun
           (V) ->
             mapWithIndex1(
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

mapMaybe() ->
  fun
    (F) ->
      mapMaybe(F)
  end.

mapMaybe(F) ->
  begin
    Go =
      fun
        Go (Acc, L) ->
          begin
            V = uncons(L),
            case V of
              {nothing} ->
                erl_data_list_types@foreign:foldlImpl(
                  fun
                    (B) ->
                      fun
                        (A) ->
                          [ A | B ]
                      end
                  end,
                  [],
                  Acc
                );
              {just, #{ head := V@1, tail := V@2 }} ->
                begin
                  V1 = F(V@1),
                  case V1 of
                    {nothing} ->
                      Go(Acc, V@2);
                    {just, V1@1} ->
                      begin
                        Acc@1 = [ V1@1 | Acc ],
                        Go(Acc@1, V@2)
                      end;
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
                end;
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
          end
      end,
    Acc = [],
    fun
      (L) ->
        Go(Acc, L)
    end
  end.

showList() ->
  fun
    (DictShow) ->
      showList(DictShow)
  end.

showList(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         if
           [] =:= V ->
             <<"nil">>;
           true ->
             <<
               "(",
               (intercalate(<<" : ">>, lists:map(DictShow, V)))/binary,
               " : nil)"
             >>
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
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           Apply0 = DictApplicative@1(undefined),
           fun
             (F) ->
               fun
                 (Lst) ->
                   begin
                     V = uncons(Lst),
                     case V of
                       {nothing} ->
                         begin
                           #{ pure := DictApplicative@2 } = DictApplicative,
                           DictApplicative@2([])
                         end;
                       {just, #{ head := V@1, tail := V@2 }} ->
                         begin
                           #{ 'Functor0' := Apply0@1, apply := Apply0@2 } =
                             Apply0,
                           (Apply0@2(((erlang:map_get(map, Apply0@1(undefined)))
                                      (cons()))
                                     (F(V@1))))
                           ((((erlang:map_get(traverse, traversableList()))
                              (DictApplicative))
                             (F))
                            (V@2))
                         end;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                   end
               end
           end
         end
     end
   , sequence =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           Apply0 = DictApplicative@1(undefined),
           fun
             (Lst) ->
               begin
                 V = uncons(Lst),
                 case V of
                   {nothing} ->
                     begin
                       #{ pure := DictApplicative@2 } = DictApplicative,
                       DictApplicative@2([])
                     end;
                   {just, #{ head := V@1, tail := V@2 }} ->
                     begin
                       #{ 'Functor0' := Apply0@1, apply := Apply0@2 } = Apply0,
                       (Apply0@2(((erlang:map_get(map, Apply0@1(undefined)))
                                  (cons()))
                                 (V@1)))
                       (((erlang:map_get(sequence, traversableList()))
                         (DictApplicative))
                        (V@2))
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
               end
           end
         end
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
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           Apply0 = DictApplicative@1(undefined),
           fun
             (F_) ->
               fun
                 (Lst_) ->
                   begin
                     TraverseWithIndexImpl =
                       fun
                         TraverseWithIndexImpl (F, Lst, I) ->
                           begin
                             V = uncons(Lst),
                             case V of
                               {nothing} ->
                                 begin
                                   #{ pure := DictApplicative@2 } =
                                     DictApplicative,
                                   DictApplicative@2([])
                                 end;
                               {just, #{ head := V@1, tail := V@2 }} ->
                                 begin
                                   #{ 'Functor0' := Apply0@1
                                    , apply := Apply0@2
                                    } =
                                     Apply0,
                                   (Apply0@2(((erlang:map_get(
                                                 map,
                                                 Apply0@1(undefined)
                                               ))
                                              (cons()))
                                             ((F(I))(V@1))))
                                   ((fun
                                      (I@1) ->
                                        TraverseWithIndexImpl(F, V@2, I@1)
                                    end)
                                    (I + 1))
                                 end;
                               _ ->
                                 erlang:error({fail, <<"Failed pattern match">>})
                             end
                           end
                       end,
                     (fun
                       (I) ->
                         TraverseWithIndexImpl(F_, Lst_, I)
                     end)
                     (0)
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
                         {nothing} ->
                           erl_data_list_types@foreign:foldlImpl(
                             fun
                               (B@1) ->
                                 fun
                                   (A) ->
                                     [ A | B@1 ]
                                 end
                             end,
                             [],
                             [ erlang:element(2, V) | Memo ]
                           );
                         {just, _} ->
                           begin
                             Source@1 = erlang:element(2, erlang:element(3, V)),
                             Memo@1 = [ erlang:element(2, V) | Memo ],
                             Go(Source@1, Memo@1)
                           end;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end
                 end,
               Memo = [],
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
                           erl_data_list_types@foreign:foldlImpl(
                             fun
                               (B@1) ->
                                 fun
                                   (A) ->
                                     [ A | B@1 ]
                                 end
                             end,
                             [],
                             Memo
                           );
                         {just, V@1} ->
                           begin
                             Source@1 = erlang:element(3, V@1),
                             Memo@1 = [ erlang:element(2, V@1) | Memo ],
                             Go(Source@1, Memo@1)
                           end;
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end
                 end,
               Memo = [],
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
                 erl_data_list_types@foreign:foldrImpl(
                   fun
                     (A) ->
                       fun
                         (#{ acc := V1, val := V1@1 }) ->
                           #{ val => [ F({nonEmpty, A, V1}) | V1@1 ]
                            , acc => [ A | V1 ]
                            }
                       end
                   end,
                   #{ val => [], acc => [] },
                   erlang:element(3, V)
                 )
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
                           true ->
                             begin
                               V3 = uncons(V1),
                               V4 = uncons(V),
                               case V4 of
                                 {nothing} ->
                                   ?IS_KNOWN_TAG(nothing, 0, V3) andalso V2;
                                 _ ->
                                   ?IS_KNOWN_TAG(just, 1, V4)
                                     andalso (?IS_KNOWN_TAG(just, 1, V3)
                                       andalso (begin
                                                  V@1 =
                                                    erlang:map_get(
                                                      tail,
                                                      erlang:element(2, V4)
                                                    ),
                                                  V1@1 =
                                                    erlang:map_get(
                                                      tail,
                                                      erlang:element(2, V3)
                                                    ),
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
                                                            (erlang:map_get(
                                                               head,
                                                               erlang:element(
                                                                 2,
                                                                 V3
                                                               )
                                                             )))
                                                           (erlang:map_get(
                                                              head,
                                                              erlang:element(
                                                                2,
                                                                V4
                                                              )
                                                            ))))))
                               end
                             end
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
  eqNonEmpty(DictEq).

ord1List() ->
  #{ compare1 =>
     fun
       (DictOrd) ->
         fun
           (Xs) ->
             fun
               (Ys) ->
                 begin
                   V = uncons(Ys),
                   V1 = uncons(Xs),
                   case V1 of
                     {nothing} ->
                       case V of
                         {nothing} ->
                           {eQ};
                         _ ->
                           {lT}
                       end;
                     _ ->
                       case V of
                         {nothing} ->
                           {gT};
                         _ ->
                           if
                             ?IS_KNOWN_TAG(just, 1, V1)
                               andalso ?IS_KNOWN_TAG(just, 1, V) ->
                               begin
                                 {just, #{ head := V@1 }} = V,
                                 {just, #{ head := V1@1 }} = V1,
                                 #{ compare := DictOrd@1 } = DictOrd,
                                 V2 = (DictOrd@1(V1@1))(V@1),
                                 case V2 of
                                   {eQ} ->
                                     begin
                                       {just, #{ tail := V@2 }} = V,
                                       {just, #{ tail := V1@2 }} = V1,
                                       (((erlang:map_get(compare1, ord1List()))
                                         (DictOrd))
                                        (V1@2))
                                       (V@2)
                                     end;
                                   _ ->
                                     V2
                                 end
                               end;
                             true ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                       end
                   end
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
  (ordNonEmpty())(DictOrd).

compactableList() ->
  #{ compact => mapMaybe(identity())
   , separate =>
     fun
       (Xs) ->
         data_compactable@ps:separateDefault(
           functorList(),
           compactableList(),
           Xs
         )
     end
   }.

filterableList() ->
  #{ partitionMap =>
     fun
       (P) ->
         fun
           (Xs) ->
             erl_data_list_types@foreign:foldrImpl(
               fun
                 (X) ->
                   fun
                     (#{ left := V, right := V@1 }) ->
                       begin
                         V1 = P(X),
                         case V1 of
                           {left, V1@1} ->
                             #{ left => [ V1@1 | V ], right => V@1 };
                           {right, V1@2} ->
                             #{ left => V, right => [ V1@2 | V@1 ] };
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                       end
                   end
               end,
               #{ left => [], right => [] },
               Xs
             )
         end
     end
   , partition =>
     fun
       (P) ->
         fun
           (Xs) ->
             erl_data_list_types@foreign:foldrImpl(
               fun
                 (X) ->
                   fun
                     (#{ no := V, yes := V@1 }) ->
                       case P(X) of
                         true ->
                           #{ no => V, yes => [ X | V@1 ] };
                         _ ->
                           #{ no => [ X | V ], yes => V@1 }
                       end
                   end
               end,
               #{ no => [], yes => [] },
               Xs
             )
         end
     end
   , filterMap => mapMaybe()
   , filter => filter()
   , 'Compactable0' =>
     fun
       (_) ->
         compactableList()
     end
   , 'Functor1' =>
     fun
       (_) ->
         functorList()
     end
   }.

witherableList() ->
  #{ wilt =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           V = witherableList(),
           Separate =
             erlang:map_get(
               separate,
               (erlang:map_get(
                  'Compactable0',
                  (erlang:map_get('Filterable0', V))(undefined)
                ))
               (undefined)
             ),
           Traverse1 =
             (erlang:map_get(
                traverse,
                (erlang:map_get('Traversable1', V))(undefined)
              ))
             (DictApplicative),
           fun
             (P) ->
               begin
                 V@1 =
                   (erlang:map_get(
                      map,
                      (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                      (undefined)
                    ))
                   (Separate),
                 V@2 = Traverse1(P),
                 fun
                   (X) ->
                     V@1(V@2(X))
                 end
               end
           end
         end
     end
   , wither =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           V = witherableList(),
           Compact =
             erlang:map_get(
               compact,
               (erlang:map_get(
                  'Compactable0',
                  (erlang:map_get('Filterable0', V))(undefined)
                ))
               (undefined)
             ),
           Traverse1 =
             (erlang:map_get(
                traverse,
                (erlang:map_get('Traversable1', V))(undefined)
              ))
             (DictApplicative),
           fun
             (P) ->
               begin
                 V@1 =
                   (erlang:map_get(
                      map,
                      (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                      (undefined)
                    ))
                   (Compact),
                 V@2 = Traverse1(P),
                 fun
                   (X) ->
                     V@1(V@2(X))
                 end
               end
           end
         end
     end
   , 'Filterable0' =>
     fun
       (_) ->
         filterableList()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         traversableList()
     end
   }.

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
       (List) ->
         fun
           (Xs) ->
             begin
               V = uncons(List),
               case V of
                 {nothing} ->
                   [];
                 {just, #{ head := V@1, tail := V@2 }} ->
                   (lists:map(V@1, Xs))
                     ++ (((erlang:map_get(apply, applyList()))(V@2))(Xs));
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
               , (((erlang:map_get(apply, V@1))(erlang:element(3, V)))
                  ([erlang:element(2, V1)]))
                   ++ (((erlang:map_get(apply, V@1))
                        ([ erlang:element(2, V) | erlang:element(3, V) ]))
                       (erlang:element(3, V1)))
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
       (L) ->
         fun
           (F) ->
             begin
               V = uncons(L),
               case V of
                 {nothing} ->
                   [];
                 {just, #{ head := V@1, tail := V@2 }} ->
                   (F(V@1)) ++ (((erlang:map_get(bind, bindList()))(V@2))(F));
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
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
               , (erlang:element(3, V1))
                   ++ (((erlang:map_get(bind, bindList()))
                        (erlang:element(3, V)))
                       (fun
                         (X) ->
                           begin
                             V@1 = F(X),
                             [ erlang:element(2, V@1) | erlang:element(3, V@1) ]
                           end
                       end))
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
         [A]
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
  #{ alt => appendImpl()
   , 'Functor0' =>
     fun
       (_) ->
         functorList()
     end
   }.

plusList() ->
  #{ empty => []
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

applicativeNonEmptyList() ->
  #{ pure =>
     fun
       (X) ->
         {nonEmpty, X, []}
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
       (#{ 'Functor0' := DictApply, apply := DictApply@1 }) ->
         begin
           #{ map := Functor0 } = DictApply(undefined),
           fun
             (F) ->
               fun
                 (V) ->
                   (Functor0(fun
                      (V1) ->
                        erl_data_list_types@foreign:foldlImpl(
                          fun
                            (B) ->
                              fun
                                (A) ->
                                  { nonEmpty
                                  , A
                                  , [ erlang:element(2, B)
                                    | erlang:element(3, B)
                                    ]
                                  }
                              end
                          end,
                          {nonEmpty, erlang:element(2, V1), []},
                          erlang:element(3, V1)
                        )
                    end))
                   (erl_data_list_types@foreign:foldlImpl(
                      fun
                        (Acc) ->
                          fun
                            (X) ->
                              (DictApply@1(((erlang:map_get(
                                               map,
                                               DictApply(undefined)
                                             ))
                                            (fun
                                              (B) ->
                                                fun
                                                  (A) ->
                                                    { nonEmpty
                                                    , A
                                                    , [ erlang:element(2, B)
                                                      | erlang:element(3, B)
                                                      ]
                                                    }
                                                end
                                            end))
                                           (Acc)))
                              (F(X))
                          end
                      end,
                      (Functor0(erlang:map_get(pure, applicativeNonEmptyList())))
                      (F(erlang:element(2, V))),
                      erlang:element(3, V)
                    ))
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

nil() ->
  erl_data_list_types@foreign:nil().

cons() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_list_types@foreign:cons(V, V@1)
      end
  end.

unconsImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              erl_data_list_types@foreign:unconsImpl(V, V@1, V@2)
          end
      end
  end.

null() ->
  fun
    (V) ->
      erl_data_list_types@foreign:null(V)
  end.

filter() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_list_types@foreign:filter(V, V@1)
      end
  end.

mapImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_list_types@foreign:mapImpl(V, V@1)
      end
  end.

appendImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_list_types@foreign:appendImpl(V, V@1)
      end
  end.

foldlImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              erl_data_list_types@foreign:foldlImpl(V, V@1, V@2)
          end
      end
  end.

foldrImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              erl_data_list_types@foreign:foldrImpl(V, V@1, V@2)
          end
      end
  end.

uncons(V) ->
  erl_data_list_types@foreign:unconsImpl(data_maybe@ps:'Just'(), {nothing}, V).

