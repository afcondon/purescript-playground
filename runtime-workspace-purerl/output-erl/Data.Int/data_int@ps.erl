-module(data_int@ps).
-export([ 'Even'/0
        , 'Odd'/0
        , showParity/0
        , radix/0
        , radix/1
        , odd/0
        , odd/1
        , octal/0
        , hexadecimal/0
        , fromStringAs/0
        , fromString/0
        , fromNumber/0
        , round/0
        , round/1
        , floor/0
        , floor/1
        , even/0
        , even/1
        , parity/0
        , parity/1
        , eqParity/0
        , ordParity/0
        , semiringParity/0
        , ringParity/0
        , divisionRingParity/0
        , decimal/0
        , commutativeRingParity/0
        , euclideanRingParity/0
        , ceil/0
        , ceil/1
        , boundedParity/0
        , binary/0
        , base36/0
        , fromNumberImpl/0
        , toNumber/0
        , fromStringAsImpl/0
        , toStringAs/0
        , pow/0
        , quot/0
        , 'rem'/0
        , fromStringAs/2
        , fromNumber/1
        , fromString/1
        ]).
-compile(no_auto_import).
-define( IS_KNOWN_TAG(Tag, Arity, V)
       , ((erlang:is_tuple(V))
         andalso (((Arity + 1) =:= (erlang:tuple_size(V)))
           andalso (Tag =:= (erlang:element(1, V)))))
       ).
'Even'() ->
  {even}.

'Odd'() ->
  {odd}.

showParity() ->
  #{ show =>
     fun
       (V) ->
         case V of
           {even} ->
             <<"Even">>;
           {odd} ->
             <<"Odd">>;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   }.

radix() ->
  fun
    (N) ->
      radix(N)
  end.

radix(N) ->
  if
    (N >= 2) andalso (N =< 36) ->
      {just, N};
    true ->
      {nothing}
  end.

odd() ->
  fun
    (X) ->
      odd(X)
  end.

odd(X) ->
  (X band 1) =/= 0.

octal() ->
  8.

hexadecimal() ->
  16.

fromStringAs() ->
  ((fromStringAsImpl())(data_maybe@ps:'Just'()))({nothing}).

fromString() ->
  (fromStringAs())(10).

fromNumber() ->
  ((fromNumberImpl())(data_maybe@ps:'Just'()))({nothing}).

round() ->
  fun
    (X) ->
      round(X)
  end.

round(X) ->
  begin
    V = fromNumber(math@foreign:round(X)),
    case V of
      {nothing} ->
        0;
      {just, V@1} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

floor() ->
  fun
    (X) ->
      floor(X)
  end.

floor(X) ->
  begin
    V = fromNumber(math@foreign:floor(X)),
    case V of
      {nothing} ->
        0;
      {just, V@1} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

even() ->
  fun
    (X) ->
      even(X)
  end.

even(X) ->
  (X band 1) =:= 0.

parity() ->
  fun
    (N) ->
      parity(N)
  end.

parity(N) ->
  if
    (N band 1) =:= 0 ->
      {even};
    true ->
      {odd}
  end.

eqParity() ->
  #{ eq =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {even} ->
                 ?IS_KNOWN_TAG(even, 0, Y);
               _ ->
                 ?IS_KNOWN_TAG(odd, 0, X) andalso ?IS_KNOWN_TAG(odd, 0, Y)
             end
         end
     end
   }.

ordParity() ->
  #{ compare =>
     fun
       (X) ->
         fun
           (Y) ->
             case X of
               {even} ->
                 case Y of
                   {even} ->
                     {eQ};
                   _ ->
                     {lT}
                 end;
               _ ->
                 case Y of
                   {even} ->
                     {gT};
                   _ ->
                     if
                       ?IS_KNOWN_TAG(odd, 0, X) andalso ?IS_KNOWN_TAG(odd, 0, Y) ->
                         {eQ};
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
         eqParity()
     end
   }.

semiringParity() ->
  #{ zero => {even}
   , add =>
     fun
       (X) ->
         fun
           (Y) ->
             case case X of
                 {even} ->
                   ?IS_KNOWN_TAG(even, 0, Y);
                 _ ->
                   ?IS_KNOWN_TAG(odd, 0, X) andalso ?IS_KNOWN_TAG(odd, 0, Y)
               end of
               true ->
                 {even};
               _ ->
                 {odd}
             end
         end
     end
   , one => {odd}
   , mul =>
     fun
       (V) ->
         fun
           (V1) ->
             if
               ?IS_KNOWN_TAG(odd, 0, V) andalso ?IS_KNOWN_TAG(odd, 0, V1) ->
                 {odd};
               true ->
                 {even}
             end
         end
     end
   }.

ringParity() ->
  #{ sub => erlang:map_get(add, semiringParity())
   , 'Semiring0' =>
     fun
       (_) ->
         semiringParity()
     end
   }.

divisionRingParity() ->
  #{ recip =>
     fun
       (X) ->
         X
     end
   , 'Ring0' =>
     fun
       (_) ->
         ringParity()
     end
   }.

decimal() ->
  10.

commutativeRingParity() ->
  #{ 'Ring0' =>
     fun
       (_) ->
         ringParity()
     end
   }.

euclideanRingParity() ->
  #{ degree =>
     fun
       (V) ->
         case V of
           {even} ->
             0;
           {odd} ->
             1;
           _ ->
             erlang:error({fail, <<"Failed pattern match">>})
         end
     end
   , 'div' =>
     fun
       (X) ->
         fun
           (_) ->
             X
         end
     end
   , mod =>
     fun
       (_) ->
         fun
           (_) ->
             {even}
         end
     end
   , 'CommutativeRing0' =>
     fun
       (_) ->
         commutativeRingParity()
     end
   }.

ceil() ->
  fun
    (X) ->
      ceil(X)
  end.

ceil(X) ->
  begin
    V = fromNumber(math@foreign:ceil(X)),
    case V of
      {nothing} ->
        0;
      {just, V@1} ->
        V@1;
      _ ->
        erlang:error({fail, <<"Failed pattern match">>})
    end
  end.

boundedParity() ->
  #{ bottom => {even}
   , top => {odd}
   , 'Ord0' =>
     fun
       (_) ->
         ordParity()
     end
   }.

binary() ->
  2.

base36() ->
  36.

fromNumberImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              data_int@foreign:fromNumberImpl(V, V@1, V@2)
          end
      end
  end.

toNumber() ->
  fun
    (V) ->
      data_int@foreign:toNumber(V)
  end.

fromStringAsImpl() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  data_int@foreign:fromStringAsImpl(V, V@1, V@2, V@3)
              end
          end
      end
  end.

toStringAs() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_int@foreign:toStringAs(V, V@1)
      end
  end.

pow() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_int@foreign:pow(V, V@1)
      end
  end.

quot() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_int@foreign:quot(V, V@1)
      end
  end.

'rem'() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_int@foreign:'rem'(V, V@1)
      end
  end.

fromStringAs(V, V@1) ->
  data_int@foreign:fromStringAsImpl(data_maybe@ps:'Just'(), {nothing}, V, V@1).

fromNumber(V) ->
  data_int@foreign:fromNumberImpl(data_maybe@ps:'Just'(), {nothing}, V).

fromString(V) ->
  fromStringAs(10, V).

