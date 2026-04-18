-module(data_filterable@ps).
-export([ partitionMapDefault/0
        , partitionMapDefault/2
        , partitionMap/0
        , partitionMap/1
        , partition/0
        , partition/1
        , maybeBool/0
        , maybeBool/2
        , filterableList/0
        , filterableArray/0
        , filterMapDefault/0
        , filterMapDefault/2
        , filterMap/0
        , filterMap/1
        , partitionDefaultFilterMap/0
        , partitionDefaultFilterMap/3
        , filterDefaultPartition/0
        , filterDefaultPartition/3
        , filterDefault/0
        , filterDefault/2
        , filter/0
        , filter/1
        , partitionDefaultFilter/0
        , partitionDefaultFilter/3
        , eitherBool/0
        , eitherBool/2
        , filterDefaultPartitionMap/0
        , filterDefaultPartitionMap/3
        , partitionDefault/0
        , partitionDefault/3
        , filterableEither/0
        , filterableEither/1
        , filterableMap/0
        , filterableMap/1
        , filterableMaybe/0
        , cleared/0
        , cleared/1
        ]).
-compile(no_auto_import).
partitionMapDefault() ->
  fun
    (DictFilterable) ->
      fun
        (P) ->
          partitionMapDefault(DictFilterable, P)
      end
  end.

partitionMapDefault( #{ 'Compactable0' := DictFilterable
                      , 'Functor1' := DictFilterable@1
                      }
                   , P
                   ) ->
  begin
    V = (erlang:map_get(map, DictFilterable@1(undefined)))(P),
    fun
      (X) ->
        (erlang:map_get(separate, DictFilterable(undefined)))(V(X))
    end
  end.

partitionMap() ->
  fun
    (Dict) ->
      partitionMap(Dict)
  end.

partitionMap(#{ partitionMap := Dict }) ->
  Dict.

partition() ->
  fun
    (Dict) ->
      partition(Dict)
  end.

partition(#{ partition := Dict }) ->
  Dict.

maybeBool() ->
  fun
    (P) ->
      fun
        (X) ->
          maybeBool(P, X)
      end
  end.

maybeBool(P, X) ->
  case P(X) of
    true ->
      {just, X};
    _ ->
      {nothing}
  end.

filterableList() ->
  #{ partitionMap =>
     fun
       (P) ->
         fun
           (Xs) ->
             (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
               (fun
                 (X) ->
                   fun
                     (#{ left := V, right := V@1 }) ->
                       begin
                         V1 = P(X),
                         case V1 of
                           {left, V1@1} ->
                             #{ left => {cons, V1@1, V}, right => V@1 };
                           {right, V1@2} ->
                             #{ left => V, right => {cons, V1@2, V@1} };
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                       end
                   end
               end))
              (#{ left => {nil}, right => {nil} }))
             (Xs)
         end
     end
   , partition =>
     fun
       (P) ->
         fun
           (Xs) ->
             (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
               (fun
                 (X) ->
                   fun
                     (#{ no := V, yes := V@1 }) ->
                       case P(X) of
                         true ->
                           #{ no => V, yes => {cons, X, V@1} };
                         _ ->
                           #{ no => {cons, X, V}, yes => V@1 }
                       end
                   end
               end))
              (#{ no => {nil}, yes => {nil} }))
             (Xs)
         end
     end
   , filterMap =>
     fun
       (P) ->
         data_list@ps:mapMaybe(P)
     end
   , filter => data_list@ps:filter()
   , 'Compactable0' =>
     fun
       (_) ->
         data_compactable@ps:compactableList()
     end
   , 'Functor1' =>
     fun
       (_) ->
         data_list_types@ps:functorList()
     end
   }.

filterableArray() ->
  #{ partitionMap =>
     fun
       (P) ->
         ((data_foldable@ps:foldlArray())
          (fun
            (Acc) ->
              fun
                (X) ->
                  begin
                    V = P(X),
                    case V of
                      {left, V@1} ->
                        Acc#{ left =>
                            data_semigroup@foreign:concatArray(
                              erlang:map_get(left, Acc),
                              array:from_list([V@1])
                            )
                            };
                      {right, V@2} ->
                        Acc#{ right =>
                            data_semigroup@foreign:concatArray(
                              erlang:map_get(right, Acc),
                              array:from_list([V@2])
                            )
                            };
                      _ ->
                        erlang:error({fail, <<"Failed pattern match">>})
                    end
                  end
              end
          end))
         (#{ left => array:from_list([]), right => array:from_list([]) })
     end
   , partition => data_array@ps:partition()
   , filterMap => data_array@ps:mapMaybe()
   , filter => data_array@ps:filter()
   , 'Compactable0' =>
     fun
       (_) ->
         data_compactable@ps:compactableArray()
     end
   , 'Functor1' =>
     fun
       (_) ->
         data_functor@ps:functorArray()
     end
   }.

filterMapDefault() ->
  fun
    (DictFilterable) ->
      fun
        (P) ->
          filterMapDefault(DictFilterable, P)
      end
  end.

filterMapDefault( #{ 'Compactable0' := DictFilterable
                   , 'Functor1' := DictFilterable@1
                   }
                , P
                ) ->
  begin
    V = (erlang:map_get(map, DictFilterable@1(undefined)))(P),
    fun
      (X) ->
        (erlang:map_get(compact, DictFilterable(undefined)))(V(X))
    end
  end.

filterMap() ->
  fun
    (Dict) ->
      filterMap(Dict)
  end.

filterMap(#{ filterMap := Dict }) ->
  Dict.

partitionDefaultFilterMap() ->
  fun
    (DictFilterable) ->
      fun
        (P) ->
          fun
            (Xs) ->
              partitionDefaultFilterMap(DictFilterable, P, Xs)
          end
      end
  end.

partitionDefaultFilterMap(#{ filterMap := DictFilterable }, P, Xs) ->
  #{ yes =>
     (DictFilterable(fun
        (X) ->
          case P(X) of
            true ->
              {just, X};
            _ ->
              {nothing}
          end
      end))
     (Xs)
   , no =>
     (DictFilterable(fun
        (X) ->
          case not (P(X)) of
            true ->
              {just, X};
            _ ->
              {nothing}
          end
      end))
     (Xs)
   }.

filterDefaultPartition() ->
  fun
    (DictFilterable) ->
      fun
        (P) ->
          fun
            (Xs) ->
              filterDefaultPartition(DictFilterable, P, Xs)
          end
      end
  end.

filterDefaultPartition(#{ partition := DictFilterable }, P, Xs) ->
  erlang:map_get(yes, (DictFilterable(P))(Xs)).

filterDefault() ->
  fun
    (DictFilterable) ->
      fun
        (X) ->
          filterDefault(DictFilterable, X)
      end
  end.

filterDefault(#{ filterMap := DictFilterable }, X) ->
  DictFilterable(fun
    (X@1) ->
      case X(X@1) of
        true ->
          {just, X@1};
        _ ->
          {nothing}
      end
  end).

filter() ->
  fun
    (Dict) ->
      filter(Dict)
  end.

filter(#{ filter := Dict }) ->
  Dict.

partitionDefaultFilter() ->
  fun
    (DictFilterable) ->
      fun
        (P) ->
          fun
            (Xs) ->
              partitionDefaultFilter(DictFilterable, P, Xs)
          end
      end
  end.

partitionDefaultFilter(#{ filter := DictFilterable }, P, Xs) ->
  #{ yes => (DictFilterable(P))(Xs)
   , no =>
     (DictFilterable(fun
        (A) ->
          not (P(A))
      end))
     (Xs)
   }.

eitherBool() ->
  fun
    (P) ->
      fun
        (X) ->
          eitherBool(P, X)
      end
  end.

eitherBool(P, X) ->
  case P(X) of
    true ->
      {right, X};
    _ ->
      {left, X}
  end.

filterDefaultPartitionMap() ->
  fun
    (DictFilterable) ->
      fun
        (P) ->
          fun
            (Xs) ->
              filterDefaultPartitionMap(DictFilterable, P, Xs)
          end
      end
  end.

filterDefaultPartitionMap(#{ partitionMap := DictFilterable }, P, Xs) ->
  erlang:map_get(
    right,
    (DictFilterable(fun
       (X) ->
         case P(X) of
           true ->
             {right, X};
           _ ->
             {left, X}
         end
     end))
    (Xs)
  ).

partitionDefault() ->
  fun
    (DictFilterable) ->
      fun
        (P) ->
          fun
            (Xs) ->
              partitionDefault(DictFilterable, P, Xs)
          end
      end
  end.

partitionDefault(#{ partitionMap := DictFilterable }, P, Xs) ->
  begin
    #{ left := O, right := O@1 } =
      (DictFilterable(fun
         (X) ->
           case P(X) of
             true ->
               {right, X};
             _ ->
               {left, X}
           end
       end))
      (Xs),
    #{ no => O, yes => O@1 }
  end.

filterableEither() ->
  fun
    (DictMonoid) ->
      filterableEither(DictMonoid)
  end.

filterableEither(DictMonoid = #{ mempty := DictMonoid@1 }) ->
  begin
    CompactableEither =
      #{ compact =>
         fun
           (V) ->
             case V of
               {left, V@1} ->
                 {left, V@1};
               {right, V@2} ->
                 case V@2 of
                   {just, V@3} ->
                     {right, V@3};
                   {nothing} ->
                     {left, DictMonoid@1};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
       , separate =>
         fun
           (V) ->
             case V of
               {left, V@1} ->
                 #{ left => {left, V@1}, right => {left, V@1} };
               {right, V@2} ->
                 case V@2 of
                   {left, V@3} ->
                     #{ left => {right, V@3}, right => {left, DictMonoid@1} };
                   {right, V@4} ->
                     #{ left => {left, DictMonoid@1}, right => {right, V@4} };
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
       },
    #{ partitionMap =>
       fun
         (V) ->
           fun
             (V1) ->
               case V1 of
                 {left, V1@1} ->
                   #{ left => {left, V1@1}, right => {left, V1@1} };
                 {right, V1@2} ->
                   begin
                     V2 = V(V1@2),
                     case V2 of
                       {left, V2@1} ->
                         #{ left => {right, V2@1}
                          , right => {left, DictMonoid@1}
                          };
                       {right, V2@2} ->
                         #{ left => {left, DictMonoid@1}
                          , right => {right, V2@2}
                          };
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                   end;
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
           end
       end
     , partition =>
       fun
         (P) ->
           begin
             #{ partitionMap := V } = filterableEither(DictMonoid),
             fun
               (Xs) ->
                 begin
                   #{ left := O, right := O@1 } =
                     (V(fun
                        (X) ->
                          case P(X) of
                            true ->
                              {right, X};
                            _ ->
                              {left, X}
                          end
                      end))
                     (Xs),
                   #{ no => O, yes => O@1 }
                 end
             end
           end
       end
     , filterMap =>
       fun
         (V) ->
           fun
             (V1) ->
               case V1 of
                 {left, V1@1} ->
                   {left, V1@1};
                 {right, V1@2} ->
                   begin
                     V2 = V(V1@2),
                     case V2 of
                       {nothing} ->
                         {left, DictMonoid@1};
                       {just, V2@1} ->
                         {right, V2@1};
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                   end;
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
           end
       end
     , filter =>
       fun
         (P) ->
           (erlang:map_get(filterMap, filterableEither(DictMonoid)))
           (fun
             (X) ->
               case P(X) of
                 true ->
                   {just, X};
                 _ ->
                   {nothing}
               end
           end)
       end
     , 'Compactable0' =>
       fun
         (_) ->
           CompactableEither
       end
     , 'Functor1' =>
       fun
         (_) ->
           data_either@ps:functorEither()
       end
     }
  end.

filterableMap() ->
  fun
    (DictOrd) ->
      filterableMap(DictOrd)
  end.

filterableMap(DictOrd) ->
  begin
    CompactableMap = data_compactable@ps:compactableMap(DictOrd),
    #{ partitionMap =>
       fun
         (P) ->
           fun
             (Xs) ->
               (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
                 (fun
                   (V) ->
                     fun
                       (#{ left := V1, right := V1@1 }) ->
                         begin
                           V2 = P(erlang:element(3, V)),
                           case V2 of
                             {left, V2@1} ->
                               #{ left =>
                                  (data_map_internal@ps:insert(
                                     DictOrd,
                                     erlang:element(2, V),
                                     V2@1
                                   ))
                                  (V1)
                                , right => V1@1
                                };
                             {right, V2@2} ->
                               #{ left => V1
                                , right =>
                                  (data_map_internal@ps:insert(
                                     DictOrd,
                                     erlang:element(2, V),
                                     V2@2
                                   ))
                                  (V1@1)
                                };
                             _ ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                         end
                     end
                 end))
                (#{ left => {leaf}, right => {leaf} }))
               (data_map_internal@ps:toUnfoldable(
                  data_list_types@ps:unfoldableList(),
                  Xs
                ))
           end
       end
     , partition =>
       fun
         (P) ->
           begin
             #{ partitionMap := V } = filterableMap(DictOrd),
             fun
               (Xs) ->
                 begin
                   #{ left := O, right := O@1 } =
                     (V(fun
                        (X) ->
                          case P(X) of
                            true ->
                              {right, X};
                            _ ->
                              {left, X}
                          end
                      end))
                     (Xs),
                   #{ no => O, yes => O@1 }
                 end
             end
           end
       end
     , filterMap =>
       fun
         (P) ->
           fun
             (Xs) ->
               (((erlang:map_get(foldr, data_list_types@ps:foldableList()))
                 (fun
                   (V) ->
                     fun
                       (M) ->
                         data_map_internal@ps:alter(
                           DictOrd,
                           begin
                             V@1 = P(erlang:element(3, V)),
                             fun
                               (_) ->
                                 V@1
                             end
                           end,
                           erlang:element(2, V),
                           M
                         )
                     end
                 end))
                ({leaf}))
               (data_map_internal@ps:toUnfoldable(
                  data_list_types@ps:unfoldableList(),
                  Xs
                ))
           end
       end
     , filter =>
       fun
         (P) ->
           (erlang:map_get(filterMap, filterableMap(DictOrd)))
           (fun
             (X) ->
               case P(X) of
                 true ->
                   {just, X};
                 _ ->
                   {nothing}
               end
           end)
       end
     , 'Compactable0' =>
       fun
         (_) ->
           CompactableMap
       end
     , 'Functor1' =>
       fun
         (_) ->
           data_map_internal@ps:functorMap()
       end
     }
  end.

filterableMaybe() ->
  #{ partitionMap =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {nothing} ->
                 #{ left => {nothing}, right => {nothing} };
               {just, V1@1} ->
                 begin
                   V2 = V(V1@1),
                   case V2 of
                     {left, V2@1} ->
                       #{ left => {just, V2@1}, right => {nothing} };
                     {right, V2@2} ->
                       #{ left => {nothing}, right => {just, V2@2} };
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , partition =>
     fun
       (P) ->
         fun
           (Xs) ->
             begin
               #{ left := O, right := O@1 } =
                 ((erlang:map_get(partitionMap, filterableMaybe()))
                  (fun
                    (X) ->
                      case P(X) of
                        true ->
                          {right, X};
                        _ ->
                          {left, X}
                      end
                  end))
                 (Xs),
               #{ no => O, yes => O@1 }
             end
         end
     end
   , filterMap =>
     fun
       (B) ->
         fun
           (A) ->
             case A of
               {just, A@1} ->
                 B(A@1);
               {nothing} ->
                 {nothing};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , filter =>
     fun
       (P) ->
         (erlang:map_get(filterMap, filterableMaybe()))
         (fun
           (X) ->
             case P(X) of
               true ->
                 {just, X};
               _ ->
                 {nothing}
             end
         end)
     end
   , 'Compactable0' =>
     fun
       (_) ->
         data_compactable@ps:compactableMaybe()
     end
   , 'Functor1' =>
     fun
       (_) ->
         data_maybe@ps:functorMaybe()
     end
   }.

cleared() ->
  fun
    (DictFilterable) ->
      cleared(DictFilterable)
  end.

cleared(#{ filterMap := DictFilterable }) ->
  DictFilterable(fun
    (_) ->
      {nothing}
  end).

