# Milestone C - Disclosure, Navigation, And Content Surfaces

This wave delivers semantic page-composition structures for substantial server-
rendered applications. It keeps disclosure, links, radios, scrolling, headings,
and landmarks native; treats sticky, anchored, and selected-panel presentation
as progressive CSS; and adds no package JavaScript or application behavior.

## Request alignment

- Accordion uses native `details` and `summary` in independent or progressively
  exclusive groups.
- Navigation Menu renders named destination navigation with ordinary links and
  caller-owned current-location state.
- Header and Section Header compose native caller content without manufacturing
  heading levels, route behavior, or commands.
- Scroll Area preserves native scrolling and explicit focus policy; Separator
  distinguishes structural and decorative use.
- The upstream radio-based pattern is released only as Radio Panels. A true ARIA
  Tab Group is deferred until its runtime, keyboard, focus, and activation
  contract is separately accepted.
- The gallery adds Disclosure, Navigation, and Content Surfaces categories plus
  substantial documentation, settings, and application-shell compositions.

## Phase order

1. [Phase 1 - Separator And Scroll Area Foundations](./phase-01-separator-and-scroll-area-foundations.md)
2. [Phase 2 - Native Accordion Foundations](./phase-02-native-accordion-foundations.md)
3. [Phase 3 - Destination Navigation Menu Foundations](./phase-03-destination-navigation-menu-foundations.md)
4. [Phase 4 - Header, Section Header, And Radio Panels](./phase-04-header-section-header-and-radio-panels.md)
5. [Phase 5 - Content Gallery, Documentation, And Milestone Acceptance](./phase-05-content-gallery-documentation-and-milestone-acceptance.md)

## Shared conventions

- Checklist numbering uses `N`, `N.M`, `N.M.K`, and `N.M.K.L` for phases,
  sections, tasks, and subtasks.
- Every phase, section, and task is followed by a description of intent and
  expected outcome.
- Every phase ends with a section named `Phase N Integration Tests`.
- Boxes remain unchecked until implementation and verification land together.
- Each implementation section is committed independently; all sections in one
  phase are delivered through one pull request.
- Components remain stateless Phoenix function components rendered with HEEx.
- Native elements and browser behavior are the semantic and interaction floor.
- Closed values map to complete static classes; stable caller keys produce only
  deterministic identifiers and never request-derived atoms.
- Applications own destinations, authorization, current route, commands,
  persistence, server state, scroll restoration, and selection transitions.
- Capability-dependent presentation must retain its exact documented native or
  normal-flow fallback.
- Gallery examples remain controller-rendered and usable without demo-only
  JavaScript.

## Non-goals

- True ARIA tabs, menus, menubars, command palettes, trees, interactive grids,
  client routers, or authorization-aware navigation.
- Package-owned disclosure, selection, navigation, focus, scroll, viewport,
  responsive, or persisted state.
- Virtual scrolling, infinite loading, custom scrollbars, lazy panel loading,
  route matching, deep-link synchronization, or analytics.
- LiveView routes, hooks, Dstar, Datastar, Ash, Electron, database, domain, or
  application-process integration.
- Milestone D modal, popup, and overlay behavior.

## Exit criteria

- Consumers can compose substantial documentation, settings, and application-
  shell pages from Milestones A, B, and C without a ShadcnUI client runtime.
- Accordion retains native disclosure and access to all content in independent,
  exclusive, CSS-disabled, unsupported-feature, and reduced-motion cases.
- Navigation links, landmarks, headings, current-location state, and Radio
  Panels expose semantics that match their implemented keyboard behavior.
- Scroll and sticky surfaces retain native focus, fragments, content access, and
  normal-flow fallbacks at narrow widths, zoom, and forced colors.
- Every Milestone C component has a stable gallery page with plain-language
  semantics, ownership, fallback, theme, accessibility, and provenance guidance.
- Package precommit, demo tests, static export, browser tests, ExDoc, SpecLed
  checks, package-boundary audits, and `git diff --check` pass.
