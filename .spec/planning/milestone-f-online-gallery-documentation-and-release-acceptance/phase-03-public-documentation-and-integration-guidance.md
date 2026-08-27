# Phase 3 - Public Documentation And Integration Guidance

Back to wave: [README](./README.md)

- [ ] 3 Phase - Public Documentation And Integration Guidance.

  Make the package understandable without reading implementation source or
  adopting the gallery's application structure.

  - [ ] 3.1 Section - Complete public API and component guidance.

    Align gallery prose, ExDoc and compile-checked examples with the public inventory.

    - [ ] 3.1.1 Task - Audit every public defining component.

      Public API documentation must describe the actual HEEX contract precisely.

      - [ ] 3.1.1.1 Subtask - Document attrs, slots, defaults, closed values, globals, escaping, semantics, caller-owned state and deterministic IDs for every defining function.
      - [ ] 3.1.1.2 Subtask - Add at least one compile-checked public-import HEEX example per function and link it to its gallery page and source.
      - [ ] 3.1.1.3 Subtask - Group public modules in ExDoc while excluding internal validation, CSS, evidence and demo helpers.

    - [ ] 3.1.2 Task - Standardize plain-language component pages.

      Repeated documentation headings should answer concrete consumer questions.

      - [ ] 3.1.2.1 Subtask - Complete what-it-is, when-to-use, application-ownership, accessibility and browser-fallback sections for every catalogue entry.
      - [ ] 3.1.2.2 Subtask - Explain native baseline, package CSS enhancement, demo-only behavior and unsupported capability separately.
      - [ ] 3.1.2.3 Subtask - Add related-pattern guidance without claiming tabs, menus, progress, animation state or other semantics a component does not implement.

  - [ ] 3.2 Section - Complete installation, assets and compatibility guidance.

    Give consumers a reproducible path from dependency to styled HEEX without hidden tooling.

    - [ ] 3.2.1 Task - Document package setup and styling.

      Installation instructions must match the distributed archive and public API.

      - [ ] 3.2.1.1 Subtask - Document dependency selection, `use ShadcnUI`, direct imports and packaged stylesheet serving with Phoenix examples.
      - [ ] 3.2.1.2 Subtask - Explain namespaced tokens, light/dark scopes, consumer overrides, CSS ordering, mixed-design-system isolation and reduced motion.
      - [ ] 3.2.1.3 Subtask - Document CSP and confirm consumers need no Node, Tailwind, remote runtime asset or ShadcnUI JavaScript.

    - [ ] 3.2.2 Task - Publish the capability and fallback policy.

      Users need actionable compatibility guidance rather than a vague browser list.

      - [ ] 3.2.2.1 Subtask - List component capability bundles, native baselines, optional enhancements and exact fallbacks with evidence dates and locked-engine revisions.
      - [ ] 3.2.2.2 Subtask - Explain how consumers evaluate their own browser or embedded renderer without implying ShadcnUI platform certification.
      - [ ] 3.2.2.3 Subtask - Define the review and migration process for admitting a feature or raising a capability floor.

  - [ ] 3.3 Section - Publish transport-neutral integration and upgrade guides.

    Show common Phoenix consumption patterns while leaving application state and transport outside the package.

    - [ ] 3.3.1 Task - Provide controller, Dstar and LiveView guidance.

      All examples should render the same explicit stateless component snapshots.

      - [ ] 3.3.1.1 Subtask - Add a runnable controller-rendered Phoenix example covering public imports, assigns, stylesheet delivery and ordinary navigation.
      - [ ] 3.3.1.2 Subtask - Add Dstar guidance for rendering validated server-owned HEEX patches without adding Dstar, routes, actions or signals to ShadcnUI.
      - [ ] 3.3.1.3 Subtask - Add LiveView guidance for rendering explicit assigns and caller-owned events without making LiveView state a component contract.

    - [ ] 3.3.2 Task - Complete version, migration and provenance records.

      Candidate consumers need to know what changed, what is licensed and how to recover.

      - [ ] 3.3.2.1 Subtask - Reconcile README, changelog, migration notes, deprecation policy, compatibility floors and rollback guidance with the internal 0.1.0 scope.
      - [ ] 3.3.2.2 Subtask - Audit all component/CSS provenance entries, pinned upstream revision, MIT notice and independent project identity.
      - [ ] 3.3.2.3 Subtask - Distinguish implemented API, internal candidate, public availability, CI, deployment and manual review status throughout public documentation.

  - [ ] 3.4 Section - Phase 3 Integration Tests.

    Prove documentation completeness, compilability, transport neutrality and archive accuracy as one consumer-facing contract.

    - [ ] 3.4.1 Task - Verify documentation parity and examples.

      Automated checks must compare the actual public surface to every documentation channel.

      - [ ] 3.4.1.1 Subtask - Add documentation tests for catalogue sections, ExDoc groups, attrs/slots, source links, ownership, fallback and provenance completeness.
      - [ ] 3.4.1.2 Subtask - Compile all controller, gallery, README, Dstar-shaped fragment and LiveView-shaped HEEX examples through the intended public imports.
      - [ ] 3.4.1.3 Subtask - Build warning-free ExDoc and audit generated links, excluded internals, changelog, migrations and legal notices.

    - [ ] 3.4.2 Task - Verify package and regression boundaries.

      Documentation work may not introduce runtime frameworks, remote assets or stale gallery routes.

      - [ ] 3.4.2.1 Subtask - Inspect dependencies, source and actual archive for absence of Dstar, application LiveView, controller, endpoint, Electron, remote asset and demo implementation.
      - [ ] 3.4.2.2 Subtask - Run affected A-E package, gallery, provenance, CSS, export and browser regression suites.
      - [ ] 3.4.2.3 Subtask - Run precommit, SpecLed and whitespace gates, record evidence, commit four sections and open one Phase 3 PR.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge without a later request.
