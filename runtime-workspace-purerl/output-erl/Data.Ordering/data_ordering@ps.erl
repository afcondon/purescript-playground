-module(data_ordering@ps).
-export([ 'LT'/0
        , 'GT'/0
        , 'EQ'/0
        , showOrdering/0
        , semigroupOrdering/0
        , invert/0
        , invert/1
        , eqOrdering/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'LT'() ->
  {lT}.

'GT'() ->
  {gT}.

'EQ'() ->
  {eQ}.

showOrdering() ->
  #{ show =>
     fun
       (V) ->
         case V of
           {lT} ->
             <<"LT">>;
           {gT} ->
             <<"GT">>;
           {eQ} ->
             <<"EQ">>;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

semigroupOrdering() ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {lT} ->
                 {lT};
               {gT} ->
                 {gT};
               {eQ} ->
                 V1;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   }.

invert() ->
  fun
    (V) ->
      invert(V)
  end.

invert(V) ->
  case V of
    {gT} ->
      {lT};
    {eQ} ->
      {eQ};
    {lT} ->
      {gT};
    _ ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

eqOrdering() ->
  #{ eq =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {lT} ->
                 ?IS_KNOWN_TAG(lT, 0, V1);
               {gT} ->
                 ?IS_KNOWN_TAG(gT, 0, V1);
               _ ->
                 ?IS_KNOWN_TAG(eQ, 0, V) andalso ?IS_KNOWN_TAG(eQ, 0, V1)
             end
         end
     end
   }.

