# Internal `0.1.0` candidate record

## Decision

Status: **BLOCKED — not qualified**.

Local evidence proves that committed inputs can build an audited archive and
that a separate Phoenix project can install that archive from a signed local
Hex repository. It does not satisfy the remaining mandatory human, CI,
integration, and SpecLed gates. `release/candidate-status.json` is the
machine-readable source for this decision; pending or failed mandatory gates
always override narrative success language.

## Recorded evidence

- Clean build source: `a0a95ee93119d97820b4246d70ac2b6207de2817`.
- Candidate archive SHA-256:
  `b5c434e0b1959cd31aab3d75684a7c65aab3b19c394ee36d8c634549448766a7`.
- Compiled CSS SHA-256:
  `d2128dd4b653375bab27d6bc070e1ef2c0ca11dd39a183ce6ab9e63eaf8047d8`.
- Actual archive allowlist: 62 entries; gallery export smoke: 634 routes and
  three local assets; consumer trial: 3 tests passed outside the source tree.
- Locked three-engine compatibility and automated accessibility evidence passed
  in Phase 4. Those results do not complete human accessibility review.

The hashes above identify the Section 5.1/5.2 rehearsal archive. Section 5.4
must rebuild the final Phase 5 revision twice and supersede these values before
qualification can be reconsidered.

## Blocking and separate gates

- Phase 5 two-build reproducibility and complete release integration: pending,
  mandatory.
- Human accessibility scenarios: six pending, mandatory before qualification;
  no WCAG or assistive-technology certification is claimed.
- CI on the final revision: pending, mandatory.
- SpecLed main/HEAD runner: known nested-login-shell failures remain unresolved;
  direct equivalent checks do not mark that runner passed.
- Merge, gallery deployment, and canonical post-deploy smoke: pending later
  publication gates and recorded separately from local package acceptance.
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
