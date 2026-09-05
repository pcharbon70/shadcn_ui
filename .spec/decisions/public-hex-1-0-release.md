---
id: shadcn_ui.public_hex_1_0_release
status: accepted
date: 2026-09-03
supersedes:
  - shadcn_ui.internal_release_candidate
affects:
  - shadcn_ui.release_publication
  - shadcn_ui.public_documentation
  - shadcn_ui.package
---

# Promote The First Public Hex Release To 1.0.0

## Context

The internal `0.1.0` candidate established the complete component catalogue,
package boundary, documentation, compatibility policy, clean-consumer harness,
and release evidence model. The package is now being prepared for its first
public Hex publication, and the maintainer has selected a stable version rather
than publishing the historical internal candidate number.

## Decision

The first public Hex release target is `1.0.0`.

- `mix.exs` is the authoritative version. Current consumer documentation,
  package metadata, gallery build identity, the clean-consumer fixture, and
  release-target status must agree with it.
- A public gallery deployed for that release target must use the same version
  in its Phoenix release metadata and repository-owned npm metadata, and must
  report that version through health and rendered identity. Canonical smoke
  treats any mismatch as a failed deployment that must be superseded before
  Hex publication.
- `1.0.0` establishes the initial stable public component, stylesheet,
  fallback, runtime-boundary, and package contracts. Later releases follow
  Semantic Versioning.
- The historical `0.1.0` archives, deployments, hashes, and acceptance records
  remain historical evidence. They are not relabelled or treated as proof for
  `1.0.0`.
- Selecting the version does not publish it. The `1.0.0` archive,
  clean-consumer trial, exact-source reproducibility, review, final-revision CI,
  merge, matching gallery identity, Hex publication, and public tag remain
  separately recorded gates.
- Evidence recorded after selecting `RELEASE_SHA` shall bind its full source
  revision and artifact checksums without replacing that immutable package
  source. Generated archives, build inventories, and disposable-consumer output
  remain outside tracked source; committed summaries record their identities
  and separate gate outcomes.
- Final consumer evidence shall install the approved archive by its recorded
  checksum in an isolated project. A passing trial for a different archive,
  path dependency, or source checkout does not satisfy the public-release gate.
- A complete prepublication go/no-go packet may authorize only the final dry
  run and the request for irreversible-action approval. It does not authorize
  `mix hex.publish`, create a public version tag, or mark either gate passed.
- The final Hex dry run shall execute from the detached `RELEASE_SHA`, reproduce
  the approved archive checksum, review the authenticated owner and exact
  package metadata, and recheck public absence. Passing it is evidence for an
  authorization request, never publication authorization itself.
- Explicit publication authorization shall bind the exact publish command,
  `RELEASE_SHA`, archive checksum, package version, repository, organization,
  and owner. It authorizes one package-and-documentation attempt only and does
  not authorize a public tag or any adjacent distribution claim.
- The published README shall use explicit versioned HexDocs destinations for
  package guides and explicit GitHub destinations for repository-only content.
  Repository-relative guide or demo links are not portable to the Hex package
  renderer and shall not be used in the public README.
- Hex publication does not create a marketplace listing, certify a consumer
  platform, or imply official shadcn/ui or unscripted/ui affiliation.

## Consequences

Consumers receive a conventional stable starting point and a clear SemVer
policy. Release preparation must regenerate evidence under the new version and
may not promote earlier candidate results merely by changing their version
labels.
