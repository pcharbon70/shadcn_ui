---
id: shadcn_ui.waive_independent_review_1_0_release
status: accepted
date: 2026-09-04
affects:
  - shadcn_ui.release_publication
---

# Waive Independent Source Review For The 1.0.0 Release

## Context

Qualification PR #52 was authored and merged by `pcharbon70` without a review.
Its complete automated workflow passed before merge, and the exact merge commit
later passed the main-branch workflow, but neither result is an independent
source approval. The release owner has explicitly chosen to accept that review
risk for the first public Hex release.

## Decision

The independent-source-review gate is waived and non-mandatory for `1.0.0`
only.

- No independent review was performed, and the gate remains `waived`, never
  `passed` or `approved`.
- The waiver is tied to PR #52 head
  `fa56572ca9e72c04c29ae17b6df4821c1835ebd4` and the release owner's signed
  GitHub comment on that PR.
- The release owner accepts the risk that a human reviewer did not inspect the
  complete qualification diff, package boundary, metadata, archive inventory,
  accessibility limitation, or publication plan before merge.
- The waiver does not replace or weaken exact-main CI, final clean-build
  reproducibility, archive audit, isolated consumption, final publication
  authorization, public verification, or tag identity.
- A later release must record its own source-review disposition; this exception
  is not a general no-review policy.

## Consequences

Phase 3 may select the already merged candidate after its merge identity and
exact-main CI are verified. Release records must continue to expose the absent
review and accepted risk, and no document may describe PR #52 as independently
reviewed or approved.
