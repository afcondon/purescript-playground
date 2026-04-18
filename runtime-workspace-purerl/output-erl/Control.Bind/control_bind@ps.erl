-module(control_bind@ps).
-export([ identity/0
        , identity/1
        , discard/0
        , discard/1
        , bindProxy/0
        , bindFn/0
        , bindArray/0
        , bind/0
        , bind/1
        , bindFlipped/0
        , bindFlipped/3
        , composeKleisliFlipped/0
        , composeKleisliFlipped/4
        , composeKleisli/0
        , composeKleisli/4
        , discardProxy/0
        , discardProxy2/0
        , discardProxy3/0
        , discardUnit/0
        , ifM/0
        , ifM/4
        , join/0
        , join/2
        , arrayBind/0
        ]).
-compile(no_auto_import).
identity() ->
  fun
    (X) ->
      identity(X)
  end.

identity(X) ->
  X.

discard() ->
  fun
    (Dict) ->
      discard(Dict)
  end.

discard(#{ discard := Dict }) ->
  Dict.

bindProxy() ->
  #{ bind =>
     fun
       (_) ->
         fun
           (_) ->
             {proxy}
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         control_apply@ps:applyProxy()
     end
   }.

bindFn() ->
  #{ bind =>
     fun
       (M) ->
         fun
           (F) ->
             fun
               (X) ->
                 (F(M(X)))(X)
             end
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         control_apply@ps:applyFn()
     end
   }.

bindArray() ->
  #{ bind => arrayBind()
   , 'Apply0' =>
     fun
       (_) ->
         control_apply@ps:applyArray()
     end
   }.

bind() ->
  fun
    (Dict) ->
      bind(Dict)
  end.

bind(#{ bind := Dict }) ->
  Dict.

bindFlipped() ->
  fun
    (DictBind) ->
      fun
        (B) ->
          fun
            (A) ->
              bindFlipped(DictBind, B, A)
          end
      end
  end.

bindFlipped(#{ bind := DictBind }, B, A) ->
  (DictBind(A))(B).

composeKleisliFlipped() ->
  fun
    (DictBind) ->
      fun
        (F) ->
          fun
            (G) ->
              fun
                (A) ->
                  composeKleisliFlipped(DictBind, F, G, A)
              end
          end
      end
  end.

composeKleisliFlipped(#{ bind := DictBind }, F, G, A) ->
  (DictBind(G(A)))(F).

composeKleisli() ->
  fun
    (DictBind) ->
      fun
        (F) ->
          fun
            (G) ->
              fun
                (A) ->
                  composeKleisli(DictBind, F, G, A)
              end
          end
      end
  end.

composeKleisli(#{ bind := DictBind }, F, G, A) ->
  (DictBind(F(A)))(G).

discardProxy() ->
  #{ discard =>
     fun
       (#{ bind := DictBind }) ->
         DictBind
     end
   }.

discardProxy2() ->
  #{ discard =>
     fun
       (#{ bind := DictBind }) ->
         DictBind
     end
   }.

discardProxy3() ->
  #{ discard =>
     fun
       (#{ bind := DictBind }) ->
         DictBind
     end
   }.

discardUnit() ->
  #{ discard =>
     fun
       (#{ bind := DictBind }) ->
         DictBind
     end
   }.

ifM() ->
  fun
    (DictBind) ->
      fun
        (Cond) ->
          fun
            (T) ->
              fun
                (F) ->
                  ifM(DictBind, Cond, T, F)
              end
          end
      end
  end.

ifM(#{ bind := DictBind }, Cond, T, F) ->
  (DictBind(Cond))
  (fun
    (Cond_) ->
      if
        Cond_ ->
          T;
        true ->
          F
      end
  end).

join() ->
  fun
    (DictBind) ->
      fun
        (M) ->
          join(DictBind, M)
      end
  end.

join(#{ bind := DictBind }, M) ->
  (DictBind(M))(identity()).

arrayBind() ->
  fun
    (V) ->
      fun
        (V@1) ->
          control_bind@foreign:arrayBind(V, V@1)
      end
  end.

