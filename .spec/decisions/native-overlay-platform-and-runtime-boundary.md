---
id: shadcn_ui.native_overlay_platform_runtime
status: accepted
date: 2026-08-25
affects:
  - shadcn_ui.package
  - shadcn_ui.component_contract
  - shadcn_ui.stylesheet
  - shadcn_ui.overlay_contract
  - shadcn_ui.overlay_gallery
---

# Use The Native Overlay Platform Without A Package JavaScript Runtime

## Context

Milestone D needs modal dialogs, nonmodal popovers, placement, dismissal, and
focus behavior that static HEEX and CSS cannot reproduce safely with ARIA alone.
Native dialog invoker commands, `closedby`, Popover, CSS anchor positioning,
position fallbacks, and discrete transitions have different implementation
timelines across browser engines. Interest invokers remain an emerging feature
rather than an interoperable package baseline.

A general overlay runtime or positioning engine would expand ShadcnUI from a
transport-neutral rendering package into a client framework. A compatibility
shim would also need its own focus, dismissal, replacement, and security
contract and would duplicate behavior that the supported renderer already owns.

## Decision

Milestone D uses the browser's native overlay platform and ships no package
JavaScript.

- Support is defined by a component capability set rather than an application,
  operating system, browser brand, or embedded-browser version. CI records the
  exact locked Chromium, Firefox, and WebKit versions used as evidence without
  turning one of them into the package's normative target.
- Modal surfaces use native `dialog`, `commandfor`, and `command` behavior.
  Nonmodal transient surfaces use `popover`, `popovertarget`, and
  `popovertargetaction`. CSS anchor positioning and discrete transitions are
  presentation enhancements guarded by capability queries.
- ShadcnUI does not ship an invoker polyfill, focus manager, overlay stack,
  positioning engine, behavior hook, custom element, or package event loop.
- A web browser is fully supported for a component only when it implements that
  component's declared native capability set. Unsupported browsers must retain
  an explicit caller-owned ordinary destination or in-flow explanation; the
  gallery demonstrates that path and never labels an inert invoker as working.
- Interest invokers and `interestfor` are excluded from Milestone D because they
  are not an interoperable cross-engine baseline. Tooltip and Hover Card use
  their separately defined CSS-first supplemental-content contract instead.
- Browser capability claims are rechecked from authoritative platform sources
  when the locked verification matrix changes. Feature detection may gate
  CSS presentation, but request data and browser-name sniffing never select
  component semantics.
- Demo scripts may inspect or display capability evidence, but they do not
  implement package component behavior and remain outside release contents.

## Consequences

Consumers whose browsers meet a component capability floor receive complete
native focus, top-layer, and dismissal behavior without weakening the package
boundary. Other consumers must provide an ordinary fallback destination.
Supporting a missing capability through package JavaScript requires a new
accepted decision and a separately versioned runtime contract.

## Reviewed platform sources

- HTML dialog and invoker commands: <https://html.spec.whatwg.org/multipage/interactive-elements.html#the-dialog-element>
- Popover API: <https://developer.mozilla.org/en-US/docs/Web/API/Popover_API/Using>
- CSS position fallbacks: <https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/position-try-fallbacks>
