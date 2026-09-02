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

  - [x] 6.2 Section - Harden deployment, smoke checks and rollback.

    Treat publication as an operational workflow with explicit ownership and recovery.

    - [x] 6.2.1 Task - Verify the reviewed Pages workflow.

      Pull requests should verify immutable artifacts while only reviewed main may publish.

      - [x] 6.2.1.1 Subtask - Pin workflow actions and permissions, build only repository inputs, upload one immutable artifact and prevent PR publication.
      - [x] 6.2.1.2 Subtask - Validate canonical host/subpath configuration, non-secret revision injection, concurrency and environment protection without source credentials.
      - [x] 6.2.1.3 Subtask - Add artifact-level smoke before deploy and retain enough immutable identity to select a verified rollback artifact.

    - [x] 6.2.2 Task - Complete post-deploy and recovery operations.

      Maintainers need bounded checks and a tested path back to known-good content.

      - [x] 6.2.2.1 Subtask - Document ownership and run canonical home, direct route/fragment, CSS, script, media, search, sitemap, health, version and error checks after deploy.
      - [x] 6.2.2.2 Subtask - Define failure triage, rollback to a previously verified artifact, cache considerations and the recovery smoke sequence.
      - [x] 6.2.2.3 Subtask - Record local, CI, merge, deployment and post-deployment results separately; never infer publication success from a merged PR.

  - [x] 6.3 Section - Reconcile final documentation and release acceptance.

    Close every requirement and expose unresolved gates before declaring the internal candidate ready.

    - [x] 6.3.1 Task - Audit all catalogue and documentation relationships.

      The final public reference must cover every actual API with no stale or invented entry.

      - [x] 6.3.1.1 Subtask - Re-run public API parity, component-page sections, examples/fragments, ExDoc, search, provenance and verification completeness.
      - [x] 6.3.1.2 Subtask - Verify README, controller/Dstar/LiveView guides, compatibility policy, changelog, migrations, release procedure and operations agree.
      - [x] 6.3.1.3 Subtask - Preserve every Milestones A-E route and contract and document deliberately deferred public Hex, marketplace, CLI, theme and new-family work.

    - [x] 6.3.2 Task - Decide internal candidate qualification truthfully.

      Qualification requires evidence, not completed planning checkboxes or a successful local run alone.

      - [x] 6.3.2.1 Subtask - Reconcile all 38 new requirements with implemented proof and fail missing, stale, contradictory or planning-only targets.
      - [x] 6.3.2.2 Subtask - Review clean builds, exact-engine results, automated and manual accessibility, consumer trial, CI, deploy and post-deploy gates.
      - [x] 6.3.2.3 Subtask - Mark the internal 0.1.0 candidate qualified only if all mandatory gates pass; otherwise publish an exact blocking-status record without Hex release.

  - [ ] 6.4 Section - Phase 6 Integration Tests.

    Run the complete clean-checkout, consumer, browser, static-site and operational acceptance suite for Milestone F.

    - [ ] 6.4.1 Task - Execute milestone-wide verification.

      Final integration must preserve all prior component and package guarantees.

      - [x] 6.4.1.1 Subtask - Add milestone_f_acceptance and release tests covering every specification ID, catalogue relationship, evidence state and absent runtime/consumer target.
      - [x] 6.4.1.2 Subtask - Run package/demo precommit, warning-free ExDoc, deterministic CSS/export, provenance/license, actual archive and clean consumer checks from a fresh checkout.
      - [ ] 6.4.1.3 Subtask - Run all A-F browser suites in locked engines, static-subpath smoke, required manual review and canonical post-deploy smoke after the reviewed publication occurs.

    - [ ] 6.4.2 Task - Record final evidence and delivery state.

      The execution record must be reproducible and distinguish every gate and authorized action.

      - [x] 6.4.2.1 Subtask - Run SpecLed next/check for main and HEAD plus git diff --check, retaining full diagnostics for any failure.
      - [x] 6.4.2.2 Subtask - Record commands, tool versions, revisions, artifact hashes, browser/manual results, consumer trial, workflow run, deployed smoke and unresolved limitations.
      - [x] 6.4.2.3 Subtask - Commit four sections and open one Phase 6 PR; publish only through reviewed main and do not publish Hex or create a public tag without separate authorization.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge without a later request.

## Execution record

- Tested source revision: `3ef5f82e0830d34b9be16a4b6f8945bc7761d93b`.
- Toolchain: Elixir 1.20.3, OTP 29.0 and Node.js 22.13.1.
- Clean builds: two independent build roots produced equivalent package,
  documentation and gallery outputs. The package archive SHA-256 is
  `38a9e118d400816a8a5780e655c1c10e0fb60e30138a13337b7a74f48e94fc07`
  and the compiled CSS SHA-256 is
  `d2128dd4b653375bab27d6bc070e1ef2c0ca11dd39a183ce6ab9e63eaf8047d8`.
  Each export contains 645 gallery files and 143 documentation files; the
  archive contains 62 entries.
- Automated suites: 402 package tests, 91 demo tests and three isolated
  archive-consumer tests passed. The isolated browser consumer trial passed.
- Browser matrix: all 417 A-F Playwright tests passed without retry in locked
  Chromium 151.0.7922.34, Firefox 153.0 and WebKit 26.5.
- Static publication: both deterministic exports, the 634-route audit,
  repository-subpath smoke, release/health manifests, hashes, media and the
  non-reflecting 404 checks passed locally.
- SpecLed: `mix spec.next` reports four new Phase 6 policy files outside current
  subject coverage. Both `mix spec.check --base main` and
  `mix spec.check --base HEAD` report four errors and 144 warnings because
  nested verification shells select Elixir 1.18.0; the same verification
  commands pass directly with the pinned Elixir 1.20.3 toolchain. The gate
  remains failed and the transient `.spec/state.json` output was not retained.
- Pending external/manual evidence: all six bounded manual accessibility
  scenarios, final-revision CI, merge, reviewed-main deployment and canonical
  post-deploy smoke. Consequently Phase 6 and Section 6.4 remain open and the
  internal candidate remains blocked.
- Publication boundary: no Hex package, public version tag, marketplace entry,
  platform certification or upstream-affiliation claim was created.
- Delivery: four section commits are proposed together in
  [PR #26](https://github.com/pcharbon70/shadcn_ui/pull/26); it remains
  unmerged for review.
