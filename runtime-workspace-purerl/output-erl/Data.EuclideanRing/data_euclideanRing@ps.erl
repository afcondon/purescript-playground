-module(data_euclideanRing@ps).
-export([ mod/0
        , mod/1
        , gcd/0
        , gcd/2
        , euclideanRingNumber/0
        , euclideanRingInt/0
        , 'div'/0
        , 'div'/1
        , lcm/0
        , lcm/2
        , degree/0
        , degree/1
        , intDegree/0
        , intDiv/0
        , intMod/0
        , numDiv/0
        ]).
-compile(no_auto_import).
mod() ->
  fun
    (Dict) ->
      mod(Dict)
  end.

mod(#{ mod := Dict }) ->
  Dict.

gcd() ->
  fun
    (DictEq) ->
      fun
        (DictEuclideanRing) ->
          gcd(DictEq, DictEuclideanRing)
      end
  end.

gcd( DictEq = #{ eq := DictEq@1 }
   , DictEuclideanRing = #{ 'CommutativeRing0' := DictEuclideanRing@1 }
   ) ->
  begin
    Zero =
      erlang:map_get(
        zero,
        (erlang:map_get(
           'Semiring0',
           (erlang:map_get('Ring0', DictEuclideanRing@1(undefined)))(undefined)
         ))
        (undefined)
      ),
    fun
      (A) ->
        fun
          (B) ->
            case (DictEq@1(B))(Zero) of
              true ->
                A;
              _ ->
                begin
                  #{ mod := DictEuclideanRing@2 } = DictEuclideanRing,
                  ((gcd(DictEq, DictEuclideanRing))(B))
                  ((DictEuclideanRing@2(A))(B))
                end
            end
        end
    end
  end.

euclideanRingNumber() ->
  #{ degree =>
     fun
       (_) ->
         1
     end
   , 'div' => numDiv()
   , mod =>
     fun
       (_) ->
         fun
           (_) ->
             0.0
         end
     end
   , 'CommutativeRing0' =>
     fun
       (_) ->
         data_commutativeRing@ps:commutativeRingNumber()
     end
   }.

euclideanRingInt() ->
  #{ degree => intDegree()
   , 'div' => intDiv()
   , mod => intMod()
   , 'CommutativeRing0' =>
     fun
       (_) ->
         data_commutativeRing@ps:commutativeRingInt()
     end
   }.

'div'() ->
  fun
    (Dict) ->
      'div'(Dict)
  end.

'div'(#{ 'div' := Dict }) ->
  Dict.

lcm() ->
  fun
    (DictEq) ->
      fun
        (DictEuclideanRing) ->
          lcm(DictEq, DictEuclideanRing)
      end
  end.

lcm( DictEq = #{ eq := DictEq@1 }
   , DictEuclideanRing = #{ 'CommutativeRing0' := DictEuclideanRing@1 }
   ) ->
  begin
    Semiring0 = #{ zero := Semiring0@1 } =
      (erlang:map_get(
         'Semiring0',
         (erlang:map_get('Ring0', DictEuclideanRing@1(undefined)))(undefined)
       ))
      (undefined),
    Gcd2 = gcd(DictEq, DictEuclideanRing),
    fun
      (A) ->
        fun
          (B) ->
            case ((DictEq@1(A))(Semiring0@1))
                orelse ((DictEq@1(B))(Semiring0@1)) of
              true ->
                Semiring0@1;
              _ ->
                begin
                  #{ mul := Semiring0@2 } = Semiring0,
                  #{ 'div' := DictEuclideanRing@2 } = DictEuclideanRing,
                  (DictEuclideanRing@2((Semiring0@2(A))(B)))((Gcd2(A))(B))
                end
            end
        end
    end
  end.

degree() ->
  fun
    (Dict) ->
      degree(Dict)
  end.

degree(#{ degree := Dict }) ->
  Dict.

intDegree() ->
  fun
    (V) ->
      data_euclideanRing@foreign:intDegree(V)
  end.

intDiv() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_euclideanRing@foreign:intDiv(V, V@1)
      end
  end.

intMod() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_euclideanRing@foreign:intMod(V, V@1)
      end
  end.

numDiv() ->
  fun
    (V) ->
      fun
        (V@1) ->
          data_euclideanRing@foreign:numDiv(V, V@1)
      end
  end.

