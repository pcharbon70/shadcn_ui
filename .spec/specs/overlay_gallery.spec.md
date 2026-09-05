# Milestone D overlay gallery and acceptance

```spec-meta
id: shadcn_ui.overlay_gallery
kind: application
status: active
summary: Overlay catalogue, cross-engine capability evidence, interaction fixtures, fallback guidance, and Milestone D acceptance.
decisions:
  - shadcn_ui.native_overlay_platform_runtime
  - shadcn_ui.dialog_modality_focus_dismissal
  - shadcn_ui.popover_positioning_actions
  - shadcn_ui.supplemental_surface_boundary
  - shadcn_ui.gallery_static_publication
surface:
  - demo/**
  - test/browser/milestone-d-*.spec.mjs
  - test/shadcn_ui/milestone_d_acceptance_test.exs
  - README.md
```

## Project identity boundary

ShadcnUI is a personal MIT-licensed project. Repository ownership, package
scope, schema identifiers, and the canonical Fly hostname are publication
identity only; they do not alter this subject's requirements, semantics,
runtime boundary, package contents, or existing verification.

## Requirements

```spec-requirements
- id: shadcn_ui.overlay_gallery.catalog
  statement: The gallery shall add stable Overlays and Interactive Surfaces categories with dedicated Dialog, Alert Dialog, Drawer, Popover, Dropdown Actions, Tooltip, and Hover Card pages through the closed catalogue, route inventory, export, and sitemap.
  priority: must
  stability: evolving

- id: shadcn_ui.overlay_gallery.states
  statement: Pages shall demonstrate closed, open through native invocation, closerequest, light-dismiss, explicit-close, cancel, consequential-action, logical edge, auto and manual popover, placement, fallback, hover, focus, long-content, and reduced-motion states without implying package-owned transitions.
  priority: must
  stability: evolving

- id: shadcn_ui.overlay_gallery.capability_matrix
  statement: The gallery shall publish an authored per-feature matrix covering commandfor, closedby, Popover, anchor positioning, position fallbacks, discrete transitions, and the deliberate exclusion of interest invokers, with authoritative source links, review date, and the exact locked Chromium, Firefox, and WebKit verification versions.
  priority: must
  stability: evolving

- id: shadcn_ui.overlay_gallery.compositions
  statement: The gallery shall provide deterministic settings-confirmation, responsive drawer, anchored action popover, and supplemental-help compositions using caller-owned fixtures with no persistence, authorization, domain operation, or transport-owned overlay state.
  priority: must
  stability: evolving

- id: shadcn_ui.overlay_gallery.fallbacks
  statement: Every page shall show the exact unsupported-browser ordinary destination or in-flow alternative plus no-anchor, no-transition, no-hover, coarse-pointer, CSS-disabled, no-script, and DOM-replacement guidance without demo shims labeled as package behavior.
  priority: must
  stability: stable

- id: shadcn_ui.overlay_gallery.browser_behavior
  statement: Locked browser tests shall verify native modal focus entry and containment, Tab order, Escape, closedby policy, backdrop and explicit close, focus restoration, Popover light dismiss and nesting, viewport placement, ordinary action controls, supplemental focus and hover, scroll, zoom, forced colors, and reduced motion.
  priority: must
  stability: evolving

- id: shadcn_ui.overlay_gallery.cross_engine_behavior
  statement: Cross-engine acceptance shall run the gallery in locked Chromium, Firefox, and WebKit projects, record exact versions and capability results, and exercise both native-enhanced and deliberately disabled-feature paths without browser-name sniffing.
  priority: must
  stability: evolving

- id: shadcn_ui.overlay_gallery.semantic_guidance
  statement: Guidance shall compare Dialog, Alert Dialog, Drawer, Popover, Dropdown Actions, Tooltip, Hover Card, ordinary links and buttons, ARIA menus, and deferred interest invokers in plain language with focus, dismissal, state, fallback, and application ownership.
  priority: must
  stability: stable

- id: shadcn_ui.overlay_gallery.release_boundary
  statement: Milestone D demo behavior, browser harnesses, capability reports, source examples, and exports shall remain outside release contents while every adapted component and CSS block receives pinned provenance and public documentation.
  priority: must
  stability: stable
```

## Verification

Selecting `1.0.0` as the first public package version changes release identity
only; it does not change this subject's gallery inventory or proof.

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's gallery contract.

The internal-record reorganization changes documentation paths only. Overlay
gallery behavior, capability evidence and executable proof are unchanged.

Milestone G Phase 4 groups accessibility, authored capability policy, exact
fallback, ownership, related controls, ordinary alternatives, and provenance
under stable requirement-level surfaces. Overlay browser checks no longer
depend on the former separated-source or subsection labels.

The closed catalogue now supplies five Overlays leaves and two Interactive
Surfaces leaves. Reference pages render actual components, inert HEEx source,
native policy/mode/edge examples and a complete visible alternative. Canonical
metadata is derived only from resolved catalogue paths; unknown/mismatched
routes remain nonreflecting 404s. Export allows ordinary authoritative links
and canonical metadata, never remote runtime assets.

The capability page combines package policy with a demo-only deterministic
observed-feature record from the locked three-engine matrix. Detection is
explicitly distinguished from behavior coverage; interest invokers remain
excluded even where detected. Four closed compositions use local native forms,
authored pending/rejection snapshots, nested Popover in Drawer, ordinary actions
and complete supplemental-help destinations without application operations.

Milestone exit runs the real gallery in all three engines, with pinned axe-core
audits of both themes and open native surfaces (settled colors), explicit identity,
relationship, keyboard, focus, replacement, viewport/RTL/zoom, forced-colors,
reduced-motion, no-script/touch, CSS-disabled and disabled-capability checks.
Package acceptance connects the public documented APIs, provenance, policy locks,
CI gates and runtime exclusions. Export checks each new route/theme, canonical
metadata, sitemap entry, ID uniqueness and nonreflecting 404 in the actual output.

```spec-verification
- kind: test_file
  target: demo/test/shadcn_ui_demo/overlay_catalog_test.exs
  covers:
    - shadcn_ui.overlay_gallery.catalog
    - shadcn_ui.overlay_gallery.states
    - shadcn_ui.overlay_gallery.semantic_guidance

- kind: test_file
  target: demo/test/shadcn_ui_demo/overlay_compositions_test.exs
  covers:
    - shadcn_ui.overlay_gallery.compositions
    - shadcn_ui.overlay_gallery.fallbacks
    - shadcn_ui.overlay_gallery.release_boundary

- kind: test_file
  target: test/browser/milestone-d-gallery.spec.mjs
  covers:
    - shadcn_ui.overlay_gallery.states
    - shadcn_ui.overlay_gallery.fallbacks
    - shadcn_ui.overlay_gallery.browser_behavior
    - shadcn_ui.overlay_gallery.semantic_guidance
    - shadcn_ui.overlay_gallery.capability_matrix
    - shadcn_ui.overlay_gallery.cross_engine_behavior

- kind: test_file
  target: test/shadcn_ui/milestone_d_acceptance_test.exs
  covers:
    - shadcn_ui.overlay_gallery.catalog
    - shadcn_ui.overlay_gallery.states
    - shadcn_ui.overlay_gallery.capability_matrix
    - shadcn_ui.overlay_gallery.compositions
    - shadcn_ui.overlay_gallery.fallbacks
    - shadcn_ui.overlay_gallery.browser_behavior
    - shadcn_ui.overlay_gallery.cross_engine_behavior
    - shadcn_ui.overlay_gallery.semantic_guidance
    - shadcn_ui.overlay_gallery.release_boundary
```

The root README's publication and navigation correction is cross-renderer
documentation only. Explicit versioned HexDocs and GitHub destinations replace
renderer-dependent relative links; no overlay-gallery contract changes.
