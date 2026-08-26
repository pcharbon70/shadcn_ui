# Milestone D Dialog, Alert Dialog, and Drawer components

```spec-meta
id: shadcn_ui.dialog_components
kind: package
status: active
summary: Native modal Dialog, consequential Alert Dialog, and edge-presented Drawer rendering contracts.
decisions:
  - shadcn_ui.native_overlay_platform_runtime
  - shadcn_ui.dialog_modality_focus_dismissal
  - shadcn_ui.semantic_component_api_and_accessibility
  - shadcn_ui.scoped_theme_token_contract
surface:
  - lib/shadcn_ui/components/overlays/dialog.ex
  - lib/shadcn_ui/components/overlays/alert_dialog.ex
  - lib/shadcn_ui/components/overlays/drawer.ex
  - test/shadcn_ui/components/overlays/dialog_test.exs
  - test/shadcn_ui/components/overlays/alert_dialog_test.exs
  - test/shadcn_ui/components/overlays/drawer_test.exs
  - test/browser/milestone-d-dialogs.spec.mjs
  - test/fixtures/milestone_d_dialogs.html
  - README.md
```

## Requirements

```spec-requirements
- id: shadcn_ui.dialog.native_modal
  statement: Dialog shall render one native dialog initially closed, one native show-modal invoker, required title or explicit accessible label, optional deterministic description, trusted body, and a visible explicit close control without role-based imitation or package JavaScript.
  priority: must
  stability: evolving

- id: shadcn_ui.dialog.dismissal_policy
  statement: Dialog shall expose closed none, closerequest, and any native closedby values with closerequest as default, preserve browser Escape and light-dismiss behavior for the selected policy, and never make those implicit operations the only exit.
  priority: must
  stability: evolving

- id: shadcn_ui.dialog.initial_focus
  statement: Dialog shall accept one explicit initial-focus target among stable caller regions or default to the first appropriate native focus candidate, protect autofocus placement, and leave containment and restoration to native modal behavior.
  priority: must
  stability: stable

- id: shadcn_ui.dialog.alert_dialog
  statement: Alert Dialog shall render a native modal dialog with alertdialog semantics, required title, consequential description, explicit cancel and action regions, closerequest dismissal, and initial focus on the least destructive cancel control without inferring consequence from visual color.
  priority: must
  stability: evolving

- id: shadcn_ui.dialog.alert_ownership
  statement: Alert Dialog shall not authorize, execute, submit, retry, persist, or report an outcome and shall preserve caller-owned native form and button behavior, server validation, CSRF, pending snapshots, and action results.
  priority: must
  stability: stable

- id: shadcn_ui.dialog.drawer
  statement: Drawer shall render native modal dialog semantics with closed logical start, end, and bottom edge presentation, a bounded viewport size, required title or label, explicit close control, and caller content in document order.
  priority: must
  stability: evolving

- id: shadcn_ui.dialog.drawer_scroll
  statement: Drawer shall keep its heading and close control reachable while long content uses one native internal scroll region with visible focus, touch and keyboard access, safe-area spacing, narrow-layout resilience, and no package scroll observation or restoration.
  priority: must
  stability: evolving

- id: shadcn_ui.dialog.protected_semantics
  statement: Dialog-family native elements, modal invocation, IDs, names, descriptions, alertdialog role, closedby policy, open state, initial-focus target, and close relationships shall override conflicting globals while unrelated documented globals pass through.
  priority: must
  stability: stable

- id: shadcn_ui.dialog.shared_contract
  statement: Dialog, Alert Dialog, and Drawer shall follow the shared overlay, component, theme, escaping, deterministic identity, state snapshot, replacement, fallback, and application-ownership contracts.
  priority: must
  stability: stable
```

## Verification

```spec-verification
- kind: test_file
  target: test/shadcn_ui/components/overlays/dialog_test.exs
  covers:
    - shadcn_ui.dialog.native_modal
    - shadcn_ui.dialog.dismissal_policy
    - shadcn_ui.dialog.initial_focus
    - shadcn_ui.dialog.protected_semantics
    - shadcn_ui.dialog.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/overlays/alert_dialog_test.exs
  covers:
    - shadcn_ui.dialog.alert_dialog
    - shadcn_ui.dialog.alert_ownership
    - shadcn_ui.dialog.protected_semantics
    - shadcn_ui.dialog.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/overlays/drawer_test.exs
  covers:
    - shadcn_ui.dialog.drawer
    - shadcn_ui.dialog.drawer_scroll
    - shadcn_ui.dialog.protected_semantics
    - shadcn_ui.dialog.shared_contract

- kind: test_file
  target: test/browser/milestone-d-dialogs.spec.mjs
  covers:
    - shadcn_ui.dialog.native_modal
    - shadcn_ui.dialog.dismissal_policy
    - shadcn_ui.dialog.initial_focus
    - shadcn_ui.dialog.alert_dialog
    - shadcn_ui.dialog.shared_contract

- kind: test_file
  target: test/shadcn_ui/milestone_d_acceptance_test.exs
  covers:
    - shadcn_ui.dialog.native_modal
    - shadcn_ui.dialog.dismissal_policy
    - shadcn_ui.dialog.initial_focus
    - shadcn_ui.dialog.alert_dialog
    - shadcn_ui.dialog.alert_ownership
    - shadcn_ui.dialog.protected_semantics
    - shadcn_ui.dialog.shared_contract
```
