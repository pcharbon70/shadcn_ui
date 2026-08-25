# Phase 4 - Native And Enhanced Select Foundations

Back to wave: [README](./README.md)

- [x] 4 Phase - Deliver ordinary native selection and a separately opt-in,
  capability-gated customizable-select presentation over the same submitted value.

  This phase makes Native Select the dependable default and proves Enhanced
  Select is only a progressive CSS presentation. Both APIs remain one native
  control with identical form, option, keyboard, and accessibility semantics.

  - [x] 4.1 Section - Shared option data and Native Select foundation.

    This section validates caller-owned option structures and renders the classic
    select contract used as the fallback and comparison baseline.

    - [x] 4.1.1 Task - Normalize safe option and optgroup data.

      The option boundary should be expressive enough for ordinary forms without
      accepting callbacks, arbitrary HTML, or executable dynamic structures.

      - [x] 4.1.1.1 Subtask - Define validated caller option maps with stable keys, escaped labels, scalar values, and optional disabled state.
      - [x] 4.1.1.2 Subtask - Define validated optgroup maps with escaped labels and nested options while rejecting duplicate keys and malformed nesting.
      - [x] 4.1.1.3 Subtask - Normalize selected scalar or list values without request-derived atoms, domain parsing, or label-based identity.
      - [x] 4.1.1.4 Subtask - Keep prompts as explicit caller-defined options rather than package-owned placeholder or validation policy.

    - [x] 4.1.2 Task - Implement Native Select.

      Native Select should expose the browser's classic picker, keyboard, and
      submission behavior with the shared field relationships.

      - [x] 4.1.2.1 Subtask - Render one native select with explicit and FormField identity, selected values, errors, help, required, disabled, and form association.
      - [x] 4.1.2.2 Subtask - Support single selection with one scalar value and multiple selection with native `multiple`, a list value, and normalized `[]` name.
      - [x] 4.1.2.3 Subtask - Render escaped option and optgroup markup with native option-local disabled state and no combobox or listbox roles.
      - [x] 4.1.2.4 Subtask - Add closed size, invalid, pending, and theme presentation without hiding the platform picker or replacing native focus.

  - [x] 4.2 Section - Enhanced Select capability boundary.

    This section adds a richer presentation only when the browser proves the
    complete platform capability, leaving classic select CSS as the default path.

    - [x] 4.2.1 Task - Implement Enhanced Select over one native control.

      The enhanced API should deliberately opt into supported customizable-select
      structure while preserving Native Select's identity and option contract.

      - [x] 4.2.1.1 Subtask - Reuse Native Select normalization, options, selected values, name, help, errors, disabled state, and submission semantics.
      - [x] 4.2.1.2 Subtask - Render only standards-based enhancement structure that unsupported parsers safely ignore while retaining all option text.
      - [x] 4.2.1.3 Subtask - Render no mirrored hidden control, custom listbox, popup state, event handler, focus manager, filter, fetcher, or polyfill.
      - [x] 4.2.1.4 Subtask - Keep Native Select as a separate recommended public API and document migration between the two presentations.

    - [x] 4.2.2 Task - Implement and audit capability-gated CSS.

      Enhancement styling must never escape its feature gate or become required
      for visibility, operation, focus, or submission.

      - [x] 4.2.2.1 Subtask - Author classic visible select styling outside feature queries as the universal fallback.
      - [x] 4.2.2.2 Subtask - Gate every customizable-select selector and property behind queries for the complete required capability set.
      - [x] 4.2.2.3 Subtask - Style picker, selected content, options, focus, checked, disabled, invalid, themes, and forced colors without replacing native state.
      - [x] 4.2.2.4 Subtask - Add a CSS audit that fails for enhancement selectors outside the gate, hidden fallback controls, or duplicated value mechanisms.

  - [x] 4.3 Section - Phase 4 Integration Tests.

    This section proves Native and Enhanced Select share one value contract and
    that unsupported browsers receive an exact usable classic fallback.

    - [x] 4.3.1 Task - Verify option rendering and native submission.

      Component and Phoenix fixtures should cover every supported option shape,
      selection mode, state, and relationship without incidental widget claims.

      - [x] 4.3.1.1 Subtask - Test option and optgroup escaping, stable keys, selected and disabled states, prompts, invalid data rejection, and atom-count stability.
      - [x] 4.3.1.2 Subtask - Test single and multiple FormField and explicit names, values, constraints, errors, globals, and native submitted parameters.
      - [x] 4.3.1.3 Subtask - Assert one visible select, no hidden mirror, no custom roles, no scripts, and no package-owned option state in both APIs.

    - [x] 4.3.2 Task - Verify enhanced and fallback browser paths.

      Browser evidence should distinguish actual platform enhancement from the
      classic path while asserting identical semantics and received values.

      - [x] 4.3.2.1 Subtask - Exercise native keyboard, label focus, picker activation, selection, reset, required validation, and submission for both APIs.
      - [x] 4.3.2.2 Subtask - Verify enhanced presentation only in a supporting engine and classic visible operation when capabilities or CSS are unavailable.
      - [x] 4.3.2.3 Subtask - Compare names, selected values, received parameters, labels, errors, tab order, zoom, themes, and forced colors across both paths.
      - [x] 4.3.2.4 Subtask - Run CSS capability audits, `mix precommit`, `mix spec.check --base main`, and `git diff --check`.
