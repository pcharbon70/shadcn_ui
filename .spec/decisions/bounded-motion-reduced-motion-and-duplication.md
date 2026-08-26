---
id: shadcn_ui.bounded_motion
status: accepted
date: 2026-08-26
affects:
  - shadcn_ui.motion_components
  - shadcn_ui.motion_media_contract
  - shadcn_ui.motion_media_gallery
---

# Make Decorative Motion Optional, Bounded, And Safely Duplicated

## Context

Reduced motion does not replace a pause/stop mechanism, and hover-only pausing ties the user's focus to the effect. Endless CSS loops also conflict with the roadmap's rejection of continuously running offscreen work without a package observer.

## Decision

Marquee defaults to a static complete list. Its optional preview mode renders a labelled native checkbox, unchecked initially and without a form name, which enables one finite traversal. Unchecking stops the effect and returns the complete static list; checking again replays it. The label must describe enabling a finite preview, not falsely report a live playing state. An explicit stop/reset remains usable after focus leaves. No auto-start or infinite iteration value is offered.

The finite traversal budget, including delay, is at most five seconds; its final state is the readable canonical list. This is a conservative product policy, not a claim that WCAG prohibits all longer user-started motion. Reduced motion or a caller motion=none setting wins over the checkbox and retains the static list. If the native/CSS control combination is unsupported, the preview is unavailable and the list remains complete.

Marquee accepts structured text/presentation image items, never arbitrary interactive HEEx for cloning. Render at most one decorative duplicate track; it has no IDs, links, controls, form names, events or focus stops, is aria-hidden and inert, and is absent in static, CSS-disabled and reduced-motion presentation. Canonical content appears once in the accessibility tree. Images in a duplicate use empty alternative text. Do not depend on aria-hidden alone to disable focus.

Stagger is a bounded, opt-in render-time entrance effect over stable keyed trusted item slots. Cap the total delay-plus-duration at one second; items beyond the stagger window appear immediately. Content is visible by default and cannot remain hidden after unsupported CSS, interruption or focus. It does not detect entry into the viewport or guarantee animation-once across server replacement.

Scroll Indicator is decorative progress along its own named native scroll region, never task completion, reading comprehension, a progressbar or announced numeric value. Its static fallback contains the complete body and a neutral track or no decoration, never a fake percentage. Scroll/view timelines must be jointly gated with their range/scope dependencies so missing timelines cannot fall back to a repeating document-time animation.

No flashes, continuous offscreen loops, rAF, listeners, observers or polling are shipped. Finite effects may finish offscreen within their fixed budget; this does not claim automatic visibility pausing. Scroll-driven effects cannot advance while their source is stationary. Documentation records these precise limits.

## Alternatives considered

- Infinite autoplay with hover/focus pausing would leave ongoing offscreen work
  and make stopping depend on the user's pointer or focus; it is not offered.
- A visibility observer could manage pauses, but would introduce a runtime;
  fixed finite budgets are the accepted compromise.
- Cloning arbitrary slots could duplicate controls, IDs and actions; structured
  noninteractive presentation items keep duplication reviewable.
- Reduced-motion handling alone would not provide an ordinary stop mechanism;
  the finite Marquee preview also uses an explicit native control.

## Consequences

Marquee is a deliberate finite-preview adaptation rather than an endless news ticker. Durable pause state, live data updates and visibility-aware autoplay require another accepted design. Native checkbox and scroll state remain local and may reset on replacement.

## Verification and delivery

The linked Milestone E subjects define normative requirements; the
[implementation plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
assigns proof and delivery phases. Accepted here means an approved design
contract, not an implemented or browser-verified feature.

## Reviewed platform sources

Review date: 2026-08-26. Draft specifications are design references, not evidence
that a shipping browser implements every feature. Recheck sources and actual
locked engines in Phase 1 and whenever an enhancement is admitted.

- <https://www.w3.org/WAI/WCAG22/Understanding/pause-stop-hide.html>
- <https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html>
- <https://drafts.csswg.org/scroll-animations-1/>
