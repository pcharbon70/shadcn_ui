# Phase 4 - Scroll Indicator And Cover Flow

Back to wave: [README](./README.md)

## Dependencies and contracts

Requires Phases 1–3 capabilities, suppression, Carousel contract and Motion/Media catalogue infrastructure.

- [motion_media_contract](../../specs/motion_media_contract.spec.md)
- [motion_components](../../specs/motion_components.spec.md)
- [media_components](../../specs/media_components.spec.md)
- [motion_media_gallery](../../specs/motion_media_gallery.spec.md)

- [ ] 4 Phase - Scroll Indicator And Cover Flow.

  Add decorative scroll progress and optional 3D media presentation using scoped native timelines while keeping static content and Carousel semantics authoritative.

  - [ ] 4.1 Section - Decorative Scroll Indicator.

    Render scroll position decoration without implying task completion, reading state or a numeric measurement API.

    - [ ] 4.1.1 Task - Implement the named native scroll composition.

      The source region and its decoration should share a deterministic instance boundary.

      - [ ] 4.1.1.1 Subtask - Add Motion.ScrollIndicator.scroll_indicator/1 with required id/name, trusted inner content and closed bounded size choices.
      - [ ] 4.1.1.2 Subtask - Render a named focusable native block scroll region plus aria-hidden decorative track; preserve caller headings, links/forms and native scroll keys.
      - [ ] 4.1.1.3 Subtask - Do not emit progressbar, value, percentage, live region, external scroll-target selector or synchronized application state.

    - [ ] 4.1.2 Task - Implement scoped timeline and neutral fallback.

      Absent timeline support must not become a document-clock animation or fake progress.

      - [ ] 4.1.2.1 Subtask - Gate timeline, range and scope dependencies jointly, isolate each instance and bind only its own decorative track to native scroll progress.
      - [ ] 4.1.2.2 Subtask - Retain complete content with a neutral or absent track when unsupported, reduced-motion, explicit suppression or forced colors makes animation unsuitable.
      - [ ] 4.1.2.3 Subtask - Test stationary sources, short/nonoverflowing content and replacement; add no listener, polling, observer, completion callback or unbounded work.

  - [ ] 4.2 Section - Cover Flow composition over Carousel.

    Add optional image depth while keeping the underlying native list, index and destinations unchanged.

    - [ ] 4.2.1 Task - Implement structured Cover Flow and flat baseline.

      The new component should reuse validated media and Carousel structure instead of duplicating a controller.

      - [ ] 4.2.1.1 Subtask - Add Media.CoverFlow.cover_flow/1 with stable structured images/captions/destinations and flat/enhanced presentation; import the defining module directly.
      - [ ] 4.2.1.2 Subtask - Reuse Carousel naming, IDs, native scroll/list/index and ordinary keyboard behavior without active-image, swipe, drag or hidden-slide state.
      - [ ] 4.2.1.3 Subtask - Preserve intrinsic dimensions, explicit alt and loading hints; render captions and destinations outside decorative transforms and provide broken-image examples.

    - [ ] 4.2.2 Task - Admit only evidence-backed 3D CSS.

      A visual enhancement must not obscure focus, captions or hit targets.

      - [ ] 4.2.2.1 Subtask - Gate view-progress/range/transform dependencies together and record precise CSS exceptions and instance-scoped names; do not fallback to a time-based loop.
      - [ ] 4.2.2.2 Subtask - Keep flat presentation under missing support, motion suppression, forced colors and layouts failing readability/hit-target tests; document these gates.
      - [ ] 4.2.2.3 Subtask - Verify overlapping image decoration never captures another item's link or clips its focus indicator; do not measure coordinates or manipulate z-index through runtime code.

  - [ ] 4.3 Section - Immediate scroll and Cover Flow gallery references.

    Make both enhanced and deliberately unavailable paths inspectable in the real catalogue.

    - [ ] 4.3.1 Task - Publish the two reference pages and update compositions.

      The demo should connect presentation effects to their complete native fallback.

      - [ ] 4.3.1.1 Subtask - Add /components/motion/scroll-indicator and /components/media/cover-flow to catalogue, breadcrumbs/current state, canonical URLs, sitemap/export and smoke inventory.
      - [ ] 4.3.1.2 Subtask - Show local media, many/few/no-overflow items, long captions, RTL, native scroll keys, independent instances, neutral progress and flat Cover Flow.
      - [ ] 4.3.1.3 Subtask - Extend media-browser and motion-preferences compositions with actual components; show feature detection separately from passed behavior and preserve no-script navigation.

    - [ ] 4.3.2 Task - Publish ownership and performance guidance.

      Consumers must not interpret decorative progress or depth as domain state.

      - [ ] 4.3.2.1 Subtask - Document all attrs/slots, stable keys, motion/size choices, source scope, native keyboard/focus and lack of numeric reading or selected-image state.
      - [ ] 4.3.2.2 Subtask - Record CSS timeline failure paths, stationary-source behavior, finite/no-perpetual-work limits and browser-local reset after replacement.
      - [ ] 4.3.2.3 Subtask - Update source examples, capability records, authored CSS ledger, upstream mappings and public docs without importing remote media or runtime tooling.

  - [ ] 4.4 Section - Phase 4 Integration Tests.

    Verify real native scroll behavior, isolated timelines and accessible flat fallbacks across the locked engines.

    - [ ] 4.4.1 Task - Verify structure, scroll behavior and enhancement rejection.

      Tests should observe progress only where supported and require identical native content everywhere.

      - [ ] 4.4.1.1 Subtask - Add Scroll Indicator/Cover Flow unit tests for values, scoped identities, image metadata, captions, escaping, globals, native lists/index and forbidden roles/state/runtime.
      - [ ] 4.4.1.2 Subtask - Add milestone-e-scroll-indicator.spec.mjs and milestone-e-cover-flow.spec.mjs for native keys/touch, independent sources, idle progress, focus visibility, hit targets, oversized images and replacement.
      - [ ] 4.4.1.3 Subtask - Exercise joint feature removal, no-script/CSS-disabled, short content, wide/narrow/zoom/RTL, themes, reduced motion/ancestor suppression and forced colors; include axe plus explicit decoration/meaning assertions.

    - [ ] 4.4.2 Task - Verify incremental release and whole-gallery compatibility.

      Timeline enhancements cannot compromise earlier component behavior or static publication.

      - [ ] 4.4.2.1 Subtask - Run package/demo precommit, scoped CSS audit, deterministic fixture and asset builds, complete route/export/sitemap and static media subpath checks.
      - [ ] 4.4.2.2 Subtask - Rebuild ExDoc/archive, verify provenance and authored CSS records, and prove no demo media, observation, observer or generated control ships in the package.
      - [ ] 4.4.2.3 Subtask - Run all affected native/overlay/Carousel/motion regressions, SpecLed and whitespace checks and record exact enhanced versus fallback evidence before section commits.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge that PR without a later request.
Keep all checkboxes unchecked until the corresponding implementation and proof
land. Update relevant specifications only after reading their full contracts.
