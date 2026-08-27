# Consumer-neutral compatibility and accessibility acceptance

```spec-meta
id: shadcn_ui.compatibility_accessibility
kind: policy
status: active
summary: Capability-based browser evidence and separate automated and manual accessibility acceptance across the complete public catalogue.
decisions:
  - shadcn_ui.progressive_enhancement_baseline
  - shadcn_ui.consumer_neutral_compatibility
  - shadcn_ui.native_overlay_platform_runtime
  - shadcn_ui.motion_media_capability_css
surface:
  - priv/compatibility/*.json
  - priv/compatibility/catalogue.json
  - docs/compatibility.md
  - docs/accessibility-review.md
  - test/browser/milestone-f-compatibility.spec.mjs
  - test/shadcn_ui/milestone_f_capability_policy_test.exs
  - test/shadcn_ui/milestone_f_acceptance_test.exs
```

## Requirements

```spec-requirements
- id: shadcn_ui.compatibility_accessibility.capability_policy
  statement: Support shall be defined by each component's declared native HTML and CSS capability set plus its documented fallback rather than by application, operating system, browser brand, or embedded-renderer identity.
  priority: must
  stability: stable

- id: shadcn_ui.compatibility_accessibility.exact_engine_evidence
  statement: Automated evidence shall record exact locked Chromium, Firefox, and WebKit versions, test date, capability observations, component outcomes, and known gaps without turning those versions into normative targets.
  priority: must
  stability: evolving

- id: shadcn_ui.compatibility_accessibility.consumer_boundary
  statement: ShadcnUI shall make no Electron or other embedded-consumer support claim; consuming applications shall own validation of their renderer, CSP, transport, shell, and deployment environment.
  priority: must
  stability: stable

- id: shadcn_ui.compatibility_accessibility.fallback_evidence
  statement: Acceptance shall exercise deliberately missing-capability, CSS-disabled, no-script, failed-media, and ordinary-destination paths without using demo shims as package behavior.
  priority: must
  stability: stable

- id: shadcn_ui.compatibility_accessibility.responsive_and_preferences
  statement: The complete catalogue shall preserve content, operation, visible focus, themes, forced colors, reduced motion, RTL and useful narrow and zoomed layouts according to each component contract.
  priority: must
  stability: stable

- id: shadcn_ui.compatibility_accessibility.keyboard_and_semantics
  statement: Browser acceptance shall verify native keyboard and focus behavior, accessible names and relationships, landmark structure, honest roles, disabled states, live feedback where specified, and reachable fallback destinations.
  priority: must
  stability: stable

- id: shadcn_ui.compatibility_accessibility.automated_accessibility
  statement: Pinned automated accessibility checks shall run against representative states in both themes and shall supplement rather than replace explicit semantic assertions.
  priority: must
  stability: stable

- id: shadcn_ui.compatibility_accessibility.manual_review
  statement: A bounded manual review record shall identify environment, assistive technology or device, scenarios, observations, defects, reviewer, date, and unresolved status without presenting unexecuted checks as certification.
  priority: must
  stability: evolving

- id: shadcn_ui.compatibility_accessibility.evidence_separation
  statement: Source review, capability parsing, automated component behavior, manual review, CI, and deployed smoke shall remain distinct evidence states with no implied promotion between them.
  priority: must
  stability: stable
```

## Verification

```spec-verification
- kind: test_file
  target: test/browser/milestone-f-compatibility.spec.mjs
  covers:
    - shadcn_ui.compatibility_accessibility.exact_engine_evidence
    - shadcn_ui.compatibility_accessibility.fallback_evidence
    - shadcn_ui.compatibility_accessibility.responsive_and_preferences
    - shadcn_ui.compatibility_accessibility.keyboard_and_semantics
    - shadcn_ui.compatibility_accessibility.automated_accessibility

- kind: test_file
  target: test/shadcn_ui/milestone_f_capability_policy_test.exs
  covers:
    - shadcn_ui.compatibility_accessibility.capability_policy
    - shadcn_ui.compatibility_accessibility.exact_engine_evidence

- kind: test_file
  target: test/shadcn_ui/milestone_f_acceptance_test.exs
  covers:
    - shadcn_ui.compatibility_accessibility.capability_policy
    - shadcn_ui.compatibility_accessibility.consumer_boundary
    - shadcn_ui.compatibility_accessibility.manual_review
    - shadcn_ui.compatibility_accessibility.evidence_separation
```
