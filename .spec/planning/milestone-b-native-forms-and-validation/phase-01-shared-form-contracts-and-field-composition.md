# Phase 1 - Shared Form Contracts And Field Composition

Back to wave: [README](./README.md)

- [ ] 1 Phase - Establish one normalization, accessibility, validation-
  ownership, and field-composition foundation for every Milestone B control.

  This phase implements the high-risk shared rules before individual controls.
  Its outcome is a tested private normalizer and public field primitives that
  render deterministic relationships without owning a form lifecycle.

  - [x] 1.1 Section - FormField normalization and validation ownership.

    This section creates a single private boundary for resolving explicit and
    Phoenix form data, error visibility, translation, and presentation state.

    - [x] 1.1.1 Task - Implement normalized field identity and value data.

      The normalizer should give every applicable control the same precedence,
      failure, escaping, and stable-identity behavior.

      - [x] 1.1.1.1 Subtask - Accept `Phoenix.HTML.FormField` or explicit ID, name, value, and error inputs with documented explicit-over-derived precedence.
      - [x] 1.1.1.2 Subtask - Require nonblank normalized IDs and names for submitted visible controls and reject contradictory identity.
      - [x] 1.1.1.3 Subtask - Keep normalized values as caller data suitable for native markup without mutating forms, changesets, or parameter maps.
      - [x] 1.1.1.4 Subtask - Add shared fixtures proving atom-count stability, deterministic output, escaping, and server-rerender identity.

    - [x] 1.1.2 Task - Implement caller-owned error and pending policy.

      Error and pending inputs should describe one render snapshot without
      creating translation, validation, authorization, or request behavior.

      - [x] 1.1.2.1 Subtask - Add closed used-input, always, and hidden error modes with no inferred submission state.
      - [x] 1.1.2.2 Subtask - Support escaped explicit strings and raw FormField tuples through a caller translator or deterministic placeholder interpolation.
      - [x] 1.1.2.3 Subtask - Add presentation-only pending normalization that never disables a control or prevents submission automatically.
      - [x] 1.1.2.4 Subtask - Test that invalid and pending snapshots execute no validation, persistence, authorization, event, or application operation.

  - [x] 1.2 Section - Deterministic relationship context.

    This section centralizes label, help, error, group, and caller-description
    relationships so components cannot drift apart during later implementation.

    - [x] 1.2.1 Task - Build stable relationship identifiers.

      Relationship helpers should derive predictable suffixes and preserve every
      meaningful repeated message without random or process-global identity.

      - [x] 1.2.1.1 Subtask - Derive label, help, error, summary-item, and repeated-option IDs from one normalized base ID.
      - [x] 1.2.1.2 Subtask - Give repeated errors stable ordinal IDs while retaining equal messages as distinct entries.
      - [x] 1.2.1.3 Subtask - Normalize stable option keys into collision-free URL-safe control IDs without using translated labels or list position.

    - [x] 1.2.2 Task - Assemble and protect accessibility attributes.

      Derived relationships should remain authoritative while unrelated caller
      attributes continue through the shared component contract.

      - [x] 1.2.2.1 Subtask - Merge ordered distinct caller descriptions, visible help, and visible error IDs into `aria-describedby`.
      - [x] 1.2.2.2 Subtask - Emit protected `aria-invalid="true"` only when errors are visible and eliminate dangling references when hidden.
      - [x] 1.2.2.3 Subtask - Protect IDs, names, label targets, group semantics, native types, invalid state, and derived relationships from conflicting globals.
      - [x] 1.2.2.4 Subtask - Pass unrelated documented native, `aria-*`, `data-*`, `phx-*`, and `data-on-*` attributes with deterministic class merging.

  - [x] 1.3 Section - Field fragments and Error Summary.

    This section exposes the semantic composition pieces applications need to
    build complete forms without adopting a package-owned form builder.

    - [x] 1.3.1 Task - Implement Field, Label, Help, and Field Errors.

      The primitives should cooperate through explicit relationship data while
      preserving caller-owned control content and message lifecycle.

      - [x] 1.3.1.1 Subtask - Implement Field as a relationship-aware layout wrapper with a required caller-owned control slot.
      - [x] 1.3.1.2 Subtask - Implement native Label with a protected `for` target and required escaped or trusted HEEX content.
      - [x] 1.3.1.3 Subtask - Implement Help and repeated Field Errors with deterministic IDs, escaped strings, and no default live-region role.
      - [x] 1.3.1.4 Subtask - Add required, optional, invalid, disabled, pending, long-content, narrow, and theme styling using semantic tokens.

    - [x] 1.3.2 Task - Implement Error Summary without behavior overstatement.

      The summary should make server errors easy to find while leaving focus,
      scrolling, announcement, and navigation policy to the consuming app.

      - [x] 1.3.2.1 Subtask - Render an escaped heading and deterministic list of form- or field-level messages.
      - [x] 1.3.2.2 Subtask - Link field messages through ordinary fragments to explicit control IDs and preserve repeated messages distinctly.
      - [x] 1.3.2.3 Subtask - Add no default alert role, tabindex, autofocus, script, focus movement, or scroll behavior.
      - [x] 1.3.2.4 Subtask - Test caller-selected announcement globals without weakening mandatory summary and link semantics.

  - [ ] 1.4 Section - Phase 1 Integration Tests.

    This section proves that the shared normalizer, relationship context, field
    fragments, and summary work together before individual controls depend on
    them.

    - [ ] 1.4.1 Task - Verify explicit and FormField contract equivalence.

      Integration fixtures should render the same semantic field composition
      from both input modes across error and presentation policies.

      - [ ] 1.4.1.1 Subtask - Render explicit and FormField fixtures with matching IDs, names, values, labels, help, errors, and globals.
      - [ ] 1.4.1.2 Subtask - Verify used-input, always, and hidden modes with translated, interpolated, repeated, and escaped messages.
      - [ ] 1.4.1.3 Subtask - Rerender fixtures and assert stable IDs, relationship order, protected attributes, and no atom growth.

    - [ ] 1.4.2 Task - Verify composed accessibility and package boundaries.

      Tests should cover content stress and absence of hidden behavior as part of
      the contract rather than treating them as later gallery polish.

      - [ ] 1.4.2.1 Subtask - Compose multiple Fields and one Error Summary with unique fragments and complete non-dangling references.
      - [ ] 1.4.2.2 Subtask - Exercise long labels, translated and repeated errors, narrow layout, light/dark themes, zoom, and forced colors.
      - [ ] 1.4.2.3 Subtask - Audit dependencies and rendered markup for absent Gettext backend, form mutation, events, scripts, application operations, and component state.
      - [ ] 1.4.2.4 Subtask - Run `mix precommit`, `mix spec.check --base main`, and `git diff --check`.
