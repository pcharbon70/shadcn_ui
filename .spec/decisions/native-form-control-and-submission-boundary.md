---
id: shadcn_ui.native_form_boundary
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.form_contract
  - shadcn_ui.form_components
  - shadcn_ui.package
  - shadcn_ui.stylesheet
---

# Preserve Native Control And Submission Semantics

## Context

Milestone B must support production forms without turning ShadcnUI into a client
form framework. Replacing browser controls with generic elements would create
new keyboard, mobile-picker, autofill, validation, submission, and value-
serialization obligations. Similar-looking elements such as Progress and Meter
also carry different native meanings.

## Decision

Native HTML behavior is the Milestone B behavioral floor.

- Input supports a closed set of text-like native types. Textarea, checkbox,
  radio, select, range, progress, and meter use their corresponding native
  elements rather than generic role-based imitations.
- Checkbox boolean mode follows Phoenix's hidden unchecked-value convention.
  Explicit multiple-value mode uses repeated names and emits no conflicting
  boolean sentinel. Switch is only a styled checkbox and shares its submitted
  value, checked state, label, disabled state, and ownership model.
- Radio Group uses one fieldset, one legend, and repeated native radios. Native
  Select uses escaped options and optgroups; multiple selection uses the native
  `multiple` attribute and a normalized repeated-value name.
- Slider uses `input type="range"` and retains native keyboard, focus, minimum,
  maximum, step, and form behavior. It does not invent drag state or a second
  hidden value.
- Progress represents task completion and Meter represents a scalar measurement
  within a known range. Neither component polls, estimates, announces changes,
  or owns the measured value.
- Supported native constraints and form attributes pass through after protected
  relationships are applied. Components do not parse domain values, submit
  forms, manage focus, fetch options, synchronize state, or attach package-owned
  event handlers.
- Comboboxes, listboxes, date-picker widgets, rich editors, asynchronous
  validation, uploads, and client-owned form frameworks remain out of scope.

## Consequences

Forms retain ordinary browser submission, keyboard, mobile, autofill, and
constraint-validation behavior without a ShadcnUI runtime. Consumers needing a
custom widget must provide and verify its larger behavior contract separately.

Rendering an invalid or pending presentation never proves that server validation
or authorization has occurred.
