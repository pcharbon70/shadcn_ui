# Marquee, Stagger, and Scroll Indicator

```spec-meta
id: shadcn_ui.motion_components
kind: package
status: active
summary: Finite Marquee, bounded Stagger and source-local Scroll Indicator implemented.
decisions:
  - shadcn_ui.motion_media_capability_css
  - shadcn_ui.bounded_motion
surface:
  - lib/shadcn_ui/components/motion/scroll_indicator.ex
  - test/shadcn_ui/components/motion/scroll_indicator_test.exs
  - assets/scroll-indicator.css
  - test/shadcn_ui/scroll_media_integration_test.exs
  - scripts/render-scroll-media-fixture.exs
  - test/fixtures/milestone_e_scroll_media.html
  - test/browser/configs/playwright.milestone-e-phase4.config.mjs
  - test/fixtures/milestone_e_motion.html
  - test/shadcn_ui/motion_integration_test.exs
  - lib/shadcn_ui/components/motion/marquee.ex
  - lib/shadcn_ui/components/motion/stagger.ex
  - assets/marquee.css
  - assets/stagger.css
  - scripts/render-motion-fixture.exs
  - test/browser/configs/playwright.milestone-e-phase3.config.mjs
  - lib/shadcn_ui/components/motion/**/*.ex
  - test/shadcn_ui/components/motion/**/*.exs
  - test/browser/milestone-e-motion.spec.mjs
  - test/browser/milestone-e-scroll-indicator.spec.mjs
```

## API contract

Functions marquee/1, stagger/1 and scroll_indicator/1 are defining
modules under ShadcnUI.Components.Motion. Shared motion preference is system
or none and cannot override an ancestor suppression scope or user preference.
All three Motion components are implemented through Phase 4.
Marquee requires `accessible_label`; durations are brief (2500ms) and default
(5000ms). Item maps accept only key/text/image, and image maps only
src/alt/width/height/srcset/sizes/loading/decoding. No caller globals are copied
into the clone. Its native hidden attribute preserves the CSS-disabled fallback;
the admitted finite CSS gate reveals it only while the preview animation runs.

Marquee requires a stable id, accessible name and nonempty structured items
with unique keys, escaped text and optional presentation image records. Mode
is static (default) or preview; direction is inline_start or inline_end; duration
is a closed preset no longer than five seconds including any delay. Preview
renders a labelled native unnamed checkbox, initially unchecked, with instructions
for stop/reset and replay. No arbitrary inner_block is accepted for duplication.

Stagger takes repeated keyed item slots with trusted HEEx. Effect is none
(default), fade or rise; interval/duration presets have an explicit capped total
window of at most one second. Beyond the bounded stagger window items appear
immediately. Never calculate unbounded delays or hide content until an observer
fires. Semantic wrappers and order remain explicit; no list role is inferred
for arbitrary non-list content.

Stagger requires id and unique keyed item slots, and exposes as=div/ul/ol with
div or li item wrappers respectively. Optional item class/rest preserve caller
composition. Presets quick (150ms duration / 50ms step) and default (250ms / 75ms)
use only validated internal numeric CSS properties; out-of-budget items get zero
delay/duration. Fade/rise start at opacity 0.5, never zero, have no fill/repeat,
and focus cancels the item effect. Replacement or restored CSS can replay it.

Scroll Indicator owns one named keyboard-focusable native block scroll region
and an aria-hidden decorative track. Its required inner content remains native
HEEx. Closed size choices bound the region. It does not target arbitrary remote
scroll nodes or document-wide selectors. A scoped CSS scroll timeline decorates
only its own track, with a neutral/no-track static fallback and no numeric API.

Scroll Indicator requires id and exactly one accessible_label/labelledby with
optional escaped description. size=small/default/large bounds native height to
12/20/32rem; default is 20rem. Global identities/names/style are protected.
The track is outside the scroll viewport, so it cannot cover focus/content.
Joint timeline/name/range/scope, no-preference and no forced colors gate width
decoration. Baseline width is zero; inactive short-content timelines and shared
suppression cannot fabricate full progress. Instance names use encoded IDs.

## Safety and lifecycle

A checked Marquee preview checkbox means the finite preview is enabled, not that
animation is currently playing. Unchecking restores the static readable list;
checking again replays. Hover/focus pausing may supplement but never replace
that persistent stop/reset. The decorative clone is hidden in every static path.
The page must remain useful after an animation ends, is interrupted, has its
styles removed, or is replaced by a fresh server render.

Finite effects may finish offscreen but cannot run continuously. Scroll-driven
decoration remains tied to source movement; no timer supplies a fallback
timeline. Reduced motion removes marquee travel, stagger reveal/translation and
Cover Flow transforms; indicator decoration becomes static. Forced colors and
keyboard focus must never depend on animated color or opacity.

## Requirements

```spec-requirements
- id: shadcn_ui.motion_components.marquee_static
  statement: Marquee shall default to a complete static semantic list and expose preview only through an initially unchecked labelled native control, without autoplay, infinite loops, live updates or an animation-owned form value.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_components.marquee_control
  statement: The preview shall finish within five seconds, return a readable static result, support persistent native stop/reset and explicit replay, and never mislabel checkbox state as observed animation progress.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_components.marquee_duplicates
  statement: Marquee shall accept only structured noninteractive presentation content for at most one clone track, omit clone IDs and actions, hide it from accessibility and focus, and exclude it from static, reduced-motion and CSS-disabled presentation.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_components.stagger
  statement: Stagger shall preserve caller content and order, default to no effect, bound its total delay plus duration to one second, immediately show excess items, and reveal focused or interrupted content without viewport observation.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_components.indicator
  statement: Scroll Indicator shall decorate its own named native scroll region using scoped CSS progress without progressbar, task-completion, reading-percentage, selected-state or live announcement semantics.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_components.timeline_fallback
  statement: Missing scroll/view timeline or range/scope capabilities shall select static complete content, never a document-time animation, hidden content or fabricated progress value.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_components.suppression
  statement: All motion components shall obey explicit and system suppression with no nested re-enablement, keeping content, labels, native scrolling, links and controls usable.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_components.work_budget
  statement: Motion components shall add no listeners, observers, polling or perpetual animations; finite work shall stay within the declared duration and duplication budgets, and stationary scroll sources shall not advance scroll-driven effects.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_components.motion_replacement
  statement: Documentation and tests shall distinguish rendered/native checkbox and scroll state from application state and show replacement reset without package persistence, replay tracking or restoration.
  priority: must
  stability: stable
```

## Verification

The internal-record reorganization moves CSS engineering notes under
`assets/engineering/` and updates path-sensitive tests only. Motion APIs,
suppression, budgets and executable proof are unchanged.

The Phase 8 browser-harness stability refinement preserves the existing motion
behavior and keeps this subject's declared verification current.

All three rendering and browser targets now exist. The [Milestone E plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
assigns their implementation phases. Missing targets remain visible in SpecLed
until implemented; no placeholder passing test or disabled gate substitutes for
actual proof. Add requirement references in each target as the tests land.

```spec-verification
- kind: test_file
  target: test/browser/milestone-e-budgets.spec.mjs
  covers:
    - shadcn_ui.motion_components.marquee_duplicates
    - shadcn_ui.motion_components.work_budget

- kind: test_file
  target: test/shadcn_ui/components/motion/marquee_test.exs
  covers:
    - shadcn_ui.motion_components.marquee_static
    - shadcn_ui.motion_components.marquee_control
    - shadcn_ui.motion_components.marquee_duplicates

- kind: test_file
  target: test/shadcn_ui/components/motion/stagger_test.exs
  covers:
    - shadcn_ui.motion_components.stagger
    - shadcn_ui.motion_components.suppression

- kind: test_file
  target: test/shadcn_ui/components/motion/scroll_indicator_test.exs
  covers:
    - shadcn_ui.motion_components.indicator
    - shadcn_ui.motion_components.timeline_fallback

- kind: test_file
  target: test/browser/milestone-e-motion.spec.mjs
  covers:
    - shadcn_ui.motion_components.marquee_control
    - shadcn_ui.motion_components.marquee_duplicates
    - shadcn_ui.motion_components.stagger
    - shadcn_ui.motion_components.suppression
    - shadcn_ui.motion_components.work_budget
    - shadcn_ui.motion_components.motion_replacement

- kind: test_file
  target: test/browser/milestone-e-scroll-indicator.spec.mjs
  covers:
    - shadcn_ui.motion_components.indicator
    - shadcn_ui.motion_components.timeline_fallback
    - shadcn_ui.motion_components.work_budget
```
