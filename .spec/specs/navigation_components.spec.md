# Milestone C navigation components

```spec-meta
id: shadcn_ui.navigation_components
kind: package
status: active
summary: Destination Navigation Menu, Header, and Section Header semantic rendering contracts.
decisions:
  - shadcn_ui.destination_navigation_landmarks
  - shadcn_ui.native_scroll_sticky_surfaces
  - shadcn_ui.semantic_component_api_and_accessibility
  - shadcn_ui.progressive_enhancement_baseline
surface:
  - lib/shadcn_ui/components/navigation/navigation_menu.ex
  - lib/shadcn_ui/components/navigation/header.ex
  - lib/shadcn_ui/components/navigation/section_header.ex
  - lib/shadcn_ui/components/navigation/**/*.ex
  - test/shadcn_ui/components/navigation/navigation_menu_test.exs
  - test/shadcn_ui/components/navigation/**/*.exs
  - test/shadcn_ui/navigation_components_test.exs
  - test/browser/navigation-menu-foundations.spec.mjs
  - test/browser/phase4-headers-radio-panels.spec.mjs
  - test/fixtures/navigation_menu.html
  - test/fixtures/phase4_headers_radio_panels.html
  - test/shadcn_ui/phase4_components_test.exs
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
- id: shadcn_ui.navigation.menu
  statement: Navigation Menu shall render a native nav with a required nonblank accessible name, one list, and one real anchor per caller item using stable keys, nonblank caller-owned destinations, and escaped or trusted label content.
  priority: must
  stability: evolving

- id: shadcn_ui.navigation.link_semantics
  statement: Navigation Menu shall emit no menu, menubar, menuitem, tablist, tab, popup, or command semantics and shall not add roving tabindex, arrow-key handling, activation interception, or a client router.
  priority: must
  stability: stable

- id: shadcn_ui.navigation.current_location
  statement: Current-location presentation shall come only from explicit caller item state mapped to closed native aria-current values; ShadcnUI shall not inspect request paths, compare URLs, infer route matches, or consult authorization.
  priority: must
  stability: stable

- id: shadcn_ui.navigation.destination_ownership
  statement: Applications shall own route generation, destination safety, authorization, visibility, navigation outcomes, prefetching, history, analytics, and external-link policy, while ShadcnUI preserves ordinary anchor behavior.
  priority: must
  stability: stable

- id: shadcn_ui.navigation.header
  statement: Header shall compose optional caller-owned brand, primary navigation, utilities, and actions in a native header without changing the semantics of supplied links, buttons, forms, or headings or inventing a page-heading level.
  priority: must
  stability: evolving

- id: shadcn_ui.navigation.section_header
  statement: Section Header shall preserve one caller-authored heading and optional description and actions in document order with closed static and sticky presentation and no package-owned section state or command behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.navigation.sticky_fallback
  statement: Sticky and anchor-positioned presentation shall be optional CSS enhancement; unsupported or CSS-disabled environments shall retain normal document flow, visible focus, current-location cues independent of color or decoration, and reachable fragment targets.
  priority: must
  stability: stable

- id: shadcn_ui.navigation.protected_semantics
  statement: Required landmark name, native anchor destinations, current-location state, structural elements, and caller-authored heading semantics shall take precedence over conflicting globals while unrelated documented globals pass through.
  priority: must
  stability: stable

- id: shadcn_ui.navigation.shared_contract
  statement: Navigation Menu, Header, and Section Header shall follow the shared closed-value, slot, escaping, protected-global, deterministic-identity, stateless, theme, and progressive-floor requirements.
  priority: must
  stability: stable
```

## Verification

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's component contract.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/components/navigation/navigation_menu_test.exs
  covers:
    - shadcn_ui.navigation.menu
    - shadcn_ui.navigation.link_semantics
    - shadcn_ui.navigation.current_location
    - shadcn_ui.navigation.destination_ownership
    - shadcn_ui.navigation.protected_semantics
    - shadcn_ui.navigation.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/navigation/headers_test.exs
  covers:
    - shadcn_ui.navigation.header
    - shadcn_ui.navigation.section_header
    - shadcn_ui.navigation.sticky_fallback
    - shadcn_ui.navigation.protected_semantics
    - shadcn_ui.navigation.shared_contract

- kind: test_file
  target: test/shadcn_ui/navigation_components_test.exs
  covers:
    - shadcn_ui.navigation.menu
    - shadcn_ui.navigation.link_semantics
    - shadcn_ui.navigation.current_location
    - shadcn_ui.navigation.destination_ownership
    - shadcn_ui.navigation.protected_semantics
    - shadcn_ui.navigation.shared_contract

- kind: test_file
  target: test/shadcn_ui/phase4_components_test.exs
  covers:
    - shadcn_ui.navigation.header
    - shadcn_ui.navigation.section_header
    - shadcn_ui.navigation.sticky_fallback
    - shadcn_ui.navigation.protected_semantics
    - shadcn_ui.navigation.shared_contract

- kind: test_file
  target: test/browser/navigation-menu-foundations.spec.mjs
  covers:
    - shadcn_ui.navigation.menu
    - shadcn_ui.navigation.link_semantics
    - shadcn_ui.navigation.current_location
    - shadcn_ui.navigation.destination_ownership
    - shadcn_ui.navigation.protected_semantics
    - shadcn_ui.navigation.shared_contract

- kind: test_file
  target: test/browser/phase4-headers-radio-panels.spec.mjs
  covers:
    - shadcn_ui.navigation.header
    - shadcn_ui.navigation.section_header
    - shadcn_ui.navigation.sticky_fallback
    - shadcn_ui.navigation.protected_semantics
    - shadcn_ui.navigation.shared_contract

- kind: test_file
  target: test/shadcn_ui/milestone_c_acceptance_test.exs
  covers:
    - shadcn_ui.navigation.menu
    - shadcn_ui.navigation.link_semantics
    - shadcn_ui.navigation.current_location
    - shadcn_ui.navigation.destination_ownership
    - shadcn_ui.navigation.header
    - shadcn_ui.navigation.section_header
    - shadcn_ui.navigation.sticky_fallback
    - shadcn_ui.navigation.protected_semantics
    - shadcn_ui.navigation.shared_contract
```
