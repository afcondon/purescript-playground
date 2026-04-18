-module(data_functor_product_nested@ps).
-export([ product9/0
        , product9/9
        , product8/0
        , product8/8
        , product7/0
        , product7/7
        , product6/0
        , product6/6
        , product5/0
        , product5/5
        , product4/0
        , product4/4
        , product3/0
        , product3/3
        , product2/0
        , product2/2
        , product10/0
        , product10/10
        , product1/0
        , product1/1
        , get9/0
        , get9/1
        , get8/0
        , get8/1
        , get7/0
        , get7/1
        , get6/0
        , get6/1
        , get5/0
        , get5/1
        , get4/0
        , get4/1
        , get3/0
        , get3/1
        , get2/0
        , get2/1
        , get10/0
        , get10/1
        , get1/0
        , get1/1
        ]).
-compile(no_auto_import).
product9() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (D) ->
                  fun
                    (E) ->
                      fun
                        (F) ->
                          fun
                            (G) ->
                              fun
                                (H) ->
                                  fun
                                    (I) ->
                                      product9(A, B, C, D, E, F, G, H, I)
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

product9(A, B, C, D, E, F, G, H, I) ->
  { tuple
  , A
  , { tuple
    , B
    , { tuple
      , C
      , { tuple
        , D
        , {tuple, E, {tuple, F, {tuple, G, {tuple, H, {tuple, I, unit}}}}}
        }
      }
    }
  }.

product8() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (D) ->
                  fun
                    (E) ->
                      fun
                        (F) ->
                          fun
                            (G) ->
                              fun
                                (H) ->
                                  product8(A, B, C, D, E, F, G, H)
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

product8(A, B, C, D, E, F, G, H) ->
  { tuple
  , A
  , { tuple
    , B
    , { tuple
      , C
      , {tuple, D, {tuple, E, {tuple, F, {tuple, G, {tuple, H, unit}}}}}
      }
    }
  }.

product7() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (D) ->
                  fun
                    (E) ->
                      fun
                        (F) ->
                          fun
                            (G) ->
                              product7(A, B, C, D, E, F, G)
                          end
                      end
                  end
              end
          end
      end
  end.

product7(A, B, C, D, E, F, G) ->
  { tuple
  , A
  , {tuple, B, {tuple, C, {tuple, D, {tuple, E, {tuple, F, {tuple, G, unit}}}}}}
  }.

product6() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (D) ->
                  fun
                    (E) ->
                      fun
                        (F) ->
                          product6(A, B, C, D, E, F)
                      end
                  end
              end
          end
      end
  end.

product6(A, B, C, D, E, F) ->
  {tuple, A, {tuple, B, {tuple, C, {tuple, D, {tuple, E, {tuple, F, unit}}}}}}.

product5() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (D) ->
                  fun
                    (E) ->
                      product5(A, B, C, D, E)
                  end
              end
          end
      end
  end.

product5(A, B, C, D, E) ->
  {tuple, A, {tuple, B, {tuple, C, {tuple, D, {tuple, E, unit}}}}}.

product4() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (D) ->
                  product4(A, B, C, D)
              end
          end
      end
  end.

product4(A, B, C, D) ->
  {tuple, A, {tuple, B, {tuple, C, {tuple, D, unit}}}}.

product3() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              product3(A, B, C)
          end
      end
  end.

product3(A, B, C) ->
  {tuple, A, {tuple, B, {tuple, C, unit}}}.

product2() ->
  fun
    (A) ->
      fun
        (B) ->
          product2(A, B)
      end
  end.

product2(A, B) ->
  {tuple, A, {tuple, B, unit}}.

product10() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (D) ->
                  fun
                    (E) ->
                      fun
                        (F) ->
                          fun
                            (G) ->
                              fun
                                (H) ->
                                  fun
                                    (I) ->
                                      fun
                                        (J) ->
                                          product10(
                                            A,
                                            B,
                                            C,
                                            D,
                                            E,
                                            F,
                                            G,
                                            H,
                                            I,
                                            J
                                          )
                                      end
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

product10(A, B, C, D, E, F, G, H, I, J) ->
  { tuple
  , A
  , { tuple
    , B
    , { tuple
      , C
      , { tuple
        , D
        , { tuple
          , E
          , {tuple, F, {tuple, G, {tuple, H, {tuple, I, {tuple, J, unit}}}}}
          }
        }
      }
    }
  }.

product1() ->
  fun
    (A) ->
      product1(A)
  end.

product1(A) ->
  {tuple, A, unit}.

get9() ->
  fun
    (V) ->
      get9(V)
  end.

get9(V) ->
  erlang:element(
    2,
    erlang:element(
      3,
      erlang:element(
        3,
        erlang:element(
          3,
          erlang:element(
            3,
            erlang:element(
              3,
              erlang:element(3, erlang:element(3, erlang:element(3, V)))
            )
          )
        )
      )
    )
  ).

get8() ->
  fun
    (V) ->
      get8(V)
  end.

get8(V) ->
  erlang:element(
    2,
    erlang:element(
      3,
      erlang:element(
        3,
        erlang:element(
          3,
          erlang:element(
            3,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        )
      )
    )
  ).

get7() ->
  fun
    (V) ->
      get7(V)
  end.

get7(V) ->
  erlang:element(
    2,
    erlang:element(
      3,
      erlang:element(
        3,
        erlang:element(
          3,
          erlang:element(3, erlang:element(3, erlang:element(3, V)))
        )
      )
    )
  ).

get6() ->
  fun
    (V) ->
      get6(V)
  end.

get6(V) ->
  erlang:element(
    2,
    erlang:element(
      3,
      erlang:element(
        3,
        erlang:element(3, erlang:element(3, erlang:element(3, V)))
      )
    )
  ).

get5() ->
  fun
    (V) ->
      get5(V)
  end.

get5(V) ->
  erlang:element(
    2,
    erlang:element(
      3,
      erlang:element(3, erlang:element(3, erlang:element(3, V)))
    )
  ).

get4() ->
  fun
    (V) ->
      get4(V)
  end.

get4(V) ->
  erlang:element(2, erlang:element(3, erlang:element(3, erlang:element(3, V)))).

get3() ->
  fun
    (V) ->
      get3(V)
  end.

get3(V) ->
  erlang:element(2, erlang:element(3, erlang:element(3, V))).

get2() ->
  fun
    (V) ->
      get2(V)
  end.

get2(V) ->
  erlang:element(2, erlang:element(3, V)).

get10() ->
  fun
    (V) ->
      get10(V)
  end.

get10(V) ->
  erlang:element(
    2,
    erlang:element(
      3,
      erlang:element(
        3,
        erlang:element(
          3,
          erlang:element(
            3,
            erlang:element(
              3,
              erlang:element(
                3,
                erlang:element(3, erlang:element(3, erlang:element(3, V)))
              )
            )
          )
        )
      )
    )
  ).

get1() ->
  fun
    (V) ->
      get1(V)
  end.

get1(V) ->
  erlang:element(2, V).

