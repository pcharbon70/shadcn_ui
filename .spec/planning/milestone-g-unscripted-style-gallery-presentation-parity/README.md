# Milestone G - Unscripted-Style Gallery Presentation Parity

## Status and purpose

This implementation record sequences the high-fidelity gallery presentation
work described by the [Milestone G roadmap](../../milestones/milestone-g-unscripted-style-gallery-presentation-parity.md).
All eight phase implementations and local automated evidence have landed. Phase
8 remains open because the deployed Fly branch has no pull request, final CI, or
merge, and six manual accessibility scenarios remain pending. The release owner
accepted that manual-review risk for R6 progression on 2026-09-03 without
promoting it to a pass or final qualification. The work changes the separate
demo and its evidence, not the transport-neutral component model.

Phase 1 accepted the additional durable decision and current-truth requirements
before later implementation phases proceeded. Existing Milestones A-F
decisions, specifications, and completed history remain authoritative.

## Existing architecture and contracts

The plan preserves these accepted decisions:

1. [Compile isolated CSS as a package-owned build artifact](../../decisions/isolated-compiled-css.md)
2. [Scope semantic tokens and theme selection](../../decisions/scoped-theme-token-contract.md)
3. [Track upstream provenance without automatic synchronization](../../decisions/upstream-provenance.md)
4. [Drive documentation from a closed catalogue and keep demo tooling progressive](../../decisions/catalogue-driven-documentation-and-progressive-demo-tooling.md)
5. [Publish the stateless gallery application on Fly.io](../../decisions/fly-gallery-application-publication.md)

The existing [gallery](../../specs/gallery.spec.md),
[documentation catalogue](../../specs/documentation_catalogue.spec.md),
[public documentation](../../specs/public_documentation.spec.md),
[compatibility and accessibility](../../specs/compatibility_accessibility.spec.md),
[stylesheet](../../specs/stylesheet.spec.md),
[provenance](../../specs/provenance.spec.md) and
[release publication](../../specs/release_publication.spec.md) specifications
continue to apply. Phase 1 supplied the additive decision, specification, and
coverage-map work required for Milestone G.

## Ordered phases

| Phase | Delivery | Dependency |
| --- | --- | --- |
| [1 - Parity Contract And Reference Baseline](./phase-01-parity-contract-and-reference-baseline.md) | Pin upstream presentation truth, accept visual and semantic boundaries, audit local assets and establish deterministic reference evidence. | Milestone F evidence |
| [2 - Responsive Documentation Shell](./phase-02-responsive-documentation-shell.md) | Deliver the compact header, constrained grid, persistent catalogue, progressive search placement, mobile navigation and secondary build metadata. | Phase 1 |
| [3 - Gallery Presentation System](./phase-03-gallery-presentation-system.md) | Establish gallery-only typography, prose, badges, specimen, code, table and metadata primitives. | Phase 2 |
| [4 - Component Page Information Architecture](./phase-04-component-page-information-architecture.md) | Reorder component documentation around introductions, paired Preview/Code specimens, explanation, accessibility, support, ownership and provenance. | Phase 3 |
| [5 - Accordion Vertical Pilot](./phase-05-accordion-vertical-pilot.md) | Prove the complete target system and acceptance matrix on independent and exclusive Accordion examples. | Phase 4 |
| [6 - Closed Catalogue Presentation Metadata](./phase-06-closed-catalogue-presentation-metadata.md) | Add safe authored capability, support, specimen, explanation and exception metadata with deterministic completeness proof. | Phase 5 |
| [7 - Complete Gallery Migration](./phase-07-complete-gallery-migration.md) | Migrate all component families, compositions, category pages, landing and documentation routes in ordered waves. | Phase 6 |
| [8 - Visual Acceptance And Versioned Publication](./phase-08-visual-acceptance-and-versioned-publication.md) | Run the complete visual, semantic, accessibility, export, provenance and publication matrix and reconcile milestone truthfully. | Phase 7 |

## Supplemental remediation

The [live visual review remediation plan](./live-visual-review-remediation.md)
tracks the correctness, pinned-parity, evidence and accessibility work found
during the 2026-09-02 review. It supplements rather than rewrites the
eight-phase implementation record. R1 through R5 and R6.1 are complete; R6.2
through R6.4 remain open until their implementation and proof exist.

Each phase uses sections, tasks and subtasks with a phase-ending integration-test
section. Delivery uses one commit per completed section and one PR per phase.
Checkboxes describe implementation state, not planning completeness.

## Resolved boundaries

- The target is high-fidelity parity with one pinned upstream revision at
  explicit reference viewports, not automatic synchronization with a live site.
- ShadcnUI branding, Phoenix HEEx and accepted local semantics remain
  authoritative; upstream visuals do not silently change component contracts.
- Gallery styles, fonts, icons, highlighting and visual evidence remain demo
  assets and outside the package archive.
- Tailwind remains a package-local build concern. The demo presentation system
  is authored as isolated gallery CSS and consumes the packaged component CSS.
- Search, theme persistence and source-copy feedback remain optional demo
  helpers. They do not implement component state, routing, focus, positioning,
  validation or transport.
- Preview and Code may look like adjacent views but cannot claim a tab contract
  unless a complete separately accepted widget contract is implemented.
- Stable routes, categories, canonical identities and example fragments remain
  intact while visible hierarchy and presentation change.
- Reference captures are checked local evidence. Verification never depends on
  the public upstream site being reachable.

## Delivery rules

1. Start each phase from synchronized `main` on a `codex/` feature branch.
2. Complete sections in order, verify each section and commit once per section.
3. Update checkboxes only when implementation and evidence exist.
4. Preserve all Milestones A-F package, semantic, accessibility and publication
   suites unless an accepted additive requirement deliberately updates them.
5. Use stable semantic and `data-gallery-*` test hooks instead of cosmetic class
   names before replacing shared markup.
6. Open one PR after a complete phase; do not merge or publish without a later
   authorized request.
7. Change decisions or specifications before implementation if evidence alters
   a durable choice or normative requirement.

## Milestone exit

Milestone G exits only after all public gallery routes use the accepted
presentation system, the locked visual matrix passes, every catalogue entry has
complete presentation metadata or an explicit exception, all A-F regressions
and package boundaries remain green, provenance and local asset licenses are
current, and the immutable redesigned gallery passes reviewed deployment and
rollback smoke. A polished Accordion pilot or completed migration plan alone
does not complete the milestone.
