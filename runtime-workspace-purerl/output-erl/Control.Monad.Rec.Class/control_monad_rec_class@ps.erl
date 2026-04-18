-module(control_monad_rec_class@ps).
-export([ 'Loop'/0
        , 'Done'/0
        , tailRecM/0
        , tailRecM/1
        , tailRecM2/0
        , tailRecM2/4
        , tailRecM3/0
        , tailRecM3/5
        , untilJust/0
        , untilJust/1
        , whileJust/0
        , whileJust/1
        , tailRec/0
        , tailRec/1
        , monadRecMaybe/0
        , monadRecIdentity/0
        , monadRecFunction/0
        , monadRecEither/0
        , monadRecEffect/0
        , functorStep/0
        , forever/0
        , forever/1
        , bifunctorStep/0
        ]).
-compile(no_auto_import).
'Loop'() ->
  fun
    (Value0) ->
      {loop, Value0}
  end.

'Done'() ->
  fun
    (Value0) ->
      {done, Value0}
  end.

tailRecM() ->
  fun
    (Dict) ->
      tailRecM(Dict)
  end.

tailRecM(#{ tailRecM := Dict }) ->
  Dict.

tailRecM2() ->
  fun
    (DictMonadRec) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (B) ->
                  tailRecM2(DictMonadRec, F, A, B)
              end
          end
      end
  end.

tailRecM2(#{ tailRecM := DictMonadRec }, F, A, B) ->
  (DictMonadRec(fun
     (#{ a := O, b := O@1 }) ->
       (F(O))(O@1)
   end))
  (#{ a => A, b => B }).

tailRecM3() ->
  fun
    (DictMonadRec) ->
      fun
        (F) ->
          fun
            (A) ->
              fun
                (B) ->
                  fun
                    (C) ->
                      tailRecM3(DictMonadRec, F, A, B, C)
                  end
              end
          end
      end
  end.

tailRecM3(#{ tailRecM := DictMonadRec }, F, A, B, C) ->
  (DictMonadRec(fun
     (#{ a := O, b := O@1, c := O@2 }) ->
       ((F(O))(O@1))(O@2)
   end))
  (#{ a => A, b => B, c => C }).

untilJust() ->
  fun
    (DictMonadRec) ->
      untilJust(DictMonadRec)
  end.

untilJust(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    #{ map := V } =
      (erlang:map_get(
         'Functor0',
         (erlang:map_get(
            'Apply0',
            (erlang:map_get('Bind1', DictMonadRec(undefined)))(undefined)
          ))
         (undefined)
       ))
      (undefined),
    fun
      (M) ->
        (DictMonadRec@1(fun
           (_) ->
             (V(fun
                (V1) ->
                  case V1 of
                    {nothing} ->
                      {loop, unit};
                    {just, V1@1} ->
                      {done, V1@1};
                    _ ->
                      erlang:error({fail, <<"Failed pattern match">>})
                  end
              end))
             (M)
         end))
        (unit)
    end
  end.

whileJust() ->
  fun
    (DictMonoid) ->
      whileJust(DictMonoid)
  end.

whileJust(DictMonoid = #{ mempty := DictMonoid@1 }) ->
  fun
    (#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
      begin
        #{ map := V } =
          (erlang:map_get(
             'Functor0',
             (erlang:map_get(
                'Apply0',
                (erlang:map_get('Bind1', DictMonadRec(undefined)))(undefined)
              ))
             (undefined)
           ))
          (undefined),
        fun
          (M) ->
            (DictMonadRec@1(fun
               (V@1) ->
                 (V(fun
                    (V1) ->
                      case V1 of
                        {nothing} ->
                          {done, V@1};
                        {just, V1@1} ->
                          begin
                            #{ 'Semigroup0' := DictMonoid@2 } = DictMonoid,
                            { loop
                            , ((erlang:map_get(append, DictMonoid@2(undefined)))
                               (V@1))
                              (V1@1)
                            }
                          end;
                        _ ->
                          erlang:error({fail, <<"Failed pattern match">>})
                      end
                  end))
                 (M)
             end))
            (DictMonoid@1)
        end
      end
  end.

tailRec() ->
  fun
    (F) ->
      tailRec(F)
  end.

tailRec(F) ->
  begin
    Go =
      fun
        Go (V) ->
          case V of
            {loop, V@1} ->
              Go(F(V@1));
            {done, V@2} ->
              V@2;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
      end,
    fun
      (X) ->
        Go(F(X))
    end
  end.

monadRecMaybe() ->
  #{ tailRecM =>
     fun
       (F) ->
         fun
           (A0) ->
             begin
               V =
                 fun
                   (V) ->
                     case V of
                       {nothing} ->
                         {done, {nothing}};
                       {just, V@1} ->
                         case V@1 of
                           {loop, V@2} ->
                             {loop, F(V@2)};
                           {done, V@3} ->
                             {done, {just, V@3}};
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end,
               Go =
                 fun
                   Go (V@1) ->
                     case V@1 of
                       {loop, V@2} ->
                         Go(V(V@2));
                       {done, V@3} ->
                         V@3;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end,
               Go(V(F(A0)))
             end
         end
     end
   , 'Monad0' =>
     fun
       (_) ->
         data_maybe@ps:monadMaybe()
     end
   }.

monadRecIdentity() ->
  #{ tailRecM =>
     fun
       (F) ->
         begin
           Go =
             fun
               Go (V) ->
                 case V of
                   {loop, V@1} ->
                     Go(F(V@1));
                   {done, V@2} ->
                     V@2;
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end,
           fun
             (X) ->
               Go(F(X))
           end
         end
     end
   , 'Monad0' =>
     fun
       (_) ->
         data_identity@ps:monadIdentity()
     end
   }.

monadRecFunction() ->
  #{ tailRecM =>
     fun
       (F) ->
         fun
           (A0) ->
             fun
               (E) ->
                 begin
                   Go =
                     fun
                       Go (V) ->
                         case V of
                           {loop, V@1} ->
                             Go((F(V@1))(E));
                           {done, V@2} ->
                             V@2;
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end
                     end,
                   Go((F(A0))(E))
                 end
             end
         end
     end
   , 'Monad0' =>
     fun
       (_) ->
         control_monad@ps:monadFn()
     end
   }.

monadRecEither() ->
  #{ tailRecM =>
     fun
       (F) ->
         fun
           (A0) ->
             begin
               V =
                 fun
                   (V) ->
                     case V of
                       {left, V@1} ->
                         {done, {left, V@1}};
                       {right, V@2} ->
                         case V@2 of
                           {loop, V@3} ->
                             {loop, F(V@3)};
                           {done, V@4} ->
                             {done, {right, V@4}};
                           _ ->
                             erlang:error({fail, <<"Failed pattern match">>})
                         end;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end,
               Go =
                 fun
                   Go (V@1) ->
                     case V@1 of
                       {loop, V@2} ->
                         Go(V(V@2));
                       {done, V@3} ->
                         V@3;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                 end,
               Go(V(F(A0)))
             end
         end
     end
   , 'Monad0' =>
     fun
       (_) ->
         data_either@ps:monadEither()
     end
   }.

monadRecEffect() ->
  #{ tailRecM =>
     fun
       (F) ->
         fun
           (A) ->
             begin
               V = F(A),
               fun
                 () ->
                   begin
                     V@1 = V(),
                     R = (effect_ref@foreign:new(V@1))(),
                     (effect@foreign:untilE(begin
                        V@2 = effect_ref@foreign:read(R),
                        fun
                          () ->
                            begin
                              V@3 = V@2(),
                              case V@3 of
                                {loop, V@4} ->
                                  fun
                                    () ->
                                      begin
                                        E = (F(V@4))(),
                                        (effect_ref@foreign:write(E, R))(),
                                        false
                                      end
                                  end;
                                {done, _} ->
                                  fun
                                    () ->
                                      true
                                  end;
                                _ ->
                                  erlang:error({ fail
                                               , <<"Failed pattern match">>
                                               })
                              end()
                            end
                        end
                      end))(),
                     A_ = {done, A_@1} = (effect_ref@foreign:read(R))(),
                     case A_ of
                       {done, _} ->
                         A_@1;
                       _ ->
                         erlang:error({fail, <<"Failed pattern match">>})
                     end
                   end
               end
             end
         end
     end
   , 'Monad0' =>
     fun
       (_) ->
         effect@ps:monadEffect()
     end
   }.

functorStep() ->
  #{ map =>
     fun
       (F) ->
         fun
           (M) ->
             case M of
               {loop, M@1} ->
                 {loop, M@1};
               {done, M@2} ->
                 {done, F(M@2)};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   }.

forever() ->
  fun
    (DictMonadRec) ->
      forever(DictMonadRec)
  end.

forever(#{ 'Monad0' := DictMonadRec, tailRecM := DictMonadRec@1 }) ->
  begin
    #{ map := V } =
      (erlang:map_get(
         'Functor0',
         (erlang:map_get(
            'Apply0',
            (erlang:map_get('Bind1', DictMonadRec(undefined)))(undefined)
          ))
         (undefined)
       ))
      (undefined),
    fun
      (Ma) ->
        (DictMonadRec@1(fun
           (U) ->
             (V(fun
                (_) ->
                  {loop, U}
              end))
             (Ma)
         end))
        (unit)
    end
  end.

bifunctorStep() ->
  #{ bimap =>
     fun
       (V) ->
         fun
           (V1) ->
             fun
               (V2) ->
                 case V2 of
                   {loop, V2@1} ->
                     {loop, V(V2@1)};
                   {done, V2@2} ->
                     {done, V1(V2@2)};
                   _ ->
                     erlang:error({fail, <<"Failed pattern match">>})
                 end
             end
         end
     end
   }.

