---
id: shadcn_ui.responsive_media_lightbox
status: accepted
date: 2026-08-26
affects:
  - shadcn_ui.motion_media_contract
  - shadcn_ui.media_components
  - shadcn_ui.motion_media_gallery
---

# Keep Responsive Images Caller-Owned And Reuse Native Dialog For Lightboxes

## Context

A gallery needs image identity, intrinsic layout, alternative text and complete destinations, not an image-management service. Origin-aware lightbox effects must not introduce a second modal or focus system.

## Decision

Use shared internal normalization for structured media values: stable key, source, explicit alt, positive intrinsic width/height, optional srcset/sizes, caption, full-size source/dimensions and complete destination. Require nonblank alt for meaningful gallery/cover images; allow empty alt only with explicit decorative intent and a separate complete control/destination name. Preserve native responsive source selection, loading and decoding. Default thumbnail loading is lazy with a documented eager override; hidden dialog media loading is a browser hint, never an on-demand network guarantee.

The package never downloads or transforms images, builds srcset, infers captions/alt, sanitizes untrusted HTML, signs URLs, authorizes image access or adds load/error state. Reject unsafe URL schemes and malformed known fields; allow root-relative paths and explicit HTTP(S) media sources under caller CSP/origin policy. No inline data/script URLs, remote media in package CSS, or arbitrary string-to-style/HTML conversion is accepted. Render ordinary failure text/alt/caption and a complete destination if decoding fails.

Image Gallery renders a semantic list/grid of figures and captions. Each item may compose one initially closed existing Dialog with a stable derived ID, named native invoker and visible close control. A separate ordinary full-image/detail link remains outside the modal. Do not nest a link in its invoker button. Multiple items do not imply simultaneous or nested modals.

Retain Dialog's naming, initial-focus intent, close-request default, native focus/inertness/dismissal/restoration and replacement contract. No selected-image state, next/previous modal controller, swipe, zoom/pan, upload, fetch-on-open or package keyboard listener is added. Enlarged images use contain presentation and preserve complete captions, with native scrolling for long content.

An origin-aware transition is an optional CSS-only enhancement contingent on scoped native anchor/transition evidence for the existing invoker and dialog. It must snap open/closed without support, when reduced motion is requested, or when its origin is missing. Shared-element/view-transition JavaScript and measured coordinates are excluded; if reliable CSS-only origin behavior is unavailable, deliver the native lightbox and document the deferred effect.

Demo fixtures are small locally authored/licensed files with recorded origin, license, dimensions, byte size and hashes. Include intentional broken/missing-image cases. Export only a closed fixture manifest; never fetch third-party stock images during build. Demo image assets and their manifest stay outside the package release.

## Alternatives considered

- A new Lightbox controller would duplicate Dialog focus and dismissal ownership;
  reuse preserves one native modal contract.
- A single selected-image modal with next/previous controls would require client
  selection state; per-item native dialogs and ordinary destinations avoid it.
- A package image loader or transform service would own network, privacy and
  processing policy; native image hints and caller records are the boundary.
- JavaScript-measured shared-element transitions could reproduce more effects,
  but are excluded; unproven CSS origin presentation is deferred.

## Consequences

Consumers retain media privacy, bandwidth, licensing and content responsibility. A static gallery and ordinary destinations remain useful below the Dialog capability floor. Native lazy loading cannot be advertised as authorization or demand loading.

## Verification and delivery

The linked Milestone E subjects define normative requirements; the
[implementation plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
assigns proof and delivery phases. Accepted here means an approved design
contract, not an implemented or browser-verified feature.

## Reviewed platform sources

Review date: 2026-08-26. Draft specifications are design references, not evidence
that a shipping browser implements every feature. Recheck sources and actual
locked engines in Phase 1 and whenever an enhancement is admitted.

- <https://html.spec.whatwg.org/multipage/images.html>
- <https://html.spec.whatwg.org/multipage/embedded-content.html#the-img-element>
- <https://html.spec.whatwg.org/multipage/interactive-elements.html#the-dialog-element>
