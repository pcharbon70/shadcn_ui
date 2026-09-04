# Internal release candidate and versioned gallery publication

```spec-meta
id: shadcn_ui.release_publication
kind: application
status: active
summary: Reproducible internal candidate, clean consumer trial, immutable gallery identity, stateless Fly.io deployment operations, and truthful release gates.
decisions:
  - shadcn_ui.fly_gallery_publication
  - shadcn_ui.public_hex_1_0_release
  - shadcn_ui.upstream_provenance
  - shadcn_ui.waive_manual_accessibility_1_0_release
  - shadcn_ui.waive_independent_review_1_0_release
surface:
  - mix.exs
  - mix.lock
  - package-lock.json
  - README.md
  - CHANGELOG.md
  - LICENSE
  - RELEASE.md
  - THIRD_PARTY_NOTICES.md
  - release/candidate-inputs.json
  - release/candidate-status.json
  - release/consumer-trial-evidence.json
  - release/preliminary-candidate-evidence.json
  - release/public-release-phase-3.json
  - release/public-release-phase-4.json
  - release/fly-deployment-evidence.json
  - release/records/**
  - demo/operations/gallery-publication.md
  - demo/lib/shadcn_ui_demo/build_identity.ex
  - demo/test/build_identity_test.exs
  - demo/Dockerfile
  - demo/fly.toml
  - demo/rel/**
  - demo/test/fly_deployment_test.exs
  - scripts/**
  - .github/workflows/**
  - test/shadcn_ui/milestone_f_release_test.exs
  - test/shadcn_ui/milestone_f_final_documentation_test.exs
  - test/shadcn_ui/milestone_f_phase1_acceptance_test.exs
  - test/shadcn_ui/milestone_f_phase6_acceptance_test.exs
  - test/shadcn_ui/milestone_f_publication_operations_test.exs
  - test/shadcn_ui/public_hex_release_phase_1_test.exs
  - test/shadcn_ui/public_hex_release_phase_2_test.exs
  - test/shadcn_ui/public_hex_release_phase_3_test.exs
```

## Requirements

```spec-requirements
- id: shadcn_ui.release_publication.version_identity
  statement: Gallery and candidate evidence shall expose the package version, full source revision, catalogue schema version, and pinned upstream provenance revision from validated immutable build inputs.
  priority: must
  stability: stable

- id: shadcn_ui.release_publication.deterministic_export
  statement: Identical locked inputs shall produce byte-identical local gallery exports, search data, health metadata, release manifests, and packaged CSS without remote runtime assets.
  priority: must
  stability: stable

- id: shadcn_ui.release_publication.health_manifest
  statement: The static artifact shall include non-secret health and release metadata covering canonical identity and known route and asset checks without credentials, mutable user data, or runtime source discovery.
  priority: must
  stability: stable

- id: shadcn_ui.release_publication.deployment_workflow
  statement: Reviewed source shall publish an immutable stateless gallery release through the approved Fly.io configuration and explicit deploy procedure, while local and pull-request verification do not publish and repository source contains no deployment credential.
  priority: must
  stability: stable

- id: shadcn_ui.release_publication.post_deploy_and_rollback
  statement: Operations guidance shall define canonical direct-route, asset, search, health, error, and version smoke checks plus rollback to a previously verified artifact and recovery verification.
  priority: must
  stability: evolving

- id: shadcn_ui.release_publication.clean_checkout
  statement: Locked setup, package and demo precommit, SpecLed, ExDoc, CSS, deterministic export, provenance, license, and actual archive audits shall run from a clean checkout with failures retained as blocking evidence.
  priority: must
  stability: stable

- id: shadcn_ui.release_publication.clean_consumer_trial
  statement: An isolated disposable Phoenix consumer shall install the candidate, import representative public APIs, serve the packaged stylesheet, compile controller HEEX, and require no ShadcnUI consumer Node or Tailwind toolchain.
  priority: must
  stability: evolving

- id: shadcn_ui.release_publication.explicit_archive
  statement: The actual candidate archive shall match the explicit allowlist, contain the complete MIT license, third-party notices, and documentation, and exclude demo, tests, generated site output, build tools, dependencies, observations, credentials, and mutable files.
  priority: must
  stability: stable

- id: shadcn_ui.release_publication.public_release_target
  statement: The first public Hex release shall use version 1.0.0, adopt Semantic Versioning for later releases, and remain unpublished and untagged until its own archive, consumer, review disposition, CI, merge, gallery-identity, publication, and truthful-gate evidence is complete; this release does not imply a marketplace listing, consumer-platform certification, or official upstream affiliation.
  priority: must
  stability: stable

- id: shadcn_ui.release_publication.truthful_gates
  statement: Local, CI, merge, deployment, post-deployment, consumer-trial, source-review, and manual-accessibility states shall be recorded separately; incomplete mandatory states shall block final qualification, while every explicit release-scoped waiver shall remain non-mandatory, visibly unexecuted, and bounded to its recorded release.
  priority: must
  stability: stable
```

## Verification

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's release contract.

The current owner-authorized Fly release binds package and demo version `1.0.0`
to exact source revision `8654f6a4500ce210682d7cae7453553d878a714c`, Fly
release `rel_76njzd0doog3yko3`, immutable image digest, passing service health,
canonical smoke, and two deployed Chromium checks. That deployment does not by
itself qualify or publish the Hex candidate; its source-review disposition,
qualification merge, and exact-main CI are recorded independently below.

The category-oriented user guides extend generated ExDoc navigation only. They
do not change the candidate version, archive allowlist, deployment inputs,
qualification gates or the distinction between generated documentation and
release-archive documentation.
Release and acceptance Markdown records live under `release/records/`, while
the gallery publication runbook remains with the demo under `demo/operations/`;
neither location is part of the HexDocs extras inventory.

Canonical smoke identifies every route through the stable ShadcnUI home link
label rather than requiring route-specific titles or secondary metadata text.
Milestone G remediation R5 adds the local rendered-reference integrity check,
locked pinned/local browser matrix, reviewed comparison hashes and deterministic
integration record to pull-request verification without publishing or using the
moving upstream site as a CI input.
Remediation R6 keeps the manual-accessibility gate pending and final candidate
qualification blocked when the release owner accepts that risk for remediation
progression; the waiver neither claims conformance nor itself authorizes
deployment.
Its complete local regression separately proves deterministic CSS and export,
the actual archive, isolated clean-consumer installation, all A-G browser
suites and current Fly-identity manifests. The later owner-authorized deployment
binds the exact green pull-request revision to an immutable Fly release, image
digest, health identity, canonical smoke, deployed-browser checks and response
hashes. Independent source approval, CI on the final evidence revision, merge,
the exact-revision two-build clean candidate and manual accessibility remain
separate gates, and an older operational release without recorded source review
is not represented as an eligible rollback candidate.
The later `1.0.0` decision changes only the current release-gate effect of those
six human scenarios: they remain pending evidence but are waived and
non-mandatory for `1.0.0`. The isolated archive-consumer trial and every other
mandatory gate remain unchanged.
Phase 2 preliminary evidence binds two equivalent clean builds and a disposable
Hex-repository consumer to one archive checksum. It remains explicitly
preliminary: the exact merged `RELEASE_SHA` build and consumer gates stay
pending until their own Phase 4 evidence exists.
For `1.0.0`, independent source review was not performed. The release owner's
accepted waiver binds that unreviewed state to qualification PR #52's exact
head and changes only the gate's mandatory effect; it does not convert the
missing review into an approval or weaken any technical release gate.
Qualification PR #52 passed its required pre-merge workflow and merged as
`aa6a2d35474a51ea63248131631ace2b113b99a4`. The merge commit and PR head share
the exact tree `6dc1d3f056196d13be1ec7529fbe2f9d4e59e4e7`, so that merge is the selected
`RELEASE_SHA`. Later governance/evidence reconciliation does not replace the
selected package source; Phase 4 operates on that detached immutable revision.
GitHub Actions run `33881762954` and verify job `101051845295` passed every
configured main-branch step for that exact `RELEASE_SHA`, including locked
package, docs, archive, demo, SpecLed, and Chromium/Firefox/WebKit verification.
The run and job logs are retained for 90 days; the workflow produced no named
artifact. Exact-source reproduction and consumption remain Phase 4 gates.
Phase 4 then built the selected `RELEASE_SHA` twice from separate detached
clean worktrees with every pinned runtime and the reviewed rebar3 binary. Both
actual 63-entry archives are byte-identical at SHA-256
`547280431c3eddd6cfb2fd92fd691c30b1e905282a0041f27d8d76130434a2da`;
the complete build records, archive inventories, compiled CSS, documentation,
gallery, input-manifest, and provenance identities also match. This passes the
final clean-candidate and exact-reproducibility gate without promoting the
then-pending final isolated-consumer result. Section 4.2 installed the selected
archive through a disposable signed Hex repository outside the source tree and
passed compilation, three consumer tests, browser interaction, packaged-
stylesheet, package-metadata, and runtime-boundary checks. Its recorded archive
checksum matches the two-build result exactly; the disposable consumer and
temporary worktrees were removed while the signed result remains external.
The final Phase 4 packet checksum-links the review disposition, exact-main CI,
both clean-build records, comparison, both archive inventories, isolated
consumer, Fly deployment record, and release-scoped waivers, and records a
fresh canonical Fly smoke plus public-Hex absence query. Every one of the 15
mandatory gates before publication and tagging passes with no stale, missing,
contradictory, or SHA-mismatched evidence. The resulting go decision allows
only the Phase 5 dry run and explicit publication-authorization request;
`mix hex.publish` and the public tag remain pending mandatory gates.

```spec-verification
- kind: test_file
  target: demo/test/build_identity_test.exs
  covers:
    - shadcn_ui.release_publication.version_identity

- kind: test_file
  target: test/shadcn_ui/milestone_f_phase1_acceptance_test.exs
  covers:
    - shadcn_ui.release_publication.version_identity

- kind: test_file
  target: test/shadcn_ui/milestone_f_release_test.exs
  covers:
    - shadcn_ui.release_publication.version_identity
    - shadcn_ui.release_publication.deterministic_export
    - shadcn_ui.release_publication.health_manifest
    - shadcn_ui.release_publication.clean_checkout
    - shadcn_ui.release_publication.clean_consumer_trial
    - shadcn_ui.release_publication.explicit_archive
    - shadcn_ui.release_publication.public_release_target
    - shadcn_ui.release_publication.truthful_gates

- kind: test_file
  target: test/shadcn_ui/milestone_f_final_documentation_test.exs
  covers:
    - shadcn_ui.release_publication.deployment_workflow
    - shadcn_ui.release_publication.post_deploy_and_rollback
    - shadcn_ui.release_publication.clean_checkout
    - shadcn_ui.release_publication.clean_consumer_trial
    - shadcn_ui.release_publication.truthful_gates

- kind: test_file
  target: demo/test/fly_deployment_test.exs
  covers:
    - shadcn_ui.release_publication.version_identity
    - shadcn_ui.release_publication.health_manifest
    - shadcn_ui.release_publication.deployment_workflow
    - shadcn_ui.release_publication.post_deploy_and_rollback

- kind: command
  target: npm --prefix demo run smoke:fly
  covers:
    - shadcn_ui.release_publication.deployment_workflow
    - shadcn_ui.release_publication.post_deploy_and_rollback

- kind: test_file
  target: demo/test/milestone_g_remediation_r6_test.exs
  covers:
    - shadcn_ui.release_publication.deterministic_export
    - shadcn_ui.release_publication.clean_checkout
    - shadcn_ui.release_publication.clean_consumer_trial
    - shadcn_ui.release_publication.explicit_archive
    - shadcn_ui.release_publication.truthful_gates

- kind: test_file
  target: test/shadcn_ui/public_hex_release_phase_2_test.exs
  covers:
    - shadcn_ui.release_publication.deterministic_export
    - shadcn_ui.release_publication.clean_checkout
    - shadcn_ui.release_publication.clean_consumer_trial
    - shadcn_ui.release_publication.explicit_archive
    - shadcn_ui.release_publication.truthful_gates

- kind: test_file
  target: test/shadcn_ui/public_hex_release_phase_3_test.exs
  covers:
    - shadcn_ui.release_publication.public_release_target
    - shadcn_ui.release_publication.truthful_gates

- kind: test_file
  target: test/shadcn_ui/public_hex_release_phase_4_test.exs
  covers:
    - shadcn_ui.release_publication.deterministic_export
    - shadcn_ui.release_publication.clean_checkout
    - shadcn_ui.release_publication.clean_consumer_trial
    - shadcn_ui.release_publication.explicit_archive
    - shadcn_ui.release_publication.public_release_target
    - shadcn_ui.release_publication.truthful_gates
```
