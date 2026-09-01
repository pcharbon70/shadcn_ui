# Pinned gallery presentation and visual evidence

```spec-meta
id: shadcn_ui.gallery_presentation
kind: application
status: active
summary: Pinned Unscripted-style documentation presentation, closed authored metadata, deterministic local visual evidence, and complete gallery migration without changing package semantics.
decisions:
  - shadcn_ui.pinned_gallery_presentation_parity
  - shadcn_ui.gallery_static_publication
  - shadcn_ui.catalogue_driven_documentation
  - shadcn_ui.versioned_gallery_publication
  - shadcn_ui.upstream_provenance
surface:
  - demo/**
  - .spec/planning/milestone-g-unscripted-style-gallery-presentation-parity/**
  - playwright.milestone-g-*.config.mjs
  - test/shadcn_ui/milestone_g_phase1_acceptance_test.exs
  - test/browser/milestone-g-*.spec.mjs
  - test/browser/milestone-g-*.spec.mjs-snapshots/**
```

## Requirements

```spec-requirements
- id: shadcn_ui.gallery_presentation.pinned_reference
  statement: Gallery presentation shall target the accepted exact unscripted/ui revision, reviewed source paths and checked local evidence rather than a moving public site or automatic upstream synchronization.
  priority: must
  stability: stable

- id: shadcn_ui.gallery_presentation.shell
  statement: The gallery shall provide a compact sticky ShadcnUI header, constrained desktop documentation grid, sticky independently scrolling catalogue, min-width-safe article, complete native mobile navigation and secondary immutable build metadata using the accepted reference geometry and documented exceptions.
  priority: must
  stability: evolving

- id: shadcn_ui.gallery_presentation.progressive_navigation
  statement: Skip link, named navigation, breadcrumb, one main landmark, visible focus, current-page state, component search and every ordinary destination shall remain complete without demo JavaScript, while mobile navigation uses honest native disclosure rather than unsupported menu or dialog claims.
  priority: must
  stability: stable

- id: shadcn_ui.gallery_presentation.presentation_system
  statement: Gallery-only local typography, prose, capability badges, specimens, escaped source, support tables and metadata shall form one reusable scoped presentation system with deterministic assets, no unrestricted reset and no package utility or runtime surface.
  priority: must
  stability: evolving

- id: shadcn_ui.gallery_presentation.article_hierarchy
  statement: Every component article shall lead with its title and concise value proposition, pair each rendered specimen with its compile-checked HEEx source, and then present how it works, accessibility, exact fallback, application ownership and provenance in a consistent heading order.
  priority: must
  stability: evolving

- id: shadcn_ui.gallery_presentation.specimen_semantics
  statement: Preview and Code selection shall use the accepted labelled native radio contract without tab roles, keep both addressable regions in source order and preserve direct-fragment, print, CSS-disabled and no-script access; optional copy feedback remains demo-only.
  priority: must
  stability: stable

- id: shadcn_ui.gallery_presentation.catalogue_metadata
  statement: The closed documentation catalogue shall author concise introductions, capability identities, how-it-works points, support rows, exact fallbacks, named specimens and upstream or local-exception identities, and shall separately record authored-ready, migrated, visually reviewed and accepted states without resolving request, fragment, feature, layout or search text into executable identities.
  priority: must
  stability: stable

- id: shadcn_ui.gallery_presentation.stable_identity
  statement: Existing category and component routes, canonical identities, breadcrumbs and example fragments shall remain stable while visible ordering, labels and presentation migrate.
  priority: must
  stability: stable

- id: shadcn_ui.gallery_presentation.visual_evidence
  statement: Checked local evidence shall hash the pinned inputs and record deterministic light and dark reference states at 1440x1200, 1024x1366, 390x844 and 320x568 with theme, scale, font, motion, open state, scroll position, geometry and accepted tolerances, without remote access during verification.
  priority: must
  stability: evolving

- id: shadcn_ui.gallery_presentation.local_assets
  statement: Fonts, icons, highlighting and reference artifacts shall be local, hash-pinned, licensed, reproducible and excluded from package contents; unavailable display assets shall use the documented system fallback rather than a remote request.
  priority: must
  stability: stable

- id: shadcn_ui.gallery_presentation.semantic_exceptions
  statement: ShadcnUI branding, Phoenix HEEx and accepted native component contracts shall override conflicting upstream presentation claims, and every intentional difference shall be documented instead of gaining richer ARIA, keyboard, state or runtime behavior for visual similarity.
  priority: must
  stability: stable

- id: shadcn_ui.gallery_presentation.accessibility_matrix
  statement: Presentation acceptance shall retain keyboard, visible-focus, pinned axe, 200 percent zoom, narrow width, forced-colors, reduced-motion, CSS-disabled and no-script coverage in both themes while keeping source order and landmarks independent of cosmetic classes.
  priority: must
  stability: evolving

- id: shadcn_ui.gallery_presentation.deterministic_distribution
  statement: Identical inputs shall produce byte-identical local assets, canonical search, sitemap and completeness outputs, and repository-subpath-safe static exports with no remote runtime dependency, new package release content or implied promotion from local evidence to CI, deployment or manual acceptance.
  priority: must
  stability: stable

- id: shadcn_ui.gallery_presentation.complete_migration
  statement: Milestone completion shall require the accepted presentation system on every component, composition, category, landing and documentation route, with complete catalogue metadata or an explicit reviewed exception and no regression of Milestones A through F.
  priority: must
  stability: evolving
```

## Verification

Targets are assigned by the Milestone G coverage map. A listed later-phase
target is planned proof, not evidence that the migration or publication exists.

```spec-verification
- kind: test_file
  target: demo/test/milestone_g_phase1_reference_test.exs
  covers:
    - shadcn_ui.gallery_presentation.pinned_reference
    - shadcn_ui.gallery_presentation.visual_evidence
    - shadcn_ui.gallery_presentation.local_assets
    - shadcn_ui.gallery_presentation.semantic_exceptions

- kind: test_file
  target: test/shadcn_ui/milestone_g_phase1_acceptance_test.exs
  covers:
    - shadcn_ui.gallery_presentation.pinned_reference
    - shadcn_ui.gallery_presentation.local_assets
    - shadcn_ui.gallery_presentation.deterministic_distribution

- kind: test_file
  target: test/browser/milestone-g-shell.spec.mjs
  covers:
    - shadcn_ui.gallery_presentation.shell
    - shadcn_ui.gallery_presentation.progressive_navigation
    - shadcn_ui.gallery_presentation.stable_identity
    - shadcn_ui.gallery_presentation.accessibility_matrix

- kind: test_file
  target: test/browser/milestone-g-presentation.spec.mjs
  covers:
    - shadcn_ui.gallery_presentation.presentation_system
    - shadcn_ui.gallery_presentation.specimen_semantics
    - shadcn_ui.gallery_presentation.visual_evidence
    - shadcn_ui.gallery_presentation.accessibility_matrix

- kind: test_file
  target: demo/test/milestone_g_phase4_article_test.exs
  covers:
    - shadcn_ui.gallery_presentation.article_hierarchy
    - shadcn_ui.gallery_presentation.specimen_semantics
    - shadcn_ui.gallery_presentation.stable_identity

- kind: test_file
  target: test/browser/milestone-g-article.spec.mjs
  covers:
    - shadcn_ui.gallery_presentation.article_hierarchy
    - shadcn_ui.gallery_presentation.specimen_semantics
    - shadcn_ui.gallery_presentation.stable_identity
    - shadcn_ui.gallery_presentation.accessibility_matrix

- kind: test_file
  target: demo/test/milestone_g_phase5_accordion_test.exs
  covers:
    - shadcn_ui.gallery_presentation.article_hierarchy
    - shadcn_ui.gallery_presentation.catalogue_metadata
    - shadcn_ui.gallery_presentation.stable_identity
    - shadcn_ui.gallery_presentation.visual_evidence
    - shadcn_ui.gallery_presentation.semantic_exceptions

- kind: test_file
  target: test/browser/milestone-g-accordion-visual.spec.mjs
  covers:
    - shadcn_ui.gallery_presentation.shell
    - shadcn_ui.gallery_presentation.presentation_system
    - shadcn_ui.gallery_presentation.visual_evidence
    - shadcn_ui.gallery_presentation.accessibility_matrix

- kind: test_file
  target: test/browser/milestone-g-accordion-acceptance.spec.mjs
  covers:
    - shadcn_ui.gallery_presentation.article_hierarchy
    - shadcn_ui.gallery_presentation.specimen_semantics
    - shadcn_ui.gallery_presentation.stable_identity
    - shadcn_ui.gallery_presentation.accessibility_matrix
    - shadcn_ui.gallery_presentation.semantic_exceptions

- kind: test_file
  target: demo/test/milestone_g_catalogue_test.exs
  covers:
    - shadcn_ui.gallery_presentation.article_hierarchy
    - shadcn_ui.gallery_presentation.catalogue_metadata
    - shadcn_ui.gallery_presentation.stable_identity
    - shadcn_ui.gallery_presentation.complete_migration

- kind: test_file
  target: test/shadcn_ui/milestone_g_acceptance_test.exs
  covers:
    - shadcn_ui.gallery_presentation.semantic_exceptions
    - shadcn_ui.gallery_presentation.deterministic_distribution
    - shadcn_ui.gallery_presentation.complete_migration
```
