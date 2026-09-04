---
id: shadcn_ui.waive_manual_accessibility_1_0_release
status: accepted
date: 2026-09-04
affects:
  - shadcn_ui.compatibility_accessibility
  - shadcn_ui.public_documentation
  - shadcn_ui.release_publication
---

# Waive Manual Accessibility Execution For The 1.0.0 Release

## Context

The automated accessibility, semantic, keyboard, fallback, responsive, theme,
forced-colors, reduced-motion, and locked-engine checks pass. The six bounded
human scenarios remain unexecuted, and the release owner has decided not to run
them for the first public Hex release.

## Decision

The manual-accessibility gate is waived and non-mandatory for `1.0.0` only.

- Every `MAN-*` scenario remains `PENDING`; the waiver is neither a pass nor a
  substitute observation.
- The release may qualify and publish without executing those scenarios once
  every other mandatory gate passes.
- Documentation must state that human assistive-technology, physical-touch,
  native high-contrast, and representative manual workflows were not assessed.
- No WCAG conformance, accessibility certification, or assistive-technology
  support claim follows from the waiver or the passing automated evidence.
- Automated accessibility and explicit browser assertions remain mandatory.
- The isolated Phoenix archive-consumer trial is unrelated to this waiver and
  remains mandatory.
- A later release must record its own manual-accessibility disposition; this
  exception does not silently become a general release policy.

## Consequences

Manual-accessibility execution no longer blocks `1.0.0`, while the unassessed
risk remains explicit and machine-readable. The release remains blocked by its
archive, isolated consumer, reproducibility, review, CI, merge, publication,
and tag gates until those states pass.
