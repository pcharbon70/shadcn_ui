# Incremental motion/media gallery and Milestone E acceptance

```spec-meta
id: shadcn_ui.motion_media_gallery
kind: application
status: active
summary: Accepted Milestone E contract; implementation and evidence are pending the phased plan.
decisions:
  - shadcn_ui.motion_media_gallery_delivery
  - shadcn_ui.motion_media_capability_css
  - shadcn_ui.native_carousel_cover_flow
  - shadcn_ui.bounded_motion
  - shadcn_ui.responsive_media_lightbox
surface:
  - demo/**
  - test/browser/milestone-e-*.spec.mjs
  - test/shadcn_ui/milestone_e_acceptance_test.exs
  - README.md
  - RELEASE.md
```

## Delivery and routes

New categories append to the existing catalogue. Media contains carousel,
cover-flow and image-gallery; Motion contains marquee, stagger and
scroll-indicator. Every reference lands with its component rather than waiting
for the last phase. Requests resolve through closed authored strings; unknown
and mismatched paths remain nonreflecting 404s.

Reference routes use /components/media/<slug> and /components/motion/<slug>.
Compositions are /examples/media-browser, /examples/image-gallery and
/examples/motion-preferences; evidence is /examples/motion-media-capabilities.
The substantial image-gallery page must render actual local images and native
lightbox controls, not just a source snippet or list of component names.

A closed motion query selects system or reduce with invalid input falling back
to system; system always respects the user's operating-system preference. Theme
and motion links preserve valid independent choices. No force-animation mode
exists. Export covers default and explicit light/dark scopes, reduced motion and
invalid-query defaults without changing canonical URLs.

## Fixtures, export, and evidence

A demo-only fixture manifest lists stable filename/key, MIME, dimensions,
license/origin, byte size and content hash. Use small authored/licensed local
fixtures and intentional missing/failed image cases. Do not depend on a remote
image CDN or copy upstream site artwork. Keep source examples inert.

Export retains its three selected CSS/JavaScript assets and adds only manifest-
selected media. Replace fixed total-asset-count assumptions with explicit
per-class expectations. Reject traversal, stale copied files, unknown extensions,
symlinks escaping the fixture root, mismatched hashes and remote runtime loads.
Verify every image/srcset reference under the deployed repository subpath.

The matrix distinguishes parsing from observed interaction and unavailable from
deliberately deferred features. Record exact browser locks, source review date,
reduced-motion output and fallback. No support claim is authored from a browser
brand alone. Phase tests exercise the real controller and exported artifacts.
Every phase updates documentation/provenance and retains earlier regressions.

## Publication status

Creating these specifications does not implement components or publish pages.
Milestone D's recorded local SpecLed runner issue remains an explicit environment
limitation, not an excuse to weaken the gate. The final release record must
distinguish direct tests, CI, manual checks and actual Pages publication.

## Requirements

```spec-requirements
- id: shadcn_ui.motion_media_gallery.incremental_catalog
  statement: Each implementation phase shall add its actual component reference through the closed catalogue, navigation, breadcrumb/current state, canonical route, export, sitemap and smoke inventory while preserving existing routes.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_gallery.references
  statement: Every new reference shall include working native examples, complete fallback, inert HEEx, API/slot guidance, keyboard/focus behavior, themes, motion suppression, image ownership, provenance and explicit application responsibility.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_gallery.compositions
  statement: The gallery shall provide complete media-browser, image-gallery and motion-preferences compositions using actual local fixtures and native components, without persistence, real operations or demo shims masquerading as package behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_gallery.capability_evidence
  statement: The capability page shall record authoritative sources, review date, exact locked three-engine versions, declaration and observed-behavior results, native fallbacks and deliberately deferred generated controls/origin effects without user-agent branching.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_gallery.motion_inspection
  statement: Ordinary gallery routes shall offer closed system/reduce motion inspection preserving theme choices and system reduced-motion priority, with deterministic safe invalid-input and no-script behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_gallery.fixture_manifest
  statement: Demo media shall be local, licensed or authored, dimensioned and hash-pinned through a closed fixture manifest with failed-image examples, and shall remain outside package releases.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_gallery.static_media
  statement: Static publication shall export exactly the selected style/script assets and manifest-listed media, verify all direct/subpath references and hashes, reject unexpected paths and remote runtime loads, and retain canonical URLs, sitemap, deterministic bytes and nonreflecting 404s.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_gallery.accessibility_matrix
  statement: Locked Chromium, Firefox and WebKit acceptance shall cover native keyboard/touch/focus, axe and explicit semantics, motion suppression, stationary/offscreen budgets, themes, zoom, narrow/wide layouts, RTL, forced colors, image failure, replacement, CSS-disabled, no-script and disabled-capability paths.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_gallery.release_acceptance
  statement: Milestone exit shall verify public APIs, all A–E gallery routes, package/demo precommit, locked builds, CSS isolation, provenance/notices, actual archive exclusions, deterministic export/subpath smoke, ExDoc, SpecLed and whitespace while separately recording manual and deployed evidence.
  priority: must
  stability: evolving
```

## Verification

The following targets are planned acceptance obligations, not existing passing
tests. The [Milestone E plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
assigns their implementation phases. Missing targets remain visible in SpecLed
until implemented; no placeholder passing test or disabled gate substitutes for
actual proof. Add requirement references in each target as the tests land.

```spec-verification
- kind: test_file
  target: demo/test/shadcn_ui_demo/motion_media_catalog_test.exs
  covers:
    - shadcn_ui.motion_media_gallery.incremental_catalog
    - shadcn_ui.motion_media_gallery.references
    - shadcn_ui.motion_media_gallery.motion_inspection

- kind: test_file
  target: demo/test/shadcn_ui_demo/motion_media_compositions_test.exs
  covers:
    - shadcn_ui.motion_media_gallery.compositions
    - shadcn_ui.motion_media_gallery.capability_evidence
    - shadcn_ui.motion_media_gallery.fixture_manifest

- kind: test_file
  target: demo/test/motion_media_export_test.exs
  covers:
    - shadcn_ui.motion_media_gallery.fixture_manifest
    - shadcn_ui.motion_media_gallery.static_media

- kind: test_file
  target: test/browser/milestone-e-gallery.spec.mjs
  covers:
    - shadcn_ui.motion_media_gallery.references
    - shadcn_ui.motion_media_gallery.compositions
    - shadcn_ui.motion_media_gallery.capability_evidence
    - shadcn_ui.motion_media_gallery.motion_inspection
    - shadcn_ui.motion_media_gallery.accessibility_matrix

- kind: test_file
  target: test/shadcn_ui/milestone_e_acceptance_test.exs
  covers:
    - shadcn_ui.motion_media_gallery.release_acceptance
```
