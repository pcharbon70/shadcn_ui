# Phase 6 - Versioned Publication And Milestone Acceptance

Back to wave: [README](./README.md)

- [ ] 6 Phase - Versioned Publication And Milestone Acceptance.

  Harden immutable gallery publication and operational recovery, then reconcile
  every Milestone F requirement and gate without conflating merge with deploy.

  - [x] 6.1 Section - Finalize immutable publication artifacts.

    Make the static site self-identifying, inspectable and deterministic before workflow changes.

    - [x] 6.1.1 Task - Complete health and release manifests.

      Machine-readable metadata must expose useful non-secret artifact identity and checks.

      - [x] 6.1.1.1 Subtask - Emit package version, full revision, catalogue schema, upstream revision, canonical URL and deterministic asset identities from validated build inputs.
      - [x] 6.1.1.2 Subtask - Record known route, search, sitemap, CSS, script, media and error-page health checks without mutable state or runtime source discovery.
      - [x] 6.1.1.3 Subtask - Validate schemas, escaping, subpath URLs, content types and absence of credentials, environment secrets and user data.

    - [x] 6.1.2 Task - Audit the complete versioned export.

      The artifact must contain every documented page and only local declared assets.

      - [x] 6.1.2.1 Subtask - Verify every catalogue route/fragment, composition, source, canonical, search record, sitemap entry and health target exists.
      - [x] 6.1.2.2 Subtask - Produce two byte-identical exports and audit local asset hashes, references, repository-subpath behavior, unknown routes and stale files.
      - [x] 6.1.2.3 Subtask - Ensure package contents remain independent of the gallery artifact, workflow configuration and deployment metadata.

  - [ ] 6.2 Section - Harden deployment, smoke checks and rollback.

    Treat publication as an operational workflow with explicit ownership and recovery.

    - [ ] 6.2.1 Task - Verify the reviewed Pages workflow.

      Pull requests should verify immutable artifacts while only reviewed main may publish.

      - [ ] 6.2.1.1 Subtask - Pin workflow actions and permissions, build only repository inputs, upload one immutable artifact and prevent PR publication.
      - [ ] 6.2.1.2 Subtask - Validate canonical host/subpath configuration, non-secret revision injection, concurrency and environment protection without source credentials.
      - [ ] 6.2.1.3 Subtask - Add artifact-level smoke before deploy and retain enough immutable identity to select a verified rollback artifact.

    - [ ] 6.2.2 Task - Complete post-deploy and recovery operations.

      Maintainers need bounded checks and a tested path back to known-good content.

      - [ ] 6.2.2.1 Subtask - Document ownership and run canonical home, direct route/fragment, CSS, script, media, search, sitemap, health, version and error checks after deploy.
      - [ ] 6.2.2.2 Subtask - Define failure triage, rollback to a previously verified artifact, cache considerations and the recovery smoke sequence.
      - [ ] 6.2.2.3 Subtask - Record local, CI, merge, deployment and post-deployment results separately; never infer publication success from a merged PR.

  - [ ] 6.3 Section - Reconcile final documentation and release acceptance.

    Close every requirement and expose unresolved gates before declaring the internal candidate ready.

    - [ ] 6.3.1 Task - Audit all catalogue and documentation relationships.

      The final public reference must cover every actual API with no stale or invented entry.

      - [ ] 6.3.1.1 Subtask - Re-run public API parity, component-page sections, examples/fragments, ExDoc, search, provenance and verification completeness.
      - [ ] 6.3.1.2 Subtask - Verify README, controller/Dstar/LiveView guides, compatibility policy, changelog, migrations, release procedure and operations agree.
      - [ ] 6.3.1.3 Subtask - Preserve every Milestones A-E route and contract and document deliberately deferred public Hex, marketplace, CLI, theme and new-family work.

    - [ ] 6.3.2 Task - Decide internal candidate qualification truthfully.

      Qualification requires evidence, not completed planning checkboxes or a successful local run alone.

      - [ ] 6.3.2.1 Subtask - Reconcile all 38 new requirements with implemented proof and fail missing, stale, contradictory or planning-only targets.
      - [ ] 6.3.2.2 Subtask - Review clean builds, exact-engine results, automated and manual accessibility, consumer trial, CI, deploy and post-deploy gates.
      - [ ] 6.3.2.3 Subtask - Mark the internal 0.1.0 candidate qualified only if all mandatory gates pass; otherwise publish an exact blocking-status record without Hex release.

  - [ ] 6.4 Section - Phase 6 Integration Tests.

    Run the complete clean-checkout, consumer, browser, static-site and operational acceptance suite for Milestone F.

    - [ ] 6.4.1 Task - Execute milestone-wide verification.

      Final integration must preserve all prior component and package guarantees.

      - [ ] 6.4.1.1 Subtask - Add milestone_f_acceptance and release tests covering every specification ID, catalogue relationship, evidence state and absent runtime/consumer target.
      - [ ] 6.4.1.2 Subtask - Run package/demo precommit, warning-free ExDoc, deterministic CSS/export, provenance/license, actual archive and clean consumer checks from a fresh checkout.
      - [ ] 6.4.1.3 Subtask - Run all A-F browser suites in locked engines, static-subpath smoke, required manual review and canonical post-deploy smoke after the reviewed publication occurs.

    - [ ] 6.4.2 Task - Record final evidence and delivery state.

      The execution record must be reproducible and distinguish every gate and authorized action.

      - [ ] 6.4.2.1 Subtask - Run SpecLed next/check for main and HEAD plus git diff --check, retaining full diagnostics for any failure.
      - [ ] 6.4.2.2 Subtask - Record commands, tool versions, revisions, artifact hashes, browser/manual results, consumer trial, workflow run, deployed smoke and unresolved limitations.
      - [ ] 6.4.2.3 Subtask - Commit four sections and open one Phase 6 PR; publish only through reviewed main and do not publish Hex or create a public tag without separate authorization.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge without a later request.
