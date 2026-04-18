-module(data_either@ps).
-export([ 'Left'/0
        , 'Right'/0
        , showEither/0
        , showEither/2
        , 'note\''/0
        , 'note\''/2
        , note/0
        , note/2
        , genericEither/0
        , functorEither/0
        , invariantEither/0
        , 'fromRight\''/0
        , 'fromRight\''/2
        , fromRight/0
        , fromRight/2
        , 'fromLeft\''/0
        , 'fromLeft\''/2
        , fromLeft/0
        , fromLeft/2
        , extendEither/0
        , eqEither/0
        , eqEither/2
        , ordEither/0
        , ordEither/1
        , eq1Either/0
        , eq1Either/1
        , ord1Either/0
        , ord1Either/1
        , either/0
        , either/3
        , hush/0
        , hush/1
        , isLeft/0
        , isLeft/1
        , isRight/0
        , isRight/1
        , choose/0
        , choose/1
        , boundedEither/0
        , boundedEither/1
        , applyEither/0
        , bindEither/0
        , semigroupEither/0
        , semigroupEither/1
        , applicativeEither/0
        , monadEither/0
        , altEither/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'Left'() ->
  fun
    (Value0) ->
      {left, Value0}
  end.

'Right'() ->
  fun
    (Value0) ->
      {right, Value0}
  end.

showEither() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showEither(DictShow, DictShow1)
      end
  end.

showEither(DictShow, DictShow1) ->
  #{ show =>
     fun
       (V) ->
         case V of
           {left, V@1} ->
             begin
               #{ show := DictShow@1 } = DictShow,
               <<"(Left ", (DictShow@1(V@1))/binary, ")">>
             end;
           {right, V@2} ->
             begin
               #{ show := DictShow1@1 } = DictShow1,
               <<"(Right ", (DictShow1@1(V@2))/binary, ")">>
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

'note\''() ->
  fun
    (F) ->
      fun
        (V2) ->
          'note\''(F, V2)
      end
  end.

'note\''(F, V2) ->
  case V2 of
    {nothing} ->
      {left, F(unit)};
    {just, V2@1} ->
      {right, V2@1};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

note() ->
  fun
    (A) ->
      fun
        (V2) ->
          note(A, V2)
      end
  end.

note(A, V2) ->
  case V2 of
    {nothing} ->
      {left, A};
    {just, V2@1} ->
      {right, V2@1};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

genericEither() ->
  #{ to =>
     fun
       (X) ->
         case X of
           {inl, X@1} ->
             {left, X@1};
           {inr, X@2} ->
             {right, X@2};
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , from =>
     fun
       (X) ->
         case X of
           {left, X@1} ->
             {inl, X@1};
           {right, X@2} ->
             {inr, X@2};
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

functorEither() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             case M of
               {left, M@1} ->
                 {left, M@1};
               {right, M@2} ->
                 {right, F(M@2)};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   }.

invariantEither() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (M) ->
                 case M of
                   {left, M@1} ->
                     {left, M@1};
                   {right, M@2} ->
                     {right, F(M@2)};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   }.

'fromRight\''() ->
  fun
    (V) ->
      fun
        (V1) ->
          'fromRight\''(V, V1)
      end
  end.

'fromRight\''(V, V1) ->
  case V1 of
    {right, V1@1} ->
      V1@1;
    _ ->
      V(unit)
  end.

fromRight() ->
  fun
    (V) ->
      fun
        (V1) ->
          fromRight(V, V1)
      end
  end.

fromRight(V, V1) ->
  case V1 of
    {right, V1@1} ->
      V1@1;
    _ ->
      V
  end.

'fromLeft\''() ->
  fun
    (V) ->
      fun
        (V1) ->
          'fromLeft\''(V, V1)
      end
  end.

'fromLeft\''(V, V1) ->
  case V1 of
    {left, V1@1} ->
      V1@1;
    _ ->
      V(unit)
  end.

fromLeft() ->
  fun
    (V) ->
      fun
        (V1) ->
          fromLeft(V, V1)
      end
  end.

fromLeft(V, V1) ->
  case V1 of
    {left, V1@1} ->
      V1@1;
    _ ->
      V
  end.

extendEither() ->
  #{ extend =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {left, V1@1} ->
                 {left, V1@1};
               _ ->
                 {right, V(V1)}
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorEither()
     end
   }.

eqEither() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          eqEither(DictEq, DictEq1)
      end
  end.

eqEither(DictEq, DictEq1) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {left, _} ->
                 ?IS_KNOWN_TAG(left, 1, Y)
                   andalso (((erlang:map_get(eq, DictEq))(erlang:element(2, X)))
                            (erlang:element(2, Y)));
               _ ->
                 ?IS_KNOWN_TAG(right, 1, X)
                   andalso (?IS_KNOWN_TAG(right, 1, Y)
                     andalso (((erlang:map_get(eq, DictEq1))
                               (erlang:element(2, X)))
                              (erlang:element(2, Y))))
             end
         end
     end
   }.

ordEither() ->
  fun
    (DictOrd) ->
      ordEither(DictOrd)
  end.

ordEither(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    V = DictOrd@1(undefined),
    fun
      (DictOrd1 = #{ 'Eq0' := DictOrd1@1 }) ->
        begin
          V@1 = DictOrd1@1(undefined),
          EqEither2 =
            #{ eq =>
               fun
                 (X) ->
                   fun
                     (Y) ->
                       case X of
                         {left, _} ->
                           ?IS_KNOWN_TAG(left, 1, Y)
                             andalso (((erlang:map_get(eq, V))
                                       (erlang:element(2, X)))
                                      (erlang:element(2, Y)));
                         _ ->
                           ?IS_KNOWN_TAG(right, 1, X)
                             andalso (?IS_KNOWN_TAG(right, 1, Y)
                               andalso (((erlang:map_get(eq, V@1))
                                         (erlang:element(2, X)))
                                        (erlang:element(2, Y))))
                       end
                   end
               end
             },
          #{ compare =>
             fun
               (X) ->
                 fun
                   (Y) ->
                     case X of
                       {left, _} ->
                         case Y of
                           {left, Y@1} ->
                             begin
                               {left, X@1} = X,
                               #{ compare := DictOrd@2 } = DictOrd,
                               (DictOrd@2(X@1))(Y@1)
                             end;
                           _ ->
                             {lT}
                         end;
                       _ ->
                         case Y of
                           {left, _} ->
                             {gT};
                           _ ->
                             if
                               ?IS_KNOWN_TAG(right, 1, X)
                                 andalso ?IS_KNOWN_TAG(right, 1, Y) ->
                                 begin
                                   {right, Y@2} = Y,
                                   {right, X@2} = X,
                                   #{ compare := DictOrd1@2 } = DictOrd1,
                                   (DictOrd1@2(X@2))(Y@2)
                                 end;
                               true ->
                                 erlang:error({fail, <<"Failed pattern match">>})
                             end
                         end
                     end
                 end
             end
           , 'Eq0' =>
             fun
               (_) ->
                 EqEither2
             end
           }
        end
    end
  end.

eq1Either() ->
  fun
    (DictEq) ->
      eq1Either(DictEq)
  end.

eq1Either(DictEq) ->
  #{ eq1 =>
     fun
       (DictEq1) ->
         fun
           (X) ->
             fun
               (Y) ->
                 case X of
                   {left, _} ->
                     ?IS_KNOWN_TAG(left, 1, Y)
                       andalso (((erlang:map_get(eq, DictEq))
                                 (erlang:element(2, X)))
                                (erlang:element(2, Y)));
                   _ ->
                     ?IS_KNOWN_TAG(right, 1, X)
                       andalso (?IS_KNOWN_TAG(right, 1, Y)
                         andalso (((erlang:map_get(eq, DictEq1))
                                   (erlang:element(2, X)))
                                  (erlang:element(2, Y))))
                 end
             end
         end
     end
   }.

ord1Either() ->
  fun
    (DictOrd) ->
      ord1Either(DictOrd)
  end.

ord1Either(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    OrdEither1 = ordEither(DictOrd),
    V = DictOrd@1(undefined),
    Eq1Either1 =
      #{ eq1 =>
         fun
           (DictEq1) ->
             fun
               (X) ->
                 fun
                   (Y) ->
                     case X of
                       {left, _} ->
                         ?IS_KNOWN_TAG(left, 1, Y)
                           andalso (((erlang:map_get(eq, V))
                                     (erlang:element(2, X)))
                                    (erlang:element(2, Y)));
                       _ ->
                         ?IS_KNOWN_TAG(right, 1, X)
                           andalso (?IS_KNOWN_TAG(right, 1, Y)
                             andalso (((erlang:map_get(eq, DictEq1))
                                       (erlang:element(2, X)))
                                      (erlang:element(2, Y))))
                     end
                 end
             end
         end
       },
    #{ compare1 =>
       fun
         (DictOrd1) ->
           erlang:map_get(compare, OrdEither1(DictOrd1))
       end
     , 'Eq10' =>
       fun
         (_) ->
           Eq1Either1
       end
     }
  end.

either() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              either(V, V1, V2)
          end
      end
  end.

either(V, V1, V2) ->
  case V2 of
    {left, V2@1} ->
      V(V2@1);
    {right, V2@2} ->
      V1(V2@2);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

hush() ->
  fun
    (V2) ->
      hush(V2)
  end.

hush(V2) ->
  case V2 of
    {left, _} ->
      {nothing};
    {right, V2@1} ->
      {just, V2@1};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

isLeft() ->
  fun
    (V2) ->
      isLeft(V2)
  end.

isLeft(V2) ->
  case V2 of
    {left, _} ->
      true;
    {right, _} ->
      false;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

isRight() ->
  fun
    (V2) ->
      isRight(V2)
  end.

isRight(V2) ->
  case V2 of
    {left, _} ->
      false;
    {right, _} ->
      true;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

choose() ->
  fun
    (DictAlt) ->
      choose(DictAlt)
  end.

choose(#{ 'Functor0' := DictAlt, alt := DictAlt@1 }) ->
  begin
    #{ map := V } = DictAlt(undefined),
    fun
      (A) ->
        fun
          (B) ->
            (DictAlt@1((V('Left'()))(A)))((V('Right'()))(B))
        end
    end
  end.

boundedEither() ->
  fun
    (DictBounded) ->
      boundedEither(DictBounded)
  end.

boundedEither(#{ 'Ord0' := DictBounded, bottom := DictBounded@1 }) ->
  begin
    OrdEither1 = ordEither(DictBounded(undefined)),
    fun
      (#{ 'Ord0' := DictBounded1, top := DictBounded1@1 }) ->
        begin
          OrdEither2 = OrdEither1(DictBounded1(undefined)),
          #{ top => {right, DictBounded1@1}
           , bottom => {left, DictBounded@1}
           , 'Ord0' =>
             fun
               (_) ->
                 OrdEither2
             end
           }
        end
    end
  end.

applyEither() ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {left, V@1} ->
                 {left, V@1};
               {right, _} ->
                 case V1 of
                   {left, V1@1} ->
                     {left, V1@1};
                   {right, V1@2} ->
                     begin
                       {right, V@2} = V,
                       {right, V@2(V1@2)}
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorEither()
     end
   }.

bindEither() ->
  #{ bind =>
     fun
       (V2) ->
         case V2 of
           {left, V2@1} ->
             fun
               (_) ->
                 {left, V2@1}
             end;
           {right, V2@2} ->
             fun
               (F) ->
                 F(V2@2)
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyEither()
     end
   }.

semigroupEither() ->
  fun
    (DictSemigroup) ->
      semigroupEither(DictSemigroup)
  end.

semigroupEither(DictSemigroup) ->
  #{ append =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {left, X@1} ->
                 {left, X@1};
               {right, _} ->
                 case Y of
                   {left, Y@1} ->
                     {left, Y@1};
                   {right, Y@2} ->
                     begin
                       {right, X@2} = X,
                       #{ append := DictSemigroup@1 } = DictSemigroup,
                       {right, (DictSemigroup@1(X@2))(Y@2)}
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   }.

applicativeEither() ->
  #{ pure => 'Right'()
   , 'Apply0' =>
     fun
       (_) ->
         applyEither()
     end
   }.

monadEither() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeEither()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindEither()
     end
   }.

altEither() ->
  #{ alt =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {left, _} ->
                 V1;
               _ ->
                 V
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorEither()
     end
   }.

