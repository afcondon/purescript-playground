-module(data_string_nonEmpty_caseInsensitive@ps).
-export([ 'CaseInsensitiveNonEmptyString'/0
        , 'CaseInsensitiveNonEmptyString'/1
        , showCaseInsensitiveNonEmptyString/0
        , newtypeCaseInsensitiveNonEmptyString/0
        , eqCaseInsensitiveNonEmptyString/0
        , ordCaseInsensitiveNonEmptyString/0
        ]).
-compile(no_auto_import).
'CaseInsensitiveNonEmptyString'() ->
  fun
    (X) ->
      'CaseInsensitiveNonEmptyString'(X)
  end.

'CaseInsensitiveNonEmptyString'(X) ->
  X.

showCaseInsensitiveNonEmptyString() ->
  #{ show =>
     fun
       (V) ->
         <<
           "(CaseInsensitiveNonEmptyString (NonEmptyString.unsafeFromString ",
           (data_show@foreign:showStringImpl(V))/binary,
           "))"
         >>
     end
   }.

newtypeCaseInsensitiveNonEmptyString() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

eqCaseInsensitiveNonEmptyString() ->
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

ordCaseInsensitiveNonEmptyString() ->
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
         eqCaseInsensitiveNonEmptyString()
     end
   }.

