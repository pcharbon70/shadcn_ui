# Public `1.0.0` Hex publication

## Section 5.1 - Final dry run

At `2026-09-05T09:10:02Z`, a fresh detached checkout at immutable
`RELEASE_SHA aa6a2d35474a51ea63248131631ace2b113b99a4` completed locked setup,
the full candidate build, actual archive audit, and the installed Hex client's
supported publish dry run. The retained checkout has no tracked change and
remains outside the repository for an explicitly authorized publication only.

The rebuilt 90,112-byte, 63-entry archive is byte-identical to the approved
Phase 4 archive at SHA-256
`547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da`.
Its candidate-build record, archive inventory, compiled CSS, documentation,
gallery export, input manifest, and provenance identities also match the final
packet.

`mix hex.publish --dry-run --yes` passed without publishing. The reviewed
payload is public package `shadcn_ui 1.0.0`, owned by authenticated personal
Hex identity `pcharbon70` with no organization override, built with Mix for
Elixir `~> 1.17`. It declares MIT, the expected description and Gallery/GitHub
links, and only `phoenix_html ~> 4.1` and `phoenix_live_view ~> 1.2` as package
dependencies. The exact 63-file archive inventory is checksum-bound, and the
dry run generated HTML, text, and EPUB documentation.

A public registry query after the completed dry run still returned
`No package with name shadcn_ui`. Section 5.1 therefore passes, but neither
this dry run nor the request to implement Phase 5 authorizes publication.
Section 5.2 remains pending until the release owner explicitly authorizes the
exact command and `RELEASE_SHA`; `mix hex.publish`, Hex publication, and the
public tag remain unexecuted.

### Non-qualifying operator diagnostics

The first temporary checkout was discarded after an incorrectly positioned
Mix task option left demo dependencies unavailable at gallery export. In the
replacement checkout, an unsupported global Mix working-directory option was
corrected before the candidate build by running dependency setup from the demo
directory, as the repository runner does. The first no-TTY dry-run invocation
also stopped at Hex's confirmation prompt; the registry absence check passed
before the completed `--dry-run --yes` execution. None of these attempts
mutated Hex or tracked source, and none is treated as qualifying proof.

## Section 5.2 - Irreversible-action authorization

At `2026-09-05T13:18:03Z`, the release owner received the exact authorization
packet and replied `yes you are authorized` in the Codex task. The authorization
binds one execution of `mix hex.publish --yes` to public repository `hexpm`,
personal owner `pcharbon70`, no organization override, package
`shadcn_ui 1.0.0`, immutable
`RELEASE_SHA aa6a2d35474a51ea63248131631ace2b113b99a4`, and archive SHA-256
`547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da`.

Section 5.2 therefore passes. Authorization covers the package and generated
documentation only; it does not authorize a public tag, marketplace listing,
platform certification, or upstream-affiliation claim. At this record point,
the authorized command has not run, so Hex publication and the public tag
remain pending.

## Section 5.3 - Blocked publication attempt

The one authorized `mix hex.publish --yes` attempt began at
`2026-09-05T13:24:17Z` from the retained clean detached checkout. It rebuilt
the reviewed package and documentation, then Hex requested an OTP code. The
non-interactive process received EOF and exited `1` at `2026-09-05T13:24:18Z`.
No retry was attempted.

Immediate `mix hex.info shadcn_ui 1.0.0` and `mix hex.info shadcn_ui` queries
reported no release and no package. At `2026-09-05T13:25:38Z`, the public Hex
API also returned HTTP `404` for `https://hex.pm/api/packages/shadcn_ui`.
Section 5.3 is therefore blocked, not passed: no registry mutation is observed,
the package remains unpublished, and the public tag remains unauthorized.

The one-attempt authorization is consumed. A retry requires fresh explicit
authorization for the same immutable release plus secure interactive OTP entry.
Never use `--replace`, and do not create the public tag before Phase 6 verifies
the eventual public package and documentation.
