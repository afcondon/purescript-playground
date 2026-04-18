-module(data_functor_coproduct_inject@ps).
-export([ prj/0
        , prj/1
        , injectReflexive/0
        , injectLeft/0
        , inj/0
        , inj/1
        , injectRight/0
        , injectRight/1
        ]).
-compile(no_auto_import).
prj() ->
  fun
    (Dict) ->
      prj(Dict)
  end.

prj(#{ prj := Dict }) ->
  Dict.

injectReflexive() ->
  #{ inj =>
     fun
       (X) ->
         X
     end
   , prj => data_maybe@ps:'Just'()
   }.

injectLeft() ->
  #{ inj =>
     fun
       (X) ->
         {left, X}
     end
   , prj =>
     fun
       (V2) ->
         case V2 of
           {left, V2@1} ->
             {just, V2@1};
           {right, _} ->
             {nothing};
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

inj() ->
  fun
    (Dict) ->
      inj(Dict)
  end.

inj(#{ inj := Dict }) ->
  Dict.

injectRight() ->
  fun
    (DictInject) ->
      injectRight(DictInject)
  end.

injectRight(DictInject = #{ inj := DictInject@1 }) ->
  #{ inj =>
     fun
       (X) ->
         {right, DictInject@1(X)}
     end
   , prj =>
     fun
       (V2) ->
         case V2 of
           {left, _} ->
             {nothing};
           {right, V2@1} ->
             begin
               #{ prj := DictInject@2 } = DictInject,
               DictInject@2(V2@1)
             end;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

