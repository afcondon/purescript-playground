-module(data_string_pattern@ps).
-export([ 'Replacement'/0
        , 'Replacement'/1
        , 'Pattern'/0
        , 'Pattern'/1
        , showReplacement/0
        , showPattern/0
        , newtypeReplacement/0
        , newtypePattern/0
        , eqReplacement/0
        , ordReplacement/0
        , eqPattern/0
        , ordPattern/0
        ]).
-compile(no_auto_import).
'Replacement'() ->
  fun
    (X) ->
      'Replacement'(X)
  end.

'Replacement'(X) ->
  X.

'Pattern'() ->
  fun
    (X) ->
      'Pattern'(X)
  end.

'Pattern'(X) ->
  X.

showReplacement() ->
  #{ show =>
     fun
       (V) ->
         <<"(Replacement ", (data_show@foreign:showStringImpl(V))/binary, ")">>
     end
   }.

showPattern() ->
  #{ show =>
     fun
       (V) ->
         <<"(Pattern ", (data_show@foreign:showStringImpl(V))/binary, ")">>
     end
   }.

newtypeReplacement() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypePattern() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

eqReplacement() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             X =:= Y
         end
     end
   }.

ordReplacement() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             ((erlang:map_get(compare, data_ord@ps:ordString()))(X))(Y)
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqReplacement()
     end
   }.

eqPattern() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             X =:= Y
         end
     end
   }.

ordPattern() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             ((erlang:map_get(compare, data_ord@ps:ordString()))(X))(Y)
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqPattern()
     end
   }.

