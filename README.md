# rationals

[![Build Status][gh-actions-badge]][gh-actions]
[![Coverage][coverage-badge]][project]
[![Tag][tag-badge]][tag]
[![Erlang Versions][erlang-badge]][versions]

*Rational numbers in Erlang*

[![Project Logo][logo]][logo-large]

## Build & Test

``` shell
rebar3 compile
rebar3 check
```

## Usage

``` erlang
1> Third = rationals:new(1, 3).
{fraction,1,3}
2> Quarter = rationals:new(1, 4).
{fraction,1,4}
```

``` erlang
3> rationals:numerator(Quarter).
1
4> rationals:denominator(Quarter).
4
```

``` erlang
5> rationals:add(Quarter, Third).
{fraction,7,12}
6> rationals:multiply(Quarter, Third).
{fraction,1,12}
```

Arithmetic returns unreduced fractions; call `reduce/1` (or `normalize/1`) for
canonical form — reduced to lowest terms with the sign on the numerator and a
positive denominator:

``` erlang
7> Sum = rationals:add(rationals:new(3, 4), rationals:new(5, 12)).
{fraction,56,48}
8> rationals:reduce(Sum).
{fraction,7,6}
9> rationals:normalize(rationals:new(1, -2)).
{fraction,-1,2}
```

The constants `zero/0` and `one/0` return canonical `0/1` and `1/1`:

``` erlang
10> rationals:zero().
{fraction,0,1}
11> rationals:one().
{fraction,1,1}
```

Compare fractions by value with `compare/2` (which returns `lt`, `eq`, or `gt`) or with the boolean predicates `gt/2`, `lt/2`, `eq/2`, `gte/2`, and `lte/2`:

``` erlang
12> rationals:compare(Quarter, Third).
lt
13> rationals:gt(Third, Quarter).
true
14> rationals:eq(rationals:new(2, 4), rationals:new(1, 2)).
true
```

Negate, absolute value, and sign:

``` erlang
15> rationals:negate(Quarter).
{fraction,-1,4}
16> rationals:abs(rationals:new(-3, 4)).
{fraction,3,4}
17> rationals:sign(rationals:new(-3, 4)).
-1
```

Integer exponentiation, sum, and product:

``` erlang
18> rationals:pow(rationals:new(2, 3), 3).
{fraction,8,27}
19> rationals:pow(rationals:new(2, 3), -1).
{fraction,3,2}
20> rationals:sum([rationals:new(1, 2), rationals:new(1, 3), rationals:new(1, 6)]).
{fraction,6,6}
21> rationals:reduce(rationals:sum([rationals:new(1, 2), rationals:new(1, 3), rationals:new(1, 6)])).
{fraction,1,1}
22> rationals:product([rationals:new(2, 3), rationals:new(3, 4)]).
{fraction,6,12}
```

Rounding and integer conversion — `floor/1` rounds toward −∞, `ceil/1` toward
+∞, `truncate/1` toward zero, and `round/1` rounds half away from zero:

``` erlang
23> rationals:floor(rationals:new(-7, 2)).
-4
24> rationals:ceil(rationals:new(-7, 2)).
-3
25> rationals:round(rationals:new(5, 2)).
3
```

Mixed-number decomposition and predicates:

``` erlang
26> rationals:to_mixed(rationals:new(7, 3)).
{2,{fraction,1,3}}
27> rationals:from_mixed(2, 1, 3).
{fraction,7,3}
28> rationals:is_integer(rationals:new(6, 3)).
true
29> rationals:is_proper(rationals:new(3, 4)).
true
```

Parse fractions from text and format them as binaries:

``` erlang
30> rationals:parse("3/4").
{ok,{fraction,3,4}}
31> rationals:parse("-7/3").
{ok,{fraction,-7,3}}
32> rationals:parse("42").
{ok,{fraction,42,1}}
33> rationals:parse("3/0").
{error,zero_denominator}
34> rationals:format(rationals:new(7, 12)).
<<"7/12">>
35> rationals:format(rationals:new(3, 1)).
<<"3">>
36> rationals:from_integer(5).
{fraction,5,1}
```

Continued fractions, convergents, and best rational approximation:

``` erlang
37> rationals:continued_fraction(rationals:new(7, 3)).
[2,3]
38> rationals:convergents(rationals:new(7, 3)).
[{fraction,2,1},{fraction,7,3}]
39> rationals:rationalize(3.14159, 0.001).
{fraction,22,7}
40> rationals:mediant(rationals:new(1, 2), rationals:new(1, 3)).
{fraction,2,5}
```

Also available: `min/2`, `max/2`, `clamp/3`, `between/3`, `dist/2`,
`is_zero/1`, `is_positive/1`, `is_negative/1`, `is_reduced/1`,
`is_unit_fraction/1`, `lcm/2`, `from_continued_fraction/1`.

``` erlang
23> rationals:gcd(64, 72).
8
```

The original long-form names — `simplify/1`, `is_greater_than/2`, `is_less_than/2`, `is_equal_to/2`, `is_greater_or_equal/2`, and `is_less_or_equal/2` — remain available as backward-compatible aliases, but the short names above are preferred.

See more examples in [test/rationals_SUITE.erl](https://github.com/erlsci/rationals/blob/master/test/rationals_SUITE.erl); see [rationals.erl](https://github.com/erlsci/rationals/blob/main/src/rationals.erl) for implementation details.

### Behavior change in 0.3.0: negative-denominator canonicalization

`reduce/1` (and its alias `simplify/1`) now canonicalize sign: the denominator
is always positive in the result and the sign is carried on the numerator.
Previously, `reduce(new(1, -2))` returned `1/-2`; it now returns `-1/2`.
`compare/2` and all derived predicates are now sign-robust — they normalize
operands internally, so comparisons are correct even on fractions with a
negative denominator.

## License

Copyright © 2021-2026, Erlang-Aided Enrichment Center

Copyright © 2014 Peter Morgan <peter.james.morgan@gmail.com>

[//]: ---Named-Links---

[project]: https://github.com/erlsci/rationals
[logo]: priv/images/logo.png
[logo-large]: priv/images/logo-large.png
[gh-actions-badge]: https://github.com/erlsci/rationals/workflows/ci/badge.svg
[gh-actions]: https://github.com/erlsci/rationals/actions
[erlang-badge]: https://img.shields.io/badge/erlang-20+-blue.svg
[versions]: https://github.com/erlsci/rationals/blob/master/.github/workflows/ci.yml
[coverage-badge]: https://img.shields.io/badge/coverage-100%25-brightgreen
[tag]: https://github.com/erlsci/rationals/tags
[tag-badge]: https://img.shields.io/github/tag/erlsci/rationals.svg
