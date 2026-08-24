# Milestone B - Native Forms and Validation

## Description

Milestone B creates a production-quality native form system for controller-
rendered Phoenix and other HEEx consumers. It uses browser form semantics and
`Phoenix.HTML.FormField` integration while keeping values, validation policy,
submission, persistence, and domain operations caller-owned.

## Intended outcomes

- Explicit control identities and `Phoenix.HTML.FormField` values share one
  deterministic field relationship contract.
- Labels, help text, errors, required state, and `aria-describedby`
  relationships remain correct through server rerenders.
- Native controls submit ordinary browser form values and preserve familiar
  keyboard, mobile picker, and constraint-validation behavior.
- Enhanced CSS presentations fall back to usable native controls when a browser
  lacks the relevant platform feature.

## Component scope

- Field, Label, Help, Field Errors, and Error Summary composition.
- Text-like Input types with native constraints and input modes.
- Textarea with documented `field-sizing: content` enhancement and fixed-height
  fallback.
- Checkbox and Radio Group using real native inputs.
- Switch as a checkbox presentation, without inventing a second state model.
- Native Select and a separately documented Enhanced Select using customizable
  select features where supported.
- Slider using `input type="range"` with native keyboard and form behavior.
- Progress and Meter with their distinct native meanings.

## Architecture work required

- Specify field normalization, ID derivation, error visibility, required
  indicators, pending presentation, and protected accessibility attributes.
- Define supported input types and reject arbitrary structural or raw-HTML
  customization that would weaken component guarantees.
- Decide how checked, selected, multiple, disabled, readonly, and submitted
  values interact with Phoenix form normalization.
- Define the enhanced-select browser floor and verify that unsupported browsers
  receive the classic native select without hidden or duplicated values.
- Document that validation and visual invalid state do not authorize or execute
  application operations.

## Gallery scope

- Add a Forms category and one dedicated page per component.
- Demonstrate pristine, used, valid, invalid, disabled, readonly, required,
  pending, and server-error states.
- Provide explicit-ID and `Phoenix.HTML.FormField` examples side by side.
- Include complete sign-in, profile, and settings compositions using only
  caller-owned sample data.
- Show native and enhanced select behavior and the exact unsupported-browser
  fallback.
- Explain the difference between Progress and Meter in plain language.

## Verification expectations

- Rendering tests cover identity, value normalization, escaping, native
  attributes, errors, ARIA relationships, and ordinary form submission.
- Integration tests submit realistic Phoenix forms and verify received values
  without LiveView or a component runtime.
- Browser tests cover Tab order, labels, checkbox/radio keyboard behavior,
  select fallback, slider keys, validation presentation, zoom, and high contrast.
- Automated accessibility checks are supplemented by explicit semantic and
  keyboard assertions.

## Exit criteria

Milestone B is complete when every form component has an explicit current-truth
contract, native submissions work through the demo server, enhanced features
degrade safely, and the online gallery documents states, ownership, semantics,
and HEEX usage for the complete form catalogue.

## Deferred work

Comboboxes, listboxes, date pickers, rich editors, asynchronous validation,
domain-specific fields, and client-owned form frameworks remain outside this
milestone unless separately specified later.

## Accepted architecture and current truth

- [FormField normalization and validation ownership](../decisions/form-field-normalization-and-validation-ownership.md)
- [Deterministic native form accessibility](../decisions/deterministic-native-form-accessibility.md)
- [Native control and submission boundary](../decisions/native-form-control-and-submission-boundary.md)
- [Enhanced Select progressive boundary](../decisions/enhanced-select-progressive-boundary.md)
- [Shared native form contract](../specs/form_contract.spec.md)
- [Milestone B native form components](../specs/form_components.spec.md)
- [Milestone B form gallery and acceptance](../specs/form_gallery.spec.md)

## Implementation plan

[Milestone B - Native Forms and Validation](../planning/milestone-b-native-forms-and-validation/README.md)
