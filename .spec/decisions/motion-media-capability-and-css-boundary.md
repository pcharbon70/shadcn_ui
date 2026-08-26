---
id: shadcn_ui.motion_media_capability_css
status: accepted
date: 2026-08-26
affects:
  - shadcn_ui.motion_media_contract
  - shadcn_ui.motion_media_gallery
---

# Keep Motion And Media Native, Capability-Based, And Runtime-Free

## Context

Modern CSS can decorate native scrolling and media, but parsing a declaration does not prove keyboard behavior, accessibility-tree semantics or interoperability. The extracted package must not target a particular application, operating system or embedded runtime.

## Decision

Milestone E ships no package JavaScript, animation framework, observer, timer, drag controller, image loader, scroll listener or view-transition controller. Support is defined by component capabilities; exact locked Chromium, Firefox and WebKit builds are evidence only. This carries forward Milestone D's web-platform boundary and supersedes any historical Electron-specific verification wording for this wave.

Six public defining components are planned: Media.Carousel, Media.CoverFlow, Media.ImageGallery, Motion.Marquee, Motion.ScrollIndicator and Motion.Stagger. Cover Flow composes the Carousel contract; Image Gallery composes the existing Dialog contract. There is no second public Lightbox state machine. Shared validation and CSS helpers remain internal; imports and ExDoc expose defining modules.

Native lists, links, images, scrolling and ordinary destinations are the baseline. CSS snap, generated scroll controls, scroll/view timelines, scoped anchors and discrete transitions are independent enhancements. Do not hide baseline controls merely because CSS.supports returns true. Generated controls remain excluded from the released API in this wave; demo-only investigation may record their observed accessibility behavior without making them required.

Phase 1 creates a normative motion/media capability manifest and schema, separate from demo-only observations. Record reviewed source URLs, review date, capability bundles, explicit fallback and admission status. Retain the existing browser locks unless a deliberate separate lock update is necessary; execute the exact builds before claiming support.

Utilities remain the first choice. An authored CSS exception ledger records each selector/keyframe family, why utility composition is insufficient, source/provenance, feature guard, fallback, theme/reduced-motion behavior and tests. Scope selectors to component markers; namespace keyframes, anchors, timeline names and custom properties. No global reset, remote URL, unrestricted consumer CSS interpolation or runtime Tailwind requirement is admitted.

## Alternatives considered

- A package animation/controller runtime would offer broader behavior but expand
  ownership beyond native HEEx and CSS; it is excluded from this wave.
- A single-browser minimum would simplify demonstrations but make the extracted
  library consumer-specific; capability bundles and complete fallbacks are used.
- Utility-only CSS would avoid an exception ledger but obscure advanced
  selectors and timelines; narrowly justified, scoped authored CSS is permitted.

## Consequences

The package can offer useful static/native results on browsers missing enhancements. Experimental effects may be omitted after failed evidence, but the named baseline component and its demo must still ship. Admitting generated controls, endless motion or a runtime later requires a new decision, not a browser-name branch.

## Verification and delivery

The linked Milestone E subjects define normative requirements; the
[implementation plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
assigns proof and delivery phases. Accepted here means an approved design
contract, not an implemented or browser-verified feature.

## Reviewed platform sources

Review date: 2026-08-26. Draft specifications are design references, not evidence
that a shipping browser implements every feature. Recheck sources and actual
locked engines in Phase 1 and whenever an enhancement is admitted.

- <https://drafts.csswg.org/css-overflow-5/>
- <https://drafts.csswg.org/scroll-animations-1/>
