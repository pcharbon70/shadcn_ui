# Phase 2 - Information Architecture, Search, And Examples

Back to wave: [README](./README.md)

- [ ] 2 Phase - Information Architecture, Search, And Examples.

  Turn the Phase 1 inventory into responsive, searchable and deep-linkable
  public documentation while preserving ordinary no-script navigation.

  - [ ] 2.1 Section - Complete responsive gallery navigation.

    Expose the full stable catalogue through useful desktop and mobile structures.

    - [ ] 2.1.1 Task - Refine categorized desktop navigation.

      The persistent navigation should make hierarchy and current location obvious.

      - [ ] 2.1.1.1 Subtask - Render all existing categories and leaves from authored catalogue metadata with ordinary links and accurate current-page state.
      - [ ] 2.1.1.2 Subtask - Preserve skip link, named navigation, breadcrumb, one main landmark, page heading and visible focus order.
      - [ ] 2.1.1.3 Subtask - Keep category labels and routes stable and avoid menu, tree, tab or client-router role overstatement.

    - [ ] 2.1.2 Task - Add an equivalent mobile navigation path.

      Narrow layouts need complete reachable navigation without copying application behavior into the package.

      - [ ] 2.1.2.1 Subtask - Provide a native responsive disclosure or in-flow catalogue navigation with the same ordered destinations.
      - [ ] 2.1.2.2 Subtask - Verify keyboard, touch target, focus return, long-label, zoom and no-script usability using native semantics.
      - [ ] 2.1.2.3 Subtask - Ensure optional demo scripting changes no route availability or core navigation result.

  - [ ] 2.2 Section - Add deterministic progressive search.

    Make the full inventory quickly discoverable without remote data or a client router.

    - [ ] 2.2.1 Task - Generate the local search document.

      Search records must be minimal, stable, safe and derived from the closed catalogue.

      - [ ] 2.2.1.1 Subtask - Export normalized names, categories, summaries, keywords and stable URLs in deterministic catalogue order.
      - [ ] 2.2.1.2 Subtask - Validate schema, encoding, uniqueness, route membership and repository-subpath URLs while excluding HEEX, executable markup and secrets.
      - [ ] 2.2.1.3 Subtask - Hash or fingerprint the local search asset and verify two identical exports produce identical bytes.

    - [ ] 2.2.2 Task - Implement the demo-only filter experience.

      Search should improve a complete link list and announce results honestly.

      - [ ] 2.2.2.1 Subtask - Add a labelled search input that filters already-rendered catalogue links and reports result counts without fetching remote data.
      - [ ] 2.2.2.2 Subtask - Handle empty, unmatched, Unicode, long and HTML-like input as inert text without altering history or creating dynamic routes.
      - [ ] 2.2.2.3 Subtask - Keep all links available without JavaScript and exclude search code/data from package contents.

  - [ ] 2.3 Section - Complete example previews and stable source views.

    Give every component a predictable page and every authored example a durable destination.

    - [ ] 2.3.1 Task - Render catalogue-driven component sections.

      Pages should share an understandable structure without erasing component-specific guidance.

      - [ ] 2.3.1.1 Subtask - Render what-it-is, when-to-use, application-ownership, accessibility, fallback and provenance sections from checked metadata.
      - [ ] 2.3.1.2 Subtask - Render each example at its stable fragment with a descriptive heading, preview state, theme scope and responsive container.
      - [ ] 2.3.1.3 Subtask - Add direct fragment links, canonical page identity and useful cross-links to related components and compositions.

    - [ ] 2.3.2 Task - Pair previews with compile-checked HEEX source.

      Displayed code must correspond to a valid public API example and remain inert.

      - [ ] 2.3.2.1 Subtask - Compile every authored snippet through public imports and compare its declared component identity to the preview.
      - [ ] 2.3.2.2 Subtask - Render escaped source with optional demo-only copy feedback that remains usable as selectable text when scripting is absent.
      - [ ] 2.3.2.3 Subtask - Expose light/dark, reduced-motion and missing-capability inspection without fabricating package behavior.

  - [ ] 2.4 Section - Phase 2 Integration Tests.

    Verify complete navigation, safe search, stable fragments, real previews and static export across responsive modes.

    - [ ] 2.4.1 Task - Exercise live and static gallery behavior.

      The same information architecture must work from controller routes and repository-subpath exports.

      - [ ] 2.4.1.1 Subtask - Add browser tests for desktop/mobile navigation, current state, breadcrumbs, direct component and fragment entry, history and 404 behavior.
      - [ ] 2.4.1.2 Subtask - Test search result filtering, announcements, reset, hostile-looking text, no matches and no-script completeness.
      - [ ] 2.4.1.3 Subtask - Check every source block, preview, theme/motion link, canonical URL and local search asset in two byte-identical exports.

    - [ ] 2.4.2 Task - Verify accessibility and release isolation.

      Progressive demo improvements may not weaken semantics or enter the package.

      - [ ] 2.4.2.1 Subtask - Run explicit landmark, label, focus-order, visible-focus, zoom, long-label, narrow-layout and pinned axe checks.
      - [ ] 2.4.2.2 Subtask - Re-run A-E gallery/browser regressions and actual archive exclusions for all new demo JavaScript, metadata and search output.
      - [ ] 2.4.2.3 Subtask - Run precommit, SpecLed and whitespace gates, record evidence, commit four sections and open one Phase 2 PR.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge without a later request.
