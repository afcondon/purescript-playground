-module(data_profunctor_strong@ps).
-export([ identity/0
        , identity/1
        , strongFn/0
        , second/0
        , second/1
        , first/0
        , first/1
        , splitStrong/0
        , splitStrong/1
        , fanout/0
        , fanout/1
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

strongFn() ->
  #{ first =>
     fun
       (A2b) ->
         fun
           (V) ->
             {tuple, A2b(erlang:element(2, V)), erlang:element(3, V)}
         end
     end
   , second => erlang:map_get(map, data_tuple@ps:functorTuple())
   , 'Profunctor0' =>
     fun
       (_) ->
         data_profunctor@ps:profunctorFn()
     end
   }.

second() ->
  fun
    (Dict) ->
      second(Dict)
  end.

second(#{ second := Dict }) ->
  Dict.

first() ->
  fun
    (Dict) ->
      first(Dict)
  end.

first(#{ first := Dict }) ->
  Dict.

splitStrong() ->
  fun
    (DictCategory) ->
      splitStrong(DictCategory)
  end.

splitStrong(#{ 'Semigroupoid0' := DictCategory }) ->
  begin
    #{ compose := V } = DictCategory(undefined),
    fun
      (#{ first := DictStrong, second := DictStrong@1 }) ->
        fun
          (L) ->
            fun
              (R) ->
                (V(DictStrong@1(R)))(DictStrong(L))
            end
        end
    end
  end.

fanout() ->
  fun
    (DictCategory) ->
      fanout(DictCategory)
  end.

fanout(#{ 'Semigroupoid0' := DictCategory, identity := DictCategory@1 }) ->
  begin
    #{ compose := V } = DictCategory(undefined),
    #{ compose := V@1 } = DictCategory(undefined),
    fun
      (#{ 'Profunctor0' := DictStrong
        , first := DictStrong@1
        , second := DictStrong@2
        }) ->
        fun
          (L) ->
            fun
              (R) ->
                (V((V@1(DictStrong@2(R)))(DictStrong@1(L))))
                ((((erlang:map_get(dimap, DictStrong(undefined)))(identity()))
                  (fun
                    (A) ->
                      {tuple, A, A}
                  end))
                 (DictCategory@1))
            end
        end
    end
  end.

