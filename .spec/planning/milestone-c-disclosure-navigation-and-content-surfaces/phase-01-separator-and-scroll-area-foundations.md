# Phase 1 - Separator And Scroll Area Foundations

Back to wave: [README](./README.md)

- [ ] 1 Phase - Establish the structural separation and native overflow
  primitives used by later Milestone C page compositions.

  This phase begins with the smallest content-surface contracts. Separator makes
  structural meaning explicit, while Scroll Area adds bounded native overflow
  without introducing viewport observation, custom scroll controls, or state.

  - [x] 1.1 Section - Separator semantics and styling.

    This section delivers a small primitive whose HTML meaning is selected
    explicitly and whose presentation remains isolated and theme-aware.

    - [x] 1.1.1 Task - Implement semantic and decorative Separator modes.

      The public API should prevent a visual line from silently gaining or
      losing document structure.

      - [x] 1.1.1.1 Subtask - Add a defining Content.Separator module and import it through `use ShadcnUI`.
      - [x] 1.1.1.2 Subtask - Render native `hr` in semantic mode and an `aria-hidden` nonsemantic element in explicit decorative mode.
      - [x] 1.1.1.3 Subtask - Add closed horizontal and vertical orientation values with complete static prefixed classes.
      - [x] 1.1.1.4 Subtask - Protect native meaning and hidden treatment while forwarding unrelated documented caller globals and classes.

    - [x] 1.1.2 Task - Add Separator visual and provenance contracts.

      Styling should consume existing semantic tokens and remain visible without
      relying on a theme-specific hard-coded color.

      - [x] 1.1.2.1 Subtask - Add isolated border and sizing utilities for both orientations with light and dark token coverage.
      - [x] 1.1.2.2 Subtask - Verify narrow layout, zoom, forced-colors, and mixed BulmaUI coexistence behavior.
      - [x] 1.1.2.3 Subtask - Record upstream component and CSS mappings with the pinned source revision and local semantic changes.
      - [x] 1.1.2.4 Subtask - Document semantic versus decorative choice, API values, HEEX examples, and application ownership.

  - [ ] 1.2 Section - Native Scroll Area contract and fallback.

    This section adds bounded overflow while keeping native browser scrolling,
    focus behavior, and content ownership authoritative.

    - [ ] 1.2.1 Task - Implement native overflow and explicit focus policy.

      One container should expose closed layout choices without measuring its
      children or creating a custom scrollbar widget.

      - [ ] 1.2.1.1 Subtask - Add a defining Content.ScrollArea module with required content and closed axis, size, and edge-affordance values.
      - [ ] 1.2.1.2 Subtask - Render one native overflow container and map closed sizing values to statically discoverable prefixed classes.
      - [ ] 1.2.1.3 Subtask - Keep the container out of Tab order by default and require a nonblank accessible name or relationship for explicit focusable mode.
      - [ ] 1.2.1.4 Subtask - Protect focus semantics while preserving unrelated caller classes, IDs, native attributes, and behavior-framework globals.

    - [ ] 1.2.2 Task - Add progressive edge presentation and resilience.

      Optional edge cues should improve scanning without becoming the only way
      users discover overflow or requiring scroll-position observation.

      - [ ] 1.2.2.1 Subtask - Add native horizontal, vertical, and both-axis overflow styling with visible focus treatment.
      - [ ] 1.2.2.2 Subtask - Add decorative edge affordances that do not intercept input and disappear harmlessly without enhancement CSS.
      - [ ] 1.2.2.3 Subtask - Verify pointer, touch, wheel, keyboard, fragment, narrow, zoom, forced-colors, and no-CSS content access.
      - [ ] 1.2.2.4 Subtask - Document sizing, focus naming, application-owned restoration and loading, exact fallback, and provenance.

  - [ ] 1.3 Section - Phase 1 Integration Tests.

    This section verifies the first content primitives together as independently
    distributable, semantic, native-first HEEX components.

    - [ ] 1.3.1 Task - Verify component rendering and shared contracts.

      Package tests should prove closed values, protected semantics, safe content,
      deterministic output, and absence of application behavior.

      - [ ] 1.3.1.1 Subtask - Test both Separator modes, orientations, globals, escaping boundaries, and invalid public values.
      - [ ] 1.3.1.2 Subtask - Test Scroll Area axes, sizes, focus-name requirements, content slots, globals, and invalid public values.
      - [ ] 1.3.1.3 Subtask - Audit component source for viewport observers, scroll handlers, custom controls, dynamic atoms, application dependencies, and package JavaScript.
      - [ ] 1.3.1.4 Subtask - Add aggregate content-surface tests covering repeated renders, theme scopes, and BulmaUI coexistence.

    - [ ] 1.3.2 Task - Verify CSS, package, and specification integration.

      The phase should leave reproducible assets and current documentation ready
      for later Accordion and navigation composition.

      - [ ] 1.3.2.1 Subtask - Run locked asset build and byte comparison, prefix/reset audits, capability/fallback audits, and provenance validation.
      - [ ] 1.3.2.2 Subtask - Run package precommit, focused no-CSS and forced-colors fixtures, ExDoc build, archive exclusion checks, and `git diff --check`.
      - [ ] 1.3.2.3 Subtask - Run `mix spec.next --base main`, `mix spec.check --base main`, and confirm Phase 1 evidence covers every active requirement.
      - [ ] 1.3.2.4 Subtask - Confirm no gallery routes or application behavior were added ahead of their planned phase.
