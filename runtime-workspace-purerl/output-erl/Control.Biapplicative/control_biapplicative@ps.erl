-module(control_biapplicative@ps).
-export([bipure/0, bipure/1, biapplicativeTuple/0]).
-compile(no_auto_import).
bipure() ->
  fun
    (Dict) ->
      bipure(Dict)
  end.

bipure(#{ bipure := Dict }) ->
  Dict.

biapplicativeTuple() ->
  #{ bipure => data_tuple@ps:'Tuple'()
   , 'Biapply0' =>
     fun
       (_) ->
         control_biapply@ps:biapplyTuple()
     end
   }.

