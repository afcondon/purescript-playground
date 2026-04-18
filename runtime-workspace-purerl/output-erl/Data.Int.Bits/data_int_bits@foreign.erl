% module Data.Int.Bits
-module(data_int_bits@foreign).
-export(['and'/1, 'or'/1, 'xor'/1, shl/1, shr/1, zshr/1, complement/1]).

'and'(N1) -> fun (N2) -> N1 band N2 end.

'or'(N1) -> fun (N2) -> N1 bor N2 end.

'xor'(N1) -> fun (N2) -> N1 bxor N2 end.

shl(N1) -> fun (N2) -> N1 bsl N2 end.

shr(N1) -> fun (N2) -> N1 bsr N2 end.

% TODO?
zshr(N1) -> fun (N2) -> N1 bsr N2 end.

complement(N) -> bnot(N).
