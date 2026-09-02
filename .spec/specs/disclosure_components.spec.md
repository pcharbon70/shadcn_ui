# Milestone C disclosure components

```spec-meta
id: shadcn_ui.disclosure_components
kind: package
status: active
summary: Native Accordion rendering, grouping, identity, state-snapshot, and fallback contracts.
decisions:
  - shadcn_ui.native_disclosure_grouping
  - shadcn_ui.semantic_component_api_and_accessibility
  - shadcn_ui.progressive_enhancement_baseline
  - shadcn_ui.scoped_theme_token_contract
surface:
  - lib/shadcn_ui/components/disclosure/accordion.ex
  - lib/shadcn_ui/components/disclosure/**/*.ex
  - test/shadcn_ui/components/disclosure/accordion_test.exs
  - test/shadcn_ui/components/disclosure/**/*.exs
  - test/shadcn_ui/disclosure_components_test.exs
  - test/browser/accordion-foundations.spec.mjs
  - test/fixtures/accordion.html
  - test/shadcn_ui/milestone_c_acceptance_test.exs
  - README.md
```

## Project identity boundary

ShadcnUI is a personal MIT-licensed project. Repository ownership, package
scope, schema identifiers, and the canonical Fly hostname are publication
identity only; they do not alter this subject's requirements, semantics,
runtime boundary, package contents, or existing verification.

## Requirements

```spec-requirements
- id: shadcn_ui.disclosure.accordion_native
  statement: Accordion shall render one native details element per item with required summary and trusted HEEX content, preserving browser disclosure activation, keyboard behavior, focus, and find-in-page semantics without role-based imitations or package JavaScript.
  priority: must
  stability: evolving

- id: shadcn_ui.disclosure.accordion_modes
  statement: Accordion shall provide closed independent and exclusive modes; independent mode shall emit no shared name, while exclusive mode shall give every details item one deterministic shared name without adding a second state model.
  priority: must
  stability: evolving

- id: shadcn_ui.disclosure.deterministic_identity
  statement: Accordion shall require a nonblank explicit base ID and stable caller item keys and shall derive group, details, summary, and content identities deterministically without request-derived atoms, random values, or process-global state.
  priority: must
  stability: stable

- id: shadcn_ui.disclosure.open_snapshot
  statement: Caller-supplied open values shall describe only the rendered server snapshot; ShadcnUI shall not observe toggles, persist browser state, infer user intent, or reconcile open state across replacement renders.
  priority: must
  stability: stable

- id: shadcn_ui.disclosure.protected_semantics
  statement: Native details and summary elements, IDs, shared exclusive name, open state, and required relationships shall take precedence over conflicting caller globals while unrelated documented data-*, aria-*, phx-*, and data-on-* attributes pass through.
  priority: must
  stability: stable

- id: shadcn_ui.disclosure.fallback
  statement: Unsupported exclusive grouping shall degrade to independently operable details, and absent CSS or animation support shall retain every summary and content region in native document order with reduced motion preserving state and access.
  priority: must
  stability: stable

- id: shadcn_ui.disclosure.ownership
  statement: Accordion shall not own authorization, lazy loading, analytics, routing, validation, focus movement, scrolling, or persisted disclosure state.
  priority: must
  stability: stable

- id: shadcn_ui.disclosure.shared_contract
  statement: Accordion shall follow the shared closed-value, slot, escaping, caller-global, protected-semantics, deterministic-identity, presentation-snapshot, theme, and progressive-floor requirements.
  priority: must
  stability: stable
```

## Verification

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's component contract.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/components/disclosure/accordion_test.exs
  covers:
    - shadcn_ui.disclosure.accordion_native
    - shadcn_ui.disclosure.accordion_modes
    - shadcn_ui.disclosure.deterministic_identity
    - shadcn_ui.disclosure.open_snapshot
    - shadcn_ui.disclosure.protected_semantics
    - shadcn_ui.disclosure.fallback
    - shadcn_ui.disclosure.ownership
    - shadcn_ui.disclosure.shared_contract

- kind: test_file
  target: test/shadcn_ui/disclosure_components_test.exs
  covers:
    - shadcn_ui.disclosure.accordion_native
    - shadcn_ui.disclosure.accordion_modes
    - shadcn_ui.disclosure.deterministic_identity
    - shadcn_ui.disclosure.open_snapshot
    - shadcn_ui.disclosure.protected_semantics
    - shadcn_ui.disclosure.fallback
    - shadcn_ui.disclosure.ownership
    - shadcn_ui.disclosure.shared_contract

- kind: test_file
  target: test/browser/accordion-foundations.spec.mjs
  covers:
    - shadcn_ui.disclosure.accordion_native
    - shadcn_ui.disclosure.accordion_modes
    - shadcn_ui.disclosure.fallback
    - shadcn_ui.disclosure.shared_contract

- kind: test_file
  target: test/shadcn_ui/milestone_c_acceptance_test.exs
  covers:
    - shadcn_ui.disclosure.accordion_native
    - shadcn_ui.disclosure.accordion_modes
    - shadcn_ui.disclosure.deterministic_identity
    - shadcn_ui.disclosure.open_snapshot
    - shadcn_ui.disclosure.protected_semantics
    - shadcn_ui.disclosure.fallback
    - shadcn_ui.disclosure.ownership
    - shadcn_ui.disclosure.shared_contract
```
