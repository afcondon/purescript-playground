-module(data_enum_generic@ps).
-export([ 'genericToEnum\''/0
        , 'genericToEnum\''/1
        , genericToEnum/0
        , genericToEnum/3
        , 'genericSucc\''/0
        , 'genericSucc\''/1
        , genericSucc/0
        , genericSucc/3
        , 'genericPred\''/0
        , 'genericPred\''/1
        , genericPred/0
        , genericPred/3
        , 'genericFromEnum\''/0
        , 'genericFromEnum\''/1
        , genericFromEnum/0
        , genericFromEnum/3
        , genericEnumSum/0
        , genericEnumSum/2
        , genericEnumProduct/0
        , genericEnumProduct/5
        , genericEnumNoArguments/0
        , genericEnumConstructor/0
        , genericEnumConstructor/1
        , genericEnumArgument/0
        , genericEnumArgument/1
        , 'genericCardinality\''/0
        , 'genericCardinality\''/1
        , genericCardinality/0
        , genericCardinality/2
        , genericBoundedEnumSum/0
        , genericBoundedEnumSum/1
        , genericBoundedEnumProduct/0
        , genericBoundedEnumProduct/1
        , genericBoundedEnumNoArguments/0
        , genericBoundedEnumConstructor/0
        , genericBoundedEnumConstructor/1
        , genericBoundedEnumArgument/0
        , genericBoundedEnumArgument/1
        ]).
-compile(no_auto_import).
'genericToEnum\''() ->
  fun
    (Dict) ->
      'genericToEnum\''(Dict)
  end.

'genericToEnum\''(#{ 'genericToEnum\'' := Dict }) ->
  Dict.

genericToEnum() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericBoundedEnum) ->
          fun
            (X) ->
              genericToEnum(DictGeneric, DictGenericBoundedEnum, X)
          end
      end
  end.

genericToEnum(DictGeneric, #{ 'genericToEnum\'' := DictGenericBoundedEnum }, X) ->
  begin
    V = DictGenericBoundedEnum(X),
    case V of
      {just, V@1} ->
        begin
          #{ to := DictGeneric@1 } = DictGeneric,
          {just, DictGeneric@1(V@1)}
        end;
      _ ->
        {nothing}
    end
  end.

'genericSucc\''() ->
  fun
    (Dict) ->
      'genericSucc\''(Dict)
  end.

'genericSucc\''(#{ 'genericSucc\'' := Dict }) ->
  Dict.

genericSucc() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericEnum) ->
          fun
            (X) ->
              genericSucc(DictGeneric, DictGenericEnum, X)
          end
      end
  end.

genericSucc( DictGeneric = #{ from := DictGeneric@1 }
           , #{ 'genericSucc\'' := DictGenericEnum }
           , X
           ) ->
  begin
    V = DictGenericEnum(DictGeneric@1(X)),
    case V of
      {just, V@1} ->
        begin
          #{ to := DictGeneric@2 } = DictGeneric,
          {just, DictGeneric@2(V@1)}
        end;
      _ ->
        {nothing}
    end
  end.

'genericPred\''() ->
  fun
    (Dict) ->
      'genericPred\''(Dict)
  end.

'genericPred\''(#{ 'genericPred\'' := Dict }) ->
  Dict.

genericPred() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericEnum) ->
          fun
            (X) ->
              genericPred(DictGeneric, DictGenericEnum, X)
          end
      end
  end.

genericPred( DictGeneric = #{ from := DictGeneric@1 }
           , #{ 'genericPred\'' := DictGenericEnum }
           , X
           ) ->
  begin
    V = DictGenericEnum(DictGeneric@1(X)),
    case V of
      {just, V@1} ->
        begin
          #{ to := DictGeneric@2 } = DictGeneric,
          {just, DictGeneric@2(V@1)}
        end;
      _ ->
        {nothing}
    end
  end.

'genericFromEnum\''() ->
  fun
    (Dict) ->
      'genericFromEnum\''(Dict)
  end.

'genericFromEnum\''(#{ 'genericFromEnum\'' := Dict }) ->
  Dict.

genericFromEnum() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericBoundedEnum) ->
          fun
            (X) ->
              genericFromEnum(DictGeneric, DictGenericBoundedEnum, X)
          end
      end
  end.

genericFromEnum( #{ from := DictGeneric }
               , #{ 'genericFromEnum\'' := DictGenericBoundedEnum }
               , X
               ) ->
  DictGenericBoundedEnum(DictGeneric(X)).

genericEnumSum() ->
  fun
    (DictGenericEnum) ->
      fun
        (DictGenericTop) ->
          genericEnumSum(DictGenericEnum, DictGenericTop)
      end
  end.

genericEnumSum(DictGenericEnum, #{ 'genericTop\'' := DictGenericTop }) ->
  fun
    (DictGenericEnum1) ->
      fun
        (#{ 'genericBottom\'' := DictGenericBottom }) ->
          #{ 'genericPred\'' =>
             fun
               (V) ->
                 case V of
                   {inl, V@1} ->
                     begin
                       #{ 'genericPred\'' := DictGenericEnum@1 } =
                         DictGenericEnum,
                       V@2 = DictGenericEnum@1(V@1),
                       case V@2 of
                         {just, V@3} ->
                           {just, {inl, V@3}};
                         _ ->
                           {nothing}
                       end
                     end;
                   {inr, V@4} ->
                     begin
                       #{ 'genericPred\'' := DictGenericEnum1@1 } =
                         DictGenericEnum1,
                       V1 = DictGenericEnum1@1(V@4),
                       case V1 of
                         {nothing} ->
                           {just, {inl, DictGenericTop}};
                         {just, V1@1} ->
                           {just, {inr, V1@1}};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
           , 'genericSucc\'' =>
             fun
               (V) ->
                 case V of
                   {inl, V@1} ->
                     begin
                       #{ 'genericSucc\'' := DictGenericEnum@1 } =
                         DictGenericEnum,
                       V1 = DictGenericEnum@1(V@1),
                       case V1 of
                         {nothing} ->
                           {just, {inr, DictGenericBottom}};
                         {just, V1@1} ->
                           {just, {inl, V1@1}};
                         _ ->
                           erlang:error({fail, <<"Failed pattern match">>})
                       end
                     end;
                   {inr, V@2} ->
                     begin
                       #{ 'genericSucc\'' := DictGenericEnum1@1 } =
                         DictGenericEnum1,
                       V@3 = DictGenericEnum1@1(V@2),
                       case V@3 of
                         {just, V@4} ->
                           {just, {inr, V@4}};
                         _ ->
                           {nothing}
                       end
                     end;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
           }
      end
  end.

genericEnumProduct() ->
  fun
    (DictGenericEnum) ->
      fun
        (DictGenericTop) ->
          fun
            (DictGenericBottom) ->
              fun
                (DictGenericEnum1) ->
                  fun
                    (DictGenericTop1) ->
                      genericEnumProduct(
                        DictGenericEnum,
                        DictGenericTop,
                        DictGenericBottom,
                        DictGenericEnum1,
                        DictGenericTop1
                      )
                  end
              end
          end
      end
  end.

genericEnumProduct( DictGenericEnum
                  , _
                  , _
                  , #{ 'genericPred\'' := DictGenericEnum1
                     , 'genericSucc\'' := DictGenericEnum1@1
                     }
                  , #{ 'genericTop\'' := DictGenericTop1 }
                  ) ->
  fun
    (#{ 'genericBottom\'' := DictGenericBottom1 }) ->
      #{ 'genericPred\'' =>
         fun
           (V) ->
             begin
               V1 = DictGenericEnum1(erlang:element(3, V)),
               case V1 of
                 {just, V1@1} ->
                   {just, {product, erlang:element(2, V), V1@1}};
                 {nothing} ->
                   begin
                     #{ 'genericPred\'' := DictGenericEnum@1 } = DictGenericEnum,
                     V@1 = DictGenericEnum@1(erlang:element(2, V)),
                     case V@1 of
                       {just, V@2} ->
                         {just, {product, V@2, DictGenericTop1}};
                       _ ->
                         {nothing}
                     end
                   end;
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
             end
         end
       , 'genericSucc\'' =>
         fun
           (V) ->
             begin
               V1 = DictGenericEnum1@1(erlang:element(3, V)),
               case V1 of
                 {just, V1@1} ->
                   {just, {product, erlang:element(2, V), V1@1}};
                 {nothing} ->
                   begin
                     #{ 'genericSucc\'' := DictGenericEnum@1 } = DictGenericEnum,
                     V@1 = DictGenericEnum@1(erlang:element(2, V)),
                     case V@1 of
                       {just, V@2} ->
                         {just, {product, V@2, DictGenericBottom1}};
                       _ ->
                         {nothing}
                     end
                   end;
                 _ ->
                   erlang:error({fail, <<"Failed pattern match">>})
               end
             end
         end
       }
  end.

genericEnumNoArguments() ->
  #{ 'genericPred\'' =>
     fun
       (_) ->
         {nothing}
     end
   , 'genericSucc\'' =>
     fun
       (_) ->
         {nothing}
     end
   }.

genericEnumConstructor() ->
  fun
    (DictGenericEnum) ->
      genericEnumConstructor(DictGenericEnum)
  end.

genericEnumConstructor(#{ 'genericPred\'' := DictGenericEnum
                        , 'genericSucc\'' := DictGenericEnum@1
                        }) ->
  #{ 'genericPred\'' =>
     fun
       (V) ->
         begin
           V@1 = DictGenericEnum(V),
           case V@1 of
             {just, V@2} ->
               {just, V@2};
             _ ->
               {nothing}
           end
         end
     end
   , 'genericSucc\'' =>
     fun
       (V) ->
         begin
           V@1 = DictGenericEnum@1(V),
           case V@1 of
             {just, V@2} ->
               {just, V@2};
             _ ->
               {nothing}
           end
         end
     end
   }.

genericEnumArgument() ->
  fun
    (DictEnum) ->
      genericEnumArgument(DictEnum)
  end.

genericEnumArgument(#{ pred := DictEnum, succ := DictEnum@1 }) ->
  #{ 'genericPred\'' =>
     fun
       (V) ->
         begin
           V@1 = DictEnum(V),
           case V@1 of
             {just, V@2} ->
               {just, V@2};
             _ ->
               {nothing}
           end
         end
     end
   , 'genericSucc\'' =>
     fun
       (V) ->
         begin
           V@1 = DictEnum@1(V),
           case V@1 of
             {just, V@2} ->
               {just, V@2};
             _ ->
               {nothing}
           end
         end
     end
   }.

'genericCardinality\''() ->
  fun
    (Dict) ->
      'genericCardinality\''(Dict)
  end.

'genericCardinality\''(#{ 'genericCardinality\'' := Dict }) ->
  Dict.

genericCardinality() ->
  fun
    (DictGeneric) ->
      fun
        (DictGenericBoundedEnum) ->
          genericCardinality(DictGeneric, DictGenericBoundedEnum)
      end
  end.

genericCardinality(_, #{ 'genericCardinality\'' := DictGenericBoundedEnum }) ->
  DictGenericBoundedEnum.

genericBoundedEnumSum() ->
  fun
    (DictGenericBoundedEnum) ->
      genericBoundedEnumSum(DictGenericBoundedEnum)
  end.

genericBoundedEnumSum(DictGenericBoundedEnum = #{ 'genericCardinality\'' :=
                                                  DictGenericBoundedEnum@1
                                                }) ->
  fun
    (DictGenericBoundedEnum1 = #{ 'genericCardinality\'' :=
                                  DictGenericBoundedEnum1@1
                                }) ->
      #{ 'genericCardinality\'' =>
         DictGenericBoundedEnum@1 + DictGenericBoundedEnum1@1
       , 'genericToEnum\'' =>
         fun
           (N) ->
             if
               (N >= 0) andalso (N < DictGenericBoundedEnum@1) ->
                 begin
                   #{ 'genericToEnum\'' := DictGenericBoundedEnum@2 } =
                     DictGenericBoundedEnum,
                   V = DictGenericBoundedEnum@2(N),
                   case V of
                     {just, V@1} ->
                       {just, {inl, V@1}};
                     _ ->
                       {nothing}
                   end
                 end;
               true ->
                 begin
                   #{ 'genericToEnum\'' := DictGenericBoundedEnum1@2 } =
                     DictGenericBoundedEnum1,
                   V@2 = DictGenericBoundedEnum1@2(N - DictGenericBoundedEnum@1),
                   case V@2 of
                     {just, V@3} ->
                       {just, {inr, V@3}};
                     _ ->
                       {nothing}
                   end
                 end
             end
         end
       , 'genericFromEnum\'' =>
         fun
           (V) ->
             case V of
               {inl, V@1} ->
                 begin
                   #{ 'genericFromEnum\'' := DictGenericBoundedEnum@2 } =
                     DictGenericBoundedEnum,
                   DictGenericBoundedEnum@2(V@1)
                 end;
               {inr, V@2} ->
                 begin
                   #{ 'genericFromEnum\'' := DictGenericBoundedEnum1@2 } =
                     DictGenericBoundedEnum1,
                   (DictGenericBoundedEnum1@2(V@2)) + DictGenericBoundedEnum@1
                 end;
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
       }
  end.

genericBoundedEnumProduct() ->
  fun
    (DictGenericBoundedEnum) ->
      genericBoundedEnumProduct(DictGenericBoundedEnum)
  end.

genericBoundedEnumProduct(#{ 'genericCardinality\'' := DictGenericBoundedEnum
                           , 'genericFromEnum\'' := DictGenericBoundedEnum@1
                           , 'genericToEnum\'' := DictGenericBoundedEnum@2
                           }) ->
  fun
    (DictGenericBoundedEnum1 = #{ 'genericCardinality\'' :=
                                  DictGenericBoundedEnum1@1
                                , 'genericFromEnum\'' :=
                                  DictGenericBoundedEnum1@2
                                }) ->
      #{ 'genericCardinality\'' =>
         DictGenericBoundedEnum * DictGenericBoundedEnum1@1
       , 'genericToEnum\'' =>
         fun
           (N) ->
             begin
               V = DictGenericBoundedEnum@2(N div DictGenericBoundedEnum1@1),
               case V of
                 {just, _} ->
                   begin
                     #{ 'genericToEnum\'' := DictGenericBoundedEnum1@3 } =
                       DictGenericBoundedEnum1,
                     V@1 =
                       DictGenericBoundedEnum1@3(data_euclideanRing@foreign:intMod(
                                                   N,
                                                   DictGenericBoundedEnum1@1
                                                 )),
                     case V@1 of
                       {just, V@2} ->
                         begin
                           {just, V@3} = V,
                           {just, {product, V@3, V@2}}
                         end;
                       _ ->
                         {nothing}
                     end
                   end;
                 _ ->
                   {nothing}
               end
             end
         end
       , 'genericFromEnum\'' =>
         fun
           (V1) ->
             ((DictGenericBoundedEnum@1(erlang:element(2, V1)))
               * DictGenericBoundedEnum1@1)
               + (DictGenericBoundedEnum1@2(erlang:element(3, V1)))
         end
       }
  end.

genericBoundedEnumNoArguments() ->
  #{ 'genericCardinality\'' => 1
   , 'genericToEnum\'' =>
     fun
       (I) ->
         if
           I =:= 0 ->
             {just, {noArguments}};
           true ->
             {nothing}
         end
     end
   , 'genericFromEnum\'' =>
     fun
       (_) ->
         0
     end
   }.

genericBoundedEnumConstructor() ->
  fun
    (DictGenericBoundedEnum) ->
      genericBoundedEnumConstructor(DictGenericBoundedEnum)
  end.

genericBoundedEnumConstructor(#{ 'genericCardinality\'' :=
                                 DictGenericBoundedEnum
                               , 'genericFromEnum\'' := DictGenericBoundedEnum@1
                               , 'genericToEnum\'' := DictGenericBoundedEnum@2
                               }) ->
  #{ 'genericCardinality\'' => DictGenericBoundedEnum
   , 'genericToEnum\'' =>
     fun
       (I) ->
         begin
           V = DictGenericBoundedEnum@2(I),
           case V of
             {just, V@1} ->
               {just, V@1};
             _ ->
               {nothing}
           end
         end
     end
   , 'genericFromEnum\'' =>
     fun
       (V) ->
         DictGenericBoundedEnum@1(V)
     end
   }.

genericBoundedEnumArgument() ->
  fun
    (DictBoundedEnum) ->
      genericBoundedEnumArgument(DictBoundedEnum)
  end.

genericBoundedEnumArgument(#{ cardinality := DictBoundedEnum
                            , fromEnum := DictBoundedEnum@1
                            , toEnum := DictBoundedEnum@2
                            }) ->
  #{ 'genericCardinality\'' => DictBoundedEnum
   , 'genericToEnum\'' =>
     fun
       (I) ->
         begin
           V = DictBoundedEnum@2(I),
           case V of
             {just, V@1} ->
               {just, V@1};
             _ ->
               {nothing}
           end
         end
     end
   , 'genericFromEnum\'' =>
     fun
       (V) ->
         DictBoundedEnum@1(V)
     end
   }.

