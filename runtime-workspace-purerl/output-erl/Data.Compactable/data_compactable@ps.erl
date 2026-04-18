-module(data_compactable@ps).
-export([ separateSequence/0
        , separateSequence/1
        , separateSequence1/0
        , separateSequence2/0
        , separate/0
        , separate/1
        , compactableMaybe/0
        , compactableMap/0
        , compactableMap/1
        , compactableList/0
        , compactableEither/0
        , compactableEither/1
        , compactableArray/0
        , compactDefault/0
        , compactDefault/2
        , compact/0
        , compact/1
        , separateDefault/0
        , separateDefault/3
        , bindMaybe/0
        , bindMaybe/3
        , bindEither/0
        , bindEither/3
        , applyMaybe/0
        , applyMaybe/3
        , applyEither/0
        , applyEither/3
        ]).
-compile(no_auto_import).
separateSequence() ->
  fun
    (DictAlternative) ->
      separateSequence(DictAlternative)
  end.

separateSequence(#{ 'Applicative0' := DictAlternative
                  , 'Plus1' := DictAlternative@1
                  }) ->
  begin
    #{ 'Alt0' := Plus1, empty := Plus1@1 } = DictAlternative@1(undefined),
    #{ alt := V } = Plus1(undefined),
    #{ pure := V@1 } = DictAlternative(undefined),
    fun
      (#{ foldl := DictFoldable }) ->
        fun
          (_) ->
            (DictFoldable(fun
               (Acc) ->
                 fun
                   (V@2) ->
                     case V@2 of
                       {left, V@3} ->
                         Acc#{ left => (V(erlang:map_get(left, Acc)))(V@1(V@3))
                             };
                       {right, V@4} ->
                         Acc#{ right =>
                             (V(erlang:map_get(right, Acc)))(V@1(V@4))
                             };
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end
             end))
            (#{ left => Plus1@1, right => Plus1@1 })
        end
    end
  end.

separateSequence1() ->
  (separateSequence(data_list_types@ps:alternativeList()))
  (data_list_types@ps:foldableList()).

separateSequence2() ->
  (separateSequence(control_alternative@ps:alternativeArray()))
  (data_foldable@ps:foldableArray()).

separate() ->
  fun
    (Dict) ->
      separate(Dict)
  end.

separate(#{ separate := Dict }) ->
  Dict.

compactableMaybe() ->
  #{ compact =>
     fun
       (M) ->
         case M of
           {just, M@1} ->
             M@1;
           {nothing} ->
             {nothing};
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , separate =>
     fun
       (V) ->
         case V of
           {nothing} ->
             #{ left => {nothing}, right => {nothing} };
           {just, V@1} ->
             case V@1 of
               {left, V@2} ->
                 #{ left => {just, V@2}, right => {nothing} };
               {right, V@3} ->
                 #{ left => {nothing}, right => {just, V@3} };
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

compactableMap() ->
  fun
    (DictOrd) ->
      compactableMap(DictOrd)
  end.

compactableMap(DictOrd) ->
  begin
    V = data_list_types@ps:foldableList(),
    #{ compact =>
       begin
         V@1 =
           ((erlang:map_get(foldr, V))
            (fun
              (V@1) ->
                fun
                  (M) ->
                    begin
                      V@2 = erlang:element(3, V@1),
                      data_map_internal@ps:alter(
                        DictOrd,
                        fun
                          (_) ->
                            V@2
                        end,
                        erlang:element(2, V@1),
                        M
                      )
                    end
                end
            end))
           ({leaf}),
         fun
           (X) ->
             V@1(data_map_internal@ps:toUnfoldable(
                   data_list_types@ps:unfoldableList(),
                   X
                 ))
         end
       end
     , separate =>
       begin
         V@2 =
           ((erlang:map_get(foldr, V))
            (fun
              (V@2) ->
                fun
                  (#{ left := V1, right := V1@1 }) ->
                    case erlang:element(3, V@2) of
                      {left, _} ->
                        #{ left =>
                           (data_map_internal@ps:insert(
                              DictOrd,
                              erlang:element(2, V@2),
                              erlang:element(2, erlang:element(3, V@2))
                            ))
                           (V1)
                         , right => V1@1
                         };
                      {right, _} ->
                        #{ left => V1
                         , right =>
                           (data_map_internal@ps:insert(
                              DictOrd,
                              erlang:element(2, V@2),
                              erlang:element(2, erlang:element(3, V@2))
                            ))
                           (V1@1)
                         };
                      _ ->
                        erlang:error({fail, <<"Failed pattern match">>})
                    end
                end
            end))
           (#{ left => {leaf}, right => {leaf} }),
         fun
           (X) ->
             V@2(data_map_internal@ps:toUnfoldable(
                   data_list_types@ps:unfoldableList(),
                   X
                 ))
         end
       end
     }
  end.

compactableList() ->
  #{ compact => data_list@ps:catMaybes()
   , separate =>
     fun
       (Xs) ->
         ((separateSequence1())(compactableList()))(Xs)
     end
   }.

compactableEither() ->
  fun
    (DictMonoid) ->
      compactableEither(DictMonoid)
  end.

compactableEither(#{ mempty := DictMonoid }) ->
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
                 {left, DictMonoid};
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
                 #{ left => {right, V@3}, right => {left, DictMonoid} };
               {right, V@4} ->
                 #{ left => {left, DictMonoid}, right => {right, V@4} };
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

compactableArray() ->
  #{ compact => data_array@ps:catMaybes()
   , separate =>
     fun
       (Xs) ->
         ((separateSequence2())(compactableArray()))(Xs)
     end
   }.

compactDefault() ->
  fun
    (DictFunctor) ->
      fun
        (DictCompactable) ->
          compactDefault(DictFunctor, DictCompactable)
      end
  end.

compactDefault(#{ map := DictFunctor }, #{ separate := DictCompactable }) ->
  begin
    V =
      DictFunctor(fun
        (V2) ->
          case V2 of
            {nothing} ->
              {left, unit};
            {just, V2@1} ->
              {right, V2@1};
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end),
    fun
      (X) ->
        erlang:map_get(right, DictCompactable(V(X)))
    end
  end.

compact() ->
  fun
    (Dict) ->
      compact(Dict)
  end.

compact(#{ compact := Dict }) ->
  Dict.

separateDefault() ->
  fun
    (DictFunctor) ->
      fun
        (DictCompactable) ->
          fun
            (Xs) ->
              separateDefault(DictFunctor, DictCompactable, Xs)
          end
      end
  end.

separateDefault(#{ map := DictFunctor }, #{ compact := DictCompactable }, Xs) ->
  #{ left =>
     DictCompactable((DictFunctor(fun
                        (X) ->
                          case X of
                            {left, X@1} ->
                              {just, X@1};
                            {right, _} ->
                              {nothing};
                            _ ->
                              erlang:error({fail, <<"Failed pattern match">>})
                          end
                      end))
                     (Xs))
   , right => DictCompactable((DictFunctor(data_either@ps:hush()))(Xs))
   }.

bindMaybe() ->
  fun
    (DictBind) ->
      fun
        (DictCompactable) ->
          fun
            (X) ->
              bindMaybe(DictBind, DictCompactable, X)
          end
      end
  end.

bindMaybe(#{ bind := DictBind }, #{ compact := DictCompactable }, X) ->
  begin
    V = DictBind(X),
    fun
      (X@1) ->
        DictCompactable(V(X@1))
    end
  end.

bindEither() ->
  fun
    (DictBind) ->
      fun
        (DictCompactable) ->
          fun
            (X) ->
              bindEither(DictBind, DictCompactable, X)
          end
      end
  end.

bindEither(#{ bind := DictBind }, #{ separate := DictCompactable }, X) ->
  begin
    V = DictBind(X),
    fun
      (X@1) ->
        DictCompactable(V(X@1))
    end
  end.

applyMaybe() ->
  fun
    (DictApply) ->
      fun
        (DictCompactable) ->
          fun
            (P) ->
              applyMaybe(DictApply, DictCompactable, P)
          end
      end
  end.

applyMaybe(#{ apply := DictApply }, #{ compact := DictCompactable }, P) ->
  begin
    V = DictApply(P),
    fun
      (X) ->
        DictCompactable(V(X))
    end
  end.

applyEither() ->
  fun
    (DictApply) ->
      fun
        (DictCompactable) ->
          fun
            (P) ->
              applyEither(DictApply, DictCompactable, P)
          end
      end
  end.

applyEither(#{ apply := DictApply }, #{ separate := DictCompactable }, P) ->
  begin
    V = DictApply(P),
    fun
      (X) ->
        DictCompactable(V(X))
    end
  end.

