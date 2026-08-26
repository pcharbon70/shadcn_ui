# Milestone E - Motion, Media, and Advanced CSS

## Description

Milestone E adds the distinctive media and motion demonstrations enabled by
modern CSS. These components must remain understandable, navigable, and usable
when animation, scroll markers, anchor functions, or view timelines are absent.
They are enhancements over semantic content, not replacements for it.

## Intended outcomes

- ShadcnUI can express polished carousels, galleries, progress effects, and
  decorative motion without a mandatory component runtime.
- Every animation has an explicit reduced-motion treatment.
- Caller content, images, links, captions, and actions remain caller-owned.
- Supplemental authored CSS is admitted only when the effect cannot be expressed
  clearly and maintainably through the package's generated utility layer.

## Component scope

- Carousel based on native horizontal scrolling and scroll snap, with generated
  markers or controls treated as enhancement.
- Marquee with duplicated presentation content hidden appropriately from
  assistive technology.
- Scroll Indicator using a scroll-driven animation with a static fallback.
- Stagger as a bounded entrance-presentation helper.
- Cover Flow as an advanced, optional 3D scroll presentation.
- Image Gallery and lightbox composition based on native dialog behavior and
  caller-provided images and alternative text.

## Architecture work required

- Define which components are reusable primitives and which are documented
  compositions built from lower-level ShadcnUI components.
- Specify reduced-motion behavior, animation pause rules, offscreen work,
  content duplication, and accessibility-tree treatment.
- Define carousel control and pagination semantics independently of whether the
  browser can generate CSS scroll buttons and markers.
- Establish responsive image, intrinsic sizing, lazy-loading, and caller-owned
  alternative-text contracts for Gallery and Cover Flow.
- Record each authored CSS exception and prevent demo-only image URLs or content
  from entering the release artifact.

## Gallery scope

- Add Motion and Media categories with realistic, locally owned fixtures.
- Provide a dedicated image-gallery page inspired by unscripted/ui's origin-
  aware lightbox while using ShadcnUI's own component and accessibility
  contracts.
- Demonstrate Carousel, Cover Flow, Gallery, Marquee, Scroll Indicator, and
  Stagger at narrow and wide sizes.
- Offer an obvious reduced-motion inspection mode and document what changes.
- Show rendered previews, copyable HEEX examples, required CSS, browser support,
  and fallback appearance together.

## Verification expectations

- Rendering tests assert semantic lists, links, buttons, images, captions,
  alternative text, duplicate-content hiding, and caller ownership.
- Browser tests cover keyboard scrolling, focus visibility, touch-sized
  controls, reduced motion, zoom, high contrast, responsive sizing, and absent-
  feature fallbacks.
- Performance checks use realistic item counts and reject unnecessary listeners,
  layout polling, or continuously running offscreen work.
- Package audits prove remote demo assets and gallery-specific scripts are not
  distributed as component dependencies.

## Exit criteria

Milestone E is complete when every advanced visual component has a useful static
or native fallback, reduced-motion behavior is verified, the online gallery
demonstrates both enhanced and fallback states, and no application or media
ownership has leaked into the package.

## Deferred work

Video players, editors, infinite data virtualization, arbitrary animation
frameworks, image transformation services, uploads, and content management
remain application responsibilities.

## Accepted architecture and implementation wave

The [Milestone E phased plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
links five accepted ADRs, four normative specifications and the requirement
coverage map. Planning is complete; implementation has not started.

The wave resolves the broad roadmap as follows:

- Carousel uses native scrolling and real item links. Generated CSS scroll
  buttons and markers are deferred from the package API.
- Marquee is static by default. Its optional user-enabled preview is finite,
  lasts at most five seconds, and exposes native stop/reset and replay rather
  than starting automatically or looping indefinitely.
- Stagger is opt-in and bounded to one second total; Scroll Indicator and Cover
  Flow retain static/native fallbacks under missing capabilities or suppression.
- Image Gallery reuses the existing native Dialog contract. Origin-aware CSS
  presentation is admitted only after evidence, with a snap fallback otherwise.
- Each component phase adds its actual demo reference. A substantial dedicated
  image-gallery composition, motion inspection and local media export are
  explicit deliverables, not postponed library-only follow-up work.
- Capability evidence is web-platform-based and consumer-neutral; Electron is
  not the extracted package's target.

These choices refine scope without marking any implementation or browser
acceptance complete. The final integration-test section of each phase supplies
the evidence needed before that phase is considered delivered.
