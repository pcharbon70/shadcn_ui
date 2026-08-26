# Phase 2 - Native Carousel And Reference Page

Back to wave: [README](./README.md)

## Dependencies and contracts

Requires Phase 1 media identity, motion suppression, capabilities and fixture/export infrastructure.

- [motion_media_contract](../../specs/motion_media_contract.spec.md)
- [media_components](../../specs/media_components.spec.md)
- [motion_media_gallery](../../specs/motion_media_gallery.spec.md)

- [x] 2 Phase - Native Carousel And Reference Page.

  Publish Carousel as an honest named native scroll region with a complete item list and real fragment navigation, and expose it immediately in the gallery.

  - [x] 2.1 Section - Carousel API and semantic structure.

    Define the public component through explicit HEEx metadata while preserving all caller content and ordinary controls.

    - [x] 2.1.1 Task - Implement the defining Carousel component.

      The API should express native list layout, not a synchronized slide model.

      - [x] 2.1.1.1 Subtask - Add Media.Carousel.carousel/1 with required unique id/name, keyed labelled item slots, optional description and closed snap/alignment choices; import the defining module directly.
      - [x] 2.1.1.2 Subtask - Render one named focusable native inline scroll region and an ordered list; generate unique item IDs and real labelled index anchors from stable keys.
      - [x] 2.1.1.3 Subtask - Preserve trusted child HEEx, native links/forms, caller classes and unrelated globals while rejecting duplicate keys, missing labels and conflicting roles/relationships.

    - [x] 2.1.2 Task - Protect native navigation and honest semantics.

      A visual carousel must not claim selection, autoplay or keyboard behavior it does not implement.

      - [x] 2.1.2.1 Subtask - Keep all items in document and accessibility order; omit active-slide state, live announcements, tab/menu/listbox roles and aria-roledescription carousel claims.
      - [x] 2.1.2.2 Subtask - Do not render previous/next controls with no native operation; omit generated CSS buttons/markers and loop clones from package output.
      - [x] 2.1.2.3 Subtask - Document native scroll and fragment behavior, child focus, server replacement and application-owned navigation with no listeners or restoration code.

  - [x] 2.2 Section - Responsive native scrolling and CSS fallbacks.

    Enhance layout with scoped CSS while preserving oversized items, focus and scroll escape.

    - [x] 2.2.1 Task - Implement logical layout and closed snap presentation.

      The same content should remain reachable at narrow widths, zoom and RTL without a translated track.

      - [x] 2.2.1.1 Subtask - Map none/proximity/mandatory snap and start/center alignment to complete static classes; choose proximity by default and keep native overflow.
      - [x] 2.2.1.2 Subtask - Add logical spacing, scroll padding/margins, visible focus and bounded item widths without hiding scroll affordances or forcing document-wide horizontal overflow.
      - [x] 2.2.1.3 Subtask - Verify focus into long items, mixed controls and oversized content; ensure explicit motion suppression disables smooth scrolling without disabling navigation.

    - [x] 2.2.2 Task - Audit enhancement and fallback isolation.

      The absence of snap or optional CSS must change presentation only.

      - [x] 2.2.2.1 Subtask - Add capability-gated CSS only where needed and record each authored exception and upstream local-change mapping.
      - [x] 2.2.2.2 Subtask - Provide complete native scrolling without snap and an ordinary ordered list with CSS disabled; keep every fragment target and destination stable.
      - [x] 2.2.2.3 Subtask - Exercise multiple sibling instances, RTL and forced colors without selector/keyframe leakage, browser sniffing or a package event loop.

  - [x] 2.3 Section - Immediate Carousel gallery and documentation.

    Make the released component inspectable as soon as it exists.

    - [x] 2.3.1 Task - Publish the closed Carousel reference and media browser fixture.

      The reference should demonstrate real interactions and complete content, not inert controls.

      - [x] 2.3.1.1 Subtask - Append Media to the catalogue and add /components/media/carousel with breadcrumbs, current-page state, canonical URL, export/sitemap/smoke entries and nonreflecting mismatches.
      - [x] 2.3.1.2 Subtask - Show short/long item lists, image and mixed-control content, oversized cards, RTL, snap variants, native index links and complete CSS-disabled/no-script alternatives.
      - [x] 2.3.1.3 Subtask - Start /examples/media-browser using actual fixtures and Carousel; preserve ordinary image destinations and demonstrate system/reduce theme combinations.

    - [x] 2.3.2 Task - Publish API, ownership and provenance guidance.

      Consumers should understand both what Carousel does and what a richer scripted widget would require.

      - [x] 2.3.2.1 Subtask - Add public attrs/slots/closed values, identity, keyboard/focus, snap, fallback and replacement guidance with compilable escaped HEEx source.
      - [x] 2.3.2.2 Subtask - Explain why index navigation is not remote pagination or selected slide state and why generated controls/autoplay remain deferred.
      - [x] 2.3.2.3 Subtask - Map adapted source and CSS to the reviewed upstream pin, preserve notices, and update the capability page without claiming unrun browser support.

  - [x] 2.4 Section - Phase 2 Integration Tests.

    Verify actual Carousel rendering and native operation across engines and published artifacts.

    - [x] 2.4.1 Task - Verify semantic, keyboard and fallback behavior.

      Tests must observe native outcomes as well as stable markup.

      - [x] 2.4.1.1 Subtask - Add carousel_test.exs for metadata, keys, labels, descriptions, forms, escaping, globals, deterministic IDs, closed values and forbidden widget/runtime output.
      - [x] 2.4.1.2 Subtask - Add milestone-e-carousel.spec.mjs for real focus/index/scroll behavior, Tab and native keys, touch/wheel, oversized items, nesting in prior layout components and replacement.
      - [x] 2.4.1.3 Subtask - Cover both themes, wide/narrow/zoom/RTL, forced colors, suppression, missing snap, no-script and CSS-disabled output; run axe plus explicit names, lists, links and duplicate-ID checks.

    - [x] 2.4.2 Task - Verify incremental gallery and package delivery.

      The phase must leave both the reusable package and its published reference buildable.

      - [x] 2.4.2.1 Subtask - Run package/demo precommit, CSS build/check, fixture comparison, deterministic export and subpath smoke for the new page/composition and prior routes.
      - [x] 2.4.2.2 Subtask - Build ExDoc/archive and audit provenance, scoped CSS, no runtime or generated controls, and exclusion of demo media/fixtures.
      - [x] 2.4.2.3 Subtask - Run the locked three-engine suite and affected A–D regressions, SpecLed and whitespace checks; record evidence and commit each section independently.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge that PR without a later request.
Keep all checkboxes unchecked until the corresponding implementation and proof
land. Update relevant specifications only after reading their full contracts.

## Execution record

Implemented on 2026-08-26 with four section commits. PR #14 was merged, local
main synchronized with origin, then the merged branch was deleted before this
phase began. Checklist completion means implementation and checks were executed;
the outstanding SpecLed gate below is not reported as passing.

- Public Carousel imports directly from its defining module. Native region,
  ordered keyed content, item focus targets, real index links, descriptions,
  closed values and caller-owned forms remain runtime-free. Upstream basic and
  marker sources were reviewed at bd8f403030c8d1f46804da6eda733fde7e908e63;
  generated controls are deliberately omitted and the MIT notice retained.
- `mix precommit`: 337 passing package tests. Demo `mix precommit`: 50 passing
  tests, including actual routes, all theme/motion pairs, compiled inert source,
  local media and repeated exports. No unfinished media page is advertised.
- `npm run browser:milestone-e-phase2`: 39 passing tests. Playwright 1.62.1:
  Chromium 151.0.7922.34 / revision 1234, Firefox 153.0 / 1538, WebKit 26.5 / 2336.
  Covers native keys, fragment/child focus, wheel, touch-index activation, native
  fixture submission, replacement, both themes, RTL, 390px layouts, 200% CSS zoom,
  forced colors, suppressed motion, missing snap, CSS-disabled and no-script
  output, axe, duplicate IDs and actual static subpath image/link navigation.
- Integration found and fixed two real layout issues: gallery grid sections
  now shrink within narrow pages; child focus suspends snap so an oversized card
  cannot pull its focused link out of view at zoom. The static test server now
  models directory redirects before resolving relative media and stylesheet URLs.
- `npm run browser:milestone-e-phase1`: final full rerun 60 passed. The first
  regression run had two intermittent Firefox probe failures; an isolated
  Firefox rerun passed 20/20 and the subsequent full rerun passed 60/60 without
  changing the probe or recorded capability evidence. This is retained as a
  harness stability observation, not hidden with automatic retries.
- `npm run capabilities:motion-media:check`: recorded exact-engine evidence
  matches. A–D gallery regressions passed: D gallery 39, demo baseline 11, C 5.
  Total distinct passing browser cases across the final suites: 154.
- Package/demo `npm run assets:check`, `mix run scripts/render-carousel-fixture.exs
  --check`, demo `npm run export:determinism`, `export:check`, `export:smoke`: pass.
  Two identical exports contain 554 route variants, three code/style assets and
  three selected local media files; new canonical routes, preferences, IDs,
  fragment targets, hashes and subpath links are checked.
- `mix docs`, `mix hex.build`, `mix run scripts/check-release-archive.exs`: pass.
  The actual archive has 56 entries including Carousel and normative data,
  excluding demo media, fixtures, observations, scripts and browser tooling.
- `mix spec.next` recognizes the covered cross-cutting change after adding
  explicit Carousel/fixture surfaces. `mix spec.check --base HEAD` reports four
  existing nested-command failures and 153 reference/future-target warnings.
  Its login shell selects Elixir 1.18 built for OTP 26 with OTP 29 instead of
  direct PowerShell Elixir 1.20.3. Component/form/package precommit and gallery
  smoke fail in that runner; direct equivalents pass. No gate or machine profile
  was changed. Shared-file reconciliation advice is not evidence of a new
  contract for unrelated components. `git diff --check` passes.
- Windows still denies symlink creation in the inherited export test; Linux CI
  must exercise the rejection assertion. CI and publication are pending. No
  physical touch-swipe testing, manual screen-reader acceptance, browser-chrome
  zoom certification or deployed smoke result is claimed by this automation.

Next: Phase 3, static-first Marquee and bounded Stagger with actual references.
