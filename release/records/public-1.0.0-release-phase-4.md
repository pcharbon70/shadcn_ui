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
