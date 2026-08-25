# Phase 3 - Destination Navigation Menu Foundations

Back to wave: [README](./README.md)

- [ ] 3 Phase - Deliver named destination navigation whose links, current state,
  focus, and keyboard behavior remain ordinary native browser semantics.

  This phase adds Navigation Menu without menu, tab, command, or client-router
  overstatement. Callers choose destinations and current location explicitly;
  ShadcnUI owns only deterministic semantic markup and presentation.

  - [x] 3.1 Section - Navigation structure and destination contract.

    This section establishes the required landmark, list, link, and stable-item
    model for server-rendered navigation.

    - [x] 3.1.1 Task - Implement named list navigation.

      The component should provide useful structure to sighted and assistive-
      technology users without changing how anchors activate.

      - [x] 3.1.1.1 Subtask - Add a defining Navigation.NavigationMenu module and import it through `use ShadcnUI`.
      - [x] 3.1.1.2 Subtask - Require a nonblank accessible landmark name and render one native `nav`, list, list item, and anchor per entry.
      - [x] 3.1.1.3 Subtask - Require stable caller keys and nonblank caller-owned destinations while supporting escaped labels and semantically distinct trusted slots.
      - [x] 3.1.1.4 Subtask - Preserve ordinary anchor Tab, Enter, context-menu, open-in-new-tab, download, and browser-history behavior without activation interception.

    - [x] 3.1.2 Task - Implement explicit current-location and protected semantics.

      Current styling should reflect caller truth exactly and never depend on a
      hidden request or router lookup.

      - [x] 3.1.2.1 Subtask - Add closed native `aria-current` values and render them only from explicit item state.
      - [x] 3.1.2.2 Subtask - Protect nav naming, anchor destinations, current state, list structure, and native link semantics from conflicting globals.
      - [x] 3.1.2.3 Subtask - Forward unrelated documented anchor, ARIA, data, Phoenix, and Datastar globals without accepting arbitrary component roles.
      - [x] 3.1.2.4 Subtask - Reject blank landmark names, destinations, duplicate or unstable keys, unsupported current values, dynamic atoms, and role overstatement.

  - [x] 3.2 Section - Responsive presentation and public guidance.

    This section adds shadcn-style presentation that remains readable and
    navigable without hover, animation, anchor positioning, or JavaScript.

    - [x] 3.2.1 Task - Add responsive navigation styles and honest indicators.

      Visual focus and current location must remain clear across input methods,
      themes, and fallback environments.

      - [x] 3.2.1.1 Subtask - Add closed horizontal, vertical, and wrapping layout values mapped to complete prefixed classes.
      - [x] 3.2.1.2 Subtask - Style links, focus-visible state, current location, long labels, and overflow with semantic tokens while avoiding a false disabled-anchor presentation.
      - [x] 3.2.1.3 Subtask - Keep anchor-positioned or animated decoration optional and ensure text, shape, or native current state remains when decoration is absent.
      - [x] 3.2.1.4 Subtask - Verify light, dark, narrow, wide, zoom, forced-colors, reduced-motion, RTL, long translated labels, and mixed BulmaUI pages.

    - [x] 3.2.2 Task - Publish destination and ownership documentation.

      Consumers should understand why this component is navigation rather than a
      menu, tab group, command bar, or route-aware application shell.

      - [x] 3.2.2.1 Subtask - Document items, keys, destinations, current values, layout, slots, protected globals, and HEEX examples.
      - [x] 3.2.2.2 Subtask - Explain landmark naming, native link keys, external-link and destination safety, authorization, visibility, current-route, and navigation-outcome ownership.
      - [x] 3.2.2.3 Subtask - Contrast Navigation Menu with buttons, Radio Panels, true tabs, menus, and client routers using concrete application examples.
      - [x] 3.2.2.4 Subtask - Add pinned upstream component and CSS provenance with local semantic and fallback changes.

  - [ ] 3.3 Section - Phase 3 Integration Tests.

    This section verifies destination navigation across semantic rendering,
    keyboard use, responsive CSS, package boundaries, and existing components.

    - [ ] 3.3.1 Task - Verify navigation rendering and ownership boundaries.

      Tests should prove every public state and prevent hidden routing or custom
      widget semantics from entering the package.

      - [ ] 3.3.1.1 Subtask - Test landmark naming, list structure, destinations, escaped and trusted labels, current values, layouts, caller globals, and invalid inputs.
      - [ ] 3.3.1.2 Subtask - Test repeated rendering, stable key handling, atom count, no inferred current route, and protected semantics.
      - [ ] 3.3.1.3 Subtask - Audit markup and source for menu, menubar, menuitem, tab, command, roving tabindex, key handlers, request access, authorization, and client-router behavior.
      - [ ] 3.3.1.4 Subtask - Compose Navigation Menu with Button, Badge, Separator, and Scroll Area and verify every child retains its original semantics.

    - [ ] 3.3.2 Task - Verify native browser operation and release integration.

      Browser and release checks should cover real link behavior and styling
      fallbacks rather than incidental wrapper structure.

      - [ ] 3.3.2.1 Subtask - Browser-test Tab and Shift+Tab order, Enter activation, context-menu and target behavior, fragment destinations, focus visibility, and current-location exposure.
      - [ ] 3.3.2.2 Subtask - Test narrow wrapping, overflow, zoom, forced colors, reduced motion, light/dark themes, RTL, no CSS, and no script.
      - [ ] 3.3.2.3 Subtask - Run locked asset checks, package precommit, ExDoc, provenance validation, archive exclusion, and coexistence audits.
      - [ ] 3.3.2.4 Subtask - Run `mix spec.next --base main`, `mix spec.check --base main`, and `git diff --check` and reconcile every Phase 3 requirement.
