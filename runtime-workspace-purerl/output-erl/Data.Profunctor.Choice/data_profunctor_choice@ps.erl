-module(data_profunctor_choice@ps).
-export([ identity/0
        , identity/1
        , right/0
        , right/1
        , left/0
        , left/1
        , splitChoice/0
        , splitChoice/1
        , fanin/0
        , fanin/1
        , choiceFn/0
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

right() ->
  fun
    (Dict) ->
      right(Dict)
  end.

right(#{ right := Dict }) ->
  Dict.

left() ->
  fun
    (Dict) ->
      left(Dict)
  end.

left(#{ left := Dict }) ->
  Dict.

splitChoice() ->
  fun
    (DictCategory) ->
      splitChoice(DictCategory)
  end.

splitChoice(#{ 'Semigroupoid0' := DictCategory }) ->
  begin
    #{ compose := V } = DictCategory(undefined),
    fun
      (#{ left := DictChoice, right := DictChoice@1 }) ->
        fun
          (L) ->
            fun
              (R) ->
                (V(DictChoice@1(R)))(DictChoice(L))
            end
        end
    end
  end.

fanin() ->
  fun
    (DictCategory) ->
      fanin(DictCategory)
  end.

fanin(#{ 'Semigroupoid0' := DictCategory, identity := DictCategory@1 }) ->
  begin
    #{ compose := V } = DictCategory(undefined),
    #{ compose := V@1 } = DictCategory(undefined),
    fun
      (#{ 'Profunctor0' := DictChoice
        , left := DictChoice@1
        , right := DictChoice@2
        }) ->
        fun
          (L) ->
            fun
              (R) ->
                (V((((erlang:map_get(dimap, DictChoice(undefined)))
                     (fun
                       (V2) ->
                         case V2 of
                           {left, V2@1} ->
                             V2@1;
                           {right, V2@2} ->
                             V2@2;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end))
                    (identity()))
                   (DictCategory@1)))
                ((V@1(DictChoice@2(R)))(DictChoice@1(L)))
            end
        end
    end
  end.

choiceFn() ->
  #{ left =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {left, V1@1} ->
                 {left, V(V1@1)};
               {right, V1@2} ->
                 {right, V1@2};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , right => erlang:map_get(map, data_either@ps:functorEither())
   , 'Profunctor0' =>
     fun
       (_) ->
         data_profunctor@ps:profunctorFn()
     end
   }.

