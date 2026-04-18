-module(data_string_common@ps).
-export([ null/0
        , null/1
        , localeCompare/0
        , '_localeCompare'/0
        , replace/0
        , replaceAll/0
        , split/0
        , toLower/0
        , toUpper/0
        , trim/0
        , joinWith/0
        , localeCompare/2
        ]).
-compile(no_auto_import).
null() ->
  fun
    (S) ->
      null(S)
  end.

null(S) ->
  S =:= <<"">>.

localeCompare() ->
  ((('_localeCompare'())({lT}))({eQ}))({gT}).

'_localeCompare'() ->
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
                      data_string_common@foreign:'_localeCompare'(
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

replace() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_string_common@foreign:replace(V, V@1, V@2)
          end
      end
  end.

replaceAll() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_string_common@foreign:replaceAll(V, V@1, V@2)
          end
      end
  end.

split() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_common@foreign:split(V, V@1)
      end
  end.

toLower() ->
  fun
    (V) ->
      data_string_common@foreign:toLower(V)
  end.

toUpper() ->
  fun
    (V) ->
      data_string_common@foreign:toUpper(V)
  end.

trim() ->
  fun
    (V) ->
      data_string_common@foreign:trim(V)
  end.

joinWith() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_string_common@foreign:joinWith(V, V@1)
      end
  end.

localeCompare(V, V@1) ->
  data_string_common@foreign:'_localeCompare'({lT}, {eQ}, {gT}, V, V@1).

