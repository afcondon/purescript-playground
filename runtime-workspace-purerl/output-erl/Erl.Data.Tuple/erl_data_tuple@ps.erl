-module(erl_data_tuple@ps).
-export([ untuple1/0
        , toNested9/0
        , toNested8/0
        , toNested7/0
        , toNested6/0
        , toNested5/0
        , toNested4/0
        , toNested3/0
        , toNested2/0
        , toNested10/0
        , showTuple9/0
        , showTuple9/9
        , showTuple8/0
        , showTuple8/8
        , showTuple7/0
        , showTuple7/7
        , showTuple6/0
        , showTuple6/6
        , showTuple5/0
        , showTuple5/5
        , showTuple4/0
        , showTuple4/4
        , showTuple3/0
        , showTuple3/3
        , showTuple2/0
        , showTuple2/2
        , showTuple10/0
        , showTuple10/10
        , showTuple1/0
        , showTuple1/1
        , eqTuple9/0
        , eqTuple9/9
        , eqTuple8/0
        , eqTuple8/8
        , eqTuple7/0
        , eqTuple7/7
        , eqTuple6/0
        , eqTuple6/6
        , eqTuple5/0
        , eqTuple5/5
        , eqTuple4/0
        , eqTuple4/4
        , eqTuple3/0
        , eqTuple3/3
        , eqTuple2/0
        , eqTuple2/2
        , eqTuple10/0
        , eqTuple10/10
        , eqTuple1/0
        , eqTuple1/1
        , eq1Tuple9/0
        , eq1Tuple9/8
        , eq1Tuple8/0
        , eq1Tuple8/7
        , eq1Tuple7/0
        , eq1Tuple7/6
        , eq1Tuple6/0
        , eq1Tuple6/5
        , eq1Tuple5/0
        , eq1Tuple5/4
        , eq1Tuple4/0
        , eq1Tuple4/3
        , eq1Tuple3/0
        , eq1Tuple3/2
        , eq1Tuple2/0
        , eq1Tuple2/1
        , eq1Tuple10/0
        , eq1Tuple10/9
        , eq1Tuple1/0
        , bifunctorTuple2/0
        , bifoldableTuple/0
        , bitraversableTuple2/0
        , tuple1/0
        , tuple2/0
        , tuple3/0
        , tuple4/0
        , tuple5/0
        , tuple6/0
        , tuple7/0
        , tuple8/0
        , tuple9/0
        , tuple10/0
        , uncurry1/0
        , uncurry2/0
        , uncurry3/0
        , uncurry4/0
        , uncurry5/0
        , uncurry6/0
        , uncurry7/0
        , uncurry8/0
        , uncurry9/0
        , uncurry10/0
        , fst/0
        , snd/0
        , untuple1/1
        , toNested9/1
        , toNested8/1
        , toNested7/1
        , toNested6/1
        , toNested5/1
        , toNested4/1
        , toNested3/1
        , toNested2/1
        , toNested10/1
        ]).
-compile(no_auto_import).
untuple1() ->
  fun
    ({X}) ->
      X
  end.

toNested9() ->
  (uncurry9())(data_tuple_nested@ps:tuple9()).

toNested8() ->
  (uncurry8())(data_tuple_nested@ps:tuple8()).

toNested7() ->
  (uncurry7())(data_tuple_nested@ps:tuple7()).

toNested6() ->
  (uncurry6())(data_tuple_nested@ps:tuple6()).

toNested5() ->
  (uncurry5())(data_tuple_nested@ps:tuple5()).

toNested4() ->
  (uncurry4())(data_tuple_nested@ps:tuple4()).

toNested3() ->
  (uncurry3())(data_tuple_nested@ps:tuple3()).

toNested2() ->
  (uncurry2())(data_tuple_nested@ps:tuple2()).

toNested10() ->
  (uncurry10())(data_tuple_nested@ps:tuple10()).

showTuple9() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          fun
            (DictShow2) ->
              fun
                (DictShow3) ->
                  fun
                    (DictShow4) ->
                      fun
                        (DictShow5) ->
                          fun
                            (DictShow6) ->
                              fun
                                (DictShow7) ->
                                  fun
                                    (DictShow8) ->
                                      showTuple9(
                                        DictShow,
                                        DictShow1,
                                        DictShow2,
                                        DictShow3,
                                        DictShow4,
                                        DictShow5,
                                        DictShow6,
                                        DictShow7,
                                        DictShow8
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

showTuple9( #{ show := DictShow }
          , #{ show := DictShow1 }
          , #{ show := DictShow2 }
          , #{ show := DictShow3 }
          , #{ show := DictShow4 }
          , #{ show := DictShow5 }
          , #{ show := DictShow6 }
          , #{ show := DictShow7 }
          , #{ show := DictShow8 }
          ) ->
  #{ show =>
     fun
       ({A, B, C, D, E, F, G, H, I}) ->
         <<
           "(Tuple9 ",
           (DictShow(A))/binary,
           " ",
           (DictShow1(B))/binary,
           " ",
           (DictShow2(C))/binary,
           " ",
           (DictShow3(D))/binary,
           " ",
           (DictShow4(E))/binary,
           " ",
           (DictShow5(F))/binary,
           " ",
           (DictShow6(G))/binary,
           " ",
           (DictShow7(H))/binary,
           " ",
           (DictShow8(I))/binary,
           ")"
         >>
     end
   }.

showTuple8() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          fun
            (DictShow2) ->
              fun
                (DictShow3) ->
                  fun
                    (DictShow4) ->
                      fun
                        (DictShow5) ->
                          fun
                            (DictShow6) ->
                              fun
                                (DictShow7) ->
                                  showTuple8(
                                    DictShow,
                                    DictShow1,
                                    DictShow2,
                                    DictShow3,
                                    DictShow4,
                                    DictShow5,
                                    DictShow6,
                                    DictShow7
                                  )
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

showTuple8( #{ show := DictShow }
          , #{ show := DictShow1 }
          , #{ show := DictShow2 }
          , #{ show := DictShow3 }
          , #{ show := DictShow4 }
          , #{ show := DictShow5 }
          , #{ show := DictShow6 }
          , #{ show := DictShow7 }
          ) ->
  #{ show =>
     fun
       ({A, B, C, D, E, F, G, H}) ->
         <<
           "(Tuple8 ",
           (DictShow(A))/binary,
           " ",
           (DictShow1(B))/binary,
           " ",
           (DictShow2(C))/binary,
           " ",
           (DictShow3(D))/binary,
           " ",
           (DictShow4(E))/binary,
           " ",
           (DictShow5(F))/binary,
           " ",
           (DictShow6(G))/binary,
           " ",
           (DictShow7(H))/binary,
           ")"
         >>
     end
   }.

showTuple7() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          fun
            (DictShow2) ->
              fun
                (DictShow3) ->
                  fun
                    (DictShow4) ->
                      fun
                        (DictShow5) ->
                          fun
                            (DictShow6) ->
                              showTuple7(
                                DictShow,
                                DictShow1,
                                DictShow2,
                                DictShow3,
                                DictShow4,
                                DictShow5,
                                DictShow6
                              )
                          end
                      end
                  end
              end
          end
      end
  end.

showTuple7( #{ show := DictShow }
          , #{ show := DictShow1 }
          , #{ show := DictShow2 }
          , #{ show := DictShow3 }
          , #{ show := DictShow4 }
          , #{ show := DictShow5 }
          , #{ show := DictShow6 }
          ) ->
  #{ show =>
     fun
       ({A, B, C, D, E, F, G}) ->
         <<
           "(Tuple7 ",
           (DictShow(A))/binary,
           " ",
           (DictShow1(B))/binary,
           " ",
           (DictShow2(C))/binary,
           " ",
           (DictShow3(D))/binary,
           " ",
           (DictShow4(E))/binary,
           " ",
           (DictShow5(F))/binary,
           " ",
           (DictShow6(G))/binary,
           ")"
         >>
     end
   }.

showTuple6() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          fun
            (DictShow2) ->
              fun
                (DictShow3) ->
                  fun
                    (DictShow4) ->
                      fun
                        (DictShow5) ->
                          showTuple6(
                            DictShow,
                            DictShow1,
                            DictShow2,
                            DictShow3,
                            DictShow4,
                            DictShow5
                          )
                      end
                  end
              end
          end
      end
  end.

showTuple6( #{ show := DictShow }
          , #{ show := DictShow1 }
          , #{ show := DictShow2 }
          , #{ show := DictShow3 }
          , #{ show := DictShow4 }
          , #{ show := DictShow5 }
          ) ->
  #{ show =>
     fun
       ({A, B, C, D, E, F}) ->
         <<
           "(Tuple6 ",
           (DictShow(A))/binary,
           " ",
           (DictShow1(B))/binary,
           " ",
           (DictShow2(C))/binary,
           " ",
           (DictShow3(D))/binary,
           " ",
           (DictShow4(E))/binary,
           " ",
           (DictShow5(F))/binary,
           ")"
         >>
     end
   }.

showTuple5() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          fun
            (DictShow2) ->
              fun
                (DictShow3) ->
                  fun
                    (DictShow4) ->
                      showTuple5(
                        DictShow,
                        DictShow1,
                        DictShow2,
                        DictShow3,
                        DictShow4
                      )
                  end
              end
          end
      end
  end.

showTuple5( #{ show := DictShow }
          , #{ show := DictShow1 }
          , #{ show := DictShow2 }
          , #{ show := DictShow3 }
          , #{ show := DictShow4 }
          ) ->
  #{ show =>
     fun
       ({A, B, C, D, E}) ->
         <<
           "(Tuple5 ",
           (DictShow(A))/binary,
           " ",
           (DictShow1(B))/binary,
           " ",
           (DictShow2(C))/binary,
           " ",
           (DictShow3(D))/binary,
           " ",
           (DictShow4(E))/binary,
           ")"
         >>
     end
   }.

showTuple4() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          fun
            (DictShow2) ->
              fun
                (DictShow3) ->
                  showTuple4(DictShow, DictShow1, DictShow2, DictShow3)
              end
          end
      end
  end.

showTuple4( #{ show := DictShow }
          , #{ show := DictShow1 }
          , #{ show := DictShow2 }
          , #{ show := DictShow3 }
          ) ->
  #{ show =>
     fun
       ({A, B, C, D}) ->
         <<
           "(Tuple4 ",
           (DictShow(A))/binary,
           " ",
           (DictShow1(B))/binary,
           " ",
           (DictShow2(C))/binary,
           " ",
           (DictShow3(D))/binary,
           ")"
         >>
     end
   }.

showTuple3() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          fun
            (DictShow2) ->
              showTuple3(DictShow, DictShow1, DictShow2)
          end
      end
  end.

showTuple3( #{ show := DictShow }
          , #{ show := DictShow1 }
          , #{ show := DictShow2 }
          ) ->
  #{ show =>
     fun
       ({A, B, C}) ->
         <<
           "(Tuple3 ",
           (DictShow(A))/binary,
           " ",
           (DictShow1(B))/binary,
           " ",
           (DictShow2(C))/binary,
           ")"
         >>
     end
   }.

showTuple2() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showTuple2(DictShow, DictShow1)
      end
  end.

showTuple2(#{ show := DictShow }, #{ show := DictShow1 }) ->
  #{ show =>
     fun
       ({A, B}) ->
         <<"(Tuple2 ", (DictShow(A))/binary, " ", (DictShow1(B))/binary, ")">>
     end
   }.

showTuple10() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          fun
            (DictShow2) ->
              fun
                (DictShow3) ->
                  fun
                    (DictShow4) ->
                      fun
                        (DictShow5) ->
                          fun
                            (DictShow6) ->
                              fun
                                (DictShow7) ->
                                  fun
                                    (DictShow8) ->
                                      fun
                                        (DictShow9) ->
                                          showTuple10(
                                            DictShow,
                                            DictShow1,
                                            DictShow2,
                                            DictShow3,
                                            DictShow4,
                                            DictShow5,
                                            DictShow6,
                                            DictShow7,
                                            DictShow8,
                                            DictShow9
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

showTuple10( #{ show := DictShow }
           , #{ show := DictShow1 }
           , #{ show := DictShow2 }
           , #{ show := DictShow3 }
           , #{ show := DictShow4 }
           , #{ show := DictShow5 }
           , #{ show := DictShow6 }
           , #{ show := DictShow7 }
           , #{ show := DictShow8 }
           , #{ show := DictShow9 }
           ) ->
  #{ show =>
     fun
       ({A, B, C, D, E, F, G, H, I, J}) ->
         <<
           "(Tuple10 ",
           (DictShow(A))/binary,
           " ",
           (DictShow1(B))/binary,
           " ",
           (DictShow2(C))/binary,
           " ",
           (DictShow3(D))/binary,
           " ",
           (DictShow4(E))/binary,
           " ",
           (DictShow5(F))/binary,
           " ",
           (DictShow6(G))/binary,
           " ",
           (DictShow7(H))/binary,
           " ",
           (DictShow8(I))/binary,
           " ",
           (DictShow9(J))/binary,
           ")"
         >>
     end
   }.

showTuple1() ->
  fun
    (DictShow) ->
      showTuple1(DictShow)
  end.

showTuple1(#{ show := DictShow }) ->
  #{ show =>
     fun
       ({A}) ->
         <<"(Tuple1 ", (DictShow(A))/binary, ")">>
     end
   }.

eqTuple9() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      fun
                        (DictEq5) ->
                          fun
                            (DictEq6) ->
                              fun
                                (DictEq7) ->
                                  fun
                                    (DictEq8) ->
                                      eqTuple9(
                                        DictEq,
                                        DictEq1,
                                        DictEq2,
                                        DictEq3,
                                        DictEq4,
                                        DictEq5,
                                        DictEq6,
                                        DictEq7,
                                        DictEq8
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

eqTuple9( #{ eq := DictEq }
        , DictEq1
        , DictEq2
        , DictEq3
        , DictEq4
        , DictEq5
        , DictEq6
        , DictEq7
        , DictEq8
        ) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1, A2, A3, A4, A5, A6, A7, A8, A9} = A,
               {B1, B2, B3, B4, B5, B6, B7, B8, B9} = B,
               ((DictEq(A1))(B1))
                 andalso ((((erlang:map_get(eq, DictEq1))(A2))(B2))
                   andalso ((((erlang:map_get(eq, DictEq2))(A3))(B3))
                     andalso ((((erlang:map_get(eq, DictEq3))(A4))(B4))
                       andalso ((((erlang:map_get(eq, DictEq4))(A5))(B5))
                         andalso ((((erlang:map_get(eq, DictEq5))(A6))(B6))
                           andalso ((((erlang:map_get(eq, DictEq6))(A7))(B7))
                             andalso ((((erlang:map_get(eq, DictEq7))(A8))(B8))
                               andalso (((erlang:map_get(eq, DictEq8))(A9))(B9)))))))))
             end
         end
     end
   }.

eqTuple8() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      fun
                        (DictEq5) ->
                          fun
                            (DictEq6) ->
                              fun
                                (DictEq7) ->
                                  eqTuple8(
                                    DictEq,
                                    DictEq1,
                                    DictEq2,
                                    DictEq3,
                                    DictEq4,
                                    DictEq5,
                                    DictEq6,
                                    DictEq7
                                  )
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

eqTuple8( #{ eq := DictEq }
        , DictEq1
        , DictEq2
        , DictEq3
        , DictEq4
        , DictEq5
        , DictEq6
        , DictEq7
        ) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1, A2, A3, A4, A5, A6, A7, A8} = A,
               {B1, B2, B3, B4, B5, B6, B7, B8} = B,
               ((DictEq(A1))(B1))
                 andalso ((((erlang:map_get(eq, DictEq1))(A2))(B2))
                   andalso ((((erlang:map_get(eq, DictEq2))(A3))(B3))
                     andalso ((((erlang:map_get(eq, DictEq3))(A4))(B4))
                       andalso ((((erlang:map_get(eq, DictEq4))(A5))(B5))
                         andalso ((((erlang:map_get(eq, DictEq5))(A6))(B6))
                           andalso ((((erlang:map_get(eq, DictEq6))(A7))(B7))
                             andalso (((erlang:map_get(eq, DictEq7))(A8))(B8))))))))
             end
         end
     end
   }.

eqTuple7() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      fun
                        (DictEq5) ->
                          fun
                            (DictEq6) ->
                              eqTuple7(
                                DictEq,
                                DictEq1,
                                DictEq2,
                                DictEq3,
                                DictEq4,
                                DictEq5,
                                DictEq6
                              )
                          end
                      end
                  end
              end
          end
      end
  end.

eqTuple7( #{ eq := DictEq }
        , DictEq1
        , DictEq2
        , DictEq3
        , DictEq4
        , DictEq5
        , DictEq6
        ) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1, A2, A3, A4, A5, A6, A7} = A,
               {B1, B2, B3, B4, B5, B6, B7} = B,
               ((DictEq(A1))(B1))
                 andalso ((((erlang:map_get(eq, DictEq1))(A2))(B2))
                   andalso ((((erlang:map_get(eq, DictEq2))(A3))(B3))
                     andalso ((((erlang:map_get(eq, DictEq3))(A4))(B4))
                       andalso ((((erlang:map_get(eq, DictEq4))(A5))(B5))
                         andalso ((((erlang:map_get(eq, DictEq5))(A6))(B6))
                           andalso (((erlang:map_get(eq, DictEq6))(A7))(B7)))))))
             end
         end
     end
   }.

eqTuple6() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      fun
                        (DictEq5) ->
                          eqTuple6(
                            DictEq,
                            DictEq1,
                            DictEq2,
                            DictEq3,
                            DictEq4,
                            DictEq5
                          )
                      end
                  end
              end
          end
      end
  end.

eqTuple6(#{ eq := DictEq }, DictEq1, DictEq2, DictEq3, DictEq4, DictEq5) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1, A2, A3, A4, A5, A6} = A,
               {B1, B2, B3, B4, B5, B6} = B,
               ((DictEq(A1))(B1))
                 andalso ((((erlang:map_get(eq, DictEq1))(A2))(B2))
                   andalso ((((erlang:map_get(eq, DictEq2))(A3))(B3))
                     andalso ((((erlang:map_get(eq, DictEq3))(A4))(B4))
                       andalso ((((erlang:map_get(eq, DictEq4))(A5))(B5))
                         andalso (((erlang:map_get(eq, DictEq5))(A6))(B6))))))
             end
         end
     end
   }.

eqTuple5() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      eqTuple5(DictEq, DictEq1, DictEq2, DictEq3, DictEq4)
                  end
              end
          end
      end
  end.

eqTuple5(#{ eq := DictEq }, DictEq1, DictEq2, DictEq3, DictEq4) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1, A2, A3, A4, A5} = A,
               {B1, B2, B3, B4, B5} = B,
               ((DictEq(A1))(B1))
                 andalso ((((erlang:map_get(eq, DictEq1))(A2))(B2))
                   andalso ((((erlang:map_get(eq, DictEq2))(A3))(B3))
                     andalso ((((erlang:map_get(eq, DictEq3))(A4))(B4))
                       andalso (((erlang:map_get(eq, DictEq4))(A5))(B5)))))
             end
         end
     end
   }.

eqTuple4() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  eqTuple4(DictEq, DictEq1, DictEq2, DictEq3)
              end
          end
      end
  end.

eqTuple4(#{ eq := DictEq }, DictEq1, DictEq2, DictEq3) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1, A2, A3, A4} = A,
               {B1, B2, B3, B4} = B,
               ((DictEq(A1))(B1))
                 andalso ((((erlang:map_get(eq, DictEq1))(A2))(B2))
                   andalso ((((erlang:map_get(eq, DictEq2))(A3))(B3))
                     andalso (((erlang:map_get(eq, DictEq3))(A4))(B4))))
             end
         end
     end
   }.

eqTuple3() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              eqTuple3(DictEq, DictEq1, DictEq2)
          end
      end
  end.

eqTuple3(#{ eq := DictEq }, DictEq1, DictEq2) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1, A2, A3} = A,
               {B1, B2, B3} = B,
               ((DictEq(A1))(B1))
                 andalso ((((erlang:map_get(eq, DictEq1))(A2))(B2))
                   andalso (((erlang:map_get(eq, DictEq2))(A3))(B3)))
             end
         end
     end
   }.

eqTuple2() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          eqTuple2(DictEq, DictEq1)
      end
  end.

eqTuple2(#{ eq := DictEq }, DictEq1) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1, A2} = A,
               {B1, B2} = B,
               ((DictEq(A1))(B1))
                 andalso (((erlang:map_get(eq, DictEq1))(A2))(B2))
             end
         end
     end
   }.

eqTuple10() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      fun
                        (DictEq5) ->
                          fun
                            (DictEq6) ->
                              fun
                                (DictEq7) ->
                                  fun
                                    (DictEq8) ->
                                      fun
                                        (DictEq9) ->
                                          eqTuple10(
                                            DictEq,
                                            DictEq1,
                                            DictEq2,
                                            DictEq3,
                                            DictEq4,
                                            DictEq5,
                                            DictEq6,
                                            DictEq7,
                                            DictEq8,
                                            DictEq9
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

eqTuple10( #{ eq := DictEq }
         , DictEq1
         , DictEq2
         , DictEq3
         , DictEq4
         , DictEq5
         , DictEq6
         , DictEq7
         , DictEq8
         , DictEq9
         ) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1, A2, A3, A4, A5, A6, A7, A8, A9, A10} = A,
               {B1, B2, B3, B4, B5, B6, B7, B8, B9, B10} = B,
               ((DictEq(A1))(B1))
                 andalso ((((erlang:map_get(eq, DictEq1))(A2))(B2))
                   andalso ((((erlang:map_get(eq, DictEq2))(A3))(B3))
                     andalso ((((erlang:map_get(eq, DictEq3))(A4))(B4))
                       andalso ((((erlang:map_get(eq, DictEq4))(A5))(B5))
                         andalso ((((erlang:map_get(eq, DictEq5))(A6))(B6))
                           andalso ((((erlang:map_get(eq, DictEq6))(A7))(B7))
                             andalso ((((erlang:map_get(eq, DictEq7))(A8))(B8))
                               andalso ((((erlang:map_get(eq, DictEq8))(A9))
                                         (B9))
                                 andalso (((erlang:map_get(eq, DictEq9))(A10))
                                          (B10))))))))))
             end
         end
     end
   }.

eqTuple1() ->
  fun
    (DictEq) ->
      eqTuple1(DictEq)
  end.

eqTuple1(#{ eq := DictEq }) ->
  #{ eq =>
     fun
       (A) ->
         fun
           (B) ->
             begin
               {A1} = A,
               {B1} = B,
               (DictEq(A1))(B1)
             end
         end
     end
   }.

eq1Tuple9() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      fun
                        (DictEq5) ->
                          fun
                            (DictEq6) ->
                              fun
                                (DictEq7) ->
                                  eq1Tuple9(
                                    DictEq,
                                    DictEq1,
                                    DictEq2,
                                    DictEq3,
                                    DictEq4,
                                    DictEq5,
                                    DictEq6,
                                    DictEq7
                                  )
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

eq1Tuple9(DictEq, DictEq1, DictEq2, DictEq3, DictEq4, DictEq5, DictEq6, DictEq7) ->
  #{ eq1 =>
     fun
       (DictEq8) ->
         erlang:map_get(
           eq,
           eqTuple9(
             DictEq,
             DictEq1,
             DictEq2,
             DictEq3,
             DictEq4,
             DictEq5,
             DictEq6,
             DictEq7,
             DictEq8
           )
         )
     end
   }.

eq1Tuple8() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      fun
                        (DictEq5) ->
                          fun
                            (DictEq6) ->
                              eq1Tuple8(
                                DictEq,
                                DictEq1,
                                DictEq2,
                                DictEq3,
                                DictEq4,
                                DictEq5,
                                DictEq6
                              )
                          end
                      end
                  end
              end
          end
      end
  end.

eq1Tuple8(DictEq, DictEq1, DictEq2, DictEq3, DictEq4, DictEq5, DictEq6) ->
  #{ eq1 =>
     fun
       (DictEq7) ->
         erlang:map_get(
           eq,
           eqTuple8(
             DictEq,
             DictEq1,
             DictEq2,
             DictEq3,
             DictEq4,
             DictEq5,
             DictEq6,
             DictEq7
           )
         )
     end
   }.

eq1Tuple7() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      fun
                        (DictEq5) ->
                          eq1Tuple7(
                            DictEq,
                            DictEq1,
                            DictEq2,
                            DictEq3,
                            DictEq4,
                            DictEq5
                          )
                      end
                  end
              end
          end
      end
  end.

eq1Tuple7(DictEq, DictEq1, DictEq2, DictEq3, DictEq4, DictEq5) ->
  #{ eq1 =>
     fun
       (DictEq6) ->
         erlang:map_get(
           eq,
           eqTuple7(
             DictEq,
             DictEq1,
             DictEq2,
             DictEq3,
             DictEq4,
             DictEq5,
             DictEq6
           )
         )
     end
   }.

eq1Tuple6() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      eq1Tuple6(DictEq, DictEq1, DictEq2, DictEq3, DictEq4)
                  end
              end
          end
      end
  end.

eq1Tuple6(DictEq, DictEq1, DictEq2, DictEq3, DictEq4) ->
  #{ eq1 =>
     fun
       (DictEq5) ->
         erlang:map_get(
           eq,
           eqTuple6(DictEq, DictEq1, DictEq2, DictEq3, DictEq4, DictEq5)
         )
     end
   }.

eq1Tuple5() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  eq1Tuple5(DictEq, DictEq1, DictEq2, DictEq3)
              end
          end
      end
  end.

eq1Tuple5(DictEq, DictEq1, DictEq2, DictEq3) ->
  #{ eq1 =>
     fun
       (DictEq4) ->
         erlang:map_get(
           eq,
           eqTuple5(DictEq, DictEq1, DictEq2, DictEq3, DictEq4)
         )
     end
   }.

eq1Tuple4() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              eq1Tuple4(DictEq, DictEq1, DictEq2)
          end
      end
  end.

eq1Tuple4(DictEq, DictEq1, DictEq2) ->
  #{ eq1 =>
     fun
       (DictEq3) ->
         erlang:map_get(eq, eqTuple4(DictEq, DictEq1, DictEq2, DictEq3))
     end
   }.

eq1Tuple3() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          eq1Tuple3(DictEq, DictEq1)
      end
  end.

eq1Tuple3(DictEq, DictEq1) ->
  #{ eq1 =>
     fun
       (DictEq2) ->
         erlang:map_get(eq, eqTuple3(DictEq, DictEq1, DictEq2))
     end
   }.

eq1Tuple2() ->
  fun
    (DictEq) ->
      eq1Tuple2(DictEq)
  end.

eq1Tuple2(DictEq) ->
  #{ eq1 =>
     fun
       (DictEq1) ->
         erlang:map_get(eq, eqTuple2(DictEq, DictEq1))
     end
   }.

eq1Tuple10() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          fun
            (DictEq2) ->
              fun
                (DictEq3) ->
                  fun
                    (DictEq4) ->
                      fun
                        (DictEq5) ->
                          fun
                            (DictEq6) ->
                              fun
                                (DictEq7) ->
                                  fun
                                    (DictEq8) ->
                                      eq1Tuple10(
                                        DictEq,
                                        DictEq1,
                                        DictEq2,
                                        DictEq3,
                                        DictEq4,
                                        DictEq5,
                                        DictEq6,
                                        DictEq7,
                                        DictEq8
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

eq1Tuple10( DictEq
          , DictEq1
          , DictEq2
          , DictEq3
          , DictEq4
          , DictEq5
          , DictEq6
          , DictEq7
          , DictEq8
          ) ->
  #{ eq1 =>
     fun
       (DictEq9) ->
         erlang:map_get(
           eq,
           eqTuple10(
             DictEq,
             DictEq1,
             DictEq2,
             DictEq3,
             DictEq4,
             DictEq5,
             DictEq6,
             DictEq7,
             DictEq8,
             DictEq9
           )
         )
     end
   }.

eq1Tuple1() ->
  #{ eq1 =>
     fun
       (DictEq) ->
         erlang:map_get(eq, eqTuple1(DictEq))
     end
   }.

bifunctorTuple2() ->
  #{ bimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (Tuple) ->
                 { F(erl_data_tuple@foreign:fst(Tuple))
                 , G(erl_data_tuple@foreign:snd(Tuple))
                 }
             end
         end
     end
   }.

bifoldableTuple() ->
  #{ bifoldMap =>
     fun
       (#{ 'Semigroup0' := DictMonoid }) ->
         fun
           (F) ->
             fun
               (G) ->
                 fun
                   (T) ->
                     ((erlang:map_get(append, DictMonoid(undefined)))
                      (F(erl_data_tuple@foreign:fst(T))))
                     (G(erl_data_tuple@foreign:snd(T)))
                 end
             end
         end
     end
   , bifoldr =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (Z) ->
                 fun
                   (T) ->
                     (F(erl_data_tuple@foreign:fst(T)))
                     ((G(erl_data_tuple@foreign:snd(T)))(Z))
                 end
             end
         end
     end
   , bifoldl =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (Z) ->
                 fun
                   (T) ->
                     (G((F(Z))(erl_data_tuple@foreign:fst(T))))
                     (erl_data_tuple@foreign:snd(T))
                 end
             end
         end
     end
   }.

bitraversableTuple2() ->
  #{ bitraverse =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         begin
           #{ 'Functor0' := Apply0, apply := Apply0@1 } =
             DictApplicative(undefined),
           fun
             (F) ->
               fun
                 (G) ->
                   fun
                     (T) ->
                       (Apply0@1(((erlang:map_get(map, Apply0(undefined)))
                                  (tuple2()))
                                 (F(erl_data_tuple@foreign:fst(T)))))
                       (G(erl_data_tuple@foreign:snd(T)))
                   end
               end
           end
         end
     end
   , bisequence =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         begin
           #{ 'Functor0' := Apply0, apply := Apply0@1 } =
             DictApplicative(undefined),
           fun
             (T) ->
               (Apply0@1(((erlang:map_get(map, Apply0(undefined)))(tuple2()))
                         (erl_data_tuple@foreign:fst(T))))
               (erl_data_tuple@foreign:snd(T))
           end
         end
     end
   , 'Bifunctor0' =>
     fun
       (_) ->
         bifunctorTuple2()
     end
   , 'Bifoldable1' =>
     fun
       (_) ->
         bifoldableTuple()
     end
   }.

tuple1() ->
  fun
    (V) ->
      erl_data_tuple@foreign:tuple1(V)
  end.

tuple2() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:tuple2(V, V@1)
      end
  end.

tuple3() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              erl_data_tuple@foreign:tuple3(V, V@1, V@2)
          end
      end
  end.

tuple4() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  erl_data_tuple@foreign:tuple4(V, V@1, V@2, V@3)
              end
          end
      end
  end.

tuple5() ->
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
                      erl_data_tuple@foreign:tuple5(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

tuple6() ->
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
                          erl_data_tuple@foreign:tuple6(
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

tuple7() ->
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
                              erl_data_tuple@foreign:tuple7(
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

tuple8() ->
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
                                  erl_data_tuple@foreign:tuple8(
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

tuple9() ->
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
                                      erl_data_tuple@foreign:tuple9(
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

tuple10() ->
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
                                          erl_data_tuple@foreign:tuple10(
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

uncurry1() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry1(V, V@1)
      end
  end.

uncurry2() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry2(V, V@1)
      end
  end.

uncurry3() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry3(V, V@1)
      end
  end.

uncurry4() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry4(V, V@1)
      end
  end.

uncurry5() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry5(V, V@1)
      end
  end.

uncurry6() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry6(V, V@1)
      end
  end.

uncurry7() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry7(V, V@1)
      end
  end.

uncurry8() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry8(V, V@1)
      end
  end.

uncurry9() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry9(V, V@1)
      end
  end.

uncurry10() ->
  fun
    (V) ->
      fun
        (V@1) ->
          erl_data_tuple@foreign:uncurry10(V, V@1)
      end
  end.

fst() ->
  fun
    (V) ->
      erl_data_tuple@foreign:fst(V)
  end.

snd() ->
  fun
    (V) ->
      erl_data_tuple@foreign:snd(V)
  end.

untuple1(V) ->
  begin
    {X} = V,
    X
  end.

toNested9(V) ->
  erl_data_tuple@foreign:uncurry9(data_tuple_nested@ps:tuple9(), V).

toNested8(V) ->
  erl_data_tuple@foreign:uncurry8(data_tuple_nested@ps:tuple8(), V).

toNested7(V) ->
  erl_data_tuple@foreign:uncurry7(data_tuple_nested@ps:tuple7(), V).

toNested6(V) ->
  erl_data_tuple@foreign:uncurry6(data_tuple_nested@ps:tuple6(), V).

toNested5(V) ->
  erl_data_tuple@foreign:uncurry5(data_tuple_nested@ps:tuple5(), V).

toNested4(V) ->
  erl_data_tuple@foreign:uncurry4(data_tuple_nested@ps:tuple4(), V).

toNested3(V) ->
  erl_data_tuple@foreign:uncurry3(data_tuple_nested@ps:tuple3(), V).

toNested2(V) ->
  erl_data_tuple@foreign:uncurry2(data_tuple_nested@ps:tuple2(), V).

toNested10(V) ->
  erl_data_tuple@foreign:uncurry10(data_tuple_nested@ps:tuple10(), V).

