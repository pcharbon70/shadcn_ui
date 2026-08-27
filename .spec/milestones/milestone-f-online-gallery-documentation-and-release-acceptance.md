# Milestone F - Online Gallery, Documentation, and Release Acceptance

## Description

Milestone F completes the online gallery as the public reference for ShadcnUI
and turns the accumulated milestone work into a releasable package. It emphasizes
plain-language documentation, verifiable examples, provenance, accessibility,
browser compatibility, deterministic assets, and deployment reliability.

## Intended outcomes

- Every public component has one stable online route, a rendered preview,
  copyable HEEX usage, API documentation, semantics, ownership boundaries,
  browser assumptions, and fallback behavior.
- The gallery is useful on desktop, mobile, keyboard-only, and the exact locked
  web engines used as reproducible evidence.
- Package documentation and the gallery derive their component inventory from a
  checked, deterministic catalogue rather than drifting hand-maintained lists.
- A release candidate can be built and verified without network-fetched runtime
  assets or undocumented consumer tooling.

## Gallery information architecture

- Categorized left navigation with a mobile equivalent.
- Searchable component catalogue and one page per public component.
- Existing Foundation, Forms, Disclosure, Navigation, Content Surfaces,
  Overlays, Interactive Surfaces, Media, and Motion categories without route or
  category renames.
- Stable deep links to components and individual examples.
- Light and dark theme selection, responsive previews, reduced-motion
  inspection, and compatibility/fallback presentation.
- Preview and HEEX source views with optional demo-only copy behavior.
- Plain-language sections for “What it is,” “When to use it,” “What the
  application owns,” “Accessibility,” and “Browser fallback.”
- Package version, full build revision, upstream provenance, catalogue schema,
  and exact web-evidence revision displayed on the site.

## Documentation and release scope

- Complete README installation, stylesheet delivery, theming, component import,
  CSP, browser support, and upgrade guidance.
- ExDoc module groups, component API examples, changelog, and migration notes.
- Controller-rendered Phoenix examples plus integration guidance for Dstar and
  LiveView that does not make either a package dependency.
- License and third-party notice audit for adapted unscripted/ui material.
- Deterministic CSS build and package-content audit.
- Versioned gallery deployment with health and asset smoke checks.
- An internal `0.1.0` release candidate and documented release procedure.

## Architecture work required

- Decide the online hosting platform, deployment ownership, canonical URL,
  environment configuration, and rollback process.
- Define how the catalogue metadata drives navigation, documentation checks,
  completeness assertions, and release contents without becoming a runtime
  component registry.
- Define demo-only JavaScript boundaries for theme persistence, source copying,
  and test controls; none may silently become required component behavior.
- Establish a consumer-neutral capability and web-engine evidence policy,
  including when newer CSS features may be adopted or capability floors raised.

## Verification expectations

- Package-local precommit, SpecLed validation, ExDoc, package build, and package-
  content checks pass from a clean checkout.
- Every catalogue entry resolves to a public component, documentation page,
  source example, rendering test, and browser acceptance route.
- Cross-browser Playwright coverage checks navigation, themes, reduced motion,
  responsive layouts, focus visibility, critical interactions, and fallbacks.
- A clean Phoenix consumer trial verifies package installation, stylesheet
  delivery, public imports, and representative controller-rendered HEEX.
- Automated accessibility tools are combined with explicit keyboard, semantics,
  zoom, contrast, and screen-reader-oriented checks.
- Deployment smoke tests verify the canonical site, assets, direct links, error
  handling, and current version metadata.

## Exit criteria

Milestone F is complete when the package and online gallery can be built from a
clean checkout, every public API has verified documentation and examples, the
supported compatibility matrix passes, provenance and licenses are complete,
and the internal `0.1.0` release candidate is ready for a real consumer trial.

ShadcnUI makes no Electron or other embedded-consumer support claim. Consumer
applications own their pinned renderer, shell, CSP, transport, and deployment
validation.

## Accepted contracts and implementation plan

- [Milestone F decisions](../decisions/README.md#milestone-f-decisions)
- [Milestone F specifications](../specs/README.md#milestone-f-planned-contracts)
- [Phased implementation plan](../planning/milestone-f-online-gallery-documentation-and-release-acceptance/README.md)

## Deferred work

A public Hex release, a component marketplace, automated upstream synchronization,
multiple branded theme catalogues, a source-copy CLI, and new component families
require separately accepted follow-on milestones.
