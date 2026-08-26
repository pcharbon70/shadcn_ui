# Phase 4 - Scroll Indicator And Cover Flow

Back to wave: [README](./README.md)

## Dependencies and contracts

Requires Phases 1–3 capabilities, suppression, Carousel contract and Motion/Media catalogue infrastructure.

- [motion_media_contract](../../specs/motion_media_contract.spec.md)
- [motion_components](../../specs/motion_components.spec.md)
- [media_components](../../specs/media_components.spec.md)
- [motion_media_gallery](../../specs/motion_media_gallery.spec.md)

- [x] 4 Phase - Scroll Indicator And Cover Flow.

  Add decorative scroll progress and optional 3D media presentation using scoped native timelines while keeping static content and Carousel semantics authoritative.

  - [x] 4.1 Section - Decorative Scroll Indicator.

    Render scroll position decoration without implying task completion, reading state or a numeric measurement API.

    - [x] 4.1.1 Task - Implement the named native scroll composition.

      The source region and its decoration should share a deterministic instance boundary.

      - [x] 4.1.1.1 Subtask - Add Motion.ScrollIndicator.scroll_indicator/1 with required id/name, trusted inner content and closed bounded size choices.
      - [x] 4.1.1.2 Subtask - Render a named focusable native block scroll region plus aria-hidden decorative track; preserve caller headings, links/forms and native scroll keys.
      - [x] 4.1.1.3 Subtask - Do not emit progressbar, value, percentage, live region, external scroll-target selector or synchronized application state.

    - [x] 4.1.2 Task - Implement scoped timeline and neutral fallback.

      Absent timeline support must not become a document-clock animation or fake progress.

      - [x] 4.1.2.1 Subtask - Gate timeline, range and scope dependencies jointly, isolate each instance and bind only its own decorative track to native scroll progress.
      - [x] 4.1.2.2 Subtask - Retain complete content with a neutral or absent track when unsupported, reduced-motion, explicit suppression or forced colors makes animation unsuitable.
      - [x] 4.1.2.3 Subtask - Test stationary sources, short/nonoverflowing content and replacement; add no listener, polling, observer, completion callback or unbounded work.

  - [x] 4.2 Section - Cover Flow composition over Carousel.

    Add optional image depth while keeping the underlying native list, index and destinations unchanged.

    - [x] 4.2.1 Task - Implement structured Cover Flow and flat baseline.

      The new component should reuse validated media and Carousel structure instead of duplicating a controller.

      - [x] 4.2.1.1 Subtask - Add Media.CoverFlow.cover_flow/1 with stable structured images/captions/destinations and flat/enhanced presentation; import the defining module directly.
      - [x] 4.2.1.2 Subtask - Reuse Carousel naming, IDs, native scroll/list/index and ordinary keyboard behavior without active-image, swipe, drag or hidden-slide state.
      - [x] 4.2.1.3 Subtask - Preserve intrinsic dimensions, explicit alt and loading hints; render captions and destinations outside decorative transforms and provide broken-image examples.

    - [x] 4.2.2 Task - Admit only evidence-backed 3D CSS.

      A visual enhancement must not obscure focus, captions or hit targets.

      - [x] 4.2.2.1 Subtask - Gate view-progress/range/transform dependencies together and record precise CSS exceptions and instance-scoped names; do not fallback to a time-based loop.
      - [x] 4.2.2.2 Subtask - Keep flat presentation under missing support, motion suppression, forced colors and layouts failing readability/hit-target tests; document these gates.
      - [x] 4.2.2.3 Subtask - Verify overlapping image decoration never captures another item's link or clips its focus indicator; do not measure coordinates or manipulate z-index through runtime code.

  - [x] 4.3 Section - Immediate scroll and Cover Flow gallery references.

    Make both enhanced and deliberately unavailable paths inspectable in the real catalogue.

    - [x] 4.3.1 Task - Publish the two reference pages and update compositions.

      The demo should connect presentation effects to their complete native fallback.

      - [x] 4.3.1.1 Subtask - Add /components/motion/scroll-indicator and /components/media/cover-flow to catalogue, breadcrumbs/current state, canonical URLs, sitemap/export and smoke inventory.
      - [x] 4.3.1.2 Subtask - Show local media, many/few/no-overflow items, long captions, RTL, native scroll keys, independent instances, neutral progress and flat Cover Flow.
      - [x] 4.3.1.3 Subtask - Extend media-browser and motion-preferences compositions with actual components; show feature detection separately from passed behavior and preserve no-script navigation.

    - [x] 4.3.2 Task - Publish ownership and performance guidance.

      Consumers must not interpret decorative progress or depth as domain state.

      - [x] 4.3.2.1 Subtask - Document all attrs/slots, stable keys, motion/size choices, source scope, native keyboard/focus and lack of numeric reading or selected-image state.
      - [x] 4.3.2.2 Subtask - Record CSS timeline failure paths, stationary-source behavior, finite/no-perpetual-work limits and browser-local reset after replacement.
      - [x] 4.3.2.3 Subtask - Update source examples, capability records, authored CSS ledger, upstream mappings and public docs without importing remote media or runtime tooling.

  - [x] 4.4 Section - Phase 4 Integration Tests.

    Verify real native scroll behavior, isolated timelines and accessible flat fallbacks across the locked engines.

    - [x] 4.4.1 Task - Verify structure, scroll behavior and enhancement rejection.

      Tests should observe progress only where supported and require identical native content everywhere.

      - [x] 4.4.1.1 Subtask - Add Scroll Indicator/Cover Flow unit tests for values, scoped identities, image metadata, captions, escaping, globals, native lists/index and forbidden roles/state/runtime.
      - [x] 4.4.1.2 Subtask - Add milestone-e-scroll-indicator.spec.mjs and milestone-e-cover-flow.spec.mjs for native keys/touch, independent sources, idle progress, focus visibility, hit targets, oversized images and replacement.
      - [x] 4.4.1.3 Subtask - Exercise joint feature removal, no-script/CSS-disabled, short content, wide/narrow/zoom/RTL, themes, reduced motion/ancestor suppression and forced colors; include axe plus explicit decoration/meaning assertions.

    - [x] 4.4.2 Task - Verify incremental release and whole-gallery compatibility.

      Timeline enhancements cannot compromise earlier component behavior or static publication.

      - [x] 4.4.2.1 Subtask - Run package/demo precommit, scoped CSS audit, deterministic fixture and asset builds, complete route/export/sitemap and static media subpath checks.
      - [x] 4.4.2.2 Subtask - Rebuild ExDoc/archive, verify provenance and authored CSS records, and prove no demo media, observation, observer or generated control ships in the package.
      - [x] 4.4.2.3 Subtask - Run all affected native/overlay/Carousel/motion regressions, SpecLed and whitespace checks and record exact enhanced versus fallback evidence before section commits.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge that PR without a later request.
Keep all checkboxes unchecked until the corresponding implementation and proof
land. Update relevant specifications only after reading their full contracts.

## Execution record

Implemented on 2026-08-26 after merging PR #16, fast-forwarding local main and
deleting its corresponding local/remote feature branch. This phase uses four
section commits and one review PR; Image Gallery and final acceptance are next.

- Section 4.1: named native Scroll Indicator with trusted content, bounded
  sizes, encoded instance-local timeline and external aria-hidden track.
  Joint timeline/range/scope support decorates only its own source. Short,
  unsupported, reduced and forced-color paths stay neutral. Verified with
  350 package tests and nine initial three-engine checks before its commit.
- Section 4.2: structured Cover Flow composes Carousel's complete list, focus
  targets and real index. Validated images retain alt, dimensions, responsive
  metadata, captions and ordinary destinations. Wide eligible containers admit
  bounded image-only depth; all other cases remain flat. No overlap, animated
  stacking, reflection or hit-target capture. Verified with 354 package tests
  and 18 browser checks before its commit. E-05/E-06 document exact CSS gates.
- Section 4.3: both real reference pages, compile-tested public HEEx examples,
  local images, broken/long/short/RTL examples and independent instances.
  Both existing media-browser and motion-preferences compositions use the actual
  components. Catalogue, canonical/preference variants, sitemap and selected
  media export are updated. Separate component outcomes do not replace parsing
  evidence. Verified with 56 demo tests, 30 browser checks and 614 exported
  variants before its commit.
- Section 4.4: individually removed joint feature gates, actual no-script
  subpath exports, native keys/touch activation/RTL, focus and hit targets,
  image failure, oversized intrinsic images, idle sources, replacement,
  reduced/ancestor/forced-color suppression, both themes, narrow/200% CSS zoom
  and axe plus explicit semantic checks. Added scoped CSS/provenance/runtime
  integration audits and CI/archive gates. The final attribute audit rejects
  conflicting progress/selection/role-description globals and malformed slots.

### Observed component matrix

The demo-only scroll_media_evidence.json is asserted against actual component
behavior and the exact existing browser lock, not inferred from engine names.

| Engine | Exact version | Scroll Indicator | Cover Flow |
| --- | --- | --- | --- |
| Chromium | 151.0.7922.34 | Source-local decoration | Image-only depth |
| Firefox | 153.0 | Neutral track | Flat images |
| WebKit | 26.5 | Source-local decoration | Image-only depth |

Enhanced observations require permitted system motion, no forced colors and,
for Cover Flow, a multi-image container at least 40rem wide. Removing any joint
dependency leaves complete neutral/flat content. Stationary sources do not
advance their effects; no DocumentTimeline substitutes for a scroll timeline.

### Direct verification

- Package precommit: 356 passing tests; demo precommit: 56 passing tests.
- Phase 4 browser suite: 48 passing checks.
- Earlier browser regressions: E foundations 60, Carousel 39, Marquee/Stagger
  45, D gallery 39, baseline/demo 11, C gallery 5; D native foundation 21,
  Dialog/Alert Dialog 21, Drawer 30, Popover/Dropdown 30, supplemental surfaces
  36. Total: 337 earlier checks, 385 including this phase.
- Exact three-engine foundation evidence check passes unchanged.
- Root/demo asset checks and deterministic fixture checks pass, including
  development and test generation. Two exports have identical bytes.
  Export audit and repository-subpath smoke cover 614 route variants,
  three selected code/style assets and three manifest-listed media files.
- ExDoc builds without documentation warnings. Actual Hex candidate audit
  verifies 60 entries, including both new defining modules, excluding demo
  images, fixture/evidence records, harnesses, scripts and generated output.
- Whitespace and explicit staging audits pass; user logs and generated SpecLed
  state are not part of any phase commit.

### Limits and test-harness observations

Native keyboard scrolling can continue after key release: idle measurements
wait for the scroll transaction to settle before sampling. Horizontal tests use
native arrow keys rather than treating End as a cross-browser inline-scroll
command. Identity matrices count as flat presentation. Firefox can restore
document state after document.write; actual subtree replacement demonstrates
fresh native scroll state without imposing an application restoration policy.
No test retries, skips, production listeners or runtime shims conceal these facts.

Touch tests exercise native taps and fragment/destination navigation, not
physical-device gesture certification. Zoom coverage uses CSS zoom at 200%;
automated axe/semantics and screenshot inspection do not certify screen readers
or browser-chrome zoom. Windows cannot create the symlink fixture (eperm); the
existing Linux CI rejection test remains required. No Pages deployment, manual
assistive-technology acceptance or Hex publication is claimed.

SpecLed prime/next/full check ran. The full check reports four existing nested
command failures (component/form/package precommit and gallery smoke), with
143 warnings, across 22 subjects and 214 requirements. The login shell selects
Elixir 1.18.0 while direct PowerShell uses 1.20.3 with OTP 29; dependency
compilation fails in the nested runner. Direct equivalent checks pass.
No configured gate, toolchain policy or future target was disabled. Shared
README/CSS surfaces make spec.next flag earlier subjects broadly; only the
motion/media, gallery, stylesheet, provenance and package contracts changed.

Milestone E remains incomplete: Phase 5 (Image Gallery and Native Lightbox) and
Phase 6 (Gallery, Documentation and Milestone Acceptance) remain pending.
