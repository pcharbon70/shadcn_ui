# Milestone A foundation components

```spec-meta
id: shadcn_ui.foundation_components
kind: package
status: active
summary: Button, Badge, Alert, Card, Avatar, and Skeleton rendering contracts.
decisions:
  - shadcn_ui.semantic_component_api_and_accessibility
  - shadcn_ui.scoped_theme_token_contract
  - shadcn_ui.progressive_enhancement_baseline
  - shadcn_ui.upstream_provenance
surface:
  - lib/shadcn_ui/components/foundation/**/*.ex
  - test/shadcn_ui/components/foundation/**/*.exs
  - test/shadcn_ui/foundation_components_test.exs
  - README.md
```

## Project identity boundary

ShadcnUI is a personal MIT-licensed project. Repository ownership, package
scope, schema identifiers, and the canonical Fly hostname are publication
identity only; they do not alter this subject's requirements, semantics,
runtime boundary, package contents, or existing verification.

## Requirements

```spec-requirements
- id: shadcn_ui.foundation.button
  statement: Button shall render a native button with required escaped or trusted slot content, types button, submit, and reset, variants default, secondary, destructive, outline, ghost, and link, sizes small, default, large, and icon, plus explicit disabled and presentation-only loading snapshots.
  priority: must
  stability: evolving

- id: shadcn_ui.foundation.button_content
  statement: Button shall support optional leading and trailing slots, require a nonblank accessible label for icon-only presentation, preserve native disabled semantics, and leave activation, submission, duplicate prevention, and command outcomes to the caller.
  priority: must
  stability: stable

- id: shadcn_ui.foundation.badge
  statement: Badge shall render a noninteractive span with required content and closed default, secondary, destructive, and outline variants without accepting destinations, button behavior, dismissal, or package-owned state.
  priority: must
  stability: stable

- id: shadcn_ui.foundation.alert
  statement: Alert shall render a visible title and/or description with optional icon and actions slots, closed default and destructive variants, and an explicit none, polite, or assertive announcement policy that produces deterministic native region semantics.
  priority: must
  stability: evolving

- id: shadcn_ui.foundation.alert_ownership
  statement: Alert shall not infer urgency from color and shall leave appearance timing, lifecycle, dismissal, retry, and action outcomes to the caller.
  priority: must
  stability: stable

- id: shadcn_ui.foundation.card
  statement: Card shall render one bordered content surface with optional header, title, description, footer, and actions composition while preserving caller-authored headings, links, forms, and controls without assigning workflow semantics.
  priority: must
  stability: stable

- id: shadcn_ui.foundation.avatar
  statement: Avatar shall render required escaped initials as the always-present fallback and may layer one caller-owned image with required source and nonblank alternative text without onerror JavaScript, remote lookup, upload, or image-provider behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.foundation.avatar_stack
  statement: Avatar shall support closed sizes and bounded stack presentation while keeping each meaningful image or text alternative available and avoiding duplicate accessible names from decorative overlap.
  priority: should
  stability: evolving

- id: shadcn_ui.foundation.skeleton
  statement: Skeleton shall render a decorative aria-hidden placeholder with closed shape and size guidance, optional caller classes, pulse presentation, and a static reduced-motion fallback without announcing loading or owning its lifecycle.
  priority: must
  stability: stable

- id: shadcn_ui.foundation.shared_contract
  statement: All six foundation components shall follow the shared closed-value, slot, escaping, caller-global, protected-semantics, deterministic identity, presentation snapshot, and progressive-floor requirements.
  priority: must
  stability: stable
```

## Verification

Selecting `1.0.0` as the first public package version changes release identity
only; it does not change this subject's component behavior or proof.

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's component contract.

The internal-record reorganization changes documentation paths only. Foundation
component APIs, presentation and executable proof are unchanged.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/components/foundation/button_test.exs
  covers:
    - shadcn_ui.foundation.button
    - shadcn_ui.foundation.button_content
    - shadcn_ui.foundation.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/foundation/badge_test.exs
  covers:
    - shadcn_ui.foundation.badge
    - shadcn_ui.foundation.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/foundation/alert_test.exs
  covers:
    - shadcn_ui.foundation.alert
    - shadcn_ui.foundation.alert_ownership
    - shadcn_ui.foundation.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/foundation/card_test.exs
  covers:
    - shadcn_ui.foundation.card
    - shadcn_ui.foundation.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/foundation/avatar_test.exs
  covers:
    - shadcn_ui.foundation.avatar
    - shadcn_ui.foundation.avatar_stack
    - shadcn_ui.foundation.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/foundation/skeleton_test.exs
  covers:
    - shadcn_ui.foundation.skeleton
    - shadcn_ui.foundation.shared_contract

- kind: test_file
  target: test/shadcn_ui/foundation_components_test.exs
  covers:
    - shadcn_ui.foundation.button
    - shadcn_ui.foundation.button_content
    - shadcn_ui.foundation.badge
    - shadcn_ui.foundation.alert
    - shadcn_ui.foundation.alert_ownership
    - shadcn_ui.foundation.card
    - shadcn_ui.foundation.avatar
    - shadcn_ui.foundation.avatar_stack
    - shadcn_ui.foundation.skeleton
    - shadcn_ui.foundation.shared_contract

- kind: test_file
  target: test/shadcn_ui/milestone_a_acceptance_test.exs
  covers:
    - shadcn_ui.foundation.button
    - shadcn_ui.foundation.button_content
    - shadcn_ui.foundation.badge
    - shadcn_ui.foundation.alert
    - shadcn_ui.foundation.alert_ownership
    - shadcn_ui.foundation.card
    - shadcn_ui.foundation.avatar
    - shadcn_ui.foundation.avatar_stack
    - shadcn_ui.foundation.skeleton
    - shadcn_ui.foundation.shared_contract
```

The root README's publication and navigation correction is cross-renderer
documentation only. Explicit versioned HexDocs and GitHub destinations replace
renderer-dependent relative links; no foundation-component contract changes.
