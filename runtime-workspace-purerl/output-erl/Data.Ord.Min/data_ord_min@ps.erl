-module(data_ord_min@ps).
-export([ 'Min'/0
        , 'Min'/1
        , showMin/0
        , showMin/1
        , semigroupMin/0
        , semigroupMin/1
        , newtypeMin/0
        , monoidMin/0
        , monoidMin/1
        , eqMin/0
        , eqMin/1
        , ordMin/0
        , ordMin/1
        ]).
-compile(no_auto_import).
'Min'() ->
  fun
    (X) ->
      'Min'(X)
  end.

'Min'(X) ->
  X.

showMin() ->
  fun
    (DictShow) ->
      showMin(DictShow)
  end.

showMin(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Min ", (DictShow(V))/binary, ")">>
     end
   }.

semigroupMin() ->
  fun
    (DictOrd) ->
      semigroupMin(DictOrd)
  end.

semigroupMin(#{ compare := DictOrd }) ->
  #{ append =>
     fun
       (V) ->
         fun
           (V1) ->
             begin
               V@1 = (DictOrd(V))(V1),
               case V@1 of
                 {lT} ->
                   V;
                 {eQ} ->
                   V;
                 {gT} ->
                   V1;
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
             end
         end
     end
   }.

newtypeMin() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

monoidMin() ->
  fun
    (DictBounded) ->
      monoidMin(DictBounded)
  end.

monoidMin(#{ 'Ord0' := DictBounded, top := DictBounded@1 }) ->
  begin
    #{ compare := V } = DictBounded(undefined),
    SemigroupMin1 =
      #{ append =>
         fun
           (V@1) ->
             fun
               (V1) ->
                 begin
                   V@2 = (V(V@1))(V1),
                   case V@2 of
                     {lT} ->
                       V@1;
                     {eQ} ->
                       V@1;
                     {gT} ->
                       V1;
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
           SemigroupMin1
       end
     }
  end.

eqMin() ->
  fun
    (DictEq) ->
      eqMin(DictEq)
  end.

eqMin(DictEq) ->
  DictEq.

ordMin() ->
  fun
    (DictOrd) ->
      ordMin(DictOrd)
  end.

ordMin(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
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

