---
id: shadcn_ui.native_carousel_cover_flow
status: accepted
date: 2026-08-26
affects:
  - shadcn_ui.media_components
  - shadcn_ui.motion_media_gallery
---

# Keep Carousel And Cover Flow As Native Scrollable Content

## Context

A CSS carousel can look like a widget while only implementing a scrollable list. Generated marker modes can change roles and keyboard behavior; a visual current item is not server-owned selection.

## Decision

Carousel renders a named, keyboard-focusable native inline scroll region containing an ordered list of stable keyed items. Each item has a text label and trusted HEEx body. Real fragment links provide an ordinary item index; native scrolling is also available. The index is not pagination over remote data, and a hash target is not a synchronized active-slide value.

Default snap is proximity; closed none/proximity/mandatory options must preserve access to oversized content, child focus and scroll escape. Use logical inline layout, visible focus and adequate scroll padding. There is no autoplay, loop clone, draggable transform track, roving tabindex, live announcement or selected-state API. Do not emit tab, tabpanel, listbox, menu or aria-roledescription=carousel claims.

CSS-generated scroll buttons/markers are deferred from package output in Milestone E. Their declaration support alone does not justify replacing real index links or claiming the ARIA carousel pattern. A bounded demo capability experiment is permitted, distinctly labelled and excluded from the archive.

Cover Flow is a reusable media composition over the same scroll/list/index model, not a separate controller. Its structured image items retain the shared image contract. Optional view-progress transforms affect decorative image presentation only; captions, destinations and focus outlines remain readable in normal order. Missing timelines, unsuitable layout, reduced motion and forced colors use the flat native scroller. No hidden inactive slides, perspective-only required information, transform-based hit-test trick or z-index focus obstruction is allowed.

Applications own item order, content, navigation, state restoration and replacement. Replacing a list may reset scroll position; the package does not measure or restore it.

## Alternatives considered

- A selected-slide widget with previous/next commands requires state and focus
  behavior not supplied by an ordinary list; the package does not pretend to
  implement that contract.
- Generated scroll controls could provide native navigation, but their semantic
  and interoperability evidence is not yet established here; they are deferred.
- Independent Cover Flow navigation would duplicate Carousel semantics and
  validation; composition keeps one native content and destination model.

## Consequences

The visual vocabulary is intentionally narrower than a scripted carousel. All items remain reachable with ordinary browser behavior. 3D presentation can be gated without sacrificing the baseline; remote pagination and automatic advance remain outside the package.

## Verification and delivery

The linked Milestone E subjects define normative requirements; the
[implementation plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
assigns proof and delivery phases. Accepted here means an approved design
contract, not an implemented or browser-verified feature.

## Reviewed platform sources

Review date: 2026-08-26. Draft specifications are design references, not evidence
that a shipping browser implements every feature. Recheck sources and actual
locked engines in Phase 1 and whenever an enhancement is admitted.

- <https://www.w3.org/TR/css-scroll-snap-1/>
- <https://drafts.csswg.org/css-overflow-5/>
- <https://drafts.csswg.org/scroll-animations-1/>
