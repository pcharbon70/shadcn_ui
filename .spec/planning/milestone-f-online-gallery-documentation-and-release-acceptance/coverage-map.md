# Milestone F Requirement Coverage Map

This planning map assigns requirements to delivery and intended proof. It is not
implementation evidence; planned targets remain absent or incomplete until their
phase lands.

| Requirement group | Phase | Primary planned proof |
| --- | --- | --- |
| `documentation_catalogue.closed_schema`, `public_api_parity`, `safe_resolution` | 1 | `demo/test/documentation_catalogue_test.exs` |
| `documentation_catalogue.completeness_report`, `package_boundary` | 1 | catalogue audit and package archive tests |
| `release_publication.version_identity` | 1 | build-metadata and static-export tests |
| `documentation_catalogue.stable_information_architecture`, `stable_examples` | 2 | controller/export tests and `milestone-f-catalogue.spec.mjs` |
| `documentation_catalogue.progressive_navigation`, `deterministic_search`, `progressive_search` | 2 | no-script, search-index and browser tests |
| `public_documentation.component_page_sections`, `api_contract`, `exdoc_inventory` | 3 | documentation parity tests and warning-free ExDoc |
| `public_documentation.installation_and_assets`, `controller_example`, `transport_guidance` | 3 | compiled guide and clean example tests |
| `public_documentation.compatibility_and_fallback`, `upgrade_and_migration`, `provenance_and_identity` | 3 | README/changelog/provenance audits |
| `compatibility_accessibility.capability_policy`, `exact_engine_evidence`, `consumer_boundary` | 4 | policy audit and exact-engine records |
| `compatibility_accessibility.fallback_evidence`, `responsive_and_preferences`, `keyboard_and_semantics` | 4 | cross-engine browser suite |
| `compatibility_accessibility.automated_accessibility`, `manual_review`, `evidence_separation` | 4 | pinned axe, explicit assertions and manual-review ledger |
| `release_publication.deterministic_export`, `clean_checkout`, `explicit_archive` | 5 | two-build comparison, clean verification and actual archive audit |
| `release_publication.clean_consumer_trial`, `internal_candidate_only` | 5 | isolated Phoenix consumer and release-policy audit |
| `release_publication.health_manifest`, `deployment_workflow`, `post_deploy_and_rollback` | 6 | export/workflow tests and canonical smoke runbook |
| `release_publication.truthful_gates` | 6 | final acceptance record and `milestone_f_release_test.exs` |

All existing `shadcn_ui.gallery`, `shadcn_ui.package`, stylesheet, provenance,
component-family and Milestones A-E acceptance requirements remain regression
coverage in every affected phase.
