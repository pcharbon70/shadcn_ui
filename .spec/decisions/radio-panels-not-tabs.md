---
id: shadcn_ui.radio_panels_not_tabs
status: accepted
date: 2026-08-25
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.content_surfaces
  - shadcn_ui.content_navigation_gallery
---

# Name Radio-Based Panel Switching Honestly And Defer True Tabs

## Context

The upstream pattern named “Tabs” uses radio inputs and CSS to select visible
content. A true ARIA tab interface requires tablist, tab, and tabpanel
relationships plus arrow-key navigation, focus management, activation policy,
disabled-item behavior, and dynamic selection synchronization. Relabeling a
radio pattern as tabs would overstate its semantics; implementing the full widget
would introduce a client-runtime boundary not approved for Milestone C.

## Decision

Milestone C may ship the pattern only as **Radio Panels**.

- Radio Panels renders a native fieldset, required legend, and one radio input
  per panel. Stable caller option keys deterministically derive input, label, and
  panel relationships, and one explicit scalar value selects the rendered
  snapshot.
- It exposes no `tablist`, `tab`, or `tabpanel` roles, arrow-key emulation,
  roving tabindex, automatic activation, focus movement, history integration, or
  package-owned selection state.
- Native radio keyboard and form behavior remains authoritative. Applications
  own the selected value, server rerender, persistence, validation, and any
  navigation or deep-link meaning.
- CSS may show the selected panel when the required selectors are supported.
  Without CSS or selector support, every panel remains available in source and
  visible in document order; no content may depend on script to become reachable.
- Documentation must contrast destination navigation, Radio Panels, and true
  tabs. A component named Tab Group is excluded from Milestone C.

## Consequences

The package can offer a compact native choice-and-content pattern without making
false accessibility claims. A future true Tab Group requires its own accepted
decision covering runtime delivery, focus, keys, activation, relationships,
state synchronization, fallback, and browser tests.
