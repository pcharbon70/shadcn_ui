# Shared component contract

```spec-meta
id: shadcn_ui.component_contract
kind: policy
status: active
summary: Shared public HEEX API, semantic rendering, accessibility, and ownership rules.
decisions:
  - shadcn_ui.transport_neutral_phoenix_package
  - shadcn_ui.semantic_component_api_and_accessibility
  - shadcn_ui.progressive_enhancement_baseline
  - shadcn_ui.native_disclosure_grouping
  - shadcn_ui.destination_navigation_landmarks
  - shadcn_ui.radio_panels_not_tabs
  - shadcn_ui.native_overlay_platform_runtime
  - shadcn_ui.dialog_modality_focus_dismissal
  - shadcn_ui.popover_positioning_actions
  - shadcn_ui.supplemental_surface_boundary
surface:
  - lib/shadcn_ui.ex
  - lib/shadcn_ui/components/**/*.ex
  - test/shadcn_ui/component_contract_test.exs
  - test/shadcn_ui/components/**/*.exs
  - README.md
```

## Requirements

```spec-requirements
- id: shadcn_ui.component.stateless_heex
  statement: Public components shall be stateless Phoenix function components rendered with HEEx and shall not own requests, navigation, application commands, state transitions, or client behavior.
  priority: must
  stability: stable

- id: shadcn_ui.component.closed_values
  statement: Variants, sizes, element choices, and semantic states shall use closed documented values mapped to complete static classes and deterministic markup without request-derived atoms or arbitrary utility interpolation.
  priority: must
  stability: stable

- id: shadcn_ui.component.classes_and_globals
  statement: Components shall preserve required prefixed classes while accepting caller classes and documented native, aria-*, data-*, phx-*, and data-on-* global attributes that do not contradict protected semantics.
  priority: must
  stability: stable

- id: shadcn_ui.component.slots
  statement: Components shall use inner_block for primary trusted HEEX and named slots only for semantically distinct regions, with required content declared through Phoenix.Component metadata.
  priority: must
  stability: stable

- id: shadcn_ui.component.safe_content
  statement: Caller text shall remain escaped and ShadcnUI shall expose no raw-HTML string attribute or convenience API that converts caller strings into trusted markup.
  priority: must
  stability: stable

- id: shadcn_ui.component.native_semantics
  statement: Components shall prefer native elements and shall not add an ARIA role, state, or keyboard claim that exceeds the behavior implemented by their HTML and documented optional runtime boundary.
  priority: must
  stability: stable

- id: shadcn_ui.component.protected_accessibility
  statement: Mandatory element type, disabled state, roles, accessible names, hidden treatment, and relationships derived from explicit component attributes shall take precedence over conflicting caller globals.
  priority: must
  stability: stable

- id: shadcn_ui.component.deterministic_identity
  statement: Components shall require or deterministically derive IDs only for real HTML relationships and shall not use random or process-global render-time identity.
  priority: must
  stability: stable

- id: shadcn_ui.component.presentation_snapshot
  statement: Loading, disabled, image fallback, dismissal, and other state attributes shall describe the rendered snapshot only; lifecycle and outcomes remain caller-owned.
  priority: must
  stability: stable

- id: shadcn_ui.component.progressive_floor
  statement: Required content, native operations, focus visibility, and semantic meaning shall remain available when optional CSS enhancements or JavaScript are absent.
  priority: must
  stability: stable

- id: shadcn_ui.component.honest_interaction_names
  statement: Public names, native elements, ARIA roles, keyboard claims, and documented behavior shall describe the same interaction pattern, and visually similar navigation, radio-panel, menu, and tab patterns shall not be presented as semantically interchangeable.
  priority: must
  stability: stable
```

## Verification

```spec-verification
- kind: command
  target: mix precommit
  execute: true
  covers:
    - shadcn_ui.component.stateless_heex
    - shadcn_ui.component.closed_values
    - shadcn_ui.component.classes_and_globals
    - shadcn_ui.component.slots
    - shadcn_ui.component.safe_content
    - shadcn_ui.component.native_semantics
    - shadcn_ui.component.protected_accessibility
    - shadcn_ui.component.deterministic_identity
    - shadcn_ui.component.presentation_snapshot
    - shadcn_ui.component.progressive_floor
    - shadcn_ui.component.honest_interaction_names

- kind: test_file
  target: test/shadcn_ui/component_contract_test.exs
  covers:
    - shadcn_ui.component.stateless_heex
    - shadcn_ui.component.closed_values
    - shadcn_ui.component.classes_and_globals
    - shadcn_ui.component.slots
    - shadcn_ui.component.safe_content
    - shadcn_ui.component.native_semantics
    - shadcn_ui.component.protected_accessibility
    - shadcn_ui.component.deterministic_identity
    - shadcn_ui.component.presentation_snapshot
    - shadcn_ui.component.progressive_floor
    - shadcn_ui.component.honest_interaction_names

- kind: test_file
  target: test/shadcn_ui/milestone_a_acceptance_test.exs
  covers:
    - shadcn_ui.component.stateless_heex
    - shadcn_ui.component.closed_values
    - shadcn_ui.component.classes_and_globals
    - shadcn_ui.component.slots
    - shadcn_ui.component.safe_content
    - shadcn_ui.component.native_semantics
    - shadcn_ui.component.protected_accessibility
    - shadcn_ui.component.deterministic_identity
    - shadcn_ui.component.presentation_snapshot
    - shadcn_ui.component.progressive_floor

- kind: test_file
  target: test/shadcn_ui/milestone_c_acceptance_test.exs
  covers:
    - shadcn_ui.component.stateless_heex
    - shadcn_ui.component.closed_values
    - shadcn_ui.component.classes_and_globals
    - shadcn_ui.component.slots
    - shadcn_ui.component.safe_content
    - shadcn_ui.component.native_semantics
    - shadcn_ui.component.protected_accessibility
    - shadcn_ui.component.deterministic_identity
    - shadcn_ui.component.presentation_snapshot
    - shadcn_ui.component.progressive_floor
    - shadcn_ui.component.honest_interaction_names
```
