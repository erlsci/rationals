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
    greatest_common_divisor_test/1
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
