-module(data_tuple_nested@ps).
-export([ uncurry9/0
        , uncurry9/2
        , uncurry8/0
        , uncurry8/2
        , uncurry7/0
        , uncurry7/2
        , uncurry6/0
        , uncurry6/2
        , uncurry5/0
        , uncurry5/2
        , uncurry4/0
        , uncurry4/2
        , uncurry3/0
        , uncurry3/2
        , uncurry2/0
        , uncurry2/2
        , uncurry10/0
        , uncurry10/2
        , uncurry1/0
        , uncurry1/2
        , tuple9/0
        , tuple9/9
        , tuple8/0
        , tuple8/8
        , tuple7/0
        , tuple7/7
        , tuple6/0
        , tuple6/6
        , tuple5/0
        , tuple5/5
        , tuple4/0
        , tuple4/4
        , tuple3/0
        , tuple3/3
        , tuple2/0
        , tuple2/2
        , tuple10/0
        , tuple10/10
        , tuple1/0
        , tuple1/1
        , over9/0
        , over9/2
        , over8/0
        , over8/2
        , over7/0
        , over7/2
        , over6/0
        , over6/2
        , over5/0
        , over5/2
        , over4/0
        , over4/2
        , over3/0
        , over3/2
        , over2/0
        , over2/2
        , over10/0
        , over10/2
        , over1/0
        , over1/2
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
        , curry9/0
        , curry9/11
        , curry8/0
        , curry8/10
        , curry7/0
        , curry7/9
        , curry6/0
        , curry6/8
        , curry5/0
        , curry5/7
        , curry4/0
        , curry4/6
        , curry3/0
        , curry3/5
        , curry2/0
        , curry2/4
        , curry10/0
        , curry10/12
        , curry1/0
        , curry1/3
        ]).
-compile(no_auto_import).
uncurry9() ->
  fun
    (F_) ->
      fun
        (V) ->
          uncurry9(F_, V)
      end
  end.

uncurry9(F_, V) ->
  ((((((((F_(erlang:element(2, V)))(erlang:element(2, erlang:element(3, V))))
        (erlang:element(2, erlang:element(3, erlang:element(3, V)))))
       (erlang:element(
          2,
          erlang:element(3, erlang:element(3, erlang:element(3, V)))
        )))
      (erlang:element(
         2,
         erlang:element(
           3,
           erlang:element(3, erlang:element(3, erlang:element(3, V)))
         )
       )))
     (erlang:element(
        2,
        erlang:element(
          3,
          erlang:element(
            3,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        )
      )))
    (erlang:element(
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
     )))
   (erlang:element(
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
    )))
  (erlang:element(
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
   )).

uncurry8() ->
  fun
    (F_) ->
      fun
        (V) ->
          uncurry8(F_, V)
      end
  end.

uncurry8(F_, V) ->
  (((((((F_(erlang:element(2, V)))(erlang:element(2, erlang:element(3, V))))
       (erlang:element(2, erlang:element(3, erlang:element(3, V)))))
      (erlang:element(
         2,
         erlang:element(3, erlang:element(3, erlang:element(3, V)))
       )))
     (erlang:element(
        2,
        erlang:element(
          3,
          erlang:element(3, erlang:element(3, erlang:element(3, V)))
        )
      )))
    (erlang:element(
       2,
       erlang:element(
         3,
         erlang:element(
           3,
           erlang:element(3, erlang:element(3, erlang:element(3, V)))
         )
       )
     )))
   (erlang:element(
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
    )))
  (erlang:element(
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
   )).

uncurry7() ->
  fun
    (F_) ->
      fun
        (V) ->
          uncurry7(F_, V)
      end
  end.

uncurry7(F_, V) ->
  ((((((F_(erlang:element(2, V)))(erlang:element(2, erlang:element(3, V))))
      (erlang:element(2, erlang:element(3, erlang:element(3, V)))))
     (erlang:element(
        2,
        erlang:element(3, erlang:element(3, erlang:element(3, V)))
      )))
    (erlang:element(
       2,
       erlang:element(
         3,
         erlang:element(3, erlang:element(3, erlang:element(3, V)))
       )
     )))
   (erlang:element(
      2,
      erlang:element(
        3,
        erlang:element(
          3,
          erlang:element(3, erlang:element(3, erlang:element(3, V)))
        )
      )
    )))
  (erlang:element(
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
   )).

uncurry6() ->
  fun
    (F_) ->
      fun
        (V) ->
          uncurry6(F_, V)
      end
  end.

uncurry6(F_, V) ->
  (((((F_(erlang:element(2, V)))(erlang:element(2, erlang:element(3, V))))
     (erlang:element(2, erlang:element(3, erlang:element(3, V)))))
    (erlang:element(
       2,
       erlang:element(3, erlang:element(3, erlang:element(3, V)))
     )))
   (erlang:element(
      2,
      erlang:element(
        3,
        erlang:element(3, erlang:element(3, erlang:element(3, V)))
      )
    )))
  (erlang:element(
     2,
     erlang:element(
       3,
       erlang:element(
         3,
         erlang:element(3, erlang:element(3, erlang:element(3, V)))
       )
     )
   )).

uncurry5() ->
  fun
    (F) ->
      fun
        (V) ->
          uncurry5(F, V)
      end
  end.

uncurry5(F, V) ->
  ((((F(erlang:element(2, V)))(erlang:element(2, erlang:element(3, V))))
    (erlang:element(2, erlang:element(3, erlang:element(3, V)))))
   (erlang:element(
      2,
      erlang:element(3, erlang:element(3, erlang:element(3, V)))
    )))
  (erlang:element(
     2,
     erlang:element(
       3,
       erlang:element(3, erlang:element(3, erlang:element(3, V)))
     )
   )).

uncurry4() ->
  fun
    (F) ->
      fun
        (V) ->
          uncurry4(F, V)
      end
  end.

uncurry4(F, V) ->
  (((F(erlang:element(2, V)))(erlang:element(2, erlang:element(3, V))))
   (erlang:element(2, erlang:element(3, erlang:element(3, V)))))
  (erlang:element(2, erlang:element(3, erlang:element(3, erlang:element(3, V))))).

uncurry3() ->
  fun
    (F) ->
      fun
        (V) ->
          uncurry3(F, V)
      end
  end.

uncurry3(F, V) ->
  ((F(erlang:element(2, V)))(erlang:element(2, erlang:element(3, V))))
  (erlang:element(2, erlang:element(3, erlang:element(3, V)))).

uncurry2() ->
  fun
    (F) ->
      fun
        (V) ->
          uncurry2(F, V)
      end
  end.

uncurry2(F, V) ->
  (F(erlang:element(2, V)))(erlang:element(2, erlang:element(3, V))).

uncurry10() ->
  fun
    (F_) ->
      fun
        (V) ->
          uncurry10(F_, V)
      end
  end.

uncurry10(F_, V) ->
  (((((((((F_(erlang:element(2, V)))(erlang:element(2, erlang:element(3, V))))
         (erlang:element(2, erlang:element(3, erlang:element(3, V)))))
        (erlang:element(
           2,
           erlang:element(3, erlang:element(3, erlang:element(3, V)))
         )))
       (erlang:element(
          2,
          erlang:element(
            3,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        )))
      (erlang:element(
         2,
         erlang:element(
           3,
           erlang:element(
             3,
             erlang:element(3, erlang:element(3, erlang:element(3, V)))
           )
         )
       )))
     (erlang:element(
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
      )))
    (erlang:element(
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
     )))
   (erlang:element(
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
    )))
  (erlang:element(
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
   )).

uncurry1() ->
  fun
    (F) ->
      fun
        (V) ->
          uncurry1(F, V)
      end
  end.

uncurry1(F, V) ->
  F(erlang:element(2, V)).

tuple9() ->
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
                                      tuple9(A, B, C, D, E, F, G, H, I)
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

tuple9(A, B, C, D, E, F, G, H, I) ->
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

tuple8() ->
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
                                  tuple8(A, B, C, D, E, F, G, H)
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

tuple8(A, B, C, D, E, F, G, H) ->
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

tuple7() ->
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
                              tuple7(A, B, C, D, E, F, G)
                          end
                      end
                  end
              end
          end
      end
  end.

tuple7(A, B, C, D, E, F, G) ->
  { tuple
  , A
  , {tuple, B, {tuple, C, {tuple, D, {tuple, E, {tuple, F, {tuple, G, unit}}}}}}
  }.

tuple6() ->
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
                          tuple6(A, B, C, D, E, F)
                      end
                  end
              end
          end
      end
  end.

tuple6(A, B, C, D, E, F) ->
  {tuple, A, {tuple, B, {tuple, C, {tuple, D, {tuple, E, {tuple, F, unit}}}}}}.

tuple5() ->
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
                      tuple5(A, B, C, D, E)
                  end
              end
          end
      end
  end.

tuple5(A, B, C, D, E) ->
  {tuple, A, {tuple, B, {tuple, C, {tuple, D, {tuple, E, unit}}}}}.

tuple4() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (D) ->
                  tuple4(A, B, C, D)
              end
          end
      end
  end.

tuple4(A, B, C, D) ->
  {tuple, A, {tuple, B, {tuple, C, {tuple, D, unit}}}}.

tuple3() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              tuple3(A, B, C)
          end
      end
  end.

tuple3(A, B, C) ->
  {tuple, A, {tuple, B, {tuple, C, unit}}}.

tuple2() ->
  fun
    (A) ->
      fun
        (B) ->
          tuple2(A, B)
      end
  end.

tuple2(A, B) ->
  {tuple, A, {tuple, B, unit}}.

tuple10() ->
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
                                          tuple10(A, B, C, D, E, F, G, H, I, J)
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

tuple10(A, B, C, D, E, F, G, H, I, J) ->
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

tuple1() ->
  fun
    (A) ->
      tuple1(A)
  end.

tuple1(A) ->
  {tuple, A, unit}.

over9() ->
  fun
    (O) ->
      fun
        (V) ->
          over9(O, V)
      end
  end.

over9(O, V) ->
  { tuple
  , erlang:element(2, V)
  , { tuple
    , erlang:element(2, erlang:element(3, V))
    , { tuple
      , erlang:element(2, erlang:element(3, erlang:element(3, V)))
      , { tuple
        , erlang:element(
            2,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        , { tuple
          , erlang:element(
              2,
              erlang:element(
                3,
                erlang:element(3, erlang:element(3, erlang:element(3, V)))
              )
            )
          , { tuple
            , erlang:element(
                2,
                erlang:element(
                  3,
                  erlang:element(
                    3,
                    erlang:element(3, erlang:element(3, erlang:element(3, V)))
                  )
                )
              )
            , { tuple
              , erlang:element(
                  2,
                  erlang:element(
                    3,
                    erlang:element(
                      3,
                      erlang:element(
                        3,
                        erlang:element(
                          3,
                          erlang:element(3, erlang:element(3, V))
                        )
                      )
                    )
                  )
                )
              , { tuple
                , erlang:element(
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
                              erlang:element(3, erlang:element(3, V))
                            )
                          )
                        )
                      )
                    )
                  )
                , { tuple
                  , O(erlang:element(
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
                                    erlang:element(3, erlang:element(3, V))
                                  )
                                )
                              )
                            )
                          )
                        )
                      ))
                  , erlang:element(
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
                                erlang:element(
                                  3,
                                  erlang:element(3, erlang:element(3, V))
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  }
                }
              }
            }
          }
        }
      }
    }
  }.

over8() ->
  fun
    (O) ->
      fun
        (V) ->
          over8(O, V)
      end
  end.

over8(O, V) ->
  { tuple
  , erlang:element(2, V)
  , { tuple
    , erlang:element(2, erlang:element(3, V))
    , { tuple
      , erlang:element(2, erlang:element(3, erlang:element(3, V)))
      , { tuple
        , erlang:element(
            2,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        , { tuple
          , erlang:element(
              2,
              erlang:element(
                3,
                erlang:element(3, erlang:element(3, erlang:element(3, V)))
              )
            )
          , { tuple
            , erlang:element(
                2,
                erlang:element(
                  3,
                  erlang:element(
                    3,
                    erlang:element(3, erlang:element(3, erlang:element(3, V)))
                  )
                )
              )
            , { tuple
              , erlang:element(
                  2,
                  erlang:element(
                    3,
                    erlang:element(
                      3,
                      erlang:element(
                        3,
                        erlang:element(
                          3,
                          erlang:element(3, erlang:element(3, V))
                        )
                      )
                    )
                  )
                )
              , { tuple
                , O(erlang:element(
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
                                erlang:element(3, erlang:element(3, V))
                              )
                            )
                          )
                        )
                      )
                    ))
                , erlang:element(
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
                              erlang:element(3, erlang:element(3, V))
                            )
                          )
                        )
                      )
                    )
                  )
                }
              }
            }
          }
        }
      }
    }
  }.

over7() ->
  fun
    (O) ->
      fun
        (V) ->
          over7(O, V)
      end
  end.

over7(O, V) ->
  { tuple
  , erlang:element(2, V)
  , { tuple
    , erlang:element(2, erlang:element(3, V))
    , { tuple
      , erlang:element(2, erlang:element(3, erlang:element(3, V)))
      , { tuple
        , erlang:element(
            2,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        , { tuple
          , erlang:element(
              2,
              erlang:element(
                3,
                erlang:element(3, erlang:element(3, erlang:element(3, V)))
              )
            )
          , { tuple
            , erlang:element(
                2,
                erlang:element(
                  3,
                  erlang:element(
                    3,
                    erlang:element(3, erlang:element(3, erlang:element(3, V)))
                  )
                )
              )
            , { tuple
              , O(erlang:element(
                    2,
                    erlang:element(
                      3,
                      erlang:element(
                        3,
                        erlang:element(
                          3,
                          erlang:element(
                            3,
                            erlang:element(3, erlang:element(3, V))
                          )
                        )
                      )
                    )
                  ))
              , erlang:element(
                  3,
                  erlang:element(
                    3,
                    erlang:element(
                      3,
                      erlang:element(
                        3,
                        erlang:element(
                          3,
                          erlang:element(3, erlang:element(3, V))
                        )
                      )
                    )
                  )
                )
              }
            }
          }
        }
      }
    }
  }.

over6() ->
  fun
    (O) ->
      fun
        (V) ->
          over6(O, V)
      end
  end.

over6(O, V) ->
  { tuple
  , erlang:element(2, V)
  , { tuple
    , erlang:element(2, erlang:element(3, V))
    , { tuple
      , erlang:element(2, erlang:element(3, erlang:element(3, V)))
      , { tuple
        , erlang:element(
            2,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        , { tuple
          , erlang:element(
              2,
              erlang:element(
                3,
                erlang:element(3, erlang:element(3, erlang:element(3, V)))
              )
            )
          , { tuple
            , O(erlang:element(
                  2,
                  erlang:element(
                    3,
                    erlang:element(
                      3,
                      erlang:element(3, erlang:element(3, erlang:element(3, V)))
                    )
                  )
                ))
            , erlang:element(
                3,
                erlang:element(
                  3,
                  erlang:element(
                    3,
                    erlang:element(3, erlang:element(3, erlang:element(3, V)))
                  )
                )
              )
            }
          }
        }
      }
    }
  }.

over5() ->
  fun
    (O) ->
      fun
        (V) ->
          over5(O, V)
      end
  end.

over5(O, V) ->
  { tuple
  , erlang:element(2, V)
  , { tuple
    , erlang:element(2, erlang:element(3, V))
    , { tuple
      , erlang:element(2, erlang:element(3, erlang:element(3, V)))
      , { tuple
        , erlang:element(
            2,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        , { tuple
          , O(erlang:element(
                2,
                erlang:element(
                  3,
                  erlang:element(3, erlang:element(3, erlang:element(3, V)))
                )
              ))
          , erlang:element(
              3,
              erlang:element(
                3,
                erlang:element(3, erlang:element(3, erlang:element(3, V)))
              )
            )
          }
        }
      }
    }
  }.

over4() ->
  fun
    (O) ->
      fun
        (V) ->
          over4(O, V)
      end
  end.

over4(O, V) ->
  { tuple
  , erlang:element(2, V)
  , { tuple
    , erlang:element(2, erlang:element(3, V))
    , { tuple
      , erlang:element(2, erlang:element(3, erlang:element(3, V)))
      , { tuple
        , O(erlang:element(
              2,
              erlang:element(3, erlang:element(3, erlang:element(3, V)))
            ))
        , erlang:element(
            3,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        }
      }
    }
  }.

over3() ->
  fun
    (O) ->
      fun
        (V) ->
          over3(O, V)
      end
  end.

over3(O, V) ->
  { tuple
  , erlang:element(2, V)
  , { tuple
    , erlang:element(2, erlang:element(3, V))
    , { tuple
      , O(erlang:element(2, erlang:element(3, erlang:element(3, V))))
      , erlang:element(3, erlang:element(3, erlang:element(3, V)))
      }
    }
  }.

over2() ->
  fun
    (O) ->
      fun
        (V) ->
          over2(O, V)
      end
  end.

over2(O, V) ->
  { tuple
  , erlang:element(2, V)
  , { tuple
    , O(erlang:element(2, erlang:element(3, V)))
    , erlang:element(3, erlang:element(3, V))
    }
  }.

over10() ->
  fun
    (O) ->
      fun
        (V) ->
          over10(O, V)
      end
  end.

over10(O, V) ->
  { tuple
  , erlang:element(2, V)
  , { tuple
    , erlang:element(2, erlang:element(3, V))
    , { tuple
      , erlang:element(2, erlang:element(3, erlang:element(3, V)))
      , { tuple
        , erlang:element(
            2,
            erlang:element(3, erlang:element(3, erlang:element(3, V)))
          )
        , { tuple
          , erlang:element(
              2,
              erlang:element(
                3,
                erlang:element(3, erlang:element(3, erlang:element(3, V)))
              )
            )
          , { tuple
            , erlang:element(
                2,
                erlang:element(
                  3,
                  erlang:element(
                    3,
                    erlang:element(3, erlang:element(3, erlang:element(3, V)))
                  )
                )
              )
            , { tuple
              , erlang:element(
                  2,
                  erlang:element(
                    3,
                    erlang:element(
                      3,
                      erlang:element(
                        3,
                        erlang:element(
                          3,
                          erlang:element(3, erlang:element(3, V))
                        )
                      )
                    )
                  )
                )
              , { tuple
                , erlang:element(
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
                              erlang:element(3, erlang:element(3, V))
                            )
                          )
                        )
                      )
                    )
                  )
                , { tuple
                  , erlang:element(
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
                                  erlang:element(3, erlang:element(3, V))
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  , { tuple
                    , O(erlang:element(
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
                                      erlang:element(
                                        3,
                                        erlang:element(3, erlang:element(3, V))
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        ))
                    , erlang:element(
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
                                  erlang:element(
                                    3,
                                    erlang:element(
                                      3,
                                      erlang:element(3, erlang:element(3, V))
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )
                      )
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }.

over1() ->
  fun
    (O) ->
      fun
        (V) ->
          over1(O, V)
      end
  end.

over1(O, V) ->
  {tuple, O(erlang:element(2, V)), erlang:element(3, V)}.

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

curry9() ->
  fun
    (Z) ->
      fun
        (F_) ->
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
                                              curry9(
                                                Z,
                                                F_,
                                                A,
                                                B,
                                                C,
                                                D,
                                                E,
                                                F,
                                                G,
                                                H,
                                                I
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
      end
  end.

curry9(Z, F_, A, B, C, D, E, F, G, H, I) ->
  F_({ tuple
     , A
     , { tuple
       , B
       , { tuple
         , C
         , { tuple
           , D
           , {tuple, E, {tuple, F, {tuple, G, {tuple, H, {tuple, I, Z}}}}}
           }
         }
       }
     }).

curry8() ->
  fun
    (Z) ->
      fun
        (F_) ->
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
                                          curry8(Z, F_, A, B, C, D, E, F, G, H)
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

curry8(Z, F_, A, B, C, D, E, F, G, H) ->
  F_({ tuple
     , A
     , { tuple
       , B
       , { tuple
         , C
         , {tuple, D, {tuple, E, {tuple, F, {tuple, G, {tuple, H, Z}}}}}
         }
       }
     }).

curry7() ->
  fun
    (Z) ->
      fun
        (F_) ->
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
                                      curry7(Z, F_, A, B, C, D, E, F, G)
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

curry7(Z, F_, A, B, C, D, E, F, G) ->
  F_({ tuple
     , A
     , {tuple, B, {tuple, C, {tuple, D, {tuple, E, {tuple, F, {tuple, G, Z}}}}}}
     }).

curry6() ->
  fun
    (Z) ->
      fun
        (F_) ->
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
                                  curry6(Z, F_, A, B, C, D, E, F)
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

curry6(Z, F_, A, B, C, D, E, F) ->
  F_({tuple, A, {tuple, B, {tuple, C, {tuple, D, {tuple, E, {tuple, F, Z}}}}}}).

curry5() ->
  fun
    (Z) ->
      fun
        (F) ->
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
                              curry5(Z, F, A, B, C, D, E)
                          end
                      end
                  end
              end
          end
      end
  end.

curry5(Z, F, A, B, C, D, E) ->
  F({tuple, A, {tuple, B, {tuple, C, {tuple, D, {tuple, E, Z}}}}}).

curry4() ->
  fun
    (Z) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (B) ->
                  fun
                    (C) ->
                      fun
                        (D) ->
                          curry4(Z, F, A, B, C, D)
                      end
                  end
              end
          end
      end
  end.

curry4(Z, F, A, B, C, D) ->
  F({tuple, A, {tuple, B, {tuple, C, {tuple, D, Z}}}}).

curry3() ->
  fun
    (Z) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (B) ->
                  fun
                    (C) ->
                      curry3(Z, F, A, B, C)
                  end
              end
          end
      end
  end.

curry3(Z, F, A, B, C) ->
  F({tuple, A, {tuple, B, {tuple, C, Z}}}).

curry2() ->
  fun
    (Z) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (B) ->
                  curry2(Z, F, A, B)
              end
          end
      end
  end.

curry2(Z, F, A, B) ->
  F({tuple, A, {tuple, B, Z}}).

curry10() ->
  fun
    (Z) ->
      fun
        (F_) ->
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
                                                  curry10(
                                                    Z,
                                                    F_,
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
          end
      end
  end.

curry10(Z, F_, A, B, C, D, E, F, G, H, I, J) ->
  F_({ tuple
     , A
     , { tuple
       , B
       , { tuple
         , C
         , { tuple
           , D
           , { tuple
             , E
             , {tuple, F, {tuple, G, {tuple, H, {tuple, I, {tuple, J, Z}}}}}
             }
           }
         }
       }
     }).

curry1() ->
  fun
    (Z) ->
      fun
        (F) ->
          fun
            (A) ->
              curry1(Z, F, A)
          end
      end
  end.

curry1(Z, F, A) ->
  F({tuple, A, Z}).

