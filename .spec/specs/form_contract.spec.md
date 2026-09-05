# Shared native form contract

```spec-meta
id: shadcn_ui.form_contract
kind: policy
status: active
summary: Shared FormField normalization, identity, validation presentation, accessibility, and ownership rules.
decisions:
  - shadcn_ui.form_field_normalization
  - shadcn_ui.deterministic_form_accessibility
  - shadcn_ui.native_form_boundary
  - shadcn_ui.semantic_component_api_and_accessibility
surface:
  - lib/shadcn_ui/components/forms/**/*.ex
  - test/shadcn_ui/forms/form_contract_test.exs
  - test/shadcn_ui/components/forms/**/*.exs
  - README.md
```

## Project identity boundary

ShadcnUI is a personal MIT-licensed project. Repository ownership, package
scope, schema identifiers, and the canonical Fly hostname are publication
identity only; they do not alter this subject's requirements, semantics,
runtime boundary, package contents, or existing verification.

## Requirements

```spec-requirements
- id: shadcn_ui.form.normalization
  statement: Applicable controls shall accept Phoenix.HTML.FormField or explicit inputs through one normalization contract in which the field provides ID, name, value, and raw-error defaults and documented explicit inputs take precedence.
  priority: must
  stability: stable

- id: shadcn_ui.form.explicit_identity
  statement: Every submitted visible control rendered without a FormField shall require nonblank normalized ID and name values and shall fail clearly for missing or contradictory identity rather than emitting partially associated markup.
  priority: must
  stability: stable

- id: shadcn_ui.form.error_ownership
  statement: Error visibility shall use closed used-input, always, and hidden modes; explicit errors shall be escaped strings; raw field errors shall use a caller translator or deterministic interpolation; and ShadcnUI shall not own a Gettext backend or infer submission state.
  priority: must
  stability: stable

- id: shadcn_ui.form.deterministic_relationships
  statement: Labels, help, and repeated visible errors shall use deterministic IDs and native associations derived from the normalized control ID, and aria-describedby shall preserve ordered distinct caller references before rendered help and errors.
  priority: must
  stability: stable

- id: shadcn_ui.form.invalid_state
  statement: Visible errors shall produce protected aria-invalid state and references to every visible error, while hidden errors shall produce neither invalid state nor dangling accessibility references.
  priority: must
  stability: stable

- id: shadcn_ui.form.native_states
  statement: Required, disabled, readonly, checked, selected, multiple, and supported constraint states shall use native HTML attributes where applicable, with visual indicators supplementing rather than replacing native semantics.
  priority: must
  stability: stable

- id: shadcn_ui.form.protected_globals
  statement: Mandatory IDs, names, label targets, group semantics, native types, invalid state, and derived accessibility relationships shall take precedence over conflicting caller globals while unrelated documented native, aria-*, data-*, phx-*, and data-on-* attributes pass through.
  priority: must
  stability: stable

- id: shadcn_ui.form.pending_snapshot
  statement: Pending presentation shall describe only the rendered snapshot and shall not mutate a value, disable a control automatically, prevent duplicate submission, run validation, or own request lifecycle.
  priority: must
  stability: stable

- id: shadcn_ui.form.validation_boundary
  statement: Browser constraints, server errors, valid or invalid styling, and pending presentation shall never authorize, persist, submit, or execute an application operation, and consumers shall validate and authorize all submitted values.
  priority: must
  stability: stable

- id: shadcn_ui.form.native_submission
  statement: Controls shall submit ordinary browser form values without package-owned event handlers, hidden mirrored state except the documented checkbox sentinel, client synchronization, or a ShadcnUI JavaScript runtime.
  priority: must
  stability: stable
```

## Verification

Selecting `1.0.0` as the first public package version changes release identity
only; it does not change this subject's form contract or proof.

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's form contract.

The internal-record reorganization changes documentation paths only. Form
normalization, accessibility, submission and executable proof are unchanged.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/forms/form_contract_test.exs
  covers:
    - shadcn_ui.form.normalization
    - shadcn_ui.form.explicit_identity
    - shadcn_ui.form.error_ownership
    - shadcn_ui.form.deterministic_relationships
    - shadcn_ui.form.invalid_state
    - shadcn_ui.form.native_states
    - shadcn_ui.form.protected_globals
    - shadcn_ui.form.pending_snapshot
    - shadcn_ui.form.validation_boundary
    - shadcn_ui.form.native_submission

- kind: test_file
  target: test/shadcn_ui/milestone_b_acceptance_test.exs
  covers:
    - shadcn_ui.form.normalization
    - shadcn_ui.form.explicit_identity
    - shadcn_ui.form.error_ownership
    - shadcn_ui.form.deterministic_relationships
    - shadcn_ui.form.invalid_state
    - shadcn_ui.form.native_states
    - shadcn_ui.form.protected_globals
    - shadcn_ui.form.pending_snapshot
    - shadcn_ui.form.validation_boundary
    - shadcn_ui.form.native_submission

- kind: command
  target: mix precommit
  execute: true
  covers:
    - shadcn_ui.form.normalization
    - shadcn_ui.form.deterministic_relationships
    - shadcn_ui.form.native_submission
```

The root README's publication and navigation correction is cross-renderer
documentation only. Explicit versioned HexDocs and GitHub destinations replace
renderer-dependent relative links; no form contract changes.
