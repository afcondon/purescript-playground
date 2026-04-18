-module(control_monad_error_class@ps).
-export([ throwError/0
        , throwError/1
        , monadThrowMaybe/0
        , monadThrowEither/0
        , monadThrowEffect/0
        , monadErrorMaybe/0
        , monadErrorEither/0
        , monadErrorEffect/0
        , liftMaybe/0
        , liftMaybe/1
        , liftEither/0
        , liftEither/1
        , catchError/0
        , catchError/1
        , catchJust/0
        , catchJust/4
        , 'try'/0
        , 'try'/1
        , withResource/0
        , withResource/1
        ]).
-compile(no_auto_import).
throwError() ->
  fun
    (Dict) ->
      throwError(Dict)
  end.

throwError(#{ throwError := Dict }) ->
  Dict.

monadThrowMaybe() ->
  #{ throwError =>
     fun
       (_) ->
         {nothing}
     end
   , 'Monad0' =>
     fun
       (_) ->
         data_maybe@ps:monadMaybe()
     end
   }.

monadThrowEither() ->
  #{ throwError => data_either@ps:'Left'()
   , 'Monad0' =>
     fun
       (_) ->
         data_either@ps:monadEither()
     end
   }.

monadThrowEffect() ->
  #{ throwError => effect_exception@ps:throwException()
   , 'Monad0' =>
     fun
       (_) ->
         effect@ps:monadEffect()
     end
   }.

monadErrorMaybe() ->
  #{ catchError =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {nothing} ->
                 V1(unit);
               {just, V@1} ->
                 {just, V@1};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'MonadThrow0' =>
     fun
       (_) ->
         monadThrowMaybe()
     end
   }.

monadErrorEither() ->
  #{ catchError =>
     fun
       (V) ->
         fun
           (V1) ->
             case V of
               {left, V@1} ->
                 V1(V@1);
               {right, V@2} ->
                 {right, V@2};
               _ ->
                 erlang:error({fail, <<"Failed pattern match">>})
             end
         end
     end
   , 'MonadThrow0' =>
     fun
       (_) ->
         monadThrowEither()
     end
   }.

monadErrorEffect() ->
  #{ catchError =>
     fun
       (B) ->
         fun
           (A) ->
             effect_exception@foreign:catchException(A, B)
         end
     end
   , 'MonadThrow0' =>
     fun
       (_) ->
         monadThrowEffect()
     end
   }.

liftMaybe() ->
  fun
    (DictMonadThrow) ->
      liftMaybe(DictMonadThrow)
  end.

liftMaybe(#{ 'Monad0' := DictMonadThrow, throwError := DictMonadThrow@1 }) ->
  begin
    Pure =
      erlang:map_get(
        pure,
        (erlang:map_get('Applicative0', DictMonadThrow(undefined)))(undefined)
      ),
    fun
      (Error) ->
        begin
          V = DictMonadThrow@1(Error),
          fun
            (V2) ->
              case V2 of
                {nothing} ->
                  V;
                {just, V2@1} ->
                  Pure(V2@1);
                _ ->
                  erlang:error({fail, <<"Failed pattern match">>})
              end
          end
        end
    end
  end.

liftEither() ->
  fun
    (DictMonadThrow) ->
      liftEither(DictMonadThrow)
  end.

liftEither(DictMonadThrow = #{ 'Monad0' := DictMonadThrow@1 }) ->
  begin
    V =
      erlang:map_get(
        pure,
        (erlang:map_get('Applicative0', DictMonadThrow@1(undefined)))(undefined)
      ),
    fun
      (V2) ->
        case V2 of
          {left, V2@1} ->
            begin
              #{ throwError := DictMonadThrow@2 } = DictMonadThrow,
              DictMonadThrow@2(V2@1)
            end;
          {right, V2@2} ->
            V(V2@2);
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
    end
  end.

catchError() ->
  fun
    (Dict) ->
      catchError(Dict)
  end.

catchError(#{ catchError := Dict }) ->
  Dict.

catchJust() ->
  fun
    (DictMonadError) ->
      fun
        (P) ->
          fun
            (Act) ->
              fun
                (Handler) ->
                  catchJust(DictMonadError, P, Act, Handler)
              end
          end
      end
  end.

catchJust(DictMonadError = #{ catchError := DictMonadError@1 }, P, Act, Handler) ->
  (DictMonadError@1(Act))
  (fun
    (E) ->
      begin
        V = P(E),
        case V of
          {nothing} ->
            begin
              #{ 'MonadThrow0' := DictMonadError@2 } = DictMonadError,
              (erlang:map_get(throwError, DictMonadError@2(undefined)))(E)
            end;
          {just, V@1} ->
            Handler(V@1);
          _ ->
            erlang:error({fail, <<"Failed pattern match">>})
        end
      end
  end).

'try'() ->
  fun
    (DictMonadError) ->
      'try'(DictMonadError)
  end.

'try'(#{ 'MonadThrow0' := DictMonadError, catchError := DictMonadError@1 }) ->
  begin
    #{ 'Applicative0' := Monad0, 'Bind1' := Monad0@1 } =
      (erlang:map_get('Monad0', DictMonadError(undefined)))(undefined),
    fun
      (A) ->
        (DictMonadError@1(((erlang:map_get(
                              map,
                              (erlang:map_get(
                                 'Functor0',
                                 (erlang:map_get('Apply0', Monad0@1(undefined)))
                                 (undefined)
                               ))
                              (undefined)
                            ))
                           (data_either@ps:'Right'()))
                          (A)))
        (fun
          (X) ->
            (erlang:map_get(pure, Monad0(undefined)))({left, X})
        end)
    end
  end.

withResource() ->
  fun
    (DictMonadError) ->
      withResource(DictMonadError)
  end.

withResource(DictMonadError = #{ 'MonadThrow0' := DictMonadError@1 }) ->
  begin
    MonadThrow0 = #{ 'Monad0' := MonadThrow0@1 } = DictMonadError@1(undefined),
    Monad0 = #{ 'Bind1' := Monad0@1 } = MonadThrow0@1(undefined),
    #{ bind := Bind1 } = Monad0@1(undefined),
    Try1 = 'try'(DictMonadError),
    fun
      (Acquire) ->
        fun
          (Release) ->
            fun
              (Kleisli) ->
                (Bind1(Acquire))
                (fun
                  (Resource) ->
                    (Bind1(Try1(Kleisli(Resource))))
                    (fun
                      (Result) ->
                        (Bind1(Release(Resource)))
                        (fun
                          (_) ->
                            case Result of
                              {left, Result@1} ->
                                begin
                                  #{ throwError := MonadThrow0@2 } = MonadThrow0,
                                  MonadThrow0@2(Result@1)
                                end;
                              {right, Result@2} ->
                                begin
                                  #{ 'Applicative0' := Monad0@2 } = Monad0,
                                  (erlang:map_get(pure, Monad0@2(undefined)))
                                  (Result@2)
                                end;
                              _ ->
                                erlang:error({fail, <<"Failed pattern match">>})
                            end
                        end)
                    end)
                end)
            end
        end
    end
  end.

