-module(erl_data_binary@ps).
-export([part/0, byteSize/0, part_/0, part/3]).
-compile(no_auto_import).
part() ->
  ((part_())({nothing}))(data_maybe@ps:'Just'()).

byteSize() ->
  fun
    (V) ->
      erl_data_binary@foreign:byteSize(V)
  end.

part_() ->
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
                      erl_data_binary@foreign:part_(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

part(V, V@1, V@2) ->
  erl_data_binary@foreign:part_({nothing}, data_maybe@ps:'Just'(), V, V@1, V@2).

