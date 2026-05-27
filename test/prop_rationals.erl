-module(prop_rationals).
-include_lib("proper/include/proper.hrl").

-export([
    prop_normalize_idempotent/0,
    prop_normalize_denominator_positive/0,
    prop_normalize_reduced/0,
    prop_normalize_value_preserved/0,
    prop_compare_matches_oracle/0,
    prop_compare_antisymmetric/0,
    prop_compare_sign_regression/0,
    prop_zero_identity/0,
    prop_one_identity/0
]).

%%% Generators

non_zero_integer() ->
    ?SUCHTHAT(D, integer(), D =/= 0).

fraction() ->
    ?LET({N, D}, {integer(), non_zero_integer()}, rationals:new(N, D)).

%%% Oracles — independent of normalize/compare

%% a/b == c/d  <=>  a*d == c*b. Independent of normalize/compare.
same_value(F1, F2) ->
    {N1, D1} = rationals:ratio(F1),
    {N2, D2} = rationals:ratio(F2),
    N1 * D2 =:= N2 * D1.

sgn(X) when X < 0 -> -1;
sgn(X) when X > 0 -> 1.

%% Sign-aware ordering oracle. Independent of normalize/compare.
expected_compare(F1, F2) ->
    {N1, D1} = rationals:ratio(F1),
    {N2, D2} = rationals:ratio(F2),
    cross_to_order((N1 * D2 - N2 * D1) * sgn(D1) * sgn(D2)).

cross_to_order(Cross) when Cross < 0 -> lt;
cross_to_order(Cross) when Cross > 0 -> gt;
cross_to_order(_) -> eq.

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
        {N, D},
        {integer(), non_zero_integer()},
        same_value(
            rationals:normalize(rationals:new(N, D)),
            rationals:new(N, D)
        )
    ).

prop_compare_matches_oracle() ->
    ?FORALL(
        {F1, F2},
        {fraction(), fraction()},
        rationals:compare(F1, F2) =:= expected_compare(F1, F2)
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

prop_compare_sign_regression() ->
    ?FORALL(
        {P, Q},
        {pos_integer(), pos_integer()},
        rationals:compare(rationals:new(1, -P), rationals:new(1, Q)) =:= lt andalso
            rationals:compare(rationals:new(1, P), rationals:new(1, -Q)) =:= gt
    ).

prop_zero_identity() ->
    ?FORALL(
        F,
        fraction(),
        same_value(rationals:add(F, rationals:zero()), F)
    ).

prop_one_identity() ->
    ?FORALL(
        F,
        fraction(),
        same_value(rationals:multiply(F, rationals:one()), F)
    ).
