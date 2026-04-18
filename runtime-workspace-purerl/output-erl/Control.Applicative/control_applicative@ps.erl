-module(control_applicative@ps).
-export([ pure/0
        , pure/1
        , unless/0
        , unless/3
        , 'when'/0
        , 'when'/3
        , liftA1/0
        , liftA1/3
        , applicativeProxy/0
        , applicativeFn/0
        , applicativeArray/0
        ]).
-compile(no_auto_import).
pure() ->
  fun
    (Dict) ->
      pure(Dict)
  end.

pure(#{ pure := Dict }) ->
  Dict.

unless() ->
  fun
    (DictApplicative) ->
      fun
        (V) ->
          fun
            (V1) ->
              unless(DictApplicative, V, V1)
          end
      end
  end.

unless(DictApplicative, V, V1) ->
  if
    not V ->
      V1;
    V ->
      begin
        #{ pure := DictApplicative@1 } = DictApplicative,
        DictApplicative@1(unit)
      end;
    true ->
      erlang:error({fail, <<"Failed pattern match">>})
  end.

'when'() ->
  fun
    (DictApplicative) ->
      fun
        (V) ->
          fun
            (V1) ->
              'when'(DictApplicative, V, V1)
          end
      end
  end.

'when'(DictApplicative, V, V1) ->
  if
    V ->
      V1;
    true ->
      begin
        #{ pure := DictApplicative@1 } = DictApplicative,
        DictApplicative@1(unit)
      end
  end.

liftA1() ->
  fun
    (DictApplicative) ->
      fun
        (F) ->
          fun
            (A) ->
              liftA1(DictApplicative, F, A)
          end
      end
  end.

liftA1(#{ 'Apply0' := DictApplicative, pure := DictApplicative@1 }, F, A) ->
  ((erlang:map_get(apply, DictApplicative(undefined)))(DictApplicative@1(F)))(A).

applicativeProxy() ->
  #{ pure =>
     fun
       (_) ->
         {proxy}
     end
   , 'Apply0' =>
     fun
       (_) ->
         control_apply@ps:applyProxy()
     end
   }.

applicativeFn() ->
  #{ pure =>
     fun
       (X) ->
         fun
           (_) ->
             X
         end
     end
   , 'Apply0' =>
     fun
       (_) ->
         control_apply@ps:applyFn()
     end
   }.

applicativeArray() ->
  #{ pure =>
     fun
       (X) ->
         array:from_list([X])
     end
   , 'Apply0' =>
     fun
       (_) ->
         control_apply@ps:applyArray()
     end
   }.

