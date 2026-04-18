-module(data_witherable@ps).
-export([ identity/0
        , identity/1
        , witherableMaybe/0
        , witherableEither/0
        , witherableEither/1
        , witherDefault/0
        , witherDefault/1
        , wither/0
        , wither/1
        , withered/0
        , withered/2
        , wiltDefault/0
        , wiltDefault/1
        , witherableArray/0
        , witherableList/0
        , witherableMap/0
        , witherableMap/1
        , wilt/0
        , wilt/1
        , wilted/0
        , wilted/2
        , traverseByWither/0
        , traverseByWither/2
        , partitionMapByWilt/0
        , partitionMapByWilt/1
        , filterMapByWither/0
        , filterMapByWither/1
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

witherableMaybe() ->
  #{ wilt =>
     fun
       (DictApplicative) ->
         fun
           (V) ->
             fun
               (V1) ->
                 case V1 of
                   {nothing} ->
                     (erlang:map_get(pure, DictApplicative))
                     (#{ left => {nothing}, right => {nothing} });
                   {just, V1@1} ->
                     ((erlang:map_get(
                         map,
                         (erlang:map_get(
                            'Functor0',
                            (erlang:map_get('Apply0', DictApplicative))
                            (undefined)
                          ))
                         (undefined)
                       ))
                      (fun
                        (V2) ->
                          case V2 of
                            {left, V2@1} ->
                              #{ left => {just, V2@1}, right => {nothing} };
                            {right, V2@2} ->
                              #{ left => {nothing}, right => {just, V2@2} };
                            _ ->
                              erlang:error({fail, <<"Failed pattern match">>})
                          end
                      end))
                     (V(V1@1));
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , wither =>
     fun
       (DictApplicative) ->
         fun
           (V) ->
             fun
               (V1) ->
                 case V1 of
                   {nothing} ->
                     begin
                       #{ pure := DictApplicative@1 } = DictApplicative,
                       DictApplicative@1({nothing})
                     end;
                   {just, V1@1} ->
                     V(V1@1);
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   , 'Filterable0' =>
     fun
       (_) ->
         data_filterable@ps:filterableMaybe()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         data_traversable@ps:traversableMaybe()
     end
   }.

witherableEither() ->
  fun
    (DictMonoid) ->
      witherableEither(DictMonoid)
  end.

witherableEither(DictMonoid = #{ mempty := DictMonoid@1 }) ->
  begin
    FilterableEither = data_filterable@ps:filterableEither(DictMonoid),
    #{ wilt =>
       fun
         (DictApplicative) ->
           fun
             (V) ->
               fun
                 (V1) ->
                   case V1 of
                     {left, V1@1} ->
                       (erlang:map_get(pure, DictApplicative))
                       (#{ left => {left, V1@1}, right => {left, V1@1} });
                     {right, V1@2} ->
                       ((erlang:map_get(
                           map,
                           (erlang:map_get(
                              'Functor0',
                              (erlang:map_get('Apply0', DictApplicative))
                              (undefined)
                            ))
                           (undefined)
                         ))
                        (fun
                          (V2) ->
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
                        end))
                       (V(V1@2));
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
       end
     , wither =>
       fun
         (DictApplicative) ->
           fun
             (V) ->
               fun
                 (V1) ->
                   case V1 of
                     {left, V1@1} ->
                       (erlang:map_get(pure, DictApplicative))({left, V1@1});
                     {right, V1@2} ->
                       ((erlang:map_get(
                           map,
                           (erlang:map_get(
                              'Functor0',
                              (erlang:map_get('Apply0', DictApplicative))
                              (undefined)
                            ))
                           (undefined)
                         ))
                        (fun
                          (V2) ->
                            case V2 of
                              {nothing} ->
                                {left, DictMonoid@1};
                              {just, V2@1} ->
                                {right, V2@1};
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end
                        end))
                       (V(V1@2));
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
       end
     , 'Filterable0' =>
       fun
         (_) ->
           FilterableEither
       end
     , 'Traversable1' =>
       fun
         (_) ->
           data_traversable@ps:traversableEither()
       end
     }
  end.

witherDefault() ->
  fun
    (DictWitherable) ->
      witherDefault(DictWitherable)
  end.

witherDefault(#{ 'Filterable0' := DictWitherable
               , 'Traversable1' := DictWitherable@1
               }) ->
  begin
    Compact =
      erlang:map_get(
        compact,
        (erlang:map_get('Compactable0', DictWitherable(undefined)))(undefined)
      ),
    fun
      (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
        begin
          Traverse1 =
            (erlang:map_get(traverse, DictWitherable@1(undefined)))
            (DictApplicative),
          fun
            (P) ->
              begin
                V =
                  (erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined)
                   ))
                  (Compact),
                V@1 = Traverse1(P),
                fun
                  (X) ->
                    V(V@1(X))
                end
              end
          end
        end
    end
  end.

wither() ->
  fun
    (Dict) ->
      wither(Dict)
  end.

wither(#{ wither := Dict }) ->
  Dict.

withered() ->
  fun
    (DictWitherable) ->
      fun
        (DictApplicative) ->
          withered(DictWitherable, DictApplicative)
      end
  end.

withered(#{ wither := DictWitherable }, DictApplicative) ->
  (DictWitherable(DictApplicative))(identity()).

wiltDefault() ->
  fun
    (DictWitherable) ->
      wiltDefault(DictWitherable)
  end.

wiltDefault(#{ 'Filterable0' := DictWitherable
             , 'Traversable1' := DictWitherable@1
             }) ->
  begin
    Separate =
      erlang:map_get(
        separate,
        (erlang:map_get('Compactable0', DictWitherable(undefined)))(undefined)
      ),
    fun
      (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
        begin
          Traverse1 =
            (erlang:map_get(traverse, DictWitherable@1(undefined)))
            (DictApplicative),
          fun
            (P) ->
              begin
                V =
                  (erlang:map_get(
                     map,
                     (erlang:map_get('Functor0', DictApplicative@1(undefined)))
                     (undefined)
                   ))
                  (Separate),
                V@1 = Traverse1(P),
                fun
                  (X) ->
                    V(V@1(X))
                end
              end
          end
        end
    end
  end.

witherableArray() ->
  #{ wilt =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           V = witherableArray(),
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
           V = witherableArray(),
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
         data_filterable@ps:filterableArray()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         data_traversable@ps:traversableArray()
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
         data_filterable@ps:filterableList()
     end
   , 'Traversable1' =>
     fun
       (_) ->
         data_list_types@ps:traversableList()
     end
   }.

witherableMap() ->
  fun
    (DictOrd) ->
      witherableMap(DictOrd)
  end.

witherableMap(DictOrd) ->
  begin
    FilterableMap = data_filterable@ps:filterableMap(DictOrd),
    #{ wilt =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             #{ 'Filterable0' := V, 'Traversable1' := V@1 } =
               witherableMap(DictOrd),
             Separate =
               erlang:map_get(
                 separate,
                 (erlang:map_get('Compactable0', V(undefined)))(undefined)
               ),
             Traverse1 =
               (erlang:map_get(traverse, V@1(undefined)))(DictApplicative),
             fun
               (P) ->
                 begin
                   V@2 =
                     (erlang:map_get(
                        map,
                        (erlang:map_get(
                           'Functor0',
                           DictApplicative@1(undefined)
                         ))
                        (undefined)
                      ))
                     (Separate),
                   V@3 = Traverse1(P),
                   fun
                     (X) ->
                       V@2(V@3(X))
                   end
                 end
             end
           end
       end
     , wither =>
       fun
         (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
           begin
             #{ 'Filterable0' := V, 'Traversable1' := V@1 } =
               witherableMap(DictOrd),
             Compact =
               erlang:map_get(
                 compact,
                 (erlang:map_get('Compactable0', V(undefined)))(undefined)
               ),
             Traverse1 =
               (erlang:map_get(traverse, V@1(undefined)))(DictApplicative),
             fun
               (P) ->
                 begin
                   V@2 =
                     (erlang:map_get(
                        map,
                        (erlang:map_get(
                           'Functor0',
                           DictApplicative@1(undefined)
                         ))
                        (undefined)
                      ))
                     (Compact),
                   V@3 = Traverse1(P),
                   fun
                     (X) ->
                       V@2(V@3(X))
                   end
                 end
             end
           end
       end
     , 'Filterable0' =>
       fun
         (_) ->
           FilterableMap
       end
     , 'Traversable1' =>
       fun
         (_) ->
           data_map_internal@ps:traversableMap()
       end
     }
  end.

wilt() ->
  fun
    (Dict) ->
      wilt(Dict)
  end.

wilt(#{ wilt := Dict }) ->
  Dict.

wilted() ->
  fun
    (DictWitherable) ->
      fun
        (DictApplicative) ->
          wilted(DictWitherable, DictApplicative)
      end
  end.

wilted(#{ wilt := DictWitherable }, DictApplicative) ->
  (DictWitherable(DictApplicative))(identity()).

traverseByWither() ->
  fun
    (DictWitherable) ->
      fun
        (DictApplicative) ->
          traverseByWither(DictWitherable, DictApplicative)
      end
  end.

traverseByWither( #{ wither := DictWitherable }
                , DictApplicative = #{ 'Apply0' := DictApplicative@1 }
                ) ->
  begin
    Wither2 = DictWitherable(DictApplicative),
    fun
      (F) ->
        Wither2(begin
          V =
            (erlang:map_get(
               map,
               (erlang:map_get('Functor0', DictApplicative@1(undefined)))
               (undefined)
             ))
            (data_maybe@ps:'Just'()),
          fun
            (X) ->
              V(F(X))
          end
        end)
    end
  end.

partitionMapByWilt() ->
  fun
    (DictWitherable) ->
      partitionMapByWilt(DictWitherable)
  end.

partitionMapByWilt(#{ wilt := DictWitherable }) ->
  begin
    Wilt1 = DictWitherable(data_identity@ps:applicativeIdentity()),
    fun
      (P) ->
        Wilt1(fun
          (X) ->
            P(X)
        end)
    end
  end.

filterMapByWither() ->
  fun
    (DictWitherable) ->
      filterMapByWither(DictWitherable)
  end.

filterMapByWither(#{ wither := DictWitherable }) ->
  begin
    Wither1 = DictWitherable(data_identity@ps:applicativeIdentity()),
    fun
      (P) ->
        Wither1(fun
          (X) ->
            P(X)
        end)
    end
  end.

