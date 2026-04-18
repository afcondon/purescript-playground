-module(data_functor_contravariant@ps).
-export([ contravariantConst/0
        , cmap/0
        , cmap/1
        , cmapFlipped/0
        , cmapFlipped/3
        , coerce/0
        , coerce/3
        , imapC/0
        , imapC/3
        ]).
-compile(no_auto_import).
contravariantConst() ->
  #{ cmap =>
     fun
       (_) ->
         fun
           (V1) ->
             V1
         end
     end
   }.

cmap() ->
  fun
    (Dict) ->
      cmap(Dict)
  end.

cmap(#{ cmap := Dict }) ->
  Dict.

cmapFlipped() ->
  fun
    (DictContravariant) ->
      fun
        (X) ->
          fun
            (F) ->
              cmapFlipped(DictContravariant, X, F)
          end
      end
  end.

cmapFlipped(#{ cmap := DictContravariant }, X, F) ->
  (DictContravariant(F))(X).

coerce() ->
  fun
    (DictContravariant) ->
      fun
        (DictFunctor) ->
          fun
            (A) ->
              coerce(DictContravariant, DictFunctor, A)
          end
      end
  end.

coerce(#{ cmap := DictContravariant }, #{ map := DictFunctor }, A) ->
  begin
    V = data_void@ps:absurd(),
    (DictFunctor(V))((DictContravariant(V))(A))
  end.

imapC() ->
  fun
    (DictContravariant) ->
      fun
        (V) ->
          fun
            (F) ->
              imapC(DictContravariant, V, F)
          end
      end
  end.

imapC(#{ cmap := DictContravariant }, _, F) ->
  DictContravariant(F).

