---
id: shadcn_ui.native_disclosure_grouping
status: accepted
date: 2026-08-25
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.disclosure_components
  - shadcn_ui.stylesheet
  - shadcn_ui.content_navigation_gallery
---

# Use Native Details For Disclosure And Grouping

## Context

Milestone C needs accordion-like disclosure without making ShadcnUI responsible
for client state, focus movement, or keyboard emulation. Native `details` and
`summary` already provide disclosure semantics, activation, keyboard behavior,
and content availability. The platform also supports exclusive groups through a
shared `name`, but that feature is an enhancement rather than a safe universal
baseline.

## Decision

Accordion is a composition of native `details` and `summary` elements.

- Every item requires a stable caller key, a nonempty summary, and trusted HEEX
  content. Item IDs and any group name are caller-supplied or deterministically
  derived from an explicit accordion ID and stable item keys.
- Independent mode emits no shared `name`; any number of items may be open.
  Exclusive mode gives every item the same deterministic `name` and documents
  that browsers without exclusive-details support may leave multiple items open.
- Caller-supplied initial `open` values describe the rendered server snapshot.
  ShadcnUI does not observe browser toggles, persist open state, or reconcile it
  across replacement renders.
- Native summary activation, keyboard behavior, focus, find-in-page behavior,
  and browser history remain authoritative. The package adds no disclosure role,
  button imitation, hidden duplicate control, or component JavaScript.
- Optional marker, height, and open-state animation is presentation only. All
  content remains reachable when CSS, exclusive grouping, or animation support
  is absent, and reduced motion removes nonessential animation.
- Applications own authorization, lazy loading, analytics, URL synchronization,
  validation, and any persisted disclosure state.

## Consequences

Accordion keeps a strong native baseline and works in controller-rendered HEEX.
Exclusive grouping degrades to independent disclosure instead of hiding content
or requiring a polyfill. A future disclosure widget that owns state or keyboard
behavior requires a separate runtime decision.
