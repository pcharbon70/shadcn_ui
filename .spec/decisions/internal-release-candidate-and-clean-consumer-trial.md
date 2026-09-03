---
id: shadcn_ui.internal_release_candidate
status: superseded
date: 2026-08-27
superseded_by: shadcn_ui.public_hex_1_0_release
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
- Qualification retains every applicable historical package and gallery
  regression in pull-request CI. Presentation migrations update those tests to
  stable semantic hooks and current accepted workflows rather than dropping a
  stale gate.
- A disposable clean Phoenix consumer installs the candidate through a local
  archive or immutable repository reference, imports public components, serves
  the packaged stylesheet and compiles representative controller HEEX.
- A disposable clean consumer outside a version manager's directory scope may
  copy the nearest already-active tool-selection file into that temporary
  consumer. The copy is never candidate content, does not select a new version,
  and is removed with the consumer; the separately pinned clean-candidate
  toolchain and CI environments with direct toolchains remain unchanged.
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
