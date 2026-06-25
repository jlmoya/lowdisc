# lowdisc — Low Discrepancy Sequences for Scilab

Low-discrepancy (quasi-random) sequence generators for Scilab: **Halton** (classic,
leaped, reverse, scrambled), **Sobol** (classic and scrambled), **Faure**, and
**Niederreiter** (arbitrary base). These sequences give a higher convergence rate
than pseudo-random numbers in Monte-Carlo simulation and numerical integration, for
problems of arbitrary dimension.

Features:
- arbitrary number of dimensions;
- skip a given number of initial elements; leap (ignore) elements between draws;
- fast sequences backed by compiled C/C++;
- helpers that suggest optimal settings per sequence;
- object-oriented API (`lowdisc_new` / `lowdisc_get` / `lowdisc_next` / `lowdisc_destroy`)
  plus the one-shot `lowdisc_ldgen(callf, n, ldseq)`;
- direct access to the *k*-th coordinate without generating coordinates `1..k-1`.

## Modernized for Scilab 2026.1.0

This is the `lowdisc` 0.7 toolbox (Michael Baudin — INRIA / DIGITEO, 2008–2014),
ported to build and run on **Scilab 2026.1.0**. The original C++ gateways were written
against the Scilab 5 `stack-c.h` API, which Scilab 6 removed; they have been rewritten
against the modern `api_scilab` interface.

What changed:
- All 28 C++ gateways migrated from `stack-c.h` to `api_scilab`; gateway signatures
  `int sci_xxx(char *fname)` → `int sci_xxx(char *fname, void *pvApiCtx)`.
- Scilab 6 dropped the implicit global `pvApiCtx` that the support helpers relied on;
  each gateway now sets a translation-unit global from its `pvApiCtx` argument before
  calling any helper (the helpers keep their original signatures).
- Reworked the gateway support layer: the dead `GetRhsVarMatrixDouble` macro was
  replaced by a new `lowdisc_GetMatrixOfDoubleArgument` helper
  (`getVarAddressFromPosition` + `getMatrixOfDouble`); single-string arguments now use
  `getAllocatedSingleString`; variable-type checks use `getVarType`.
- `tbx_builder_help` wrapped in `try/catch` so a headless (CLI) build completes even
  when the help chapter can't be built.
- The pure-numeric C++ library under `src/cpp` was unchanged — it uses no Scilab API.

The numerical results were verified end-to-end on Scilab 2026.1.0: all seven sequence
types produce points in `[0,1]^n` of the expected shape via `lowdisc_ldgen`.

## Dependencies

Requires two ATOMS toolboxes (both pure-macro), loaded automatically by Scilab before
`lowdisc`:
- **apifun** — argument-checking helpers;
- **number** — prime-number tables (`number_primes100`, …) used for Halton/Faure bases.

## Building

```scilab
exec builder.sce;   // compiles src/cpp + the 28 gateways, builds macros, generates loader.sce
exec loader.sce;    // loads the toolbox into the running session
```

## License

GNU LGPL — see [`license.txt`](license.txt). The interface and numerical sources are
distributed under the LGPL / CeCILL terms noted in the individual file headers.

## Credits

Original toolbox by **Michael Baudin** (INRIA, DIGITEO / Scilab Enterprises), 2008–2014.
Scilab 2026 modernization preserves the original algorithms and public API.
