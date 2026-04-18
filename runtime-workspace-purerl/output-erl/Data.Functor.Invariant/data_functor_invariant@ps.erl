-module(data_functor_invariant@ps).
-export([ invariantMultiplicative/0
        , invariantEndo/0
        , invariantDual/0
        , invariantDisj/0
        , invariantConj/0
        , invariantAdditive/0
        , imapF/0
        , imapF/3
        , invariantArray/0
        , invariantFn/0
        , imap/0
        , imap/1
        , invariantAlternate/0
        , invariantAlternate/1
        ]).
-compile(no_auto_import).
invariantMultiplicative() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V1) ->
                 F(V1)
             end
         end
     end
   }.

invariantEndo() ->
  #{ imap =>
     fun
       (Ab) ->
         fun
           (Ba) ->
             fun
               (V) ->
                 fun
                   (X) ->
                     Ab(V(Ba(X)))
                 end
             end
         end
     end
   }.

invariantDual() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V1) ->
                 F(V1)
             end
         end
     end
   }.

invariantDisj() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V1) ->
                 F(V1)
             end
         end
     end
   }.

invariantConj() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V1) ->
                 F(V1)
             end
         end
     end
   }.

invariantAdditive() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             fun
               (V1) ->
                 F(V1)
             end
         end
     end
   }.

imapF() ->
  fun
    (DictFunctor) ->
      fun
        (F) ->
          fun
            (V) ->
              imapF(DictFunctor, F, V)
          end
      end
  end.

imapF(#{ map := DictFunctor }, F, _) ->
  DictFunctor(F).

invariantArray() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             (data_functor@ps:arrayMap())(F)
         end
     end
   }.

invariantFn() ->
  #{ imap =>
     fun
       (F) ->
         fun
           (_) ->
             (erlang:map_get(compose, control_semigroupoid@ps:semigroupoidFn()))
             (F)
         end
     end
   }.

imap() ->
  fun
    (Dict) ->
      imap(Dict)
  end.

imap(#{ imap := Dict }) ->
  Dict.

invariantAlternate() ->
  fun
    (DictInvariant) ->
      invariantAlternate(DictInvariant)
  end.

invariantAlternate(#{ imap := DictInvariant }) ->
  #{ imap =>
     fun
       (F) ->
         fun
           (G) ->
             fun
               (V) ->
                 ((DictInvariant(F))(G))(V)
             end
         end
     end
   }.

