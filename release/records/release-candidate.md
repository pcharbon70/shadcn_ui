# Public `1.0.0` release candidate record

## Decision

Status: **BLOCKED — not qualified**.

The implementation, current local package and demo acceptance, SpecLed checks,
owner-authorized `1.0.0` Fly deployment, canonical smoke, and deployed Chromium
smoke pass. The public-release Phase 1 source-boundary, metadata, authenticated
Hex identity, package-name availability, and pinned-input preflight also pass.
Qualification is still blocked because the actual `1.0.0` archive,
isolated consumer, two exact-toolchain reproducible builds, independent source
approval, final-revision CI, merge, Hex publication, and public tag remain
pending. All six human accessibility scenarios also remain unexecuted, but are
explicitly waived and non-mandatory for `1.0.0`.
`release/candidate-status.json` is the machine-readable source for this
decision; pending or failed mandatory gates always override narrative success
language.

## Recorded evidence

- Phase 1 started from synchronized main
  `42227ebb2892f0b98d0204786c616d0641497c3f`. Its 34-file change inventory
  contains only specification/planning, release evidence, validators, and
  tests, so no replacement Fly deployment is required. The authenticated
  personal Hex identity is `pcharbon70`, the registry reported no existing
  `shadcn_ui` package, and the complete pinned input verifier passed. See
  `release/public-release-preflight.json`.
- The current evidence working tree is based on committed deployment source
  `8654f6a4500ce210682d7cae7453553d878a714c`; later evidence changes do not
  relabel that immutable deployed source.
- No actual `1.0.0` archive or isolated-consumer evidence is recorded yet. The
  earlier 63-entry local archive and consumer trial belong to `0.1.0` and do
  not qualify the public target.
- Compiled CSS SHA-256:
  `ed0768e9582e980f3fd1b3ca0076afc573fc269514f527aef9dc942d1f8e9f41`.
- Historical Phase 6 evidence recorded a 62-entry archive and a passing
  three-test isolated consumer at source `3ef5f82e...`; that revision is no
  longer retrievable from current repository history and cannot qualify HEAD.
- Locked three-engine compatibility and automated accessibility remain passing
  implementation evidence. Current local SpecLed validation passed with zero
  findings; those results do not complete human review or final CI.
- Fly release `rel_76njzd0doog3yko3` serves exact revision
  `8654f6a4500ce210682d7cae7453553d878a714c` with package and demo identity
  `1.0.0` from image digest
  `sha256:0f1005b6a445b9585ad7eb0b3dc71458b625f1ef6547254cbcdab8147d0fc23d`.
  Service health, canonical smoke, and the two-test deployed Chromium check
  pass; see `release/fly-deployment-evidence.json`.

No current archive hash is authoritative until two clean pinned-toolchain
builds produce equivalent `1.0.0` evidence.

## Blocking and separate gates

- Public release Phase 1 preflight: passed, mandatory. This is metadata and
  authority evidence only, not candidate qualification or publication.
- Exact-current-revision two-build reproducibility, actual archive audit, and
  isolated consumer trial: pending, mandatory.
- Human accessibility scenarios: six pending and unassessed, but explicitly
  waived and non-mandatory for `1.0.0`; no WCAG, accessibility-certification,
  physical-device, or assistive-technology support claim is made.
- CI on the final revision: pending, mandatory. The earlier version PR failed
  its rendered R5 comparison; the same R5 checks pass locally, but no CI result
  exists for the deployed correction.
- Independent deployment source approval: pending, mandatory. The owner
  explicitly authorized deployment, but no current PR or independent approval
  is recorded.
- SpecLed: passing locally with zero errors, warnings, or branch findings for
  the deployment source; final merged-source CI remains independent.
- Fly deployment, canonical post-deploy smoke, deployed 320px geometry, direct
  fragments, category route, themes, and response hashes: passed for exact
  recorded source. Final-revision CI, independent approval, and merge remain
  separate pending states.
- Hex publication and a public version tag: pending mandatory gates.
  Marketplace listing, consumer-platform certification, and official
  Unscripted affiliation remain not applicable and are not implied.

## Rollback and identity

Rollback means restoring the previous reviewed commit and its matching compiled
stylesheet, rebuilding the consuming application, and rerunning its smoke tests.
Never edit an archive, cached stylesheet, or deployed gallery artifact in
place. Package and gallery rollback are independent. See `docs/upgrading.md`
for version decisions and migration evidence required by future breaking API,
token, CSS, capability, or archive changes.
