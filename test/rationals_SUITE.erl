%% Copyright (c) 2013-2014 Peter Morgan <peter.james.morgan@gmail.com>
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(rationals_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([
    all/0,
    groups/0,
    adding_quarters_to_thirds_test/1,
    adding_three_quarters_to_five_twelves_test/1,
    multiply_two_thirds_by_three_quarters_test/1,
    simplify_test/1,
    is_greater_than_test/1,
    is_equal_to_test/1,
    is_less_than_test/1,
    subtraction_test/1,
    mixed_numbers_test/1,
    reciprocal_test/1,
    divide_test/1,
    six_from_float_test/1,
    point_seven_five_from_float_test/1,
    point_five_from_float_test/1,
    greatest_common_divisor_test/1,
    compare_test/1,
    gt_lt_eq_test/1,
    gte_lte_test/1,
    reduce_test/1,
    ratio_test/1,
    to_float_test/1,
    normalize_test/1,
    normalize_zero_denominator_test/1,
    reduce_canonical_sign_test/1,
    compare_sign_robust_test/1,
    constants_test/1,
    denominator_contract_boundary_test/1,
    negate_test/1,
    abs_test/1,
    sign_test/1,
    predicates_test/1,
    min_max_test/1,
    clamp_between_test/1,
    dist_test/1,
    pow_test/1,
    sum_product_test/1,
    floor_test/1,
    ceil_test/1,
    truncate_test/1,
    round_test/1,
    to_mixed_test/1,
    from_mixed_test/1,
    is_integer_test/1,
    is_proper_test/1,
    parse_test/1,
    parse_error_test/1,
    format_test/1,
    from_integer_test/1,
    round_trip_test/1,
    mediant_test/1,
    is_reduced_test/1,
    is_unit_fraction_test/1,
    lcm_test/1,
    continued_fraction_test/1,
    from_continued_fraction_test/1,
    convergents_test/1,
    rationalize_test/1,
    decimal_expansion_test/1,
    egyptian_test/1,
    farey_test/1
]).

all() ->
    common:all().

groups() ->
    common:groups(?MODULE).

adding_quarters_to_thirds_test(_Config) ->
    Quarter = rationals:new(1, 4),
    Third = rationals:new(1, 3),
    Sum = rationals:add(Quarter, Third),
    7 = rationals:numerator(Sum),
    12 = rationals:denominator(Sum).

adding_three_quarters_to_five_twelves_test(_Config) ->
    A = rationals:new(3, 4),
    B = rationals:new(5, 12),
    Sum = rationals:add(A, B),
    56 = rationals:numerator(Sum),
    48 = rationals:denominator(Sum).

multiply_two_thirds_by_three_quarters_test(_Config) ->
    A = rationals:new(2, 3),
    B = rationals:new(3, 4),
    Product = rationals:multiply(A, B),
    6 = rationals:numerator(Product),
    12 = rationals:denominator(Product).

simplify_test(_Config) ->
    A = rationals:new(63, 462),
    Simplified = rationals:simplify(A),
    3 = rationals:numerator(Simplified),
    22 = rationals:denominator(Simplified).

is_greater_than_test(_Config) ->
    A = rationals:new(3, 4),
    B = rationals:new(2, 4),
    true = rationals:is_greater_than(A, B),
    true = rationals:is_greater_or_equal(A, B),
    false = rationals:is_greater_than(B, A),
    false = rationals:is_greater_than(A, A),
    true = rationals:is_greater_or_equal(A, A).

is_equal_to_test(_Config) ->
    A = rationals:new(3, 4),
    B = rationals:new(2, 4),
    C = rationals:new(1, 2),
    false = rationals:is_equal_to(A, B),
    false = rationals:is_equal_to(B, A),
    true = rationals:is_equal_to(A, A),
    true = rationals:is_equal_to(B, B),
    true = rationals:is_equal_to(B, C),
    true = rationals:is_equal_to(C, B).

is_less_than_test(_Config) ->
    A = rationals:new(3, 4),
    B = rationals:new(2, 4),
    false = rationals:is_less_than(A, B),
    true = rationals:is_less_or_equal(B, A),
    true = rationals:is_less_than(B, A).

subtraction_test(_Config) ->
    A = rationals:new(2, 3),
    B = rationals:new(1, 2),
    Difference = rationals:subtract(A, B),
    1 = rationals:numerator(Difference),
    6 = rationals:denominator(Difference).

mixed_numbers_test(_Config) ->
    A = rationals:new(6),
    B = rationals:new(3, 4),
    Product = rationals:multiply(A, B),
    18 = rationals:numerator(Product),
    4 = rationals:denominator(Product).

reciprocal_test(_Config) ->
    A = rationals:new(3, 4),
    Reciprocal = rationals:reciprocal(A),
    4 = rationals:numerator(Reciprocal),
    3 = rationals:denominator(Reciprocal).

divide_test(_Config) ->
    A = rationals:new(1, 2),
    B = rationals:new(3, 4),
    R = rationals:divide(A, B),
    4 = rationals:numerator(R),
    6 = rationals:denominator(R).

six_from_float_test(_Config) ->
    A = rationals:from_float(6.0),
    6 = rationals:numerator(A),
    1 = rationals:denominator(A).

point_seven_five_from_float_test(_Config) ->
    A = rationals:from_float(0.75),
    3 = rationals:numerator(A),
    4 = rationals:denominator(A).

point_five_from_float_test(_Config) ->
    A = rationals:from_float(0.5),
    1 = rationals:numerator(A),
    2 = rationals:denominator(A).

greatest_common_divisor_test(_Config) ->
    6 = rationals:gcd(48, 18).

compare_test(_Config) ->
    A = rationals:new(3, 4),
    B = rationals:new(2, 4),
    C = rationals:new(1, 2),
    gt = rationals:compare(A, B),
    lt = rationals:compare(B, A),
    eq = rationals:compare(B, C),
    eq = rationals:compare(A, A).

gt_lt_eq_test(_Config) ->
    A = rationals:new(3, 4),
    B = rationals:new(2, 4),
    true = rationals:gt(A, B),
    false = rationals:gt(B, A),
    false = rationals:gt(A, A),
    true = rationals:lt(B, A),
    false = rationals:lt(A, B),
    false = rationals:lt(A, A),
    true = rationals:eq(A, A),
    true = rationals:eq(rationals:new(2, 4), rationals:new(1, 2)),
    false = rationals:eq(A, B).

gte_lte_test(_Config) ->
    A = rationals:new(3, 4),
    B = rationals:new(2, 4),
    true = rationals:gte(A, B),
    true = rationals:gte(A, A),
    false = rationals:gte(B, A),
    true = rationals:lte(B, A),
    true = rationals:lte(A, A),
    false = rationals:lte(A, B).

reduce_test(_Config) ->
    A = rationals:new(63, 462),
    R = rationals:reduce(A),
    3 = rationals:numerator(R),
    22 = rationals:denominator(R),
    Half = rationals:new(1, 2),
    1 = rationals:numerator(rationals:reduce(Half)),
    2 = rationals:denominator(rationals:reduce(Half)).

ratio_test(_Config) ->
    A = rationals:new(3, 4),
    {3, 4} = rationals:ratio(A).

to_float_test(_Config) ->
    A = rationals:new(1, 4),
    0.25 = rationals:to_float(A).

normalize_test(_Config) ->
    {-1, 2} = rationals:ratio(rationals:normalize(rationals:new(1, -2))),
    {3, 4} = rationals:ratio(rationals:normalize(rationals:new(-3, -4))),
    {-1, 2} = rationals:ratio(rationals:normalize(rationals:new(2, -4))),
    {-3, 4} = rationals:ratio(rationals:normalize(rationals:new(-6, 8))),
    {0, 1} = rationals:ratio(rationals:normalize(rationals:new(0, -5))),
    {2, 1} = rationals:ratio(rationals:normalize(rationals:new(6, 3))),
    {3, 4} = rationals:ratio(rationals:normalize(rationals:new(3, 4))).

normalize_zero_denominator_test(_Config) ->
    try rationals:normalize(rationals:new(1, 0)) of
        _ -> error(should_have_crashed)
    catch
        error:function_clause -> ok
    end.

reduce_canonical_sign_test(_Config) ->
    {-1, 2} = rationals:ratio(rationals:reduce(rationals:new(1, -2))).

compare_sign_robust_test(_Config) ->
    lt = rationals:compare(rationals:new(1, -2), rationals:new(1, 3)),
    eq = rationals:compare(rationals:new(1, -2), rationals:new(-1, 2)).

constants_test(_Config) ->
    {0, 1} = rationals:ratio(rationals:zero()),
    {1, 1} = rationals:ratio(rationals:one()),
    F = rationals:new(3, 4),
    eq = rationals:compare(rationals:add(F, rationals:zero()), F),
    eq = rationals:compare(rationals:multiply(F, rationals:one()), F).

denominator_contract_boundary_test(_Config) ->
    Lazy = rationals:new(1, -2),
    Normalized = rationals:normalize(Lazy),
    {1, -2} = rationals:ratio(Lazy),
    {-1, 2} = rationals:ratio(Normalized).

negate_test(_Config) ->
    {-3, 4} = rationals:ratio(rationals:negate(rationals:new(3, 4))),
    {3, 4} = rationals:ratio(rationals:negate(rationals:new(-3, 4))).

abs_test(_Config) ->
    eq = rationals:compare(rationals:abs(rationals:new(-3, 4)), rationals:new(3, 4)),
    eq = rationals:compare(rationals:abs(rationals:new(3, -4)), rationals:new(3, 4)),
    true = rationals:is_zero(rationals:abs(rationals:zero())).

sign_test(_Config) ->
    Neg = -1,
    1 = rationals:sign(rationals:new(3, 4)),
    Neg = rationals:sign(rationals:new(-3, 4)),
    0 = rationals:sign(rationals:zero()),
    Neg = rationals:sign(rationals:new(3, -4)),
    1 = rationals:sign(rationals:new(-3, -4)).

predicates_test(_Config) ->
    true = rationals:is_zero(rationals:zero()),
    false = rationals:is_zero(rationals:one()),
    true = rationals:is_positive(rationals:new(3, 4)),
    false = rationals:is_positive(rationals:zero()),
    true = rationals:is_negative(rationals:new(-3, 4)),
    true = rationals:is_negative(rationals:new(1, -2)),
    false = rationals:is_negative(rationals:zero()).

min_max_test(_Config) ->
    Half = rationals:new(1, 2),
    ThreeQuarters = rationals:new(3, 4),
    eq = rationals:compare(rationals:min(Half, ThreeQuarters), Half),
    eq = rationals:compare(rationals:max(Half, ThreeQuarters), ThreeQuarters),
    eq = rationals:compare(rationals:min(Half, Half), Half),
    eq = rationals:compare(rationals:max(Half, Half), Half).

clamp_between_test(_Config) ->
    Lo = rationals:zero(),
    Hi = rationals:new(3, 1),
    Below = rationals:new(-1, 1),
    Within = rationals:new(1, 1),
    Above = rationals:new(5, 1),
    eq = rationals:compare(rationals:clamp(Below, Lo, Hi), Lo),
    eq = rationals:compare(rationals:clamp(Within, Lo, Hi), Within),
    eq = rationals:compare(rationals:clamp(Above, Lo, Hi), Hi),
    true = rationals:between(Lo, Lo, Hi),
    true = rationals:between(Hi, Lo, Hi),
    true = rationals:between(Within, Lo, Hi),
    false = rationals:between(Below, Lo, Hi),
    false = rationals:between(Above, Lo, Hi).

dist_test(_Config) ->
    eq = rationals:compare(
        rationals:dist(rationals:new(1, 2), rationals:new(3, 4)),
        rationals:new(1, 4)
    ),
    eq = rationals:compare(
        rationals:dist(rationals:new(3, 4), rationals:new(1, 2)),
        rationals:new(1, 4)
    ).

pow_test(_Config) ->
    F = rationals:new(2, 3),
    {1, 1} = rationals:ratio(rationals:pow(F, 0)),
    eq = rationals:compare(rationals:pow(F, 1), F),
    eq = rationals:compare(rationals:pow(F, 2), rationals:new(4, 9)),
    eq = rationals:compare(rationals:pow(F, -1), rationals:new(3, 2)),
    eq = rationals:compare(rationals:pow(F, -2), rationals:new(9, 4)),
    {1, 1} = rationals:ratio(rationals:pow(rationals:zero(), 0)).

sum_product_test(_Config) ->
    Half = rationals:new(1, 2),
    Third = rationals:new(1, 3),
    Sixth = rationals:new(1, 6),
    eq = rationals:compare(rationals:sum([Half, Third, Sixth]), rationals:one()),
    {0, 1} = rationals:ratio(rationals:sum([])),
    TwoThirds = rationals:new(2, 3),
    ThreeQuarters = rationals:new(3, 4),
    eq = rationals:compare(rationals:product([TwoThirds, ThreeQuarters]), Half),
    {1, 1} = rationals:ratio(rationals:product([])).

floor_test(_Config) ->
    3 = rationals:floor(rationals:new(7, 2)),
    Neg4 = -4,
    Neg4 = rationals:floor(rationals:new(-7, 2)),
    2 = rationals:floor(rationals:new(6, 3)),
    0 = rationals:floor(rationals:new(3, 4)),
    Neg1 = -1,
    Neg1 = rationals:floor(rationals:new(-3, 4)).

ceil_test(_Config) ->
    4 = rationals:ceil(rationals:new(7, 2)),
    Neg3 = -3,
    Neg3 = rationals:ceil(rationals:new(-7, 2)),
    2 = rationals:ceil(rationals:new(6, 3)),
    1 = rationals:ceil(rationals:new(3, 4)),
    0 = rationals:ceil(rationals:new(-3, 4)).

truncate_test(_Config) ->
    3 = rationals:truncate(rationals:new(7, 2)),
    Neg3 = -3,
    Neg3 = rationals:truncate(rationals:new(-7, 2)),
    0 = rationals:truncate(rationals:new(-3, 4)).

round_test(_Config) ->
    Neg1 = -1,
    1 = rationals:round(rationals:new(1, 2)),
    Neg1 = rationals:round(rationals:new(-1, 2)),
    2 = rationals:round(rationals:new(3, 2)),
    3 = rationals:round(rationals:new(5, 2)),
    1 = rationals:round(rationals:new(2, 3)),
    0 = rationals:round(rationals:new(1, 3)),
    Neg1 = rationals:round(rationals:new(-2, 3)).

to_mixed_test(_Config) ->
    {2, Frac1} = rationals:to_mixed(rationals:new(7, 3)),
    eq = rationals:compare(Frac1, rationals:new(1, 3)),
    {Neg2, Frac2} = rationals:to_mixed(rationals:new(-7, 3)),
    Neg2 = -2,
    eq = rationals:compare(Frac2, rationals:new(-1, 3)),
    {2, Frac3} = rationals:to_mixed(rationals:new(6, 3)),
    true = rationals:is_zero(Frac3),
    {1, Frac4} = rationals:to_mixed(rationals:new(8, 6)),
    eq = rationals:compare(Frac4, rationals:new(1, 3)).

from_mixed_test(_Config) ->
    eq = rationals:compare(rationals:from_mixed(2, 1, 3), rationals:new(7, 3)),
    eq = rationals:compare(rationals:from_mixed(-2, -1, 3), rationals:new(-7, 3)).

is_integer_test(_Config) ->
    true = rationals:is_integer(rationals:new(4, 2)),
    false = rationals:is_integer(rationals:new(3, 4)),
    true = rationals:is_integer(rationals:new(0, 5)),
    true = rationals:is_integer(rationals:new(6, 3)).

is_proper_test(_Config) ->
    true = rationals:is_proper(rationals:new(3, 4)),
    false = rationals:is_proper(rationals:new(4, 3)),
    false = rationals:is_proper(rationals:new(6, 4)),
    true = rationals:is_proper(rationals:new(-3, 4)),
    false = rationals:is_proper(rationals:new(5, 5)),
    true = rationals:is_proper(rationals:new(0, 5)).

parse_test(_Config) ->
    {ok, F1} = rationals:parse("3/4"),
    eq = rationals:compare(F1, rationals:new(3, 4)),
    {ok, F2} = rationals:parse("3"),
    eq = rationals:compare(F2, rationals:new(3, 1)),
    {ok, F3} = rationals:parse("-3/4"),
    eq = rationals:compare(F3, rationals:new(-3, 4)),
    {ok, F4} = rationals:parse(<<"3/4">>),
    eq = rationals:compare(F4, rationals:new(3, 4)),
    {ok, F5} = rationals:parse("  3 / 4  "),
    eq = rationals:compare(F5, rationals:new(3, 4)).

parse_error_test(_Config) ->
    {error, zero_denominator} = rationals:parse("3/0"),
    {error, invalid} = rationals:parse("x"),
    {error, invalid} = rationals:parse("3/"),
    {error, invalid} = rationals:parse("/4"),
    {error, invalid} = rationals:parse("3/4/5"),
    {error, invalid} = rationals:parse("").

format_test(_Config) ->
    <<"3/4">> = rationals:format(rationals:new(3, 4)),
    <<"3">> = rationals:format(rationals:new(3, 1)),
    <<"-3/4">> = rationals:format(rationals:new(-3, 4)),
    <<"0">> = rationals:format(rationals:zero()).

from_integer_test(_Config) ->
    {5, 1} = rationals:ratio(rationals:from_integer(5)),
    true = rationals:is_integer(rationals:from_integer(5)).

round_trip_test(_Config) ->
    {ok, G} = rationals:parse(rationals:format(rationals:new(7, 12))),
    eq = rationals:compare(G, rationals:new(7, 12)).

mediant_test(_Config) ->
    {2, 5} = rationals:ratio(rationals:mediant(rationals:new(1, 2), rationals:new(1, 3))),
    eq = rationals:compare(
        rationals:mediant(rationals:new(2, 4), rationals:new(1, 3)),
        rationals:new(2, 5)
    ),
    M = rationals:mediant(rationals:new(1, 3), rationals:new(1, 2)),
    lt = rationals:compare(rationals:new(1, 3), M),
    lt = rationals:compare(M, rationals:new(1, 2)).

is_reduced_test(_Config) ->
    true = rationals:is_reduced(rationals:new(1, 2)),
    true = rationals:is_reduced(rationals:new(1, -2)),
    true = rationals:is_reduced(rationals:new(0, 1)),
    false = rationals:is_reduced(rationals:new(2, 4)),
    false = rationals:is_reduced(rationals:new(0, 5)).

is_unit_fraction_test(_Config) ->
    true = rationals:is_unit_fraction(rationals:new(1, 3)),
    true = rationals:is_unit_fraction(rationals:new(2, 6)),
    false = rationals:is_unit_fraction(rationals:new(2, 3)),
    false = rationals:is_unit_fraction(rationals:new(-1, 2)),
    false = rationals:is_unit_fraction(rationals:zero()).

lcm_test(_Config) ->
    12 = rationals:lcm(4, 6),
    12 = rationals:lcm(-4, 6),
    0 = rationals:lcm(0, 5),
    0 = rationals:lcm(7, 0),
    7 = rationals:lcm(7, 1).

continued_fraction_test(_Config) ->
    [2, 3] = rationals:continued_fraction(rationals:new(7, 3)),
    [0, 2] = rationals:continued_fraction(rationals:new(1, 2)),
    [3] = rationals:continued_fraction(rationals:new(3, 1)),
    [-3, 1, 2] = rationals:continued_fraction(rationals:new(-7, 3)).

from_continued_fraction_test(_Config) ->
    eq = rationals:compare(rationals:from_continued_fraction([2, 3]), rationals:new(7, 3)),
    eq = rationals:compare(rationals:from_continued_fraction([3]), rationals:new(3, 1)),
    eq = rationals:compare(rationals:from_continued_fraction([-3, 1, 2]), rationals:new(-7, 3)).

convergents_test(_Config) ->
    C1 = rationals:convergents(rationals:new(7, 3)),
    2 = length(C1),
    eq = rationals:compare(lists:last(C1), rationals:new(7, 3)),
    eq = rationals:compare(hd(C1), rationals:new(2, 1)),
    C2 = rationals:convergents(rationals:new(3, 1)),
    1 = length(C2),
    eq = rationals:compare(hd(C2), rationals:new(3, 1)).

rationalize_test(_Config) ->
    {1, 2} = rationals:ratio(rationals:rationalize(0.5, 0.01)),
    {1, 3} = rationals:ratio(rationals:rationalize(0.333333, 0.001)),
    {2, 1} = rationals:ratio(rationals:rationalize(2.5, 0.5)),
    {0, 1} = rationals:ratio(rationals:rationalize(0.0, 0.5)),
    {-1, 2} = rationals:ratio(rationals:rationalize(-0.5, 0.01)).

decimal_expansion_test(_Config) ->
    {<<"0.25">>, <<>>} = rationals:decimal_expansion(rationals:new(1, 4)),
    {<<"0.5">>, <<>>} = rationals:decimal_expansion(rationals:new(1, 2)),
    {<<"0.">>, <<"3">>} = rationals:decimal_expansion(rationals:new(1, 3)),
    {<<"0.1">>, <<"6">>} = rationals:decimal_expansion(rationals:new(1, 6)),
    {<<"0.">>, <<"285714">>} = rationals:decimal_expansion(rationals:new(2, 7)),
    {<<"2.">>, <<"3">>} = rationals:decimal_expansion(rationals:new(7, 3)),
    {<<"3">>, <<>>} = rationals:decimal_expansion(rationals:new(3, 1)),
    {<<"-0.">>, <<"3">>} = rationals:decimal_expansion(rationals:new(-1, 3)),
    {<<"0">>, <<>>} = rationals:decimal_expansion(rationals:zero()).

egyptian_test(_Config) ->
    E1 = rationals:egyptian(rationals:new(2, 3)),
    2 = length(E1),
    eq = rationals:compare(hd(E1), rationals:new(1, 2)),
    eq = rationals:compare(lists:last(E1), rationals:new(1, 6)),
    E2 = rationals:egyptian(rationals:new(3, 4)),
    2 = length(E2),
    eq = rationals:compare(hd(E2), rationals:new(1, 2)),
    eq = rationals:compare(lists:last(E2), rationals:new(1, 4)),
    [] = rationals:egyptian(rationals:zero()).

farey_test(_Config) ->
    F1 = rationals:farey(1),
    [{0, 1}, {1, 1}] = [rationals:ratio(X) || X <- F1],
    F2 = rationals:farey(2),
    [{0, 1}, {1, 2}, {1, 1}] = [rationals:ratio(X) || X <- F2],
    F3 = rationals:farey(3),
    [{0, 1}, {1, 3}, {1, 2}, {2, 3}, {1, 1}] = [rationals:ratio(X) || X <- F3].
