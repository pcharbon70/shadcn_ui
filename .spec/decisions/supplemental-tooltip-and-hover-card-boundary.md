---
id: shadcn_ui.supplemental_surface_boundary
status: accepted
date: 2026-08-25
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.supplemental_surfaces
  - shadcn_ui.stylesheet
  - shadcn_ui.overlay_gallery
---

# Keep Tooltip And Hover Card Supplemental And CSS-First

## Context

Tooltip and Hover Card commonly depend on hover delays, focus, pointer exit,
touch behavior, top-layer placement, and coordinated dismissal. The emerging
interest-invoker platform is intended to provide that behavior declaratively,
but it is not an interoperable Chromium, Firefox, and WebKit baseline.
Implementing its unfinished interaction model in package JavaScript would
contradict the accepted native-runtime boundary.

CSS `:hover`, `:focus-visible`, and `:focus-within` can progressively reveal
supplemental content, but they cannot make required information or commands
reliably available across all pointer and touch environments.

## Decision

Milestone D publishes bounded CSS-first Tooltip and Hover Card contracts only.

- Tooltip relates one short escaped text description to one natively focusable
  caller trigger through deterministic `aria-describedby` identity. The visual
  bubble uses `role="tooltip"`, accepts no interactive descendants, never takes
  focus, and contains no required or unique task information.
- Tooltip visibility may respond to hover and keyboard focus through CSS.
  Reduced motion removes delay and transition. Unsupported CSS leaves the
  accessible description relationship intact even if the visual bubble is not
  presented.
- Hover Card supplements one ordinary caller-owned link with preview content.
  The link destination, accessible name, and activation remain complete without
  the card. The card contains no required controls, workflow step, authorization
  result, or information unavailable at the destination.
- Hover Card may remain visible while pointer or focus is within its bounded
  wrapper, but it adds no interest events, timers, long-press emulation, focus
  movement, top-layer claim, or package JavaScript. Coarse-pointer users use the
  underlying link; the gallery states this exact fallback.
- CSS anchor positioning may improve placement behind feature queries. Normal-
  flow or bounded absolute presentation is the fallback, and overflow handling
  must not obscure the trigger or required page content.
- `interestfor`, `popover="hint"` activation, interactive hover cards, and touch
  interest heuristics are deferred until the cross-engine web contract can
  accept them together.

## Consequences

These components provide useful visual affordances without promising an
interaction model the target platform cannot supply. Required help belongs in
visible Help, Alert, or page content; required actions belong in ordinary
controls or a supported Dialog or Popover.
