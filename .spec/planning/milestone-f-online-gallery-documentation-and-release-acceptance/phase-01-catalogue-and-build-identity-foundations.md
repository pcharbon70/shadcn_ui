# Phase 1 - Catalogue And Build Identity Foundations

Back to wave: [README](./README.md)

- [ ] 1 Phase - Catalogue And Build Identity Foundations.

  Establish the immutable documentation inventory, safe identity mapping and
  reproducible build metadata before changing the public gallery experience.

  - [x] 1.1 Section - Define the documentation catalogue schema.

    Extend the closed gallery catalogue with explicit documentation identities
    while preserving every implemented route and category.

    - [x] 1.1.1 Task - Model public components and examples explicitly.

      The schema must describe public APIs and authored examples without dynamic dispatch.

      - [x] 1.1.1.1 Subtask - Define closed fields for category, slug, module, function, route, purpose, documentation sections, provenance, examples and verification identities.
      - [x] 1.1.1.2 Subtask - Give examples authored stable unique fragment IDs, source identities, preview labels and component-page relationships.
      - [x] 1.1.1.3 Subtask - Preserve existing category labels, ordering, component slugs, canonical routes, breadcrumbs and sitemap destinations.

    - [x] 1.1.2 Task - Enforce safe immutable resolution.

      Catalogue data and request text must never become executable identities.

      - [x] 1.1.2.1 Subtask - Resolve only closed strings to predeclared module/function pairs and reject unknown, duplicate or mismatched entries deterministically.
      - [x] 1.1.2.2 Subtask - Prove route, search and fragment text cannot create atoms, modules, functions, templates, asset paths or callbacks.
      - [x] 1.1.2.3 Subtask - Keep documentation metadata in the demo/build boundary and add no package registry or public runtime lookup API.

  - [x] 1.2 Section - Reconcile the complete public inventory.

    Connect every Milestones A-E defining component to one gallery and documentation identity.

    - [x] 1.2.1 Task - Audit public API parity.

      The checked inventory must neither omit a public component nor advertise an internal helper.

      - [x] 1.2.1.1 Subtask - Enumerate defining component modules and public functions through compile-time metadata without parsing user input.
      - [x] 1.2.1.2 Subtask - Compare that inventory to catalogue leaves, ExDoc groups, provenance records, source examples and existing browser routes.
      - [x] 1.2.1.3 Subtask - Fail on missing, duplicate, stale or internal-only entries with actionable deterministic diagnostics.

    - [x] 1.2.2 Task - Produce a completeness report.

      Maintainers need one reproducible view of every required documentation relationship.

      - [x] 1.2.2.1 Subtask - Generate a sorted report linking component, route, fragments, docs, provenance, compile test, browser route and export artifact.
      - [x] 1.2.2.2 Subtask - Make report generation independent of timestamps, working-tree ordering, remote services and machine-specific absolute paths.
      - [x] 1.2.2.3 Subtask - Keep generated reports ignored or test-owned and outside the actual release allowlist.

  - [ ] 1.3 Section - Establish immutable build and site identity.

    Define how local and published artifacts truthfully identify their source without runtime discovery.

    - [ ] 1.3.1 Task - Validate release metadata inputs.

      Package, source, catalogue and upstream identities must be explicit reproducible inputs.

      - [ ] 1.3.1.1 Subtask - Define validated package-version, full-revision, catalogue-schema and upstream-revision formats with deterministic development defaults.
      - [ ] 1.3.1.2 Subtask - Inject build revision during export or CI rather than querying Git or remote services from package runtime.
      - [ ] 1.3.1.3 Subtask - Reject partial, malformed, secret-like or mutable identity values before creating a release artifact.

    - [ ] 1.3.2 Task - Render identity consistently.

      HTML and machine-readable metadata must describe the same immutable build.

      - [ ] 1.3.2.1 Subtask - Display package and build identity in the gallery shell without claiming deployment or browser support from version text.
      - [ ] 1.3.2.2 Subtask - Seed deterministic release and health metadata from the same validated identity record.
      - [ ] 1.3.2.3 Subtask - Verify identity is local, non-secret, escaped, stable across all routes and excluded from package runtime state.

  - [ ] 1.4 Section - Phase 1 Integration Tests.

    Prove schema safety, inventory parity, stable history, build identity and package isolation together.

    - [ ] 1.4.1 Task - Exercise catalogue and identity integration.

      Tests must use the actual compiled public surface and real gallery route inventory.

      - [ ] 1.4.1.1 Subtask - Add documentation catalogue tests covering valid inventory, duplicates, omissions, mismatches, unsafe text and stable example fragments.
      - [ ] 1.4.1.2 Subtask - Run every existing route, breadcrumb, canonical, sitemap, export and unknown-route regression from Milestones A-E.
      - [ ] 1.4.1.3 Subtask - Generate identical identity and completeness outputs twice from fixed inputs and verify non-secret escaped content.

    - [ ] 1.4.2 Task - Verify phase boundaries and contracts.

      The new planning subject must not weaken package, gallery or SpecLed gates.

      - [ ] 1.4.2.1 Subtask - Audit the actual archive for absence of catalogue, search, report, demo and build-identity implementation files.
      - [ ] 1.4.2.2 Subtask - Run package/demo precommit, affected browser smoke, SpecLed next/check for main and HEAD, and git diff --check.
      - [ ] 1.4.2.3 Subtask - Record executed evidence and limitations, complete section commits in order and open one Phase 1 PR.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge without a later request.
