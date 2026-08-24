---
id: shadcn_ui.form_field_normalization
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.form_contract
  - shadcn_ui.form_components
  - shadcn_ui.form_gallery
---

# Normalize Phoenix Form Fields Without Owning Validation

## Context

Phoenix consumers commonly render controls from `Phoenix.HTML.FormField`, while
tests and non-form consumers need explicit `id`, `name`, `value`, and error
inputs. Per-component normalization would create inconsistent identity, value,
error visibility, and accessibility behavior. ShadcnUI also cannot assume an
application Gettext backend, changeset lifecycle, or submission policy.

## Decision

Milestone B form components use one internal normalization contract.

- A component accepts a `Phoenix.HTML.FormField` where applicable or documented
  explicit inputs. The field supplies default `id`, `name`, `value`, and raw
  errors; supported explicit attributes take precedence when supplied.
- Every submitted visible control requires a nonblank normalized `id` and
  `name`. Missing or contradictory identity fails clearly instead of rendering
  a partially associated control.
- Error visibility uses a closed caller-selected mode: follow
  `Phoenix.Component.used_input?/1`, always show, or hide. ShadcnUI never infers
  that submission occurred.
- Explicit errors are already-rendered strings. Raw `{message, options}` field
  errors use a caller-supplied one-arity translator when present; otherwise the
  package performs deterministic placeholder interpolation without adding an
  application Gettext dependency.
- Values and error messages remain escaped. No form component accepts raw HTML
  strings or marks caller messages safe.
- Pending is presentation only. It may expose documented busy styling and
  semantics but never changes values, disables controls, prevents duplicate
  submission, or owns a transition back to idle.
- Constraint attributes and a visual invalid snapshot do not validate,
  authorize, persist, or execute an operation. Applications must validate and
  authorize every submitted value independently.

## Consequences

The same public semantic contract works with `@form[:field]` and explicit test
fixtures. Applications retain translation and validation timing, while shared
tests can prove consistent identity and error behavior across controls.

Any future package-owned changeset mutation, submission lifecycle, translation
backend, or asynchronous validation would require a new decision.
