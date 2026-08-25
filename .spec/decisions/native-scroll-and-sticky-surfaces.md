---
id: shadcn_ui.native_scroll_sticky_surfaces
status: accepted
date: 2026-08-25
affects:
  - shadcn_ui.content_surfaces
  - shadcn_ui.navigation_components
  - shadcn_ui.stylesheet
  - shadcn_ui.content_navigation_gallery
---

# Preserve Native Scrolling And Static Content Fallbacks

## Context

Scroll areas, sticky headers, edge shadows, and anchored decoration can make
large pages easier to scan, but they can also trap keyboard users, hide focused
content, or make viewport observation a hidden runtime dependency. ShadcnUI must
provide layout presentation without inspecting application data or browser
scroll state.

## Decision

Milestone C content surfaces use native layout and scrolling as their behavioral
floor.

- Scroll Area renders one caller-sized container with native overflow. Closed
  axis and sizing options map to static classes; arbitrary dimensions remain
  caller CSS rather than request-derived utility names.
- A Scroll Area is not made focusable automatically. Callers may explicitly
  request keyboard focus only with a nonblank accessible name or relationship,
  and mandatory focus semantics override conflicting globals.
- The package does not measure content, observe the viewport, synchronize scroll
  position, virtualize children, add custom scrollbar controls, or emit scroll
  handlers. Native pointer, touch, wheel, keyboard, and assistive-technology
  behavior remains authoritative.
- Optional edge affordances are decorative CSS and never the only indication of
  more content. Unsupported CSS leaves the native scroll container and all
  children visible and operable.
- Sticky Section Header uses `position: sticky` only as progressive presentation.
  Unsupported or CSS-disabled environments retain the header in normal document
  flow, and scroll padding or margin preserves focused and fragment-targeted
  content where package layout creates an overlap risk.
- Separator uses a native `hr` when it separates content. A separately selected
  decorative mode is hidden from accessibility APIs and cannot claim structural
  meaning.

## Consequences

The components remain stateless and transport-neutral while supporting dense
application pages. Consumers must choose dimensions deliberately and own any
scroll restoration, virtualization, infinite loading, or viewport-driven state.
