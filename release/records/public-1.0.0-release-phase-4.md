# Public `1.0.0` exact-release qualification

## Section 4.1 - Reproduce `RELEASE_SHA`

The clean controlling checkout selected
`aa6a2d35474a51ea63248131631ace2b113b99a4` as the unchanged `RELEASE_SHA` and
ran the candidate builder twice through separate detached temporary worktrees
and output directories. Both runs used Elixir `1.20.3`, OTP `29.0.5`, ERTS
`17.0.5`, Mix `1.20.3`, Hex `2.5.1`, Node `22.13.1`, npm `10.9.2`, locked
dependencies, and the reviewed rebar3 binary at SHA-256
`8dead71212b8008ec830c085607c23ec2997ab1c36a3c91901ac42c9814ee08c`.

Both complete build records are equivalent. Each generated and independently
audited its own 90,112-byte, 63-entry `shadcn_ui-1.0.0.tar`; the archives are
byte-identical at SHA-256
`547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da`.
The input-manifest, provenance, compiled CSS, 147-file documentation inventory,
and 646-file gallery inventory also match exactly.

The complete generated records and archives remain uncommitted in the
operator-controlled external evidence directory recorded in
`release/public-release-phase-4.json`. Both temporary worktrees were removed;
the controlling checkout remained clean. This passes the final clean-candidate,
exact-reproducibility, and archive-audit boundary. It does not satisfy the
separate final isolated-consumer gate in Section 4.2.

## Section 4.2 - Consume the final archive

The consumer harness selected build A's final archive and verified that its
SHA-256 exactly matches the two-build comparison:
`547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da`.
It installed `shadcn_ui 1.0.0` through a disposable signed Hex repository—not a
path dependency—and confirmed installed package metadata outside the source
tree.

The external Phoenix consumer compiled, passed all 3 tests, exercised native
focus and dialog behavior in Chromium, and served the packaged stylesheet. It
required no consumer Node or Tailwind toolchain, package JavaScript, source
module visibility, or remote runtime asset. The disposable consumer and all
temporary worktrees were removed; only `consumer/consumer-trial.json` remains
in the external evidence directory, bound by record SHA-256
`fd8851bc239c2a40ee996eeed0fca52f63935a6bad99d393e6a1fb79bd3dabb6`.

The final clean-consumer gate now passes. Hex publication and the public tag
remain pending, and Section 4.3 must still assemble and verify the go/no-go
packet before publication authorization can be requested.

## Section 4.3 - Final go/no-go packet

At `2026-09-04T16:49:27Z`, the canonical Fly smoke passed again for public
gallery version `1.0.0` and recorded deployed revision
`8654f6a4500ce210682d7cae7453553d878a714c`. Phase 1 found no later package,
compiled-CSS, gallery-runtime, asset, dependency, or version-identity change,
so no replacement Fly deployment is required. A fresh official Hex client
query returned `No package with name shadcn_ui`.

`release/public-release-phase-4.json` is the immutable go/no-go packet. It
checksum-links the Phase 1 preflight, the unperformed independent-review
waiver, exact-`RELEASE_SHA` CI, both final build records, byte-identical archive
comparison, both archive inventories, final isolated-consumer record, Fly
deployment record, and manual-accessibility waiver. Its exact identities are:

- `RELEASE_SHA`:
  `aa6a2d35474a51ea63248131631ace2b113b99a4`
- approved archive SHA-256:
  `547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da`
- main CI run/job: `33881762954` / `101051845295`
- build-record SHA-256, both builds:
  `38191c0d7e2a64b73a73065e0e354585ab588e2b8cd68a4157d036224e9d4aa2`
- build-comparison SHA-256:
  `8877133464c00f29e4e32ab661779ed2ec36cd46c6f06c82a67118e6412eb2fa`
- archive-inventory SHA-256, both builds:
  `cb37a252e3948973e6dcc9cb3a07cb45614c9a7bd35632e6c0ccd1515d536a8d`
- consumer-record SHA-256:
  `fd8851bc239c2a40ee996eeed0fca52f63935a6bad99d393e6a1fb79bd3dabb6`

All 15 mandatory gates before publication and tagging pass. The packet found no
stale, missing, contradictory, or SHA-mismatched evidence. Independent review
is `waived`, non-mandatory, and not an approval; manual accessibility is also
`waived`, non-mandatory, and unassessed.

The decision is **go to the Phase 5 dry run and explicit publication-
authorization request**. It is not authorization to run `mix hex.publish`, and
it does not mark Hex publication or the public tag complete. Both gates remain
pending and the release remains unpublished.
