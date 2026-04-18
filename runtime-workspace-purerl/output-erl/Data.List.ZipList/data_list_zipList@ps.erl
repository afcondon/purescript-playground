-module(data_list_zipList@ps).
-export([ 'ZipList'/0
        , 'ZipList'/1
        , traversableZipList/0
        , showZipList/0
        , showZipList/1
        , semigroupZipList/0
        , ordZipList/0
        , ordZipList/1
        , newtypeZipList/0
        , monoidZipList/0
        , functorZipList/0
        , foldableZipList/0
        , eqZipList/0
        , eqZipList/1
        , applyZipList/0
        , zipListIsNotBind/0
        , zipListIsNotBind/1
        , applicativeZipList/0
        , altZipList/0
        , plusZipList/0
        , alternativeZipList/0
        ]).
-compile(no_auto_import).
'ZipList'() ->
  fun
    (X) ->
      'ZipList'(X)
  end.

'ZipList'(X) ->
  X.

traversableZipList() ->
  data_list_lazy_types@ps:traversableList().

showZipList() ->
  fun
    (DictShow) ->
      showZipList(DictShow)
  end.

showZipList(DictShow) ->
  #{ show =>
     fun
       (V) ->
         <<
           "(ZipList ",
           ((erlang:map_get(show, data_list_lazy_types@ps:showList(DictShow)))
            (V))/binary,
           ")"
         >>
     end
   }.

semigroupZipList() ->
  data_list_lazy_types@ps:semigroupList().

ordZipList() ->
  fun
    (DictOrd) ->
      ordZipList(DictOrd)
  end.

ordZipList(DictOrd) ->
  data_list_lazy_types@ps:ordList(DictOrd).

newtypeZipList() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidZipList() ->
  data_list_lazy_types@ps:monoidList().

functorZipList() ->
  data_list_lazy_types@ps:functorList().

foldableZipList() ->
  data_list_lazy_types@ps:foldableList().

eqZipList() ->
  fun
    (DictEq) ->
      eqZipList(DictEq)
  end.

eqZipList(DictEq) ->
  #{ eq => (erlang:map_get(eq1, data_list_lazy_types@ps:eq1List()))(DictEq) }.

applyZipList() ->
  #{ apply =>
     fun
       (V) ->
         fun
           (V1) ->
             data_list_lazy@ps:zipWith(data_function@ps:apply(), V, V1)
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_list_lazy_types@ps:functorList()
     end
   }.

zipListIsNotBind() ->
  fun
    (V) ->
      zipListIsNotBind(V)
  end.

zipListIsNotBind(_) ->
  #{ bind => erlang:error(<<"bind: unreachable">>)
   , 'Apply0' =>
     fun
       (_) ->
         applyZipList()
     end
   }.

applicativeZipList() ->
  #{ pure =>
     fun
       (X) ->
         data_list_lazy@ps:repeat(X)
     end
   , 'Apply0' =>
     fun
       (_) ->
         applyZipList()
     end
   }.

altZipList() ->
  #{ alt =>
     fun
       (V) ->
         fun
           (V1) ->
             ((erlang:map_get(append, data_list_lazy_types@ps:semigroupList()))
              (V))
             ((data_list_lazy@ps:drop((data_list_lazy@ps:length())(V)))(V1))
         end
     end
   , 'Functor0' =>
     fun
       (_) ->
         data_list_lazy_types@ps:functorList()
     end
   }.

plusZipList() ->
  #{ empty => data_list_lazy_types@ps:nil()
   , 'Alt0' =>
     fun
       (_) ->
         altZipList()
     end
   }.

alternativeZipList() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         applicativeZipList()
     end
   , 'Plus1' =>
     fun
       (_) ->
         plusZipList()
     end
   }.

