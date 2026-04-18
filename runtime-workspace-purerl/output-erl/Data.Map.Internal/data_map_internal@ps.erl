-module(data_map_internal@ps).
-export([ all/0
        , identity/0
        , identity/1
        , nub/0
        , 'Leaf'/0
        , 'Two'/0
        , 'Three'/0
        , 'TwoLeft'/0
        , 'TwoRight'/0
        , 'ThreeLeft'/0
        , 'ThreeMiddle'/0
        , 'ThreeRight'/0
        , 'KickUp'/0
        , values/0
        , values/1
        , size/0
        , size/1
        , singleton/0
        , singleton/2
        , toUnfoldable/0
        , toUnfoldable/2
        , toUnfoldableUnordered/0
        , toUnfoldableUnordered/2
        , showTree/0
        , showTree/3
        , showMap/0
        , showMap/2
        , lookupLE/0
        , lookupLE/2
        , lookupGE/0
        , lookupGE/2
        , lookup/0
        , lookup/2
        , member/0
        , member/3
        , keys/0
        , keys/1
        , isSubmap/0
        , isSubmap/4
        , isEmpty/0
        , isEmpty/1
        , functorMap/0
        , functorWithIndexMap/0
        , fromZipper/0
        , fromZipper/3
        , insert/0
        , insert/3
        , pop/0
        , pop/2
        , foldableMap/0
        , traversableMap/0
        , foldSubmapBy/0
        , foldSubmapBy/6
        , foldSubmap/0
        , foldSubmap/2
        , 'findMin.go'/0
        , 'findMin.go'/2
        , findMin/0
        , lookupGT/0
        , lookupGT/2
        , 'findMax.go'/0
        , 'findMax.go'/2
        , findMax/0
        , lookupLT/0
        , lookupLT/2
        , eqMap/0
        , eqMap/2
        , ordMap/0
        , ordMap/1
        , eq1Map/0
        , eq1Map/1
        , ord1Map/0
        , ord1Map/1
        , empty/0
        , fromFoldable/0
        , fromFoldable/2
        , filterWithKey/0
        , filterWithKey/1
        , filter/0
        , filter/1
        , filterKeys/0
        , filterKeys/1
        , fromFoldableWithIndex/0
        , fromFoldableWithIndex/2
        , intersectionWith/0
        , intersectionWith/4
        , intersection/0
        , intersection/1
        , delete/0
        , delete/3
        , difference/0
        , difference/3
        , checkValid/0
        , checkValid/1
        , foldableWithIndexMap/0
        , mapMaybeWithKey/0
        , mapMaybeWithKey/2
        , mapMaybe/0
        , mapMaybe/2
        , catMaybes/0
        , catMaybes/1
        , traversableWithIndexMap/0
        , applyMap/0
        , applyMap/1
        , bindMap/0
        , bindMap/1
        , alter/0
        , alter/4
        , fromFoldableWith/0
        , fromFoldableWith/3
        , insertWith/0
        , insertWith/4
        , unionWith/0
        , unionWith/4
        , union/0
        , union/1
        , submap/0
        , submap/3
        , unions/0
        , unions/2
        , update/0
        , update/4
        , altMap/0
        , altMap/1
        , plusMap/0
        , plusMap/1
        , findMin/1
        , findMax/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
all() ->
  (erlang:map_get(foldMap, data_list_lazy_types@ps:foldableList()))
  (begin
    SemigroupConj1 =
      #{ append =>
         fun
           (V) ->
             fun
               (V1) ->
                 V andalso V1
             end
         end
       },
    #{ mempty => true
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupConj1
       end
     }
  end).

identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

nub() ->
  data_list@ps:nubBy(erlang:map_get(compare, data_ord@ps:ordInt())).

'Leaf'() ->
  {leaf}.

'Two'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  {two, Value0, Value1, Value2, Value3}
              end
          end
      end
  end.

'Three'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  fun
                    (Value4) ->
                      fun
                        (Value5) ->
                          fun
                            (Value6) ->
                              { three
                              , Value0
                              , Value1
                              , Value2
                              , Value3
                              , Value4
                              , Value5
                              , Value6
                              }
                          end
                      end
                  end
              end
          end
      end
  end.

'TwoLeft'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              {twoLeft, Value0, Value1, Value2}
          end
      end
  end.

'TwoRight'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              {twoRight, Value0, Value1, Value2}
          end
      end
  end.

'ThreeLeft'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  fun
                    (Value4) ->
                      fun
                        (Value5) ->
                          { threeLeft
                          , Value0
                          , Value1
                          , Value2
                          , Value3
                          , Value4
                          , Value5
                          }
                      end
                  end
              end
          end
      end
  end.

'ThreeMiddle'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  fun
                    (Value4) ->
                      fun
                        (Value5) ->
                          { threeMiddle
                          , Value0
                          , Value1
                          , Value2
                          , Value3
                          , Value4
                          , Value5
                          }
                      end
                  end
              end
          end
      end
  end.

'ThreeRight'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  fun
                    (Value4) ->
                      fun
                        (Value5) ->
                          { threeRight
                          , Value0
                          , Value1
                          , Value2
                          , Value3
                          , Value4
                          , Value5
                          }
                      end
                  end
              end
          end
      end
  end.

'KickUp'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  {kickUp, Value0, Value1, Value2, Value3}
              end
          end
      end
  end.

values() ->
  fun
    (V) ->
      values(V)
  end.

values(V) ->
  case V of
    {leaf} ->
      {nil};
    {two, V@1, _, V@2, V@3} ->
      (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
        (data_list_types@ps:'Cons'()))
       ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
          (data_list_types@ps:'Cons'()))
         (values(V@3)))
        ({cons, V@2, {nil}})))
      (values(V@1));
    {three, V@4, _, V@5, V@6, _, V@7, V@8} ->
      (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
        (data_list_types@ps:'Cons'()))
       ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
          (data_list_types@ps:'Cons'()))
         ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
            (data_list_types@ps:'Cons'()))
           ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
              (data_list_types@ps:'Cons'()))
             (values(V@8)))
            ({cons, V@7, {nil}})))
          (values(V@6))))
        ({cons, V@5, {nil}})))
      (values(V@4));
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

size() ->
  fun
    (V) ->
      size(V)
  end.

size(V) ->
  case V of
    {leaf} ->
      0;
    {two, V@1, _, _, V@2} ->
      (1 + (size(V@1))) + (size(V@2));
    {three, V@3, _, _, V@4, _, _, V@5} ->
      ((2 + (size(V@3))) + (size(V@4))) + (size(V@5));
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

singleton() ->
  fun
    (K) ->
      fun
        (V) ->
          singleton(K, V)
      end
  end.

singleton(K, V) ->
  {two, {leaf}, K, V, {leaf}}.

toUnfoldable() ->
  fun
    (DictUnfoldable) ->
      fun
        (M) ->
          toUnfoldable(DictUnfoldable, M)
      end
  end.

toUnfoldable(#{ unfoldr := DictUnfoldable }, M) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {nil} ->
              {nothing};
            {cons, V@1, V@2} ->
              case V@1 of
                {leaf} ->
                  Go(V@2);
                {two, V@3, V@4, V@5, V@6} ->
                  case V@3 of
                    {leaf} ->
                      case V@6 of
                        {leaf} ->
                          {just, {tuple, {tuple, V@4, V@5}, V@2}};
                        _ ->
                          {just, {tuple, {tuple, V@4, V@5}, {cons, V@6, V@2}}}
                      end;
                    _ ->
                      Go({ cons
                         , V@3
                         , { cons
                           , {two, {leaf}, V@4, V@5, {leaf}}
                           , {cons, V@6, V@2}
                           }
                         })
                  end;
                {three, V@7, V@8, V@9, V@10, V@11, V@12, V@13} ->
                  Go({ cons
                     , V@7
                     , { cons
                       , {two, {leaf}, V@8, V@9, {leaf}}
                       , { cons
                         , V@10
                         , { cons
                           , {two, {leaf}, V@11, V@12, {leaf}}
                           , {cons, V@13, V@2}
                           }
                         }
                       }
                     });
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    (DictUnfoldable(Go))({cons, M, {nil}})
  end.

toUnfoldableUnordered() ->
  fun
    (DictUnfoldable) ->
      fun
        (M) ->
          toUnfoldableUnordered(DictUnfoldable, M)
      end
  end.

toUnfoldableUnordered(#{ unfoldr := DictUnfoldable }, M) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {nil} ->
              {nothing};
            {cons, V@1, V@2} ->
              case V@1 of
                {leaf} ->
                  Go(V@2);
                {two, V@3, V@4, V@5, V@6} ->
                  { just
                  , {tuple, {tuple, V@4, V@5}, {cons, V@3, {cons, V@6, V@2}}}
                  };
                {three, V@7, V@8, V@9, V@10, V@11, V@12, V@13} ->
                  { just
                  , { tuple
                    , {tuple, V@8, V@9}
                    , { cons
                      , {two, {leaf}, V@11, V@12, {leaf}}
                      , {cons, V@7, {cons, V@10, {cons, V@13, V@2}}}
                      }
                    }
                  };
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    (DictUnfoldable(Go))({cons, M, {nil}})
  end.

showTree() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          fun
            (V) ->
              showTree(DictShow, DictShow1, V)
          end
      end
  end.

showTree(DictShow, DictShow1, V) ->
  case V of
    {leaf} ->
      <<"Leaf">>;
    {two, V@1, V@2, V@3, V@4} ->
      begin
        #{ show := DictShow1@1 } = DictShow1,
        #{ show := DictShow@1 } = DictShow,
        <<
          "Two (",
          (showTree(DictShow, DictShow1, V@1))/binary,
          ") (",
          (DictShow@1(V@2))/binary,
          ") (",
          (DictShow1@1(V@3))/binary,
          ") (",
          (showTree(DictShow, DictShow1, V@4))/binary,
          ")"
        >>
      end;
    {three, V@5, V@6, V@7, V@8, V@9, V@10, V@11} ->
      begin
        #{ show := DictShow1@2 } = DictShow1,
        #{ show := DictShow@2 } = DictShow,
        <<
          "Three (",
          (showTree(DictShow, DictShow1, V@5))/binary,
          ") (",
          (DictShow@2(V@6))/binary,
          ") (",
          (DictShow1@2(V@7))/binary,
          ") (",
          (showTree(DictShow, DictShow1, V@8))/binary,
          ") (",
          (DictShow@2(V@9))/binary,
          ") (",
          (DictShow1@2(V@10))/binary,
          ") (",
          (showTree(DictShow, DictShow1, V@11))/binary,
          ")"
        >>
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

showMap() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showMap(DictShow, DictShow1)
      end
  end.

showMap(#{ show := DictShow }, #{ show := DictShow1 }) ->
  begin
    Show =
      (data_show@ps:showArrayImpl())
      (fun
        (V) ->
          <<
            "(Tuple ",
            (DictShow(erlang:element(2, V)))/binary,
            " ",
            (DictShow1(erlang:element(3, V)))/binary,
            ")"
          >>
      end),
    #{ show =>
       fun
         (M) ->
           <<
             "(fromFoldable ",
             (Show(toUnfoldable(data_unfoldable@ps:unfoldableArray(), M)))/binary,
             ")"
           >>
       end
     }
  end.

lookupLE() ->
  fun
    (DictOrd) ->
      fun
        (K) ->
          lookupLE(DictOrd, K)
      end
  end.

lookupLE(DictOrd, K) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {leaf} ->
              {nothing};
            {two, _, V@1, _, _} ->
              begin
                #{ compare := DictOrd@1 } = DictOrd,
                V2 = (DictOrd@1(K))(V@1),
                case V2 of
                  {eQ} ->
                    {just, #{ key => V@1, value => erlang:element(4, V) }};
                  {gT} ->
                    { just
                    , begin
                        V@2 = Go(erlang:element(5, V)),
                        case V@2 of
                          {nothing} ->
                            begin
                              {two, _, V@3, V@4, _} = V,
                              #{ key => V@3, value => V@4 }
                            end;
                          {just, V@5} ->
                            V@5;
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end
                    };
                  {lT} ->
                    Go(erlang:element(2, V));
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            {three, _, _, _, _, V@6, _, _} ->
              begin
                #{ compare := DictOrd@2 } = DictOrd,
                V3 = (DictOrd@2(K))(V@6),
                case V3 of
                  {eQ} ->
                    {just, #{ key => V@6, value => erlang:element(7, V) }};
                  {gT} ->
                    { just
                    , begin
                        V@7 = Go(erlang:element(8, V)),
                        case V@7 of
                          {nothing} ->
                            begin
                              {three, _, _, _, _, V@8, V@9, _} = V,
                              #{ key => V@8, value => V@9 }
                            end;
                          {just, V@10} ->
                            V@10;
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end
                    };
                  {lT} ->
                    Go({ two
                       , erlang:element(2, V)
                       , erlang:element(3, V)
                       , erlang:element(4, V)
                       , erlang:element(5, V)
                       });
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Go
  end.

lookupGE() ->
  fun
    (DictOrd) ->
      fun
        (K) ->
          lookupGE(DictOrd, K)
      end
  end.

lookupGE(DictOrd, K) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {leaf} ->
              {nothing};
            {two, _, V@1, _, _} ->
              begin
                #{ compare := DictOrd@1 } = DictOrd,
                V2 = (DictOrd@1(K))(V@1),
                case V2 of
                  {eQ} ->
                    {just, #{ key => V@1, value => erlang:element(4, V) }};
                  {lT} ->
                    { just
                    , begin
                        V@2 = Go(erlang:element(2, V)),
                        case V@2 of
                          {nothing} ->
                            begin
                              {two, _, V@3, V@4, _} = V,
                              #{ key => V@3, value => V@4 }
                            end;
                          {just, V@5} ->
                            V@5;
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end
                    };
                  {gT} ->
                    Go(erlang:element(5, V));
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            {three, _, V@6, _, _, _, _, _} ->
              begin
                #{ compare := DictOrd@2 } = DictOrd,
                V3 = (DictOrd@2(K))(V@6),
                case V3 of
                  {eQ} ->
                    {just, #{ key => V@6, value => erlang:element(4, V) }};
                  {lT} ->
                    { just
                    , begin
                        V@7 = Go(erlang:element(2, V)),
                        case V@7 of
                          {nothing} ->
                            begin
                              {three, _, V@8, V@9, _, _, _, _} = V,
                              #{ key => V@8, value => V@9 }
                            end;
                          {just, V@10} ->
                            V@10;
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end
                    };
                  {gT} ->
                    Go({ two
                       , erlang:element(5, V)
                       , erlang:element(6, V)
                       , erlang:element(7, V)
                       , erlang:element(8, V)
                       });
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Go
  end.

lookup() ->
  fun
    (DictOrd) ->
      fun
        (K) ->
          lookup(DictOrd, K)
      end
  end.

lookup(DictOrd, K) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {leaf} ->
              {nothing};
            {two, _, V@1, _, _} ->
              begin
                #{ compare := DictOrd@1 } = DictOrd,
                V2 = (DictOrd@1(K))(V@1),
                case V2 of
                  {eQ} ->
                    {just, erlang:element(4, V)};
                  {lT} ->
                    Go(erlang:element(2, V));
                  _ ->
                    Go(erlang:element(5, V))
                end
              end;
            {three, _, V@2, _, _, _, _, _} ->
              begin
                #{ compare := DictOrd@2 } = DictOrd,
                V3 = (DictOrd@2(K))(V@2),
                case V3 of
                  {eQ} ->
                    {just, erlang:element(4, V)};
                  _ ->
                    begin
                      #{ compare := DictOrd@3 } = DictOrd,
                      V4 = (DictOrd@3(K))(erlang:element(6, V)),
                      case V4 of
                        {eQ} ->
                          {just, erlang:element(7, V)};
                        _ ->
                          case V3 of
                            {lT} ->
                              Go(erlang:element(2, V));
                            _ ->
                              case V4 of
                                {gT} ->
                                  Go(erlang:element(8, V));
                                _ ->
                                  Go(erlang:element(5, V))
                              end
                          end
                      end
                    end
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Go
  end.

member() ->
  fun
    (DictOrd) ->
      fun
        (K) ->
          fun
            (M) ->
              member(DictOrd, K, M)
          end
      end
  end.

member(DictOrd, K, M) ->
  begin
    V = (lookup(DictOrd, K))(M),
    case V of
      {nothing} ->
        false;
      {just, _} ->
        true;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

keys() ->
  fun
    (V) ->
      keys(V)
  end.

keys(V) ->
  case V of
    {leaf} ->
      {nil};
    {two, V@1, V@2, _, V@3} ->
      (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
        (data_list_types@ps:'Cons'()))
       ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
          (data_list_types@ps:'Cons'()))
         (keys(V@3)))
        ({cons, V@2, {nil}})))
      (keys(V@1));
    {three, V@4, V@5, _, V@6, V@7, _, V@8} ->
      (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
        (data_list_types@ps:'Cons'()))
       ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
          (data_list_types@ps:'Cons'()))
         ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
            (data_list_types@ps:'Cons'()))
           ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
              (data_list_types@ps:'Cons'()))
             (keys(V@8)))
            ({cons, V@7, {nil}})))
          (keys(V@6))))
        ({cons, V@5, {nil}})))
      (keys(V@4));
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

isSubmap() ->
  fun
    (DictOrd) ->
      fun
        (DictEq) ->
          fun
            (M1) ->
              fun
                (M2) ->
                  isSubmap(DictOrd, DictEq, M1, M2)
              end
          end
      end
  end.

isSubmap(DictOrd, DictEq, M1, M2) ->
  ((all())
   (fun
     (V) ->
       begin
         V@1 = (lookup(DictOrd, erlang:element(2, V)))(M2),
         case V@1 of
           {nothing} ->
             false;
           _ ->
             ?IS_KNOWN_TAG(just, 1, V@1)
               andalso (((erlang:map_get(eq, DictEq))(erlang:element(2, V@1)))
                        (erlang:element(3, V)))
         end
       end
   end))
  (toUnfoldable(data_list_lazy_types@ps:unfoldableList(), M1)).

isEmpty() ->
  fun
    (V) ->
      isEmpty(V)
  end.

isEmpty(V) ->
  ?IS_KNOWN_TAG(leaf, 0, V).

functorMap() ->
  #{ map =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {leaf} ->
                 {leaf};
               {two, V1@1, V1@2, V1@3, V1@4} ->
                 { two
                 , ((erlang:map_get(map, functorMap()))(V))(V1@1)
                 , V1@2
                 , V(V1@3)
                 , ((erlang:map_get(map, functorMap()))(V))(V1@4)
                 };
               {three, V1@5, V1@6, V1@7, V1@8, V1@9, V1@10, V1@11} ->
                 { three
                 , ((erlang:map_get(map, functorMap()))(V))(V1@5)
                 , V1@6
                 , V(V1@7)
                 , ((erlang:map_get(map, functorMap()))(V))(V1@8)
                 , V1@9
                 , V(V1@10)
                 , ((erlang:map_get(map, functorMap()))(V))(V1@11)
                 };
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   }.

functorWithIndexMap() ->
  #{ mapWithIndex =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {leaf} ->
                 {leaf};
               {two, V1@1, V1@2, V1@3, V1@4} ->
                 { two
                 , ((erlang:map_get(mapWithIndex, functorWithIndexMap()))(V))
                   (V1@1)
                 , V1@2
                 , (V(V1@2))(V1@3)
                 , ((erlang:map_get(mapWithIndex, functorWithIndexMap()))(V))
                   (V1@4)
                 };
               {three, V1@5, V1@6, V1@7, V1@8, V1@9, V1@10, V1@11} ->
                 { three
                 , ((erlang:map_get(mapWithIndex, functorWithIndexMap()))(V))
                   (V1@5)
                 , V1@6
                 , (V(V1@6))(V1@7)
                 , ((erlang:map_get(mapWithIndex, functorWithIndexMap()))(V))
                   (V1@8)
                 , V1@9
                 , (V(V1@9))(V1@10)
                 , ((erlang:map_get(mapWithIndex, functorWithIndexMap()))(V))
                   (V1@11)
                 };
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorMap()
     end
   }.

fromZipper() ->
  fun
    (DictOrd) ->
      fun
        (V) ->
          fun
            (V1) ->
              fromZipper(DictOrd, V, V1)
          end
      end
  end.

fromZipper(DictOrd, V, V1) ->
  case V of
    {nil} ->
      V1;
    {cons, V@1, V@2} ->
      case V@1 of
        {twoLeft, V@3, V@4, V@5} ->
          fromZipper(DictOrd, V@2, {two, V1, V@3, V@4, V@5});
        {twoRight, V@6, V@7, V@8} ->
          fromZipper(DictOrd, V@2, {two, V@6, V@7, V@8, V1});
        {threeLeft, V@9, V@10, V@11, V@12, V@13, V@14} ->
          fromZipper(
            DictOrd,
            V@2,
            {three, V1, V@9, V@10, V@11, V@12, V@13, V@14}
          );
        {threeMiddle, V@15, V@16, V@17, V@18, V@19, V@20} ->
          fromZipper(
            DictOrd,
            V@2,
            {three, V@15, V@16, V@17, V1, V@18, V@19, V@20}
          );
        {threeRight, V@21, V@22, V@23, V@24, V@25, V@26} ->
          fromZipper(
            DictOrd,
            V@2,
            {three, V@21, V@22, V@23, V@24, V@25, V@26, V1}
          );
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

insert() ->
  fun
    (DictOrd) ->
      fun
        (K) ->
          fun
            (V) ->
              insert(DictOrd, K, V)
          end
      end
  end.

insert(DictOrd, K, V) ->
  begin
    Up =
      fun
        Up (V1, V2) ->
          case V1 of
            {nil} ->
              { two
              , erlang:element(2, V2)
              , erlang:element(3, V2)
              , erlang:element(4, V2)
              , erlang:element(5, V2)
              };
            {cons, V1@1, V1@2} ->
              case V1@1 of
                {twoLeft, V1@3, V1@4, V1@5} ->
                  fromZipper(
                    DictOrd,
                    V1@2,
                    { three
                    , erlang:element(2, V2)
                    , erlang:element(3, V2)
                    , erlang:element(4, V2)
                    , erlang:element(5, V2)
                    , V1@3
                    , V1@4
                    , V1@5
                    }
                  );
                {twoRight, V1@6, V1@7, V1@8} ->
                  fromZipper(
                    DictOrd,
                    V1@2,
                    { three
                    , V1@6
                    , V1@7
                    , V1@8
                    , erlang:element(2, V2)
                    , erlang:element(3, V2)
                    , erlang:element(4, V2)
                    , erlang:element(5, V2)
                    }
                  );
                {threeLeft, V1@9, V1@10, V1@11, V1@12, V1@13, V1@14} ->
                  begin
                    V2@1 =
                      { kickUp
                      , { two
                        , erlang:element(2, V2)
                        , erlang:element(3, V2)
                        , erlang:element(4, V2)
                        , erlang:element(5, V2)
                        }
                      , V1@9
                      , V1@10
                      , {two, V1@11, V1@12, V1@13, V1@14}
                      },
                    Up(V1@2, V2@1)
                  end;
                {threeMiddle, V1@15, V1@16, V1@17, V1@18, V1@19, V1@20} ->
                  begin
                    V2@2 =
                      { kickUp
                      , {two, V1@15, V1@16, V1@17, erlang:element(2, V2)}
                      , erlang:element(3, V2)
                      , erlang:element(4, V2)
                      , {two, erlang:element(5, V2), V1@18, V1@19, V1@20}
                      },
                    Up(V1@2, V2@2)
                  end;
                {threeRight, V1@21, V1@22, V1@23, V1@24, V1@25, V1@26} ->
                  begin
                    V2@3 =
                      { kickUp
                      , {two, V1@21, V1@22, V1@23, V1@24}
                      , V1@25
                      , V1@26
                      , { two
                        , erlang:element(2, V2)
                        , erlang:element(3, V2)
                        , erlang:element(4, V2)
                        , erlang:element(5, V2)
                        }
                      },
                    Up(V1@2, V2@3)
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Down =
      fun
        Down (V1, V2) ->
          case V2 of
            {leaf} ->
              begin
                V2@1 = {kickUp, {leaf}, K, V, {leaf}},
                Up(V1, V2@1)
              end;
            {two, V2@2, V2@3, _, V2@4} ->
              begin
                #{ compare := DictOrd@1 } = DictOrd,
                V3 = (DictOrd@1(K))(V2@3),
                case V3 of
                  {eQ} ->
                    fromZipper(DictOrd, V1, {two, V2@2, K, V, V2@4});
                  {lT} ->
                    begin
                      V1@1 =
                        {cons, {twoLeft, V2@3, erlang:element(4, V2), V2@4}, V1},
                      Down(V1@1, V2@2)
                    end;
                  _ ->
                    begin
                      V1@2 =
                        { cons
                        , {twoRight, V2@2, V2@3, erlang:element(4, V2)}
                        , V1
                        },
                      Down(V1@2, V2@4)
                    end
                end
              end;
            {three, V2@5, V2@6, _, V2@7, V2@8, _, V2@9} ->
              begin
                #{ compare := DictOrd@2 } = DictOrd,
                V3@1 = (DictOrd@2(K))(V2@6),
                case V3@1 of
                  {eQ} ->
                    fromZipper(
                      DictOrd,
                      V1,
                      { three
                      , V2@5
                      , K
                      , V
                      , V2@7
                      , V2@8
                      , erlang:element(7, V2)
                      , V2@9
                      }
                    );
                  _ ->
                    begin
                      #{ compare := DictOrd@3 } = DictOrd,
                      V4 = (DictOrd@3(K))(V2@8),
                      case V4 of
                        {eQ} ->
                          fromZipper(
                            DictOrd,
                            V1,
                            { three
                            , V2@5
                            , V2@6
                            , erlang:element(4, V2)
                            , V2@7
                            , K
                            , V
                            , V2@9
                            }
                          );
                        _ ->
                          case V3@1 of
                            {lT} ->
                              begin
                                V1@3 =
                                  { cons
                                  , { threeLeft
                                    , V2@6
                                    , erlang:element(4, V2)
                                    , V2@7
                                    , V2@8
                                    , erlang:element(7, V2)
                                    , V2@9
                                    }
                                  , V1
                                  },
                                Down(V1@3, V2@5)
                              end;
                            _ ->
                              if
                                ?IS_KNOWN_TAG(gT, 0, V3@1)
                                  andalso ?IS_KNOWN_TAG(lT, 0, V4) ->
                                  begin
                                    V1@4 =
                                      { cons
                                      , { threeMiddle
                                        , V2@5
                                        , V2@6
                                        , erlang:element(4, V2)
                                        , V2@8
                                        , erlang:element(7, V2)
                                        , V2@9
                                        }
                                      , V1
                                      },
                                    Down(V1@4, V2@7)
                                  end;
                                true ->
                                  begin
                                    V1@5 =
                                      { cons
                                      , { threeRight
                                        , V2@5
                                        , V2@6
                                        , erlang:element(4, V2)
                                        , V2@7
                                        , V2@8
                                        , erlang:element(7, V2)
                                        }
                                      , V1
                                      },
                                    Down(V1@5, V2@9)
                                  end
                              end
                          end
                      end
                    end
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V1 = {nil},
    fun
      (V2) ->
        Down(V1, V2)
    end
  end.

pop() ->
  fun
    (DictOrd) ->
      fun
        (K) ->
          pop(DictOrd, K)
      end
  end.

pop(DictOrd, K) ->
  begin
    Up =
      fun
        Up (Ctxs, Tree) ->
          case Ctxs of
            {nil} ->
              Tree;
            {cons, Ctxs@1, Ctxs@2} ->
              begin
                V =
                  fun
                    (A, B, C, D, K1, K2, K3, V1, V2, V3) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        {two, {two, A, K1, V1, B}, K2, V2, {two, C, K3, V3, D}}
                      )
                  end,
                V@1 =
                  fun
                    (A, B, C, D, K1, K2, K3, V1, V2, V3) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        {two, {two, A, K1, V1, B}, K2, V2, {two, C, K3, V3, D}}
                      )
                  end,
                V@2 =
                  fun
                    (A, B, C, D, K1, K2, K3, V1, V2, V3) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        {two, {three, A, K1, V1, B, K2, V2, C}, K3, V3, D}
                      )
                  end,
                V@3 =
                  fun
                    (A, B, C, D, K1, K2, K3, V1, V2, V3) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        {two, {three, A, K1, V1, B, K2, V2, C}, K3, V3, D}
                      )
                  end,
                V@4 =
                  fun
                    (A, B, C, D, K1, K2, K3, V1, V2, V3) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        {two, A, K1, V1, {three, B, K2, V2, C, K3, V3, D}}
                      )
                  end,
                V@5 =
                  fun
                    (A, B, C, D, K1, K2, K3, V1, V2, V3) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        {two, A, K1, V1, {three, B, K2, V2, C, K3, V3, D}}
                      )
                  end,
                V@6 =
                  fun
                    (A, B, C, D, E, K1, K2, K3, K4, V1, V2, V3, V4) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        { three
                        , {two, A, K1, V1, B}
                        , K2
                        , V2
                        , {two, C, K3, V3, D}
                        , K4
                        , V4
                        , E
                        }
                      )
                  end,
                V@7 =
                  fun
                    (A, B, C, D, E, K1, K2, K3, K4, V1, V2, V3, V4) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        { three
                        , {two, A, K1, V1, B}
                        , K2
                        , V2
                        , {two, C, K3, V3, D}
                        , K4
                        , V4
                        , E
                        }
                      )
                  end,
                V@8 =
                  fun
                    (A, B, C, D, E, K1, K2, K3, K4, V1, V2, V3, V4) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        { three
                        , A
                        , K1
                        , V1
                        , {two, B, K2, V2, C}
                        , K3
                        , V3
                        , {two, D, K4, V4, E}
                        }
                      )
                  end,
                V@9 =
                  fun
                    (A, B, C, D, E, K1, K2, K3, K4, V1, V2, V3, V4) ->
                      fromZipper(
                        DictOrd,
                        Ctxs@2,
                        { three
                        , A
                        , K1
                        , V1
                        , {two, B, K2, V2, C}
                        , K3
                        , V3
                        , {two, D, K4, V4, E}
                        }
                      )
                  end,
                case Tree of
                  {leaf} ->
                    case Ctxs@1 of
                      {twoLeft, Ctxs@3, Ctxs@4, Ctxs@5} ->
                        case Ctxs@5 of
                          {leaf} ->
                            fromZipper(
                              DictOrd,
                              Ctxs@2,
                              {two, {leaf}, Ctxs@3, Ctxs@4, {leaf}}
                            );
                          {two, Ctxs@6, Ctxs@7, Ctxs@8, Ctxs@9} ->
                            begin
                              Tree@1 =
                                { three
                                , Tree
                                , Ctxs@3
                                , Ctxs@4
                                , Ctxs@6
                                , Ctxs@7
                                , Ctxs@8
                                , Ctxs@9
                                },
                              Up(Ctxs@2, Tree@1)
                            end;
                          { three
                          , Ctxs@10
                          , Ctxs@11
                          , Ctxs@12
                          , Ctxs@13
                          , Ctxs@14
                          , Ctxs@15
                          , Ctxs@16
                          } ->
                            V(
                              Tree,
                              Ctxs@10,
                              Ctxs@13,
                              Ctxs@16,
                              Ctxs@3,
                              Ctxs@11,
                              Ctxs@14,
                              Ctxs@4,
                              Ctxs@12,
                              Ctxs@15
                            );
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end;
                      {twoRight, Ctxs@17, Ctxs@18, Ctxs@19} ->
                        case Ctxs@17 of
                          {leaf} ->
                            fromZipper(
                              DictOrd,
                              Ctxs@2,
                              {two, {leaf}, Ctxs@18, Ctxs@19, {leaf}}
                            );
                          {two, Ctxs@20, Ctxs@21, Ctxs@22, Ctxs@23} ->
                            begin
                              Tree@2 =
                                { three
                                , Ctxs@20
                                , Ctxs@21
                                , Ctxs@22
                                , Ctxs@23
                                , Ctxs@18
                                , Ctxs@19
                                , Tree
                                },
                              Up(Ctxs@2, Tree@2)
                            end;
                          { three
                          , Ctxs@24
                          , Ctxs@25
                          , Ctxs@26
                          , Ctxs@27
                          , Ctxs@28
                          , Ctxs@29
                          , Ctxs@30
                          } ->
                            V@1(
                              Ctxs@24,
                              Ctxs@27,
                              Ctxs@30,
                              Tree,
                              Ctxs@25,
                              Ctxs@28,
                              Ctxs@18,
                              Ctxs@26,
                              Ctxs@29,
                              Ctxs@19
                            );
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end;
                      { threeLeft
                      , Ctxs@31
                      , Ctxs@32
                      , Ctxs@33
                      , Ctxs@34
                      , Ctxs@35
                      , Ctxs@36
                      } ->
                        case Ctxs@36 of
                          {leaf} ->
                            case Ctxs@33 of
                              {leaf} ->
                                fromZipper(
                                  DictOrd,
                                  Ctxs@2,
                                  { three
                                  , {leaf}
                                  , Ctxs@31
                                  , Ctxs@32
                                  , {leaf}
                                  , Ctxs@34
                                  , Ctxs@35
                                  , {leaf}
                                  }
                                );
                              {two, Ctxs@37, Ctxs@38, Ctxs@39, Ctxs@40} ->
                                V@2(
                                  Tree,
                                  Ctxs@37,
                                  Ctxs@40,
                                  Ctxs@36,
                                  Ctxs@31,
                                  Ctxs@38,
                                  Ctxs@34,
                                  Ctxs@32,
                                  Ctxs@39,
                                  Ctxs@35
                                );
                              { three
                              , Ctxs@41
                              , Ctxs@42
                              , Ctxs@43
                              , Ctxs@44
                              , Ctxs@45
                              , Ctxs@46
                              , Ctxs@47
                              } ->
                                V@6(
                                  Tree,
                                  Ctxs@41,
                                  Ctxs@44,
                                  Ctxs@47,
                                  Ctxs@36,
                                  Ctxs@31,
                                  Ctxs@42,
                                  Ctxs@45,
                                  Ctxs@34,
                                  Ctxs@32,
                                  Ctxs@43,
                                  Ctxs@46,
                                  Ctxs@35
                                );
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end;
                          _ ->
                            case Ctxs@33 of
                              {two, Ctxs@48, Ctxs@49, Ctxs@50, Ctxs@51} ->
                                V@2(
                                  Tree,
                                  Ctxs@48,
                                  Ctxs@51,
                                  Ctxs@36,
                                  Ctxs@31,
                                  Ctxs@49,
                                  Ctxs@34,
                                  Ctxs@32,
                                  Ctxs@50,
                                  Ctxs@35
                                );
                              { three
                              , Ctxs@52
                              , Ctxs@53
                              , Ctxs@54
                              , Ctxs@55
                              , Ctxs@56
                              , Ctxs@57
                              , Ctxs@58
                              } ->
                                V@6(
                                  Tree,
                                  Ctxs@52,
                                  Ctxs@55,
                                  Ctxs@58,
                                  Ctxs@36,
                                  Ctxs@31,
                                  Ctxs@53,
                                  Ctxs@56,
                                  Ctxs@34,
                                  Ctxs@32,
                                  Ctxs@54,
                                  Ctxs@57,
                                  Ctxs@35
                                );
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end
                        end;
                      { threeMiddle
                      , Ctxs@59
                      , Ctxs@60
                      , Ctxs@61
                      , Ctxs@62
                      , Ctxs@63
                      , Ctxs@64
                      } ->
                        case Ctxs@59 of
                          {leaf} ->
                            case Ctxs@64 of
                              {leaf} ->
                                fromZipper(
                                  DictOrd,
                                  Ctxs@2,
                                  { three
                                  , {leaf}
                                  , Ctxs@60
                                  , Ctxs@61
                                  , {leaf}
                                  , Ctxs@62
                                  , Ctxs@63
                                  , {leaf}
                                  }
                                );
                              {two, Ctxs@65, Ctxs@66, Ctxs@67, Ctxs@68} ->
                                V@4(
                                  Ctxs@59,
                                  Tree,
                                  Ctxs@65,
                                  Ctxs@68,
                                  Ctxs@60,
                                  Ctxs@62,
                                  Ctxs@66,
                                  Ctxs@61,
                                  Ctxs@63,
                                  Ctxs@67
                                );
                              { three
                              , Ctxs@69
                              , Ctxs@70
                              , Ctxs@71
                              , Ctxs@72
                              , Ctxs@73
                              , Ctxs@74
                              , Ctxs@75
                              } ->
                                V@8(
                                  Ctxs@59,
                                  Tree,
                                  Ctxs@69,
                                  Ctxs@72,
                                  Ctxs@75,
                                  Ctxs@60,
                                  Ctxs@62,
                                  Ctxs@70,
                                  Ctxs@73,
                                  Ctxs@61,
                                  Ctxs@63,
                                  Ctxs@71,
                                  Ctxs@74
                                );
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end;
                          {two, Ctxs@76, Ctxs@77, Ctxs@78, Ctxs@79} ->
                            V@3(
                              Ctxs@76,
                              Ctxs@79,
                              Tree,
                              Ctxs@64,
                              Ctxs@77,
                              Ctxs@60,
                              Ctxs@62,
                              Ctxs@78,
                              Ctxs@61,
                              Ctxs@63
                            );
                          _ ->
                            case Ctxs@64 of
                              {two, Ctxs@80, Ctxs@81, Ctxs@82, Ctxs@83} ->
                                V@4(
                                  Ctxs@59,
                                  Tree,
                                  Ctxs@80,
                                  Ctxs@83,
                                  Ctxs@60,
                                  Ctxs@62,
                                  Ctxs@81,
                                  Ctxs@61,
                                  Ctxs@63,
                                  Ctxs@82
                                );
                              _ ->
                                case Ctxs@59 of
                                  { three
                                  , Ctxs@84
                                  , Ctxs@85
                                  , Ctxs@86
                                  , Ctxs@87
                                  , Ctxs@88
                                  , Ctxs@89
                                  , Ctxs@90
                                  } ->
                                    V@7(
                                      Ctxs@84,
                                      Ctxs@87,
                                      Ctxs@90,
                                      Tree,
                                      Ctxs@64,
                                      Ctxs@85,
                                      Ctxs@88,
                                      Ctxs@60,
                                      Ctxs@62,
                                      Ctxs@86,
                                      Ctxs@89,
                                      Ctxs@61,
                                      Ctxs@63
                                    );
                                  _ ->
                                    case Ctxs@64 of
                                      { three
                                      , Ctxs@91
                                      , Ctxs@92
                                      , Ctxs@93
                                      , Ctxs@94
                                      , Ctxs@95
                                      , Ctxs@96
                                      , Ctxs@97
                                      } ->
                                        V@8(
                                          Ctxs@59,
                                          Tree,
                                          Ctxs@91,
                                          Ctxs@94,
                                          Ctxs@97,
                                          Ctxs@60,
                                          Ctxs@62,
                                          Ctxs@92,
                                          Ctxs@95,
                                          Ctxs@61,
                                          Ctxs@63,
                                          Ctxs@93,
                                          Ctxs@96
                                        );
                                      _ ->
                                        erlang:error({ fail
                                                     , <<
                                                         "Failed pattern match"
                                                       >>
                                                     })
                                    end
                                end
                            end
                        end;
                      { threeRight
                      , Ctxs@98
                      , Ctxs@99
                      , Ctxs@100
                      , Ctxs@101
                      , Ctxs@102
                      , Ctxs@103
                      } ->
                        case Ctxs@98 of
                          {leaf} ->
                            case Ctxs@101 of
                              {leaf} ->
                                fromZipper(
                                  DictOrd,
                                  Ctxs@2,
                                  { three
                                  , {leaf}
                                  , Ctxs@99
                                  , Ctxs@100
                                  , {leaf}
                                  , Ctxs@102
                                  , Ctxs@103
                                  , {leaf}
                                  }
                                );
                              {two, Ctxs@104, Ctxs@105, Ctxs@106, Ctxs@107} ->
                                V@5(
                                  Ctxs@98,
                                  Ctxs@104,
                                  Ctxs@107,
                                  Tree,
                                  Ctxs@99,
                                  Ctxs@105,
                                  Ctxs@102,
                                  Ctxs@100,
                                  Ctxs@106,
                                  Ctxs@103
                                );
                              { three
                              , Ctxs@108
                              , Ctxs@109
                              , Ctxs@110
                              , Ctxs@111
                              , Ctxs@112
                              , Ctxs@113
                              , Ctxs@114
                              } ->
                                V@9(
                                  Ctxs@98,
                                  Ctxs@108,
                                  Ctxs@111,
                                  Ctxs@114,
                                  Tree,
                                  Ctxs@99,
                                  Ctxs@109,
                                  Ctxs@112,
                                  Ctxs@102,
                                  Ctxs@100,
                                  Ctxs@110,
                                  Ctxs@113,
                                  Ctxs@103
                                );
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end;
                          _ ->
                            case Ctxs@101 of
                              {two, Ctxs@115, Ctxs@116, Ctxs@117, Ctxs@118} ->
                                V@5(
                                  Ctxs@98,
                                  Ctxs@115,
                                  Ctxs@118,
                                  Tree,
                                  Ctxs@99,
                                  Ctxs@116,
                                  Ctxs@102,
                                  Ctxs@100,
                                  Ctxs@117,
                                  Ctxs@103
                                );
                              { three
                              , Ctxs@119
                              , Ctxs@120
                              , Ctxs@121
                              , Ctxs@122
                              , Ctxs@123
                              , Ctxs@124
                              , Ctxs@125
                              } ->
                                V@9(
                                  Ctxs@98,
                                  Ctxs@119,
                                  Ctxs@122,
                                  Ctxs@125,
                                  Tree,
                                  Ctxs@99,
                                  Ctxs@120,
                                  Ctxs@123,
                                  Ctxs@102,
                                  Ctxs@100,
                                  Ctxs@121,
                                  Ctxs@124,
                                  Ctxs@103
                                );
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end
                        end;
                      _ ->
                        erlang:error({fail, <<"Failed pattern match">>})
                    end;
                  _ ->
                    case Ctxs@1 of
                      {twoLeft, Ctxs@126, Ctxs@127, Ctxs@128} ->
                        case Ctxs@128 of
                          {two, Ctxs@129, Ctxs@130, Ctxs@131, Ctxs@132} ->
                            begin
                              Tree@3 =
                                { three
                                , Tree
                                , Ctxs@126
                                , Ctxs@127
                                , Ctxs@129
                                , Ctxs@130
                                , Ctxs@131
                                , Ctxs@132
                                },
                              Up(Ctxs@2, Tree@3)
                            end;
                          { three
                          , Ctxs@133
                          , Ctxs@134
                          , Ctxs@135
                          , Ctxs@136
                          , Ctxs@137
                          , Ctxs@138
                          , Ctxs@139
                          } ->
                            V(
                              Tree,
                              Ctxs@133,
                              Ctxs@136,
                              Ctxs@139,
                              Ctxs@126,
                              Ctxs@134,
                              Ctxs@137,
                              Ctxs@127,
                              Ctxs@135,
                              Ctxs@138
                            );
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end;
                      {twoRight, Ctxs@140, Ctxs@141, Ctxs@142} ->
                        case Ctxs@140 of
                          {two, Ctxs@143, Ctxs@144, Ctxs@145, Ctxs@146} ->
                            begin
                              Tree@4 =
                                { three
                                , Ctxs@143
                                , Ctxs@144
                                , Ctxs@145
                                , Ctxs@146
                                , Ctxs@141
                                , Ctxs@142
                                , Tree
                                },
                              Up(Ctxs@2, Tree@4)
                            end;
                          { three
                          , Ctxs@147
                          , Ctxs@148
                          , Ctxs@149
                          , Ctxs@150
                          , Ctxs@151
                          , Ctxs@152
                          , Ctxs@153
                          } ->
                            V@1(
                              Ctxs@147,
                              Ctxs@150,
                              Ctxs@153,
                              Tree,
                              Ctxs@148,
                              Ctxs@151,
                              Ctxs@141,
                              Ctxs@149,
                              Ctxs@152,
                              Ctxs@142
                            );
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end;
                      { threeLeft
                      , Ctxs@154
                      , Ctxs@155
                      , Ctxs@156
                      , Ctxs@157
                      , Ctxs@158
                      , Ctxs@159
                      } ->
                        case Ctxs@156 of
                          {two, Ctxs@160, Ctxs@161, Ctxs@162, Ctxs@163} ->
                            V@2(
                              Tree,
                              Ctxs@160,
                              Ctxs@163,
                              Ctxs@159,
                              Ctxs@154,
                              Ctxs@161,
                              Ctxs@157,
                              Ctxs@155,
                              Ctxs@162,
                              Ctxs@158
                            );
                          { three
                          , Ctxs@164
                          , Ctxs@165
                          , Ctxs@166
                          , Ctxs@167
                          , Ctxs@168
                          , Ctxs@169
                          , Ctxs@170
                          } ->
                            V@6(
                              Tree,
                              Ctxs@164,
                              Ctxs@167,
                              Ctxs@170,
                              Ctxs@159,
                              Ctxs@154,
                              Ctxs@165,
                              Ctxs@168,
                              Ctxs@157,
                              Ctxs@155,
                              Ctxs@166,
                              Ctxs@169,
                              Ctxs@158
                            );
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end;
                      { threeMiddle
                      , Ctxs@171
                      , Ctxs@172
                      , Ctxs@173
                      , Ctxs@174
                      , Ctxs@175
                      , Ctxs@176
                      } ->
                        case Ctxs@171 of
                          {two, Ctxs@177, Ctxs@178, Ctxs@179, Ctxs@180} ->
                            V@3(
                              Ctxs@177,
                              Ctxs@180,
                              Tree,
                              Ctxs@176,
                              Ctxs@178,
                              Ctxs@172,
                              Ctxs@174,
                              Ctxs@179,
                              Ctxs@173,
                              Ctxs@175
                            );
                          _ ->
                            case Ctxs@176 of
                              {two, Ctxs@181, Ctxs@182, Ctxs@183, Ctxs@184} ->
                                V@4(
                                  Ctxs@171,
                                  Tree,
                                  Ctxs@181,
                                  Ctxs@184,
                                  Ctxs@172,
                                  Ctxs@174,
                                  Ctxs@182,
                                  Ctxs@173,
                                  Ctxs@175,
                                  Ctxs@183
                                );
                              _ ->
                                case Ctxs@171 of
                                  { three
                                  , Ctxs@185
                                  , Ctxs@186
                                  , Ctxs@187
                                  , Ctxs@188
                                  , Ctxs@189
                                  , Ctxs@190
                                  , Ctxs@191
                                  } ->
                                    V@7(
                                      Ctxs@185,
                                      Ctxs@188,
                                      Ctxs@191,
                                      Tree,
                                      Ctxs@176,
                                      Ctxs@186,
                                      Ctxs@189,
                                      Ctxs@172,
                                      Ctxs@174,
                                      Ctxs@187,
                                      Ctxs@190,
                                      Ctxs@173,
                                      Ctxs@175
                                    );
                                  _ ->
                                    case Ctxs@176 of
                                      { three
                                      , Ctxs@192
                                      , Ctxs@193
                                      , Ctxs@194
                                      , Ctxs@195
                                      , Ctxs@196
                                      , Ctxs@197
                                      , Ctxs@198
                                      } ->
                                        V@8(
                                          Ctxs@171,
                                          Tree,
                                          Ctxs@192,
                                          Ctxs@195,
                                          Ctxs@198,
                                          Ctxs@172,
                                          Ctxs@174,
                                          Ctxs@193,
                                          Ctxs@196,
                                          Ctxs@173,
                                          Ctxs@175,
                                          Ctxs@194,
                                          Ctxs@197
                                        );
                                      _ ->
                                        erlang:error({ fail
                                                     , <<
                                                         "Failed pattern match"
                                                       >>
                                                     })
                                    end
                                end
                            end
                        end;
                      { threeRight
                      , Ctxs@199
                      , Ctxs@200
                      , Ctxs@201
                      , Ctxs@202
                      , Ctxs@203
                      , Ctxs@204
                      } ->
                        case Ctxs@202 of
                          {two, Ctxs@205, Ctxs@206, Ctxs@207, Ctxs@208} ->
                            V@5(
                              Ctxs@199,
                              Ctxs@205,
                              Ctxs@208,
                              Tree,
                              Ctxs@200,
                              Ctxs@206,
                              Ctxs@203,
                              Ctxs@201,
                              Ctxs@207,
                              Ctxs@204
                            );
                          { three
                          , Ctxs@209
                          , Ctxs@210
                          , Ctxs@211
                          , Ctxs@212
                          , Ctxs@213
                          , Ctxs@214
                          , Ctxs@215
                          } ->
                            V@9(
                              Ctxs@199,
                              Ctxs@209,
                              Ctxs@212,
                              Ctxs@215,
                              Tree,
                              Ctxs@200,
                              Ctxs@210,
                              Ctxs@213,
                              Ctxs@203,
                              Ctxs@201,
                              Ctxs@211,
                              Ctxs@214,
                              Ctxs@204
                            );
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end;
                      _ ->
                        erlang:error({fail, <<"Failed pattern match">>})
                    end
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    RemoveMaxNode =
      fun
        RemoveMaxNode (Ctx, M) ->
          case M of
            {two, M@1, _, _, _} ->
              if
                ?IS_KNOWN_TAG(leaf, 0, M@1)
                  andalso ?IS_KNOWN_TAG(leaf, 0, erlang:element(5, M)) ->
                  begin
                    Tree = {leaf},
                    Up(Ctx, Tree)
                  end;
                true ->
                  begin
                    Ctx@1 =
                      { cons
                      , { twoRight
                        , M@1
                        , erlang:element(3, M)
                        , erlang:element(4, M)
                        }
                      , Ctx
                      },
                    M@2 = erlang:element(5, M),
                    RemoveMaxNode(Ctx@1, M@2)
                  end
              end;
            {three, M@3, M@4, M@5, M@6, _, _, M@7} ->
              if
                ?IS_KNOWN_TAG(leaf, 0, M@3)
                  andalso (?IS_KNOWN_TAG(leaf, 0, M@6)
                    andalso ?IS_KNOWN_TAG(leaf, 0, M@7)) ->
                  begin
                    Ctxs = {cons, {twoRight, {leaf}, M@4, M@5}, Ctx},
                    Tree@1 = {leaf},
                    Up(Ctxs, Tree@1)
                  end;
                true ->
                  begin
                    Ctx@2 =
                      { cons
                      , { threeRight
                        , M@3
                        , M@4
                        , M@5
                        , M@6
                        , erlang:element(6, M)
                        , erlang:element(7, M)
                        }
                      , Ctx
                      },
                    RemoveMaxNode(Ctx@2, M@7)
                  end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    MaxNode =
      fun
        MaxNode (M) ->
          case M of
            {two, _, _, _, M@1} ->
              case M@1 of
                {leaf} ->
                  #{ key => erlang:element(3, M)
                   , value => erlang:element(4, M)
                   };
                _ ->
                  MaxNode(M@1)
              end;
            {three, _, _, _, _, _, _, M@2} ->
              case M@2 of
                {leaf} ->
                  #{ key => erlang:element(6, M)
                   , value => erlang:element(7, M)
                   };
                _ ->
                  MaxNode(M@2)
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Down =
      fun
        Down (Ctx, M) ->
          case M of
            {leaf} ->
              {nothing};
            {two, _, M@1, M@2, M@3} ->
              begin
                #{ compare := DictOrd@1 } = DictOrd,
                V = (DictOrd@1(K))(M@1),
                case V of
                  {eQ} ->
                    case M@3 of
                      {leaf} ->
                        { just
                        , { tuple
                          , M@2
                          , begin
                              Tree = {leaf},
                              Up(Ctx, Tree)
                            end
                          }
                        };
                      _ ->
                        begin
                          #{ key := Max, value := Max@1 } =
                            MaxNode(erlang:element(2, M)),
                          { just
                          , { tuple
                            , M@2
                            , begin
                                Ctx@1 = {cons, {twoLeft, Max, Max@1, M@3}, Ctx},
                                M@4 = erlang:element(2, M),
                                RemoveMaxNode(Ctx@1, M@4)
                              end
                            }
                          }
                        end
                    end;
                  {lT} ->
                    begin
                      Ctx@2 = {cons, {twoLeft, M@1, M@2, M@3}, Ctx},
                      M@5 = erlang:element(2, M),
                      Down(Ctx@2, M@5)
                    end;
                  _ ->
                    begin
                      Ctx@3 =
                        {cons, {twoRight, erlang:element(2, M), M@1, M@2}, Ctx},
                      Down(Ctx@3, M@3)
                    end
                end
              end;
            {three, M@6, M@7, M@8, M@9, M@10, M@11, M@12} ->
              begin
                #{ compare := DictOrd@2 } = DictOrd,
                V@1 = (DictOrd@2(K))(M@10),
                V3 = (DictOrd@2(K))(M@7),
                if
                  ?IS_KNOWN_TAG(leaf, 0, M@6)
                    andalso (?IS_KNOWN_TAG(leaf, 0, M@9)
                      andalso ?IS_KNOWN_TAG(leaf, 0, M@12)) ->
                    case V3 of
                      {eQ} ->
                        { just
                        , { tuple
                          , M@8
                          , fromZipper(
                              DictOrd,
                              Ctx,
                              {two, {leaf}, M@10, M@11, {leaf}}
                            )
                          }
                        };
                      _ ->
                        case V@1 of
                          {eQ} ->
                            { just
                            , { tuple
                              , M@11
                              , fromZipper(
                                  DictOrd,
                                  Ctx,
                                  {two, {leaf}, M@7, M@8, {leaf}}
                                )
                              }
                            };
                          _ ->
                            case V3 of
                              {lT} ->
                                begin
                                  Ctx@4 =
                                    { cons
                                    , { threeLeft
                                      , M@7
                                      , M@8
                                      , M@9
                                      , M@10
                                      , M@11
                                      , M@12
                                      }
                                    , Ctx
                                    },
                                  Down(Ctx@4, M@6)
                                end;
                              _ ->
                                if
                                  ?IS_KNOWN_TAG(gT, 0, V3)
                                    andalso ?IS_KNOWN_TAG(lT, 0, V@1) ->
                                    begin
                                      Ctx@5 =
                                        { cons
                                        , { threeMiddle
                                          , M@6
                                          , M@7
                                          , M@8
                                          , M@10
                                          , M@11
                                          , M@12
                                          }
                                        , Ctx
                                        },
                                      Down(Ctx@5, M@9)
                                    end;
                                  true ->
                                    begin
                                      Ctx@6 =
                                        { cons
                                        , { threeRight
                                          , M@6
                                          , M@7
                                          , M@8
                                          , M@9
                                          , M@10
                                          , M@11
                                          }
                                        , Ctx
                                        },
                                      Down(Ctx@6, M@12)
                                    end
                                end
                            end
                        end
                    end;
                  ?IS_KNOWN_TAG(eQ, 0, V3) ->
                    begin
                      #{ key := Max@2, value := Max@3 } = MaxNode(M@6),
                      { just
                      , { tuple
                        , M@8
                        , begin
                            Ctx@7 =
                              { cons
                              , {threeLeft, Max@2, Max@3, M@9, M@10, M@11, M@12}
                              , Ctx
                              },
                            RemoveMaxNode(Ctx@7, M@6)
                          end
                        }
                      }
                    end;
                  ?IS_KNOWN_TAG(eQ, 0, V@1) ->
                    begin
                      #{ key := Max@4, value := Max@5 } = MaxNode(M@9),
                      { just
                      , { tuple
                        , M@11
                        , begin
                            Ctx@8 =
                              { cons
                              , {threeMiddle, M@6, M@7, M@8, Max@4, Max@5, M@12}
                              , Ctx
                              },
                            RemoveMaxNode(Ctx@8, M@9)
                          end
                        }
                      }
                    end;
                  ?IS_KNOWN_TAG(lT, 0, V3) ->
                    begin
                      Ctx@9 =
                        { cons
                        , {threeLeft, M@7, M@8, M@9, M@10, M@11, M@12}
                        , Ctx
                        },
                      Down(Ctx@9, M@6)
                    end;
                  ?IS_KNOWN_TAG(gT, 0, V3) andalso ?IS_KNOWN_TAG(lT, 0, V@1) ->
                    begin
                      Ctx@10 =
                        { cons
                        , {threeMiddle, M@6, M@7, M@8, M@10, M@11, M@12}
                        , Ctx
                        },
                      Down(Ctx@10, M@9)
                    end;
                  true ->
                    begin
                      Ctx@11 =
                        { cons
                        , {threeRight, M@6, M@7, M@8, M@9, M@10, M@11}
                        , Ctx
                        },
                      Down(Ctx@11, M@12)
                    end
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Ctx = {nil},
    fun
      (M) ->
        Down(Ctx, M)
    end
  end.

foldableMap() ->
  #{ foldl =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (M) ->
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
                   V = values(M),
                   Go(Z, V)
                 end
             end
         end
     end
   , foldr =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (M) ->
                 (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
                   (F))
                  (Z))
                 (values(M))
             end
         end
     end
   , foldMap =>
     fun
       (DictMonoid) ->
         begin
           FoldMap1 =
             (erlang:map_get(foldMap, data_list_types@ps:foldableList()))
             (DictMonoid),
           fun
             (F) ->
               fun
                 (M) ->
                   (FoldMap1(F))(values(M))
               end
           end
         end
     end
   }.

traversableMap() ->
  #{ traverse =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1
                           , pure := DictApplicative@2
                           }) ->
         begin
           Apply0 = #{ 'Functor0' := Apply0@1 } = DictApplicative@1(undefined),
           V = Apply0@1(undefined),
           fun
             (V@1) ->
               fun
                 (V1) ->
                   case V1 of
                     {leaf} ->
                       DictApplicative@2({leaf});
                     {two, V1@1, V1@2, V1@3, V1@4} ->
                       begin
                         #{ map := V@2 } = V,
                         #{ apply := Apply0@2 } = Apply0,
                         (Apply0@2((Apply0@2((Apply0@2((V@2('Two'()))
                                                       ((((erlang:map_get(
                                                             traverse,
                                                             traversableMap()
                                                           ))
                                                          (DictApplicative))
                                                         (V@1))
                                                        (V1@1))))
                                             (DictApplicative@2(V1@2))))
                                   (V@1(V1@3))))
                         ((((erlang:map_get(traverse, traversableMap()))
                            (DictApplicative))
                           (V@1))
                          (V1@4))
                       end;
                     {three, V1@5, V1@6, V1@7, V1@8, V1@9, V1@10, V1@11} ->
                       begin
                         #{ map := V@3 } = V,
                         #{ apply := Apply0@3 } = Apply0,
                         (Apply0@3((Apply0@3((Apply0@3((Apply0@3((Apply0@3((Apply0@3((V@3('Three'()))
                                                                                     ((((erlang:map_get(
                                                                                           traverse,
                                                                                           traversableMap()
                                                                                         ))
                                                                                        (DictApplicative))
                                                                                       (V@1))
                                                                                      (V1@5))))
                                                                           (DictApplicative@2(V1@6))))
                                                                 (V@1(V1@7))))
                                                       ((((erlang:map_get(
                                                             traverse,
                                                             traversableMap()
                                                           ))
                                                          (DictApplicative))
                                                         (V@1))
                                                        (V1@8))))
                                             (DictApplicative@2(V1@9))))
                                   (V@1(V1@10))))
                         ((((erlang:map_get(traverse, traversableMap()))
                            (DictApplicative))
                           (V@1))
                          (V1@11))
                       end;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
         end
     end
   , sequence =>
     fun
       (DictApplicative) ->
         ((erlang:map_get(traverse, traversableMap()))(DictApplicative))
         (identity())
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorMap()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         foldableMap()
     end
   }.

foldSubmapBy() ->
  fun
    (DictOrd) ->
      fun
        (AppendFn) ->
          fun
            (MemptyValue) ->
              fun
                (Kmin) ->
                  fun
                    (Kmax) ->
                      fun
                        (F) ->
                          foldSubmapBy(
                            DictOrd,
                            AppendFn,
                            MemptyValue,
                            Kmin,
                            Kmax,
                            F
                          )
                      end
                  end
              end
          end
      end
  end.

foldSubmapBy(DictOrd, AppendFn, MemptyValue, Kmin, Kmax, F) ->
  begin
    TooSmall =
      case Kmin of
        {just, Kmin@1} ->
          begin
            #{ compare := DictOrd@1 } = DictOrd,
            fun
              (K) ->
                begin
                  V = (DictOrd@1(K))(Kmin@1),
                  ?IS_KNOWN_TAG(lT, 0, V)
                end
            end
          end;
        {nothing} ->
          fun
            (_) ->
              false
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end,
    TooLarge =
      case Kmax of
        {just, Kmax@1} ->
          begin
            #{ compare := DictOrd@2 } = DictOrd,
            fun
              (K) ->
                begin
                  V = (DictOrd@2(K))(Kmax@1),
                  ?IS_KNOWN_TAG(gT, 0, V)
                end
            end
          end;
        {nothing} ->
          fun
            (_) ->
              false
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end,
    InBounds =
      case Kmin of
        {just, Kmin@2} ->
          begin
            #{ compare := DictOrd@3 } = DictOrd,
            case Kmax of
              {just, Kmax@2} ->
                fun
                  (K) ->
                    (not begin
                      V = (DictOrd@3(Kmin@2))(K),
                      ?IS_KNOWN_TAG(gT, 0, V)
                    end)
                      andalso (not begin
                        V@1 = (DictOrd@3(K))(Kmax@2),
                        ?IS_KNOWN_TAG(gT, 0, V@1)
                      end)
                end;
              {nothing} ->
                fun
                  (K) ->
                    not begin
                      V = (DictOrd@3(Kmin@2))(K),
                      ?IS_KNOWN_TAG(gT, 0, V)
                    end
                end;
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
          end;
        {nothing} ->
          case Kmax of
            {just, Kmax@3} ->
              begin
                #{ compare := DictOrd@4 } = DictOrd,
                fun
                  (K) ->
                    not begin
                      V = (DictOrd@4(K))(Kmax@3),
                      ?IS_KNOWN_TAG(gT, 0, V)
                    end
                end
              end;
            {nothing} ->
              fun
                (_) ->
                  true
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end,
    Go =
      fun
        Go (V) ->
          case V of
            {leaf} ->
              MemptyValue;
            {two, _, V@1, _, _} ->
              (AppendFn((AppendFn(case TooSmall(V@1) of
                           true ->
                             MemptyValue;
                           _ ->
                             begin
                               {two, V@2, _, _, _} = V,
                               Go(V@2)
                             end
                         end))
                        (case InBounds(V@1) of
                          true ->
                            begin
                              {two, _, V@3, V@4, _} = V,
                              (F(V@3))(V@4)
                            end;
                          _ ->
                            MemptyValue
                        end)))
              (case TooLarge(V@1) of
                true ->
                  MemptyValue;
                _ ->
                  begin
                    {two, _, _, _, V@5} = V,
                    Go(V@5)
                  end
              end);
            {three, _, V@6, _, _, V@7, _, _} ->
              (AppendFn((AppendFn((AppendFn((AppendFn(case TooSmall(V@6) of
                                               true ->
                                                 MemptyValue;
                                               _ ->
                                                 begin
                                                   { three
                                                   , V@8
                                                   , _
                                                   , _
                                                   , _
                                                   , _
                                                   , _
                                                   , _
                                                   } =
                                                     V,
                                                   Go(V@8)
                                                 end
                                             end))
                                            (case InBounds(V@6) of
                                              true ->
                                                begin
                                                  { three
                                                  , _
                                                  , V@9
                                                  , V@10
                                                  , _
                                                  , _
                                                  , _
                                                  , _
                                                  } =
                                                    V,
                                                  (F(V@9))(V@10)
                                                end;
                                              _ ->
                                                MemptyValue
                                            end)))
                                  (case (TooSmall(V@7)) orelse (TooLarge(V@6)) of
                                    true ->
                                      MemptyValue;
                                    _ ->
                                      begin
                                        {three, _, _, _, V@11, _, _, _} = V,
                                        Go(V@11)
                                      end
                                  end)))
                        (case InBounds(V@7) of
                          true ->
                            begin
                              {three, _, _, _, _, V@12, V@13, _} = V,
                              (F(V@12))(V@13)
                            end;
                          _ ->
                            MemptyValue
                        end)))
              (case TooLarge(V@7) of
                true ->
                  MemptyValue;
                _ ->
                  begin
                    {three, _, _, _, _, _, _, V@14} = V,
                    Go(V@14)
                  end
              end);
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Go
  end.

foldSubmap() ->
  fun
    (DictOrd) ->
      fun
        (DictMonoid) ->
          foldSubmap(DictOrd, DictMonoid)
      end
  end.

foldSubmap(DictOrd, #{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
  (((foldSubmapBy())(DictOrd))(erlang:map_get(append, DictMonoid(undefined))))
  (DictMonoid@1).

'findMin.go'() ->
  fun
    (V) ->
      fun
        (V1) ->
          'findMin.go'(V, V1)
      end
  end.

'findMin.go'(V, V1) ->
  case V1 of
    {leaf} ->
      V;
    {two, V1@1, V1@2, V1@3, _} ->
      'findMin.go'({just, #{ key => V1@2, value => V1@3 }}, V1@1);
    {three, V1@4, V1@5, V1@6, _, _, _, _} ->
      'findMin.go'({just, #{ key => V1@5, value => V1@6 }}, V1@4);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

findMin() ->
  ('findMin.go'())({nothing}).

lookupGT() ->
  fun
    (DictOrd) ->
      fun
        (K) ->
          lookupGT(DictOrd, K)
      end
  end.

lookupGT(DictOrd, K) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {leaf} ->
              {nothing};
            {two, _, V@1, _, _} ->
              begin
                #{ compare := DictOrd@1 } = DictOrd,
                V2 = (DictOrd@1(K))(V@1),
                case V2 of
                  {eQ} ->
                    findMin(erlang:element(5, V));
                  {lT} ->
                    { just
                    , begin
                        V@2 = Go(erlang:element(2, V)),
                        case V@2 of
                          {nothing} ->
                            begin
                              {two, _, V@3, V@4, _} = V,
                              #{ key => V@3, value => V@4 }
                            end;
                          {just, V@5} ->
                            V@5;
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end
                    };
                  {gT} ->
                    Go(erlang:element(5, V));
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            {three, _, V@6, _, _, _, _, _} ->
              begin
                #{ compare := DictOrd@2 } = DictOrd,
                V3 = (DictOrd@2(K))(V@6),
                case V3 of
                  {eQ} ->
                    findMin({ two
                            , erlang:element(5, V)
                            , erlang:element(6, V)
                            , erlang:element(7, V)
                            , erlang:element(8, V)
                            });
                  {lT} ->
                    { just
                    , begin
                        V@7 = Go(erlang:element(2, V)),
                        case V@7 of
                          {nothing} ->
                            begin
                              {three, _, V@8, V@9, _, _, _, _} = V,
                              #{ key => V@8, value => V@9 }
                            end;
                          {just, V@10} ->
                            V@10;
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end
                    };
                  {gT} ->
                    Go({ two
                       , erlang:element(5, V)
                       , erlang:element(6, V)
                       , erlang:element(7, V)
                       , erlang:element(8, V)
                       });
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Go
  end.

'findMax.go'() ->
  fun
    (V) ->
      fun
        (V1) ->
          'findMax.go'(V, V1)
      end
  end.

'findMax.go'(V, V1) ->
  case V1 of
    {leaf} ->
      V;
    {two, _, V1@1, V1@2, V1@3} ->
      'findMax.go'({just, #{ key => V1@1, value => V1@2 }}, V1@3);
    {three, _, _, _, _, V1@4, V1@5, V1@6} ->
      'findMax.go'({just, #{ key => V1@4, value => V1@5 }}, V1@6);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

findMax() ->
  ('findMax.go'())({nothing}).

lookupLT() ->
  fun
    (DictOrd) ->
      fun
        (K) ->
          lookupLT(DictOrd, K)
      end
  end.

lookupLT(DictOrd, K) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {leaf} ->
              {nothing};
            {two, _, V@1, _, _} ->
              begin
                #{ compare := DictOrd@1 } = DictOrd,
                V2 = (DictOrd@1(K))(V@1),
                case V2 of
                  {eQ} ->
                    findMax(erlang:element(2, V));
                  {gT} ->
                    { just
                    , begin
                        V@2 = Go(erlang:element(5, V)),
                        case V@2 of
                          {nothing} ->
                            begin
                              {two, _, V@3, V@4, _} = V,
                              #{ key => V@3, value => V@4 }
                            end;
                          {just, V@5} ->
                            V@5;
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end
                    };
                  {lT} ->
                    Go(erlang:element(2, V));
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            {three, _, _, _, _, V@6, _, _} ->
              begin
                #{ compare := DictOrd@2 } = DictOrd,
                V3 = (DictOrd@2(K))(V@6),
                case V3 of
                  {eQ} ->
                    findMax({ two
                            , erlang:element(2, V)
                            , erlang:element(3, V)
                            , erlang:element(4, V)
                            , erlang:element(5, V)
                            });
                  {gT} ->
                    { just
                    , begin
                        V@7 = Go(erlang:element(8, V)),
                        case V@7 of
                          {nothing} ->
                            begin
                              {three, _, _, _, _, V@8, V@9, _} = V,
                              #{ key => V@8, value => V@9 }
                            end;
                          {just, V@10} ->
                            V@10;
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end
                    };
                  {lT} ->
                    Go({ two
                       , erlang:element(2, V)
                       , erlang:element(3, V)
                       , erlang:element(4, V)
                       , erlang:element(5, V)
                       });
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Go
  end.

eqMap() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          eqMap(DictEq, DictEq1)
      end
  end.

eqMap(#{ eq := DictEq }, DictEq1) ->
  begin
    Eq1 =
      (data_eq@ps:eqArrayImpl())
      (fun
        (X) ->
          fun
            (Y) ->
              ((DictEq(erlang:element(2, X)))(erlang:element(2, Y)))
                andalso (((erlang:map_get(eq, DictEq1))(erlang:element(3, X)))
                         (erlang:element(3, Y)))
          end
      end),
    #{ eq =>
       fun
         (M1) ->
           fun
             (M2) ->
               begin
                 V = data_unfoldable@ps:unfoldableArray(),
                 (Eq1(toUnfoldable(V, M1)))(toUnfoldable(V, M2))
               end
           end
       end
     }
  end.

ordMap() ->
  fun
    (DictOrd) ->
      ordMap(DictOrd)
  end.

ordMap(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    #{ eq := V } = DictOrd(undefined),
    EqMap1 = (eqMap())(DictOrd(undefined)),
    fun
      (DictOrd1 = #{ 'Eq0' := DictOrd1@1 }) ->
        begin
          EqMap2 = EqMap1(DictOrd1@1(undefined)),
          #{ compare =>
             fun
               (M1) ->
                 fun
                   (M2) ->
                     begin
                       V@1 = data_unfoldable@ps:unfoldableArray(),
                       ((erlang:map_get(
                           compare,
                           data_ord@ps:ordArray(begin
                             V@2 = DictOrd1@1(undefined),
                             EqTuple2 =
                               #{ eq =>
                                  fun
                                    (X) ->
                                      fun
                                        (Y) ->
                                          ((V(erlang:element(2, X)))
                                           (erlang:element(2, Y)))
                                            andalso (((erlang:map_get(eq, V@2))
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
                                          V@3 =
                                            (DictOrd@1(erlang:element(2, X)))
                                            (erlang:element(2, Y)),
                                          case V@3 of
                                            {lT} ->
                                              {lT};
                                            {gT} ->
                                              {gT};
                                            _ ->
                                              begin
                                                #{ compare := DictOrd1@2 } =
                                                  DictOrd1,
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
                           end)
                         ))
                        (toUnfoldable(V@1, M1)))
                       (toUnfoldable(V@1, M2))
                     end
                 end
             end
           , 'Eq0' =>
             fun
               (_) ->
                 EqMap2
             end
           }
        end
    end
  end.

eq1Map() ->
  fun
    (DictEq) ->
      eq1Map(DictEq)
  end.

eq1Map(DictEq) ->
  #{ eq1 =>
     fun
       (DictEq1) ->
         erlang:map_get(eq, eqMap(DictEq, DictEq1))
     end
   }.

ord1Map() ->
  fun
    (DictOrd) ->
      ord1Map(DictOrd)
  end.

ord1Map(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    OrdMap1 = ordMap(DictOrd),
    V = DictOrd@1(undefined),
    Eq1Map1 =
      #{ eq1 =>
         fun
           (DictEq1) ->
             erlang:map_get(eq, eqMap(V, DictEq1))
         end
       },
    #{ compare1 =>
       fun
         (DictOrd1) ->
           erlang:map_get(compare, OrdMap1(DictOrd1))
       end
     , 'Eq10' =>
       fun
         (_) ->
           Eq1Map1
       end
     }
  end.

empty() ->
  {leaf}.

fromFoldable() ->
  fun
    (DictOrd) ->
      fun
        (DictFoldable) ->
          fromFoldable(DictOrd, DictFoldable)
      end
  end.

fromFoldable(DictOrd, #{ foldl := DictFoldable }) ->
  (DictFoldable(fun
     (M) ->
       fun
         (V) ->
           (insert(DictOrd, erlang:element(2, V), erlang:element(3, V)))(M)
       end
   end))
  ({leaf}).

filterWithKey() ->
  fun
    (DictOrd) ->
      filterWithKey(DictOrd)
  end.

filterWithKey(DictOrd) ->
  begin
    FromFoldable1 =
      fromFoldable(DictOrd, data_list_lazy_types@ps:foldableList()),
    fun
      (Predicate) ->
        begin
          V =
            data_list_lazy@ps:filter(fun
              (V) ->
                (Predicate(erlang:element(2, V)))(erlang:element(3, V))
            end),
          fun
            (X) ->
              FromFoldable1(V(toUnfoldable(
                                data_list_lazy_types@ps:unfoldableList(),
                                X
                              )))
          end
        end
    end
  end.

filter() ->
  fun
    (DictOrd) ->
      filter(DictOrd)
  end.

filter(DictOrd) ->
  begin
    FilterWithKey1 = filterWithKey(DictOrd),
    fun
      (Predicate) ->
        FilterWithKey1(fun
          (_) ->
            Predicate
        end)
    end
  end.

filterKeys() ->
  fun
    (DictOrd) ->
      filterKeys(DictOrd)
  end.

filterKeys(DictOrd) ->
  begin
    FilterWithKey1 = filterWithKey(DictOrd),
    fun
      (Predicate) ->
        FilterWithKey1(fun
          (X) ->
            begin
              V = Predicate(X),
              fun
                (_) ->
                  V
              end
            end
        end)
    end
  end.

fromFoldableWithIndex() ->
  fun
    (DictOrd) ->
      fun
        (DictFoldableWithIndex) ->
          fromFoldableWithIndex(DictOrd, DictFoldableWithIndex)
      end
  end.

fromFoldableWithIndex(DictOrd, #{ foldlWithIndex := DictFoldableWithIndex }) ->
  (DictFoldableWithIndex(fun
     (K) ->
       fun
         (M) ->
           fun
             (V) ->
               (insert(DictOrd, K, V))(M)
           end
       end
   end))
  ({leaf}).

intersectionWith() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          fun
            (M1) ->
              fun
                (M2) ->
                  intersectionWith(DictOrd, F, M1, M2)
              end
          end
      end
  end.

intersectionWith(DictOrd, F, M1, M2) ->
  begin
    V = data_list_types@ps:unfoldableList(),
    Go =
      fun
        Go (V@1, V1, V2) ->
          case V@1 of
            {nil} ->
              V2;
            _ ->
              case V1 of
                {nil} ->
                  V2;
                _ ->
                  if
                    ?IS_KNOWN_TAG(cons, 2, V@1)
                      andalso ?IS_KNOWN_TAG(cons, 2, V1) ->
                      begin
                        {cons, V@2, _} = V@1,
                        {cons, V1@1, _} = V1,
                        #{ compare := DictOrd@1 } = DictOrd,
                        V3 =
                          (DictOrd@1(erlang:element(2, V@2)))
                          (erlang:element(2, V1@1)),
                        case V3 of
                          {lT} ->
                            begin
                              V@3 = erlang:element(3, V@1),
                              fun
                                (V2@1) ->
                                  Go(V@3, V1, V2@1)
                              end
                            end
                            (V2);
                          {eQ} ->
                            begin
                              V@4 = erlang:element(3, V@1),
                              V1@2 = erlang:element(3, V1),
                              fun
                                (V2@1) ->
                                  Go(V@4, V1@2, V2@1)
                              end
                            end
                            ((insert(
                                DictOrd,
                                erlang:element(2, V@2),
                                (F(erlang:element(3, V@2)))
                                (erlang:element(3, V1@1))
                              ))
                             (V2));
                          {gT} ->
                            begin
                              V1@3 = erlang:element(3, V1),
                              fun
                                (V2@1) ->
                                  Go(V@1, V1@3, V2@1)
                              end
                            end
                            (V2);
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end;
                    true ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
              end
          end
      end,
    begin
      V@1 = toUnfoldable(V, M1),
      V1 = toUnfoldable(V, M2),
      fun
        (V2) ->
          Go(V@1, V1, V2)
      end
    end
    ({leaf})
  end.

intersection() ->
  fun
    (DictOrd) ->
      intersection(DictOrd)
  end.

intersection(DictOrd) ->
  ((intersectionWith())(DictOrd))(data_function@ps:const()).

delete() ->
  fun
    (DictOrd) ->
      fun
        (K) ->
          fun
            (M) ->
              delete(DictOrd, K, M)
          end
      end
  end.

delete(DictOrd, K, M) ->
  begin
    V = (pop(DictOrd, K))(M),
    case V of
      {nothing} ->
        M;
      {just, V@1} ->
        erlang:element(3, V@1);
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

difference() ->
  fun
    (DictOrd) ->
      fun
        (M1) ->
          fun
            (M2) ->
              difference(DictOrd, M1, M2)
          end
      end
  end.

difference(DictOrd, M1, M2) ->
  begin
    Go =
      fun
        Go (B, V) ->
          case V of
            {nil} ->
              B;
            {cons, V@1, V@2} ->
              begin
                B@1 = delete(DictOrd, V@1, B),
                Go(B@1, V@2)
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V = keys(M2),
    Go(M1, V)
  end.

checkValid() ->
  fun
    (Tree) ->
      checkValid(Tree)
  end.

checkValid(Tree) ->
  begin
    AllHeights =
      fun
        AllHeights (V) ->
          case V of
            {leaf} ->
              {cons, 0, {nil}};
            {two, V@1, _, _, V@2} ->
              (data_list_types@ps:listMap(fun
                 (N) ->
                   N + 1
               end))
              ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
                 (data_list_types@ps:'Cons'()))
                (AllHeights(V@2)))
               (AllHeights(V@1)));
            {three, V@3, _, _, V@4, _, _, V@5} ->
              (data_list_types@ps:listMap(fun
                 (N) ->
                   N + 1
               end))
              ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
                 (data_list_types@ps:'Cons'()))
                ((((erlang:map_get(foldr, data_list_types@ps:foldableList()))
                   (data_list_types@ps:'Cons'()))
                  (AllHeights(V@5)))
                 (AllHeights(V@4))))
               (AllHeights(V@3)));
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    (data_list@ps:length((nub())(AllHeights(Tree)))) =:= 1
  end.

foldableWithIndexMap() ->
  #{ foldlWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (M) ->
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
                                 ((F(erlang:element(2, V@1)))(B))
                                 (erlang:element(3, V@1)),
                               Go(B@1, V@2)
                             end;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end,
                   V = toUnfoldable(data_list_types@ps:unfoldableList(), M),
                   Go(Z, V)
                 end
             end
         end
     end
   , foldrWithIndex =>
     fun
       (F) ->
         fun
           (Z) ->
             fun
               (M) ->
                 (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
                   (fun
                     (V) ->
                       (F(erlang:element(2, V)))(erlang:element(3, V))
                   end))
                  (Z))
                 (toUnfoldable(data_list_types@ps:unfoldableList(), M))
             end
         end
     end
   , foldMapWithIndex =>
     fun
       (DictMonoid) ->
         begin
           FoldMap1 =
             (erlang:map_get(foldMap, data_list_types@ps:foldableList()))
             (DictMonoid),
           fun
             (F) ->
               fun
                 (M) ->
                   (FoldMap1(fun
                      (V) ->
                        (F(erlang:element(2, V)))(erlang:element(3, V))
                    end))
                   (toUnfoldable(data_list_types@ps:unfoldableList(), M))
               end
           end
         end
     end
   , 'Foldable0' =>
     fun
       (_) ->
         foldableMap()
     end
   }.

mapMaybeWithKey() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          mapMaybeWithKey(DictOrd, F)
      end
  end.

mapMaybeWithKey(DictOrd, F) ->
  ((erlang:map_get(foldrWithIndex, foldableWithIndexMap()))
   (fun
     (K) ->
       fun
         (A) ->
           fun
             (Acc) ->
               begin
                 V = (F(K))(A),
                 case V of
                   {nothing} ->
                     Acc;
                   {just, V@1} ->
                     (insert(DictOrd, K, V@1))(Acc);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
               end
           end
       end
   end))
  ({leaf}).

mapMaybe() ->
  fun
    (DictOrd) ->
      fun
        (X) ->
          mapMaybe(DictOrd, X)
      end
  end.

mapMaybe(DictOrd, X) ->
  mapMaybeWithKey(
    DictOrd,
    fun
      (_) ->
        X
    end
  ).

catMaybes() ->
  fun
    (DictOrd) ->
      catMaybes(DictOrd)
  end.

catMaybes(DictOrd) ->
  mapMaybe(DictOrd, identity()).

traversableWithIndexMap() ->
  #{ traverseWithIndex =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1
                           , pure := DictApplicative@2
                           }) ->
         begin
           Apply0 = #{ 'Functor0' := Apply0@1 } = DictApplicative@1(undefined),
           V = Apply0@1(undefined),
           fun
             (V@1) ->
               fun
                 (V1) ->
                   case V1 of
                     {leaf} ->
                       DictApplicative@2({leaf});
                     {two, V1@1, V1@2, V1@3, V1@4} ->
                       begin
                         #{ map := V@2 } = V,
                         #{ apply := Apply0@2 } = Apply0,
                         (Apply0@2((Apply0@2((Apply0@2((V@2('Two'()))
                                                       ((((erlang:map_get(
                                                             traverseWithIndex,
                                                             traversableWithIndexMap()
                                                           ))
                                                          (DictApplicative))
                                                         (V@1))
                                                        (V1@1))))
                                             (DictApplicative@2(V1@2))))
                                   ((V@1(V1@2))(V1@3))))
                         ((((erlang:map_get(
                               traverseWithIndex,
                               traversableWithIndexMap()
                             ))
                            (DictApplicative))
                           (V@1))
                          (V1@4))
                       end;
                     {three, V1@5, V1@6, V1@7, V1@8, V1@9, V1@10, V1@11} ->
                       begin
                         #{ map := V@3 } = V,
                         #{ apply := Apply0@3 } = Apply0,
                         (Apply0@3((Apply0@3((Apply0@3((Apply0@3((Apply0@3((Apply0@3((V@3('Three'()))
                                                                                     ((((erlang:map_get(
                                                                                           traverseWithIndex,
                                                                                           traversableWithIndexMap()
                                                                                         ))
                                                                                        (DictApplicative))
                                                                                       (V@1))
                                                                                      (V1@5))))
                                                                           (DictApplicative@2(V1@6))))
                                                                 ((V@1(V1@6))
                                                                  (V1@7))))
                                                       ((((erlang:map_get(
                                                             traverseWithIndex,
                                                             traversableWithIndexMap()
                                                           ))
                                                          (DictApplicative))
                                                         (V@1))
                                                        (V1@8))))
                                             (DictApplicative@2(V1@9))))
                                   ((V@1(V1@9))(V1@10))))
                         ((((erlang:map_get(
                               traverseWithIndex,
                               traversableWithIndexMap()
                             ))
                            (DictApplicative))
                           (V@1))
                          (V1@11))
                       end;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
         end
     end
   , 'FunctorWithIndex0' =>
     fun
       (_) ->
         functorWithIndexMap()
     end
   , 'FoldableWithIndex1' =>
     fun
       (_) ->
         foldableWithIndexMap()
     end
   , 'Traversable2' =>
     fun
       (_) ->
         traversableMap()
     end
   }.

applyMap() ->
  fun
    (DictOrd) ->
      applyMap(DictOrd)
  end.

applyMap(DictOrd) ->
  #{ apply => ((intersectionWith())(DictOrd))(identity())
   , 'Functor0' =>
     fun
       (_) ->
         functorMap()
     end
   }.

bindMap() ->
  fun
    (DictOrd) ->
      bindMap(DictOrd)
  end.

bindMap(DictOrd) ->
  #{ bind =>
     fun
       (M) ->
         fun
           (F) ->
             (mapMaybeWithKey(
                DictOrd,
                fun
                  (K) ->
                    begin
                      V = lookup(DictOrd, K),
                      fun
                        (X) ->
                          V(F(X))
                      end
                    end
                end
              ))
             (M)
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         #{ apply => ((intersectionWith())(DictOrd))(identity())
          , 'Functor0' =>
            fun
              (_) ->
                functorMap()
            end
          }
     end
   }.

alter() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          fun
            (K) ->
              fun
                (M) ->
                  alter(DictOrd, F, K, M)
              end
          end
      end
  end.

alter(DictOrd, F, K, M) ->
  begin
    V = F((lookup(DictOrd, K))(M)),
    case V of
      {nothing} ->
        delete(DictOrd, K, M);
      {just, V@1} ->
        (insert(DictOrd, K, V@1))(M);
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

fromFoldableWith() ->
  fun
    (DictOrd) ->
      fun
        (DictFoldable) ->
          fun
            (F) ->
              fromFoldableWith(DictOrd, DictFoldable, F)
          end
      end
  end.

fromFoldableWith(DictOrd, #{ foldl := DictFoldable }, F) ->
  (DictFoldable(fun
     (M) ->
       fun
         (V) ->
           begin
             V@1 = erlang:element(3, V),
             alter(
               DictOrd,
               fun
                 (V1) ->
                   case V1 of
                     {just, V1@1} ->
                       {just, (F(V@1))(V1@1)};
                     {nothing} ->
                       {just, V@1};
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end,
               erlang:element(2, V),
               M
             )
           end
       end
   end))
  ({leaf}).

insertWith() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          fun
            (K) ->
              fun
                (V) ->
                  insertWith(DictOrd, F, K, V)
              end
          end
      end
  end.

insertWith(DictOrd, F, K, V) ->
  (((alter())(DictOrd))
   (fun
     (X) ->
       { just
       , case X of
           {nothing} ->
             V;
           {just, X@1} ->
             (F(X@1))(V);
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
       }
   end))
  (K).

unionWith() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          fun
            (M1) ->
              fun
                (M2) ->
                  unionWith(DictOrd, F, M1, M2)
              end
          end
      end
  end.

unionWith(DictOrd, F, M1, M2) ->
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
                  begin
                    V@3 = erlang:element(3, V@1),
                    alter(
                      DictOrd,
                      begin
                        V@4 = F(V@3),
                        fun
                          (X) ->
                            { just
                            , case X of
                                {nothing} ->
                                  V@3;
                                {just, X@1} ->
                                  V@4(X@1);
                                _ ->
                                  erlang:error({ fail
                                               , <<"Failed pattern match">>
                                               })
                              end
                            }
                        end
                      end,
                      erlang:element(2, V@1),
                      B
                    )
                  end,
                Go(B@1, V@2)
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V = toUnfoldable(data_list_types@ps:unfoldableList(), M1),
    Go(M2, V)
  end.

union() ->
  fun
    (DictOrd) ->
      union(DictOrd)
  end.

union(DictOrd) ->
  ((unionWith())(DictOrd))(data_function@ps:const()).

submap() ->
  fun
    (DictOrd) ->
      fun
        (Kmin) ->
          fun
            (Kmax) ->
              submap(DictOrd, Kmin, Kmax)
          end
      end
  end.

submap(DictOrd, Kmin, Kmax) ->
  foldSubmapBy(DictOrd, union(DictOrd), {leaf}, Kmin, Kmax, singleton()).

unions() ->
  fun
    (DictOrd) ->
      fun
        (DictFoldable) ->
          unions(DictOrd, DictFoldable)
      end
  end.

unions(DictOrd, #{ foldl := DictFoldable }) ->
  (DictFoldable(union(DictOrd)))({leaf}).

update() ->
  fun
    (DictOrd) ->
      fun
        (F) ->
          fun
            (K) ->
              fun
                (M) ->
                  update(DictOrd, F, K, M)
              end
          end
      end
  end.

update(DictOrd, F, K, M) ->
  alter(
    DictOrd,
    fun
      (V2) ->
        case V2 of
          {nothing} ->
            {nothing};
          {just, V2@1} ->
            F(V2@1);
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
    end,
    K,
    M
  ).

altMap() ->
  fun
    (DictOrd) ->
      altMap(DictOrd)
  end.

altMap(DictOrd) ->
  #{ alt => union(DictOrd)
   , 'Functor0' =>
     fun
       (_) ->
         functorMap()
     end
   }.

plusMap() ->
  fun
    (DictOrd) ->
      plusMap(DictOrd)
  end.

plusMap(DictOrd) ->
  #{ empty => {leaf}
   , 'Alt0' =>
     fun
       (_) ->
         #{ alt => union(DictOrd)
          , 'Functor0' =>
            fun
              (_) ->
                functorMap()
            end
          }
     end
   }.

findMin(V) ->
  'findMin.go'({nothing}, V).

findMax(V) ->
  'findMax.go'({nothing}, V).

