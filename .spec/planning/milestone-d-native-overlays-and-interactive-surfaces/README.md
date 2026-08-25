# Milestone D - Native Overlays And Interactive Surfaces

This wave delivers truthful native overlay components for reusable server-
rendered HEEX. Dialog modality, Popover top-layer behavior, focus, dismissal,
and placement remain browser-owned; ShadcnUI provides deterministic markup,
capability-gated CSS, explicit fallbacks, and no package JavaScript runtime.

## Request alignment

- Support is capability-based and reusable across web consumers. ShadcnUI does
  not select a consuming product, operating system, embedded runtime, or one
  browser engine as its target.
- Locked Chromium, Firefox, and WebKit projects provide versioned verification
  evidence without becoming the normative package contract.
- Dialog, Alert Dialog, and Drawer use native modal dialog behavior with
  explicit focus and dismissal policies.
- Popover and Dropdown Actions use native nonmodal Popover behavior; Dropdown
  Actions remains ordinary links and buttons rather than an ARIA menu.
- Tooltip and Hover Card are supplemental CSS-first surfaces. They do not claim
  interest-invoker, touch-interest, or interactive-preview behavior.
- The package ships no overlay JavaScript, invoker shim, focus manager, overlay
  stack, or positioning engine.

## Architecture resolutions

1. [Native overlay platform and runtime boundary](../../decisions/native-overlay-platform-and-runtime-boundary.md)
2. [Dialog modality, focus, and dismissal](../../decisions/dialog-modality-focus-and-dismissal.md)
3. [Popover positioning and action semantics](../../decisions/popover-positioning-and-action-semantics.md)
4. [Supplemental Tooltip and Hover Card boundary](../../decisions/supplemental-tooltip-and-hover-card-boundary.md)

## Current-truth subjects

1. [Shared native overlay contract](../../specs/overlay_contract.spec.md)
2. [Dialog, Alert Dialog, and Drawer components](../../specs/dialog_components.spec.md)
3. [Popover and Dropdown Actions components](../../specs/popover_components.spec.md)
4. [Tooltip and Hover Card supplemental surfaces](../../specs/supplemental_surfaces.spec.md)
5. [Overlay gallery and acceptance](../../specs/overlay_gallery.spec.md)

## Phase order

1. [Phase 1 - Browser Capability And Shared Overlay Foundations](./phase-01-browser-capability-and-shared-overlay-foundations.md)
2. [Phase 2 - Dialog And Alert Dialog Foundations](./phase-02-dialog-and-alert-dialog-foundations.md)
3. [Phase 3 - Drawer Foundations](./phase-03-drawer-foundations.md)
4. [Phase 4 - Popover And Dropdown Actions Foundations](./phase-04-popover-and-dropdown-actions-foundations.md)
5. [Phase 5 - Tooltip And Hover Card Foundations](./phase-05-tooltip-and-hover-card-foundations.md)
6. [Phase 6 - Overlay Gallery, Documentation, And Milestone Acceptance](./phase-06-overlay-gallery-documentation-and-milestone-acceptance.md)

## Shared conventions

- Checklist numbering uses `N`, `N.M`, `N.M.K`, and `N.M.K.L` for phases,
  sections, tasks, and subtasks.
- Every phase, section, and task begins with a description of intent and expected
  outcome.
- Every phase ends with a section named `Phase N Integration Tests`.
- Boxes remain unchecked until implementation and verification land together.
- Each section is committed independently; all sections in one phase are
  delivered through one pull request.
- Components remain stateless Phoenix function components rendered with HEEx.
- Native elements and documented native capabilities are the behavioral floor.
- Closed values map to complete static classes; stable caller keys derive only
  deterministic identities and never request-derived atoms.
- Browser-local open state is not server state. Applications own replacement,
  reinvocation, persistence, authorization, commands, and outcomes.
- Capability-dependent CSS retains a documented bounded or in-flow fallback.
- Gallery capability reporting and source conveniences remain demo-only.

## Non-goals

- Package JavaScript, invoker polyfills, custom focus traps, overlay managers,
  unrestricted collision engines, arbitrary overlay stacks, or virtual anchors.
- Full ARIA menus, menubars, submenus, command palettes, typeahead, roving
  tabindex, trees, interactive grids, or true tabs.
- Interest invokers, interactive Hover Cards, touch long-press emulation, or
  browser-name sniffing.
- Application authorization, command execution, persistence, routing, CSRF,
  validation, pending lifecycle, analytics, or transport-specific hooks.
- Consumer-specific runtime, product, or native-capability requirements inside
  the extracted library.

## Exit criteria

- Every public Milestone D component has semantics matching its implemented
  native or CSS interaction contract.
- Dialog-family focus and dismissal, Popover invocation and placement, ordinary
  action controls, and supplemental fallbacks pass locked Chromium, Firefox,
  and WebKit evidence or are explicitly capability-gated.
- Unsupported-feature, CSS-disabled, no-script, coarse-pointer, reduced-motion,
  forced-colors, zoom, RTL, long-content, and DOM-replacement boundaries are
  visible and documented.
- The gallery exposes every component, capability, composition, source example,
  fallback, and ownership boundary through deterministic static publication.
- Package and demo precommit, assets, browser matrix, static export, ExDoc,
  provenance, archive, SpecLed, and whitespace checks pass.
