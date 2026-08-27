# Phase 5 - Reproducible Candidate And Clean Consumer Trial

Back to wave: [README](./README.md)

- [ ] 5 Phase - Reproducible Candidate And Clean Consumer Trial.

  Rebuild and inspect the internal `0.1.0` candidate from clean inputs, then
  prove a separate Phoenix consumer can use what the archive actually contains.

  - [x] 5.1 Section - Make clean candidate builds reproducible.

    Lock all inputs and compare actual outputs rather than relying on a developer working tree.

    - [x] 5.1.1 Task - Define the clean build procedure.

      A disposable checkout must be able to recreate every candidate artifact with repository-owned commands.

      - [x] 5.1.1.1 Subtask - Pin and verify Elixir/OTP, Mix, Hex, rebar, Node, npm, Tailwind, Playwright and browser lock inputs used by the release procedure.
      - [x] 5.1.1.2 Subtask - Run package/demo setup, CSS build, ExDoc, gallery export, search/health metadata and archive creation without global build tools.
      - [x] 5.1.1.3 Subtask - Document offline/runtime asset boundaries and fail remote imports, undeclared downloads, untracked inputs or mutable environment dependencies.

    - [x] 5.1.2 Task - Compare deterministic outputs and release contents.

      Two clean runs should produce the same consumer-relevant bytes and allowlist.

      - [x] 5.1.2.1 Subtask - Compare compiled CSS, static export, search data, health/release manifests and archive file/hash inventories from identical inputs.
      - [x] 5.1.2.2 Subtask - Audit the actual archive for runtime modules, CSS, metadata, README, changelog, migrations and notices and reject every excluded path class.
      - [x] 5.1.2.3 Subtask - Reconcile upstream provenance, MIT notices, independently authored material and the exact pinned upstream revision.

  - [x] 5.2 Section - Build an isolated clean Phoenix consumer.

    Test the candidate from the viewpoint of a project that does not inherit repository-local source or tooling.

    - [x] 5.2.1 Task - Install and compile the actual candidate.

      The fixture must consume an immutable candidate input rather than the source path accidentally.

      - [x] 5.2.1.1 Subtask - Create a disposable minimal Phoenix consumer from a checked fixture recipe outside the candidate source tree.
      - [x] 5.2.1.2 Subtask - Install the local archive or immutable repository candidate and assert no path dependency, demo module or repository build output is visible.
      - [x] 5.2.1.3 Subtask - Compile representative foundation, form, navigation, overlay, media and motion HEEX through public imports.

    - [x] 5.2.2 Task - Exercise runtime assets and transport neutrality.

      The consumer should prove the package contract without becoming a framework certification project.

      - [x] 5.2.2.1 Subtask - Serve the packaged stylesheet, render light/dark scopes and confirm no consumer Node, Tailwind, remote asset or package JavaScript setup.
      - [x] 5.2.2.2 Subtask - Render an ordinary controller page and verify package version, public modules, stylesheet resolution and representative native interactions.
      - [x] 5.2.2.3 Subtask - Compile Dstar-shaped and LiveView-shaped stateless HEEX guidance where possible without adding either as a ShadcnUI dependency or support claim.

  - [ ] 5.3 Section - Qualify the internal version and release record.

    Establish exactly what `0.1.0` means and which gates still block final qualification.

    - [ ] 5.3.1 Task - Reconcile versioning and migration policy.

      Candidate identity and consumer expectations must agree across code and documentation.

      - [ ] 5.3.1.1 Subtask - Confirm package version, changelog, migration notes, compatibility floors, deprecations and rollback instructions describe the same internal candidate.
      - [ ] 5.3.1.2 Subtask - Document how future breaking component, token, CSS, capability or archive changes affect versioning and migration evidence.
      - [ ] 5.3.1.3 Subtask - Verify no Hex publish, public tag, marketplace, consumer-platform certification or official upstream affiliation is claimed.

    - [ ] 5.3.2 Task - Assemble candidate evidence and blocking status.

      Release readiness should be a structured result rather than a narrative success claim.

      - [ ] 5.3.2.1 Subtask - Record clean build identities, output hashes, archive inventory, documentation result, browser result and consumer trial result.
      - [ ] 5.3.2.2 Subtask - List mandatory, manual, CI, deployment and post-deployment gates with explicit passed, failed, pending or not-applicable states.
      - [ ] 5.3.2.3 Subtask - Block qualification on any failed or pending mandatory pre-publication gate and preserve exact diagnostic evidence.

  - [ ] 5.4 Section - Phase 5 Integration Tests.

    Verify clean reproducibility, package contents, real consumer use and truthful internal-candidate status end to end.

    - [ ] 5.4.1 Task - Run clean build and consumer acceptance.

      Automation must start without source-tree dependencies and inspect the actual candidate artifact.

      - [ ] 5.4.1.1 Subtask - Execute two disposable clean builds and fail byte or inventory differences not explicitly identified as excluded nondeterministic output.
      - [ ] 5.4.1.2 Subtask - Run the isolated consumer's compile, controller render, stylesheet, theme, public import and representative browser checks.
      - [ ] 5.4.1.3 Subtask - Remove disposable fixtures after recording hashes/results and prove no generated consumer or dependency output enters Git or the archive.

    - [ ] 5.4.2 Task - Run candidate-wide release gates.

      Candidate acceptance must retain every earlier package, gallery and compatibility guarantee.

      - [ ] 5.4.2.1 Subtask - Run package/demo precommit, warning-free ExDoc, CSS checks, deterministic export, provenance/license audit, all A-F tests and actual archive inspection.
      - [ ] 5.4.2.2 Subtask - Run SpecLed main/HEAD and git diff --check, recording known infrastructure failures without disabling commands or marking them passed.
      - [ ] 5.4.2.3 Subtask - Update the candidate record, commit four sections and open one Phase 5 PR without publishing or tagging.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge without a later request.
