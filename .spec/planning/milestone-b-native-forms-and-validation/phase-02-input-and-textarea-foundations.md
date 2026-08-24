# Phase 2 - Input And Textarea Foundations

Back to wave: [README](./README.md)

- [x] 2 Phase - Deliver the common text-entry controls on the shared native form
  contract with documented constraints and safe progressive sizing.

  This phase implements Input and Textarea for ordinary CRUD workflows. Both
  controls preserve native value and validation behavior while keeping parsing,
  submission, and request state outside the package.

  - [x] 2.1 Section - Text-like Input foundation.

    This section adds one closed Input API whose native types and constraints are
    explicit enough to remain statically styled and semantically testable.

    - [x] 2.1.1 Task - Implement native Input rendering and normalization.

      Input should reuse the shared field contract instead of recreating type,
      identity, error, or relationship rules.

      - [x] 2.1.1.1 Subtask - Support `text`, `email`, `password`, `search`, `tel`, `url`, `number`, `date`, `datetime-local`, `month`, `week`, and `time` through a closed mapping.
      - [x] 2.1.1.2 Subtask - Resolve FormField and explicit ID, name, value, and errors through the shared normalizer.
      - [x] 2.1.1.3 Subtask - Pass documented autocomplete, inputmode, placeholder, minlength, maxlength, pattern, min, max, step, required, disabled, readonly, and form attributes where valid.
      - [x] 2.1.1.4 Subtask - Reject checkbox, radio, range, file, color, hidden, arbitrary type strings, raw HTML, and structural replacement through Input.

    - [x] 2.1.2 Task - Implement Input presentation and protected semantics.

      Shadcn-style visuals should make state apparent without changing the native
      element or claiming application validation has occurred.

      - [x] 2.1.2.1 Subtask - Add closed size and visual-state classes using semantic input, invalid, foreground, and ring tokens.
      - [x] 2.1.2.2 Subtask - Preserve native disabled, readonly, required, autofill, focus-visible, and constraint-validation behavior.
      - [x] 2.1.2.3 Subtask - Add optional leading and trailing decorative or trusted HEEX regions without obscuring the label, value, focus ring, or pointer target.
      - [x] 2.1.2.4 Subtask - Keep pending presentation independent from disabled state, validation, value mutation, submission, and duplicate prevention.

  - [x] 2.2 Section - Textarea foundation and sizing fallback.

    This section adds multiline entry with escaped element content and a clearly
    separated native fallback and platform enhancement.

    - [x] 2.2.1 Task - Implement native Textarea rendering.

      Textarea should share Input's field relationships while respecting the
      distinct native rule that its value is element content.

      - [x] 2.2.1.1 Subtask - Resolve FormField and explicit identity, value, and errors through the shared normalizer.
      - [x] 2.2.1.2 Subtask - Render the normalized value as escaped textarea content rather than a conflicting `value` attribute.
      - [x] 2.2.1.3 Subtask - Support documented rows, cols, minlength, maxlength, placeholder, autocomplete, required, disabled, readonly, and form attributes.
      - [x] 2.2.1.4 Subtask - Add closed vertical, horizontal, both, and fixed resize policies without auto-grow script or measurement state.

    - [x] 2.2.2 Task - Implement progressive content sizing.

      Content sizing should improve capable browsers while leaving a stable
      fixed-size control everywhere else.

      - [x] 2.2.2.1 Subtask - Define a usable minimum-height and documented resize fallback outside every feature query.
      - [x] 2.2.2.2 Subtask - Apply `field-sizing: content` only inside a capability query and only for the explicit enhancement value.
      - [x] 2.2.2.3 Subtask - Verify long, empty, multiline, translated, and constrained values do not collapse, overflow essential content, or hide focus.
      - [x] 2.2.2.4 Subtask - Document the difference between native resize policy, content-sizing enhancement, and caller-owned dynamic behavior.

  - [x] 2.3 Section - Phase 2 Integration Tests.

    This section verifies common text entry through real field compositions and
    native form submission without relying on a component runtime.

    - [x] 2.3.1 Task - Verify Input and Textarea semantic contracts.

      Rendering tests should cover the complete closed API and shared
      relationship behavior in explicit and FormField modes.

      - [x] 2.3.1.1 Subtask - Test all supported Input types and reject excluded or unknown types without atom creation.
      - [x] 2.3.1.2 Subtask - Test Input and Textarea identity, value, errors, constraints, globals, required, disabled, readonly, invalid, and pending snapshots.
      - [x] 2.3.1.3 Subtask - Assert labels, help, repeated errors, caller descriptions, protected attributes, and escaped values remain deterministic.
      - [x] 2.3.1.4 Subtask - Audit rendered markup for absent parsing, reveal controls, counters, events, hooks, scripts, and hidden synchronized values.

    - [x] 2.3.2 Task - Verify native entry and fallback behavior.

      Browser and submission fixtures should prove that styled controls retain
      their platform behavior under stress and reduced enhancement.

      - [x] 2.3.2.1 Subtask - Submit realistic explicit and FormField Input and Textarea values through an ordinary Phoenix form fixture.
      - [x] 2.3.2.2 Subtask - Verify tab order, label focus, text entry, native constraints, zoom, forced colors, and light/dark focus visibility.
      - [x] 2.3.2.3 Subtask - Verify Textarea fixed sizing with enhancement disabled and content sizing only when capability support is present.
      - [x] 2.3.2.4 Subtask - Run `mix precommit`, `mix spec.check --base main`, and `git diff --check`.
