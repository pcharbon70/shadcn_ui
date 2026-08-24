# Phase 3 - Alert and Card Foundations

Back to wave: [README](./README.md)

- [ ] 3 Phase - Implement feedback and content surfaces with explicit semantics,
  composable regions, and caller-owned lifecycle and workflow behavior.

  This phase adds larger structural primitives while ensuring that color does
  not infer announcement urgency and visual grouping does not invent application
  meaning.

  - [x] 3.1 Section - Alert component.

    This section implements visible feedback with explicit announcement policy
    and optional caller-authored icon and action regions.

    - [x] 3.1.1 Task - Define the Alert public API and announcement semantics.

      Alert should separate visible presentation from live-region behavior so
      applications deliberately choose whether new content is announced.

      - [x] 3.1.1.1 Subtask - Declare default/destructive variant, none/polite/assertive announcement policy, optional title and description, icon and actions slots, class, and supported globals.
      - [x] 3.1.1.2 Subtask - Require at least one visible title or description and derive deterministic role/live attributes only from announcement policy.
      - [x] 3.1.1.3 Subtask - Protect announcement semantics from conflicting globals and keep destructive color independent from urgency.
      - [x] 3.1.1.4 Subtask - Document caller ownership of insertion timing, dismissal, retry, action outcomes, and lifecycle.

    - [x] 3.1.2 Task - Implement Alert presentation and tests.

      The alert layout should remain coherent with absent optional regions, long
      text, nested native controls, and both supported themes.

      - [x] 3.1.2.1 Subtask - Implement token-driven grid, icon, title, description, action, default, and destructive class mappings.
      - [x] 3.1.2.2 Subtask - Test every announcement policy, variant, region combination, escaped content, trusted slots, globals, and protected semantics.
      - [x] 3.1.2.3 Subtask - Test absent or blank visible content rejection and absence of dismissal or command behavior.
      - [x] 3.1.2.4 Subtask - Add provenance coverage for the adapted upstream Alert markup.

  - [x] 3.2 Section - Card component.

    This section implements a neutral content surface that preserves the meaning
    and behavior of caller-authored headings, links, forms, and controls.

    - [x] 3.2.1 Task - Define the Card composition API.

      Card should provide spacing and surface regions without becoming a record,
      navigation destination, form, or workflow abstraction.

      - [x] 3.2.1.1 Subtask - Declare optional header, title, description, actions, content, and footer regions with explicit required primary content policy.
      - [x] 3.2.1.2 Subtask - Keep caller headings and interactive elements unchanged and avoid card-wide implicit click behavior.
      - [x] 3.2.1.3 Subtask - Define deterministic region omission and ordering when optional slots are absent.
      - [x] 3.2.1.4 Subtask - Document application ownership of data, destination, selection, submission, loading, and command outcomes.

    - [x] 3.2.2 Task - Implement Card presentation and tests.

      The surface should use semantic tokens and remain stable with sparse,
      dense, long, and interactive caller content.

      - [x] 3.2.2.1 Subtask - Implement fixed surface, border, radius, shadow, header, content, actions, and footer class mappings.
      - [x] 3.2.2.2 Subtask - Test all region combinations, heading preservation, nested links/buttons/forms, escaping, globals, long content, and deterministic order.
      - [x] 3.2.2.3 Subtask - Assert Card adds no click handler, destination inference, selected state, workflow role, or application data model.
      - [x] 3.2.2.4 Subtask - Add provenance coverage for the adapted upstream Card markup.

  - [ ] 3.3 Section - Phase 3 Integration Tests.

    This section proves Alert and Card composition through public HEEX and the
    shared stylesheet without semantic or behavior leakage.

    - [ ] 3.3.1 Task - Run feedback-and-surface rendering integration tests.

      Representative compositions should combine both components with Phase 2
      primitives while retaining explicit ownership and accessibility state.

      - [ ] 3.3.1.1 Subtask - Render default and destructive alerts inside sparse and dense cards with caller Button and Badge content.
      - [ ] 3.3.1.2 Subtask - Assert announcement policy, headings, slot order, nested native semantics, globals, escaping, and application-boundary text.
      - [ ] 3.3.1.3 Subtask - Audit both modules for event handling, implicit workflows, arbitrary utilities, and raw HTML.

    - [ ] 3.3.2 Task - Run feedback-and-surface browser and asset integration tests.

      Browser evidence should cover announcements, focusable nested actions,
      themes, content stress, and isolated styles.

      - [ ] 3.3.2.1 Subtask - Exercise light/dark rendering, keyboard focus through card actions, long descriptions, narrow widths, zoom, forced colors, and reduced motion.
      - [ ] 3.3.2.2 Subtask - Rebuild the stylesheet and verify all Alert and Card classes and tokens are present and deterministic.
      - [ ] 3.3.2.3 Subtask - Run `mix precommit`, the Phase 3 integration suite, `mix spec.check --base main`, and `git diff --check`.
