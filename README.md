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

``` erlang
15> rationals:gcd(64, 72).
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
[erlang-badge]: https://img.shields.io/badge/erlang-19%20to%2023-blue.svg
[versions]: https://github.com/erlsci/rationals/blob/master/.github/workflows/ci.yml
[coverage-badge]: https://img.shields.io/badge/coverage-100%25-brightgreen
[tag]: https://github.com/erlsci/rationals/tags
[tag-badge]: https://img.shields.io/github/tag/erlsci/rationals.svg
