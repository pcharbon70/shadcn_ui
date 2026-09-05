# Versioning, deprecation, migration, and rollback

ShadcnUI `1.0.0` is its first public Hex release. The package and generated
documentation are publicly available; the public source tag remains a separate
release gate. Passing local tests is not proof of CI, clean-consumer
qualification, gallery deployment, post-deploy smoke, manual review, or public
availability.

## Version and compatibility floors

- `mix.exs` is the authoritative package version.
- `CHANGELOG.md` records consumer-visible changes and migration needs.
- `docs/compatibility.md` defines HTML/CSS capability floors and fallbacks.
- `RELEASE.md` records candidate evidence and explicitly pending gates.
- The package supports Elixir `~> 1.17` and the dependency ranges in `mix.exs`;
  an actual consumer must verify its locked Elixir, OTP, Phoenix, and renderer.

Consumers should use the published dependency `{:shadcn_ui, "~> 1.0"}` and
commit their lockfile. Source-based evaluation should pin a full commit SHA,
never a mutable branch.

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
   changes between the installed and proposed versions.
2. Select the proposed semantic version in a branch of the consuming
   application and commit the resulting lockfile.
3. Recopy or rebundle `ShadcnUI.stylesheet_path()`; do not mix component source
   from one revision with CSS from another.
4. Compile with warnings as errors and run the consumer's server, browser,
   fallback, accessibility, CSP, and embedded-environment tests.
5. Review application-owned state/replacement behavior for changed components.
6. Promote only the exact verified revision and retain the previous lock and
   artifact for rollback.

There is no migration from an earlier public ShadcnUI release. Version `1.0.0`
establishes the initial stable public API from the component work completed in
Milestones A–E.

## Version decisions for future changes

After `1.0.0`, removing or incompatibly changing a public component, attr,
slot, closed value, semantic/fallback contract, token, CSS
selector contract, capability floor, runtime boundary, or archive path requires
a new major version, migration guidance, and explicit rollback evidence. A
backward-compatible public addition increments the minor version; a
backward-compatible correction increments the patch version. Before any future
version is published, its target may be rebuilt only when
prior candidate evidence is explicitly superseded and no consumer is told that
different bytes share the same published identity. Exact commit and archive
hashes remain authoritative.

Documentation-only wording does not by itself change the package version, but
documentation that changes a promised contract is not documentation-only.
Version `1.0.0` adopts normal Semantic Versioning rules. No breaking change may
be hidden under an already-published archive identity.

## Rollback

Restore the previous reviewed commit in the consumer lock, restore its matching
compiled stylesheet, rebuild the consuming artifact, and rerun its smoke tests.
Do not edit an archive, cached stylesheet, or deployed gallery artifact in
place. The package revision and independently deployed gallery may be rolled
back separately. A server-rendered application also owns database or domain
migrations; this UI package performs none.
