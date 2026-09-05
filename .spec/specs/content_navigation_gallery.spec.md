# Milestone C content and navigation gallery acceptance

```spec-meta
id: shadcn_ui.content_navigation_gallery
kind: application
status: active
summary: Disclosure, Navigation, and Content Surfaces catalogue, compositions, fallback evidence, and Milestone C acceptance.
decisions:
  - shadcn_ui.native_disclosure_grouping
  - shadcn_ui.destination_navigation_landmarks
  - shadcn_ui.native_scroll_sticky_surfaces
  - shadcn_ui.radio_panels_not_tabs
  - shadcn_ui.gallery_static_publication
surface:
  - demo/**
  - test/browser/milestone-c-content-navigation.spec.mjs
  - test/browser/milestone-g-remediation-r4.spec.mjs
  - test/shadcn_ui/milestone_c_acceptance_test.exs
  - test/shadcn_ui/milestone_b_documentation_test.exs
  - test/shadcn_ui/milestone_c_documentation_test.exs
  - README.md
```

## Project identity boundary

ShadcnUI is a personal MIT-licensed project. Repository ownership, package
scope, schema identifiers, and the canonical Fly hostname are publication
identity only; they do not alter this subject's requirements, semantics,
runtime boundary, package contents, or existing verification.

## Requirements

```spec-requirements
- id: shadcn_ui.content_gallery.catalog
  statement: The gallery shall add stable Disclosure, Navigation, and Content Surfaces categories with dedicated Accordion, Navigation Menu, Header, Section Header, Scroll Area, Separator, and Radio Panels pages through the closed catalogue, static route inventory, and sitemap.
  priority: must
  stability: evolving

- id: shadcn_ui.content_gallery.states
  statement: Component pages shall demonstrate applicable independent, exclusive, open, closed, current, static, sticky, overflow-axis, focusable, semantic, decorative, selected, disabled, enhanced, and fallback snapshots without implying package-owned transitions.
  priority: must
  stability: evolving

- id: shadcn_ui.content_gallery.compositions
  statement: The gallery shall provide realistic controller-rendered documentation, settings, and application-shell pages that compose Milestones A, B, and C using caller-owned fixtures and no domain or transport behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.content_gallery.semantic_guidance
  statement: Guidance shall explain native disclosure, destination navigation, landmark naming, current-location ownership, scroll focus, sticky fallback, semantic versus decorative separation, and the distinction among navigation links, Radio Panels, and true tabs in plain language.
  priority: must
  stability: stable

- id: shadcn_ui.content_gallery.fallbacks
  statement: Gallery examples shall expose independent disclosure when exclusive grouping is unsupported, normal-flow headers when sticky or anchor positioning is unavailable, native scrolling without edge affordances, and fully visible Radio Panels content without enhancement CSS or JavaScript.
  priority: must
  stability: stable

- id: shadcn_ui.content_gallery.content_stress
  statement: Examples shall cover narrow and wide layouts, horizontal and vertical overflow, long and translated text, nested content, fragment destinations, 200 percent zoom, forced colors, reduced motion, light and dark themes, and keyboard-only and no-script operation.
  priority: must
  stability: evolving

- id: shadcn_ui.content_gallery.browser_behavior
  statement: Browser tests shall verify native summary activation, exclusive and fallback disclosure, find-in-page access, ordinary link keys and destinations, current-location semantics, scroll operation and focus policy, sticky fallback, native radio keys, complete panel access, and absence of menu, tab, router, or package-owned client behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.content_gallery.release_boundary
  statement: Milestone C demo behavior, browser tests, source examples, and export artifacts shall remain outside package release contents while every substantially adapted component and CSS block receives pinned provenance and public documentation.
  priority: must
  stability: stable
```

## Verification

Selecting `1.0.0` as the first public package version changes release identity
only; it does not change this subject's gallery inventory or proof.

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's gallery contract.

The internal-record reorganization changes documentation paths only. Content,
navigation, gallery behavior and executable proof are unchanged.

Milestone G Phase 4 adds native Preview/Code radios around component examples.
Milestone C browser evidence therefore scopes its Radio Panels count to the
rendered component while retaining CSS-disabled access to both documentation
views and every component panel.
Remediation R4 verifies that mobile component search remains discoverable only
after opening the honest native navigation disclosure and retains the current
ordinary destination at the two narrow acceptance widths.

```spec-verification
- kind: test_file
  target: demo/test/shadcn_ui_demo/content_navigation_catalog_test.exs
  covers:
    - shadcn_ui.content_gallery.catalog
    - shadcn_ui.content_gallery.states
    - shadcn_ui.content_gallery.semantic_guidance
    - shadcn_ui.content_gallery.fallbacks

- kind: test_file
  target: demo/test/shadcn_ui_demo/content_navigation_compositions_test.exs
  covers:
    - shadcn_ui.content_gallery.compositions
    - shadcn_ui.content_gallery.content_stress
    - shadcn_ui.content_gallery.release_boundary

- kind: test_file
  target: test/browser/milestone-c-content-navigation.spec.mjs
  covers:
    - shadcn_ui.content_gallery.states
    - shadcn_ui.content_gallery.fallbacks
    - shadcn_ui.content_gallery.content_stress
    - shadcn_ui.content_gallery.browser_behavior

- kind: test_file
  target: test/shadcn_ui/milestone_c_acceptance_test.exs
  covers:
    - shadcn_ui.content_gallery.catalog
    - shadcn_ui.content_gallery.states
    - shadcn_ui.content_gallery.compositions
    - shadcn_ui.content_gallery.semantic_guidance
    - shadcn_ui.content_gallery.fallbacks
    - shadcn_ui.content_gallery.content_stress
    - shadcn_ui.content_gallery.browser_behavior
    - shadcn_ui.content_gallery.release_boundary

- kind: test_file
  target: test/browser/milestone-g-remediation-r4.spec.mjs
  covers:
    - shadcn_ui.content_gallery.content_stress
    - shadcn_ui.content_gallery.browser_behavior
```

The root README's publication and navigation correction is cross-renderer
documentation only. Explicit versioned HexDocs and GitHub destinations replace
renderer-dependent relative links; no content/navigation gallery contract changes.
