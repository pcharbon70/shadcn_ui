# Milestone D - Native Overlays and Interactive Surfaces

## Description

Milestone D adapts modern native overlay primitives into bounded HEEX component
contracts. It uses `dialog`, the Popover API, invoker commands, and CSS anchor
positioning where the supported platform can provide complete behavior, while
documenting when a small compatibility behavior or a different semantic widget
is genuinely necessary.

## Intended outcomes

- Modal and nonmodal surfaces have explicit naming, focus, dismissal, placement,
  and state-ownership contracts.
- The supported Electron Chromium release provides a tested, predictable native
  platform for Lecowin3 consumers.
- Web-browser fallbacks are documented per feature and never silently claim
  interaction that is absent.
- Optional compatibility behavior, if accepted, remains small, framework-
  neutral, separately distributed, and independent of application commands.

## Component scope

- Dialog using native modal semantics.
- Alert Dialog as a distinct consequential-confirmation contract.
- Drawer as a dialog presentation with bounded edge placement and scrolling.
- Popover for nonmodal supplemental controls or content.
- Dropdown Actions as a simple popover containing ordinary buttons or links.
- Tooltip with a broadly compatible CSS-first form and an optional enhanced
  form only where its browser contract is acceptable.
- Hover Card as progressive supplemental content rather than required access to
  information.

## Architecture work required

- Establish the supported Electron and web-browser feature matrix for
  `commandfor`, `closedby`, Popover, anchor positioning, interest invokers, and
  discrete transitions.
- Decide whether ShadcnUI ships no JavaScript, an optional invoker shim, or a
  more complete optional widget runtime; record the decision before coding.
- Specify local versus caller-controlled open state and behavior under Phoenix,
  Dstar, or LiveView DOM replacement without depending on any one transport.
- Specify focus entry, containment, restoration, cancellation, light dismiss,
  nested overlay, scroll-lock, and reduced-motion policies.
- Keep a simple Dropdown Actions component distinct from a full ARIA menu with
  roving focus, arrow keys, typeahead, and submenu expectations.

## Gallery scope

- Add Overlays and Interactive Surfaces categories with isolated examples.
- Demonstrate mouse, keyboard, touch-sized, long-content, viewport-edge, and
  nested-scroll scenarios.
- Compare ordinary Dialog and Alert Dialog dismissal and initial-focus policy.
- Display supported-feature and fallback behavior beside each example.
- Add Electron-targeted demonstrations and record the tested Chromium version.
- Keep demo-owned simulations and source-copy conveniences outside the package
  runtime boundary.

## Verification expectations

- Rendering tests assert IDs, accessible names, descriptions, roles, protected
  relationships, global attributes, and local/controlled snapshots.
- Browser tests cover focus entry, Tab containment where applicable, Escape,
  backdrop behavior, focus restoration, viewport flipping, scrolling, nested
  surfaces, and reduced motion.
- Compatibility tests exercise both enhanced and deliberately disabled-feature
  paths rather than testing only the newest Chromium behavior.
- Electron smoke tests verify the packaged renderer with its real security
  settings and supported native feature set.

## Exit criteria

Milestone D is complete when each public overlay has a complete and truthful
interaction contract, the supported Electron build passes native behavior tests,
web fallbacks remain usable, and the online gallery lets users inspect every
interaction and compatibility boundary.

## Deferred work

Nested submenus, arbitrary overlay stacks, drag-and-drop surfaces, command
authorization, application workflows, unrestricted positioning engines, and
framework-specific hooks remain outside this milestone.
