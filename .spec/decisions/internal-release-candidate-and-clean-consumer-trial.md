---
id: shadcn_ui.internal_release_candidate
status: accepted
date: 2026-08-27
affects:
  - shadcn_ui.release_publication
  - shadcn_ui.public_documentation
  - shadcn_ui.package
  - shadcn_ui.provenance
---

# Qualify An Internal Release Candidate Through A Clean Consumer Trial

## Context

Milestones A-E produced the package surface, but release readiness cannot be
proved only from the repository that builds it. Milestone F needs a reproducible
internal `0.1.0` candidate, complete notices and a real consumer exercise while
public Hex publication remains deferred.

## Decision

The first candidate is an internal `0.1.0` release qualified from a clean
checkout and an isolated consumer fixture.

- The candidate uses the explicit package allowlist and includes only required
  runtime modules, compiled CSS, Mix metadata, README, changelog, migration
  guidance and legal notices.
- Locked Mix and npm inputs rebuild CSS, ExDoc, deterministic gallery output and
  the actual package archive without network-fetched runtime assets or a
  consumer Node/Tailwind toolchain.
- A disposable clean Phoenix consumer installs the candidate through a local
  archive or immutable repository reference, imports public components, serves
  the packaged stylesheet and compiles representative controller HEEX.
- Dstar and LiveView guidance is checked for transport-neutral accuracy without
  installing either as a ShadcnUI dependency or making the clean trial an
  application framework certification.
- Version, changelog, migration, deprecation and compatibility-floor rules are
  reviewed before qualification. A failed mandatory gate blocks the candidate;
  manual and deployed gates remain explicitly pending until executed.
- Milestone F does not publish to Hex, create a marketplace, tag a public
  release or grant a consumer platform support claim. Those actions require
  separate authorization and accepted follow-on scope.

## Consequences

The team can test what an actual consumer receives and declare a bounded
internal candidate without prematurely claiming public availability. Release
contents, tooling assumptions and unresolved gates remain visible and auditable.
