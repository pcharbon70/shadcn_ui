---
id: shadcn_ui.dialog_modality_focus_dismissal
status: accepted
date: 2026-08-25
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.dialog_components
  - shadcn_ui.overlay_contract
  - shadcn_ui.overlay_gallery
---

# Keep Dialog Modality, Focus, And Dismissal Native And Explicit

## Context

Dialog, Alert Dialog, and Drawer look related but have different consequences,
dismissal expectations, and initial-focus policies. Rendering `role="dialog"`
on an ordinary element would not provide modality, page inertness, focus
containment, Escape handling, top-layer placement, or focus restoration.
Likewise, adding `open` to a dialog creates a nonmodal snapshot and is not a
substitute for invoking `showModal()` through a native command.

Server rendering and DOM replacement introduce a second state model only if the
package tries to synchronize the browser's open overlay state. ShadcnUI must
remain transport-neutral and truthful about what survives replacement.

## Decision

Dialog-family components use native modal dialog behavior with explicit
relationships and caller-owned application state.

- Every surface requires a stable nonblank ID and either a package-related title
  or an explicit nonblank accessible label. Optional descriptions receive
  deterministic relationships. Conflicting IDs, roles, names, `open`,
  `closedby`, command targets, and modal semantics are protected.
- A native invoker button uses `command="show-modal"` and `commandfor` to open
  the dialog. Every dialog contains a visible explicit close or cancel control;
  applications do not rely on Escape or backdrop activation as the only exit.
- Ordinary Dialog defaults to `closedby="closerequest"`; callers may select the
  closed `none`, `closerequest`, or `any` policy when its documented interaction
  matches the workflow. Drawer follows the same policy and defaults.
- Alert Dialog uses `closedby="closerequest"`, requires distinct cancel and
  consequential-action regions, and places initial focus on the least
  destructive cancel control. It never enables light dismiss by default.
- Dialog and Drawer accept an explicit caller-selected initial-focus target.
  Native dialog focus containment, page inertness, Escape handling, close
  requests, backdrop behavior, and restoration to the invoker remain browser-
  owned. ShadcnUI adds no focus trap or restoration code.
- Open state between native invocation and close is browser-local presentation.
  Server and application state remains caller-owned. Replacing an open dialog
  may close it and lose browser-local focus; applications must choose whether to
  avoid replacement, render a new closed snapshot, or re-invoke it through
  their selected transport behavior outside ShadcnUI.
- Nested modal dialogs and arbitrary overlay stacks are unsupported. One native
  popover may be used inside a dialog when its trigger, dismissal, focus order,
  and fallback remain complete. Applications own all other orchestration.
- Dialog actions never imply authorization, confirmation outcome, persistence,
  navigation, or command success. Native forms and caller event attributes keep
  their existing behavior and security boundary.

## Consequences

The public API can describe rendered structure and native dismissal policy
without implementing a second modal system. Applications must account for DOM
replacement explicitly, and Alert Dialog remains semantically distinct from a
general dialog whose visual styling happens to be destructive.
