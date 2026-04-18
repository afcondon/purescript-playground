-module(data_interval@ps).
-export([ show/0
        , show/1
        , compare/0
        , compare/2
        , 'StartEnd'/0
        , 'DurationEnd'/0
        , 'StartDuration'/0
        , 'DurationOnly'/0
        , 'RecurringInterval'/0
        , showInterval/0
        , showInterval/2
        , showRecurringInterval/0
        , showRecurringInterval/2
        , over/0
        , over/3
        , foldableInterval/0
        , foldableRecurringInterval/0
        , eqInterval/0
        , eqInterval/2
        , eqRecurringInterval/0
        , eqRecurringInterval/2
        , ordInterval/0
        , ordInterval/1
        , ordRecurringInterval/0
        , ordRecurringInterval/1
        , bifunctorInterval/0
        , bifunctorRecurringInterval/0
        , functorInterval/0
        , extendInterval/0
        , functorRecurringInterval/0
        , extendRecurringInterval/0
        , traversableInterval/0
        , traversableRecurringInterval/0
        , bifoldableInterval/0
        , bifoldableRecurringInterval/0
        , bitraversableInterval/0
        , bitraversableRecurringInterval/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
show() ->
  fun
    (V) ->
      show(V)
  end.

show(V) ->
  case V of
    {just, V@1} ->
      <<"(Just ", (data_show@foreign:showIntImpl(V@1))/binary, ")">>;
    {nothing} ->
      <<"Nothing">>;
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

compare() ->
  fun
    (X) ->
      fun
        (Y) ->
          compare(X, Y)
      end
  end.

compare(X, Y) ->
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
            ?IS_KNOWN_TAG(just, 1, X) andalso ?IS_KNOWN_TAG(just, 1, Y) ->
              begin
                {just, Y@1} = Y,
                {just, X@1} = X,
                ((erlang:map_get(compare, data_ord@ps:ordInt()))(X@1))(Y@1)
              end;
            true ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end
  end.

'StartEnd'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {startEnd, Value0, Value1}
      end
  end.

'DurationEnd'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {durationEnd, Value0, Value1}
      end
  end.

'StartDuration'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {startDuration, Value0, Value1}
      end
  end.

'DurationOnly'() ->
  fun
    (Value0) ->
      {durationOnly, Value0}
  end.

'RecurringInterval'() ->
  fun
    (Value0) ->
      fun
        (Value1) ->
          {recurringInterval, Value0, Value1}
      end
  end.

showInterval() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showInterval(DictShow, DictShow1)
      end
  end.

showInterval(DictShow, DictShow1) ->
  #{ show =>
     fun
       (V) ->
         case V of
           {startEnd, V@1, V@2} ->
             begin
               #{ show := DictShow1@1 } = DictShow1,
               <<
                 "(StartEnd ",
                 (DictShow1@1(V@1))/binary,
                 " ",
                 (DictShow1@1(V@2))/binary,
                 ")"
               >>
             end;
           {durationEnd, V@3, V@4} ->
             begin
               #{ show := DictShow1@2 } = DictShow1,
               #{ show := DictShow@1 } = DictShow,
               <<
                 "(DurationEnd ",
                 (DictShow@1(V@3))/binary,
                 " ",
                 (DictShow1@2(V@4))/binary,
                 ")"
               >>
             end;
           {startDuration, V@5, V@6} ->
             begin
               #{ show := DictShow1@3 } = DictShow1,
               #{ show := DictShow@2 } = DictShow,
               <<
                 "(StartDuration ",
                 (DictShow1@3(V@5))/binary,
                 " ",
                 (DictShow@2(V@6))/binary,
                 ")"
               >>
             end;
           {durationOnly, V@7} ->
             begin
               #{ show := DictShow@3 } = DictShow,
               <<"(DurationOnly ", (DictShow@3(V@7))/binary, ")">>
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

showRecurringInterval() ->
  fun
    (DictShow) ->
      fun
        (DictShow1) ->
          showRecurringInterval(DictShow, DictShow1)
      end
  end.

showRecurringInterval(DictShow, DictShow1) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(RecurringInterval ",
           (show(erlang:element(2, V)))/binary,
           " ",
           ((erlang:map_get(show, showInterval(DictShow, DictShow1)))
            (erlang:element(3, V)))/binary,
           ")"
         >>
     end
   }.

over() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (V) ->
              over(DictFunctor, F, V)
          end
      end
  end.

over(#{ map := DictFunctor }, F, V) ->
  (DictFunctor(('RecurringInterval'())(erlang:element(2, V))))
  (F(erlang:element(3, V))).

foldableInterval() ->
  #{ foldl =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (V2) ->
                 case V2 of
                   {startEnd, V2@1, V2@2} ->
                     (V((V(V1))(V2@1)))(V2@2);
                   {durationEnd, _, V2@3} ->
                     (V(V1))(V2@3);
                   {startDuration, V2@4, _} ->
                     (V(V1))(V2@4);
                   _ ->
                     V1
                 end
             end
         end
     end
   , foldr =>
     fun
       (X) ->
         (data_foldable@ps:foldrDefault(foldableInterval()))(X)
     end
   , foldMap =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         fun
           (F) ->
             ((erlang:map_get(foldl, foldableInterval()))
              (fun
                (Acc) ->
                  fun
                    (X) ->
                      ((erlang:map_get(append, DictMonoid(undefined)))(Acc))
                      (F(X))
                  end
              end))
             (DictMonoid@1)
         end
     end
   }.

foldableRecurringInterval() ->
  #{ foldl =>
     fun
       (F) ->
         fun
           (I) ->
             fun
               (X) ->
                 case erlang:element(3, X) of
                   {startEnd, _, _} ->
                     (F((F(I))(erlang:element(2, erlang:element(3, X)))))
                     (erlang:element(3, erlang:element(3, X)));
                   {durationEnd, _, _} ->
                     (F(I))(erlang:element(3, erlang:element(3, X)));
                   {startDuration, _, _} ->
                     (F(I))(erlang:element(2, erlang:element(3, X)));
                   _ ->
                     I
                 end
             end
         end
     end
   , foldr =>
     fun
       (F) ->
         fun
           (I) ->
             begin
               V = ((data_foldable@ps:foldrDefault(foldableInterval()))(F))(I),
               fun
                 (X) ->
                   V(erlang:element(3, X))
               end
             end
         end
     end
   , foldMap =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         fun
           (F) ->
             ((erlang:map_get(foldl, foldableRecurringInterval()))
              (fun
                (Acc) ->
                  fun
                    (X) ->
                      ((erlang:map_get(append, DictMonoid(undefined)))(Acc))
                      (F(X))
                  end
              end))
             (DictMonoid@1)
         end
     end
   }.

eqInterval() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          eqInterval(DictEq, DictEq1)
      end
  end.

eqInterval(DictEq, DictEq1) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {startEnd, _, _} ->
                 ?IS_KNOWN_TAG(startEnd, 2, Y)
                   andalso ((((erlang:map_get(eq, DictEq1))
                              (erlang:element(2, X)))
                             (erlang:element(2, Y)))
                     andalso (((erlang:map_get(eq, DictEq1))
                               (erlang:element(3, X)))
                              (erlang:element(3, Y))));
               {durationEnd, _, _} ->
                 ?IS_KNOWN_TAG(durationEnd, 2, Y)
                   andalso ((((erlang:map_get(eq, DictEq))
                              (erlang:element(2, X)))
                             (erlang:element(2, Y)))
                     andalso (((erlang:map_get(eq, DictEq1))
                               (erlang:element(3, X)))
                              (erlang:element(3, Y))));
               {startDuration, _, _} ->
                 ?IS_KNOWN_TAG(startDuration, 2, Y)
                   andalso ((((erlang:map_get(eq, DictEq1))
                              (erlang:element(2, X)))
                             (erlang:element(2, Y)))
                     andalso (((erlang:map_get(eq, DictEq))
                               (erlang:element(3, X)))
                              (erlang:element(3, Y))));
               _ ->
                 ?IS_KNOWN_TAG(durationOnly, 1, X)
                   andalso (?IS_KNOWN_TAG(durationOnly, 1, Y)
                     andalso (((erlang:map_get(eq, DictEq))
                               (erlang:element(2, X)))
                              (erlang:element(2, Y))))
             end
         end
     end
   }.

eqRecurringInterval() ->
  fun
    (DictEq) ->
      fun
        (DictEq1) ->
          eqRecurringInterval(DictEq, DictEq1)
      end
  end.

eqRecurringInterval(DictEq, DictEq1) ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case erlang:element(2, X) of
               {nothing} ->
                 ?IS_KNOWN_TAG(nothing, 0, erlang:element(2, Y));
               _ ->
                 ?IS_KNOWN_TAG(just, 1, erlang:element(2, X))
                   andalso (?IS_KNOWN_TAG(just, 1, erlang:element(2, Y))
                     andalso ((erlang:element(2, erlang:element(2, X)))
                       =:= (erlang:element(2, erlang:element(2, Y)))))
             end
               andalso (((erlang:map_get(eq, eqInterval(DictEq, DictEq1)))
                         (erlang:element(3, X)))
                        (erlang:element(3, Y)))
         end
     end
   }.

ordInterval() ->
  fun
    (DictOrd) ->
      ordInterval(DictOrd)
  end.

ordInterval(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    EqInterval1 = (eqInterval())(DictOrd@1(undefined)),
    fun
      (DictOrd1 = #{ 'Eq0' := DictOrd1@1 }) ->
        begin
          EqInterval2 = EqInterval1(DictOrd1@1(undefined)),
          #{ compare =>
             fun
               (X) ->
                 fun
                   (Y) ->
                     case X of
                       {startEnd, _, _} ->
                         case Y of
                           {startEnd, Y@1, _} ->
                             begin
                               {startEnd, X@1, _} = X,
                               #{ compare := DictOrd1@2 } = DictOrd1,
                               V = (DictOrd1@2(X@1))(Y@1),
                               case V of
                                 {lT} ->
                                   {lT};
                                 {gT} ->
                                   {gT};
                                 _ ->
                                   begin
                                     {startEnd, _, Y@2} = Y,
                                     {startEnd, _, X@2} = X,
                                     #{ compare := DictOrd1@3 } = DictOrd1,
                                     (DictOrd1@3(X@2))(Y@2)
                                   end
                               end
                             end;
                           _ ->
                             {lT}
                         end;
                       _ ->
                         case Y of
                           {startEnd, _, _} ->
                             {gT};
                           _ ->
                             case X of
                               {durationEnd, _, _} ->
                                 case Y of
                                   {durationEnd, Y@3, _} ->
                                     begin
                                       {durationEnd, X@3, _} = X,
                                       #{ compare := DictOrd@2 } = DictOrd,
                                       V@1 = (DictOrd@2(X@3))(Y@3),
                                       case V@1 of
                                         {lT} ->
                                           {lT};
                                         {gT} ->
                                           {gT};
                                         _ ->
                                           begin
                                             {durationEnd, _, Y@4} = Y,
                                             {durationEnd, _, X@4} = X,
                                             #{ compare := DictOrd1@4 } =
                                               DictOrd1,
                                             (DictOrd1@4(X@4))(Y@4)
                                           end
                                       end
                                     end;
                                   _ ->
                                     {lT}
                                 end;
                               _ ->
                                 case Y of
                                   {durationEnd, _, _} ->
                                     {gT};
                                   _ ->
                                     case X of
                                       {startDuration, _, _} ->
                                         case Y of
                                           {startDuration, Y@5, _} ->
                                             begin
                                               {startDuration, X@5, _} = X,
                                               #{ compare := DictOrd1@5 } =
                                                 DictOrd1,
                                               V@2 = (DictOrd1@5(X@5))(Y@5),
                                               case V@2 of
                                                 {lT} ->
                                                   {lT};
                                                 {gT} ->
                                                   {gT};
                                                 _ ->
                                                   begin
                                                     {startDuration, _, Y@6} = Y,
                                                     {startDuration, _, X@6} = X,
                                                     #{ compare := DictOrd@3 } =
                                                       DictOrd,
                                                     (DictOrd@3(X@6))(Y@6)
                                                   end
                                               end
                                             end;
                                           _ ->
                                             {lT}
                                         end;
                                       _ ->
                                         case Y of
                                           {startDuration, _, _} ->
                                             {gT};
                                           _ ->
                                             if
                                               ?IS_KNOWN_TAG(durationOnly, 1, X)
                                                 andalso ?IS_KNOWN_TAG(durationOnly, 1, Y) ->
                                                 begin
                                                   {durationOnly, Y@7} = Y,
                                                   {durationOnly, X@7} = X,
                                                   #{ compare := DictOrd@4 } =
                                                     DictOrd,
                                                   (DictOrd@4(X@7))(Y@7)
                                                 end;
                                               true ->
                                                 erlang:error({ fail
                                                              , <<
                                                                  "Failed pattern match"
                                                                >>
                                                              })
                                             end
                                         end
                                     end
                                 end
                             end
                         end
                     end
                 end
             end
           , 'Eq0' =>
             fun
               (_) ->
                 EqInterval2
             end
           }
        end
    end
  end.

ordRecurringInterval() ->
  fun
    (DictOrd) ->
      ordRecurringInterval(DictOrd)
  end.

ordRecurringInterval(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
  begin
    OrdInterval1 = ordInterval(DictOrd),
    EqRecurringInterval1 = (eqRecurringInterval())(DictOrd@1(undefined)),
    fun
      (DictOrd1 = #{ 'Eq0' := DictOrd1@1 }) ->
        begin
          EqRecurringInterval2 = EqRecurringInterval1(DictOrd1@1(undefined)),
          #{ compare =>
             fun
               (X) ->
                 fun
                   (Y) ->
                     begin
                       V = compare(erlang:element(2, X), erlang:element(2, Y)),
                       case V of
                         {lT} ->
                           {lT};
                         {gT} ->
                           {gT};
                         _ ->
                           ((erlang:map_get(compare, OrdInterval1(DictOrd1)))
                            (erlang:element(3, X)))
                           (erlang:element(3, Y))
                       end
                     end
                 end
             end
           , 'Eq0' =>
             fun
               (_) ->
                 EqRecurringInterval2
             end
           }
        end
    end
  end.

bifunctorInterval() ->
  #{ bimap =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (V2) ->
                 case V2 of
                   {startEnd, V2@1, V2@2} ->
                     {startEnd, V1(V2@1), V1(V2@2)};
                   {durationEnd, V2@3, V2@4} ->
                     {durationEnd, V(V2@3), V1(V2@4)};
                   {startDuration, V2@5, V2@6} ->
                     {startDuration, V1(V2@5), V(V2@6)};
                   {durationOnly, V2@7} ->
                     {durationOnly, V(V2@7)};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   }.

bifunctorRecurringInterval() ->
  #{ bimap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 { recurringInterval
                 , erlang:element(2, V)
                 , case erlang:element(3, V) of
                     {startEnd, _, _} ->
                       { startEnd
                       , G(erlang:element(2, erlang:element(3, V)))
                       , G(erlang:element(3, erlang:element(3, V)))
                       };
                     {durationEnd, _, _} ->
                       { durationEnd
                       , F(erlang:element(2, erlang:element(3, V)))
                       , G(erlang:element(3, erlang:element(3, V)))
                       };
                     {startDuration, _, _} ->
                       { startDuration
                       , G(erlang:element(2, erlang:element(3, V)))
                       , F(erlang:element(3, erlang:element(3, V)))
                       };
                     {durationOnly, _} ->
                       { durationOnly
                       , F(erlang:element(2, erlang:element(3, V)))
                       };
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 }
             end
         end
     end
   }.

functorInterval() ->
  #{ map =>
     fun
       (V1) ->
         fun
           (V2) ->
             case V2 of
               {startEnd, V2@1, V2@2} ->
                 {startEnd, V1(V2@1), V1(V2@2)};
               {durationEnd, V2@3, V2@4} ->
                 {durationEnd, V2@3, V1(V2@4)};
               {startDuration, V2@5, V2@6} ->
                 {startDuration, V1(V2@5), V2@6};
               {durationOnly, V2@7} ->
                 {durationOnly, V2@7};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   }.

extendInterval() ->
  #{ extend =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {startEnd, _, _} ->
                 {startEnd, V(V1), V(V1)};
               {durationEnd, V1@1, _} ->
                 {durationEnd, V1@1, V(V1)};
               {startDuration, _, V1@2} ->
                 {startDuration, V(V1), V1@2};
               {durationOnly, V1@3} ->
                 {durationOnly, V1@3};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorInterval()
     end
   }.

functorRecurringInterval() ->
  #{ map =>
     fun
       (F) ->
         fun
           (V) ->
             { recurringInterval
             , erlang:element(2, V)
             , case erlang:element(3, V) of
                 {startEnd, _, _} ->
                   { startEnd
                   , F(erlang:element(2, erlang:element(3, V)))
                   , F(erlang:element(3, erlang:element(3, V)))
                   };
                 {durationEnd, _, _} ->
                   { durationEnd
                   , erlang:element(2, erlang:element(3, V))
                   , F(erlang:element(3, erlang:element(3, V)))
                   };
                 {startDuration, _, _} ->
                   { startDuration
                   , F(erlang:element(2, erlang:element(3, V)))
                   , erlang:element(3, erlang:element(3, V))
                   };
                 {durationOnly, _} ->
                   {durationOnly, erlang:element(2, erlang:element(3, V))};
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
             }
         end
     end
   }.

extendRecurringInterval() ->
  #{ extend =>
     fun
       (F) ->
         fun
           (V) ->
             { recurringInterval
             , erlang:element(2, V)
             , begin
                 V@1 = F(V),
                 case erlang:element(3, V) of
                   {startEnd, _, _} ->
                     {startEnd, V@1, V@1};
                   {durationEnd, _, _} ->
                     {durationEnd, erlang:element(2, erlang:element(3, V)), V@1};
                   {startDuration, _, _} ->
                     { startDuration
                     , V@1
                     , erlang:element(3, erlang:element(3, V))
                     };
                   {durationOnly, _} ->
                     {durationOnly, erlang:element(2, erlang:element(3, V))};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
               end
             }
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorRecurringInterval()
     end
   }.

traversableInterval() ->
  #{ traverse =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           Apply0 = #{ 'Functor0' := Apply0@1 } = DictApplicative@1(undefined),
           Functor0 = Apply0@1(undefined),
           fun
             (V) ->
               fun
                 (V1) ->
                   case V1 of
                     {startEnd, V1@1, V1@2} ->
                       begin
                         #{ map := Functor0@1 } = Functor0,
                         #{ apply := Apply0@2 } = Apply0,
                         (Apply0@2((Functor0@1('StartEnd'()))(V(V1@1))))
                         (V(V1@2))
                       end;
                     {durationEnd, V1@3, V1@4} ->
                       begin
                         #{ map := Functor0@2 } = Functor0,
                         (Functor0@2(('DurationEnd'())(V1@3)))(V(V1@4))
                       end;
                     {startDuration, V1@5, V1@6} ->
                       begin
                         #{ map := Functor0@3 } = Functor0,
                         (Functor0@3(fun
                            (V2) ->
                              {startDuration, V2, V1@6}
                          end))
                         (V(V1@5))
                       end;
                     {durationOnly, V1@7} ->
                       begin
                         #{ pure := DictApplicative@2 } = DictApplicative,
                         DictApplicative@2({durationOnly, V1@7})
                       end;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
               end
           end
         end
     end
   , sequence =>
     fun
       (DictApplicative) ->
         ((erlang:map_get(traverse, traversableInterval()))(DictApplicative))
         (data_traversable@ps:identity())
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorInterval()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         foldableInterval()
     end
   }.

traversableRecurringInterval() ->
  #{ traverse =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           Over1 =
             (over())
             ((erlang:map_get('Functor0', DictApplicative@1(undefined)))
              (undefined)),
           Traverse1 =
             (erlang:map_get(traverse, traversableInterval()))(DictApplicative),
           fun
             (F) ->
               fun
                 (I) ->
                   (Over1(Traverse1(F)))(I)
               end
           end
         end
     end
   , sequence =>
     fun
       (DictApplicative) ->
         ((erlang:map_get(traverse, traversableRecurringInterval()))
          (DictApplicative))
         (data_traversable@ps:identity())
     end
   , 'Functor0' =>
     fun
       (_) ->
         functorRecurringInterval()
     end
   , 'Foldable1' =>
     fun
       (_) ->
         foldableRecurringInterval()
     end
   }.

bifoldableInterval() ->
  #{ bifoldl =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (V2) ->
                 fun
                   (V3) ->
                     case V3 of
                       {startEnd, V3@1, V3@2} ->
                         (V1((V1(V2))(V3@1)))(V3@2);
                       {durationEnd, V3@3, V3@4} ->
                         (V1((V(V2))(V3@3)))(V3@4);
                       {startDuration, V3@5, V3@6} ->
                         (V1((V(V2))(V3@6)))(V3@5);
                       {durationOnly, V3@7} ->
                         (V(V2))(V3@7);
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end
             end
         end
     end
   , bifoldr =>
     fun
       (X) ->
         (data_bifoldable@ps:bifoldrDefault(bifoldableInterval()))(X)
     end
   , bifoldMap =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         begin
           #{ append := V } = DictMonoid(undefined),
           fun
             (F) ->
               fun
                 (G) ->
                   (((erlang:map_get(bifoldl, bifoldableInterval()))
                     (fun
                       (M) ->
                         fun
                           (A) ->
                             (V(M))(F(A))
                         end
                     end))
                    (fun
                      (M) ->
                        fun
                          (B) ->
                            (V(M))(G(B))
                        end
                    end))
                   (DictMonoid@1)
               end
           end
         end
     end
   }.

bifoldableRecurringInterval() ->
  #{ bifoldl =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (I) ->
                 fun
                   (X) ->
                     case erlang:element(3, X) of
                       {startEnd, _, _} ->
                         (G((G(I))(erlang:element(2, erlang:element(3, X)))))
                         (erlang:element(3, erlang:element(3, X)));
                       {durationEnd, _, _} ->
                         (G((F(I))(erlang:element(2, erlang:element(3, X)))))
                         (erlang:element(3, erlang:element(3, X)));
                       {startDuration, _, _} ->
                         (G((F(I))(erlang:element(3, erlang:element(3, X)))))
                         (erlang:element(2, erlang:element(3, X)));
                       {durationOnly, _} ->
                         (F(I))(erlang:element(2, erlang:element(3, X)));
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
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
               (I) ->
                 begin
                   V =
                     (((data_bifoldable@ps:bifoldrDefault(bifoldableInterval()))
                       (F))
                      (G))
                     (I),
                   fun
                     (X) ->
                       V(erlang:element(3, X))
                   end
                 end
             end
         end
     end
   , bifoldMap =>
     fun
       (#{ 'Semigroup0' := DictMonoid, mempty := DictMonoid@1 }) ->
         begin
           #{ append := V } = DictMonoid(undefined),
           fun
             (F) ->
               fun
                 (G) ->
                   (((erlang:map_get(bifoldl, bifoldableRecurringInterval()))
                     (fun
                       (M) ->
                         fun
                           (A) ->
                             (V(M))(F(A))
                         end
                     end))
                    (fun
                      (M) ->
                        fun
                          (B) ->
                            (V(M))(G(B))
                        end
                    end))
                   (DictMonoid@1)
               end
           end
         end
     end
   }.

bitraversableInterval() ->
  #{ bitraverse =>
     fun
       (#{ 'Apply0' := DictApplicative }) ->
         begin
           Apply0 = #{ 'Functor0' := Apply0@1 } = DictApplicative(undefined),
           #{ map := V } = Apply0@1(undefined),
           fun
             (V@1) ->
               fun
                 (V1) ->
                   fun
                     (V2) ->
                       case V2 of
                         {startEnd, V2@1, V2@2} ->
                           begin
                             #{ apply := Apply0@2 } = Apply0,
                             (Apply0@2((V('StartEnd'()))(V1(V2@1))))(V1(V2@2))
                           end;
                         {durationEnd, V2@3, V2@4} ->
                           begin
                             #{ apply := Apply0@3 } = Apply0,
                             (Apply0@3((V('DurationEnd'()))(V@1(V2@3))))
                             (V1(V2@4))
                           end;
                         {startDuration, V2@5, V2@6} ->
                           begin
                             #{ apply := Apply0@4 } = Apply0,
                             (Apply0@4((V('StartDuration'()))(V1(V2@5))))
                             (V@1(V2@6))
                           end;
                         {durationOnly, V2@7} ->
                           (V('DurationOnly'()))(V@1(V2@7));
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                   end
               end
           end
         end
     end
   , bisequence =>
     fun
       (DictApplicative) ->
         begin
           V = data_bitraversable@ps:identity(),
           (((erlang:map_get(bitraverse, bitraversableInterval()))
             (DictApplicative))
            (V))
           (V)
         end
     end
   , 'Bifunctor0' =>
     fun
       (_) ->
         bifunctorInterval()
     end
   , 'Bifoldable1' =>
     fun
       (_) ->
         bifoldableInterval()
     end
   }.

bitraversableRecurringInterval() ->
  #{ bitraverse =>
     fun
       (DictApplicative = #{ 'Apply0' := DictApplicative@1 }) ->
         begin
           Over1 =
             (over())
             ((erlang:map_get('Functor0', DictApplicative@1(undefined)))
              (undefined)),
           Bitraverse1 =
             (erlang:map_get(bitraverse, bitraversableInterval()))
             (DictApplicative),
           fun
             (L) ->
               fun
                 (R) ->
                   fun
                     (I) ->
                       (Over1((Bitraverse1(L))(R)))(I)
                   end
               end
           end
         end
     end
   , bisequence =>
     fun
       (DictApplicative) ->
         begin
           V = data_bitraversable@ps:identity(),
           (((erlang:map_get(bitraverse, bitraversableRecurringInterval()))
             (DictApplicative))
            (V))
           (V)
         end
     end
   , 'Bifunctor0' =>
     fun
       (_) ->
         bifunctorRecurringInterval()
     end
   , 'Bifoldable1' =>
     fun
       (_) ->
         bifoldableRecurringInterval()
     end
   }.

