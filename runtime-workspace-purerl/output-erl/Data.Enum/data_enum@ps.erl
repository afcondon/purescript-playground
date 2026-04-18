-module(data_enum@ps).
-export([ guard/0
        , 'Cardinality'/0
        , 'Cardinality'/1
        , toEnum/0
        , toEnum/1
        , succ/0
        , succ/1
        , upFromIncluding/0
        , upFromIncluding/2
        , showCardinality/0
        , pred/0
        , pred/1
        , ordCardinality/0
        , newtypeCardinality/0
        , fromEnum/0
        , fromEnum/1
        , toEnumWithDefaults/0
        , toEnumWithDefaults/1
        , eqCardinality/0
        , enumUnit/0
        , enumTuple/0
        , enumTuple/1
        , enumOrdering/0
        , enumMaybe/0
        , enumMaybe/1
        , enumInt/0
        , enumFromTo/0
        , enumFromTo/1
        , enumFromThenTo/0
        , enumFromThenTo/6
        , enumEither/0
        , enumEither/1
        , enumBoolean/0
        , downFromIncluding/0
        , downFromIncluding/2
        , downFrom/0
        , downFrom/2
        , upFrom/0
        , upFrom/2
        , defaultToEnum/0
        , defaultToEnum/1
        , defaultSucc/0
        , defaultSucc/3
        , defaultPred/0
        , defaultPred/3
        , defaultFromEnum/0
        , defaultFromEnum/1
        , defaultCardinality/0
        , defaultCardinality/1
        , charToEnum/0
        , charToEnum/1
        , enumChar/0
        , cardinality/0
        , cardinality/1
        , boundedEnumUnit/0
        , boundedEnumOrdering/0
        , boundedEnumChar/0
        , boundedEnumBoolean/0
        , toCharCode/0
        , fromCharCode/0
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
guard() ->
  control_alternative@ps:guard(data_maybe@ps:alternativeMaybe()).

'Cardinality'() ->
  fun
    (X) ->
      'Cardinality'(X)
  end.

'Cardinality'(X) ->
  X.

toEnum() ->
  fun
    (Dict) ->
      toEnum(Dict)
  end.

toEnum(#{ toEnum := Dict }) ->
  Dict.

succ() ->
  fun
    (Dict) ->
      succ(Dict)
  end.

succ(#{ succ := Dict }) ->
  Dict.

upFromIncluding() ->
  fun
    (DictEnum) ->
      fun
        (DictUnfoldable1) ->
          upFromIncluding(DictEnum, DictUnfoldable1)
      end
  end.

upFromIncluding(#{ succ := DictEnum }, #{ unfoldr1 := DictUnfoldable1 }) ->
  DictUnfoldable1(fun
    (X) ->
      {tuple, X, DictEnum(X)}
  end).

showCardinality() ->
  #{ show =>
     fun
       (V) ->
         <<"(Cardinality ", (data_show@foreign:showIntImpl(V))/binary, ")">>
     end
   }.

pred() ->
  fun
    (Dict) ->
      pred(Dict)
  end.

pred(#{ pred := Dict }) ->
  Dict.

ordCardinality() ->
  data_ord@ps:ordInt().

newtypeCardinality() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

fromEnum() ->
  fun
    (Dict) ->
      fromEnum(Dict)
  end.

fromEnum(#{ fromEnum := Dict }) ->
  Dict.

toEnumWithDefaults() ->
  fun
    (DictBoundedEnum) ->
      toEnumWithDefaults(DictBoundedEnum)
  end.

toEnumWithDefaults(DictBoundedEnum = #{ 'Bounded0' := DictBoundedEnum@1
                                      , toEnum := DictBoundedEnum@2
                                      }) ->
  begin
    Bottom = erlang:map_get(bottom, DictBoundedEnum@1(undefined)),
    fun
      (Low) ->
        fun
          (High) ->
            fun
              (X) ->
                begin
                  V = DictBoundedEnum@2(X),
                  case V of
                    {just, V@1} ->
                      V@1;
                    {nothing} ->
                      begin
                        #{ fromEnum := DictBoundedEnum@3 } = DictBoundedEnum,
                        case X < (DictBoundedEnum@3(Bottom)) of
                          true ->
                            Low;
                          _ ->
                            High
                        end
                      end;
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
                end
            end
        end
    end
  end.

eqCardinality() ->
  data_eq@ps:eqInt().

enumUnit() ->
  #{ succ =>
     fun
       (_) ->
         {nothing}
     end
   , pred =>
     fun
       (_) ->
         {nothing}
     end
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordUnit()
     end
   }.

enumTuple() ->
  fun
    (DictEnum) ->
      enumTuple(DictEnum)
  end.

enumTuple(#{ 'Ord0' := DictEnum, pred := DictEnum@1, succ := DictEnum@2 }) ->
  begin
    #{ 'Eq0' := V, compare := V@1 } = DictEnum(undefined),
    #{ eq := V@2 } = V(undefined),
    fun
      (#{ 'Bounded0' := DictBoundedEnum, 'Enum1' := DictBoundedEnum@1 }) ->
        begin
          #{ bottom := Bounded0, top := Bounded0@1 } =
            DictBoundedEnum(undefined),
          #{ 'Ord0' := Enum1, pred := Enum1@1, succ := Enum1@2 } =
            DictBoundedEnum@1(undefined),
          V@3 = #{ 'Eq0' := V@4 } = Enum1(undefined),
          V@5 = V@4(undefined),
          OrdTuple1 =
            begin
              EqTuple2 =
                #{ eq =>
                   fun
                     (X) ->
                       fun
                         (Y) ->
                           ((V@2(erlang:element(2, X)))(erlang:element(2, Y)))
                             andalso (((erlang:map_get(eq, V@5))
                                       (erlang:element(3, X)))
                                      (erlang:element(3, Y)))
                       end
                   end
                 },
              #{ compare =>
                 fun
                   (X) ->
                     fun
                       (Y) ->
                         begin
                           V@6 =
                             (V@1(erlang:element(2, X)))(erlang:element(2, Y)),
                           case V@6 of
                             {lT} ->
                               {lT};
                             {gT} ->
                               {gT};
                             _ ->
                               begin
                                 #{ compare := V@7 } = V@3,
                                 (V@7(erlang:element(3, X)))
                                 (erlang:element(3, Y))
                               end
                           end
                         end
                     end
                 end
               , 'Eq0' =>
                 fun
                   (_) ->
                     EqTuple2
                 end
               }
            end,
          #{ succ =>
             fun
               (V@6) ->
                 begin
                   V@7 = DictEnum@2(erlang:element(2, V@6)),
                   V@9 =
                     case V@7 of
                       {just, V@8} ->
                         {just, {tuple, V@8, Bounded0}};
                       _ ->
                         {nothing}
                     end,
                   V@10 = (data_tuple@ps:'Tuple'())(erlang:element(2, V@6)),
                   V@11 = Enum1@2(erlang:element(3, V@6)),
                   case V@11 of
                     {nothing} ->
                       V@9;
                     {just, V@12} ->
                       {just, V@10(V@12)};
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end
           , pred =>
             fun
               (V@6) ->
                 begin
                   V@7 = DictEnum@1(erlang:element(2, V@6)),
                   V@9 =
                     case V@7 of
                       {just, V@8} ->
                         {just, {tuple, V@8, Bounded0@1}};
                       _ ->
                         {nothing}
                     end,
                   V@10 = (data_tuple@ps:'Tuple'())(erlang:element(2, V@6)),
                   V@11 = Enum1@1(erlang:element(3, V@6)),
                   case V@11 of
                     {nothing} ->
                       V@9;
                     {just, V@12} ->
                       {just, V@10(V@12)};
                     _ ->
                       erlang:error({fail, <<"Failed pattern match">>})
                   end
                 end
             end
           , 'Ord0' =>
             fun
               (_) ->
                 OrdTuple1
             end
           }
        end
    end
  end.

enumOrdering() ->
  #{ succ =>
     fun
       (V) ->
         case V of
           {lT} ->
             {just, {eQ}};
           {eQ} ->
             {just, {gT}};
           {gT} ->
             {nothing};
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , pred =>
     fun
       (V) ->
         case V of
           {lT} ->
             {nothing};
           {eQ} ->
             {just, {lT}};
           {gT} ->
             {just, {eQ}};
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordOrdering()
     end
   }.

enumMaybe() ->
  fun
    (DictBoundedEnum) ->
      enumMaybe(DictBoundedEnum)
  end.

enumMaybe(#{ 'Bounded0' := DictBoundedEnum, 'Enum1' := DictBoundedEnum@1 }) ->
  begin
    Bottom = erlang:map_get(bottom, DictBoundedEnum(undefined)),
    Enum1 = #{ 'Ord0' := Enum1@1 } = DictBoundedEnum@1(undefined),
    V = #{ 'Eq0' := V@1 } = Enum1@1(undefined),
    V@2 = V@1(undefined),
    OrdMaybe =
      begin
        EqMaybe1 =
          #{ eq =>
             fun
               (X) ->
                 fun
                   (Y) ->
                     case X of
                       {nothing} ->
                         ?IS_KNOWN_TAG(nothing, 0, Y);
                       _ ->
                         ?IS_KNOWN_TAG(just, 1, X)
                           andalso (?IS_KNOWN_TAG(just, 1, Y)
                             andalso (((erlang:map_get(eq, V@2))
                                       (erlang:element(2, X)))
                                      (erlang:element(2, Y))))
                     end
                 end
             end
           },
        #{ compare =>
           fun
             (X) ->
               fun
                 (Y) ->
                   case X of
                     {nothing} ->
                       case Y of
                         {nothing} ->
                           {eQ};
                         _ ->
                           {lT}
                       end;
                     _ ->
                       case Y of
                         {nothing} ->
                           {gT};
                         _ ->
                           if
                             ?IS_KNOWN_TAG(just, 1, X)
                               andalso ?IS_KNOWN_TAG(just, 1, Y) ->
                               begin
                                 {just, Y@1} = Y,
                                 {just, X@1} = X,
                                 #{ compare := V@3 } = V,
                                 (V@3(X@1))(Y@1)
                               end;
                             true ->
                               erlang:error({fail, <<"Failed pattern match">>})
                           end
                       end
                   end
               end
           end
         , 'Eq0' =>
           fun
             (_) ->
               EqMaybe1
           end
         }
      end,
    #{ succ =>
       fun
         (V@3) ->
           case V@3 of
             {nothing} ->
               {just, {just, Bottom}};
             {just, V@4} ->
               begin
                 #{ succ := Enum1@2 } = Enum1,
                 V@5 = Enum1@2(V@4),
                 case V@5 of
                   {just, V@6} ->
                     {just, {just, V@6}};
                   _ ->
                     {nothing}
                 end
               end;
             _ ->
               erlang:error({fail, <<"Failed pattern match">>})
           end
       end
     , pred =>
       fun
         (V@3) ->
           case V@3 of
             {nothing} ->
               {nothing};
             {just, V@4} ->
               begin
                 #{ pred := Enum1@2 } = Enum1,
                 {just, Enum1@2(V@4)}
               end;
             _ ->
               erlang:error({fail, <<"Failed pattern match">>})
           end
       end
     , 'Ord0' =>
       fun
         (_) ->
           OrdMaybe
       end
     }
  end.

enumInt() ->
  #{ succ =>
     fun
       (N) ->
         {just, N + 1}
     end
   , pred =>
     fun
       (N) ->
         {just, N - 1}
     end
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordInt()
     end
   }.

enumFromTo() ->
  fun
    (DictEnum) ->
      enumFromTo(DictEnum)
  end.

enumFromTo(DictEnum = #{ 'Ord0' := DictEnum@1 }) ->
  begin
    Ord0 = #{ 'Eq0' := Ord0@1 } = DictEnum@1(undefined),
    fun
      (#{ unfoldr1 := DictUnfoldable1 }) ->
        fun
          (V) ->
            fun
              (V1) ->
                case ((erlang:map_get(eq, Ord0@1(undefined)))(V))(V1) of
                  true ->
                    (DictUnfoldable1(fun
                       (I) ->
                         if
                           I =< 0 ->
                             {tuple, V, {nothing}};
                           true ->
                             {tuple, V, {just, I - 1}}
                         end
                     end))
                    (0);
                  _ ->
                    begin
                      #{ compare := Ord0@2 } = Ord0,
                      V@1 = (Ord0@2(V))(V1),
                      case ?IS_KNOWN_TAG(lT, 0, V@1) of
                        true ->
                          (DictUnfoldable1(fun
                             (A) ->
                               { tuple
                               , A
                               , begin
                                   V@2 = (erlang:map_get(succ, DictEnum))(A),
                                   case V@2 of
                                     {just, V@3} ->
                                       begin
                                         #{ compare := Ord0@3 } = Ord0,
                                         V@5 =
                                           (guard())
                                           (not begin
                                             V@4 = (Ord0@3(V@3))(V1),
                                             ?IS_KNOWN_TAG(gT, 0, V@4)
                                           end),
                                         case ?IS_KNOWN_TAG(just, 1, V@5) of
                                           true ->
                                             begin
                                               {just, V@6} = V@2,
                                               {just, V@6}
                                             end;
                                           _ ->
                                             {nothing}
                                         end
                                       end;
                                     {nothing} ->
                                       {nothing};
                                     _ ->
                                       erlang:error({ fail
                                                    , <<"Failed pattern match">>
                                                    })
                                   end
                                 end
                               }
                           end))
                          (V);
                        _ ->
                          (DictUnfoldable1(fun
                             (A) ->
                               { tuple
                               , A
                               , begin
                                   V@2 = (erlang:map_get(pred, DictEnum))(A),
                                   case V@2 of
                                     {just, V@3} ->
                                       begin
                                         #{ compare := Ord0@3 } = Ord0,
                                         V@5 =
                                           (guard())
                                           (not begin
                                             V@4 = (Ord0@3(V@3))(V1),
                                             ?IS_KNOWN_TAG(lT, 0, V@4)
                                           end),
                                         case ?IS_KNOWN_TAG(just, 1, V@5) of
                                           true ->
                                             begin
                                               {just, V@6} = V@2,
                                               {just, V@6}
                                             end;
                                           _ ->
                                             {nothing}
                                         end
                                       end;
                                     {nothing} ->
                                       {nothing};
                                     _ ->
                                       erlang:error({ fail
                                                    , <<"Failed pattern match">>
                                                    })
                                   end
                                 end
                               }
                           end))
                          (V)
                      end
                    end
                end
            end
        end
    end
  end.

enumFromThenTo() ->
  fun
    (DictUnfoldable) ->
      fun
        (DictFunctor) ->
          fun
            (DictBoundedEnum) ->
              fun
                (A) ->
                  fun
                    (B) ->
                      fun
                        (C) ->
                          enumFromThenTo(
                            DictUnfoldable,
                            DictFunctor,
                            DictBoundedEnum,
                            A,
                            B,
                            C
                          )
                      end
                  end
              end
          end
      end
  end.

enumFromThenTo( #{ unfoldr := DictUnfoldable }
              , #{ map := DictFunctor }
              , #{ fromEnum := DictBoundedEnum, toEnum := DictBoundedEnum@1 }
              , A
              , B
              , C
              ) ->
  begin
    A_ = DictBoundedEnum(A),
    (DictFunctor(fun
       (X) ->
         begin
           V = {just, V@1} = DictBoundedEnum@1(X),
           case V of
             {just, _} ->
               V@1;
             _ ->
               erlang:error({fail, <<"Failed pattern match">>})
           end
         end
     end))
    ((DictUnfoldable(begin
        V = (DictBoundedEnum(B)) - A_,
        V@1 = DictBoundedEnum(C),
        fun
          (E) ->
            if
              E =< V@1 ->
                {just, {tuple, E, E + V}};
              true ->
                {nothing}
            end
        end
      end))
     (A_))
  end.

enumEither() ->
  fun
    (DictBoundedEnum) ->
      enumEither(DictBoundedEnum)
  end.

enumEither(#{ 'Bounded0' := DictBoundedEnum, 'Enum1' := DictBoundedEnum@1 }) ->
  begin
    Enum1 = #{ 'Ord0' := Enum1@1 } = DictBoundedEnum@1(undefined),
    Top = erlang:map_get(top, DictBoundedEnum(undefined)),
    OrdEither = data_either@ps:ordEither(Enum1@1(undefined)),
    fun
      (#{ 'Bounded0' := DictBoundedEnum1, 'Enum1' := DictBoundedEnum1@1 }) ->
        begin
          Bottom = erlang:map_get(bottom, DictBoundedEnum1(undefined)),
          Enum11 = #{ 'Ord0' := Enum11@1 } = DictBoundedEnum1@1(undefined),
          OrdEither1 = OrdEither(Enum11@1(undefined)),
          #{ succ =>
             fun
               (V) ->
                 case V of
                   {left, V@1} ->
                     begin
                       #{ succ := Enum1@2 } = Enum1,
                       V@2 = Enum1@2(V@1),
                       case V@2 of
                         {nothing} ->
                           {just, {right, Bottom}};
                         {just, V@3} ->
                           {just, {left, V@3}};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end;
                   {right, V@4} ->
                     begin
                       #{ succ := Enum11@2 } = Enum11,
                       V@5 = Enum11@2(V@4),
                       case V@5 of
                         {nothing} ->
                           {nothing};
                         {just, V@6} ->
                           {just, {right, V@6}};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
           , pred =>
             fun
               (V) ->
                 case V of
                   {left, V@1} ->
                     begin
                       #{ pred := Enum1@2 } = Enum1,
                       V@2 = Enum1@2(V@1),
                       case V@2 of
                         {nothing} ->
                           {nothing};
                         {just, V@3} ->
                           {just, {left, V@3}};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end;
                   {right, V@4} ->
                     begin
                       #{ pred := Enum11@2 } = Enum11,
                       V@5 = Enum11@2(V@4),
                       case V@5 of
                         {nothing} ->
                           {just, {left, Top}};
                         {just, V@6} ->
                           {just, {right, V@6}};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
           , 'Ord0' =>
             fun
               (_) ->
                 OrdEither1
             end
           }
        end
    end
  end.

enumBoolean() ->
  #{ succ =>
     fun
       (V) ->
         if
           not V ->
             {just, true};
           true ->
             {nothing}
         end
     end
   , pred =>
     fun
       (V) ->
         if
           V ->
             {just, false};
           true ->
             {nothing}
         end
     end
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordBoolean()
     end
   }.

downFromIncluding() ->
  fun
    (DictEnum) ->
      fun
        (DictUnfoldable1) ->
          downFromIncluding(DictEnum, DictUnfoldable1)
      end
  end.

downFromIncluding(#{ pred := DictEnum }, #{ unfoldr1 := DictUnfoldable1 }) ->
  DictUnfoldable1(fun
    (X) ->
      {tuple, X, DictEnum(X)}
  end).

downFrom() ->
  fun
    (DictEnum) ->
      fun
        (DictUnfoldable) ->
          downFrom(DictEnum, DictUnfoldable)
      end
  end.

downFrom(#{ pred := DictEnum }, #{ unfoldr := DictUnfoldable }) ->
  DictUnfoldable(fun
    (X) ->
      begin
        V = DictEnum(X),
        case V of
          {just, V@1} ->
            {just, {tuple, V@1, V@1}};
          _ ->
            {nothing}
        end
      end
  end).

upFrom() ->
  fun
    (DictEnum) ->
      fun
        (DictUnfoldable) ->
          upFrom(DictEnum, DictUnfoldable)
      end
  end.

upFrom(#{ succ := DictEnum }, #{ unfoldr := DictUnfoldable }) ->
  DictUnfoldable(fun
    (X) ->
      begin
        V = DictEnum(X),
        case V of
          {just, V@1} ->
            {just, {tuple, V@1, V@1}};
          _ ->
            {nothing}
        end
      end
  end).

defaultToEnum() ->
  fun
    (DictBounded) ->
      defaultToEnum(DictBounded)
  end.

defaultToEnum(#{ bottom := DictBounded }) ->
  fun
    (DictEnum) ->
      fun
        (I_) ->
          begin
            Go =
              fun
                Go (I, X) ->
                  if
                    I =:= 0 ->
                      {just, X};
                    true ->
                      begin
                        #{ succ := DictEnum@1 } = DictEnum,
                        V = DictEnum@1(X),
                        case V of
                          {just, V@1} ->
                            begin
                              I@1 = I - 1,
                              Go(I@1, V@1)
                            end;
                          {nothing} ->
                            {nothing};
                          _ ->
                            erlang:error({fail, <<"Failed pattern match">>})
                        end
                      end
                  end
              end,
            if
              I_ < 0 ->
                {nothing};
              true ->
                Go(I_, DictBounded)
            end
          end
      end
  end.

defaultSucc() ->
  fun
    (ToEnum_) ->
      fun
        (FromEnum_) ->
          fun
            (A) ->
              defaultSucc(ToEnum_, FromEnum_, A)
          end
      end
  end.

defaultSucc(ToEnum_, FromEnum_, A) ->
  ToEnum_((FromEnum_(A)) + 1).

defaultPred() ->
  fun
    (ToEnum_) ->
      fun
        (FromEnum_) ->
          fun
            (A) ->
              defaultPred(ToEnum_, FromEnum_, A)
          end
      end
  end.

defaultPred(ToEnum_, FromEnum_, A) ->
  ToEnum_((FromEnum_(A)) - 1).

defaultFromEnum() ->
  fun
    (DictEnum) ->
      defaultFromEnum(DictEnum)
  end.

defaultFromEnum(#{ pred := DictEnum }) ->
  begin
    Go =
      fun
        Go (I, X) ->
          begin
            V = DictEnum(X),
            case V of
              {just, V@1} ->
                begin
                  I@1 = I + 1,
                  Go(I@1, V@1)
                end;
              {nothing} ->
                I;
              _ ->
                erlang:error({fail, <<"Failed pattern match">>})
            end
          end
      end,
    I = 0,
    fun
      (X) ->
        Go(I, X)
    end
  end.

defaultCardinality() ->
  fun
    (DictBounded) ->
      defaultCardinality(DictBounded)
  end.

defaultCardinality(#{ bottom := DictBounded }) ->
  fun
    (#{ succ := DictEnum }) ->
      begin
        Go =
          fun
            Go (I, X) ->
              begin
                V = DictEnum(X),
                case V of
                  {just, V@1} ->
                    begin
                      I@1 = I + 1,
                      Go(I@1, V@1)
                    end;
                  {nothing} ->
                    I;
                  _ ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
              end
          end,
        I = 1,
        Go(I, DictBounded)
      end
  end.

charToEnum() ->
  fun
    (N) ->
      charToEnum(N)
  end.

charToEnum(N) ->
  {just, data_enum@foreign:fromCharCode(N)}.

enumChar() ->
  #{ succ =>
     fun
       (A) ->
         { just
         , data_enum@foreign:fromCharCode((data_enum@foreign:toCharCode(A)) + 1)
         }
     end
   , pred =>
     fun
       (A) ->
         { just
         , data_enum@foreign:fromCharCode((data_enum@foreign:toCharCode(A)) - 1)
         }
     end
   , 'Ord0' =>
     fun
       (_) ->
         data_ord@ps:ordChar()
     end
   }.

cardinality() ->
  fun
    (Dict) ->
      cardinality(Dict)
  end.

cardinality(#{ cardinality := Dict }) ->
  Dict.

boundedEnumUnit() ->
  #{ cardinality => 1
   , toEnum =>
     fun
       (V) ->
         if
           V =:= 0 ->
             {just, unit};
           true ->
             {nothing}
         end
     end
   , fromEnum =>
     fun
       (_) ->
         0
     end
   , 'Bounded0' =>
     fun
       (_) ->
         data_bounded@ps:boundedUnit()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumUnit()
     end
   }.

boundedEnumOrdering() ->
  #{ cardinality => 3
   , toEnum =>
     fun
       (V) ->
         if
           V =:= 0 ->
             {just, {lT}};
           V =:= 1 ->
             {just, {eQ}};
           V =:= 2 ->
             {just, {gT}};
           true ->
             {nothing}
         end
     end
   , fromEnum =>
     fun
       (V) ->
         case V of
           {lT} ->
             0;
           {eQ} ->
             1;
           {gT} ->
             2;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , 'Bounded0' =>
     fun
       (_) ->
         data_bounded@ps:boundedOrdering()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumOrdering()
     end
   }.

boundedEnumChar() ->
  #{ cardinality =>
     (data_enum@foreign:toCharCode(data_bounded@foreign:topChar()))
       - (data_enum@foreign:toCharCode(data_bounded@foreign:bottomChar()))
   , toEnum => charToEnum()
   , fromEnum => toCharCode()
   , 'Bounded0' =>
     fun
       (_) ->
         data_bounded@ps:boundedChar()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumChar()
     end
   }.

boundedEnumBoolean() ->
  #{ cardinality => 2
   , toEnum =>
     fun
       (V) ->
         if
           V =:= 0 ->
             {just, false};
           V =:= 1 ->
             {just, true};
           true ->
             {nothing}
         end
     end
   , fromEnum =>
     fun
       (V) ->
         if
           not V ->
             0;
           V ->
             1;
           true ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , 'Bounded0' =>
     fun
       (_) ->
         data_bounded@ps:boundedBoolean()
     end
   , 'Enum1' =>
     fun
       (_) ->
         enumBoolean()
     end
   }.

toCharCode() ->
  fun
    (V) ->
      data_enum@foreign:toCharCode(V)
  end.

fromCharCode() ->
  fun
    (V) ->
      data_enum@foreign:fromCharCode(V)
  end.

