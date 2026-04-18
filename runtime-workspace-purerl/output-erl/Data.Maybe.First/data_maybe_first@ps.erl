-module(data_maybe_first@ps).
-export([ 'First'/0
        , 'First'/1
        , showFirst/0
        , showFirst/1
        , semigroupFirst/0
        , ordFirst/0
        , ordFirst/1
        , ord1First/0
        , newtypeFirst/0
        , monoidFirst/0
        , monadFirst/0
        , invariantFirst/0
        , functorFirst/0
        , extendFirst/0
        , eqFirst/0
        , eqFirst/1
        , eq1First/0
        , boundedFirst/0
        , boundedFirst/1
        , bindFirst/0
        , applyFirst/0
        , applicativeFirst/0
        , altFirst/0
        , plusFirst/0
        , alternativeFirst/0
        , monadZeroFirst/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'First'() ->
  fun
    (X) ->
      'First'(X)
  end.

'First'(X) ->
  X.

showFirst() ->
  fun
    (DictShow) ->
      showFirst(DictShow)
  end.

showFirst(DictShow) ->
  #{ show =>
     fun
       (V) ->
         case V of
           {just, V@1} ->
             begin
               #{ show := DictShow@1 } = DictShow,
               <<"First ((Just ", (DictShow@1(V@1))/binary, "))">>
             end;
           {nothing} ->
             <<"First (Nothing)">>;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

semigroupFirst() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {just, _} ->
                 V;
               _ ->
                 V1
             end
         end
     end
   }.

ordFirst() ->
  fun
    (DictOrd) ->
      ordFirst(DictOrd)
  end.

ordFirst(DictOrd = #{ 'Eq0' := DictOrd@1 }) ->
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

ord1First() ->
  data_maybe@ps:ord1Maybe().

newtypeFirst() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidFirst() ->
  #{ mempty => {nothing}
   , 'Semigroup0' =>
     fun
       (_) ->
         semigroupFirst()
     end
   }.

monadFirst() ->
  data_maybe@ps:monadMaybe().

invariantFirst() ->
  data_maybe@ps:invariantMaybe().

functorFirst() ->
  data_maybe@ps:functorMaybe().

extendFirst() ->
  data_maybe@ps:extendMaybe().

eqFirst() ->
  fun
    (DictEq) ->
      eqFirst(DictEq)
  end.

eqFirst(DictEq) ->
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

eq1First() ->
  data_maybe@ps:eq1Maybe().

boundedFirst() ->
  fun
    (DictBounded) ->
      boundedFirst(DictBounded)
  end.

boundedFirst(DictBounded) ->
  data_maybe@ps:boundedMaybe(DictBounded).

bindFirst() ->
  data_maybe@ps:bindMaybe().

applyFirst() ->
  data_maybe@ps:applyMaybe().

applicativeFirst() ->
  data_maybe@ps:applicativeMaybe().

altFirst() ->
  #{ alt => erlang:map_get(append, semigroupFirst())
   , 'Functor0' =>
     fun
       (_) ->
         data_maybe@ps:functorMaybe()
     end
   }.

plusFirst() ->
  #{ empty => {nothing}
   , 'Alt0' =>
     fun
       (_) ->
         altFirst()
     end
   }.

alternativeFirst() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         data_maybe@ps:applicativeMaybe()
     end
   , 'Plus1' =>
     fun
       (_) ->
         plusFirst()
     end
   }.

monadZeroFirst() ->
  #{ 'Monad0' =>
     fun
       (_) ->
         data_maybe@ps:monadMaybe()
     end
   , 'Alternative1' =>
     fun
       (_) ->
         alternativeFirst()
     end
   , 'MonadZeroIsDeprecated2' =>
     fun
       (_) ->
         undefined
     end
   }.

