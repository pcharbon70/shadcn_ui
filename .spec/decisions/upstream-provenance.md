---
id: shadcn_ui.upstream_provenance
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.package
  - shadcn_ui.provenance
  - shadcn_ui.foundation_components
  - shadcn_ui.gallery
---

# Track Upstream Provenance Without Automatic Synchronization

## Context

Unscripted/ui is an MIT-licensed source of HTML, Tailwind utility patterns, and
fallback research, but it is a copy-paste project rather than a versioned runtime
dependency. Its documentation and source can change independently, and ShadcnUI
will adapt markup into different APIs with additional Phoenix and accessibility
requirements.

## Decision

ShadcnUI records provenance for substantially adapted upstream material.

- `THIRD_PARTY_NOTICES.md` preserves the unscripted/ui MIT copyright and license
  notice and identifies the reviewed repository URL and exact commit.
- A package-owned provenance manifest maps each adapted component or CSS block
  to its upstream path and pinned commit plus a concise local-change summary.
- Upstream source is reviewed and copied deliberately; it is not a runtime,
  build-time Git dependency, submodule, generated vendor directory, registry, or
  automatic synchronization target.
- Local semantics, API decisions, tests, and browser-support policy take
  precedence over later upstream changes.
- Demo images, remote fonts, analytics, documentation-site scripts, and other
  site-only material are not copied into release contents.
- Documentation describes ShadcnUI as an independent Phoenix adaptation, not an
  official shadcn or unscripted/ui package.

## Consequences

Every adapted implementation remains auditable and legally attributable. An
upstream update becomes an explicit reviewed change that can preserve local API
compatibility instead of silently altering generated output.
