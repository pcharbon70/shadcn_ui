# Phase 3 - Drawer Foundations

Back to wave: [README](./README.md)

- [x] 3 Phase - Publish Drawer as a bounded logical-edge presentation of native
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

  - [x] 3.2 Section - Long-content scrolling and composition.

    This section keeps Drawer titles, exits, actions, and body content reachable
    without scroll observation, custom scrollbar controls, or hidden focus.

    - [x] 3.2.1 Task - Implement bounded native Drawer scrolling.

      Long bodies should use one predictable native overflow region while
      header and footer composition remains understandable in document order.

      - [x] 3.2.1.1 Subtask - Add one flex-bounded native body scroll region with explicit focus policy, accessible naming guidance, overscroll containment, and visible scrollbar behavior.
      - [x] 3.2.1.2 Subtask - Keep title and explicit close reachable, preserve optional footer actions after body content, and prevent package-created focus targets from hiding behind sticky regions.
      - [x] 3.2.1.3 Subtask - Compose long translated copy, native forms, validation errors, Scroll Area, Accordion, separators, and action buttons without nested-form or landmark distortion.
      - [x] 3.2.1.4 Subtask - Reject scroll measurement, restoration, infinite loading, custom scrollbars, viewport observers, drag-to-close, swipe gestures, and package-owned responsive state.

    - [x] 3.2.2 Task - Document Drawer selection and ownership.

      Consumers should know when Drawer is appropriate and when a normal page,
      ordinary Dialog, or application-specific workflow is more honest.

      - [x] 3.2.2.1 Subtask - Compare Drawer with Dialog, Popover, responsive page navigation, permanent sidebars, bottom sheets with gestures, and dedicated routes.
      - [x] 3.2.2.2 Subtask - Document focus, dismissal, scroll, safe-area, edge, orientation, DOM replacement, form submission, and result ownership.
      - [x] 3.2.2.3 Subtask - Provide deterministic filter, details, and compact-edit compositions with caller-owned data and no persistence or authorization.
      - [x] 3.2.2.4 Subtask - Show CSS-disabled, no-transition, no-script, unsupported-invoker, long-content, coarse-pointer, and ordinary-route fallback states.

  - [x] 3.3 Section - Phase 3 Integration Tests.

    This section verifies that Drawer adds only bounded presentation and native
    overflow while retaining Dialog semantics and package boundaries.

    - [x] 3.3.1 Task - Verify Drawer rendering, focus, and dismissal.

      Tests should cover every logical edge and composition without confusing
      Drawer presentation with a separate interaction contract.

      - [x] 3.3.1.1 Subtask - Test all slots, edges, sizes, dismissal values, identity, names, descriptions, autofocus, close control, caller globals, escaping, and invalid values.
      - [x] 3.3.1.2 Subtask - Browser-test native show-modal, focus entry and containment, Escape, explicit close, allowed light dismiss, restoration, LTR and RTL edge placement, and reduced motion.
      - [x] 3.3.1.3 Subtask - Test narrow and wide viewports, zoom, forced colors, safe areas, long scrolling, sticky regions, native forms, validation focus, nested Popover, replacement, and ordinary fallback route.
      - [x] 3.3.1.4 Subtask - Assert native dialog semantics and absence of complementary or navigation landmark invention, drag handlers, pointer capture, observers, timers, focus scripts, and JavaScript.

    - [x] 3.3.2 Task - Verify cross-component and release integration.

      Drawer should compose with prior milestones without changing their native
      relationships or leaking gallery fixtures into release contents.

      - [x] 3.3.2.1 Subtask - Compose Drawer with Header, Section Header, Navigation Menu, Accordion, Scroll Area, Radio Panels, form controls, Button, Alert, and Card and assert original child semantics.
      - [x] 3.3.2.2 Subtask - Run locked Chromium, Firefox, and WebKit behavior and fallback projects with CSS, transitions, and relevant capabilities deliberately disabled.
      - [x] 3.3.2.3 Subtask - Run asset checks, package precommit, ExDoc, provenance mappings, source audits, and release archive allowlist checks.
      - [x] 3.3.2.4 Subtask - Run `mix spec.check --base main`, `git diff --check`, and record Phase 3 semantics, scrolling, fallback, and package-boundary evidence.

## Phase 3 verification evidence

- Package `mix precommit`: 291 tests passed.
  The existing Select atom-count assertion flaked once after dependency
  recompilation; a clean rerun passed without changing unrelated form code.
- Drawer: 30 browser checks passed across locked Chromium, Firefox, and WebKit;
  prior overlay foundation and Dialog suites: 21 + 21 checks passed.
- Actual component HEEx generates the deterministic Drawer fixture; CI rejects
  stale output. Tests cover edge/size/direction, zoom, focus, native forms and
  validation, long scrolling, one nested Popover, replacement, touch activation,
  disabled CSS/invokers/logical layout/transitions, and ordinary destinations.
- `npm run assets:check`, `mix docs`, `mix hex.build`, actual archive allowlist
  audit (46 entries), deterministic gallery export, and `git diff --check` pass.
- The locked Windows WebKit build lacks overscroll containment; native scrolling
  remains usable and the capability-based fallback is explicitly tested.
- `mix spec.check --base main` was run: its nested command runner still fails
  four command records on the existing local Erlang/OTP/rebar mismatch. Direct
  commands pass. Remaining warnings concern future-phase targets and historical
  coverage references; this record does not claim a clean SpecLed run.
- No runtime, consumer-specific target, application operation, or gallery page
  was added. Overlay gallery delivery remains Phase 6.
