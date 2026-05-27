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
    prop_one_identity/0,
    prop_negate_additive_inverse/0,
    prop_negate_involution/0,
    prop_abs_non_negative/0,
    prop_abs_idempotent/0,
    prop_sign_matches_compare/0,
    prop_sign_trichotomy/0,
    prop_pow_zero/0,
    prop_pow_one/0,
    prop_pow_add/0,
    prop_min_lower_bound/0,
    prop_max_upper_bound/0,
    prop_clamp_in_range/0,
    prop_dist_symmetric/0,
    prop_dist_non_negative/0,
    prop_sum_append/0,
    prop_product_append/0,
    prop_floor_le/0,
    prop_ceil_ge/0,
    prop_floor_ceil_relation/0,
    prop_truncate_between/0,
    prop_round_nearest/0,
    prop_to_mixed_round_trip/0,
    prop_to_mixed_proper/0,
    prop_is_integer_consistent/0,
    prop_is_proper_consistent/0,
    prop_parse_format_round_trip/0,
    prop_from_integer_is_integer/0,
    prop_parse_integer_string/0,
    prop_parse_zero_denominator/0,
    prop_cf_round_trip/0,
    prop_last_convergent_is_value/0,
    prop_mediant_between/0,
    prop_is_reduced_after_reduce/0,
    prop_lcm_divisible/0,
    prop_is_unit_fraction_basic/0,
    prop_rationalize_within_tolerance/0,
    prop_egyptian_reconstructs/0,
    prop_egyptian_all_units/0,
    prop_egyptian_distinct/0,
    prop_farey_endpoints/0,
    prop_farey_ascending/0,
    prop_farey_reduced_bounded/0
]).

%%% Generators

non_zero_integer() ->
    ?SUCHTHAT(D, integer(), D =/= 0).

fraction() ->
    ?LET({N, D}, {integer(), non_zero_integer()}, rationals:new(N, D)).

fraction_list() ->
    list(fraction()).

small_non_neg_integer() ->
    range(0, 10).

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

%%% Phase 1 properties

prop_negate_additive_inverse() ->
    ?FORALL(
        F,
        fraction(),
        same_value(rationals:add(F, rationals:negate(F)), rationals:zero())
    ).

prop_negate_involution() ->
    ?FORALL(
        F,
        fraction(),
        same_value(rationals:negate(rationals:negate(F)), F)
    ).

prop_abs_non_negative() ->
    ?FORALL(
        F,
        fraction(),
        not rationals:is_negative(rationals:abs(F))
    ).

prop_abs_idempotent() ->
    ?FORALL(
        F,
        fraction(),
        same_value(rationals:abs(rationals:abs(F)), rationals:abs(F))
    ).

prop_sign_matches_compare() ->
    ?FORALL(
        F,
        fraction(),
        begin
            S = rationals:sign(F),
            C = rationals:compare(F, rationals:zero()),
            case C of
                gt -> S =:= 1;
                lt -> S =:= -1;
                eq -> S =:= 0
            end
        end
    ).

prop_sign_trichotomy() ->
    ?FORALL(
        F,
        fraction(),
        begin
            Z = rationals:is_zero(F),
            P = rationals:is_positive(F),
            N = rationals:is_negative(F),
            [true] =:= [X || X <- [Z, P, N], X]
        end
    ).

prop_pow_zero() ->
    ?FORALL(
        F,
        fraction(),
        same_value(rationals:pow(F, 0), rationals:one())
    ).

prop_pow_one() ->
    ?FORALL(
        F,
        fraction(),
        same_value(rationals:pow(F, 1), F)
    ).

prop_pow_add() ->
    ?FORALL(
        {F, A, B},
        {fraction(), small_non_neg_integer(), small_non_neg_integer()},
        same_value(
            rationals:pow(F, A + B),
            rationals:multiply(rationals:pow(F, A), rationals:pow(F, B))
        )
    ).

prop_min_lower_bound() ->
    ?FORALL(
        {F1, F2},
        {fraction(), fraction()},
        begin
            M = rationals:min(F1, F2),
            rationals:lte(M, F1) andalso
                rationals:lte(M, F2) andalso
                (same_value(M, F1) orelse same_value(M, F2))
        end
    ).

prop_max_upper_bound() ->
    ?FORALL(
        {F1, F2},
        {fraction(), fraction()},
        begin
            M = rationals:max(F1, F2),
            rationals:gte(M, F1) andalso
                rationals:gte(M, F2) andalso
                (same_value(M, F1) orelse same_value(M, F2))
        end
    ).

prop_clamp_in_range() ->
    ?FORALL(
        {F, X, Y},
        {fraction(), fraction(), fraction()},
        begin
            Lo = rationals:min(X, Y),
            Hi = rationals:max(X, Y),
            rationals:between(rationals:clamp(F, Lo, Hi), Lo, Hi)
        end
    ).

prop_dist_symmetric() ->
    ?FORALL(
        {A, B},
        {fraction(), fraction()},
        same_value(rationals:dist(A, B), rationals:dist(B, A))
    ).

prop_dist_non_negative() ->
    ?FORALL(
        {A, B},
        {fraction(), fraction()},
        not rationals:is_negative(rationals:dist(A, B))
    ).

prop_sum_append() ->
    ?FORALL(
        {L1, L2},
        {fraction_list(), fraction_list()},
        same_value(
            rationals:sum(L1 ++ L2),
            rationals:add(rationals:sum(L1), rationals:sum(L2))
        )
    ).

prop_product_append() ->
    ?FORALL(
        {L1, L2},
        {fraction_list(), fraction_list()},
        same_value(
            rationals:product(L1 ++ L2),
            rationals:multiply(rationals:product(L1), rationals:product(L2))
        )
    ).

%%% Phase 2 properties

prop_floor_le() ->
    ?FORALL(
        F,
        fraction(),
        begin
            Fl = rationals:floor(F),
            rationals:compare(rationals:new(Fl, 1), F) =/= gt andalso
                rationals:compare(F, rationals:new(Fl + 1, 1)) =:= lt
        end
    ).

prop_ceil_ge() ->
    ?FORALL(
        F,
        fraction(),
        begin
            C = rationals:ceil(F),
            rationals:compare(rationals:new(C, 1), F) =/= lt andalso
                rationals:compare(F, rationals:new(C - 1, 1)) =:= gt
        end
    ).

prop_floor_ceil_relation() ->
    ?FORALL(
        F,
        fraction(),
        begin
            Diff = rationals:ceil(F) - rationals:floor(F),
            case rationals:is_integer(F) of
                true -> Diff =:= 0;
                false -> Diff =:= 1
            end
        end
    ).

prop_truncate_between() ->
    ?FORALL(
        F,
        fraction(),
        begin
            T = rationals:truncate(F),
            Fl = rationals:floor(F),
            C = rationals:ceil(F),
            T >= erlang:min(Fl, C) andalso T =< erlang:max(Fl, C) andalso
                case rationals:compare(F, rationals:zero()) of
                    lt -> T =:= C;
                    _ -> T =:= Fl
                end
        end
    ).

prop_round_nearest() ->
    ?FORALL(
        F,
        fraction(),
        rationals:compare(
            rationals:dist(F, rationals:new(rationals:round(F), 1)),
            rationals:new(1, 2)
        ) =/= gt
    ).

prop_to_mixed_round_trip() ->
    ?FORALL(
        F,
        fraction(),
        begin
            {W, Frac} = rationals:to_mixed(F),
            same_value(
                rationals:from_mixed(W, rationals:numerator(Frac), rationals:denominator(Frac)),
                F
            )
        end
    ).

prop_to_mixed_proper() ->
    ?FORALL(
        F,
        fraction(),
        rationals:is_proper(element(2, rationals:to_mixed(F)))
    ).

prop_is_integer_consistent() ->
    ?FORALL(
        F,
        fraction(),
        rationals:is_integer(F) =:=
            (rationals:compare(F, rationals:new(rationals:truncate(F), 1)) =:= eq)
    ).

prop_is_proper_consistent() ->
    ?FORALL(
        F,
        fraction(),
        rationals:is_proper(F) =:=
            (rationals:compare(rationals:abs(F), rationals:one()) =:= lt)
    ).

%%% Phase 3 properties

prop_parse_format_round_trip() ->
    ?FORALL(
        F,
        fraction(),
        begin
            {ok, G} = rationals:parse(rationals:format(F)),
            same_value(G, F)
        end
    ).

prop_from_integer_is_integer() ->
    ?FORALL(
        N,
        integer(),
        rationals:is_integer(rationals:from_integer(N)) andalso
            same_value(rationals:from_integer(N), rationals:new(N, 1))
    ).

prop_parse_integer_string() ->
    ?FORALL(
        N,
        integer(),
        begin
            {ok, G} = rationals:parse(integer_to_list(N)),
            same_value(G, rationals:from_integer(N))
        end
    ).

prop_parse_zero_denominator() ->
    ?FORALL(
        N,
        integer(),
        rationals:parse(integer_to_list(N) ++ "/0") =:= {error, zero_denominator}
    ).

%%% Phase 4 properties

prop_cf_round_trip() ->
    ?FORALL(
        F,
        fraction(),
        same_value(rationals:from_continued_fraction(rationals:continued_fraction(F)), F)
    ).

prop_last_convergent_is_value() ->
    ?FORALL(
        F,
        fraction(),
        same_value(lists:last(rationals:convergents(F)), F)
    ).

prop_mediant_between() ->
    ?FORALL(
        {A, B},
        {fraction(), fraction()},
        begin
            Lo = rationals:min(A, B),
            Hi = rationals:max(A, B),
            M = rationals:mediant(A, B),
            rationals:lte(Lo, M) andalso rationals:lte(M, Hi)
        end
    ).

prop_is_reduced_after_reduce() ->
    ?FORALL(
        F,
        fraction(),
        rationals:is_reduced(rationals:reduce(F))
    ).

prop_lcm_divisible() ->
    ?FORALL(
        {A, B},
        {non_zero_integer(), non_zero_integer()},
        begin
            L = rationals:lcm(A, B),
            L >= 0 andalso L rem A =:= 0 andalso L rem B =:= 0
        end
    ).

prop_is_unit_fraction_basic() ->
    ?FORALL(
        P,
        pos_integer(),
        rationals:is_unit_fraction(rationals:new(1, P))
    ).

prop_rationalize_within_tolerance() ->
    ?FORALL(
        {X, K},
        {float(-100.0, 100.0), range(1, 1000)},
        begin
            Eps = 1.0 / K,
            R = rationals:rationalize(X, Eps),
            erlang:abs(rationals:to_float(R) - X) =< Eps + 1.0e-9
        end
    ).

%%% Phase 5 properties

proper_fraction() ->
    ?LET({A, B}, {pos_integer(), pos_integer()}, rationals:new(A, A + B)).

prop_egyptian_reconstructs() ->
    ?FORALL(
        F,
        proper_fraction(),
        same_value(rationals:sum(rationals:egyptian(F)), F)
    ).

prop_egyptian_all_units() ->
    ?FORALL(
        F,
        proper_fraction(),
        lists:all(fun rationals:is_unit_fraction/1, rationals:egyptian(F))
    ).

prop_egyptian_distinct() ->
    ?FORALL(
        F,
        proper_fraction(),
        begin
            Ratios = [rationals:ratio(E) || E <- rationals:egyptian(F)],
            length(Ratios) =:= length(lists:usort(Ratios))
        end
    ).

prop_farey_endpoints() ->
    ?FORALL(
        N,
        range(1, 30),
        begin
            Seq = rationals:farey(N),
            same_value(hd(Seq), rationals:zero()) andalso
                same_value(lists:last(Seq), rationals:one())
        end
    ).

prop_farey_ascending() ->
    ?FORALL(
        N,
        range(1, 30),
        begin
            Seq = rationals:farey(N),
            pairs_ascending(Seq)
        end
    ).

prop_farey_reduced_bounded() ->
    ?FORALL(
        N,
        range(1, 30),
        begin
            Seq = rationals:farey(N),
            lists:all(
                fun(F) ->
                    rationals:is_reduced(F) andalso
                        rationals:denominator(F) =< N
                end,
                Seq
            )
        end
    ).

pairs_ascending([_]) -> true;
pairs_ascending([A, B | Rest]) -> rationals:lt(A, B) andalso pairs_ascending([B | Rest]).
