-module(data_string_regex@ps).
-export([ showRegex/0
        , search/0
        , 'replace\''/0
        , renderFlags/0
        , renderFlags/1
        , regex/0
        , regex/2
        , parseFlags/0
        , parseFlags/1
        , match/0
        , flags/0
        , flags/1
        , showRegexImpl/0
        , regexImpl/0
        , source/0
        , flagsImpl/0
        , test/0
        , '_match'/0
        , replace/0
        , '_replaceBy'/0
        , '_search'/0
        , split/0
        , search/2
        , 'replace\''/3
        , match/2
        ]).
-compile(no_auto_import).
showRegex() ->
  #{ show => showRegexImpl() }.

search() ->
  (('_search'())(data_maybe@ps:'Just'()))({nothing}).

'replace\''() ->
  (('_replaceBy'())(data_maybe@ps:'Just'()))({nothing}).

renderFlags() ->
  fun
    (V) ->
      renderFlags(V)
  end.

renderFlags(V) ->
  <<
    if
      erlang:map_get(global, erlang:element(2, V)) ->
        <<"g">>;
      true ->
        <<"">>
    end/binary,
    if
      erlang:map_get(ignoreCase, erlang:element(2, V)) ->
        <<"i">>;
      true ->
        <<"">>
    end/binary,
    if
      erlang:map_get(multiline, erlang:element(2, V)) ->
        <<"m">>;
      true ->
        <<"">>
    end/binary,
    if
      erlang:map_get(dotAll, erlang:element(2, V)) ->
        <<"s">>;
      true ->
        <<"">>
    end/binary,
    if
      erlang:map_get(sticky, erlang:element(2, V)) ->
        <<"y">>;
      true ->
        <<"">>
    end/binary,
    if
      erlang:map_get(unicode, erlang:element(2, V)) ->
        <<"u">>;
      true ->
        <<"">>
    end/binary
  >>.

regex() ->
  fun
    (S) ->
      fun
        (F) ->
          regex(S, F)
      end
  end.

regex(S, F) ->
  data_string_regex@foreign:regexImpl(
    data_either@ps:'Left'(),
    data_either@ps:'Right'(),
    S,
    <<
      if
        erlang:map_get(global, erlang:element(2, F)) ->
          <<"g">>;
        true ->
          <<"">>
      end/binary,
      if
        erlang:map_get(ignoreCase, erlang:element(2, F)) ->
          <<"i">>;
        true ->
          <<"">>
      end/binary,
      if
        erlang:map_get(multiline, erlang:element(2, F)) ->
          <<"m">>;
        true ->
          <<"">>
      end/binary,
      if
        erlang:map_get(dotAll, erlang:element(2, F)) ->
          <<"s">>;
        true ->
          <<"">>
      end/binary,
      if
        erlang:map_get(sticky, erlang:element(2, F)) ->
          <<"y">>;
        true ->
          <<"">>
      end/binary,
      if
        erlang:map_get(unicode, erlang:element(2, F)) ->
          <<"u">>;
        true ->
          <<"">>
      end/binary
    >>
  ).

parseFlags() ->
  fun
    (S) ->
      parseFlags(S)
  end.

parseFlags(S) ->
  { regexFlags
  , #{ global => (data_string_codeUnits@ps:contains(<<"g">>))(S)
     , ignoreCase => (data_string_codeUnits@ps:contains(<<"i">>))(S)
     , multiline => (data_string_codeUnits@ps:contains(<<"m">>))(S)
     , dotAll => (data_string_codeUnits@ps:contains(<<"s">>))(S)
     , sticky => (data_string_codeUnits@ps:contains(<<"y">>))(S)
     , unicode => (data_string_codeUnits@ps:contains(<<"u">>))(S)
     }
  }.

match() ->
  (('_match'())(data_maybe@ps:'Just'()))({nothing}).

flags() ->
  fun
    (X) ->
      flags(X)
  end.

flags(X) ->
  {regexFlags, data_string_regex@foreign:flagsImpl(X)}.

showRegexImpl() ->
  fun
    (V) ->
      data_string_regex@foreign:showRegexImpl(V)
  end.

regexImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_string_regex@foreign:regexImpl(V, V@1, V@2, V@3)
              end
          end
      end
  end.

source() ->
  fun
    (V) ->
      data_string_regex@foreign:source(V)
  end.

flagsImpl() ->
  fun
    (V) ->
      data_string_regex@foreign:flagsImpl(V)
  end.

test() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_regex@foreign:test(V, V@1)
      end
  end.

'_match'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_string_regex@foreign:'_match'(V, V@1, V@2, V@3)
              end
          end
      end
  end.

replace() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_string_regex@foreign:replace(V, V@1, V@2)
          end
      end
  end.

'_replaceBy'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      data_string_regex@foreign:'_replaceBy'(
                        V,
                        V@1,
                        V@2,
                        V@3,
                        V@4
                      )
                  end
              end
          end
      end
  end.

'_search'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_string_regex@foreign:'_search'(V, V@1, V@2, V@3)
              end
          end
      end
  end.

split() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_regex@foreign:split(V, V@1)
      end
  end.

search(V, V@1) ->
  data_string_regex@foreign:'_search'(data_maybe@ps:'Just'(), {nothing}, V, V@1).

'replace\''(V, V@1, V@2) ->
  data_string_regex@foreign:'_replaceBy'(
    data_maybe@ps:'Just'(),
    {nothing},
    V,
    V@1,
    V@2
  ).

match(V, V@1) ->
  data_string_regex@foreign:'_match'(data_maybe@ps:'Just'(), {nothing}, V, V@1).

