-module(data_map_gen@ps).
-export([genMap/0, genMap/2]).
-compile(no_auto_import).
genMap() ->
  fun
    (DictMonadRec) ->
      fun
        (DictMonadGen) ->
          genMap(DictMonadRec, DictMonadGen)
      end
  end.

genMap( DictMonadRec
      , DictMonadGen = #{ 'Monad0' := DictMonadGen@1
                        , chooseInt := DictMonadGen@2
                        , resize := DictMonadGen@3
                        , sized := DictMonadGen@4
                        }
      ) ->
  begin
    #{ 'Apply0' := Bind1, bind := Bind1@1 } =
      (erlang:map_get('Bind1', DictMonadGen@1(undefined)))(undefined),
    #{ 'Functor0' := Apply0, apply := Apply0@1 } = Bind1(undefined),
    #{ map := V } = Apply0(undefined),
    Unfoldable1 =
      (control_monad_gen@ps:unfoldable(DictMonadRec, DictMonadGen))
      (data_list_types@ps:unfoldableList()),
    fun
      (DictOrd) ->
        begin
          FromFoldable =
            data_map_internal@ps:fromFoldable(
              DictOrd,
              data_list_types@ps:foldableList()
            ),
          fun
            (GenKey) ->
              fun
                (GenValue) ->
                  DictMonadGen@4(fun
                    (Size) ->
                      (Bind1@1((DictMonadGen@2(0))(Size)))
                      (fun
                        (NewSize) ->
                          (DictMonadGen@3(fun
                             (_) ->
                               NewSize
                           end))
                          ((V(FromFoldable))
                           (Unfoldable1((Apply0@1((V(data_tuple@ps:'Tuple'()))
                                                  (GenKey)))
                                        (GenValue))))
                      end)
                  end)
              end
          end
        end
    end
  end.

