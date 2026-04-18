-module(data_function_uncurried@ps).
-export([ runFn1/0
        , runFn1/1
        , mkFn1/0
        , mkFn1/1
        , mkFn0/0
        , mkFn2/0
        , mkFn3/0
        , mkFn4/0
        , mkFn5/0
        , mkFn6/0
        , mkFn7/0
        , mkFn8/0
        , mkFn9/0
        , mkFn10/0
        , runFn0/0
        , runFn2/0
        , runFn3/0
        , runFn4/0
        , runFn5/0
        , runFn6/0
        , runFn7/0
        , runFn8/0
        , runFn9/0
        , runFn10/0
        ]).
-compile(no_auto_import).
runFn1() ->
  fun
    (F) ->
      runFn1(F)
  end.

runFn1(F) ->
  F.

mkFn1() ->
  fun
    (F) ->
      mkFn1(F)
  end.

mkFn1(F) ->
  F.

mkFn0() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn0(V)
  end.

mkFn2() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn2(V)
  end.

mkFn3() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn3(V)
  end.

mkFn4() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn4(V)
  end.

mkFn5() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn5(V)
  end.

mkFn6() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn6(V)
  end.

mkFn7() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn7(V)
  end.

mkFn8() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn8(V)
  end.

mkFn9() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn9(V)
  end.

mkFn10() ->
  fun
    (V) ->
      data_function_uncurried@foreign:mkFn10(V)
  end.

runFn0() ->
  fun
    (V) ->
      data_function_uncurried@foreign:runFn0(V)
  end.

runFn2() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_function_uncurried@foreign:runFn2(V, V@1, V@2)
          end
      end
  end.

runFn3() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_function_uncurried@foreign:runFn3(V, V@1, V@2, V@3)
              end
          end
      end
  end.

runFn4() ->
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
                      data_function_uncurried@foreign:runFn4(
                        V,
                        V@1,
                        V@2,
                        V@3,
                        V@4
                      )
                  end
              end
          end
      end
  end.

runFn5() ->
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
                          data_function_uncurried@foreign:runFn5(
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

runFn6() ->
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
                          fun
                            (V@6) ->
                              data_function_uncurried@foreign:runFn6(
                                V,
                                V@1,
                                V@2,
                                V@3,
                                V@4,
                                V@5,
                                V@6
                              )
                          end
                      end
                  end
              end
          end
      end
  end.

runFn7() ->
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
                          fun
                            (V@6) ->
                              fun
                                (V@7) ->
                                  data_function_uncurried@foreign:runFn7(
                                    V,
                                    V@1,
                                    V@2,
                                    V@3,
                                    V@4,
                                    V@5,
                                    V@6,
                                    V@7
                                  )
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

runFn8() ->
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
                          fun
                            (V@6) ->
                              fun
                                (V@7) ->
                                  fun
                                    (V@8) ->
                                      data_function_uncurried@foreign:runFn8(
                                        V,
                                        V@1,
                                        V@2,
                                        V@3,
                                        V@4,
                                        V@5,
                                        V@6,
                                        V@7,
                                        V@8
                                      )
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

runFn9() ->
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
                          fun
                            (V@6) ->
                              fun
                                (V@7) ->
                                  fun
                                    (V@8) ->
                                      fun
                                        (V@9) ->
                                          data_function_uncurried@foreign:runFn9(
                                            V,
                                            V@1,
                                            V@2,
                                            V@3,
                                            V@4,
                                            V@5,
                                            V@6,
                                            V@7,
                                            V@8,
                                            V@9
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

runFn10() ->
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
                          fun
                            (V@6) ->
                              fun
                                (V@7) ->
                                  fun
                                    (V@8) ->
                                      fun
                                        (V@9) ->
                                          fun
                                            (V@10) ->
                                              data_function_uncurried@foreign:runFn10(
                                                V,
                                                V@1,
                                                V@2,
                                                V@3,
                                                V@4,
                                                V@5,
                                                V@6,
                                                V@7,
                                                V@8,
                                                V@9,
                                                V@10
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

