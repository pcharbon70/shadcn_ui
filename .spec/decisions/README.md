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
