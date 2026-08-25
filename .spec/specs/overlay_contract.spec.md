# Shared native overlay contract

```spec-meta
id: shadcn_ui.overlay_contract
kind: policy
status: active
summary: Native capability, identity, invocation, state, focus, dismissal, replacement, fallback, and ownership rules for overlays.
decisions:
  - shadcn_ui.native_overlay_platform_runtime
  - shadcn_ui.dialog_modality_focus_dismissal
  - shadcn_ui.popover_positioning_actions
  - shadcn_ui.supplemental_surface_boundary
  - shadcn_ui.transport_neutral_phoenix_package
  - shadcn_ui.progressive_enhancement_baseline
surface:
  - priv/compatibility/native_overlays.json
  - priv/compatibility/native_overlays.schema.json
  - lib/shadcn_ui/components/overlays/overlay_contract.ex
  - lib/shadcn_ui/components/overlays/**/*.ex
  - test/shadcn_ui/components/overlays/overlay_capability_manifest_test.exs
  - test/shadcn_ui/components/overlays/**/*.exs
  - test/fixtures/milestone_d_overlay_contract.html
  - test/fixtures/milestone_d_*.html
  - test/browser/milestone-d-*.spec.mjs
  - README.md
```

## Requirements

```spec-requirements
- id: shadcn_ui.overlay.browser_matrix
  statement: Milestone D acceptance shall record the exact locked Chromium, Firefox, and WebKit versions and test the native dialog commands, closedby, Popover, anchor-positioning, position-fallback, and discrete-transition capability set used by each component without making one browser or consuming application the package target.
  priority: must
  stability: evolving

- id: shadcn_ui.overlay.no_package_runtime
  statement: ShadcnUI shall ship no overlay JavaScript, invoker polyfill, focus manager, overlay stack, positioning engine, custom element, framework hook, or client state process, and demo capability reporting shall remain outside package release contents.
  priority: must
  stability: stable

- id: shadcn_ui.overlay.deterministic_identity
  statement: Every invoker, surface, title, description, close control, and related element shall use nonblank explicit identity or deterministic derivation from explicit stable caller keys without random values, request-derived atoms, or process-global state.
  priority: must
  stability: stable

- id: shadcn_ui.overlay.native_invocation
  statement: Dialog-family components shall use native command and commandfor relationships and Popover-family components shall use native popover target and action relationships, while protected target, action, mode, element, and accessibility semantics override conflicting caller globals.
  priority: must
  stability: evolving

- id: shadcn_ui.overlay.state_ownership
  statement: Open, closed, modal, popover, dismissal, pending, and action-result values shall describe the rendered or browser-local snapshot only; ShadcnUI shall not observe toggles, synchronize state, infer user intent, persist state, or reconcile it with a server.
  priority: must
  stability: stable

- id: shadcn_ui.overlay.focus_ownership
  statement: Initial-focus intent shall be explicit, while native focus entry, modal containment, Tab order, page inertness, Escape handling, and restoration remain browser-owned and ShadcnUI shall add no focus-trap or focus-restoration script.
  priority: must
  stability: stable

- id: shadcn_ui.overlay.dismissal
  statement: Dismissal policy shall use closed native values and every modal surface shall include a visible explicit close or cancel control so Escape, backdrop activation, light dismiss, or application event handling is never the sole exit.
  priority: must
  stability: stable

- id: shadcn_ui.overlay.dom_replacement
  statement: Documentation and tests shall state that Phoenix, Dstar, or LiveView replacement may close a native overlay and lose browser-local focus, and applications shall own patch boundaries, reinvocation, server state, and any restoration behavior outside ShadcnUI.
  priority: must
  stability: stable

- id: shadcn_ui.overlay.nesting_boundary
  statement: Milestone D shall support at most one native Popover inside a Dialog-family surface with complete focus and dismissal evidence and shall reject nested modal dialogs, arbitrary overlay stacks, submenus, and unrestricted virtual anchors.
  priority: must
  stability: stable

- id: shadcn_ui.overlay.web_fallback
  statement: Every component shall document its native capability floor and an ordinary caller-owned destination, visible content, or non-overlay operation for unsupported browsers; absent anchor positioning or transition support shall preserve the native operation in a bounded readable position without animation.
  priority: must
  stability: stable

- id: shadcn_ui.overlay.application_boundary
  statement: Applications shall own authorization, commands, methods, CSRF, navigation, validation, persistence, loading, analytics, outcomes, replacement, and native capabilities, while ShadcnUI renders no behavior-specific transport integration.
  priority: must
  stability: stable
```

## Verification

```spec-verification
- kind: test_file
  target: test/shadcn_ui/components/overlays/overlay_contract_test.exs
  covers:
    - shadcn_ui.overlay.deterministic_identity
    - shadcn_ui.overlay.native_invocation
    - shadcn_ui.overlay.state_ownership
    - shadcn_ui.overlay.focus_ownership
    - shadcn_ui.overlay.dismissal
    - shadcn_ui.overlay.dom_replacement
    - shadcn_ui.overlay.nesting_boundary
    - shadcn_ui.overlay.web_fallback

- kind: test_file
  target: test/shadcn_ui/components/overlays/overlay_capability_manifest_test.exs
  covers:
    - shadcn_ui.overlay.browser_matrix
    - shadcn_ui.overlay.no_package_runtime
    - shadcn_ui.overlay.web_fallback
    - shadcn_ui.overlay.application_boundary

- kind: test_file
  target: test/browser/milestone-d-overlay-contract.spec.mjs
  covers:
    - shadcn_ui.overlay.native_invocation
    - shadcn_ui.overlay.state_ownership
    - shadcn_ui.overlay.focus_ownership
    - shadcn_ui.overlay.dismissal
    - shadcn_ui.overlay.dom_replacement
    - shadcn_ui.overlay.nesting_boundary
    - shadcn_ui.overlay.web_fallback

- kind: test_file
  target: test/browser/milestone-d-capabilities.spec.mjs
  covers:
    - shadcn_ui.overlay.browser_matrix
    - shadcn_ui.overlay.native_invocation
    - shadcn_ui.overlay.focus_ownership
    - shadcn_ui.overlay.dismissal

- kind: test_file
  target: test/shadcn_ui/milestone_d_acceptance_test.exs
  covers:
    - shadcn_ui.overlay.browser_matrix
    - shadcn_ui.overlay.no_package_runtime
    - shadcn_ui.overlay.deterministic_identity
    - shadcn_ui.overlay.native_invocation
    - shadcn_ui.overlay.state_ownership
    - shadcn_ui.overlay.focus_ownership
    - shadcn_ui.overlay.dismissal
    - shadcn_ui.overlay.dom_replacement
    - shadcn_ui.overlay.nesting_boundary
    - shadcn_ui.overlay.web_fallback
    - shadcn_ui.overlay.application_boundary
```
