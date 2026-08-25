# Phase 2 - Native Accordion Foundations

Back to wave: [README](./README.md)

- [x] 2 Phase - Deliver native independent and progressively exclusive disclosure
  with deterministic relationships and complete content fallbacks.

  This phase builds Accordion directly on `details` and `summary`. Server inputs
  describe the rendered snapshot while browsers retain activation, keyboard,
  focus, and find-in-page behavior.

  - [x] 2.1 Section - Native Accordion structure and identity.

    This section establishes stable item markup and a closed public API without
    inventing a second disclosure state model.

    - [x] 2.1.1 Task - Implement the Accordion item contract.

      Every item should retain native disclosure behavior and deterministic
      identity across server rerenders.

      - [x] 2.1.1.1 Subtask - Add a defining Disclosure.Accordion module and import it through `use ShadcnUI`.
      - [x] 2.1.1.2 Subtask - Require an explicit nonblank accordion ID, stable item keys, summary content, and trusted panel content.
      - [x] 2.1.1.3 Subtask - Render one native `details` and `summary` pair per item with deterministic details, summary, and content IDs.
      - [x] 2.1.1.4 Subtask - Preserve escaped text and trusted HEEX slots without disclosure roles, button imitations, hidden duplicate controls, or package scripts.

    - [x] 2.1.2 Task - Define rendered open state and protected globals.

      Open values should be explicit snapshots that cannot be contradicted by
      caller attributes or mistaken for persisted application state.

      - [x] 2.1.2.1 Subtask - Support explicit per-item initial open snapshots with deterministic repeated rendering.
      - [x] 2.1.2.2 Subtask - Protect native elements, IDs, summary relationships, group names, and open values from conflicting globals.
      - [x] 2.1.2.3 Subtask - Forward unrelated documented native, ARIA, data, Phoenix, and Datastar attributes to their documented elements.
      - [x] 2.1.2.4 Subtask - Reject blank IDs, duplicate or unstable keys, invalid modes, and contradictory item data without creating atoms.

  - [x] 2.2 Section - Grouping, animation, and fallback policy.

    This section adds optional exclusive grouping and visual polish while keeping
    independent native disclosure as the reliable fallback.

    - [x] 2.2.1 Task - Implement independent and exclusive modes.

      Group policy should be visible in deterministic markup and degrade without
      hiding or disabling any content.

      - [x] 2.2.1.1 Subtask - Emit no shared `name` in independent mode and allow any caller-supplied combination of open items.
      - [x] 2.2.1.2 Subtask - Derive one stable shared details `name` in exclusive mode and define deterministic handling of multiple caller-open snapshots.
      - [x] 2.2.1.3 Subtask - Document unsupported exclusive-details behavior as independently operable disclosure rather than a polyfilled package feature.
      - [x] 2.2.1.4 Subtask - Verify server replacement renders remain deterministic while browser-owned toggles and persistence stay outside the package.

    - [x] 2.2.2 Task - Add theme-aware disclosure presentation.

      Markers, open state, and optional motion should supplement native semantics
      without reducing focus or content access.

      - [x] 2.2.2.1 Subtask - Add prefixed summary, marker, panel, open-state, and focus-visible classes using semantic tokens; document why native disclosure exposes no false disabled presentation.
      - [x] 2.2.2.2 Subtask - Gate optional height or marker enhancement safely and retain native snap-open behavior when unsupported.
      - [x] 2.2.2.3 Subtask - Disable nonessential disclosure animation under reduced motion and retain visible open state in forced colors.
      - [x] 2.2.2.4 Subtask - Add API, semantics, find-in-page, state ownership, fallback, theme, and provenance documentation.

  - [x] 2.3 Section - Phase 2 Integration Tests.

    This section verifies Accordion as native disclosure across rendering,
    browser behavior, fallbacks, and package boundaries.

    - [x] 2.3.1 Task - Verify rendering, identity, and ownership.

      Component tests should prove deterministic markup and prevent accidental
      expansion into an application-controlled disclosure widget.

      - [x] 2.3.1.1 Subtask - Test independent and exclusive markup, stable IDs and names, open snapshots, nested content, caller globals, and invalid inputs.
      - [x] 2.3.1.2 Subtask - Test escaping, trusted slots, duplicate-key rejection, repeated server renders, and stable atom count.
      - [x] 2.3.1.3 Subtask - Audit source and release output for toggle handlers, persistence, focus movement, routing, lazy loading, application dependencies, and JavaScript.
      - [x] 2.3.1.4 Subtask - Add aggregate disclosure tests composing Separator and Scroll Area without changing their native contracts.

    - [x] 2.3.2 Task - Verify native browser and fallback behavior.

      Browser evidence should cover the semantics the package claims and the
      degraded behavior it documents.

      - [x] 2.3.2.1 Subtask - Browser-test summary click, Enter and Space activation, focus visibility, open state, nested interactive content, and find-in-page access.
      - [x] 2.3.2.2 Subtask - Test exclusive grouping where supported and independent disclosure when the shared-name feature is absent or ignored.
      - [x] 2.3.2.3 Subtask - Test light, dark, narrow, zoom, forced-colors, reduced-motion, no-CSS, and no-script presentation.
      - [x] 2.3.2.4 Subtask - Run asset checks, package precommit, ExDoc, archive audit, provenance validation, `mix spec.check --base main`, and `git diff --check`.
