# Internal release candidate and versioned gallery publication

```spec-meta
id: shadcn_ui.release_publication
kind: application
status: active
summary: Reproducible internal candidate, clean consumer trial, immutable gallery identity, stateless Fly.io deployment operations, and truthful release gates.
decisions:
  - shadcn_ui.fly_gallery_publication
  - shadcn_ui.internal_release_candidate
  - shadcn_ui.upstream_provenance
surface:
  - mix.exs
  - mix.lock
  - package-lock.json
  - README.md
  - CHANGELOG.md
  - RELEASE.md
  - THIRD_PARTY_NOTICES.md
  - docs/release-candidate.md
  - docs/gallery-operations.md
  - demo/lib/shadcn_ui_demo/build_identity.ex
  - demo/test/build_identity_test.exs
  - demo/Dockerfile
  - demo/fly.toml
  - demo/rel/**
  - demo/test/fly_deployment_test.exs
  - scripts/**
  - .github/workflows/**
  - test/shadcn_ui/milestone_f_release_test.exs
  - test/shadcn_ui/milestone_f_phase1_acceptance_test.exs
  - test/shadcn_ui/milestone_f_phase6_acceptance_test.exs
  - test/shadcn_ui/milestone_f_publication_operations_test.exs
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
  statement: The actual candidate archive shall match the explicit allowlist, contain complete notices and documentation, and exclude demo, tests, generated site output, build tools, dependencies, observations, credentials, and mutable files.
  priority: must
  stability: stable

- id: shadcn_ui.release_publication.internal_candidate_only
  statement: Milestone F shall qualify an internal 0.1.0 candidate without publishing Hex, creating a marketplace listing, or claiming a public release or consumer-platform certification.
  priority: must
  stability: stable

- id: shadcn_ui.release_publication.truthful_gates
  statement: Local, CI, merge, deployment, post-deployment, consumer-trial, and manual-accessibility states shall be recorded separately, and incomplete mandatory states shall block final qualification.
  priority: must
  stability: stable
```

## Verification

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's release contract.

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
    - shadcn_ui.release_publication.internal_candidate_only
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
```
