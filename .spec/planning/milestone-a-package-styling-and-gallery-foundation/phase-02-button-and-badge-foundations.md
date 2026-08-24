# Phase 2 - Button and Badge Foundations

Back to wave: [README](./README.md)

- [ ] 2 Phase - Implement the action and label primitives that establish the
  recognizable shadcn visual language over native HTML.

  This phase proves that the shared HEEX and CSS contracts can express closed
  component APIs without hiding native button behavior or turning passive labels
  into controls.

  - [ ] 2.1 Section - Button component.

    This section implements the native action primitive with explicit variants,
    sizes, content regions, and caller-owned activation.

    - [ ] 2.1.1 Task - Define the Button public API and semantic markup.

      Button should preserve native submission and disabled behavior while
      exposing only the shadcn-style choices the package can guarantee.

      - [ ] 2.1.1.1 Subtask - Declare required content, button/submit/reset type, default/secondary/destructive/outline/ghost/link variant, small/default/large/icon size, disabled, loading presentation, accessible label, class, and supported global attributes.
      - [ ] 2.1.1.2 Subtask - Add optional leading and trailing slots and prevent empty icon-only buttons by requiring a nonblank accessible label.
      - [ ] 2.1.1.3 Subtask - Render native `disabled` when requested and keep loading presentation separate from caller-owned duplicate-submission prevention.
      - [ ] 2.1.1.4 Subtask - Protect type, disabled state, and icon-only accessible naming from conflicting caller globals.

    - [ ] 2.1.2 Task - Implement Button presentation and tests.

      Fixed `sui`-prefixed class mappings should cover every public combination
      and use semantic tokens rather than theme-specific colors.

      - [ ] 2.1.2.1 Subtask - Implement base layout, focus, disabled, loading, six variant, and four size class mappings.
      - [ ] 2.1.2.2 Subtask - Test every type, variant, size, state, slot, caller class, global attribute, escaped label, and protected semantic outcome.
      - [ ] 2.1.2.3 Subtask - Test that Button emits no event handler, request, command authorization, state transition, or JavaScript dependency.
      - [ ] 2.1.2.4 Subtask - Add provenance coverage for the adapted upstream Button markup.

  - [ ] 2.2 Section - Badge component.

    This section implements a compact passive label whose visual variants never
    imply link, button, dismissal, or selection behavior.

    - [ ] 2.2.1 Task - Define the Badge public API and semantic markup.

      Badge should remain a native inline text container with required content
      and a deliberately small presentation vocabulary.

      - [ ] 2.2.1.1 Subtask - Declare required content, default/secondary/destructive/outline variant, class, and supported passive global attributes.
      - [ ] 2.2.1.2 Subtask - Render a span, reject destination and button attributes, and preserve caller text escaping.
      - [ ] 2.2.1.3 Subtask - Document that status lifecycle, selection, dismissal, and interactivity belong to surrounding application markup.

    - [ ] 2.2.2 Task - Implement Badge presentation and tests.

      Token-driven fixed classes should remain legible in both themes and under
      high-contrast and narrow-content conditions.

      - [ ] 2.2.2.1 Subtask - Implement base geometry and four fixed semantic-token variant mappings.
      - [ ] 2.2.2.2 Subtask - Test variants, long and escaped content, caller classes, globals, deterministic output, and absence of interactive semantics.
      - [ ] 2.2.2.3 Subtask - Add provenance coverage for the adapted upstream Badge markup.

  - [ ] 2.3 Section - Phase 2 Integration Tests.

    This section proves Button and Badge together through the public import and
    compiled stylesheet under representative consumer conditions.

    - [ ] 2.3.1 Task - Run action-and-label rendering integration tests.

      Integration fixtures should use only public ShadcnUI imports and verify
      semantic distinctions across the complete closed state matrix.

      - [ ] 2.3.1.1 Subtask - Compile a consumer fixture through `use ShadcnUI` and render every Button and Badge variant and size.
      - [ ] 2.3.1.2 Subtask - Assert native button types, disabled behavior, icon-only naming, passive Badge semantics, escaping, globals, and deterministic class order.
      - [ ] 2.3.1.3 Subtask - Audit the two modules for transport, event, random identity, arbitrary utility, and raw-HTML behavior.

    - [ ] 2.3.2 Task - Run action-and-label browser and asset integration tests.

      Browser evidence should prove focus, themes, motion preferences, and CSS
      isolation without adding a component runtime.

      - [ ] 2.3.2.1 Subtask - Exercise keyboard focus, disabled activation prevention, light/dark contrast, long labels, narrow layout, zoom, and forced colors.
      - [ ] 2.3.2.2 Subtask - Rebuild the stylesheet and prove all new classes are prefixed, present, deterministic, and token-driven.
      - [ ] 2.3.2.3 Subtask - Run `mix precommit`, the Phase 2 integration suite, `mix spec.check --base main`, and `git diff --check`.
