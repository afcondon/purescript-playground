-module(data_functor_coproduct_nested@ps).
-export([ in9/0
        , in9/1
        , in8/0
        , in8/1
        , in7/0
        , in7/1
        , in6/0
        , in6/1
        , in5/0
        , in5/1
        , in4/0
        , in4/1
        , in3/0
        , in3/1
        , in2/0
        , in2/1
        , in10/0
        , in10/1
        , in1/0
        , coproduct9/0
        , coproduct9/10
        , coproduct8/0
        , coproduct8/9
        , coproduct7/0
        , coproduct7/8
        , coproduct6/0
        , coproduct6/7
        , coproduct5/0
        , coproduct5/6
        , coproduct4/0
        , coproduct4/5
        , coproduct3/0
        , coproduct3/4
        , coproduct2/0
        , coproduct2/3
        , coproduct10/0
        , coproduct10/11
        , coproduct1/0
        , coproduct1/1
        , at9/0
        , at9/3
        , at8/0
        , at8/3
        , at7/0
        , at7/3
        , at6/0
        , at6/3
        , at5/0
        , at5/3
        , at4/0
        , at4/3
        , at3/0
        , at3/3
        , at2/0
        , at2/3
        , at10/0
        , at10/3
        , at1/0
        , at1/3
        , in1/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
in9() ->
  fun
    (V) ->
      in9(V)
  end.

in9(V) ->
  { right
  , {right, {right, {right, {right, {right, {right, {right, {left, V}}}}}}}}
  }.

in8() ->
  fun
    (V) ->
      in8(V)
  end.

in8(V) ->
  {right, {right, {right, {right, {right, {right, {right, {left, V}}}}}}}}.

in7() ->
  fun
    (V) ->
      in7(V)
  end.

in7(V) ->
  {right, {right, {right, {right, {right, {right, {left, V}}}}}}}.

in6() ->
  fun
    (V) ->
      in6(V)
  end.

in6(V) ->
  {right, {right, {right, {right, {right, {left, V}}}}}}.

in5() ->
  fun
    (V) ->
      in5(V)
  end.

in5(V) ->
  {right, {right, {right, {right, {left, V}}}}}.

in4() ->
  fun
    (V) ->
      in4(V)
  end.

in4(V) ->
  {right, {right, {right, {left, V}}}}.

in3() ->
  fun
    (V) ->
      in3(V)
  end.

in3(V) ->
  {right, {right, {left, V}}}.

in2() ->
  fun
    (V) ->
      in2(V)
  end.

in2(V) ->
  {right, {left, V}}.

in10() ->
  fun
    (V) ->
      in10(V)
  end.

in10(V) ->
  { right
  , { right
    , {right, {right, {right, {right, {right, {right, {right, {left, V}}}}}}}}
    }
  }.

in1() ->
  data_functor_coproduct@ps:left().

coproduct9() ->
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
                                        (Y) ->
                                          coproduct9(
                                            A,
                                            B,
                                            C,
                                            D,
                                            E,
                                            F,
                                            G,
                                            H,
                                            I,
                                            Y
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

coproduct9(A, B, C, D, E, F, G, H, I, Y) ->
  case Y of
    {left, Y@1} ->
      A(Y@1);
    {right, Y@2} ->
      case Y@2 of
        {left, Y@3} ->
          B(Y@3);
        {right, Y@4} ->
          case Y@4 of
            {left, Y@5} ->
              C(Y@5);
            {right, Y@6} ->
              case Y@6 of
                {left, Y@7} ->
                  D(Y@7);
                {right, Y@8} ->
                  case Y@8 of
                    {left, Y@9} ->
                      E(Y@9);
                    {right, Y@10} ->
                      case Y@10 of
                        {left, Y@11} ->
                          F(Y@11);
                        {right, Y@12} ->
                          case Y@12 of
                            {left, Y@13} ->
                              G(Y@13);
                            {right, Y@14} ->
                              case Y@14 of
                                {left, Y@15} ->
                                  H(Y@15);
                                {right, Y@16} ->
                                  case Y@16 of
                                    {left, Y@17} ->
                                      I(Y@17);
                                    {right, Y@18} ->
                                      begin
                                        Spin =
                                          fun
                                            Spin (V) ->
                                              Spin(V)
                                          end,
                                        Spin(Y@18)
                                      end;
                                    _ ->
                                      erlang:error({ fail
                                                   , <<"Failed pattern match">>
                                                   })
                                  end;
                                _ ->
                                  erlang:error({ fail
                                               , <<"Failed pattern match">>
                                               })
                              end;
                            _ ->
                              erlang:error({fail, <<"Failed pattern match">>})
                          end;
                        _ ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end;
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

coproduct8() ->
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
                                    (Y) ->
                                      coproduct8(A, B, C, D, E, F, G, H, Y)
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

coproduct8(A, B, C, D, E, F, G, H, Y) ->
  case Y of
    {left, Y@1} ->
      A(Y@1);
    {right, Y@2} ->
      case Y@2 of
        {left, Y@3} ->
          B(Y@3);
        {right, Y@4} ->
          case Y@4 of
            {left, Y@5} ->
              C(Y@5);
            {right, Y@6} ->
              case Y@6 of
                {left, Y@7} ->
                  D(Y@7);
                {right, Y@8} ->
                  case Y@8 of
                    {left, Y@9} ->
                      E(Y@9);
                    {right, Y@10} ->
                      case Y@10 of
                        {left, Y@11} ->
                          F(Y@11);
                        {right, Y@12} ->
                          case Y@12 of
                            {left, Y@13} ->
                              G(Y@13);
                            {right, Y@14} ->
                              case Y@14 of
                                {left, Y@15} ->
                                  H(Y@15);
                                {right, Y@16} ->
                                  begin
                                    Spin =
                                      fun
                                        Spin (V) ->
                                          Spin(V)
                                      end,
                                    Spin(Y@16)
                                  end;
                                _ ->
                                  erlang:error({ fail
                                               , <<"Failed pattern match">>
                                               })
                              end;
                            _ ->
                              erlang:error({fail, <<"Failed pattern match">>})
                          end;
                        _ ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end;
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

coproduct7() ->
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
                                (Y) ->
                                  coproduct7(A, B, C, D, E, F, G, Y)
                              end
                          end
                      end
                  end
              end
          end
      end
  end.

coproduct7(A, B, C, D, E, F, G, Y) ->
  case Y of
    {left, Y@1} ->
      A(Y@1);
    {right, Y@2} ->
      case Y@2 of
        {left, Y@3} ->
          B(Y@3);
        {right, Y@4} ->
          case Y@4 of
            {left, Y@5} ->
              C(Y@5);
            {right, Y@6} ->
              case Y@6 of
                {left, Y@7} ->
                  D(Y@7);
                {right, Y@8} ->
                  case Y@8 of
                    {left, Y@9} ->
                      E(Y@9);
                    {right, Y@10} ->
                      case Y@10 of
                        {left, Y@11} ->
                          F(Y@11);
                        {right, Y@12} ->
                          case Y@12 of
                            {left, Y@13} ->
                              G(Y@13);
                            {right, Y@14} ->
                              begin
                                Spin =
                                  fun
                                    Spin (V) ->
                                      Spin(V)
                                  end,
                                Spin(Y@14)
                              end;
                            _ ->
                              erlang:error({fail, <<"Failed pattern match">>})
                          end;
                        _ ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end;
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

coproduct6() ->
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
                            (Y) ->
                              coproduct6(A, B, C, D, E, F, Y)
                          end
                      end
                  end
              end
          end
      end
  end.

coproduct6(A, B, C, D, E, F, Y) ->
  case Y of
    {left, Y@1} ->
      A(Y@1);
    {right, Y@2} ->
      case Y@2 of
        {left, Y@3} ->
          B(Y@3);
        {right, Y@4} ->
          case Y@4 of
            {left, Y@5} ->
              C(Y@5);
            {right, Y@6} ->
              case Y@6 of
                {left, Y@7} ->
                  D(Y@7);
                {right, Y@8} ->
                  case Y@8 of
                    {left, Y@9} ->
                      E(Y@9);
                    {right, Y@10} ->
                      case Y@10 of
                        {left, Y@11} ->
                          F(Y@11);
                        {right, Y@12} ->
                          begin
                            Spin =
                              fun
                                Spin (V) ->
                                  Spin(V)
                              end,
                            Spin(Y@12)
                          end;
                        _ ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end;
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

coproduct5() ->
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
                        (Y) ->
                          coproduct5(A, B, C, D, E, Y)
                      end
                  end
              end
          end
      end
  end.

coproduct5(A, B, C, D, E, Y) ->
  case Y of
    {left, Y@1} ->
      A(Y@1);
    {right, Y@2} ->
      case Y@2 of
        {left, Y@3} ->
          B(Y@3);
        {right, Y@4} ->
          case Y@4 of
            {left, Y@5} ->
              C(Y@5);
            {right, Y@6} ->
              case Y@6 of
                {left, Y@7} ->
                  D(Y@7);
                {right, Y@8} ->
                  case Y@8 of
                    {left, Y@9} ->
                      E(Y@9);
                    {right, Y@10} ->
                      begin
                        Spin =
                          fun
                            Spin (V) ->
                              Spin(V)
                          end,
                        Spin(Y@10)
                      end;
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

coproduct4() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (D) ->
                  fun
                    (Y) ->
                      coproduct4(A, B, C, D, Y)
                  end
              end
          end
      end
  end.

coproduct4(A, B, C, D, Y) ->
  case Y of
    {left, Y@1} ->
      A(Y@1);
    {right, Y@2} ->
      case Y@2 of
        {left, Y@3} ->
          B(Y@3);
        {right, Y@4} ->
          case Y@4 of
            {left, Y@5} ->
              C(Y@5);
            {right, Y@6} ->
              case Y@6 of
                {left, Y@7} ->
                  D(Y@7);
                {right, Y@8} ->
                  begin
                    Spin =
                      fun
                        Spin (V) ->
                          Spin(V)
                      end,
                    Spin(Y@8)
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

coproduct3() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (C) ->
              fun
                (Y) ->
                  coproduct3(A, B, C, Y)
              end
          end
      end
  end.

coproduct3(A, B, C, Y) ->
  case Y of
    {left, Y@1} ->
      A(Y@1);
    {right, Y@2} ->
      case Y@2 of
        {left, Y@3} ->
          B(Y@3);
        {right, Y@4} ->
          case Y@4 of
            {left, Y@5} ->
              C(Y@5);
            {right, Y@6} ->
              begin
                Spin =
                  fun
                    Spin (V) ->
                      Spin(V)
                  end,
                Spin(Y@6)
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

coproduct2() ->
  fun
    (A) ->
      fun
        (B) ->
          fun
            (Y) ->
              coproduct2(A, B, Y)
          end
      end
  end.

coproduct2(A, B, Y) ->
  case Y of
    {left, Y@1} ->
      A(Y@1);
    {right, Y@2} ->
      case Y@2 of
        {left, Y@3} ->
          B(Y@3);
        {right, Y@4} ->
          begin
            Spin =
              fun
                Spin (V) ->
                  Spin(V)
              end,
            Spin(Y@4)
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

coproduct10() ->
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
                                          fun
                                            (Y) ->
                                              coproduct10(
                                                A,
                                                B,
                                                C,
                                                D,
                                                E,
                                                F,
                                                G,
                                                H,
                                                I,
                                                J,
                                                Y
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

coproduct10(A, B, C, D, E, F, G, H, I, J, Y) ->
  case Y of
    {left, Y@1} ->
      A(Y@1);
    {right, Y@2} ->
      case Y@2 of
        {left, Y@3} ->
          B(Y@3);
        {right, Y@4} ->
          case Y@4 of
            {left, Y@5} ->
              C(Y@5);
            {right, Y@6} ->
              case Y@6 of
                {left, Y@7} ->
                  D(Y@7);
                {right, Y@8} ->
                  case Y@8 of
                    {left, Y@9} ->
                      E(Y@9);
                    {right, Y@10} ->
                      case Y@10 of
                        {left, Y@11} ->
                          F(Y@11);
                        {right, Y@12} ->
                          case Y@12 of
                            {left, Y@13} ->
                              G(Y@13);
                            {right, Y@14} ->
                              case Y@14 of
                                {left, Y@15} ->
                                  H(Y@15);
                                {right, Y@16} ->
                                  case Y@16 of
                                    {left, Y@17} ->
                                      I(Y@17);
                                    {right, Y@18} ->
                                      case Y@18 of
                                        {left, Y@19} ->
                                          J(Y@19);
                                        {right, Y@20} ->
                                          begin
                                            Spin =
                                              fun
                                                Spin (V) ->
                                                  Spin(V)
                                              end,
                                            Spin(Y@20)
                                          end;
                                        _ ->
                                          erlang:error({ fail
                                                       , <<
                                                           "Failed pattern match"
                                                         >>
                                                       })
                                      end;
                                    _ ->
                                      erlang:error({ fail
                                                   , <<"Failed pattern match">>
                                                   })
                                  end;
                                _ ->
                                  erlang:error({ fail
                                               , <<"Failed pattern match">>
                                               })
                              end;
                            _ ->
                              erlang:error({fail, <<"Failed pattern match">>})
                          end;
                        _ ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end;
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end;
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end;
        _ ->
          erlang:error({fail, <<"Failed pattern match">>})
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

coproduct1() ->
  fun
    (Y) ->
      coproduct1(Y)
  end.

coproduct1(Y) ->
  case Y of
    {left, Y@1} ->
      Y@1;
    {right, Y@2} ->
      begin
        Spin =
          fun
            Spin (V) ->
              Spin(V)
          end,
        Spin(Y@2)
      end;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

at9() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at9(B, F, Y)
          end
      end
  end.

at9(B, F, Y) ->
  if
    ?IS_KNOWN_TAG(right, 1, Y)
      andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, Y))
        andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, erlang:element(2, Y)))
          andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                             2,
                                             erlang:element(
                                               2,
                                               erlang:element(2, Y)
                                             )
                                           ))
            andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                               2,
                                               erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(2, Y)
                                                 )
                                               )
                                             ))
              andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(2, Y)
                                                     )
                                                   )
                                                 )
                                               ))
                andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(
                                                           2,
                                                           erlang:element(2, Y)
                                                         )
                                                       )
                                                     )
                                                   )
                                                 ))
                  andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(
                                                           2,
                                                           erlang:element(
                                                             2,
                                                             erlang:element(
                                                               2,
                                                               erlang:element(
                                                                 2,
                                                                 Y
                                                               )
                                                             )
                                                           )
                                                         )
                                                       )
                                                     )
                                                   ))
                    andalso ?IS_KNOWN_TAG(left, 1, erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(
                                                           2,
                                                           erlang:element(
                                                             2,
                                                             erlang:element(
                                                               2,
                                                               erlang:element(
                                                                 2,
                                                                 erlang:element(
                                                                   2,
                                                                   Y
                                                                 )
                                                               )
                                                             )
                                                           )
                                                         )
                                                       )
                                                     )
                                                   ))))))))) ->
      begin
        { right
        , { right
          , {right, {right, {right, {right, {right, {right, {left, Y@1}}}}}}}
          }
        } =
          Y,
        F(Y@1)
      end;
    true ->
      B
  end.

at8() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at8(B, F, Y)
          end
      end
  end.

at8(B, F, Y) ->
  if
    ?IS_KNOWN_TAG(right, 1, Y)
      andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, Y))
        andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, erlang:element(2, Y)))
          andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                             2,
                                             erlang:element(
                                               2,
                                               erlang:element(2, Y)
                                             )
                                           ))
            andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                               2,
                                               erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(2, Y)
                                                 )
                                               )
                                             ))
              andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(2, Y)
                                                     )
                                                   )
                                                 )
                                               ))
                andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(
                                                           2,
                                                           erlang:element(2, Y)
                                                         )
                                                       )
                                                     )
                                                   )
                                                 ))
                  andalso ?IS_KNOWN_TAG(left, 1, erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(
                                                           2,
                                                           erlang:element(
                                                             2,
                                                             erlang:element(
                                                               2,
                                                               Y
                                                             )
                                                           )
                                                         )
                                                       )
                                                     )
                                                   )
                                                 )))))))) ->
      begin
        { right
        , {right, {right, {right, {right, {right, {right, {left, Y@1}}}}}}}
        } =
          Y,
        F(Y@1)
      end;
    true ->
      B
  end.

at7() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at7(B, F, Y)
          end
      end
  end.

at7(B, F, Y) ->
  if
    ?IS_KNOWN_TAG(right, 1, Y)
      andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, Y))
        andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, erlang:element(2, Y)))
          andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                             2,
                                             erlang:element(
                                               2,
                                               erlang:element(2, Y)
                                             )
                                           ))
            andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                               2,
                                               erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(2, Y)
                                                 )
                                               )
                                             ))
              andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(2, Y)
                                                     )
                                                   )
                                                 )
                                               ))
                andalso ?IS_KNOWN_TAG(left, 1, erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(2, Y)
                                                       )
                                                     )
                                                   )
                                                 )
                                               ))))))) ->
      begin
        {right, {right, {right, {right, {right, {right, {left, Y@1}}}}}}} = Y,
        F(Y@1)
      end;
    true ->
      B
  end.

at6() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at6(B, F, Y)
          end
      end
  end.

at6(B, F, Y) ->
  if
    ?IS_KNOWN_TAG(right, 1, Y)
      andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, Y))
        andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, erlang:element(2, Y)))
          andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                             2,
                                             erlang:element(
                                               2,
                                               erlang:element(2, Y)
                                             )
                                           ))
            andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                               2,
                                               erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(2, Y)
                                                 )
                                               )
                                             ))
              andalso ?IS_KNOWN_TAG(left, 1, erlang:element(
                                               2,
                                               erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(2, Y)
                                                   )
                                                 )
                                               )
                                             )))))) ->
      begin
        {right, {right, {right, {right, {right, {left, Y@1}}}}}} = Y,
        F(Y@1)
      end;
    true ->
      B
  end.

at5() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at5(B, F, Y)
          end
      end
  end.

at5(B, F, Y) ->
  if
    ?IS_KNOWN_TAG(right, 1, Y)
      andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, Y))
        andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, erlang:element(2, Y)))
          andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                             2,
                                             erlang:element(
                                               2,
                                               erlang:element(2, Y)
                                             )
                                           ))
            andalso ?IS_KNOWN_TAG(left, 1, erlang:element(
                                             2,
                                             erlang:element(
                                               2,
                                               erlang:element(
                                                 2,
                                                 erlang:element(2, Y)
                                               )
                                             )
                                           ))))) ->
      begin
        {right, {right, {right, {right, {left, Y@1}}}}} = Y,
        F(Y@1)
      end;
    true ->
      B
  end.

at4() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at4(B, F, Y)
          end
      end
  end.

at4(B, F, Y) ->
  if
    ?IS_KNOWN_TAG(right, 1, Y)
      andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, Y))
        andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, erlang:element(2, Y)))
          andalso ?IS_KNOWN_TAG(left, 1, erlang:element(
                                           2,
                                           erlang:element(
                                             2,
                                             erlang:element(2, Y)
                                           )
                                         )))) ->
      begin
        {right, {right, {right, {left, Y@1}}}} = Y,
        F(Y@1)
      end;
    true ->
      B
  end.

at3() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at3(B, F, Y)
          end
      end
  end.

at3(B, F, Y) ->
  if
    ?IS_KNOWN_TAG(right, 1, Y)
      andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, Y))
        andalso ?IS_KNOWN_TAG(left, 1, erlang:element(2, erlang:element(2, Y)))) ->
      begin
        {right, {right, {left, Y@1}}} = Y,
        F(Y@1)
      end;
    true ->
      B
  end.

at2() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at2(B, F, Y)
          end
      end
  end.

at2(B, F, Y) ->
  if
    ?IS_KNOWN_TAG(right, 1, Y)
      andalso ?IS_KNOWN_TAG(left, 1, erlang:element(2, Y)) ->
      begin
        {right, {left, Y@1}} = Y,
        F(Y@1)
      end;
    true ->
      B
  end.

at10() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at10(B, F, Y)
          end
      end
  end.

at10(B, F, Y) ->
  if
    ?IS_KNOWN_TAG(right, 1, Y)
      andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, Y))
        andalso (?IS_KNOWN_TAG(right, 1, erlang:element(2, erlang:element(2, Y)))
          andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                             2,
                                             erlang:element(
                                               2,
                                               erlang:element(2, Y)
                                             )
                                           ))
            andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                               2,
                                               erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(2, Y)
                                                 )
                                               )
                                             ))
              andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                 2,
                                                 erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(2, Y)
                                                     )
                                                   )
                                                 )
                                               ))
                andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                   2,
                                                   erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(
                                                           2,
                                                           erlang:element(2, Y)
                                                         )
                                                       )
                                                     )
                                                   )
                                                 ))
                  andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                     2,
                                                     erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(
                                                           2,
                                                           erlang:element(
                                                             2,
                                                             erlang:element(
                                                               2,
                                                               erlang:element(
                                                                 2,
                                                                 Y
                                                               )
                                                             )
                                                           )
                                                         )
                                                       )
                                                     )
                                                   ))
                    andalso (?IS_KNOWN_TAG(right, 1, erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(
                                                           2,
                                                           erlang:element(
                                                             2,
                                                             erlang:element(
                                                               2,
                                                               erlang:element(
                                                                 2,
                                                                 erlang:element(
                                                                   2,
                                                                   erlang:element(
                                                                     2,
                                                                     Y
                                                                   )
                                                                 )
                                                               )
                                                             )
                                                           )
                                                         )
                                                       )
                                                     ))
                      andalso ?IS_KNOWN_TAG(left, 1, erlang:element(
                                                       2,
                                                       erlang:element(
                                                         2,
                                                         erlang:element(
                                                           2,
                                                           erlang:element(
                                                             2,
                                                             erlang:element(
                                                               2,
                                                               erlang:element(
                                                                 2,
                                                                 erlang:element(
                                                                   2,
                                                                   erlang:element(
                                                                     2,
                                                                     erlang:element(
                                                                       2,
                                                                       Y
                                                                     )
                                                                   )
                                                                 )
                                                               )
                                                             )
                                                           )
                                                         )
                                                       )
                                                     )))))))))) ->
      begin
        { right
        , { right
          , { right
            , {right, {right, {right, {right, {right, {right, {left, Y@1}}}}}}}
            }
          }
        } =
          Y,
        F(Y@1)
      end;
    true ->
      B
  end.

at1() ->
  fun
    (B) ->
      fun
        (F) ->
          fun
            (Y) ->
              at1(B, F, Y)
          end
      end
  end.

at1(B, F, Y) ->
  case Y of
    {left, Y@1} ->
      F(Y@1);
    _ ->
      B
  end.

in1(V) ->
  data_functor_coproduct@ps:left(V).

