-module(data_newtype@ps).
-export([ wrap/0
        , wrap/1
        , unwrap/0
        , unwrap/1
        , underF2/0
        , underF2/5
        , underF/0
        , underF/5
        , under2/0
        , under2/3
        , under/0
        , under/3
        , un/0
        , un/2
        , traverse/0
        , traverse/3
        , overF2/0
        , overF2/5
        , overF/0
        , overF/5
        , over2/0
        , over2/3
        , over/0
        , over/3
        , newtypeMultiplicative/0
        , newtypeLast/0
        , newtypeFirst/0
        , newtypeEndo/0
        , newtypeDual/0
        , newtypeDisj/0
        , newtypeConj/0
        , newtypeAdditive/0
        , collect/0
        , collect/3
        , alaF/0
        , alaF/5
        , ala/0
        , ala/5
        ]).
-compile(no_auto_import).
wrap() ->
  fun
    (V) ->
      wrap(V)
  end.

wrap(_) ->
  unsafe_coerce@ps:unsafeCoerce().

unwrap() ->
  fun
    (V) ->
      unwrap(V)
  end.

unwrap(_) ->
  unsafe_coerce@ps:unsafeCoerce().

underF2() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      underF2(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

underF2(_, _, _, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

underF() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      underF(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

underF(_, _, _, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

under2() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              under2(V, V@1, V@2)
          end
      end
  end.

under2(_, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

under() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              under(V, V@1, V@2)
          end
      end
  end.

under(_, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

un() ->
  fun
    (V) ->
      fun
        (V@1) ->
          un(V, V@1)
      end
  end.

un(_, _) ->
  unsafe_coerce@ps:unsafeCoerce().

traverse() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              traverse(V, V@1, V@2)
          end
      end
  end.

traverse(_, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

overF2() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      overF2(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

overF2(_, _, _, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

overF() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      overF(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

overF(_, _, _, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

over2() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              over2(V, V@1, V@2)
          end
      end
  end.

over2(_, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

over() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              over(V, V@1, V@2)
          end
      end
  end.

over(_, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

newtypeMultiplicative() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeLast() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeFirst() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeEndo() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeDual() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeDisj() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeConj() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

newtypeAdditive() ->
  #{ 'Coercible0' =>
     fun
       (_) ->
         undefined
     end
   }.

collect() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              collect(V, V@1, V@2)
          end
      end
  end.

collect(_, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

alaF() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (V@4) ->
                      alaF(V, V@1, V@2, V@3, V@4)
                  end
              end
          end
      end
  end.

alaF(_, _, _, _, _) ->
  unsafe_coerce@ps:unsafeCoerce().

ala() ->
  fun
    (V) ->
      fun
        (V@1) ->
          fun
            (V@2) ->
              fun
                (V@3) ->
                  fun
                    (F) ->
                      ala(V, V@1, V@2, V@3, F)
                  end
              end
          end
      end
  end.

ala(_, _, _, _, F) ->
  F(unsafe_coerce@ps:unsafeCoerce()).

