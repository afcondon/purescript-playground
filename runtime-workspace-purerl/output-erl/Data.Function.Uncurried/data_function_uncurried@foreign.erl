-module(data_function_uncurried@foreign).
-export([mkFn0/1,mkFn2/1,mkFn3/1,mkFn4/1,mkFn5/1,mkFn6/1,mkFn7/1,mkFn8/1,mkFn9/1,mkFn10/1,runFn0/1,runFn2/3,runFn3/4,runFn4/5,runFn5/6,runFn6/7,runFn7/8,runFn8/9,runFn9/10,runFn10/11]).

% mkFnX - feeling the paren love

mkFn0(Fun) -> fun () -> Fun(unit) end.

mkFn2(Fun) -> fun (A,B) -> (Fun(A))(B) end.

mkFn3(Fun) -> fun (A,B,C) -> ((Fun(A))(B))(C) end.

mkFn4(Fun) -> fun (A,B,C,D) -> (((Fun(A))(B))(C))(D) end.

mkFn5(Fun) -> fun (A,B,C,D,E) -> ((((Fun(A))(B))(C))(D))(E) end.

mkFn6(Fun) -> fun (A,B,C,D,E,F) -> (((((Fun(A))(B))(C))(D))(E))(F) end.

mkFn7(Fun) -> fun (A,B,C,D,E,F,G) -> ((((((Fun(A))(B))(C))(D))(E))(F))(G) end.

mkFn8(Fun) -> fun (A,B,C,D,E,F,G,H) -> (((((((Fun(A))(B))(C))(D))(E))(F))(G))(H) end.

mkFn9(Fun) -> fun (A,B,C,D,E,F,G,H,I) -> ((((((((Fun(A))(B))(C))(D))(E))(F))(G))(H))(I) end.

mkFn10(Fun) -> fun (A,B,C,D,E,F,G,H,I,J) -> (((((((((Fun(A))(B))(C))(D))(E))(F))(G))(H))(I))(J) end.

% runFnX - making heavy use of auto-currying

runFn0(Fun) -> Fun().

runFn2(Fun,A,B) -> Fun(A,B).

runFn3(Fun,A,B,C) -> Fun(A,B,C).

runFn4(Fun,A,B,C,D) -> Fun(A,B,C,D).

runFn5(Fun,A,B,C,D,E) -> Fun(A,B,C,D,E).

runFn6(Fun,A,B,C,D,E,F) -> Fun(A,B,C,D,E,F).

runFn7(Fun,A,B,C,D,E,F,G) -> Fun(A,B,C,D,E,F,G).

runFn8(Fun,A,B,C,D,E,F,G,H) -> Fun(A,B,C,D,E,F,G,H).

runFn9(Fun,A,B,C,D,E,F,G,H,I) -> Fun(A,B,C,D,E,F,G,H,I).

runFn10(Fun,A,B,C,D,E,F,G,H,I,J) -> Fun(A,B,C,D,E,F,G,H,I,J).
