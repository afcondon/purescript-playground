-module(data_list_internal@ps).
-export([ 'Leaf'/0
        , 'Two'/0
        , 'Three'/0
        , 'TwoLeft'/0
        , 'TwoRight'/0
        , 'ThreeLeft'/0
        , 'ThreeMiddle'/0
        , 'ThreeRight'/0
        , 'KickUp'/0
        , fromZipper/0
        , fromZipper/2
        , insertAndLookupBy/0
        , insertAndLookupBy/3
        , emptySet/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'Leaf'() ->
  {leaf}.

'Two'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              {two, Value0, Value1, Value2}
          end
      end
  end.

'Three'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  fun
                    (Value4) ->
                      {three, Value0, Value1, Value2, Value3, Value4}
                  end
              end
          end
      end
  end.

'TwoLeft'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {twoLeft, Value0, Value1}
      end
  end.

'TwoRight'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {twoRight, Value0, Value1}
      end
  end.

'ThreeLeft'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  {threeLeft, Value0, Value1, Value2, Value3}
              end
          end
      end
  end.

'ThreeMiddle'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  {threeMiddle, Value0, Value1, Value2, Value3}
              end
          end
      end
  end.

'ThreeRight'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              fun
                (Value3) ->
                  {threeRight, Value0, Value1, Value2, Value3}
              end
          end
      end
  end.

'KickUp'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          fun
            (Value2) ->
              {kickUp, Value0, Value1, Value2}
          end
      end
  end.

fromZipper() ->
  fun
    (V) ->
      fun
        (V1) ->
          fromZipper(V, V1)
      end
  end.

fromZipper(V, V1) ->
  case V of
    {nil} ->
      V1;
    {cons, V@1, V@2} ->
      case V@1 of
        {twoLeft, V@3, V@4} ->
          fromZipper(V@2, {two, V1, V@3, V@4});
        {twoRight, V@5, V@6} ->
          fromZipper(V@2, {two, V@5, V@6, V1});
        {threeLeft, V@7, V@8, V@9, V@10} ->
          fromZipper(V@2, {three, V1, V@7, V@8, V@9, V@10});
        {threeMiddle, V@11, V@12, V@13, V@14} ->
          fromZipper(V@2, {three, V@11, V@12, V1, V@13, V@14});
        {threeRight, V@15, V@16, V@17, V@18} ->
          fromZipper(V@2, {three, V@15, V@16, V@17, V@18, V1});
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

insertAndLookupBy() ->
  fun
    (Comp) ->
      fun
        (K) ->
          fun
            (Orig) ->
              insertAndLookupBy(Comp, K, Orig)
          end
      end
  end.

insertAndLookupBy(Comp, K, Orig) ->
  begin
    Up =
      fun
        Up (V, V1) ->
          case V of
            {nil} ->
              { two
              , erlang:element(2, V1)
              , erlang:element(3, V1)
              , erlang:element(4, V1)
              };
            {cons, V@1, V@2} ->
              case V@1 of
                {twoLeft, V@3, V@4} ->
                  fromZipper(
                    V@2,
                    { three
                    , erlang:element(2, V1)
                    , erlang:element(3, V1)
                    , erlang:element(4, V1)
                    , V@3
                    , V@4
                    }
                  );
                {twoRight, V@5, V@6} ->
                  fromZipper(
                    V@2,
                    { three
                    , V@5
                    , V@6
                    , erlang:element(2, V1)
                    , erlang:element(3, V1)
                    , erlang:element(4, V1)
                    }
                  );
                {threeLeft, V@7, V@8, V@9, V@10} ->
                  begin
                    V1@1 =
                      { kickUp
                      , { two
                        , erlang:element(2, V1)
                        , erlang:element(3, V1)
                        , erlang:element(4, V1)
                        }
                      , V@7
                      , {two, V@8, V@9, V@10}
                      },
                    Up(V@2, V1@1)
                  end;
                {threeMiddle, V@11, V@12, V@13, V@14} ->
                  begin
                    V1@2 =
                      { kickUp
                      , {two, V@11, V@12, erlang:element(2, V1)}
                      , erlang:element(3, V1)
                      , {two, erlang:element(4, V1), V@13, V@14}
                      },
                    Up(V@2, V1@2)
                  end;
                {threeRight, V@15, V@16, V@17, V@18} ->
                  begin
                    V1@3 =
                      { kickUp
                      , {two, V@15, V@16, V@17}
                      , V@18
                      , { two
                        , erlang:element(2, V1)
                        , erlang:element(3, V1)
                        , erlang:element(4, V1)
                        }
                      },
                    Up(V@2, V1@3)
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    Down =
      fun
        Down (V, V1) ->
          case V1 of
            {leaf} ->
              #{ found => false
               , result =>
                 begin
                   V1@1 = {kickUp, {leaf}, K, {leaf}},
                   Up(V, V1@1)
                 end
               };
            {two, _, V1@2, _} ->
              begin
                V2 = (Comp(K))(V1@2),
                case V2 of
                  {eQ} ->
                    #{ found => true, result => Orig };
                  {lT} ->
                    begin
                      {two, V1@3, V1@4, V1@5} = V1,
                      V@1 = {cons, {twoLeft, V1@4, V1@5}, V},
                      Down(V@1, V1@3)
                    end;
                  _ ->
                    begin
                      {two, V1@6, V1@7, V1@8} = V1,
                      V@2 = {cons, {twoRight, V1@6, V1@7}, V},
                      Down(V@2, V1@8)
                    end
                end
              end;
            {three, _, V1@9, _, _, _} ->
              begin
                V2@1 = (Comp(K))(V1@9),
                case V2@1 of
                  {eQ} ->
                    #{ found => true, result => Orig };
                  _ ->
                    begin
                      {three, _, _, _, V1@10, _} = V1,
                      V3 = (Comp(K))(V1@10),
                      case V3 of
                        {eQ} ->
                          #{ found => true, result => Orig };
                        _ ->
                          case V2@1 of
                            {lT} ->
                              begin
                                {three, V1@11, V1@12, V1@13, V1@14, V1@15} = V1,
                                V@3 =
                                  { cons
                                  , {threeLeft, V1@12, V1@13, V1@14, V1@15}
                                  , V
                                  },
                                Down(V@3, V1@11)
                              end;
                            _ ->
                              if
                                ?IS_KNOWN_TAG(gT, 0, V2@1)
                                  andalso ?IS_KNOWN_TAG(lT, 0, V3) ->
                                  begin
                                    {three, V1@16, V1@17, V1@18, V1@19, V1@20} =
                                      V1,
                                    V@4 =
                                      { cons
                                      , { threeMiddle
                                        , V1@16
                                        , V1@17
                                        , V1@19
                                        , V1@20
                                        }
                                      , V
                                      },
                                    Down(V@4, V1@18)
                                  end;
                                true ->
                                  begin
                                    {three, V1@21, V1@22, V1@23, V1@24, V1@25} =
                                      V1,
                                    V@5 =
                                      { cons
                                      , {threeRight, V1@21, V1@22, V1@23, V1@24}
                                      , V
                                      },
                                    Down(V@5, V1@25)
                                  end
                              end
                          end
                      end
                    end
                end
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    V = {nil},
    Down(V, Orig)
  end.

emptySet() ->
  {leaf}.

