# Decisions

Store accepted, durable, cross-cutting ShadcnUI decisions here. Expected early
subjects include package boundaries, CSS compilation and isolation, browser
support, optional compatibility behavior, upstream provenance, and gallery
deployment.

Milestone documents may identify decisions that must be made, but they do not
silently accept those decisions.

<!-- covers: spec.workspace.decisions_readme_present -->

## Milestone A decisions

1. [Keep ShadcnUI an independent transport-neutral Phoenix package](./transport-neutral-phoenix-package.md)
2. [Use explicit semantic component APIs and accessibility contracts](./semantic-component-api-and-accessibility.md)
3. [Compile isolated CSS as a package-owned build artifact](./isolated-compiled-css.md)
4. [Scope semantic tokens and theme selection](./scoped-theme-token-contract.md)
5. [Track upstream provenance without automatic synchronization](./upstream-provenance.md)
6. [Adopt progressive enhancement with explicit fallback evidence](./progressive-enhancement-baseline.md)
7. [Keep the gallery separate and publish a static export](./gallery-static-publication.md)

## Milestone B decisions

1. [Normalize Phoenix form fields without owning validation](./form-field-normalization-and-validation-ownership.md)
2. [Make native form accessibility relationships deterministic](./deterministic-native-form-accessibility.md)
3. [Preserve native control and submission semantics](./native-form-control-and-submission-boundary.md)
4. [Enhance select controls through a capability-gated native fallback](./enhanced-select-progressive-boundary.md)

## Milestone C decisions

1. [Use native details for disclosure and grouping](./native-disclosure-and-grouping.md)
2. [Keep navigation destination-based and landmarks explicit](./destination-navigation-and-landmarks.md)
3. [Preserve native scrolling and static content fallbacks](./native-scroll-and-sticky-surfaces.md)
4. [Name radio-based panel switching honestly and defer true tabs](./radio-panels-not-tabs.md)

## Milestone D decisions

1. [Use the native overlay platform without a package JavaScript runtime](./native-overlay-platform-and-runtime-boundary.md)
2. [Keep Dialog modality, focus, and dismissal native and explicit](./dialog-modality-focus-and-dismissal.md)
3. [Use native Popovers and keep Dropdown Actions out of the ARIA menu contract](./popover-positioning-and-action-semantics.md)
4. [Keep Tooltip and Hover Card supplemental and CSS-first](./supplemental-tooltip-and-hover-card-boundary.md)

## Milestone E decisions

These accept the planned design; component implementation and browser evidence
will land through the Milestone E phases.

1. [Keep motion and media native, capability-based, and runtime-free](./motion-media-capability-and-css-boundary.md)
2. [Keep Carousel and Cover Flow as native scrollable content](./native-carousel-and-cover-flow-semantics.md)
3. [Make decorative motion optional, bounded, and safely duplicated](./bounded-motion-reduced-motion-and-duplication.md)
4. [Keep responsive images caller-owned and reuse native Dialog](./responsive-media-and-native-gallery-lightbox.md)
5. [Deliver each component with its actual gallery page](./incremental-motion-media-gallery-and-acceptance.md)

## Milestone F decisions

These decisions define documentation and internal release qualification. They
add no component family, package runtime, transport or consumer-platform target.

1. [Drive documentation from a closed catalogue and keep demo tooling progressive](./catalogue-driven-documentation-and-progressive-demo-tooling.md)
2. [Keep compatibility and integration guidance consumer-neutral](./consumer-neutral-compatibility-and-integration-guidance.md)
3. [Publish immutable gallery evidence with explicit operations](./versioned-gallery-publication-and-operations.md)
4. [Qualify an internal release candidate through a clean consumer trial](./internal-release-candidate-and-clean-consumer-trial.md)

## Public release decisions

1. [Promote the first public Hex release to 1.0.0](./public-hex-1-0-release.md)
2. [Waive manual accessibility execution for the 1.0.0 release](./waive-manual-accessibility-for-1-0-0.md)
3. [Waive independent source review for the 1.0.0 release](./waive-independent-review-for-1-0-0.md)

## Milestone G decisions

This decision governs presentation work in the separate gallery. It does not
change package component semantics or accept a package runtime.

1. [Pin gallery presentation parity and preserve semantic truth](./pinned-gallery-presentation-parity.md)

## Current gallery publication decision

1. [Publish the stateless gallery application on Fly.io](./fly-gallery-application-publication.md)
