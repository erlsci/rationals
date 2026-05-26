-module(prop_rationals).
-include_lib("proper/include/proper.hrl").

-export([
    prop_normalize_idempotent/0,
    prop_normalize_denominator_positive/0,
    prop_normalize_reduced/0,
    prop_normalize_value_preserved/0,
    prop_compare_sign_invariant/0,
    prop_compare_antisymmetric/0,
    prop_zero_identity/0,
    prop_one_identity/0
]).

%%% Generators

non_zero_integer() ->
    ?SUCHTHAT(D, integer(), D =/= 0).

fraction() ->
    ?LET({N, D}, {integer(), non_zero_integer()}, rationals:new(N, D)).

%%% Properties

prop_normalize_idempotent() ->
    ?FORALL(
        F,
        fraction(),
        rationals:normalize(rationals:normalize(F)) =:=
            rationals:normalize(F)
    ).

prop_normalize_denominator_positive() ->
    ?FORALL(
        F,
        fraction(),
        rationals:denominator(rationals:normalize(F)) > 0
    ).

prop_normalize_reduced() ->
    ?FORALL(
        F,
        fraction(),
        begin
            N = rationals:normalize(F),
            Num = erlang:abs(rationals:numerator(N)),
            Den = rationals:denominator(N),
            rationals:gcd(Num, Den) =:= 1 orelse
                (Num =:= 0 andalso Den =:= 1)
        end
    ).

prop_normalize_value_preserved() ->
    ?FORALL(
        F,
        fraction(),
        rationals:compare(F, rationals:normalize(F)) =:= eq
    ).

prop_compare_sign_invariant() ->
    ?FORALL(
        {N, D},
        {integer(), non_zero_integer()},
        rationals:compare(rationals:new(N, D), rationals:new(-N, -D)) =:=
            eq
    ).

prop_compare_antisymmetric() ->
    ?FORALL(
        {F1, F2},
        {fraction(), fraction()},
        begin
            C1 = rationals:compare(F1, F2),
            C2 = rationals:compare(F2, F1),
            Self = rationals:compare(F1, F1),
            (Self =:= eq) andalso
                case C1 of
                    gt -> C2 =:= lt;
                    lt -> C2 =:= gt;
                    eq -> C2 =:= eq
                end
        end
    ).

prop_zero_identity() ->
    ?FORALL(
        F,
        fraction(),
        rationals:compare(rationals:add(F, rationals:zero()), F) =:=
            eq
    ).

prop_one_identity() ->
    ?FORALL(
        F,
        fraction(),
        rationals:compare(rationals:multiply(F, rationals:one()), F) =:=
            eq
    ).
