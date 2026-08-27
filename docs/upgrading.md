# Versioning, deprecation, migration, and rollback

ShadcnUI is currently qualifying an internal `0.1.0` candidate. It is not
publicly available on Hex, has no authorized public tag, and remains subject to
internal `0.x` change. Passing local tests is not proof of CI, clean-consumer
qualification, gallery deployment, post-deploy smoke, manual review, or public
availability.

## Version and compatibility floors

- `mix.exs` is the authoritative package version.
- `CHANGELOG.md` records consumer-visible changes and migration needs.
- `docs/compatibility.md` defines HTML/CSS capability floors and fallbacks.
- `RELEASE.md` records candidate evidence and explicitly pending gates.
- The package supports Elixir `~> 1.17` and the dependency ranges in `mix.exs`;
  an actual consumer must verify its locked Elixir, OTP, Phoenix, and renderer.

Until a stable public policy is accepted, every reviewed revision is pinned by
commit SHA. Do not depend on a mutable branch.

## Deprecation policy

A public component, attr, slot, closed value, semantic contract, token, or
fallback cannot disappear silently. A deprecation must:

1. be documented in the changelog and this guide;
2. preserve a warning-backed compatibility path for an explicitly stated
   internal window when technically safe;
3. include compile, semantic, fallback, gallery, and consumer evidence;
4. identify the replacement and rollback revision;
5. receive a version decision before removal.

A raised browser capability floor or new package runtime additionally requires
an accepted ADR and specification change.

## Upgrade procedure

1. Review `CHANGELOG.md`, this guide, capability manifests, and provenance
   changes between the old and proposed commits.
2. Pin the proposed full commit SHA in a branch of the consuming application.
3. Recopy or rebundle `ShadcnUI.stylesheet_path()`; do not mix component source
   from one revision with CSS from another.
4. Compile with warnings as errors and run the consumer's server, browser,
   fallback, accessibility, CSP, and embedded-environment tests.
5. Review application-owned state/replacement behavior for changed components.
6. Promote only the exact verified revision and retain the previous lock and
   artifact for rollback.

There is no migration from an earlier public ShadcnUI release yet. The current
candidate consolidates Milestones A–E under the same `0.1.0` internal scope.

## Version decisions for future changes

After `0.1.0` is internally qualified, removing or incompatibly changing a
public component, attr, slot, closed value, semantic/fallback contract, token,
CSS selector contract, capability floor, runtime boundary, or archive path
requires a new internal minor candidate such as `0.2.0`, a migration record,
and explicit rollback evidence. A compatible public addition also requires an
internal minor decision; a compatible correction may use a patch decision.
Before qualification, `0.1.0` may be rebuilt only when every prior candidate
record is explicitly superseded and no consumer is told that the bytes are the
same. Exact commit and archive hashes remain authoritative.

Documentation-only wording does not by itself change the package version, but
documentation that changes a promised contract is not documentation-only.
Once a stable public-version policy exists, normal Semantic Versioning rules
supersede this internal `0.x` convention. No breaking change may be hidden under
an already-qualified archive identity.

## Rollback

Restore the previous reviewed commit in the consumer lock, restore its matching
compiled stylesheet, rebuild the consuming artifact, and rerun its smoke tests.
Do not edit an archive, cached stylesheet, or deployed gallery artifact in
place. The package revision and independently deployed gallery may be rolled
back separately. A server-rendered application also owns database or domain
migrations; this UI package performs none.
