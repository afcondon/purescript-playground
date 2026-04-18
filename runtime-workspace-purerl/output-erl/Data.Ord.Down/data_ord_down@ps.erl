-module(data_ord_down@ps).
-export([ 'Down'/0
        , 'Down'/1
        , showDown/0
        , showDown/1
        , newtypeDown/0
        , eqDown/0
        , eqDown/1
        , ordDown/0
        , ordDown/1
        , boundedDown/0
        , boundedDown/1
        ]).
-compile(no_auto_import).
'Down'() ->
  fun
    (X) ->
      'Down'(X)
  end.

'Down'(X) ->
  X.

showDown() ->
  fun
    (DictShow) ->
      showDown(DictShow)
  end.

showDown(#{ show := DictShow }) ->
  #{ show =>
     fun
       (V) ->
         <<"(Down ", (DictShow(V))/binary, ")">>
     end
   }.

newtypeDown() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

eqDown() ->
  fun
    (DictEq) ->
      eqDown(DictEq)
  end.

eqDown(DictEq) ->
  DictEq.

ordDown() ->
  fun
    (DictOrd) ->
      ordDown(DictOrd)
  end.

ordDown(#{ 'Eq0' := DictOrd, compare := DictOrd@1 }) ->
  begin
    V = DictOrd(undefined),
    #{ compare =>
       fun
         (V@1) ->
           fun
             (V1) ->
               begin
                 V@2 = (DictOrd@1(V@1))(V1),
                 case V@2 of
                   {gT} ->
                     {lT};
                   {eQ} ->
                     {eQ};
                   {lT} ->
                     {gT};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
               end
           end
       end
     , 'Eq0' =>
       fun
         (_) ->
           V
       end
     }
  end.

boundedDown() ->
  fun
    (DictBounded) ->
      boundedDown(DictBounded)
  end.

boundedDown(#{ 'Ord0' := DictBounded
             , bottom := DictBounded@1
             , top := DictBounded@2
             }) ->
  begin
    #{ 'Eq0' := V, compare := V@1 } = DictBounded(undefined),
    V@2 = V(undefined),
    OrdDown1 =
      #{ compare =>
         fun
           (V@3) ->
             fun
               (V1) ->
                 begin
                   V@4 = (V@1(V@3))(V1),
                   case V@4 of
                     {gT} ->
                       {lT};
                     {eQ} ->
                       {eQ};
                     {lT} ->
                       {gT};
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end
         end
       , 'Eq0' =>
         fun
           (_) ->
             V@2
         end
       },
    #{ top => DictBounded@1
     , bottom => DictBounded@2
     , 'Ord0' =>
       fun
         (_) ->
           OrdDown1
       end
     }
  end.

