# Reproducible public release candidate

The public `1.0.0` candidate is built only from a committed Git revision and
the reviewed inputs in `release/candidate-inputs.json`. The manifest pins the
Elixir/OTP, Mix, Hex, rebar3, Node, npm, Tailwind, Playwright and axe identities
plus every dependency lockfile hash. Exact Playwright browser revisions remain
observed evidence in the demo compatibility record, not package support targets.

Set `MIX_REBAR3` to the reviewed executable, make the matching Elixir/OTP and
Node/npm runtimes available, then run:

```console
node scripts/run-clean-candidate.mjs --ref HEAD --output /absolute/evidence/directory
```

The command creates a detached disposable Git worktree, installs only locked
Mix and npm dependencies, builds and checks CSS, runs package precommit,
generates warning-free deterministic HTML/Markdown ExDoc, creates and audits
the Hex archive, exports and
smoke-tests the gallery, records SHA-256 inventories, then removes the worktree.
The output directory contains the actual archive, its unpacked file/hash
inventory and `candidate-build.json`.

Dependency setup may contact the configured Hex and npm registries when caches
are cold. That is a build-time input boundary, not a runtime asset dependency.
The package and exported gallery contain no remote CSS/JavaScript imports,
undeclared downloads, credentials or mutable user data. Consumers receive the
compiled stylesheet and do not need Node, npm, Tailwind, Playwright or package
JavaScript. Clean worktrees ensure untracked files and developer build output
cannot affect the candidate.

Two records from the same revision are equivalent only when the input,
provenance, compiled CSS, gallery/search/health/release output, documentation
and unpacked archive inventories match. The outer Hex archive hash is recorded
as additional evidence; if packaging metadata ever makes that container
nondeterministic, the difference must be documented while the unpacked
inventory remains identical. No difference is silently waived.

The release documentation command normalizes presentation-only Makeup delimiter
prefixes. EPUB is excluded from the reproducibility claim because ExDoc assigns
it a random UUID; HTML and Markdown remain the published candidate formats.
This normalization does not alter code examples, package code, tests, gallery
behavior, consumer behavior, or application state.
