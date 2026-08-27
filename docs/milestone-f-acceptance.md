# Milestone F acceptance ledger

This is the current evidence ledger for the internal ShadcnUI `0.1.0`
candidate. Requirement implementation is complete, but candidate qualification
is **blocked**: the six mandatory manual accessibility scenarios, final-revision
CI, reviewed deployment, canonical post-deploy smoke, and a passing SpecLed gate
are not complete. A checked planning item or local run never substitutes for
one of those states.

Statuses below mean:

- `PASSED` — implemented and supported by current local automated evidence.
- `IMPLEMENTED; GATE PENDING` — the reviewed mechanism exists, but its CI,
  deployment, or canonical outcome cannot occur on this unmerged revision.
- `PENDING` — mandatory evidence has not been executed successfully.

## Documentation catalogue (10)

| Requirement | Status | Primary evidence |
| --- | --- | --- |
| `shadcn_ui.documentation_catalogue.closed_schema` | PASSED | `demo/test/documentation_catalogue_test.exs` |
| `shadcn_ui.documentation_catalogue.public_api_parity` | PASSED | catalogue and public API parity tests |
| `shadcn_ui.documentation_catalogue.stable_information_architecture` | PASSED | gallery route and navigation tests |
| `shadcn_ui.documentation_catalogue.stable_examples` | PASSED | fragment/source/browser tests |
| `shadcn_ui.documentation_catalogue.safe_resolution` | PASSED | controller and 404 tests |
| `shadcn_ui.documentation_catalogue.progressive_navigation` | PASSED | no-script navigation tests |
| `shadcn_ui.documentation_catalogue.deterministic_search` | PASSED | deterministic export and search hashes |
| `shadcn_ui.documentation_catalogue.progressive_search` | PASSED | Milestone F browser catalogue tests |
| `shadcn_ui.documentation_catalogue.completeness_report` | PASSED | catalogue completeness tests |
| `shadcn_ui.documentation_catalogue.package_boundary` | PASSED | package/archive exclusion tests |

## Public documentation (9)

| Requirement | Status | Primary evidence |
| --- | --- | --- |
| `shadcn_ui.public_documentation.component_page_sections` | PASSED | all 41 component-page audits |
| `shadcn_ui.public_documentation.api_contract` | PASSED | public attr/slot parity tests |
| `shadcn_ui.public_documentation.installation_and_assets` | PASSED | `docs/installation.md` and clean consumer |
| `shadcn_ui.public_documentation.compatibility_and_fallback` | PASSED | exact-engine and fallback matrix |
| `shadcn_ui.public_documentation.controller_example` | PASSED | compiled controller fixture |
| `shadcn_ui.public_documentation.transport_guidance` | PASSED | compiled Dstar/LiveView-shaped HEEX guidance |
| `shadcn_ui.public_documentation.exdoc_inventory` | PASSED | warnings-as-errors deterministic ExDoc |
| `shadcn_ui.public_documentation.upgrade_and_migration` | PASSED | changelog, upgrade, rollback and version tests |
| `shadcn_ui.public_documentation.provenance_and_identity` | PASSED | provenance manifest/notices and gallery identity |

## Compatibility and accessibility (9)

| Requirement | Status | Primary evidence |
| --- | --- | --- |
| `shadcn_ui.compatibility_accessibility.capability_policy` | PASSED | authored capability catalogue |
| `shadcn_ui.compatibility_accessibility.exact_engine_evidence` | PASSED | pinned Chromium/Firefox/WebKit records |
| `shadcn_ui.compatibility_accessibility.consumer_boundary` | PASSED | compatibility policy and archive boundary |
| `shadcn_ui.compatibility_accessibility.fallback_evidence` | PASSED | CSS/script/media/capability failure matrix |
| `shadcn_ui.compatibility_accessibility.responsive_and_preferences` | PASSED | narrow/zoom/RTL/theme/motion tests |
| `shadcn_ui.compatibility_accessibility.keyboard_and_semantics` | PASSED | native keyboard/focus/semantics assertions |
| `shadcn_ui.compatibility_accessibility.automated_accessibility` | PASSED | pinned axe plus explicit assertions |
| `shadcn_ui.compatibility_accessibility.manual_review` | PENDING | all six scenarios in `docs/accessibility-review.md` |
| `shadcn_ui.compatibility_accessibility.evidence_separation` | PASSED | normative capabilities and observed engines remain separate |

## Release and publication (10)

| Requirement | Status | Primary evidence |
| --- | --- | --- |
| `shadcn_ui.release_publication.version_identity` | PASSED | validated release manifest identity |
| `shadcn_ui.release_publication.deterministic_export` | PASSED | two byte-identical versioned exports |
| `shadcn_ui.release_publication.health_manifest` | PASSED | hashed `health.json` and `release.json` |
| `shadcn_ui.release_publication.deployment_workflow` | IMPLEMENTED; GATE PENDING | pinned main-only Pages workflow; Phase 6 CI/deploy pending |
| `shadcn_ui.release_publication.post_deploy_and_rollback` | IMPLEMENTED; GATE PENDING | canonical smoke and rollback runbook; deployed result pending |
| `shadcn_ui.release_publication.clean_checkout` | PASSED | reproducible candidate builds and current local gates |
| `shadcn_ui.release_publication.clean_consumer_trial` | PASSED | installed archive consumer and browser trial |
| `shadcn_ui.release_publication.explicit_archive` | PASSED | 62-entry allowlisted candidate archive |
| `shadcn_ui.release_publication.internal_candidate_only` | PASSED | no Hex publish, public tag, marketplace, or certification |
| `shadcn_ui.release_publication.truthful_gates` | PASSED | structured candidate status and this ledger |

## Documentation and regression reconciliation

The README, installation, compatibility, integration, upgrade, changelog,
release, reproducible-build, clean-consumer, provenance, accessibility and
gallery-operations documents describe the same transport-neutral package. The
ordinary controller example executes. Dstar and LiveView examples remain
dependency-free guidance around stateless HEEX; neither is a package runtime or
certified consumer target. All Milestones A–E component routes, examples,
native semantics, stylesheet contracts, package boundaries and browser suites
remain regression requirements.

## Deliberately deferred

Public Hex publication, a public version tag, marketplace or CLI distribution,
multiple branded theme catalogues, automated upstream synchronization, new
component families, Electron/embedded-consumer certification, and official
shadcn/ui or unscripted/ui affiliation are outside Milestone F. None is implied
by this candidate, gallery, workflow, or PR.

## Final qualification decision

The internal candidate remains blocked. After this revision is merged, record
final CI, Pages deployment and canonical smoke independently. Manual review and
SpecLed must also pass before `qualified` can become true. Until every mandatory
gate passes, do not publish Hex or create a public tag.
