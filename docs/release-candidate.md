# Internal `0.1.0` candidate record

## Decision

Status: **BLOCKED — not qualified**.

The implementation, recorded local automated acceptance, SpecLed checks,
owner-authorized Fly deployment, canonical smoke, and deployed Chromium smoke
pass. Qualification is still blocked because the exact current revision needs
two clean reproducible candidate builds, all six human accessibility scenarios
remain pending, no independent source approval is recorded, and CI has not yet
run on the final evidence-only PR revision. The current isolated
archive-consumer trial passes. `release/candidate-status.json` is the
machine-readable source for this decision; pending or failed mandatory gates
always override narrative success language.

## Recorded evidence

- The reconciled working tree is based on merged main revision
  `380f861985e05ea7de6bee1e7f261621ef968223`; it has no committed exact source
  identity yet.
- Its local archive build has SHA-256
  `e9a757388369dfba10171629d8e1f3d5bcbd2413b6c176fe7ed38c4bebc80e73`
  and 63 allowlisted entries, including the complete `LICENSE`. This is an
  audited local build, not the required two-build reproducibility result.
- Compiled CSS SHA-256:
  `ed0768e9582e980f3fd1b3ca0076afc573fc269514f527aef9dc942d1f8e9f41`.
- Historical Phase 6 evidence recorded a 62-entry archive and a passing
  three-test isolated consumer at source `3ef5f82e...`; that revision is no
  longer retrievable from current repository history and cannot qualify HEAD.
- The current 63-entry archive compiles in an isolated Phoenix consumer, passes
  three tests and browser acceptance, serves its packaged stylesheet, and
  requires neither a path dependency nor package JavaScript. See
  `release/consumer-trial-evidence.json`.
- Locked three-engine compatibility, automated accessibility, and current
  SpecLed evidence pass. Those results do not complete human review or final CI.
- Fly release `rel_krm823exwop9zxw4` serves exact reviewed-workflow revision
  `c08761f69429f88858a891584bc3962bd3109fe5` from image digest
  `sha256:a7b6e6753075234c6760309f99c926be53f4aafee6e270088a0a95df6fc5e4cb`.
  Initial PR CI, service health, canonical smoke, the two-test deployed
  Chromium check, and seven response hashes pass; see
  `release/fly-deployment-evidence.json`.

The current archive hash is provisional until two clean pinned-toolchain builds
produce equivalent evidence.

## Blocking and separate gates

- Exact-current-revision two-build reproducibility: pending, mandatory. The
  archive-consumer trial passes independently.
- Human accessibility scenarios: six pending, mandatory before qualification;
  no WCAG or assistive-technology certification is claimed.
- CI on the final revision: pending, mandatory. Initial PR CI passed at the
  exact deployed revision before the evidence-only commits.
- Independent deployment source approval: pending, mandatory. PR #43 was open,
  owner-authorized, and green before deployment, but no independent approval is
  recorded.
- SpecLed: passing locally with zero errors, warnings, or branch findings;
  final-revision CI remains independent.
- Fly deployment, canonical post-deploy smoke, deployed 320px geometry, direct
  fragments, category route, themes, and response hashes: passed for exact
  recorded source. Final-revision CI, independent approval, and merge remain
  separate pending states.
- Hex publication, a public version tag, marketplace listing, consumer-platform
  certification, and official Unscripted affiliation: not applicable and not
  authorized for this internal candidate.

## Rollback and identity

Rollback means restoring the previous reviewed commit and its matching compiled
stylesheet, rebuilding the consuming application, and rerunning its smoke tests.
Never edit an archive, cached stylesheet, or deployed gallery artifact in
place. Package and gallery rollback are independent. See `docs/upgrading.md`
for version decisions and migration evidence required by future breaking API,
token, CSS, capability, or archive changes.
