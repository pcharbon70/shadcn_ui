# Phase 3 - Drawer Foundations

Back to wave: [README](./README.md)

- [ ] 3 Phase - Publish Drawer as a bounded logical-edge presentation of native
  modal dialog semantics with resilient long-content scrolling.

  This phase reuses Dialog modality and dismissal instead of inventing a second
  overlay widget, while adding responsive edge placement and safe internal
  scrolling appropriate for dense server-rendered application surfaces.

  - [x] 3.1 Section - Drawer semantics and logical-edge presentation.

    This section builds the Drawer API and preserves the full Dialog contract
    beneath closed start, end, and bottom visual placements.

    - [x] 3.1.1 Task - Implement the native Drawer structure.

      Drawer should remain recognizably a modal dialog to browsers and assistive
      technology regardless of which edge supplies its visual presentation.

      - [x] 3.1.1.1 Subtask - Add a defining Overlays.Drawer module with required ID, trigger, title or accessible label, trusted body, explicit close, and optional description, header, and footer regions.
      - [x] 3.1.1.2 Subtask - Render native show-modal invocation, dialog relationships, closedby policy, initial-focus target, explicit exit, and caller content order through the shared overlay contract.
      - [x] 3.1.1.3 Subtask - Add closed logical start, end, and bottom edge values plus small, default, and large bounded sizes using prefixed classes and RTL-aware logical properties.
      - [x] 3.1.1.4 Subtask - Protect native dialog and command semantics, identity, accessible relationships, dismissal, edge, and focus values while forwarding unrelated documented globals.

    - [x] 3.1.2 Task - Add responsive presentation and normal modal fallback.

      Edge animation and dimensions should enhance a complete native modal
      without turning viewport state into package-owned behavior.

      - [x] 3.1.2.1 Subtask - Add capability-gated entry and exit transitions, backdrop styling, safe-area padding, maximum viewport dimensions, and reduced-motion snap behavior.
      - [x] 3.1.2.2 Subtask - Preserve a bounded centered or full-width native dialog when logical edge, transform, transition, or advanced viewport units are unsupported.
      - [x] 3.1.2.3 Subtask - Verify start and end placement in LTR and RTL, bottom placement at narrow and wide widths, 200 percent zoom, forced colors, themes, and orientation changes.
      - [x] 3.1.2.4 Subtask - Document edge selection as rendered presentation, caller-owned responsive policy, replacement behavior, explicit fallback destination, and absence of drag gestures.

  - [ ] 3.2 Section - Long-content scrolling and composition.

    This section keeps Drawer titles, exits, actions, and body content reachable
    without scroll observation, custom scrollbar controls, or hidden focus.

    - [ ] 3.2.1 Task - Implement bounded native Drawer scrolling.

      Long bodies should use one predictable native overflow region while
      header and footer composition remains understandable in document order.

      - [ ] 3.2.1.1 Subtask - Add one flex-bounded native body scroll region with explicit focus policy, accessible naming guidance, overscroll containment, and visible scrollbar behavior.
      - [ ] 3.2.1.2 Subtask - Keep title and explicit close reachable, preserve optional footer actions after body content, and prevent package-created focus targets from hiding behind sticky regions.
      - [ ] 3.2.1.3 Subtask - Compose long translated copy, native forms, validation errors, Scroll Area, Accordion, separators, and action buttons without nested-form or landmark distortion.
      - [ ] 3.2.1.4 Subtask - Reject scroll measurement, restoration, infinite loading, custom scrollbars, viewport observers, drag-to-close, swipe gestures, and package-owned responsive state.

    - [ ] 3.2.2 Task - Document Drawer selection and ownership.

      Consumers should know when Drawer is appropriate and when a normal page,
      ordinary Dialog, or application-specific workflow is more honest.

      - [ ] 3.2.2.1 Subtask - Compare Drawer with Dialog, Popover, responsive page navigation, permanent sidebars, bottom sheets with gestures, and dedicated routes.
      - [ ] 3.2.2.2 Subtask - Document focus, dismissal, scroll, safe-area, edge, orientation, DOM replacement, form submission, and result ownership.
      - [ ] 3.2.2.3 Subtask - Provide deterministic filter, details, and compact-edit compositions with caller-owned data and no persistence or authorization.
      - [ ] 3.2.2.4 Subtask - Show CSS-disabled, no-transition, no-script, unsupported-invoker, long-content, coarse-pointer, and ordinary-route fallback states.

  - [ ] 3.3 Section - Phase 3 Integration Tests.

    This section verifies that Drawer adds only bounded presentation and native
    overflow while retaining Dialog semantics and package boundaries.

    - [ ] 3.3.1 Task - Verify Drawer rendering, focus, and dismissal.

      Tests should cover every logical edge and composition without confusing
      Drawer presentation with a separate interaction contract.

      - [ ] 3.3.1.1 Subtask - Test all slots, edges, sizes, dismissal values, identity, names, descriptions, autofocus, close control, caller globals, escaping, and invalid values.
      - [ ] 3.3.1.2 Subtask - Browser-test native show-modal, focus entry and containment, Escape, explicit close, allowed light dismiss, restoration, LTR and RTL edge placement, and reduced motion.
      - [ ] 3.3.1.3 Subtask - Test narrow and wide viewports, zoom, forced colors, safe areas, long scrolling, sticky regions, native forms, validation focus, nested Popover, replacement, and ordinary fallback route.
      - [ ] 3.3.1.4 Subtask - Assert native dialog semantics and absence of complementary or navigation landmark invention, drag handlers, pointer capture, observers, timers, focus scripts, and JavaScript.

    - [ ] 3.3.2 Task - Verify cross-component and release integration.

      Drawer should compose with prior milestones without changing their native
      relationships or leaking gallery fixtures into release contents.

      - [ ] 3.3.2.1 Subtask - Compose Drawer with Header, Section Header, Navigation Menu, Accordion, Scroll Area, Radio Panels, form controls, Button, Alert, and Card and assert original child semantics.
      - [ ] 3.3.2.2 Subtask - Run locked Chromium, Firefox, and WebKit behavior and fallback projects with CSS, transitions, and relevant capabilities deliberately disabled.
      - [ ] 3.3.2.3 Subtask - Run asset checks, package precommit, ExDoc, provenance mappings, source audits, and release archive allowlist checks.
      - [ ] 3.3.2.4 Subtask - Run `mix spec.check --base main`, `git diff --check`, and record Phase 3 semantics, scrolling, fallback, and package-boundary evidence.
