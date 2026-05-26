# CLAUDE.md — rationals

Standing instructions for Claude (including Claude Code / "CC") working in this
repository. Auto-loaded each session. Keep it short; keep it followed.

## What rationals is

rationals is a rational-number (fraction) arithmetic library for Erlang. It is a
small, single-module library (`src/rationals.erl`, app `rationals`, currently
v0.2.0) — not an application with a supervision tree. It depends only on `kernel`
and `stdlib`.

History: created by Peter Morgan (2013–2014) as the singular `rational`; later
renamed to the plural `rationals` and converted to rebar3 under the
[erlsci](https://github.com/erlsci) org (Erlang-Aided Enrichment Center).
Maintained by Duncan McGreggor. Published on Hex; hosted on GitHub.

Public API (all in `rationals`):

* construction — `new/1`, `new/2`
* accessors — `numerator/1`, `denominator/1`, `ratio/1`
* arithmetic — `add/2`, `subtract/2`, `multiply/2`, `divide/2`, `reciprocal/1`,
  `simplify/1`
* comparison — `is_greater_than/2`, `is_less_than/2`, `is_equal_to/2`,
  `is_greater_or_equal/2`, `is_less_or_equal/2`
* conversion — `from_float/1`, `to_float/1`
* helper — `gcd/2`

Exported types: `numerator/0`, `denominator/0`, and `ratio/0` are the public
vocabulary of the API. `fraction/0` is **opaque on purpose** — callers build
fractions with `new/*` and read them through `numerator/1`, `denominator/1`, and
`ratio/1`; they must not pattern-match the underlying `#fraction{}` record. Keep
`fraction/0` opaque and keep the record private to the module.

Behaviour worth knowing before you "fix" it (these are characteristics, not
bugs — changing them is a behaviour change, so check the issue tracker and
version accordingly): arithmetic does **not** auto-simplify — `add`, `subtract`,
`multiply`, and `divide` return unreduced fractions, and callers reduce with
`simplify/1` when they want lowest terms. `new/2` does not validate its
denominator (the `pos_integer()` spec is a contract for dialyzer/callers, not a
runtime guard). `from_float/1` handles terminating decimals by scaling; it is not
a general real-to-rational converter.

## House style — load this first

Before writing or reviewing Erlang, read **`priv/ai/erlang/SKILL.md`** and follow
its own loading instructions (it indexes `priv/ai/erlang/guides/`). This is the
authoritative Erlang skill and the operative code-quality reference. (It is a
symlink into the shared `ai-engineering` knowledge base, used across the erlsci
Erlang projects.)

Note that the official home for this SKILL and guides is here:

* <https://github.com/billosys/ai-engineering>

## Conventions

* This is a public library published on Hex. It is **pre-1.0 (0.2.0)**, so the
  API may still evolve — but don't break callers casually. Bump the version per
  SemVer when behaviour or the public surface changes (pre-1.0: a breaking change
  rides a minor bump).
* **Broad OTP support.** The floor is **OTP 20** (compile/xref/dialyzer run there);
  tests, PropEr, and coverage are gated to **OTP ≥ 21** because PropEr 1.5 needs
  21.3. CI exercises the full OTP 20–27 matrix. Don't introduce features newer
  than the OTP-20 floor — in particular **no OTP-27 `-doc`/EEP-48 attributes and
  no `maybe`** expression/keyword; both break the old-OTP builds.
* **`fraction/0` stays opaque; no shared records across module boundaries.**
  (There's effectively one module here — keep the `#fraction{}` record private.)
* **No `_new` forks; no macros for logic.** One way to do a thing.
* **Release discipline:** SemVer + git history + Hex release notes. No
  hand-maintained `CHANGELOG`.

## Tooling

Build and check with rebar3 (the Makefile wraps the common ones):

* `rebar3 compile` (`make compile`).
* `rebar3 xref` — `xref_checks` in `rebar.config`: `undefined_function_calls`,
  `undefined_functions`, `locals_not_used`, `deprecated_function_calls`,
  `deprecated_functions`.
* `rebar3 dialyzer` — warnings: `unknown`, `unmatched_returns`, `error_handling`,
  `underspecs`.
* Tests are **common_test**: the suite is `test/rationals_SUITE.erl`, with
  `test/common.erl` providing `all/0` / `groups/1` and auto-discovering the
  `*_test/1` cases. `make test` runs `rebar3 do eunit --cover, ct --cover,
  proper -c`.
* **Coverage gate is 100%** (`cover -v --min_coverage=100`), enforced in CI. Keep
  it at 100% by adding real tests when you add code — don't lower the threshold,
  and don't pad it with trivial tests.
* `rebar3 check` (alias) — compile, xref, dialyzer, eunit, coverage (proper +
  `cover --min_coverage=100`). `make check` additionally runs `clean`,
  `format-check`, and `lint` (elvis).

Note `erl_opts` is empty — `warnings_as_errors` is **not** on. Still, treat
compiler warnings as defects to fix, not noise to tolerate.

Dev/doc/publish tooling lives in the **`dev` rebar3 profile** so the CI matrix
never builds plugins that need a newer OTP than the library's floor. Invoke them
as `rebar3 as dev <task>`: erlfmt (`make format`), rebar3_lint/elvis
(`make lint`), rebar3_ex_doc (`make docs`), rebar3_hex (`make publish`),
coveralls. Documentation is ex_doc (with `README.md` as the main page); do not
use EEP-48 `-doc` attributes (OTP-floor rule above).

## How we work (process rigour)

Two roles. **CC** implements and self-assesses. A separate reviewer context
independently verifies — re-running commands and reading diffs, not summaries.
The implementer does not mark its own work verified.

Write to the floor, not the ceiling: state what the work actually achieves, name
what is not done, and distinguish "verified by running X" from "I believe X".

## Subagent Delegation Policy

(full text: `priv/ai/SUBAGENT-DELEGATION-POLICY.md`)

* **Do not delegate thinking work to subagents** — code edits, design/architecture
  decisions, tradeoff reasoning, judging whether a finding is real, planning,
  evaluating correctness.
* **Subagents are for lookup only** — finding files/symbols, grepping, reading a
  file, fetching docs: retrieval that needs no judgment about the result.
* Serial on thinking (main context); parallel on lookup. Quality over wall-clock
  on the thinking path.

## Branches & CI

* Work on **`main`** (default branch). Long-lived feature work can use
  `feature/**`, `epic/**`, `release/**`, or `task/**` branches.
* CI (`.github/workflows/ci.yml`) fires on `main`, `release/**`, `task/**`,
  `feature/**`, `epic/**`, and tags, in two tiers: OTP 20–23 inside the official
  `erlang` Debian containers (rebar3 pinned to 3.15.2), and OTP 24–27 via
  `erlef/setup-beam`. It is the independent reproducer for
  compile/xref/dialyzer/eunit/proper/coverage. (eunit/proper/coverage only run on
  OTP ≥ 21.)
* Releases publish to Hex via `make publish` (`rebar3 as dev hex publish`).

## Collaboration posture

Peer frame: equal contributors, mutual intellectual humility, honest engagement
over agreeable hedging. Being corrected is a contribution, not a defeat. See
`priv/ai/AI-CONSTITUTION-SUPPLEMENT.md` and `priv/ai/AI-ENGINEERING-METHODOLOGY.md`.

## Before submitting

* [ ] `rebar3 compile` clean (fix all warnings, even though they aren't errors).
* [ ] `rebar3 xref` clean.
* [ ] common_test suite green; PropEr properties pass.
* [ ] `rebar3 dialyzer` clean.
* [ ] Coverage at 100%.
* [ ] Public API and the opaque `fraction/0` unchanged (or the change is
      intentional + versioned).
* [ ] Self-reviewed against the Erlang skill (`priv/ai/erlang/SKILL.md`).
