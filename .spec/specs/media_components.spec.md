# Carousel, Cover Flow, and Image Gallery

```spec-meta
id: shadcn_ui.media_components
kind: package
status: active
summary: Carousel, Cover Flow and responsive Image Gallery with native Dialog lightboxes are implemented.
decisions:
  - shadcn_ui.motion_media_capability_css
  - shadcn_ui.native_carousel_cover_flow
  - shadcn_ui.responsive_media_lightbox
surface:
  - docs/image-gallery.md
  - scripts/render-image-gallery-fixture.exs
  - scripts/record-gallery-origin.mjs
  - playwright.milestone-e-phase5.config.mjs
  - test/fixtures/milestone_e_image_gallery.html
  - test/browser/support/gallery-origin-probe.mjs
  - test/shadcn_ui/image_gallery_integration_test.exs
  - lib/shadcn_ui/components/media/cover_flow.ex
  - test/shadcn_ui/components/media/cover_flow_test.exs
  - test/shadcn_ui/scroll_media_integration_test.exs
  - scripts/render-scroll-media-fixture.exs
  - test/fixtures/milestone_e_scroll_media.html
  - playwright.milestone-e-phase4.config.mjs
  - lib/shadcn_ui/components/media/carousel.ex
  - test/shadcn_ui/components/media/carousel_test.exs
  - test/fixtures/milestone_e_carousel.html
  - lib/shadcn_ui/components/media/**/*.ex
  - test/shadcn_ui/components/media/**/*.exs
  - test/browser/milestone-e-carousel.spec.mjs
  - test/browser/milestone-e-cover-flow.spec.mjs
  - test/browser/milestone-e-image-gallery.spec.mjs
  - test/shadcn_ui/carousel_integration_test.exs
  - scripts/render-carousel-fixture.exs
  - playwright.milestone-e-phase2.config.mjs
```

## API contract

Functions are carousel/1, cover_flow/1 and image_gallery/1 (implemented) in defining
modules under ShadcnUI.Components.Media, imported directly through use ShadcnUI.
All require unique id and an accessible name (label or valid heading reference,
not conflicting sources); optional descriptions receive deterministic IDs.
Closed presentation inputs map to full static classes. Values are atoms in HEEx,
never atoms constructed from request data.

Carousel has repeated item slots with unique key, nonblank label and trusted
inner content; its real item index targets derived item IDs. Closed snap values
are none, proximity (default), mandatory; alignment is start or center.
The logical axis is inline only in this wave. Preserve native child controls,
form values and destinations; do not clone caller slot content.

Carousel names use exactly one of accessible_label or labelledby. The latter
contains space-separated caller-owned heading IDs. description is escaped text;
its derived ID is protected. Item slots accept class and unrelated rest globals,
while required IDs, list semantics, focus and naming cannot be overridden.
Item targets have tabindex=-1 for native fragment focus, not extra Tab stops.
Snapping pauses while a descendant is focused; focused content takes precedence
over any snap point, including mandatory snapping and oversized cards at zoom.
motion accepts system/none and respects ancestor and OS suppression.

Cover Flow accepts structured image items using the shared record, labels,
captions and optional destinations. It reuses Carousel's list, native scroll
region and index contract; its presentation is flat or enhanced. Enhanced means
eligible CSS presentation, not a promise that it activates. Motion suppression
or absent joint timeline/transform support selects flat presentation.

Cover Flow requires nonempty images; no arbitrary slot or transform input exists.
presentation defaults enhanced, snap proximity, alignment start, motion system.
One-image collections stay flat. A 40rem named container query, joint view
timeline/name/range/scope and perspective support, no-preference and no forced
colors admit image-only depth. Captions and destination links never transform;
images have bounded contain sizing and cannot capture pointer events. Encoded
timeline names are instance/item-local. No overlap or animated stacking exists.

Image Gallery accepts structured images and closed density/column/fit
presentation rather than a dynamic CSS grid expression. Thumbnail fit may be
cover or contain; enlarged images are always contain. An optional caption is
trusted HEEx only through a distinct caption slot; plain record captions remain
escaped text. Item destinations and invoker names are explicit.

Lightbox presentation is none or dialog. Dialog mode composes one existing
Dialog per item, with a derived stable base ID and a close label; it does not
create a new overlay API. The complete image/detail destination remains a
separate visible ordinary link. The default is the native dialog composition
with close-request dismissal; keep explicit close and inherited autofocus
choices. The no-dialog choice renders just the complete linked figure.

Image Gallery requires nonempty images; columns two/three/four (three default),
density compact/comfortable (comfortable), fit cover/contain (cover) and motion
system/none are closed. Full images always contain within 60dvb. The separate
destination uses href, then full.src, then src; no URL is fetched or inferred.
Caption slots require unique existing keys and receive key/context
(thumbnail/full); presentation-only trusted HEEx must scope IDs and exclude
interactive content. Plain record captions remain escaped in both contexts.
lightbox defaults dialog; initial_focus auto/content/close (auto), dismissal
close_request/none/any (close_request), and nonblank close_label (Close image)
compose the existing Dialog unchanged. context root/dialog is an explicit caller
declaration: dialog context rejects nested dialog mode, but permits none.
Ancestor HEEx cannot be inferred. Visible Enlarge name text names each invoker;
its thumbnail is aria-hidden, while the full image retains meaningful alt.

## Native behavior and fallback

A carousel is a named scroll region containing a list, not an ARIA tab widget
or synchronized slideshow. No active-slide or progress percentage is reported.
Focus and fragment targets must remain in view even when items exceed the
viewport. CSS-disabled output is a complete ordered list with real links.

The Gallery does not promise lazy lightbox fetching, smooth origin transitions,
next/previous navigation, swipe or full-screen state. A failed image retains
alt/caption/destination; a missing native dialog capability uses that ordinary
destination. Native origin-aware CSS is optional and must be separately proven;
an unproven effect is deferred, not simulated by scripts.

Phase 5 deliberately defers origin presentation across this release. The
test-only scoped anchor/discrete experiment matches thumbnail opening geometry
in locked Chromium but produces no origin transition in Firefox/WebKit despite
their anchor/discrete declaration support. All ship existing native snap.
Keyboard-invoked restoration returns to the previously focused invoker; pointer
focus follows platform policy, and Tab may visit browser chrome without entering
the inert page. No alternate focus system is introduced.

## Requirements

```spec-requirements
- id: shadcn_ui.media_components.carousel_structure
  statement: Carousel shall render one named native inline scroll region, a complete semantic list with stable keyed item IDs, and real labelled fragment index links without hiding inactive content.
  priority: must
  stability: evolving

- id: shadcn_ui.media_components.carousel_controls
  statement: Carousel shall preserve native pointer, touch, wheel, keyboard, link and form behavior without autoplay, cloning, selection state, ARIA carousel/tab/menu claims, fake previous-next controls or package-generated CSS scroll buttons and markers.
  priority: must
  stability: evolving

- id: shadcn_ui.media_components.carousel_layout
  statement: Closed snap and alignment choices shall preserve oversized item access, focus visibility, scroll escape, RTL order and a complete CSS-disabled list.
  priority: must
  stability: evolving

- id: shadcn_ui.media_components.cover_flow_composition
  statement: Cover Flow shall reuse Carousel semantics and shared media normalization, retain captions and destinations, and never introduce independent active-item or drag state.
  priority: must
  stability: evolving

- id: shadcn_ui.media_components.cover_flow_enhancement
  statement: Cover Flow transforms shall affect decorative image presentation only behind joint feature gates, with flat readable presentation for absent capabilities, reduced motion, forced colors and unsupported layout conditions.
  priority: must
  stability: evolving

- id: shadcn_ui.media_components.gallery_figures
  statement: Image Gallery shall render stable keyed figures, explicit alternative text, captions, intrinsic dimensions and native responsive image hints, with complete ordinary destinations independent of lightbox operation.
  priority: must
  stability: evolving

- id: shadcn_ui.media_components.gallery_dialog
  statement: Dialog lightboxes shall reuse the existing native Dialog contract, deterministic naming, explicit close, focus intent, Escape/dismissal and ordinary fallback, without nested modals, current-image state, slideshow navigation or package event handling.
  priority: must
  stability: evolving

- id: shadcn_ui.media_components.gallery_origin
  statement: Origin-aware presentation shall use only proven scoped native CSS and snap safely when support, motion permission or origin is absent, without measured coordinates or view-transition JavaScript.
  priority: must
  stability: evolving

- id: shadcn_ui.media_components.media_failure
  statement: Missing or failed images shall retain meaningful alt, captions, accessible controls and complete destinations, without a package loader, inferred status or authorization guarantee.
  priority: must
  stability: evolving

- id: shadcn_ui.media_components.media_ownership
  statement: Applications shall own image rights, privacy, sources, srcset correctness, alt meaning, request validation, permissions, navigation, loading policy and replacement; the package shall not transform, fetch, persist or synchronize media.
  priority: must
  stability: stable
```

## Verification

Carousel unit, generated-HEEx browser and integration targets are implemented.
Cover Flow rendering and actual-HEEx browser targets are implemented in Phase 4.
Image Gallery rendering, actual-modal origin probe, native browser and integration
targets are implemented in Phase 5; broader milestone acceptance remains Phase 6.
The [Milestone E plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
assigns their implementation phases. Missing targets remain visible in SpecLed
until implemented; no placeholder passing test or disabled gate substitutes for
actual proof. Add requirement references in each target as the tests land.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/carousel_integration_test.exs
  covers:
    - shadcn_ui.media_components.carousel_structure
    - shadcn_ui.media_components.carousel_controls
    - shadcn_ui.media_components.carousel_layout

- kind: test_file
  target: test/shadcn_ui/components/media/carousel_test.exs
  covers:
    - shadcn_ui.media_components.carousel_structure
    - shadcn_ui.media_components.carousel_controls
    - shadcn_ui.media_components.carousel_layout

- kind: test_file
  target: test/shadcn_ui/components/media/cover_flow_test.exs
  covers:
    - shadcn_ui.media_components.cover_flow_composition
    - shadcn_ui.media_components.cover_flow_enhancement

- kind: test_file
  target: test/shadcn_ui/components/media/image_gallery_test.exs
  covers:
    - shadcn_ui.media_components.gallery_figures
    - shadcn_ui.media_components.gallery_dialog
    - shadcn_ui.media_components.gallery_origin
    - shadcn_ui.media_components.media_failure
    - shadcn_ui.media_components.media_ownership

- kind: test_file
  target: test/browser/milestone-e-carousel.spec.mjs
  covers:
    - shadcn_ui.media_components.carousel_structure
    - shadcn_ui.media_components.carousel_controls
    - shadcn_ui.media_components.carousel_layout

- kind: test_file
  target: test/browser/milestone-e-cover-flow.spec.mjs
  covers:
    - shadcn_ui.media_components.cover_flow_enhancement

- kind: test_file
  target: test/browser/milestone-e-image-gallery.spec.mjs
  covers:
    - shadcn_ui.media_components.gallery_dialog
    - shadcn_ui.media_components.gallery_origin
    - shadcn_ui.media_components.media_failure
```
