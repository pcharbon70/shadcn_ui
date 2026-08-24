# Phase 3 - Checkbox, Radio Group, And Switch Foundations

Back to wave: [README](./README.md)

- [ ] 3 Phase - Deliver native binary and exclusive-choice controls with Phoenix-
  compatible submitted values and one shared state model.

  This phase implements Checkbox, Radio Group, and Switch without recreating
  selection in generic elements. Its outcome is predictable native keyboard,
  label, grouping, and submission behavior under shadcn-style presentation.

  - [x] 3.1 Section - Checkbox value and relationship foundation.

    This section defines boolean and repeated-value checkbox modes explicitly so
    hidden sentinels never conflict with multi-value submissions.

    - [x] 3.1.1 Task - Implement native Checkbox normalization and values.

      Checkbox should derive checked state from normalized data while leaving the
      submitted parameter authoritative for the consuming application.

      - [x] 3.1.1.1 Subtask - Render one real `input type="checkbox"` with explicit and FormField identity, value, checked, errors, and disabled state.
      - [x] 3.1.1.2 Subtask - In boolean mode emit a same-name hidden unchecked sentinel immediately before the visible checkbox and mirror documented form and disabled semantics.
      - [x] 3.1.1.3 Subtask - In multiple-value mode normalize a repeated `[]` name, accept an explicit option value, and emit no unchecked sentinel.
      - [x] 3.1.1.4 Subtask - Normalize documented Phoenix truthy values without parsing domain data or mutating the form.

    - [x] 3.1.2 Task - Implement Checkbox composition and presentation.

      The visible label and supporting content should remain associated with the
      native input across compact, long, invalid, and disabled presentations.

      - [x] 3.1.2.1 Subtask - Associate the label directly with the checkbox and keep shared help and errors outside the label text.
      - [x] 3.1.2.2 Subtask - Add checked, unchecked, focus-visible, required, disabled, invalid, and pending styling without hiding native semantics.
      - [x] 3.1.2.3 Subtask - Preserve native Space activation, form reset, focus, high-contrast, and ordinary submission behavior.
      - [x] 3.1.2.4 Subtask - Protect type, ID, name, checked, disabled, invalid, and relationship attributes from contradictory globals.

  - [x] 3.2 Section - Radio Group foundation.

    This section provides one semantically grouped exclusive choice with stable
    option identity independent of display order and translated labels.

    - [x] 3.2.1 Task - Implement native group and option normalization.

      Radio Group should accept bounded caller data and emit a predictable
      fieldset rather than a custom selection widget.

      - [x] 3.2.1.1 Subtask - Render one native fieldset, one required legend, and repeated real radio inputs from validated caller option maps.
      - [x] 3.2.1.2 Subtask - Resolve group ID, name, scalar selected value, help, and errors from FormField or explicit data.
      - [x] 3.2.1.3 Subtask - Derive option IDs from stable explicit keys and reject duplicate keys, values, missing labels, and executable structures.
      - [x] 3.2.1.4 Subtask - Support fieldset-wide and option-local disabled states without inventing readonly radio semantics.

    - [x] 3.2.2 Task - Implement Radio Group relationships and presentation.

      Shared help and errors should describe the group while each option retains
      a direct native label and native keyboard behavior.

      - [x] 3.2.2.1 Subtask - Associate every option label with its radio and connect group help and visible errors deterministically.
      - [x] 3.2.2.2 Subtask - Add selected, unselected, focus-visible, required, disabled, invalid, and pending styling through semantic tokens.
      - [x] 3.2.2.3 Subtask - Preserve native arrow-key movement, Space selection, tab-stop behavior, form reset, and scalar submission.
      - [x] 3.2.2.4 Subtask - Protect fieldset, legend, type, shared name, selected value, option IDs, and derived relationships from globals.

  - [ ] 3.3 Section - Switch presentation boundary.

    This section exposes the familiar switch appearance while making its native
    checkbox identity and caller-owned checked state unambiguous.

    - [ ] 3.3.1 Task - Implement Switch as a styled checkbox.

      Switch should reuse Checkbox normalization and submission rather than
      introducing a role-only element or synchronized state.

      - [ ] 3.3.1.1 Subtask - Render one native checkbox and reuse boolean FormField, explicit, sentinel, checked, disabled, help, and error behavior.
      - [ ] 3.3.1.2 Subtask - Add closed switch track and thumb presentation while retaining a visible native focus indicator and adequate pointer target.
      - [ ] 3.3.1.3 Subtask - Keep label text visible by default and require an explicit nonblank accessible label for visually hidden-label usage.
      - [ ] 3.3.1.4 Subtask - Add no package event, toggle method, transition state, role-only imitation, or hidden mirrored checked value.

  - [ ] 3.4 Section - Phase 3 Integration Tests.

    This section proves that native choices retain correct identity, keyboard
    behavior, values, and relationships in realistic grouped forms.

    - [ ] 3.4.1 Task - Verify Checkbox and Switch values and behavior.

      Integration coverage should distinguish boolean sentinel submission from
      explicit repeated-value selection and prove Switch is the same control model.

      - [ ] 3.4.1.1 Subtask - Test checked and unchecked boolean submissions, sentinel order, disabled behavior, form association, and reset.
      - [ ] 3.4.1.2 Subtask - Test multiple-value names and values with zero, one, and several checked boxes and no sentinel collision.
      - [ ] 3.4.1.3 Subtask - Compare Checkbox and Switch FormField and explicit markup, submitted values, labels, help, errors, and protected globals.
      - [ ] 3.4.1.4 Subtask - Browser-test label activation, Space toggling, Tab order, focus visibility, zoom, forced colors, and no-script operation.

    - [ ] 3.4.2 Task - Verify Radio Group and complete choice composition.

      Tests should exercise stable keys, native exclusivity, shared descriptions,
      and realistic combinations of binary and exclusive choices.

      - [ ] 3.4.2.1 Subtask - Test FormField and explicit selection, no selection, group and option disabled states, reordered options, and duplicate-data rejection.
      - [ ] 3.4.2.2 Subtask - Verify fieldset, legend, option labels, stable IDs, help, repeated errors, invalid state, and non-conflicting caller descriptions.
      - [ ] 3.4.2.3 Subtask - Browser-test arrow keys, Space, native single selection, form reset, scalar submission, and long translated labels.
      - [ ] 3.4.2.4 Subtask - Compose Checkbox, Radio Group, Switch, Input, Error Summary, and Button in one static Phoenix form and run `mix precommit`, `mix spec.check --base main`, and `git diff --check`.
