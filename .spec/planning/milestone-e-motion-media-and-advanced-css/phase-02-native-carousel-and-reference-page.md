# Phase 2 - Native Carousel And Reference Page

Back to wave: [README](./README.md)

## Dependencies and contracts

Requires Phase 1 media identity, motion suppression, capabilities and fixture/export infrastructure.

- [motion_media_contract](../../specs/motion_media_contract.spec.md)
- [media_components](../../specs/media_components.spec.md)
- [motion_media_gallery](../../specs/motion_media_gallery.spec.md)

- [ ] 2 Phase - Native Carousel And Reference Page.

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

  - [ ] 2.3 Section - Immediate Carousel gallery and documentation.

    Make the released component inspectable as soon as it exists.

    - [ ] 2.3.1 Task - Publish the closed Carousel reference and media browser fixture.

      The reference should demonstrate real interactions and complete content, not inert controls.

      - [ ] 2.3.1.1 Subtask - Append Media to the catalogue and add /components/media/carousel with breadcrumbs, current-page state, canonical URL, export/sitemap/smoke entries and nonreflecting mismatches.
      - [ ] 2.3.1.2 Subtask - Show short/long item lists, image and mixed-control content, oversized cards, RTL, snap variants, native index links and complete CSS-disabled/no-script alternatives.
      - [ ] 2.3.1.3 Subtask - Start /examples/media-browser using actual fixtures and Carousel; preserve ordinary image destinations and demonstrate system/reduce theme combinations.

    - [ ] 2.3.2 Task - Publish API, ownership and provenance guidance.

      Consumers should understand both what Carousel does and what a richer scripted widget would require.

      - [ ] 2.3.2.1 Subtask - Add public attrs/slots/closed values, identity, keyboard/focus, snap, fallback and replacement guidance with compilable escaped HEEx source.
      - [ ] 2.3.2.2 Subtask - Explain why index navigation is not remote pagination or selected slide state and why generated controls/autoplay remain deferred.
      - [ ] 2.3.2.3 Subtask - Map adapted source and CSS to the reviewed upstream pin, preserve notices, and update the capability page without claiming unrun browser support.

  - [ ] 2.4 Section - Phase 2 Integration Tests.

    Verify actual Carousel rendering and native operation across engines and published artifacts.

    - [ ] 2.4.1 Task - Verify semantic, keyboard and fallback behavior.

      Tests must observe native outcomes as well as stable markup.

      - [ ] 2.4.1.1 Subtask - Add carousel_test.exs for metadata, keys, labels, descriptions, forms, escaping, globals, deterministic IDs, closed values and forbidden widget/runtime output.
      - [ ] 2.4.1.2 Subtask - Add milestone-e-carousel.spec.mjs for real focus/index/scroll behavior, Tab and native keys, touch/wheel, oversized items, nesting in prior layout components and replacement.
      - [ ] 2.4.1.3 Subtask - Cover both themes, wide/narrow/zoom/RTL, forced colors, suppression, missing snap, no-script and CSS-disabled output; run axe plus explicit names, lists, links and duplicate-ID checks.

    - [ ] 2.4.2 Task - Verify incremental gallery and package delivery.

      The phase must leave both the reusable package and its published reference buildable.

      - [ ] 2.4.2.1 Subtask - Run package/demo precommit, CSS build/check, fixture comparison, deterministic export and subpath smoke for the new page/composition and prior routes.
      - [ ] 2.4.2.2 Subtask - Build ExDoc/archive and audit provenance, scoped CSS, no runtime or generated controls, and exclusion of demo media/fixtures.
      - [ ] 2.4.2.3 Subtask - Run the locked three-engine suite and affected A–D regressions, SpecLed and whitespace checks; record evidence and commit each section independently.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge that PR without a later request.
Keep all checkboxes unchecked until the corresponding implementation and proof
land. Update relevant specifications only after reading their full contracts.
