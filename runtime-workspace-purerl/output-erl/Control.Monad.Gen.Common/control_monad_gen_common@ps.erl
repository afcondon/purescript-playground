-module(control_monad_gen_common@ps).
-export([ max/0
        , max/2
        , genTuple/0
        , genTuple/3
        , genNonEmpty/0
        , genNonEmpty/2
        , 'genMaybe\''/0
        , 'genMaybe\''/1
        , genMaybe/0
        , genMaybe/1
        , genIdentity/0
        , genIdentity/1
        , 'genEither\''/0
        , 'genEither\''/1
        , genEither/0
        , genEither/1
        ]).
-compile(no_auto_import).
max() ->
  fun
    (X) ->
      fun
        (Y) ->
          max(X, Y)
      end
  end.

max(X, Y) ->
  begin
    V = ((erlang:map_get(compare, data_ord@ps:ordInt()))(X))(Y),
    case V of
      {lT} ->
        Y;
      {eQ} ->
        X;
      {gT} ->
        X;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

genTuple() ->
  fun
    (DictApply) ->
      fun
        (A) ->
          fun
            (B) ->
              genTuple(DictApply, A, B)
          end
      end
  end.

genTuple(#{ 'Functor0' := DictApply, apply := DictApply@1 }, A, B) ->
  (DictApply@1(((erlang:map_get(map, DictApply(undefined)))
                (data_tuple@ps:'Tuple'()))
               (A)))
  (B).

genNonEmpty() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          genNonEmpty(DictMonadRec, DictMonadGen)
      end
  end.

genNonEmpty( DictMonadRec
           , DictMonadGen = #{ 'Monad0' := DictMonadGen@1
                             , resize := DictMonadGen@2
                             }
           ) ->
  begin
    #{ 'Functor0' := Apply0, apply := Apply0@1 } =
      (erlang:map_get(
         'Apply0',
         (erlang:map_get('Bind1', DictMonadGen@1(undefined)))(undefined)
       ))
      (undefined),
    Unfoldable1 = control_monad_gen@ps:unfoldable(DictMonadRec, DictMonadGen),
    fun
      (DictUnfoldable) ->
        begin
          Unfoldable2 = Unfoldable1(DictUnfoldable),
          fun
            (Gen) ->
              (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                         (data_nonEmpty@ps:'NonEmpty'()))
                        (Gen)))
              ((DictMonadGen@2(fun
                  (X) ->
                    max(0, X - 1)
                end))
               (Unfoldable2(Gen)))
          end
        end
    end
  end.

'genMaybe\''() ->
  fun
    (DictMonadGen) ->
      'genMaybe\''(DictMonadGen)
  end.

'genMaybe\''(#{ 'Monad0' := DictMonadGen, chooseFloat := DictMonadGen@1 }) ->
  begin
    Monad0 = #{ 'Bind1' := Monad0@1 } = DictMonadGen(undefined),
    Bind1 = #{ bind := Bind1@1 } = Monad0@1(undefined),
    fun
      (Bias) ->
        fun
          (Gen) ->
            (Bind1@1((DictMonadGen@1(0.0))(1.0)))
            (fun
              (N) ->
                if
                  N < Bias ->
                    begin
                      #{ 'Apply0' := Bind1@2 } = Bind1,
                      ((erlang:map_get(
                          map,
                          (erlang:map_get('Functor0', Bind1@2(undefined)))
                          (undefined)
                        ))
                       (data_maybe@ps:'Just'()))
                      (Gen)
                    end;
                  true ->
                    begin
                      #{ 'Applicative0' := Monad0@2 } = Monad0,
                      (erlang:map_get(pure, Monad0@2(undefined)))({nothing})
                    end
                end
            end)
        end
    end
  end.

genMaybe() ->
  fun
    (DictMonadGen) ->
      genMaybe(DictMonadGen)
  end.

genMaybe(DictMonadGen) ->
  ('genMaybe\''(DictMonadGen))(0.75).

genIdentity() ->
  fun
    (DictFunctor) ->
      genIdentity(DictFunctor)
  end.

genIdentity(#{ map := DictFunctor }) ->
  DictFunctor(data_identity@ps:'Identity'()).

'genEither\''() ->
  fun
    (DictMonadGen) ->
      'genEither\''(DictMonadGen)
  end.

'genEither\''(#{ 'Monad0' := DictMonadGen, chooseFloat := DictMonadGen@1 }) ->
  begin
    #{ 'Apply0' := Bind1, bind := Bind1@1 } =
      (erlang:map_get('Bind1', DictMonadGen(undefined)))(undefined),
    #{ map := V } = (erlang:map_get('Functor0', Bind1(undefined)))(undefined),
    fun
      (Bias) ->
        fun
          (GenA) ->
            fun
              (GenB) ->
                (Bind1@1((DictMonadGen@1(0.0))(1.0)))
                (fun
                  (N) ->
                    if
                      N < Bias ->
                        (V(data_either@ps:'Left'()))(GenA);
                      true ->
                        (V(data_either@ps:'Right'()))(GenB)
                    end
                end)
            end
        end
    end
  end.

genEither() ->
  fun
    (DictMonadGen) ->
      genEither(DictMonadGen)
  end.

genEither(DictMonadGen) ->
  ('genEither\''(DictMonadGen))(0.5).

