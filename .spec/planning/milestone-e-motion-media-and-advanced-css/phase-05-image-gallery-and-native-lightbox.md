# Phase 5 - Image Gallery And Native Lightbox

Back to wave: [README](./README.md)

## Dependencies and contracts

Requires Phase 1 image contracts and fixture export, current Media catalogue, and the existing Milestone D Dialog contract. No new modal runtime is permitted.

- [motion_media_contract](../../specs/motion_media_contract.spec.md)
- [media_components](../../specs/media_components.spec.md)
- [motion_media_gallery](../../specs/motion_media_gallery.spec.md)

- [ ] 5 Phase - Image Gallery And Native Lightbox.

  Publish the complete responsive image-gallery experience with real local fixtures, native Dialog enlargement and ordinary destinations, treating origin transitions only as optional proven CSS.

  - [x] 5.1 Section - Structured Image Gallery and responsive figures.

    Make media meaning and intrinsic layout explicit before adding enlargement.

    - [x] 5.1.1 Task - Implement the defining Image Gallery component.

      The public API should normalize structured images rather than own a media service.

      - [x] 5.1.1.1 Subtask - Add Media.ImageGallery.image_gallery/1 with unique id/name, structured keyed image/full-size records and closed layout/density/thumbnail-fit values.
      - [x] 5.1.1.2 Subtask - Render a semantic list/grid of figures with explicit alt intent, captions, intrinsic dimensions, responsive srcset/sizes and preserved native loading/decoding hints.
      - [x] 5.1.1.3 Subtask - Provide a complete ordinary detail/full-image destination for every enlargable item; reject invalid fields, unsafe schemes, duplicate identities and conflicting globals.

    - [x] 5.1.2 Task - Preserve failure, layout and caller ownership.

      Image absence and remote policy cannot become hidden package state.

      - [x] 5.1.2.1 Subtask - Keep captions, alt, control names and destinations understandable when images fail or are missing; include mixed aspect ratios and long text.
      - [x] 5.1.2.2 Subtask - Use responsive bounded sizing with contain for enlarged images and no layout polling, dimension fetching, inferred alt/caption or generated srcset.
      - [x] 5.1.2.3 Subtask - Document browser loading hints versus guaranteed deferred fetching, caller media rights/privacy/CSP policy, destination semantics and replacement.

  - [x] 5.2 Section - Lightbox composition through existing Dialog.

    Reuse the already tested native modal contract without introducing selected-image navigation or a second focus system.

    - [x] 5.2.1 Task - Compose stable per-item native dialogs.

      Each item needs a real invoker, meaningful name, explicit exit and complete nonmodal alternative.

      - [x] 5.2.1.1 Subtask - Support none/dialog lightbox modes; in dialog mode derive stable IDs and compose one initially closed existing Dialog per item with a visible close control.
      - [x] 5.2.1.2 Subtask - Keep thumbnail button and ordinary image/detail link separate to avoid nested interactive elements; preserve Dialog naming, description, autofocus choices and close-request default.
      - [x] 5.2.1.3 Subtask - Render full image and complete caption inside a viewport-bounded scrolling modal; prohibit nested dialogs, package next/previous state, swipe/zoom/pan and event listeners.

    - [x] 5.2.2 Task - Verify native lifecycle and optional origin presentation.

      The origin effect must never become a condition of opening, closing or reaching content.

      - [x] 5.2.2.1 Subtask - Test native command invocation, modality, inertness, focus entry/containment, Escape/explicit close and restoration without altering shared Dialog semantics.
      - [x] 5.2.2.2 Subtask - Probe scoped CSS-only origin/anchor/discrete-transition behavior on actual thumbnail/dialog pairs; admit only jointly supported and proven presentation with a snap fallback.
      - [x] 5.2.2.3 Subtask - If the origin effect is unreliable, explicitly defer that effect and ship the native lightbox; never add coordinates, view-transition JavaScript or a focus/overlay manager.

  - [ ] 5.3 Section - Substantial image-gallery demo and public reference.

    Deliver the requested online-style gallery as a complete useful page rather than a collection of inert examples.

    - [ ] 5.3.1 Task - Publish real local image browsing and lightboxes.

      The image-gallery composition is the primary demonstration of this phase.

      - [ ] 5.3.1.1 Subtask - Add /components/media/image-gallery and /examples/image-gallery using the closed fixture manifest, multiple aspect ratios, captions, alt, destinations and working native enlargement.
      - [ ] 5.3.1.2 Subtask - Include failed-image, long-caption, no-dialog, reduced-motion, CSS-disabled and missing-command alternatives; keep ordinary destinations visible even when native enlargement works.
      - [ ] 5.3.1.3 Subtask - Add full navigation/current-state/breadcrumb, source, canonical, sitemap/export and smoke coverage; test every exported image and srcset under the repository subpath.

    - [ ] 5.3.2 Task - Document complete media and modal ownership.

      Consumers should know which behaviors are native, optional, absent or application-owned.

      - [ ] 5.3.2.1 Subtask - Publish APIs/slots/closed values, intrinsic/responsive image guidance, invoker/close relationships, focus/dismissal, native loading hints and failure behavior.
      - [ ] 5.3.2.2 Subtask - Explain origin-effect admission or deferral and replacement reset; explicitly exclude image management, uploads, transformation, remote galleries and slideshow state.
      - [ ] 5.3.2.3 Subtask - Update exact upstream component/CSS mappings, full notices, local fixture licenses, ExDoc and release guidance while keeping demo assets out of the archive.

  - [ ] 5.4 Section - Phase 5 Integration Tests.

    Verify gallery and lightbox behavior as an accessible media composition in live and static consumers.

    - [ ] 5.4.1 Task - Verify images, native modality and fallback destinations.

      The complete image information must survive every capability and loading path.

      - [ ] 5.4.1.1 Subtask - Add image_gallery_test.exs for keyed figures, responsive attrs, dimensions, alt/decorative intent, captions, safe URLs, dialog IDs, escaped content and prohibited nested controls.
      - [ ] 5.4.1.2 Subtask - Add milestone-e-image-gallery.spec.mjs for real invocation, names/descriptions, focus containment/return, Escape/close, long content, multiple instances, failed media and replacement.
      - [ ] 5.4.1.3 Subtask - Exercise disabled commands/anchors/transitions, motion suppression, no-script/CSS-disabled, touch, zoom, RTL, themes and forced colors; run axe plus explicit image, dialog, destination and duplicate-ID assertions.

    - [ ] 5.4.2 Task - Verify complete static media and release isolation.

      Prove image delivery works from the exported artifact without remote runtime services.

      - [ ] 5.4.2.1 Subtask - Run package/demo precommit, deterministic assets and export, live routes and actual static subpath media/HTML smoke including every manifest and srcset reference.
      - [ ] 5.4.2.2 Subtask - Verify archive excludes fixtures, observations, image loaders and browser tools; rebuild ExDoc and audit provenance/license and authored CSS exceptions.
      - [ ] 5.4.2.3 Subtask - Run inherited Dialog and all affected A–E regressions in locked engines, SpecLed and whitespace; record whether origin presentation was admitted or deferred and commit each section.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge that PR without a later request.
Keep all checkboxes unchecked until the corresponding implementation and proof
land. Update relevant specifications only after reading their full contracts.

## Execution record

- Section 5.1: defining imported component, shared structured-media validation,
  named responsive figures, keyed trusted captions and independent destinations.
  Full-size metadata is validated here; bounded contain rendering is composed
  with Dialog in Section 5.2. Package precommit: 361 passed; deterministic CSS
  build/check passed. No network fetching or new runtime was introduced.
- Section 5.2: existing per-item Dialog, explicit exits, keyboard restoration,
  bounded contain images and ordinary alternatives. Package precommit: 362 passed;
  generated-HEEx browser tests: 9 passed in the three locked engines. Origin
  experiment: Chromium reproduces scoped opening geometry; Firefox/WebKit do not
  produce origin transitions despite parsing anchor/discrete declarations. The
  optional effect is deferred everywhere; native snap ships with no new runtime.
  Native pointer focus and browser-chrome Tab behavior are documented separately
  from keyboard-invoked restoration. Fixture, probe and observations are test/demo only.
