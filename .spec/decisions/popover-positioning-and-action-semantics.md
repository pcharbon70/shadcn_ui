---
id: shadcn_ui.popover_positioning_actions
status: accepted
date: 2026-08-25
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.popover_components
  - shadcn_ui.overlay_contract
  - shadcn_ui.stylesheet
  - shadcn_ui.overlay_gallery
---

# Use Native Popovers And Keep Dropdown Actions Out Of The ARIA Menu Contract

## Context

The Popover API supplies nonmodal top-layer display, declarative invokers,
light dismiss, focus-order integration, and implicit accessibility
relationships. CSS anchor positioning can place that surface near its invoker
and try alternate positions at viewport edges. Reimplementing those mechanisms
would require a client runtime and a positioning engine.

A list of actions inside a popover may look like an application menu while
still containing ordinary links and buttons. Claiming `menu` semantics would
also require roving focus, arrow keys, Home and End, typeahead, disabled-item
behavior, and submenu rules that Milestone D does not implement.

## Decision

Popover and Dropdown Actions use native nonmodal semantics and closed bounded
placement.

- Popover renders one stable native invoker and one related `popover` surface.
  Closed `auto` and `manual` modes map directly to native behavior; `auto` is the
  default for light dismiss and one-at-a-time behavior.
- Stable caller identity deterministically connects invoker, popover, accessible
  name or description, and optional close control. The package protects native
  target, action, popover mode, IDs, and required relationships.
- Placement uses logical closed values such as block-start, block-end, inline-
  start, and inline-end. Anchor positioning and `position-try-fallbacks` are
  capability-gated presentation. Without them the top-layer popover remains
  operable in a bounded viewport-safe default position.
- Native Tab order, Escape behavior, light dismiss, nested-popover rules, focus
  return, and implicit invoker relationships remain browser-owned. ShadcnUI
  does not observe toggle events, calculate coordinates, or synchronize open
  state.
- Dropdown Actions is an `auto` Popover composition containing caller-owned
  ordinary links and native buttons in document order. It emits no `menu`,
  `menubar`, or `menuitem` role and adds no roving tabindex, arrow-key handling,
  typeahead, submenu, command registry, or authorization behavior.
- Each action retains its own native semantics. Callers own destinations,
  methods, CSRF, authorization, pending state, command execution, dismissal
  after an outcome, and replacement behavior.
- Nested submenus, arbitrary overlay stacks, unrestricted collision engines,
  and programmatic virtual anchors are deferred.

## Consequences

Popover composition stays useful for supplemental controls while the browser
owns the difficult top-layer and focus-order mechanics. Dropdown Actions is
honest about being a group of ordinary controls, so applications needing a full
ARIA menu must select a future separately specified component.
