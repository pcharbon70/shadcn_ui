---
id: shadcn_ui.gallery_static_publication
status: superseded
date: 2026-08-24
superseded_by: shadcn_ui.fly_gallery_publication
affects:
  - shadcn_ui.package
  - shadcn_ui.gallery
  - shadcn_ui.stylesheet
  - shadcn_ui.provenance
---

# Keep the Gallery Separate and Publish a Static Export

## Context

Milestone A needs a realistic Phoenix consumer and a public reference site, but
the gallery does not need server state or application behavior. Shipping a
Phoenix endpoint inside ShadcnUI would expand the runtime package, while tying
the package architecture to a hosting vendor would make local verification and
future relocation harder.

## Decision

The gallery is a separate Phoenix application under `demo` that consumes
ShadcnUI through a path dependency and renders ordinary controller HEEx.

- The demo defines no LiveView routes, sockets, hooks, state processes, Ecto,
  Dstar, Datastar, Ash, authentication, or Electron capability integration.
- One immutable authored catalogue maps stable category and component slugs to
  explicit render identities. Request text never becomes an atom, module,
  template, function, or asset path.
- Every component receives a stable route, practical description, HEEX example,
  accessibility guidance, ownership boundary, theme coverage, and fallback
  notes.
- A deterministic export command requests the closed route inventory from the
  local controller-rendered application and writes self-contained static HTML
  and local fingerprinted assets to ignored output.
- CI publishes that static artifact to an approved HTTPS static host. The host,
  canonical URL, credentials, and rollback are deployment configuration rather
  than runtime package concerns.
- Small theme persistence or source-copy behavior may exist in an explicit
  demo-only script. Core navigation, content, examples, and theme defaults remain
  usable without it, and the script is excluded from package contents.
- Demo source, dependencies, generated assets, export output, and deployment
  configuration are excluded from the ShadcnUI release allowlist.

## Consequences

The local gallery proves real Phoenix consumption while the public site is cheap,
portable, and does not require a long-running Phoenix service. Interactive
server examples in later milestones require a separate decision rather than
silently changing the publication model.
