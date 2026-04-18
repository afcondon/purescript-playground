-module(data_string_caseInsensitive@ps).
-export([ 'CaseInsensitiveString'/0
        , 'CaseInsensitiveString'/1
        , showCaseInsensitiveString/0
        , newtypeCaseInsensitiveString/0
        , eqCaseInsensitiveString/0
        , ordCaseInsensitiveString/0
        ]).
-compile(no_auto_import).
'CaseInsensitiveString'() ->
  fun
    (X) ->
      'CaseInsensitiveString'(X)
  end.

'CaseInsensitiveString'(X) ->
  X.

showCaseInsensitiveString() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(CaseInsensitiveString ",
           (data_show@foreign:showStringImpl(V))/binary,
           ")"
         >>
     end
   }.

newtypeCaseInsensitiveString() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

eqCaseInsensitiveString() ->
  #{ eq =>
     fun
       (V) ->
         fun
           (V1) ->
             (data_string_common@foreign:toLower(V))
               =:= (data_string_common@foreign:toLower(V1))
         end
     end
   }.

ordCaseInsensitiveString() ->
  #{ compare =>
     fun
       (V) ->
         fun
           (V1) ->
             ((erlang:map_get(compare, data_ord@ps:ordString()))
              (data_string_common@foreign:toLower(V)))
             (data_string_common@foreign:toLower(V1))
         end
     end
   , 'Eq0' =>
     fun
       (_) ->
         eqCaseInsensitiveString()
     end
   }.

