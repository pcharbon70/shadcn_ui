# Public `1.0.0` preliminary qualification evidence

## Section 2.1 - Preliminary clean candidates

Two independent clean builds from exact revision
`71d0edba92755f9d273765db79e1176255a4b365` completed with the manifest-pinned
toolchain. Both produced `shadcn_ui-1.0.0.tar` as a 90,112-byte archive with
SHA-256
`547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da`.

The comparison passed for source identity, locked-input hash, provenance,
compiled CSS, gallery export, generated documentation, and unpacked archive
inventory. Both candidates contain 63 allowlisted entries, 646 gallery files,
and 147 documentation files. Their compiled stylesheet SHA-256 is
`ed0768e9582e980f3fd1b3ca0076afc573fc269514f527aef9dc942d1f8e9f41`.
The archive audit found the required MIT license, third-party notices,
documentation, compiled stylesheet, public modules, compatibility/provenance
data, and Mix metadata, with no unexpected entry.

The candidate builder runs the gallery export under `MIX_ENV=test`. This keeps
development-only tooling such as the Tidewave toolbar out of the static
artifact while leaving ExDoc generation in the root development environment.

## Section 2.2 - Preliminary isolated consumption

The disposable consumer installed one of those exact archives through a local
signed Hex repository as `{:shadcn_ui, "== 1.0.0", repo: "candidate"}`. It did
not use a path dependency and ran outside the source tree. The fresh Phoenix
application compiled the package and representative controller HEEx, passed 3
consumer tests, served the packaged stylesheet, and passed its browser
interaction check.

The consumer required no consumer Node installation, Tailwind build, remote
runtime asset, or package JavaScript. Its recorded archive SHA-256 equals the
two-build comparison checksum above, preventing attribution to a different
archive.

Generated archives, complete inventories, build records, documentation output,
and disposable-consumer output remain in the operator-controlled external
evidence directory and are not committed. The compact non-secret result and
checksums are recorded in `release/preliminary-candidate-evidence.json` and are
intended for the Phase 2 pull request description.

These results are preliminary. They do not select `RELEASE_SHA`, satisfy the
final `clean-candidate` or `actual-archive-consumer` gates, publish to Hex,
create `v1.0.0`, or claim qualification. Section 2.3 and every later release
phase remain independently gated.
