# Public `1.0.0` release preflight

## Section 1.1 - Candidate boundary

Phase 1 started from clean, synchronized `main` at
`42227ebb2892f0b98d0204786c616d0641497c3f` on branch
`codex/public-1-0-0-release-phase-1`. The release target is public Hex package
`shadcn_ui` version `1.0.0`, with `pcharbon70` as release owner and intended
personal Hex account; Section 1.2 records the authenticated identity check.
There is no Hex organization target.

The required independent review method is an approving GitHub review by a
reviewer other than the change author. A merge, comment, local check, or earlier
pull request does not substitute for that approval.

The source-boundary inventory compares deployed revision
`8654f6a4500ce210682d7cae7453553d878a714c` through the synchronized branch base.
It contains 7 commits and 34 changed files. The ordered file-list SHA-256 is
`9a7de94adecb93f4db0c2c776920a769f67a5006d25367f4cb12b05246e5f1ec`;
the complete list is retained in `release/public-release-preflight.json`.

Every change is specification/planning, release/deployment evidence,
verification tooling, or test content. No package module, compiled package CSS,
gallery runtime/template/asset, version metadata, dependency manifest, or
dependency lock changed. A replacement Fly deployment is therefore not
required by this inventory. Phase 4 must still recheck the current public
`1.0.0` identity and canonical smoke before publication.

The section began with a clean working tree. No generated archive,
documentation build, credential, or secret evidence file is tracked.

Sections 1.2 and 1.3 remain pending. This record neither qualifies nor
publishes the release.
