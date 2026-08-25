# Phase 2 - Dialog And Alert Dialog Foundations

Back to wave: [README](./README.md)

- [ ] 2 Phase - Publish native modal Dialog and consequential Alert Dialog with
  explicit accessible relationships, focus intent, dismissal, and ownership.

  This phase relies on the accepted native command capability instead of an
  ARIA imitation or focus-trap runtime and keeps consequential confirmation
  distinct from ordinary modal content.

  - [x] 2.1 Section - Native Dialog structure and modal behavior.

    This section implements the general modal surface, its invoker, explicit
    exit, names, descriptions, initial-focus intent, and closed dismissal policy.

    - [x] 2.1.1 Task - Implement deterministic Dialog rendering and invocation.

      Dialog should emit one complete native modal relationship while preserving
      trusted caller body, forms, controls, and application attributes.

      - [x] 2.1.1.1 Subtask - Add a defining Overlays.Dialog module with required ID, trigger, title or accessible label, trusted body, and explicit close content.
      - [x] 2.1.1.2 Subtask - Render one native show-modal button, commandfor relationship, initially closed dialog, deterministic title and description relationships, and visible close control.
      - [x] 2.1.1.3 Subtask - Add closed size, alignment, density, and none, closerequest, or any dismissal values mapped to complete prefixed classes and native closedby values.
      - [x] 2.1.1.4 Subtask - Protect dialog element, modal command, IDs, names, descriptions, closedby, open state, and exit relationships while forwarding unrelated documented globals.

    - [x] 2.1.2 Task - Implement focus, dismissal, and replacement guidance.

      Native modal behavior should remain authoritative while callers can state
      deliberate initial focus and understand what server replacement changes.

      - [x] 2.1.2.1 Subtask - Add explicit stable initial-focus selection and native autofocus placement without adding tabindex to the dialog or a package focus manager.
      - [x] 2.1.2.2 Subtask - Verify Tab containment, Shift+Tab, Escape, explicit close, allowed light dismiss, prevented dismissal, inert background, and restoration to the invoker.
      - [x] 2.1.2.3 Subtask - Document browser-local open state, close requests, form method dialog behavior, caller event attributes, patch avoidance, replacement loss, and reinvocation ownership.
      - [x] 2.1.2.4 Subtask - Add long title, translated content, nested native form, nested Popover, narrow viewport, zoom, forced-colors, reduced-motion, light/dark, RTL, and ordinary fallback fixtures.

  - [x] 2.2 Section - Consequential Alert Dialog contract.

    This section defines confirmation markup and least-destructive initial focus
    without performing, authorizing, or reporting the consequential operation.

    - [x] 2.2.1 Task - Implement Alert Dialog semantics and action regions.

      Alert Dialog should make consequence, cancellation, and caller action
      unmistakable while retaining native modal mechanics.

      - [x] 2.2.1.1 Subtask - Add a defining Overlays.AlertDialog module with required ID, trigger, title, consequential description, cancel content, action content, and optional supporting body.
      - [x] 2.2.1.2 Subtask - Render native dialog with alertdialog semantics, closerequest dismissal, deterministic relationships, explicit cancel command, and least-destructive cancel autofocus.
      - [x] 2.2.1.3 Subtask - Preserve caller-owned native action button or form semantics, types, names, values, CSRF fields, disabled and pending snapshots, and transport attributes.
      - [x] 2.2.1.4 Subtask - Protect consequence semantics and reject light-dismiss defaults, missing exits, ambiguous initial focus, role contradiction, and package-owned outcome attributes.

    - [x] 2.2.2 Task - Document confirmation and application ownership boundaries.

      Consumers should understand that modal presentation never grants authority
      or turns a browser-side choice into a completed server operation.

      - [x] 2.2.2.1 Subtask - Document cancellation, Escape, close request, initial focus, validation errors, server rejection, pending state, retry, and result announcement ownership.
      - [x] 2.2.2.2 Subtask - Compare ordinary Dialog, Alert Dialog, destructive Button styling, browser confirm, and application-specific multi-step workflows.
      - [x] 2.2.2.3 Subtask - Demonstrate safe delete, discard, and irreversible-action snapshots with inert deterministic caller fixtures and no domain operation.
      - [x] 2.2.2.4 Subtask - Add unsupported-invoker ordinary destinations and no-transition, CSS-disabled, no-script, long-content, and replacement evidence.

  - [ ] 2.3 Section - Phase 2 Integration Tests.

    This section verifies both modal contracts across rendering, browser-native
    interaction, accessibility, fallback, and application boundaries.

    - [ ] 2.3.1 Task - Verify Dialog rendering and browser behavior.

      Tests should prove that the native platform, not ShadcnUI script, supplies
      modality, focus containment, dismissal, and restoration.

      - [ ] 2.3.1.1 Subtask - Test all Dialog slots, size and dismissal values, identity, descriptions, autofocus, explicit exit, caller globals, escaping, stable rerenders, and invalid input.
      - [ ] 2.3.1.2 Subtask - Browser-test show-modal invocation, top layer, background inertness, Tab loop, Escape, explicit close, allowed backdrop dismissal, focus restoration, and form method dialog.
      - [ ] 2.3.1.3 Subtask - Test nested Popover, rejected nested modal, long native scroll, zoom, narrow viewport, forced colors, reduced motion, RTL, themes, replacement, and fallback destination.
      - [ ] 2.3.1.4 Subtask - Audit source for event listeners, focus traps, timers, command execution, authorization, routing, persistence, dynamic atoms, and JavaScript.

    - [ ] 2.3.2 Task - Verify Alert Dialog consequence boundaries.

      Automated evidence should distinguish alertdialog semantics and least-
      destructive focus from visual destructive styling alone.

      - [ ] 2.3.2.1 Subtask - Test required title, description, cancel and action regions, alertdialog role, closerequest policy, cancel autofocus, command relationships, and protected globals.
      - [ ] 2.3.2.2 Subtask - Browser-test cancel, Escape, consequential native action, focus restoration, rejected light dismiss, server-error snapshot, and replacement behavior.
      - [ ] 2.3.2.3 Subtask - Assert absence of automatic submission, authorization, persistence, success claims, focus scripting, alert urgency inferred from color, and browser confirm calls.
      - [ ] 2.3.2.4 Subtask - Run asset checks, package precommit, cross-engine Dialog suites, ExDoc, provenance and archive audits, `mix spec.check --base main`, and `git diff --check`.
