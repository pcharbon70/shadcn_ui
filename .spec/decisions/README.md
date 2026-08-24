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
