# Public documentation and integration guidance

```spec-meta
id: shadcn_ui.public_documentation
kind: policy
status: active
summary: Complete plain-language component, installation, transport-neutral integration, upgrade, and provenance documentation.
decisions:
  - shadcn_ui.fly_gallery_publication
  - shadcn_ui.transport_neutral_phoenix_package
  - shadcn_ui.catalogue_driven_documentation
  - shadcn_ui.consumer_neutral_compatibility
  - shadcn_ui.public_hex_1_0_release
surface:
  - README.md
  - CHANGELOG.md
  - RELEASE.md
  - docs/**
  - docs/components.md
  - docs/installation.md
  - docs/compatibility.md
  - docs/integrations.md
  - docs/upgrading.md
  - docs/provenance.md
  - lib/shadcn_ui/**/*.ex
  - demo/lib/shadcn_ui_demo_web/**
  - demo/lib/shadcn_ui_demo/documentation_catalogue.ex
  - demo/lib/shadcn_ui_demo/reference.ex
  - demo/test/milestone_f_public_documentation_test.exs
  - scripts/check-documentation.exs
  - test/shadcn_ui/milestone_f_documentation_test.exs
  - test/shadcn_ui/milestone_f_final_documentation_test.exs
  - test/shadcn_ui/milestone_f_installation_compatibility_test.exs
  - test/shadcn_ui/milestone_f_integration_guidance_test.exs
  - release/candidate-status.json
  - release/fly-deployment-evidence.json
```

## Project identity boundary

ShadcnUI is a personal MIT-licensed project. Repository ownership, package
scope, schema identifiers, and the canonical Fly hostname are publication
identity only; they do not alter this subject's requirements, semantics,
runtime boundary, package contents, or existing verification.

## Requirements

```spec-requirements
- id: shadcn_ui.public_documentation.component_page_sections
  statement: Every component page shall explain in plain language what it is, when to use it, what the application owns, accessibility behavior, browser fallback, and provenance.
  priority: must
  stability: stable

- id: shadcn_ui.public_documentation.api_contract
  statement: Every public defining function shall document attributes, slots, defaults, closed values, globals, semantics, caller responsibilities, and at least one compile-checked HEEX example.
  priority: must
  stability: stable

- id: shadcn_ui.public_documentation.installation_and_assets
  statement: README guidance shall cover dependency installation, public imports, packaged stylesheet delivery, namespaced theme tokens, CSP, and the absence of a consumer Node, Tailwind, or package-JavaScript requirement.
  priority: must
  stability: stable

- id: shadcn_ui.public_documentation.compatibility_and_fallback
  statement: Documentation shall identify native baselines, optional capability-gated enhancements, exact fallbacks, reduced-motion behavior, and how current browser evidence differs from normative policy, including that Accordion row, chevron, and reveal presentation is CSS-only while native details state and access remain authoritative.
  priority: must
  stability: stable

- id: shadcn_ui.public_documentation.controller_example
  statement: Documentation shall provide a compile-checked ordinary Phoenix controller and HEEX consumption example without adding application code to the package.
  priority: must
  stability: stable

- id: shadcn_ui.public_documentation.transport_guidance
  statement: Dstar and LiveView guidance shall show applications rendering explicit stateless component snapshots without making either framework a ShadcnUI dependency or assigning application state to the package.
  priority: must
  stability: stable

- id: shadcn_ui.public_documentation.exdoc_inventory
  statement: ExDoc shall group every public defining component, expose accurate source-linked API documentation, and group one user guide for each closed gallery sidebar category with an introduction plus functionality, supported options, and at least one compile-checked HEEX example for every control, while excluding internal helpers, demo-only modules, release evidence, acceptance ledgers, engineering records, and operations runbooks from the public inventory.
  priority: must
  stability: stable

- id: shadcn_ui.public_documentation.upgrade_and_migration
  statement: Versioned changelog, migration, compatibility-floor, deprecation, and rollback guidance shall identify 1.0.0 as the first public release target, apply Semantic Versioning after publication, and distinguish historical internal-candidate evidence from current public release availability.
  priority: must
  stability: evolving

- id: shadcn_ui.public_documentation.provenance_and_identity
  statement: Public documentation shall identify ShadcnUI as an independent Phoenix adaptation and link each adapted component to the pinned upstream provenance and retained MIT notices without implying official affiliation.
  priority: must
  stability: stable
```

## Verification

Public documentation now names `1.0.0` as the first Hex release target while
stating that it is not yet published. Historical `0.1.0` candidate and Fly
evidence remains explicitly historical and cannot establish current release
availability.

The top-level README is the consumer-oriented package overview. Detailed
functionality, supported options, fallbacks and per-control HEEX examples live
in the category guides and generated API documentation; documentation tests
verify those owning surfaces rather than requiring the README to duplicate the
complete component manual.

Phase 8 publication runbook review is current proof for the documented gallery
recovery boundary; it does not change the public documentation contract.
Current documentation preserves dated Pages-era and phase-local snapshots,
while the candidate ledger separately records the operational Fly pass,
unreviewed deployed source, ineligible rollback state, and remaining clean,
manual, review, CI, and merge gates.
The R6 accessibility record adds a scoped owner-approved delivery waiver while
keeping every unexecuted manual scenario pending and explicitly refusing a
conformance, qualification or deployment claim.
The R6 local-regression record updates the candidate ledger with current
package, consumer, browser and export proof while retaining exact-revision CI,
manual accessibility and external delivery as pending states.
The R6 deployment and acceptance records name the exact deployed revision, Fly
release and image digest, canonical smoke and deployed-browser results, and
response hashes. Candidate-facing documentation keeps the exact clean build,
six manual scenarios, independent source approval, final evidence CI and merge
states distinct instead of inferring qualification from a healthy deployment.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/milestone_f_documentation_test.exs
  covers:
    - shadcn_ui.public_documentation.component_page_sections
    - shadcn_ui.public_documentation.api_contract
    - shadcn_ui.public_documentation.installation_and_assets
    - shadcn_ui.public_documentation.compatibility_and_fallback
    - shadcn_ui.public_documentation.controller_example
    - shadcn_ui.public_documentation.transport_guidance
    - shadcn_ui.public_documentation.exdoc_inventory
    - shadcn_ui.public_documentation.upgrade_and_migration
    - shadcn_ui.public_documentation.provenance_and_identity

- kind: test_file
  target: test/shadcn_ui/milestone_f_installation_compatibility_test.exs
  covers:
    - shadcn_ui.public_documentation.installation_and_assets
    - shadcn_ui.public_documentation.compatibility_and_fallback

- kind: test_file
  target: test/shadcn_ui/milestone_f_integration_guidance_test.exs
  covers:
    - shadcn_ui.public_documentation.controller_example
    - shadcn_ui.public_documentation.transport_guidance
    - shadcn_ui.public_documentation.upgrade_and_migration
    - shadcn_ui.public_documentation.provenance_and_identity

- kind: test_file
  target: demo/test/milestone_f_public_documentation_test.exs
  covers:
    - shadcn_ui.public_documentation.component_page_sections
    - shadcn_ui.public_documentation.api_contract
    - shadcn_ui.public_documentation.exdoc_inventory

- kind: command
  target: mix docs --warnings-as-errors
  covers:
    - shadcn_ui.public_documentation.api_contract
    - shadcn_ui.public_documentation.exdoc_inventory

- kind: test_file
  target: demo/test/milestone_g_remediation_r6_test.exs
  covers:
    - shadcn_ui.public_documentation.compatibility_and_fallback
    - shadcn_ui.public_documentation.upgrade_and_migration
```
