# Milestone B native form components

```spec-meta
id: shadcn_ui.form_components
kind: package
status: active
summary: Field composition, native controls, enhanced select, range, progress, and meter rendering contracts.
decisions:
  - shadcn_ui.form_field_normalization
  - shadcn_ui.deterministic_form_accessibility
  - shadcn_ui.native_form_boundary
  - shadcn_ui.enhanced_select_boundary
  - shadcn_ui.scoped_theme_token_contract
surface:
  - lib/shadcn_ui/components/forms/**/*.ex
  - test/shadcn_ui/components/forms/**/*.exs
  - test/shadcn_ui/form_components_test.exs
  - README.md
```

## Requirements

```spec-requirements
- id: shadcn_ui.forms.field_composition
  statement: Field shall compose Label, Help, and Field Errors around caller-owned control content through one deterministic relationship context without generating a form, changeset, value, submission, or validation lifecycle.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.field_fragments
  statement: Label shall render a native label with a protected target, Help shall render escaped descriptive content, and Field Errors shall preserve the order and distinct identity of every visible escaped message without a default live-region role.
  priority: must
  stability: stable

- id: shadcn_ui.forms.error_summary
  statement: Error Summary shall render an escaped heading and ordered form- or field-level messages with stable ordinary fragment links to explicit control IDs while leaving announcement, focus, scrolling, and navigation behavior to the caller.
  priority: must
  stability: stable

- id: shadcn_ui.forms.input
  statement: Input shall render a closed set of text-like native types comprising text, email, password, search, tel, url, number, date, datetime-local, month, week, and time with normalized identity and value, documented constraints and input modes, protected semantics, and caller-owned pending presentation.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.textarea
  statement: Textarea shall render escaped normalized value as native textarea content, support documented constraints and fixed resize policies, use field-sizing content only as a feature-gated enhancement, and retain a usable fixed minimum-height fallback.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.checkbox
  statement: Checkbox shall render a real checkbox with deterministic label, help, and error relationships; boolean mode shall emit a same-name hidden unchecked sentinel before the visible control, while explicit multiple-value mode shall normalize a repeated-value name and emit no sentinel.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.radio_group
  statement: Radio Group shall render one native fieldset and legend with deterministic native radio IDs from stable caller option keys, scalar selected value, shared help and errors, group and option disabled states, and no package-owned selection state.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.switch
  statement: Switch shall be a presentation of one native checkbox with the same FormField normalization, submitted values, label, checked, required, disabled, help, and error semantics as Checkbox and shall not expose a second state model or role-only imitation.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.native_select
  statement: Native Select shall render one native select with escaped caller option and optgroup data, deterministic option values, single or native multiple selection, normalized repeated-value naming, native disabled states, and no combobox or listbox role overstatement.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.enhanced_select
  statement: Enhanced Select shall render one native select with the same value and submission contract as Native Select, activate customizable-select presentation only inside required capability queries, and fall back to a visible operable classic select without mirrored controls, hidden duplicate values, script, or popup state.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.slider
  statement: Slider shall render one input type range with normalized identity and value, native min, max, step, required label and optional value description, keyboard and form behavior, and no package-owned drag or synchronized hidden state.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.progress
  statement: Progress shall render a native progress element for task completion with optional determinate value and max or an indeterminate state, a required accessible name, and no polling, estimation, announcement, or lifecycle behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.meter
  statement: Meter shall render a native meter element for a scalar measurement with required value and documented min, max, low, high, and optimum inputs, a required accessible name, and no task-progress meaning or package-owned measurement behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.forms.shared_contract
  statement: Every Milestone B component shall follow shared FormField or explicit normalization where applicable, deterministic relationships, escaping, protected globals, native semantics, presentation-only pending state, and caller-owned validation and operations.
  priority: must
  stability: stable
```

## Verification

```spec-verification
- kind: test_file
  target: test/shadcn_ui/components/forms/field_test.exs
  covers:
    - shadcn_ui.forms.field_composition
    - shadcn_ui.forms.field_fragments
    - shadcn_ui.forms.error_summary
    - shadcn_ui.forms.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/forms/text_controls_test.exs
  covers:
    - shadcn_ui.forms.input
    - shadcn_ui.forms.textarea
    - shadcn_ui.forms.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/forms/choice_controls_test.exs
  covers:
    - shadcn_ui.forms.checkbox
    - shadcn_ui.forms.radio_group
    - shadcn_ui.forms.switch
    - shadcn_ui.forms.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/forms/select_test.exs
  covers:
    - shadcn_ui.forms.native_select
    - shadcn_ui.forms.enhanced_select
    - shadcn_ui.forms.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/forms/range_and_measurement_test.exs
  covers:
    - shadcn_ui.forms.slider
    - shadcn_ui.forms.progress
    - shadcn_ui.forms.meter
    - shadcn_ui.forms.shared_contract

- kind: test_file
  target: test/shadcn_ui/form_components_test.exs
  covers:
    - shadcn_ui.forms.field_composition
    - shadcn_ui.forms.field_fragments
    - shadcn_ui.forms.error_summary
    - shadcn_ui.forms.input
    - shadcn_ui.forms.textarea
    - shadcn_ui.forms.checkbox
    - shadcn_ui.forms.radio_group
    - shadcn_ui.forms.switch
    - shadcn_ui.forms.native_select
    - shadcn_ui.forms.enhanced_select
    - shadcn_ui.forms.slider
    - shadcn_ui.forms.progress
    - shadcn_ui.forms.meter
    - shadcn_ui.forms.shared_contract

- kind: test_file
  target: test/shadcn_ui/milestone_b_acceptance_test.exs
  covers:
    - shadcn_ui.forms.field_composition
    - shadcn_ui.forms.field_fragments
    - shadcn_ui.forms.error_summary
    - shadcn_ui.forms.input
    - shadcn_ui.forms.textarea
    - shadcn_ui.forms.checkbox
    - shadcn_ui.forms.radio_group
    - shadcn_ui.forms.switch
    - shadcn_ui.forms.native_select
    - shadcn_ui.forms.enhanced_select
    - shadcn_ui.forms.slider
    - shadcn_ui.forms.progress
    - shadcn_ui.forms.meter
    - shadcn_ui.forms.shared_contract
```
