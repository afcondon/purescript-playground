-module(data_maybe@ps).
-export([ identity/0
        , identity/1
        , 'Nothing'/0
        , 'Just'/0
        , showMaybe/0
        , showMaybe/1
        , semigroupMaybe/0
        , semigroupMaybe/1
        , optional/0
        , optional/3
        , monoidMaybe/0
        , monoidMaybe/1
        , 'maybe\''/0
        , 'maybe\''/3
        , maybe/0
        , maybe/3
        , isNothing/0
        , isNothing/1
        , isJust/0
        , isJust/1
        , genericMaybe/0
        , functorMaybe/0
        , invariantMaybe/0
        , 'fromMaybe\''/0
        , 'fromMaybe\''/1
        , fromMaybe/0
        , fromMaybe/2
        , fromJust/0
        , fromJust/2
        , extendMaybe/0
        , eqMaybe/0
        , eqMaybe/1
        , ordMaybe/0
        , ordMaybe/1
        , eq1Maybe/0
        , ord1Maybe/0
        , boundedMaybe/0
        , boundedMaybe/1
        , applyMaybe/0
        , bindMaybe/0
        , applicativeMaybe/0
        , monadMaybe/0
        , altMaybe/0
        , plusMaybe/0
        , alternativeMaybe/0
        , monadZeroMaybe/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

'Nothing'() ->
  {nothing}.

'Just'() ->
  fun
    (Value0) ->
      {just, Value0}
  end.

showMaybe() ->
  fun
    (DictShow) ->
      showMaybe(DictShow)
  end.

showMaybe(DictShow) ->
  #{ show =>
     fun
       (V) ->
         case V of
           {just, V@1} ->
             begin
               #{ show := DictShow@1 } = DictShow,
               <<"(Just ", (DictShow@1(V@1))/binary, ")">>
             end;
           {nothing} ->
             <<"Nothing">>;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

semigroupMaybe() ->
  fun
    (DictSemigroup) ->
      semigroupMaybe(DictSemigroup)
  end.

semigroupMaybe(DictSemigroup) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {nothing} ->
                 V1;
               _ ->
                 case V1 of
                   {nothing} ->
                     V;
                   _ ->
                     if
                       ?IS_KNOWN_TAG(just, 1, V)
                         andalso ?IS_KNOWN_TAG(just, 1, V1) ->
                         begin
                           {just, V@1} = V,
                           {just, V1@1} = V1,
                           #{ append := DictSemigroup@1 } = DictSemigroup,
                           {just, (DictSemigroup@1(V@1))(V1@1)}
                         end;
                       true ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end
             end
         end
     end
   }.

optional() ->
  fun
    (DictAlt) ->
      fun
        (DictApplicative) ->
          fun
            (A) ->
              optional(DictAlt, DictApplicative, A)
          end
      end
  end.

optional( #{ 'Functor0' := DictAlt, alt := DictAlt@1 }
        , #{ pure := DictApplicative }
        , A
        ) ->
  (DictAlt@1(((erlang:map_get(map, DictAlt(undefined)))('Just'()))(A)))
  (DictApplicative({nothing})).

monoidMaybe() ->
  fun
    (DictSemigroup) ->
      monoidMaybe(DictSemigroup)
  end.

monoidMaybe(DictSemigroup) ->
  begin
    SemigroupMaybe1 =
      #{ append =>
         fun
           (V) ->
             fun
               (V1) ->
                 case V of
                   {nothing} ->
                     V1;
                   _ ->
                     case V1 of
                       {nothing} ->
                         V;
                       _ ->
                         if
                           ?IS_KNOWN_TAG(just, 1, V)
                             andalso ?IS_KNOWN_TAG(just, 1, V1) ->
                             begin
                               {just, V@1} = V,
                               {just, V1@1} = V1,
                               #{ append := DictSemigroup@1 } = DictSemigroup,
                               {just, (DictSemigroup@1(V@1))(V1@1)}
                             end;
                           true ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end
                 end
             end
         end
       },
    #{ mempty => {nothing}
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupMaybe1
       end
     }
  end.

'maybe\''() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              'maybe\''(V, V1, V2)
          end
      end
  end.

'maybe\''(V, V1, V2) ->
  case V2 of
    {nothing} ->
      V(unit);
    {just, V2@1} ->
      V1(V2@1);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

maybe() ->
  fun
    (V) ->
      fun
        (V1) ->
          fun
            (V2) ->
              maybe(V, V1, V2)
          end
      end
  end.

maybe(V, V1, V2) ->
  case V2 of
    {nothing} ->
      V;
    {just, V2@1} ->
      V1(V2@1);
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

isNothing() ->
  fun
    (V2) ->
      isNothing(V2)
  end.

isNothing(V2) ->
  case V2 of
    {nothing} ->
      true;
    {just, _} ->
      false;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

isJust() ->
  fun
    (V2) ->
      isJust(V2)
  end.

isJust(V2) ->
  case V2 of
    {nothing} ->
      false;
    {just, _} ->
      true;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

genericMaybe() ->
  #{ to =>
     fun
       (X) ->
         case X of
           {inl, _} ->
             {nothing};
           {inr, X@1} ->
             {just, X@1};
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , from =>
     fun
       (X) ->
         case X of
           {nothing} ->
             {inl, {noArguments}};
           {just, X@1} ->
             {inr, X@1};
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

functorMaybe() ->
  #{ map =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {just, V1@1} ->
                 {just, V(V1@1)};
               _ ->
                 {nothing}
             end
         end
     end
   }.

invariantMaybe() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V1) ->
                 case V1 of
                   {just, V1@1} ->
                     {just, F(V1@1)};
                   _ ->
                     {nothing}
                 end
             end
         end
     end
   }.

'fromMaybe\''() ->
  fun
    (A) ->
      'fromMaybe\''(A)
  end.

'fromMaybe\''(A) ->
  (('maybe\''())(A))(identity()).

fromMaybe() ->
  fun
    (A) ->
      fun
        (V2) ->
          fromMaybe(A, V2)
      end
  end.

fromMaybe(A, V2) ->
  case V2 of
    {nothing} ->
      A;
    {just, V2@1} ->
      V2@1;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

fromJust() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fromJust(V, V@1)
      end
  end.

fromJust(_, V = {just, V@1}) ->
  case V of
    {just, _} ->
      V@1;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

extendMaybe() ->
  #{ extend =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {nothing} ->
                 {nothing};
               _ ->
                 {just, V(V1)}
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorMaybe()
     end
   }.

eqMaybe() ->
  fun
    (DictEq) ->
      eqMaybe(DictEq)
  end.

eqMaybe(DictEq) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {nothing} ->
                 ?IS_KNOWN_TAG(nothing, 0, Y);
               _ ->
                 ?IS_KNOWN_TAG(just, 1, X)
                   andalso (?IS_KNOWN_TAG(just, 1, Y)
                     andalso (((erlang:map_get(eq, DictEq))
                               (erlang:element(2, X)))
                              (erlang:element(2, Y))))
             end
         end
     end
   }.

ordMaybe() ->
  fun
    (DictOrd) ->
      ordMaybe(DictOrd)
  end.

ordMaybe(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    V = DictOrd@1(undefined),
    EqMaybe1 =
      #{ eq =>
         fun
           (X) ->
             fun
               (Y) ->
                 case X of
                   {nothing} ->
                     ?IS_KNOWN_TAG(nothing, 0, Y);
                   _ ->
                     ?IS_KNOWN_TAG(just, 1, X)
                       andalso (?IS_KNOWN_TAG(just, 1, Y)
                         andalso (((erlang:map_get(eq, V))
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
                 {nothing} ->
                   case Y of
                     {nothing} ->
                       {eQ};
                     _ ->
                       {lT}
                   end;
                 _ ->
                   case Y of
                     {nothing} ->
                       {gT};
                     _ ->
                       if
                         ?IS_KNOWN_TAG(just, 1, X)
                           andalso ?IS_KNOWN_TAG(just, 1, Y) ->
                           begin
                             {just, Y@1} = Y,
                             {just, X@1} = X,
                             #{ compare := DictOrd@2 } = DictOrd,
                             (DictOrd@2(X@1))(Y@1)
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
           EqMaybe1
       end
     }
  end.

eq1Maybe() ->
  #{ eq1 =>
     fun
       (DictEq) ->
         fun
           (X) ->
             fun
               (Y) ->
                 case X of
                   {nothing} ->
                     ?IS_KNOWN_TAG(nothing, 0, Y);
                   _ ->
                     ?IS_KNOWN_TAG(just, 1, X)
                       andalso (?IS_KNOWN_TAG(just, 1, Y)
                         andalso (((erlang:map_get(eq, DictEq))
                                   (erlang:element(2, X)))
                                  (erlang:element(2, Y))))
                 end
             end
         end
     end
   }.

ord1Maybe() ->
  #{ compare1 =>
     fun
       (DictOrd) ->
         fun
           (X) ->
             fun
               (Y) ->
                 case X of
                   {nothing} ->
                     case Y of
                       {nothing} ->
                         {eQ};
                       _ ->
                         {lT}
                     end;
                   _ ->
                     case Y of
                       {nothing} ->
                         {gT};
                       _ ->
                         if
                           ?IS_KNOWN_TAG(just, 1, X)
                             andalso ?IS_KNOWN_TAG(just, 1, Y) ->
                             begin
                               {just, Y@1} = Y,
                               {just, X@1} = X,
                               #{ compare := DictOrd@1 } = DictOrd,
                               (DictOrd@1(X@1))(Y@1)
                             end;
                           true ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end
                 end
             end
         end
     end
   , 'Eq10' =>
     fun
       (_) ->
         eq1Maybe()
     end
   }.

boundedMaybe() ->
  fun
    (DictBounded) ->
      boundedMaybe(DictBounded)
  end.

boundedMaybe(#{ 'Ord0' := DictBounded, top := DictBounded@1 }) ->
  begin
    V = #{ 'Eq0' := V@1 } = DictBounded(undefined),
    V@2 = V@1(undefined),
    OrdMaybe1 =
      begin
        EqMaybe1 =
          #{ eq =>
             fun
               (X) ->
                 fun
                   (Y) ->
                     case X of
                       {nothing} ->
                         ?IS_KNOWN_TAG(nothing, 0, Y);
                       _ ->
                         ?IS_KNOWN_TAG(just, 1, X)
                           andalso (?IS_KNOWN_TAG(just, 1, Y)
                             andalso (((erlang:map_get(eq, V@2))
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
                     {nothing} ->
                       case Y of
                         {nothing} ->
                           {eQ};
                         _ ->
                           {lT}
                       end;
                     _ ->
                       case Y of
                         {nothing} ->
                           {gT};
                         _ ->
                           if
                             ?IS_KNOWN_TAG(just, 1, X)
                               andalso ?IS_KNOWN_TAG(just, 1, Y) ->
                               begin
                                 {just, Y@1} = Y,
                                 {just, X@1} = X,
                                 #{ compare := V@3 } = V,
                                 (V@3(X@1))(Y@1)
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
               EqMaybe1
           end
         }
      end,
    #{ top => {just, DictBounded@1}
     , bottom => {nothing}
     , 'Ord0' =>
       fun
         (_) ->
           OrdMaybe1
       end
     }
  end.

applyMaybe() ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {just, _} ->
                 case V1 of
                   {just, V1@1} ->
                     begin
                       {just, V@1} = V,
                       {just, V@1(V1@1)}
                     end;
                   _ ->
                     {nothing}
                 end;
               {nothing} ->
                 {nothing};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorMaybe()
     end
   }.

bindMaybe() ->
  #{ bind =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {just, V@1} ->
                 V1(V@1);
               {nothing} ->
                 {nothing};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyMaybe()
     end
   }.

applicativeMaybe() ->
  #{ pure => 'Just'()
   , 'Apply0' =>
     fun
       (_) ->
         applyMaybe()
     end
   }.

monadMaybe() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeMaybe()
     end
   , 'Bind1' =>
     fun
       (_) ->
         bindMaybe()
     end
   }.

altMaybe() ->
  #{ alt =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {nothing} ->
                 V1;
               _ ->
                 V
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorMaybe()
     end
   }.

plusMaybe() ->
  #{ empty => {nothing}
   , 'Alt0' =>
     fun
       (_) ->
         altMaybe()
     end
   }.

alternativeMaybe() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeMaybe()
     end
   , 'Plus1' =>
     fun
       (_) ->
         plusMaybe()
     end
   }.

monadZeroMaybe() ->
  #{ 'Monad0' =>
     fun
       (_) ->
         monadMaybe()
     end
   , 'Alternative1' =>
     fun
       (_) ->
         alternativeMaybe()
     end
   , 'MonadZeroIsDeprecated2' =>
     fun
       (_) ->
         undefined
     end
   }.

