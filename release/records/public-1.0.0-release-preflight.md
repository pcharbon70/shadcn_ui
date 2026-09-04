# Public `1.0.0` release preflight

## Section 1.1 - Candidate boundary

Phase 1 started from clean, synchronized `main` at
`42227ebb2892f0b98d0204786c616d0641497c3f` on branch
`codex/public-1-0-0-release-phase-1`. The release target is public Hex package
`shadcn_ui` version `1.0.0`, with `pcharbon70` as release owner and intended
personal Hex account; Section 1.2 records the authenticated identity check.
There is no Hex organization target.

The required independent review method is an approving GitHub review by a
reviewer other than the change author. A merge, comment, local check, or earlier
pull request does not substitute for that approval.

The source-boundary inventory compares deployed revision
`8654f6a4500ce210682d7cae7453553d878a714c` through the synchronized branch base.
It contains 7 commits and 34 changed files. The ordered file-list SHA-256 is
`9a7de94adecb93f4db0c2c776920a769f67a5006d25367f4cb12b05246e5f1ec`;
the complete list is retained in `release/public-release-preflight.json`.

Every change is specification/planning, release/deployment evidence,
verification tooling, or test content. No package module, compiled package CSS,
gallery runtime/template/asset, version metadata, dependency manifest, or
dependency lock changed. A replacement Fly deployment is therefore not
required by this inventory. Phase 4 must still recheck the current public
`1.0.0` identity and canonical smoke before publication.

The section began with a clean working tree. No generated archive,
documentation build, credential, or secret evidence file is tracked.

Sections 1.2 and 1.3 remain pending. This record neither qualifies nor
publishes the release.

## Section 1.2 - Metadata and authority

At `2026-09-04T12:07:17Z`, the manifest-pinned Elixir `1.20.3`, OTP `29`
(ERTS `17.0.5`), Mix `1.20.3`, Hex `2.5.1`, Node `22.13.1`, npm `10.9.2`, and
reviewed rebar3 SHA-256 were active. `node scripts/check-candidate-inputs.mjs`
passed all toolchain, dependency-lock, browser-input, and provenance-linkage
checks. No toolchain mismatch remains for this section.

The earlier browser evidence retained a pre-`1.0.0` demo lock hash. The current
lock differs from the later three-engine regression source only in the root
demo version fields (`0.1.0` to `1.0.0`), without a dependency or behavior
change. `release/browser-evidence-inputs.json` records that relationship and
binds the candidate input checker to the current lock without relabelling the
historical outcomes. Phase 2 browser acceptance remains pending and mandatory.

Package metadata consistently selects `shadcn_ui 1.0.0`, MIT licensing, the
complete third-party notices and provenance, the public gallery and repository
links, an unreleased changelog entry, and a README that says the package is not
yet published. Release guidance preserves the six human scenarios as pending
and waived, never passed or conformant.

The installed Hex client authenticated as intended personal account
`pcharbon70`. The official registry query returned
`No package with name shadcn_ui`; there is no organization target. This is a
passing new-personal-package authority preflight. The supported publish dry run
in Phase 5 must recheck final server authorization and package-name
availability before any irreversible command.

No Hex API key or other credential value was printed into or stored by this
record. Section 1.3 and every later release gate remain pending.

## Section 1.3 - Pre-publication ledger reconciliation

Phase 1 is complete and the `public-release-phase-1-preflight` mandatory gate
is `passed`. The source boundary is recorded in Section 1.1 commit
`7ba93b6ee329e1b358ca1d3821bc2e3d0379ddec`; metadata, registry authority, and
candidate inputs are recorded in Section 1.2 commit
`20ff997ad653f5f3812927f26c516f793aa127f3`. This section is recorded in its
containing commit because a commit cannot truthfully contain its own ID.

Candidate qualification remains **blocked**. The exact `1.0.0` clean candidate,
actual archive consumer, exact-final-main SpecLed/CI, independent source
approval, qualification merge, Hex publication, and `v1.0.0` tag gates remain
pending and mandatory. Phase 1 creates no archive, publishes nothing, and does
not select `RELEASE_SHA`.

All six human accessibility scenarios remain `PENDING` and unassessed. Their
gate remains `mandatory: false` and `waived` for `1.0.0`, with no WCAG,
certification, physical-device, or assistive-technology support claim.

The current Fly deployment and canonical smoke remain separate passing
evidence. The Phase 1 inventory requires no replacement deployment; Phase 4
must still recheck public identity and smoke before publication.

The exact candidate-input check, 20 focused release tests, pinned gallery
determinism, `mix spec.next`, strict `mix spec.check --base origin/main`, and
`git diff --check` pass. SpecLed reports zero errors, warnings, or branch
findings. An initial SpecLed attempt inherited unpinned Node `24.3.0` and failed
gallery determinism; the same gallery check and strict SpecLed run passed after
all manifest-pinned runtimes were selected. The unpinned attempt is retained as
a diagnostic, not qualifying evidence. These phase-ending results apply only
to this branch and do not satisfy the final merged-source or CI gates.
