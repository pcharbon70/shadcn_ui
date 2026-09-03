# Milestone B form gallery and acceptance

```spec-meta
id: shadcn_ui.form_gallery
kind: application
status: active
summary: Dedicated form catalogue, realistic native submissions, browser fallback evidence, and Milestone B guidance.
decisions:
  - shadcn_ui.form_field_normalization
  - shadcn_ui.deterministic_form_accessibility
  - shadcn_ui.native_form_boundary
  - shadcn_ui.enhanced_select_boundary
  - shadcn_ui.gallery_static_publication
surface:
  - demo/**
  - test/browser/milestone-b-forms.spec.mjs
  - test/shadcn_ui/milestone_b_acceptance_test.exs
  - README.md
```

## Project identity boundary

ShadcnUI is a personal MIT-licensed project. Repository ownership, package
scope, schema identifiers, and the canonical Fly hostname are publication
identity only; they do not alter this subject's requirements, semantics,
runtime boundary, package contents, or existing verification.

## Requirements

```spec-requirements
- id: shadcn_ui.form_gallery.catalog
  statement: The gallery shall add one stable Forms category and a dedicated page for Field, Label, Help, Field Errors, Error Summary, Input, Textarea, Checkbox, Radio Group, Switch, Native Select, Enhanced Select, Slider, Progress, and Meter through the closed catalogue and static route inventory.
  priority: must
  stability: evolving

- id: shadcn_ui.form_gallery.states
  statement: Component pages shall demonstrate applicable pristine, used, valid, invalid, disabled, readonly, required, pending, checked, selected, multiple, indeterminate, and server-error snapshots without implying package-owned transitions.
  priority: must
  stability: evolving

- id: shadcn_ui.form_gallery.modes
  statement: Applicable component pages shall present explicit-ID and Phoenix.HTML.FormField examples side by side with equivalent identity, value, error, and accessibility relationships.
  priority: must
  stability: stable

- id: shadcn_ui.form_gallery.compositions
  statement: The gallery shall provide complete sign-in, profile, and settings form compositions using only caller-owned sample data and ordinary controller-rendered submissions.
  priority: must
  stability: evolving

- id: shadcn_ui.form_gallery.submission_fixture
  statement: A demo endpoint shall receive realistic native form submissions, render escaped deterministic received values for test evidence, and perform no persistence, authentication, authorization, or domain operation.
  priority: must
  stability: stable

- id: shadcn_ui.form_gallery.select_fallback
  statement: Native and Enhanced Select pages shall show their common value contract, capability-gated enhanced presentation, and exact unsupported or CSS-disabled classic fallback without hidden or duplicated values.
  priority: must
  stability: stable

- id: shadcn_ui.form_gallery.semantic_guidance
  statement: Guidance shall explain native semantics, FormField and explicit precedence, validation and translation ownership, protected relationships, native constraints, pending presentation, and the distinction between task Progress and scalar Meter in plain language.
  priority: must
  stability: stable

- id: shadcn_ui.form_gallery.content_stress
  statement: Form examples shall cover long labels, translated text, repeated errors, repeated groups, narrow layouts, 200 percent zoom, keyboard focus, forced colors, light and dark themes, and operation without demo-only JavaScript.
  priority: must
  stability: evolving

- id: shadcn_ui.form_gallery.browser_behavior
  statement: Browser tests shall verify tab order, native label activation, checkbox and radio keyboard behavior, select fallback, slider keys, native submission values, validation presentation, and absence of package-owned client behavior.
  priority: must
  stability: evolving
```

## Verification

Selecting `1.0.0` as the first public package version changes release identity
only; it does not change this subject's gallery inventory or proof.

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's gallery contract.

The internal-record reorganization changes documentation paths only. Form
gallery behavior, fixtures and executable proof are unchanged.

Milestone G Phase 4 changes only the shared documentation hierarchy. Forms
coverage locates compile-checked source through the stable specimen surface and
continues to exercise form inputs inside the rendered preview, distinct from
the gallery's native Preview/Code controls.
Remediation R6 restores the Milestone B browser suite to CI and updates its
narrow navigation and focus assertions to the accepted bounded mobile panel and
skip-link contracts without changing form semantics.

```spec-verification
- kind: test_file
  target: demo/test/shadcn_ui_demo/form_catalog_test.exs
  covers:
    - shadcn_ui.form_gallery.catalog
    - shadcn_ui.form_gallery.states
    - shadcn_ui.form_gallery.modes
    - shadcn_ui.form_gallery.semantic_guidance

- kind: test_file
  target: demo/test/shadcn_ui_demo_web/controllers/form_submission_controller_test.exs
  covers:
    - shadcn_ui.form_gallery.compositions
    - shadcn_ui.form_gallery.submission_fixture

- kind: test_file
  target: test/browser/milestone-b-forms.spec.mjs
  covers:
    - shadcn_ui.form_gallery.states
    - shadcn_ui.form_gallery.modes
    - shadcn_ui.form_gallery.select_fallback
    - shadcn_ui.form_gallery.content_stress
    - shadcn_ui.form_gallery.browser_behavior

- kind: test_file
  target: test/shadcn_ui/milestone_b_acceptance_test.exs
  covers:
    - shadcn_ui.form_gallery.catalog
    - shadcn_ui.form_gallery.states
    - shadcn_ui.form_gallery.modes
    - shadcn_ui.form_gallery.compositions
    - shadcn_ui.form_gallery.submission_fixture
    - shadcn_ui.form_gallery.select_fallback
    - shadcn_ui.form_gallery.semantic_guidance
    - shadcn_ui.form_gallery.content_stress
    - shadcn_ui.form_gallery.browser_behavior
```
