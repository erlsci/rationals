# rationals

[![Build Status][gh-actions-badge]][gh-actions]
[![Erlang Versions][erlang-badge]][versions]
[![Tag][github-tag-badge]][github-tag]

[![Project Logo][logo]][logo-large]

*Rational numbers in Erlang*

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

``` erlang
7> rationals:gcd(64, 72).
8
```

See more examples in [test/rationals_SUITE.erl](https://github.com/erlsci/rationals/blob/master/test/rationals_SUITE.erl); see [rationals.erl](https://github.com/erlsci/rationals/blob/main/src/rationals.erl) for implementation details.

## License

Copyright © 2021, Erlang-Aided Enrichment Center

Copyright © 2014 Peter Morgan <peter.james.morgan@gmail.com>

[//]: ---Named-Links---

[logo]: priv/images/logo.png
[logo-large]: priv/images/logo-large.png
[gh-actions-badge]: https://github.com/erlsci/rationals/workflows/ci/badge.svg
[gh-actions]: https://github.com/erlsci/rationals/actions
[erlang-badge]: https://img.shields.io/badge/erlang-19%20to%2023-blue.svg
[versions]: https://github.com/erlsci/rationals/blob/master/.github/workflows/ci.yml
[github-tag]: https://github.com/erlsci/rationals/tags
[github-tag-badge]: https://img.shields.io/github/tag/erlsci/rationals.svg
