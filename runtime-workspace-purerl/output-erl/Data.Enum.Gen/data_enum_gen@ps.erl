-module(data_enum_gen@ps).
-export([foldable1NonEmpty/0, genBoundedEnum/0, genBoundedEnum/1]).
-compile(no_auto_import).
foldable1NonEmpty() ->
  data_nonEmpty@ps:foldable1NonEmpty(data_foldable@ps:foldableArray()).

genBoundedEnum() ->
  fun
    (DictMonadGen) ->
      genBoundedEnum(DictMonadGen)
  end.

genBoundedEnum(DictMonadGen) ->
  begin
    Elements =
      (control_monad_gen@ps:elements(DictMonadGen))(foldable1NonEmpty()),
    fun
      (#{ 'Bounded0' := DictBoundedEnum, 'Enum1' := DictBoundedEnum@1 }) ->
        begin
          Enum1 = #{ succ := Enum1@1 } = DictBoundedEnum@1(undefined),
          Bounded0 = #{ bottom := Bounded0@1 } = DictBoundedEnum(undefined),
          V = Enum1@1(Bounded0@1),
          case V of
            {just, V@1} ->
              Elements({ nonEmpty
                       , Bounded0@1
                       , (((data_enum@ps:enumFromTo(Enum1))
                           (data_unfoldable1@ps:unfoldable1Array()))
                          (V@1))
                         (erlang:map_get(top, Bounded0))
                       });
            {nothing} ->
              begin
                #{ 'Monad0' := DictMonadGen@1 } = DictMonadGen,
                (erlang:map_get(
                   pure,
                   (erlang:map_get('Applicative0', DictMonadGen@1(undefined)))
                   (undefined)
                 ))
                (Bounded0@1)
              end;
            _ ->
              erlang:error({fail, <<"Failed pattern match">>})
          end
        end
    end
  end.

