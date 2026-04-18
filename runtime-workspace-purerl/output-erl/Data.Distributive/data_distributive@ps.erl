-module(data_distributive@ps).
-export([ identity/0
        , identity/1
        , distributiveIdentity/0
        , distribute/0
        , distribute/1
        , distributiveFunction/0
        , cotraverse/0
        , cotraverse/2
        , collectDefault/0
        , collectDefault/2
        , distributiveTuple/0
        , distributiveTuple/1
        , collect/0
        , collect/1
        , distributeDefault/0
        , distributeDefault/2
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

distributiveIdentity() ->
  #{ distribute =>
     fun
       (#{ map := DictFunctor }) ->
         DictFunctor(unsafe_coerce@ps:unsafeCoerce())
     end
   , collect =>
     fun
       (#{ map := DictFunctor }) ->
         fun
           (F) ->
             DictFunctor(fun
               (X) ->
                 F(X)
             end)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_identity@ps:functorIdentity()
     end
   }.

distribute() ->
  fun
    (Dict) ->
      distribute(Dict)
  end.

distribute(#{ distribute := Dict }) ->
  Dict.

distributiveFunction() ->
  #{ distribute =>
     fun
       (#{ map := DictFunctor }) ->
         fun
           (A) ->
             fun
               (E) ->
                 (DictFunctor(fun
                    (V) ->
                      V(E)
                  end))
                 (A)
             end
         end
     end
   , collect =>
     fun
       (DictFunctor = #{ map := DictFunctor@1 }) ->
         fun
           (F) ->
             begin
               V =
                 (erlang:map_get(distribute, distributiveFunction()))
                 (DictFunctor),
               V@1 = DictFunctor@1(F),
               fun
                 (X) ->
                   V(V@1(X))
               end
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_functor@ps:functorFn()
     end
   }.

cotraverse() ->
  fun
    (DictDistributive) ->
      fun
        (DictFunctor) ->
          cotraverse(DictDistributive, DictFunctor)
      end
  end.

cotraverse( #{ 'Functor0' := DictDistributive
             , distribute := DictDistributive@1
             }
          , DictFunctor
          ) ->
  begin
    Distribute2 = DictDistributive@1(DictFunctor),
    fun
      (F) ->
        begin
          V = (erlang:map_get(map, DictDistributive(undefined)))(F),
          fun
            (X) ->
              V(Distribute2(X))
          end
        end
    end
  end.

collectDefault() ->
  fun
    (DictDistributive) ->
      fun
        (DictFunctor) ->
          collectDefault(DictDistributive, DictFunctor)
      end
  end.

collectDefault( #{ distribute := DictDistributive }
              , DictFunctor = #{ map := DictFunctor@1 }
              ) ->
  begin
    Distribute2 = DictDistributive(DictFunctor),
    fun
      (F) ->
        begin
          V = DictFunctor@1(F),
          fun
            (X) ->
              Distribute2(V(X))
          end
        end
    end
  end.

distributiveTuple() ->
  fun
    (DictTypeEquals) ->
      distributiveTuple(DictTypeEquals)
  end.

distributiveTuple(DictTypeEquals = #{ proof := DictTypeEquals@1 }) ->
  begin
    From =
      DictTypeEquals@1(fun
        (A) ->
          A
      end),
    #{ collect =>
       fun
         (DictFunctor = #{ map := DictFunctor@1 }) ->
           begin
             Distribute2 =
               (erlang:map_get(distribute, distributiveTuple(DictTypeEquals)))
               (DictFunctor),
             fun
               (F) ->
                 begin
                   V = DictFunctor@1(F),
                   fun
                     (X) ->
                       Distribute2(V(X))
                   end
                 end
             end
           end
       end
     , distribute =>
       fun
         (#{ map := DictFunctor }) ->
           begin
             V = (data_tuple@ps:'Tuple'())(From(unit)),
             V@1 = DictFunctor(data_tuple@ps:snd()),
             fun
               (X) ->
                 V(V@1(X))
             end
           end
       end
     , 'Functor0' =>
       fun
         (_) ->
           data_tuple@ps:functorTuple()
       end
     }
  end.

collect() ->
  fun
    (Dict) ->
      collect(Dict)
  end.

collect(#{ collect := Dict }) ->
  Dict.

distributeDefault() ->
  fun
    (DictDistributive) ->
      fun
        (DictFunctor) ->
          distributeDefault(DictDistributive, DictFunctor)
      end
  end.

distributeDefault(#{ collect := DictDistributive }, DictFunctor) ->
  (DictDistributive(DictFunctor))(identity()).

