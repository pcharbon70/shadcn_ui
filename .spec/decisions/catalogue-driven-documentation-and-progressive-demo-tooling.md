---
id: shadcn_ui.catalogue_driven_documentation
status: accepted
date: 2026-08-27
affects:
  - shadcn_ui.documentation_catalogue
  - shadcn_ui.public_documentation
  - shadcn_ui.gallery
---

# Drive Documentation From A Closed Catalogue And Keep Demo Tooling Progressive

## Context

The gallery already has a closed route catalogue, but component navigation,
source examples, public API documentation, search data and release-completeness
checks can drift when they are maintained as unrelated lists. The static gallery
also needs search and source-copy conveniences without turning its demo script
into a component runtime or client router.

## Decision

Milestone F extends one immutable, authored, build-time gallery catalogue into
the documentation inventory.

- Each public defining component maps to one stable category and route, its
  public function identity, authored examples and fragments, documentation
  sections, source, provenance and verification identities.
- Existing category names and routes remain stable. New metadata augments the
  catalogue; it does not rename implemented Milestones A-E history.
- ExDoc groups one authored user guide for each stable gallery category in the
  same sidebar order. Each guide introduces the category and covers every
  mapped control's function, supported options and a compile-checked HEEX
  example without becoming package runtime content.
- Catalogue validation resolves only closed strings to explicit identities.
  Request or search text never creates atoms, modules, functions, templates,
  callbacks, asset paths or executable code.
- Static export derives a deterministic local search document and completeness
  report from the catalogue. The release package contains neither a runtime
  registry nor demo search data.
- Search progressively filters the complete server-rendered catalogue through
  demo-only JavaScript. With scripting disabled, every category and component
  link remains present and usable.
- Demo JavaScript may persist theme choice, copy already-rendered source, filter
  catalogue links and expose bounded test controls. It may not implement
  component state, navigation, focus, positioning, validation or transport.
- Individual examples receive stable authored fragment identifiers. A fragment
  identifies documentation within a stable page; it does not become a second
  component route or dynamic renderer.

## Consequences

One checked inventory can drive navigation, search, documentation parity,
static export, category-oriented ExDoc guidance and release acceptance without
expanding ShadcnUI's runtime API or release archive. Adding or removing a public
component requires an explicit catalogue and proof change. The gallery remains
complete and navigable when optional demo tooling is unavailable.
