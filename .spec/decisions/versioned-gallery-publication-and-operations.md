---
id: shadcn_ui.versioned_gallery_publication
status: accepted
date: 2026-08-27
affects:
  - shadcn_ui.release_publication
  - shadcn_ui.documentation_catalogue
  - shadcn_ui.gallery
---

# Publish Immutable Gallery Evidence With Explicit Operations

## Context

The gallery is already a deterministic static export published through GitHub
Pages. Release acceptance needs a trustworthy answer to which package and source
revision a deployed page describes, without putting secrets or mutable runtime
state into the site or confusing a merged commit with a successful deployment.

## Decision

Gallery publication uses immutable build metadata and an explicit operational
state model.

- The canonical site remains the reviewed GitHub Pages deployment unless a
  later decision changes hosting. Pull requests verify artifacts; reviewed main
  publishes them through the repository workflow.
- Export records the package version, full source revision, catalogue schema
  version, upstream provenance revision and deterministic asset identities from
  validated build inputs. It does not shell out or query Git at package runtime.
- A local release manifest and health document expose only non-secret immutable
  metadata and known static routes/assets. They contain no credentials,
  environment secrets, mutable user data or remote runtime dependency.
- Repeated exports from identical inputs are byte-identical. Canonical URLs,
  direct routes, repository-subpath assets, search data, health data and error
  handling are smoke-tested before publication.
- Local verification, CI verification, merge, deployment and post-deployment
  smoke are separate recorded states. No earlier state implies a later one.
- The runbook names workflow ownership, configuration, rollback to a previously
  verified artifact and recovery checks. Credentials remain in the hosting
  platform, never in source or exported files.

## Consequences

Visitors and maintainers can identify the exact source represented by the site,
and deployment failure cannot be hidden by a successful local export. Publishing
remains outside the runtime package and is recoverable without rebuilding an
unknown working tree.
