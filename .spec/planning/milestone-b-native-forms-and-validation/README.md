# Milestone B - Native Forms And Validation

This wave delivers a production-quality native form catalogue for ordinary
Phoenix and HEEX consumers. It implements shared `Phoenix.HTML.FormField`
normalization, deterministic accessibility relationships, native submission,
capability-gated CSS enhancements, complete gallery guidance, and milestone
acceptance without adding application-owned validation or client state.

## Request alignment

- Field, Label, Help, Field Errors, and Error Summary provide reusable semantic
  composition rather than a form builder.
- Input, Textarea, Checkbox, Radio Group, Switch, Native Select, Enhanced Select,
  Slider, Progress, and Meter use their native HTML behavioral floor.
- Applicable controls support explicit and `Phoenix.HTML.FormField` modes through
  one identity, value, error, and relationship contract.
- Consumers own changesets, translation, validation timing, submission,
  persistence, authorization, pending transitions, focus, and announcements.
- Customizable select and `field-sizing: content` are CSS enhancements with exact
  native fallbacks, not new minimum browser requirements.
- The gallery receives a Forms category, a page per component, realistic caller-
  owned compositions, and a harmless submission evidence endpoint.

## Phase order

1. [Phase 1 - Shared Form Contracts And Field Composition](./phase-01-shared-form-contracts-and-field-composition.md)
2. [Phase 2 - Input And Textarea Foundations](./phase-02-input-and-textarea-foundations.md)
3. [Phase 3 - Checkbox, Radio Group, And Switch Foundations](./phase-03-checkbox-radio-group-and-switch-foundations.md)
4. [Phase 4 - Native And Enhanced Select Foundations](./phase-04-native-and-enhanced-select-foundations.md)
5. [Phase 5 - Slider, Progress, And Meter Foundations](./phase-05-slider-progress-and-meter-foundations.md)
6. [Phase 6 - Form Gallery, Documentation, And Milestone Acceptance](./phase-06-form-gallery-documentation-and-milestone-acceptance.md)

## Shared conventions

- Checklist numbering uses `N`, `N.M`, `N.M.K`, and `N.M.K.L` for phases,
  sections, tasks, and subtasks.
- Every phase, section, and task is followed by a description of intent and
  expected outcome.
- Every phase ends with a section named `Phase N Integration Tests`.
- Boxes remain unchecked until implementation and verification land together.
- Each implementation section is committed independently; all sections in one
  phase are delivered through one pull request.
- Components remain stateless Phoenix function components rendered with HEEX.
- Explicit and FormField modes share the same normalized public semantics.
- Native HTML expresses form values and states; CSS never creates a second state
  model.
- Mandatory identity, label, error, group, and ARIA relationships cannot be
  contradicted through caller globals.
- Pending, valid, invalid, determinate, and indeterminate values are rendered
  snapshots only.
- Component tests assert native elements, values, and relationships rather than
  incidental wrapper markup.
- Gallery examples remain controller-rendered and usable without demo-only
  JavaScript.

## Non-goals

- Changeset creation or mutation, validation execution, asynchronous validation,
  submission lifecycle, persistence, authentication, or authorization.
- A package-owned Gettext backend, translation policy, CSRF policy, or generated
  form builder.
- LiveView routes, sockets, streams, hooks, uploads, events, or state processes.
- Dstar, Datastar, Ash, Electron, or application-specific form integration.
- Comboboxes, listboxes, date-picker widgets, file uploads, OTP controls, rich
  editors, or client-owned form frameworks.
- Package-owned focus movement, scrolling, announcement, option fetching,
  filtering, polling, or progress estimation.
- Milestone C disclosure, navigation, and content-surface work.

## Exit criteria

- Consumers can build complete sign-in, profile, and settings forms without
  manual label/help/error wiring or a ShadcnUI client runtime.
- Applicable controls produce equivalent explicit and FormField markup and submit
  ordinary browser values through the demo server.
- Labels, legends, help, repeated errors, invalid state, and summary links have
  deterministic verified relationships across server rerenders.
- Native control states and values cover required, disabled, readonly where
  supported, checked, selected, multiple, pending, determinate, and indeterminate
  snapshots.
- Enhanced Select and expanding Textarea retain exact usable native fallbacks.
- Every form component has a stable gallery page with plain-language ownership,
  semantics, accessibility, fallback, theme, and provenance guidance.
- Light, dark, narrow, zoom, keyboard, forced-colors, native-submission, and
  no-script browser evidence passes.
- Package precommit, demo tests, static export, browser tests, ExDoc, SpecLed
  checks, package-boundary audits, and `git diff --check` pass.
