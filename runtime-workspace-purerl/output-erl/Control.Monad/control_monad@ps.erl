-module(control_monad@ps).
-export([ whenM/0
        , whenM/1
        , unlessM/0
        , unlessM/1
        , monadProxy/0
        , monadFn/0
        , monadArray/0
        , liftM1/0
        , liftM1/3
        , ap/0
        , ap/1
        ]).
-compile(no_auto_import).
whenM() ->
  fun
    (DictMonad) ->
      whenM(DictMonad)
  end.

whenM(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
  begin
    V = DictMonad(undefined),
    fun
      (Mb) ->
        fun
          (M) ->
            ((erlang:map_get(bind, DictMonad@1(undefined)))(Mb))
            (fun
              (B) ->
                if
                  B ->
                    M;
                  true ->
                    begin
                      #{ pure := V@1 } = V,
                      V@1(unit)
                    end
                end
            end)
        end
    end
  end.

unlessM() ->
  fun
    (DictMonad) ->
      unlessM(DictMonad)
  end.

unlessM(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
  begin
    V = DictMonad(undefined),
    fun
      (Mb) ->
        fun
          (M) ->
            ((erlang:map_get(bind, DictMonad@1(undefined)))(Mb))
            (fun
              (B) ->
                if
                  not B ->
                    M;
                  B ->
                    begin
                      #{ pure := V@1 } = V,
                      V@1(unit)
                    end;
                  true ->
                    erlang:error({fail, <<"Failed pattern match">>})
                end
            end)
        end
    end
  end.

monadProxy() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         control_applicative@ps:applicativeProxy()
     end
   , 'Bind1' =>
     fun
       (_) ->
         control_bind@ps:bindProxy()
     end
   }.

monadFn() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         control_applicative@ps:applicativeFn()
     end
   , 'Bind1' =>
     fun
       (_) ->
         control_bind@ps:bindFn()
     end
   }.

monadArray() ->
  #{ 'Applicative0' =>
     fun
       (_) ->
         control_applicative@ps:applicativeArray()
     end
   , 'Bind1' =>
     fun
       (_) ->
         control_bind@ps:bindArray()
     end
   }.

liftM1() ->
  fun
    (DictMonad) ->
      fun
        (F) ->
          fun
            (A) ->
              liftM1(DictMonad, F, A)
          end
      end
  end.

liftM1(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }, F, A) ->
  ((erlang:map_get(bind, DictMonad@1(undefined)))(A))
  (fun
    (A_) ->
      (erlang:map_get(pure, DictMonad(undefined)))(F(A_))
  end).

ap() ->
  fun
    (DictMonad) ->
      ap(DictMonad)
  end.

ap(#{ 'Applicative0' := DictMonad, 'Bind1' := DictMonad@1 }) ->
  begin
    #{ bind := V } = DictMonad@1(undefined),
    fun
      (F) ->
        fun
          (A) ->
            (V(F))
            (fun
              (F_) ->
                (V(A))
                (fun
                  (A_) ->
                    (erlang:map_get(pure, DictMonad(undefined)))(F_(A_))
                end)
            end)
        end
    end
  end.

