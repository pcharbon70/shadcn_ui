# Milestone F acceptance ledger

This is the current evidence ledger for the ShadcnUI `1.0.0` public release
target. All requirements have explicit implementation/evidence entries, but
release qualification is **blocked**: the version-specific archive, isolated
consumer, exact-source reproducibility, Hex publication, and public tag remain
pending. The qualification merge and exact-main CI pass for the selected
`RELEASE_SHA`; independent source review remains unperformed under the explicit
`1.0.0` owner waiver. The matching `1.0.0` Fly deployment and post-deploy smoke
pass for the exact recorded deployed source.
All six manual accessibility scenarios remain pending and unassessed, but are
explicitly waived and non-mandatory for `1.0.0`. The recorded `0.1.0` archive
evidence remains historical and does not satisfy a `1.0.0` gate. A checked
planning item or historical run never substitutes for a current gate.
Public-release Phases 1-3 now pass their mandatory gates; every later exact-
source qualification and publication gate retains its separate status.

Statuses below mean:

- `PASSED` — implemented and supported by the cited or recorded automated evidence.
- `IMPLEMENTED; GATE PENDING` — the mechanism exists, but its current
  clean-build, consumer, CI, or human outcome is not yet passing.
- `PENDING` — mandatory evidence has not been executed successfully.
- `WAIVED; NON-BLOCKING` — evidence remains unexecuted under an explicit,
  release-scoped owner decision and is not represented as a pass.

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
| `shadcn_ui.compatibility_accessibility.manual_review` | WAIVED; NON-BLOCKING | all six scenarios remain `PENDING`; owner waiver applies to `1.0.0` only and makes no conformance claim |
| `shadcn_ui.compatibility_accessibility.evidence_separation` | PASSED | normative capabilities and observed engines remain separate |

## Release and publication (10)

| Requirement | Status | Primary evidence |
| --- | --- | --- |
| `shadcn_ui.release_publication.version_identity` | PASSED | validated release manifest identity |
| `shadcn_ui.release_publication.deterministic_export` | PASSED | two byte-identical versioned exports |
| `shadcn_ui.release_publication.health_manifest` | PASSED | hashed `health.json` and `release.json` |
| `shadcn_ui.release_publication.deployment_workflow` | PASSED | Fly release `rel_76njzd0doog3yko3` serves exact `1.0.0` source and image identity; review remains separately unperformed under the bounded owner waiver |
| `shadcn_ui.release_publication.post_deploy_and_rollback` | PASSED | current service health, canonical smoke, deployed Chromium checks, failed-interim-release record, rollback policy, and `release/fly-deployment-evidence.json` |
| `shadcn_ui.release_publication.clean_checkout` | IMPLEMENTED; GATE PENDING | Phase 2 preliminary two-build evidence passed; final `RELEASE_SHA` comparison remains pending for Phase 4 |
| `shadcn_ui.release_publication.clean_consumer_trial` | IMPLEMENTED; GATE PENDING | Phase 2 preliminary `1.0.0` archive trial passed; final `RELEASE_SHA` archive trial remains pending for Phase 4 |
| `shadcn_ui.release_publication.explicit_archive` | IMPLEMENTED; GATE PENDING | Phase 2 actual archives passed the allowlist; final `RELEASE_SHA` archive audit remains pending for Phase 4 |
| `shadcn_ui.release_publication.public_release_target` | PENDING | `1.0.0` selected; Phases 1-3 pass with review explicitly waived, qualification merged, and exact-main CI green; final archive, consumer, reproducibility, Hex publication, and tag evidence remain pending |
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

## Publication target and deliberately deferred work

Hex publication and a public `v1.0.0` tag are now explicit release gates, not
completed outcomes. A marketplace or CLI distribution, multiple branded theme
catalogues, automated upstream synchronization, new component families,
Electron/embedded-consumer certification, and official shadcn/ui or
unscripted/ui affiliation remain outside the release. None is implied by the
package, gallery, workflow, or PR.

## Final qualification decision

The `1.0.0` release remains blocked. Build and audit its actual archive, run the
isolated consumer, complete two clean builds against the exact final revision,
and require those Phase 4 results to bind to the selected `RELEASE_SHA`. The
qualification merge and exact-main CI already pass; independent source review
and all six human scenarios remain unexecuted under their separate,
non-blocking `1.0.0` waivers. The matching Fly deployment and smoke also pass.
Only after the remaining exact-source gates pass may Hex publication and the
public tag be recorded as completed. Phase evidence is recorded in
`release/public-release-preflight.json`, `release/preliminary-candidate-evidence.json`,
and `release/public-release-phase-3.json`; no earlier phase promotes a later
gate.
