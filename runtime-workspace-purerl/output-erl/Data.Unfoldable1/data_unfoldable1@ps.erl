-module(data_unfoldable1@ps).
-export([ fromJust/0
        , fromJust/1
        , unfoldr1/0
        , unfoldr1/1
        , unfoldable1Maybe/0
        , unfoldable1Array/0
        , replicate1/0
        , replicate1/3
        , replicate1A/0
        , replicate1A/3
        , singleton/0
        , singleton/2
        , range/0
        , range/3
        , unfoldr1ArrayImpl/0
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

unfoldr1() ->
  fun
    (Dict) ->
      unfoldr1(Dict)
  end.

unfoldr1(#{ unfoldr1 := Dict }) ->
  Dict.

unfoldable1Maybe() ->
  #{ unfoldr1 =>
     fun
       (F) ->
         fun
           (B) ->
             {just, erlang:element(2, F(B))}
         end
     end
   }.

unfoldable1Array() ->
  #{ unfoldr1 =>
     ((((unfoldr1ArrayImpl())(data_maybe@ps:isNothing()))(fromJust()))
      (data_tuple@ps:fst()))
     (data_tuple@ps:snd())
   }.

replicate1() ->
  fun
    (DictUnfoldable1) ->
      fun
        (N) ->
          fun
            (V) ->
              replicate1(DictUnfoldable1, N, V)
          end
      end
  end.

replicate1(#{ unfoldr1 := DictUnfoldable1 }, N, V) ->
  (DictUnfoldable1(fun
     (I) ->
       if
         I =< 0 ->
           {tuple, V, {nothing}};
         true ->
           {tuple, V, {just, I - 1}}
       end
   end))
  (N - 1).

replicate1A() ->
  fun
    (DictApply) ->
      fun
        (DictUnfoldable1) ->
          fun
            (DictTraversable1) ->
              replicate1A(DictApply, DictUnfoldable1, DictTraversable1)
          end
      end
  end.

replicate1A( DictApply
           , #{ unfoldr1 := DictUnfoldable1 }
           , #{ sequence1 := DictTraversable1 }
           ) ->
  begin
    Sequence1 = DictTraversable1(DictApply),
    fun
      (N) ->
        fun
          (M) ->
            Sequence1((DictUnfoldable1(fun
                         (I) ->
                           if
                             I =< 0 ->
                               {tuple, M, {nothing}};
                             true ->
                               {tuple, M, {just, I - 1}}
                           end
                       end))
                      (N - 1))
        end
    end
  end.

singleton() ->
  fun
    (DictUnfoldable1) ->
      fun
        (V) ->
          singleton(DictUnfoldable1, V)
      end
  end.

singleton(#{ unfoldr1 := DictUnfoldable1 }, V) ->
  (DictUnfoldable1(fun
     (I) ->
       if
         I =< 0 ->
           {tuple, V, {nothing}};
         true ->
           {tuple, V, {just, I - 1}}
       end
   end))
  (0).

range() ->
  fun
    (DictUnfoldable1) ->
      fun
        (Start) ->
          fun
            (End) ->
              range(DictUnfoldable1, Start, End)
          end
      end
  end.

range(#{ unfoldr1 := DictUnfoldable1 }, Start, End) ->
  (DictUnfoldable1(begin
     V =
       if
         End >= Start ->
           1;
         true ->
           -1
       end,
     fun
       (I) ->
         begin
           I_ = I + V,
           { tuple
           , I
           , if
               I =:= End ->
                 {nothing};
               true ->
                 {just, I_}
             end
           }
         end
     end
   end))
  (Start).

unfoldr1ArrayImpl() ->
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
                          data_unfoldable1@foreign:unfoldr1ArrayImpl(
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

