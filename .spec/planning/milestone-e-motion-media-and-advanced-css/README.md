# Milestone E - Motion, Media, and Advanced CSS

## Status and purpose

Phases 1–3 implement the shared foundations, native Carousel, finite Marquee and
bounded Stagger, their real references, media-browser and motion-preferences
compositions. The recorded SpecLed login-shell limitation remains outstanding.
Phases 4–6 and Scroll Indicator, Cover Flow and Image Gallery remain pending.
Milestones A–D history is unchanged. See the
[Phase 3 execution record](./phase-03-marquee-stagger-and-motion-references.md#execution-record)
for checks and limitations. Next is Phase 4, Scroll Indicator and Cover Flow.

This wave implements the [Milestone E roadmap](../../milestones/milestone-e-motion-media-and-advanced-css.md)
as independently reviewable phases. Native content, useful fallbacks, scoped
CSS, and actual gallery pages land together. The package remains reusable
Phoenix HEEx with no application, operating-system, Electron, or transport target.

## Accepted architecture and contracts

1. [Keep Motion And Media Native, Capability-Based, And Runtime-Free](../../decisions/motion-media-capability-and-css-boundary.md)
2. [Keep Carousel And Cover Flow As Native Scrollable Content](../../decisions/native-carousel-and-cover-flow-semantics.md)
3. [Make Decorative Motion Optional, Bounded, And Safely Duplicated](../../decisions/bounded-motion-reduced-motion-and-duplication.md)
4. [Keep Responsive Images Caller-Owned And Reuse Native Dialog For Lightboxes](../../decisions/responsive-media-and-native-gallery-lightbox.md)
5. [Deliver Each Motion And Media Component With Its Real Gallery Page](../../decisions/incremental-motion-media-gallery-and-acceptance.md)

The specifications are normative; this plan sequences their implementation:

- [Shared motion, media, and capability contract](../../specs/motion_media_contract.spec.md)
- [Carousel, Cover Flow, and Image Gallery](../../specs/media_components.spec.md)
- [Marquee, Stagger, and Scroll Indicator](../../specs/motion_components.spec.md)
- [Incremental motion/media gallery and Milestone E acceptance](../../specs/motion_media_gallery.spec.md)

The [requirement coverage map](./coverage-map.md) assigns all 38 new requirements
to delivery phases and planned proof files. Existing package, component,
stylesheet, provenance, gallery, and native Dialog contracts still apply.
Read those subjects before updating them as their E extensions land; do not
change an implemented contract by silently relying on a new plan.

## Resolved scope

| Public defining module | Native/static baseline | Optional presentation and fallback |
| --- | --- | --- |
| `ShadcnUI.Components.Media.Carousel` | Named scroll region, complete keyed list, real fragment index | Scroll snap; ordinary scrolling/list if styling is unavailable |
| `ShadcnUI.Components.Motion.Marquee` | Static noninteractive presentation list | Explicit finite preview, at most five seconds; static when suppressed |
| `ShadcnUI.Components.Motion.Stagger` | Complete caller content in document order | Opt-in fade/rise, at most one second total; immediately visible fallback |
| `ShadcnUI.Components.Motion.ScrollIndicator` | Named native scroll region and neutral decorative track | Scoped scroll-driven decoration; no fabricated progress when unsupported |
| `ShadcnUI.Components.Media.CoverFlow` | Carousel composition with responsive images and real destinations | Gated decorative 3D presentation; flat under suppression or missing capabilities |
| `ShadcnUI.Components.Media.ImageGallery` | Keyed figures, captions and complete ordinary image destinations | Existing native Dialog lightboxes; origin effect only if proven, otherwise snap |

Generated CSS scroll buttons/markers are deferred from the package API for this
wave. Native scrolling and real item links are the Carousel controls. There is
no selected-slide state, autoplay, synthetic previous/next behavior, or ARIA
carousel/tab/menu claim.

Marquee does not start automatically or loop indefinitely. Its optional preview
uses an initially unchecked, labelled native checkbox to enable one finite
traversal. Unchecking stops/resets; rechecking replays. The label describes
preview enablement, not a supposedly observed playback state. At most one inert,
accessibility-hidden clone is allowed, and it disappears from static,
CSS-disabled, and reduced-motion presentation. This stricter product policy
narrows the original broad roadmap; it is not a claim that all animation must
follow this duration under WCAG.

Public component motion values are `system` (default) and `none`. Demo inspection
uses the separate closed query `motion=system|reduce`, with invalid values falling
back to system. A `data-shadcn-motion="reduce"` ancestor suppresses descendants.
System reduced motion always wins; no setting forces animation or permits a
nested component to override suppression.

Image Gallery reuses the existing Dialog contract, including its capability
boundary, naming, native dismissal, focus intent, and fallback. Each lightbox
has a separate complete ordinary link; there is no independent Lightbox manager,
current-image state, zoom controller, or slideshow navigation. Caller image
records supply explicit alt intent, dimensions, responsive metadata, captions
and URLs. Image processing, rights, privacy and application state stay outside
the package.

## Ordered phases

| Phase | Delivery | Dependency |
| --- | --- | --- |
| [1 - Capability, Media, And Motion Foundations](./phase-01-capability-media-and-motion-foundations.md) | Establish the shared native and CSS capability boundaries, image contracts, suppression rules, fixture inventory and proof harness before publishing concrete components. | Milestone D baseline |
| [2 - Native Carousel And Reference Page](./phase-02-native-carousel-and-reference-page.md) | Publish Carousel as an honest named native scroll region with a complete item list and real fragment navigation, and expose it immediately in the gallery. | Phase 1 |
| [3 - Marquee, Stagger, And Motion References](./phase-03-marquee-stagger-and-motion-references.md) | Publish bounded decorative motion with static defaults, explicit native opt-in/stop controls and duplicate-content safety, together with real Motion reference pages. | Phase 2 |
| [4 - Scroll Indicator And Cover Flow](./phase-04-scroll-indicator-and-cover-flow.md) | Add decorative scroll progress and optional 3D media presentation using scoped native timelines while keeping static content and Carousel semantics authoritative. | Phase 3 |
| [5 - Image Gallery And Native Lightbox](./phase-05-image-gallery-and-native-lightbox.md) | Publish the complete responsive image-gallery experience with real local fixtures, native Dialog enlargement and ordinary destinations, treating origin transitions only as optional proven CSS. | Phase 4 |
| [6 - Gallery, Documentation, And Milestone Acceptance](./phase-06-gallery-documentation-and-milestone-acceptance.md) | Consolidate all Motion and Media references, complete compositions, capability and performance evidence, public documentation and release audits without deferring essential component demos until this phase. | Phase 5 |

The order is deliberate: shared contracts and static asset handling precede
media components; Carousel precedes Cover Flow; existing Dialog precedes Image
Gallery; final acceptance consolidates rather than postpones demo delivery.

Each phase has four sections, eight tasks and twenty-four subtasks. Every phase,
section and task starts with a description, and the last implementation section
is integration tests. There are 24 planned section commits across six phase PRs.

## Incremental gallery delivery

Append Media and Motion categories to the closed catalogue without renaming or
removing A–D pages. Every component phase must update navigation, breadcrumbs,
canonical route, source links, export, sitemap and smoke coverage in that same
phase. Each reference includes working examples, an inert copyable HEEx source,
API/slot details, keyboard/focus guidance, themes, suppressed/unsupported states,
provenance, and plain-language caller responsibilities.

| Phase | Actual routes introduced or expanded |
| --- | --- |
| 1 | `/examples/motion-media-capabilities`; shared motion inspection and local fixture export infrastructure |
| 2 | `/components/media/carousel`; begin `/examples/media-browser` |
| 3 | `/components/motion/marquee`, `/components/motion/stagger`, `/examples/motion-preferences` |
| 4 | `/components/motion/scroll-indicator`, `/components/media/cover-flow`; expand media-browser and motion examples |
| 5 | `/components/media/image-gallery`, `/examples/image-gallery` |
| 6 | Consolidate all references, compositions and evidence; verify all A–E routes |

The dedicated `/examples/image-gallery` is the substantial gallery composition,
not just a row of thumbnails in the component reference. It uses licensed or
authored local fixtures, useful captions, varied aspect ratios, responsive
layouts, native lightboxes and honest fallback links.

Static publication extends the existing selected three code/style assets with
only manifest-listed media. It must validate paths, dimensions, hashes and
direct/subpath links, reject unlisted files and stale copies, and remain
deterministic without remote image fetches. Demo images, observations, fixture
manifests and export scripts remain outside the Hex release.

## Capability and source evidence

CSS specifications describe eligible features, not guaranteed browser behavior.
Phase 1 records normative capability bundles separately from observed results in
the exact locked Chromium, Firefox and WebKit versions. Negative-capability
fixtures must exercise static fallbacks even on a browser that supports an
enhancement. There is no user-agent or engine-name branch in package code.

The platform references and six pinned upstream component patterns were reviewed
on 2026-08-26. The [foundation notes](../../../docs/motion-media-foundations.md)
record source paths, adaptation choices and separate executed browser evidence.
These are foundation probes, not acceptance of future components or a comparison
with an unpinned live gallery. Update the review and evidence when admitting an effect.

Origin-aware Image Gallery presentation is an explicit admission checkpoint:
record a proven native CSS path or a documented deferral. Neither failure of
that optional effect nor deferred generated controls permits omitting the useful
baseline component, actual gallery page, or its tests.

## Delivery rules

1. Start a feature branch from synced main for each implementation phase.
2. Complete and verify sections in order, making one commit per section.
3. Add actual gallery pages and proof with their component sections; do not
   defer all demo work to Phase 6.
4. Update checkboxes and requirement references only when implementation and
   evidence land. Missing future test targets are not passing coverage.
5. Open one PR for the completed phase, with checks, limitations and evidence.
   Do not merge it without a subsequent request.
6. If evidence changes a durable design choice, revise the ADR and specification
   explicitly before changing its contract.

## Milestone exit

All six component APIs and real gallery references must be delivered, with
ordinary/native fallbacks, bounded motion, image failure behavior and documented
ownership. All 38 requirements need real proof; the coverage map is only an
assignment, not evidence.

Acceptance includes package/demo precommit, locked assets and browser builds,
unit and three-engine integration tests, explicit keyboard/focus/semantic
checks alongside axe, reduced motion, forced colors, RTL, zoom, narrow layouts,
CSS-disabled/no-script and deliberately missing-feature paths. Exercise native
state replacement and bounded stationary/offscreen work at realistic item counts.

Verify all A–E routes, deterministic direct/subpath static exports, local media
hashes and links, ExDoc, public imports, isolated CSS, attribution, and the actual
Hex archive allowlist. Record manual screen-reader observations and deployed
smoke evidence separately; automation is not a substitute and a local export is
not proof of deployment. Do not publish or deploy without authorization.

Run SpecLed and whitespace checks at every phase boundary. The existing local
nested-command/OTP compatibility limitation must remain visible until repaired;
do not waive checks or report a failed command as passing. Planning-only missing
test targets are expected now and must be replaced by implemented evidence
during this wave.

## Deferred work

Generated scroll controls, endless Marquee playback, custom dragging, media
players/editors, uploads, image transformation services, infinite virtualization,
application navigation/state, and arbitrary animation or JavaScript runtimes
remain outside this wave. Optional origin presentation is deferred unless its
native CSS evidence passes.
