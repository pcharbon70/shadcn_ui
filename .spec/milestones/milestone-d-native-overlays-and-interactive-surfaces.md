# Milestone D - Native Overlays and Interactive Surfaces

## Description

Milestone D adapts modern native overlay primitives into bounded HEEX component
contracts. It uses `dialog`, the Popover API, invoker commands, and CSS anchor
positioning where the supported platform can provide complete behavior, keeps
the extracted package free of component JavaScript, and documents when an
ordinary fallback or a different semantic widget is necessary.

## Intended outcomes

- Modal and nonmodal surfaces have explicit naming, focus, dismissal, placement,
  and state-ownership contracts.
- A capability-based Chromium, Firefox, and WebKit matrix provides tested,
  reusable web-platform boundaries without selecting a consuming application.
- Web-browser fallbacks are documented per feature and never silently claim
  interaction that is absent.
- The package remains free of compatibility behavior; unsupported capabilities
  use explicit caller-owned ordinary destinations or in-flow alternatives.

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

- Establish the supported web-browser capability matrix for
  `commandfor`, `closedby`, Popover, anchor positioning, interest invokers, and
  discrete transitions.
- Preserve the accepted no-package-JavaScript decision and define explicit
  ordinary fallbacks instead of an invoker shim or widget runtime.
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
- Add cross-engine demonstrations and record the exact locked browser versions
  used as verification evidence without making one engine the package target.
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
- Cross-engine browser tests verify the locked Chromium, Firefox, and WebKit
  projects plus deliberately disabled-feature paths.

## Exit criteria

Milestone D is complete when each public overlay has a complete and truthful
interaction contract, the locked cross-engine browser matrix passes native
behavior tests, web fallbacks remain usable, and the online gallery lets users
inspect every interaction and compatibility boundary.

## Deferred work

Nested submenus, arbitrary overlay stacks, drag-and-drop surfaces, command
authorization, application workflows, unrestricted positioning engines, and
framework-specific hooks remain outside this milestone.

## Accepted architecture and delivery plan

- [Native overlay platform and runtime boundary](../decisions/native-overlay-platform-and-runtime-boundary.md)
- [Dialog modality, focus, and dismissal](../decisions/dialog-modality-focus-and-dismissal.md)
- [Popover positioning and action semantics](../decisions/popover-positioning-and-action-semantics.md)
- [Supplemental Tooltip and Hover Card boundary](../decisions/supplemental-tooltip-and-hover-card-boundary.md)
- [Milestone D current-truth specifications](../specs/README.md)
- [Milestone D phased implementation plan](../planning/milestone-d-native-overlays-and-interactive-surfaces/README.md)
