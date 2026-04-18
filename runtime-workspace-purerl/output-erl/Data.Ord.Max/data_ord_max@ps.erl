-module(data_ord_max@ps).
-export([ 'Max'/0
        , 'Max'/1
        , showMax/0
        , showMax/1
        , semigroupMax/0
        , semigroupMax/1
        , newtypeMax/0
        , monoidMax/0
        , monoidMax/1
        , eqMax/0
        , eqMax/1
        , ordMax/0
        , ordMax/1
        ]).
-compile(no_auto_import).
'Max'() ->
  fun
    (X) ->
      'Max'(X)
  end.

'Max'(X) ->
  X.

showMax() ->
  fun
    (DictShow) ->
      showMax(DictShow)
  end.

showMax(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Max ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupMax() ->
  fun
    (DictOrd) ->
      semigroupMax(DictOrd)
  end.

semigroupMax(#{ compare := DictOrd }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             begin
               V@1 = (DictOrd(V))(V1),
               case V@1 of
                 {lT} ->
                   V1;
                 {eQ} ->
                   V;
                 {gT} ->
                   V;
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
             end
         end
     end
   }.

newtypeMax() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidMax() ->
  fun
    (DictBounded) ->
      monoidMax(DictBounded)
  end.

monoidMax(#{ 'Ord0' := DictBounded, bottom := DictBounded@1 }) ->
  begin
    #{ compare := V } = DictBounded(undefined),
    SemigroupMax1 =
      #{ append =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 begin
                   V@2 = (V(V@1))(V1),
                   case V@2 of
                     {lT} ->
                       V1;
                     {eQ} ->
                       V@1;
                     {gT} ->
                       V@1;
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end
         end
       },
    #{ mempty => DictBounded@1
     , 'Semigroup0' =>
       fun
         (_) ->
           SemigroupMax1
       end
     }
  end.

eqMax() ->
  fun
    (DictEq) ->
      eqMax(DictEq)
  end.

eqMax(DictEq) ->
  DictEq.

ordMax() ->
  fun
    (DictOrd) ->
      ordMax(DictOrd)
  end.

ordMax(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    V = DictOrd(undefined),
    #{ compare =>
       fun
         (V@1) ->
           fun
             (V1) ->
               (DictOrd@1(V@1))(V1)
           end
       end
     , 'Eq0' =>
       fun
         (_) ->
           V
       end
     }
  end.

