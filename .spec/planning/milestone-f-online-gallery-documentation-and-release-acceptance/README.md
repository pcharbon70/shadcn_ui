# Milestone F - Online Gallery, Documentation, And Release Acceptance

## Status and purpose

This implementation record sequences the documentation, compatibility and
internal release work described by the [Milestone F roadmap](../../milestones/milestone-f-online-gallery-documentation-and-release-acceptance.md).
Phases 1-5 and Phase 6 Sections 6.1-6.3 have landed. Final qualification remains
open for an exact-revision clean candidate and archive consumer, source review,
and final-revision CI. The six manual accessibility scenarios remain pending
but are waived and non-mandatory for `1.0.0`. The canonical Fly release and
post-deploy smoke pass operationally, but review and merge remain separate
states. The work adds no component family, package JavaScript runtime,
application framework, operating-system target, or embedded-renderer support
claim.

## Accepted architecture and contracts

1. [Catalogue-driven documentation and progressive demo tooling](../../decisions/catalogue-driven-documentation-and-progressive-demo-tooling.md)
2. [Consumer-neutral compatibility and integration guidance](../../decisions/consumer-neutral-compatibility-and-integration-guidance.md)
3. [Fly gallery application publication](../../decisions/fly-gallery-application-publication.md)
4. [Internal release candidate and clean consumer trial](../../decisions/internal-release-candidate-and-clean-consumer-trial.md)
5. [Public Hex 1.0.0 release](../../decisions/public-hex-1-0-release.md)
6. [1.0.0 manual-accessibility waiver](../../decisions/waive-manual-accessibility-for-1-0-0.md)

The normative specifications are:

- [Documentation catalogue](../../specs/documentation_catalogue.spec.md)
- [Public documentation](../../specs/public_documentation.spec.md)
- [Compatibility and accessibility](../../specs/compatibility_accessibility.spec.md)
- [Release and publication](../../specs/release_publication.spec.md)

The [coverage map](./coverage-map.md) assigns all 38 new requirements to phases
and planned evidence. Existing package, gallery, component, stylesheet,
provenance and Milestones A-E contracts continue to apply.

## Ordered phases

| Phase | Delivery | Dependency |
| --- | --- | --- |
| [1 - Catalogue And Build Identity Foundations](./phase-01-catalogue-and-build-identity-foundations.md) | Establish the closed documentation schema, public inventory, immutable build identity and completeness machinery. | Milestone E candidate |
| [2 - Information Architecture, Search, And Examples](./phase-02-information-architecture-search-and-examples.md) | Deliver responsive navigation, progressive local search, stable example fragments, previews and source views. | Phase 1 |
| [3 - Public Documentation And Integration Guidance](./phase-03-public-documentation-and-integration-guidance.md) | Complete component, installation, ExDoc, controller, Dstar, LiveView, upgrade and provenance guidance. | Phase 2 |
| [4 - Compatibility And Accessibility Acceptance](./phase-04-compatibility-and-accessibility-acceptance.md) | Execute the capability-based browser, fallback, responsive, semantic, automated and bounded manual review matrix. | Phase 3 |
| [5 - Reproducible Candidate And Clean Consumer Trial](./phase-05-reproducible-candidate-and-clean-consumer-trial.md) | Build the internal 0.1.0 candidate reproducibly and consume it from an isolated Phoenix fixture. | Phase 4 |
| [6 - Versioned Publication And Milestone Acceptance](./phase-06-versioned-publication-and-milestone-acceptance.md) | Preserve deterministic static evidence, operate the immutable Fly release, and reconcile every final gate truthfully. | Phase 5 |

Each phase contains four sections, eight tasks and twenty-four subtasks. Every
phase, section and task starts with a description; Section 4 is always the
phase's integration-test section. Delivery uses one commit per completed section
and one PR per phase.

## Resolved boundaries

- The existing categories and routes remain stable; metadata augments them.
- The catalogue is an authored demo/build inventory, not a package registry.
- Search filters a complete server-rendered link inventory and remains optional.
- Theme, copy, search and test helpers are demo-only and never component behavior.
- Exact Chromium, Firefox and WebKit builds provide evidence, not product targets.
- Electron and other embedded consumers validate their own environment.
- Controller examples may execute; Dstar and LiveView remain dependency-free
  integration guidance around the same stateless HEEX API.
- The candidate is internal `0.1.0`; Hex publication and a public tag are deferred.
- Local, CI, merge, deploy, post-deploy, manual review and consumer-trial states
  are separate. No unchecked state may be reported as complete.

## Delivery rules

1. Start each phase from synchronized `main` on a `codex/` feature branch.
2. Complete sections in order, verify each section, and commit once per section.
3. Update checkboxes only when implementation and evidence exist.
4. Preserve stable Milestones A-E routes and acceptance suites.
5. Open one PR after a complete phase; do not merge without a later request.
6. Change ADRs or specifications before implementation if evidence changes a
   durable choice or normative requirement.

## Milestone exit

Milestone F exits only after all 38 requirements have real evidence, the public
inventory and documentation are complete, exact-engine and fallback acceptance
passes, required manual and deployed gates are executed, the actual archive is
audited, an isolated consumer successfully exercises the internal candidate,
and the deployed source passes review.
Public Hex publication remains outside this milestone.
