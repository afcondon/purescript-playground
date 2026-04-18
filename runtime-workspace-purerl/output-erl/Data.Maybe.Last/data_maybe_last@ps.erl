-module(data_maybe_last@ps).
-export([ 'Last'/0
        , 'Last'/1
        , showLast/0
        , showLast/1
        , semigroupLast/0
        , ordLast/0
        , ordLast/1
        , ord1Last/0
        , newtypeLast/0
        , monoidLast/0
        , monadLast/0
        , invariantLast/0
        , functorLast/0
        , extendLast/0
        , eqLast/0
        , eqLast/1
        , eq1Last/0
        , boundedLast/0
        , boundedLast/1
        , bindLast/0
        , applyLast/0
        , applicativeLast/0
        , altLast/0
        , plusLast/0
        , alternativeLast/0
        , monadZeroLast/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'Last'() ->
  fun
    (X) ->
      'Last'(X)
  end.

'Last'(X) ->
  X.

showLast() ->
  fun
    (DictShow) ->
      showLast(DictShow)
  end.

showLast(DictShow) ->
  #{ show =>
     fun
       (V) ->
         case V of
           {just, V@1} ->
             begin
               #{ show := DictShow@1 } = DictShow,
               <<"(Last (Just ", (DictShow@1(V@1))/binary, "))">>
             end;
           {nothing} ->
             <<"(Last Nothing)">>;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

semigroupLast() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             case V1 of
               {just, _} ->
                 V1;
               {nothing} ->
                 V;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   }.

ordLast() ->
  fun
    (DictOrd) ->
      ordLast(DictOrd)
  end.

ordLast(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
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

ord1Last() ->
  data_maybe@ps:ord1Maybe().

newtypeLast() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidLast() ->
  #{ mempty => {nothing}
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupLast()
     end
   }.

monadLast() ->
  data_maybe@ps:monadMaybe().

invariantLast() ->
  data_maybe@ps:invariantMaybe().

functorLast() ->
  data_maybe@ps:functorMaybe().

extendLast() ->
  data_maybe@ps:extendMaybe().

eqLast() ->
  fun
    (DictEq) ->
      eqLast(DictEq)
  end.

eqLast(DictEq) ->
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

eq1Last() ->
  data_maybe@ps:eq1Maybe().

boundedLast() ->
  fun
    (DictBounded) ->
      boundedLast(DictBounded)
  end.

boundedLast(DictBounded) ->
  data_maybe@ps:boundedMaybe(DictBounded).

bindLast() ->
  data_maybe@ps:bindMaybe().

applyLast() ->
  data_maybe@ps:applyMaybe().

applicativeLast() ->
  data_maybe@ps:applicativeMaybe().

altLast() ->
  #{ alt => erlang:map_get(append, semigroupLast())
   , 'Functor0' =>
     fun
       (_) ->
         data_maybe@ps:functorMaybe()
     end
   }.

plusLast() ->
  #{ empty => {nothing}
   , 'Alt0' =>
     fun
       (_) ->
         altLast()
     end
   }.

alternativeLast() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         data_maybe@ps:applicativeMaybe()
     end
   , 'Plus1' =>
     fun
       (_) ->
         plusLast()
     end
   }.

monadZeroLast() ->
  #{ 'Monad0' =>
     fun
       (_) ->
         data_maybe@ps:monadMaybe()
     end
   , 'Alternative1' =>
     fun
       (_) ->
         alternativeLast()
     end
   , 'MonadZeroIsDeprecated2' =>
     fun
       (_) ->
         undefined
     end
   }.

