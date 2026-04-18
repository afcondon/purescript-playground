-module(data_unfoldable@ps).
-export([ fromJust/0
        , fromJust/1
        , unfoldr/0
        , unfoldr/1
        , unfoldableMaybe/0
        , unfoldableArray/0
        , replicate/0
        , replicate/3
        , replicateA/0
        , replicateA/3
        , none/0
        , none/1
        , fromMaybe/0
        , fromMaybe/1
        , unfoldrArrayImpl/0
        ]).
-compile(no_auto_import).
fromJust() ->
  fun
    (V) ->
      fromJust(V)
  end.

fromJust(V = {just, V@1}) ->
  case V of
    {just, _} ->
      V@1;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

unfoldr() ->
  fun
    (Dict) ->
      unfoldr(Dict)
  end.

unfoldr(#{ unfoldr := Dict }) ->
  Dict.

unfoldableMaybe() ->
  #{ unfoldr =>
     fun
       (F) ->
         fun
           (B) ->
             begin
               V = F(B),
               case V of
                 {just, V@1} ->
                   {just, erlang:element(2, V@1)};
                 _ ->
                   {nothing}
               end
             end
         end
     end
   , 'Unfoldable10' =>
     fun
       (_) ->
         data_unfoldable1@ps:unfoldable1Maybe()
     end
   }.

unfoldableArray() ->
  #{ unfoldr =>
     ((((unfoldrArrayImpl())(data_maybe@ps:isNothing()))(fromJust()))
      (data_tuple@ps:fst()))
     (data_tuple@ps:snd())
   , 'Unfoldable10' =>
     fun
       (_) ->
         data_unfoldable1@ps:unfoldable1Array()
     end
   }.

replicate() ->
  fun
    (DictUnfoldable) ->
      fun
        (N) ->
          fun
            (V) ->
              replicate(DictUnfoldable, N, V)
          end
      end
  end.

replicate(#{ unfoldr := DictUnfoldable }, N, V) ->
  (DictUnfoldable(fun
     (I) ->
       if
         I =< 0 ->
           {nothing};
         true ->
           {just, {tuple, V, I - 1}}
       end
   end))
  (N).

replicateA() ->
  fun
    (DictApplicative) ->
      fun
        (DictUnfoldable) ->
          fun
            (DictTraversable) ->
              replicateA(DictApplicative, DictUnfoldable, DictTraversable)
          end
      end
  end.

replicateA( DictApplicative
          , #{ unfoldr := DictUnfoldable }
          , #{ sequence := DictTraversable }
          ) ->
  begin
    Sequence = DictTraversable(DictApplicative),
    fun
      (N) ->
        fun
          (M) ->
            Sequence((DictUnfoldable(fun
                        (I) ->
                          if
                            I =< 0 ->
                              {nothing};
                            true ->
                              {just, {tuple, M, I - 1}}
                          end
                      end))
                     (N))
        end
    end
  end.

none() ->
  fun
    (DictUnfoldable) ->
      none(DictUnfoldable)
  end.

none(#{ unfoldr := DictUnfoldable }) ->
  (DictUnfoldable(fun
     (_) ->
       {nothing}
   end))
  (unit).

fromMaybe() ->
  fun
    (DictUnfoldable) ->
      fromMaybe(DictUnfoldable)
  end.

fromMaybe(#{ unfoldr := DictUnfoldable }) ->
  DictUnfoldable(fun
    (B) ->
      case B of
        {just, B@1} ->
          {just, {tuple, B@1, {nothing}}};
        _ ->
          {nothing}
      end
  end).

unfoldrArrayImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      fun
                        (V@5) ->
                          data_unfoldable@foreign:unfoldrArrayImpl(
                            V,
                            V@1,
                            V@2,
                            V@3,
                            V@4,
                            V@5
                          )
                      end
                  end
              end
          end
      end
  end.

