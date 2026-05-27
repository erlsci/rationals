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

-module(rationals).

-compile({no_auto_import, [abs/1, min/2, max/2, floor/1, ceil/1, round/1, is_integer/1]}).

-export([
    new/1,
    new/2,
    ratio/1,
    add/2,
    subtract/2,
    multiply/2,
    divide/2,
    reciprocal/1,
    normalize/1,
    reduce/1,
    numerator/1,
    denominator/1,
    compare/2,
    gt/2,
    lt/2,
    eq/2,
    gte/2,
    lte/2,
    zero/0,
    one/0,
    negate/1,
    abs/1,
    sign/1,
    is_zero/1,
    is_positive/1,
    is_negative/1,
    min/2,
    max/2,
    clamp/3,
    between/3,
    dist/2,
    pow/2,
    sum/1,
    product/1,
    truncate/1,
    floor/1,
    ceil/1,
    round/1,
    to_mixed/1,
    from_mixed/3,
    is_integer/1,
    is_proper/1,
    from_integer/1,
    format/1,
    parse/1,
    from_float/1,
    to_float/1,
    gcd/2,

    %% Backward-compatible aliases for the original long-form names. These
    %% delegate to the short names above; new code should prefer the short
    %% names. Kept exported so existing callers do not break.
    simplify/1,
    is_greater_than/2,
    is_less_than/2,
    is_equal_to/2,
    is_greater_or_equal/2,
    is_less_or_equal/2
]).

-export_type([
    numerator/0,
    denominator/0,
    fraction/0,
    ratio/0
]).

-type numerator() :: integer().
%% The canonical (post-normalize) contract: always positive after reduce/normalize.
-type denominator() :: pos_integer().
%% Representation: lazy new/2 may store any non-zero integer before normalization.
-type raw_denominator() :: integer().

-record(fraction, {
    numerator :: numerator(),
    denominator :: raw_denominator()
}).

-type ratio() :: {numerator(), denominator()}.

-opaque fraction() :: #fraction{}.

-spec new(numerator()) -> fraction().
new(Numerator) ->
    #fraction{numerator = Numerator, denominator = 1}.

-spec new(numerator(), denominator()) -> fraction().
new(Numerator, Denominator) ->
    #fraction{numerator = Numerator, denominator = Denominator}.

-spec numerator(fraction()) -> numerator().
numerator(#fraction{numerator = Numerator}) ->
    Numerator.

%% Canonical-form guarantee: returns pos_integer() after normalize/reduce.
%% A fraction built lazily with new/2 may carry a negative denominator.
-spec denominator(fraction()) -> denominator().
denominator(#fraction{denominator = Denominator}) ->
    Denominator.

%% Canonical-form guarantee: the second element is pos_integer() after
%% normalize/reduce. A lazily-built fraction may yield a negative denominator.
-spec ratio(fraction()) -> ratio().
ratio(#fraction{numerator = Numerator, denominator = Denominator}) ->
    {Numerator, Denominator}.

-spec add(fraction(), fraction()) -> fraction().
add(
    #fraction{numerator = N1, denominator = D1},
    #fraction{numerator = N2, denominator = D2}
) ->
    new((N1 * D2) + (D1 * N2), D1 * D2).

-spec subtract(fraction(), fraction()) -> fraction().
subtract(
    #fraction{numerator = N1, denominator = D1},
    #fraction{numerator = N2, denominator = D2}
) ->
    new((N1 * D2) - (D1 * N2), D1 * D2).

-spec multiply(fraction(), fraction()) -> fraction().
multiply(
    #fraction{numerator = N1, denominator = D1},
    #fraction{numerator = N2, denominator = D2}
) ->
    new(N1 * N2, D1 * D2).

-spec reciprocal(fraction()) -> fraction().
reciprocal(#fraction{numerator = Numerator, denominator = Denominator}) ->
    new(Denominator, Numerator).

-spec divide(fraction(), fraction()) -> fraction().
divide(A, B) ->
    multiply(A, reciprocal(B)).

-spec normalize(fraction()) -> fraction().
normalize(#fraction{numerator = N, denominator = D}) when D =/= 0 ->
    G = gcd(erlang:abs(N), erlang:abs(D)),
    case D < 0 of
        true -> new(-(N div G), -(D div G));
        false -> new(N div G, D div G)
    end.

-spec reduce(fraction()) -> fraction().
reduce(F) ->
    normalize(F).

-spec compare(fraction(), fraction()) -> lt | eq | gt.
compare(F1, F2) ->
    #fraction{numerator = N1, denominator = D1} = normalize(F1),
    #fraction{numerator = N2, denominator = D2} = normalize(F2),
    compare_cross(N1 * D2, N2 * D1).

compare_cross(Left, Right) when Left < Right -> lt;
compare_cross(Left, Right) when Left > Right -> gt;
compare_cross(_Left, _Right) -> eq.

-spec gt(fraction(), fraction()) -> boolean().
gt(F1, F2) ->
    compare(F1, F2) =:= gt.

-spec lt(fraction(), fraction()) -> boolean().
lt(F1, F2) ->
    compare(F1, F2) =:= lt.

-spec eq(fraction(), fraction()) -> boolean().
eq(F1, F2) ->
    compare(F1, F2) =:= eq.

-spec gte(fraction(), fraction()) -> boolean().
gte(F1, F2) ->
    compare(F1, F2) =/= lt.

-spec lte(fraction(), fraction()) -> boolean().
lte(F1, F2) ->
    compare(F1, F2) =/= gt.

-spec zero() -> fraction().
zero() -> new(0, 1).

-spec one() -> fraction().
one() -> new(1, 1).

-spec negate(fraction()) -> fraction().
negate(#fraction{numerator = N, denominator = D}) ->
    new(-N, D).

-spec abs(fraction()) -> fraction().
abs(#fraction{numerator = N, denominator = D}) ->
    new(erlang:abs(N), erlang:abs(D)).

-spec sign(fraction()) -> -1 | 0 | 1.
sign(F) ->
    case numerator(normalize(F)) of
        0 -> 0;
        N when N < 0 -> -1;
        _ -> 1
    end.

-spec is_zero(fraction()) -> boolean().
is_zero(F) -> numerator(F) =:= 0.

-spec is_positive(fraction()) -> boolean().
is_positive(F) -> sign(F) =:= 1.

-spec is_negative(fraction()) -> boolean().
is_negative(F) -> sign(F) =:= -1.

-spec min(fraction(), fraction()) -> fraction().
min(F1, F2) ->
    case compare(F1, F2) of
        gt -> F2;
        _ -> F1
    end.

-spec max(fraction(), fraction()) -> fraction().
max(F1, F2) ->
    case compare(F1, F2) of
        lt -> F2;
        _ -> F1
    end.

-spec clamp(fraction(), fraction(), fraction()) -> fraction().
clamp(F, Lo, Hi) ->
    max(Lo, min(F, Hi)).

-spec between(fraction(), fraction(), fraction()) -> boolean().
between(F, Lo, Hi) ->
    gte(F, Lo) andalso lte(F, Hi).

-spec dist(fraction(), fraction()) -> fraction().
dist(F1, F2) ->
    abs(subtract(F1, F2)).

%% 0^0 = 1 by convention. pow(zero(), N) for N < 0 produces a
%% zero-denominator fraction (out of contract, like reciprocal of zero).
-spec pow(fraction(), integer()) -> fraction().
pow(_F, 0) -> one();
pow(F, N) when N > 0 -> pow_pos(F, N, one());
pow(F, N) when N < 0 -> reciprocal(pow_pos(F, -N, one())).

pow_pos(_F, 0, Acc) ->
    Acc;
pow_pos(F, N, Acc) ->
    Acc1 =
        case N rem 2 of
            1 -> multiply(Acc, F);
            0 -> Acc
        end,
    pow_pos(multiply(F, F), N div 2, Acc1).

-spec sum([fraction()]) -> fraction().
sum(Fs) -> lists:foldl(fun add/2, zero(), Fs).

-spec product([fraction()]) -> fraction().
product(Fs) -> lists:foldl(fun multiply/2, one(), Fs).

-spec truncate(fraction()) -> integer().
truncate(F) ->
    #fraction{numerator = N, denominator = D} = normalize(F),
    N div D.

-spec floor(fraction()) -> integer().
floor(F) ->
    #fraction{numerator = N, denominator = D} = normalize(F),
    case N rem D of
        R when R < 0 -> (N div D) - 1;
        _ -> N div D
    end.

-spec ceil(fraction()) -> integer().
ceil(F) ->
    #fraction{numerator = N, denominator = D} = normalize(F),
    case N rem D of
        R when R > 0 -> (N div D) + 1;
        _ -> N div D
    end.

%% Rounds half away from zero (matches erlang:round/1 convention).
-spec round(fraction()) -> integer().
round(F) ->
    #fraction{numerator = N, denominator = D} = normalize(F),
    Mag = (2 * erlang:abs(N) + D) div (2 * D),
    case N < 0 of
        true -> -Mag;
        false -> Mag
    end.

%% Whole part (toward zero) + signed proper fractional remainder.
-spec to_mixed(fraction()) -> {integer(), fraction()}.
to_mixed(F) ->
    #fraction{numerator = N, denominator = D} = normalize(F),
    {N div D, new(N rem D, D)}.

-spec from_mixed(integer(), numerator(), denominator()) -> fraction().
from_mixed(Whole, N, D) ->
    new(Whole * D + N, D).

-spec is_integer(fraction()) -> boolean().
is_integer(F) ->
    denominator(normalize(F)) =:= 1.

-spec is_proper(fraction()) -> boolean().
is_proper(F) ->
    #fraction{numerator = N, denominator = D} = normalize(F),
    erlang:abs(N) < D.

-spec from_integer(integer()) -> fraction().
from_integer(N) ->
    new(N, 1).

-spec format(fraction()) -> binary().
format(F) ->
    case ratio(F) of
        {N, 1} ->
            integer_to_binary(N);
        {N, D} ->
            <<(integer_to_binary(N))/binary, $/, (integer_to_binary(D))/binary>>
    end.

-spec parse(string() | binary()) -> {ok, fraction()} | {error, invalid | zero_denominator}.
parse(Bin) when is_binary(Bin) ->
    parse(binary_to_list(Bin));
parse(Str) when is_list(Str) ->
    case string:split(string:trim(Str), "/", all) of
        [NumStr] ->
            case to_int(NumStr) of
                {ok, N} -> {ok, new(N, 1)};
                error -> {error, invalid}
            end;
        [NumStr, DenStr] ->
            case {to_int(NumStr), to_int(DenStr)} of
                {{ok, _}, {ok, 0}} -> {error, zero_denominator};
                {{ok, N}, {ok, D}} -> {ok, new(N, D)};
                _ -> {error, invalid}
            end;
        _ ->
            {error, invalid}
    end.

to_int(Str) ->
    case string:to_integer(string:trim(Str)) of
        {Int, []} -> {ok, Int};
        _ -> error
    end.

-spec to_float(fraction()) -> float().
to_float(#fraction{
    numerator = Numerator,
    denominator = Denominator
}) ->
    Numerator / Denominator.

-spec from_float(float()) -> fraction().
from_float(Float) when is_float(Float) ->
    from_float(Float, 1).

from_float(Numerator, Denominator) when Numerator == trunc(Numerator) ->
    reduce(new(trunc(Numerator), Denominator));
from_float(Numerator, Denominator) ->
    from_float(Numerator * 10, Denominator * 10).

gcd(A, 0) ->
    A;
gcd(A, B) ->
    gcd(B, A rem B).

%%% ===========================================================================
%%% Backward-compatible aliases
%%%
%%% Thin wrappers preserving the original long-form names. Each delegates to its
%%% short-form replacement above. New code should prefer the short names; these
%%% are kept so existing callers continue to work.
%%% ===========================================================================

-spec simplify(fraction()) -> fraction().
simplify(F) ->
    reduce(F).

-spec is_greater_than(fraction(), fraction()) -> boolean().
is_greater_than(F1, F2) ->
    gt(F1, F2).

-spec is_less_than(fraction(), fraction()) -> boolean().
is_less_than(F1, F2) ->
    lt(F1, F2).

-spec is_equal_to(fraction(), fraction()) -> boolean().
is_equal_to(F1, F2) ->
    eq(F1, F2).

-spec is_greater_or_equal(fraction(), fraction()) -> boolean().
is_greater_or_equal(F1, F2) ->
    gte(F1, F2).

-spec is_less_or_equal(fraction(), fraction()) -> boolean().
is_less_or_equal(F1, F2) ->
    lte(F1, F2).
