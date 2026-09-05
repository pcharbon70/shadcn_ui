# Milestone D Tooltip and Hover Card supplemental surfaces

```spec-meta
id: shadcn_ui.supplemental_surfaces
kind: package
status: active
summary: CSS-first nonessential Tooltip and Hover Card rendering and fallback contracts.
decisions:
  - shadcn_ui.native_overlay_platform_runtime
  - shadcn_ui.supplemental_surface_boundary
  - shadcn_ui.semantic_component_api_and_accessibility
  - shadcn_ui.progressive_enhancement_baseline
surface:
  - lib/shadcn_ui/components/overlays/supplemental_contract.ex
  - lib/shadcn_ui/components/overlays/tooltip.ex
  - lib/shadcn_ui/components/overlays/hover_card.ex
  - test/shadcn_ui/components/overlays/tooltip_test.exs
  - test/shadcn_ui/components/overlays/hover_card_test.exs
  - test/browser/milestone-d-supplemental-surfaces.spec.mjs
  - test/fixtures/milestone_d_supplemental_surfaces.html
  - scripts/render-supplemental-fixture.exs
  - test/browser/configs/playwright.milestone-d-phase5.config.mjs
  - README.md
```

## Project identity boundary

ShadcnUI is a personal MIT-licensed project. Repository ownership, package
scope, schema identifiers, and the canonical Fly hostname are publication
identity only; they do not alter this subject's requirements, semantics,
runtime boundary, package contents, or existing verification.

## Requirements

```spec-requirements
- id: shadcn_ui.supplemental.tooltip
  statement: Tooltip shall relate one short escaped text description to one natively focusable caller trigger through deterministic aria-describedby identity and render a nonfocusable role tooltip bubble containing no interactive descendants.
  priority: must
  stability: evolving

- id: shadcn_ui.supplemental.tooltip_fallback
  statement: Tooltip content shall be supplemental rather than the only label, instruction, error, status, or task information; CSS-disabled or unsupported visual presentation shall retain the accessible description relationship and the complete trigger operation.
  priority: must
  stability: stable

- id: shadcn_ui.supplemental.hover_card
  statement: Hover Card shall supplement one ordinary caller-owned link with bounded trusted preview content while preserving the link's complete accessible name, destination, focus, activation, and external-link policy without requiring the preview.
  priority: must
  stability: evolving

- id: shadcn_ui.supplemental.hover_card_boundary
  statement: Hover Card shall contain no required action, workflow step, authorization result, or unique information and shall add no timers, interest events, long-press emulation, focus movement, or pointer-dependent application behavior.
  priority: must
  stability: stable

- id: shadcn_ui.supplemental.css_behavior
  statement: Tooltip and Hover Card visibility may use hover, focus-visible, and focus-within CSS plus capability-gated anchor positioning, while reduced motion removes delay and transition and coarse-pointer or unsupported environments retain the trigger and ordinary destination.
  priority: must
  stability: evolving

- id: shadcn_ui.supplemental.no_interest_claim
  statement: Milestone D shall emit no interestfor activation or claim popover hint, touch-interest, top-layer, or browser-managed interest behavior because those capabilities are not an interoperable Chromium, Firefox, and WebKit baseline.
  priority: must
  stability: stable

- id: shadcn_ui.supplemental.protected_semantics
  statement: Trigger identity, tooltip role, description relationship, native link destination, and noninteractive content boundary shall override conflicting caller globals while unrelated documented classes and globals pass through.
  priority: must
  stability: stable

- id: shadcn_ui.supplemental.shared_contract
  statement: Tooltip and Hover Card shall follow the shared component, overlay capability, theme, escaping, deterministic identity, reduced-motion, fallback, and application-ownership contracts.
  priority: must
  stability: stable
```

## Verification

Selecting `1.0.0` as the first public package version changes release identity
only; it does not change this subject's component behavior or proof.

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's component contract.

The internal-record reorganization changes documentation paths only. Tooltip
and Hover Card semantics, fallbacks and executable proof are unchanged.

Tooltip uses a single self-closing structured trigger slot (`label`, native
button/link attributes, class and unrelated globals), not caller-supplied nested
control markup. Its explicit `describedby` references are deduplicated before the
stable description ID is appended. Text strings remain escaped; raw safe tuples
and nested trigger content are rejected. Placement improves progressively from
normal flow to scoped CSS anchors on wide LTR fine-pointer layouts. RTL retains
normal flow because scoped RTL anchor coordinates are not interoperable in the
locked matrix. No browser-name branching is used. This contract
does not promise Escape dismissal or escape from overflow clipping.

Hover Card uses the same deterministic structured trigger, restricted to an
ordinary link. Trusted `inner_block` accepts a small presentation-only tag and
attribute vocabulary, rejecting interactive/focusable/fetching/stateful markup
without adding a runtime parser dependency. This is a composition guard, not an
untrusted-HTML sanitizer. Callers must enforce content completeness, nonessential
meaning, privacy and freshness; these cannot be inferred from rendered text.
Hover/focus-within keep its adjacent preview visible without intercepting the
link, client fetch, analytics or interest-invoker behavior.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/components/overlays/tooltip_test.exs
  covers:
    - shadcn_ui.supplemental.tooltip
    - shadcn_ui.supplemental.tooltip_fallback
    - shadcn_ui.supplemental.css_behavior
    - shadcn_ui.supplemental.no_interest_claim
    - shadcn_ui.supplemental.protected_semantics
    - shadcn_ui.supplemental.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/overlays/hover_card_test.exs
  covers:
    - shadcn_ui.supplemental.hover_card
    - shadcn_ui.supplemental.hover_card_boundary
    - shadcn_ui.supplemental.css_behavior
    - shadcn_ui.supplemental.no_interest_claim
    - shadcn_ui.supplemental.protected_semantics
    - shadcn_ui.supplemental.shared_contract

- kind: test_file
  target: test/browser/milestone-d-supplemental-surfaces.spec.mjs
  covers:
    - shadcn_ui.supplemental.tooltip
    - shadcn_ui.supplemental.tooltip_fallback
    - shadcn_ui.supplemental.hover_card
    - shadcn_ui.supplemental.hover_card_boundary
    - shadcn_ui.supplemental.css_behavior
    - shadcn_ui.supplemental.no_interest_claim

- kind: test_file
  target: test/shadcn_ui/milestone_d_acceptance_test.exs
  covers:
    - shadcn_ui.supplemental.tooltip
    - shadcn_ui.supplemental.tooltip_fallback
    - shadcn_ui.supplemental.hover_card
    - shadcn_ui.supplemental.hover_card_boundary
    - shadcn_ui.supplemental.css_behavior
    - shadcn_ui.supplemental.no_interest_claim
    - shadcn_ui.supplemental.protected_semantics
    - shadcn_ui.supplemental.shared_contract
```

The root README's publication and navigation correction is cross-renderer
documentation only. Explicit versioned HexDocs and GitHub destinations replace
renderer-dependent relative links; no supplemental-surface contract changes.
