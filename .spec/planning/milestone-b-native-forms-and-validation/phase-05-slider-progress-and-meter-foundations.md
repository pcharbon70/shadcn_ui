# Phase 5 - Slider, Progress, And Meter Foundations

Back to wave: [README](./README.md)

- [x] 5 Phase - Deliver native range input and distinct task-progress and scalar-
  measurement presentations without adding polling, estimation, or synchronized state.

  This phase completes the Milestone B native-control catalogue. Slider remains a
  submitted range input, while Progress and Meter preserve their different native
  meanings as caller-owned render snapshots.

  - [x] 5.1 Section - Slider foundation.

    This section styles native range input while retaining its platform keyboard,
    focus, value, constraint, and form behavior.

    - [x] 5.1.1 Task - Implement Slider normalization and semantics.

      Slider should reuse the field contract and expose only values the native
      range element can represent honestly.

      - [x] 5.1.1.1 Subtask - Render one native `input type="range"` with explicit and FormField ID, name, value, errors, and caller-owned pending state.
      - [x] 5.1.1.2 Subtask - Support native min, max, step, disabled, required label, form association, and optional deterministic value-description relationship.
      - [x] 5.1.1.3 Subtask - Protect type, identity, constraints, disabled, invalid, and accessibility relationships from conflicting globals.
      - [x] 5.1.1.4 Subtask - Add no drag state, event handler, numeric domain parser, output synchronization, hidden mirror, or value announcement behavior.

    - [x] 5.1.2 Task - Implement resilient Slider presentation.

      Track, range, thumb, and focus styling should remain understandable across
      themes and system accessibility modes without obscuring the native input.

      - [x] 5.1.2.1 Subtask - Add prefixed track and thumb styles using semantic foreground, input, accent, invalid, and ring tokens.
      - [x] 5.1.2.2 Subtask - Preserve visible native focus and distinguish disabled, invalid, and current-value presentation without color alone.
      - [x] 5.1.2.3 Subtask - Add engine-specific pseudo-element rules only where necessary and audit that the input remains operable without them.
      - [x] 5.1.2.4 Subtask - Verify adequate pointer target, narrow layouts, zoom, forced colors, and left-to-right and right-to-left document contexts.

  - [x] 5.2 Section - Progress and Meter semantic foundations.

    This section makes the meaning difference between task completion and scalar
    measurement explicit in APIs, markup, styling, and documentation.

    - [x] 5.2.1 Task - Implement native Progress.

      Progress should render caller-supplied task completion without estimating,
      polling, or announcing lifecycle changes.

      - [x] 5.2.1.1 Subtask - Render a native progress element with required accessible name and optional visible label and description.
      - [x] 5.2.1.2 Subtask - Support determinate value and max or native indeterminate state by omitting value, with clear validation of contradictory inputs.
      - [x] 5.2.1.3 Subtask - Add closed size and semantic presentation while preserving the native value contract and reduced-motion floor.
      - [x] 5.2.1.4 Subtask - Add no polling, estimation, completion event, announcement, request lifecycle, or form-submission claim.

    - [x] 5.2.2 Task - Implement native Meter.

      Meter should represent a measurement in a known range and never be presented
      as task completion merely because its visual shape is similar.

      - [x] 5.2.2.1 Subtask - Render a native meter element with required value and accessible name plus optional visible label and description.
      - [x] 5.2.2.2 Subtask - Support and validate native min, max, low, high, and optimum inputs without interpreting their domain meaning.
      - [x] 5.2.2.3 Subtask - Add closed size and semantic zone presentation that remains understandable in themes and forced colors.
      - [x] 5.2.2.4 Subtask - Add no task-progress language, polling, measurement, threshold decisions, announcement, or package-owned lifecycle.

  - [x] 5.3 Section - Phase 5 Integration Tests.

    This section proves native range keyboard and submission behavior and the
    semantic distinction between Progress and Meter under real rendering stress.

    - [x] 5.3.1 Task - Verify Slider behavior and submitted values.

      Tests should cover the native value and constraint surface in both field
      modes while ensuring styling never creates a second slider model.

      - [x] 5.3.1.1 Subtask - Test explicit and FormField identity, value, min, max, step, disabled, invalid, pending, help, errors, and globals.
      - [x] 5.3.1.2 Subtask - Browser-test arrow, Page Up, Page Down, Home, and End keys where the platform defines them, plus focus, pointer use, reset, and submission.
      - [x] 5.3.1.3 Subtask - Verify light/dark themes, narrow width, zoom, forced colors, reduced motion, and operation without custom pseudo-element CSS.

    - [x] 5.3.2 Task - Verify Progress and Meter meanings and boundaries.

      Rendering and accessibility tests should assert native elements and value
      rules rather than relying only on visually similar bars.

      - [x] 5.3.2.1 Subtask - Test determinate and indeterminate Progress, required accessible naming, bounds, invalid combinations, and escaped descriptions.
      - [x] 5.3.2.2 Subtask - Test Meter range and threshold inputs, accessible naming, invalid combinations, semantic zones, and escaped descriptions.
      - [x] 5.3.2.3 Subtask - Assert Progress never renders Meter semantics, Meter never claims task completion, and neither adds events, polling, or live regions.
      - [x] 5.3.2.4 Subtask - Compose Slider, Progress, Meter, Field fragments, and Card in one fixture and run `mix precommit`, `mix spec.check --base main`, and `git diff --check`.
