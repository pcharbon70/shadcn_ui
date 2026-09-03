# Milestone D Popover and Dropdown Actions components

```spec-meta
id: shadcn_ui.popover_components
kind: package
status: active
summary: Native nonmodal Popover and ordinary-control Dropdown Actions rendering contracts.
decisions:
  - shadcn_ui.native_overlay_platform_runtime
  - shadcn_ui.popover_positioning_actions
  - shadcn_ui.semantic_component_api_and_accessibility
  - shadcn_ui.scoped_theme_token_contract
surface:
  - lib/shadcn_ui/components/overlays/popover.ex
  - lib/shadcn_ui/components/overlays/dropdown_actions.ex
  - test/shadcn_ui/components/overlays/popover_test.exs
  - test/shadcn_ui/components/overlays/dropdown_actions_test.exs
  - test/browser/milestone-d-popovers.spec.mjs
  - test/fixtures/milestone_d_popovers.html
  - scripts/render-popover-fixture.exs
  - test/browser/configs/playwright.milestone-d-phase4.config.mjs
  - README.md
```

## Project identity boundary

ShadcnUI is a personal MIT-licensed project. Repository ownership, package
scope, schema identifiers, and the canonical Fly hostname are publication
identity only; they do not alter this subject's requirements, semantics,
runtime boundary, package contents, or existing verification.

## Requirements

```spec-requirements
- id: shadcn_ui.popover.native_surface
  statement: Popover shall render one native button invoker and one related native popover surface with required stable ID, escaped or trusted trigger content, required accessible name or relationship, trusted body, and no package JavaScript.
  priority: must
  stability: evolving

- id: shadcn_ui.popover.modes
  statement: Popover shall expose closed auto and manual modes plus native show, hide, and toggle invoker actions, default to auto light-dismiss behavior, and preserve browser-owned Escape, focus order, implicit relationships, and native nested-popover rules.
  priority: must
  stability: evolving

- id: shadcn_ui.popover.positioning
  statement: Popover shall expose closed logical block-start, block-end, inline-start, and inline-end placement mapped to capability-gated CSS anchor positioning and ordered position fallbacks, with a bounded readable top-layer default when anchor support is absent.
  priority: must
  stability: evolving

- id: shadcn_ui.popover.state_ownership
  statement: ShadcnUI shall not observe beforetoggle or toggle events, calculate coordinates, persist open state, restore it after replacement, infer viewport placement in HEEX, or add a second open-state model.
  priority: must
  stability: stable

- id: shadcn_ui.popover.dropdown_actions
  statement: Dropdown Actions shall compose one auto Popover containing caller-owned native links and buttons in document order with stable keys, touch-sized targets, optional group labels and separators, and no mutation of their native semantics.
  priority: must
  stability: evolving

- id: shadcn_ui.popover.not_menu
  statement: Dropdown Actions shall emit no menu, menubar, or menuitem roles and shall add no roving tabindex, arrow-key handling, Home or End behavior, typeahead, submenu state, command registry, authorization, or automatic dismissal after an application outcome.
  priority: must
  stability: stable

- id: shadcn_ui.popover.protected_semantics
  statement: Popover mode, invoker target and action, IDs, native relationships, accessible name, and placement values shall override conflicting globals while each caller link or button retains its protected native destination, type, disabled state, and application attributes.
  priority: must
  stability: stable

- id: shadcn_ui.popover.shared_contract
  statement: Popover and Dropdown Actions shall follow the shared overlay, component, theme, escaping, deterministic identity, state snapshot, fallback, nesting, replacement, and application-ownership contracts.
  priority: must
  stability: stable
```

## Verification

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's component contract.

The internal-record reorganization changes documentation paths only. Popover
APIs, native behavior and executable proof are unchanged.

Popover accepts one title slot, accessible label or external labelledby naming
source. Manual mode persists until native hide/toggle; no autofocus or static
expanded state is imposed. Dropdown Actions uses self-closing keyed action slots
with text labels to reject nested interactive content. Groups are contiguous
and separators name their preceding action. Native link and button fields are
explicit; contradictory globals and unsafe destination schemes are rejected.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/components/overlays/popover_test.exs
  covers:
    - shadcn_ui.popover.native_surface
    - shadcn_ui.popover.modes
    - shadcn_ui.popover.positioning
    - shadcn_ui.popover.state_ownership
    - shadcn_ui.popover.protected_semantics
    - shadcn_ui.popover.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/overlays/dropdown_actions_test.exs
  covers:
    - shadcn_ui.popover.dropdown_actions
    - shadcn_ui.popover.not_menu
    - shadcn_ui.popover.protected_semantics
    - shadcn_ui.popover.shared_contract

- kind: test_file
  target: test/browser/milestone-d-popovers.spec.mjs
  covers:
    - shadcn_ui.popover.native_surface
    - shadcn_ui.popover.modes
    - shadcn_ui.popover.positioning
    - shadcn_ui.popover.state_ownership
    - shadcn_ui.popover.dropdown_actions
    - shadcn_ui.popover.not_menu
    - shadcn_ui.popover.shared_contract

- kind: test_file
  target: test/shadcn_ui/milestone_d_acceptance_test.exs
  covers:
    - shadcn_ui.popover.native_surface
    - shadcn_ui.popover.modes
    - shadcn_ui.popover.positioning
    - shadcn_ui.popover.state_ownership
    - shadcn_ui.popover.dropdown_actions
    - shadcn_ui.popover.not_menu
    - shadcn_ui.popover.protected_semantics
    - shadcn_ui.popover.shared_contract
```
