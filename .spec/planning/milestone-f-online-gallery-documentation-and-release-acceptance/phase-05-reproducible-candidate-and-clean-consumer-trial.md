# Phase 5 - Reproducible Candidate And Clean Consumer Trial

Back to wave: [README](./README.md)

- [x] 5 Phase - Reproducible Candidate And Clean Consumer Trial.

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

  - [x] 5.3 Section - Qualify the internal version and release record.

    Establish exactly what `0.1.0` means and which gates still block final qualification.

    - [x] 5.3.1 Task - Reconcile versioning and migration policy.

      Candidate identity and consumer expectations must agree across code and documentation.

      - [x] 5.3.1.1 Subtask - Confirm package version, changelog, migration notes, compatibility floors, deprecations and rollback instructions describe the same internal candidate.
      - [x] 5.3.1.2 Subtask - Document how future breaking component, token, CSS, capability or archive changes affect versioning and migration evidence.
      - [x] 5.3.1.3 Subtask - Verify no Hex publish, public tag, marketplace, consumer-platform certification or official upstream affiliation is claimed.

    - [x] 5.3.2 Task - Assemble candidate evidence and blocking status.

      Release readiness should be a structured result rather than a narrative success claim.

      - [x] 5.3.2.1 Subtask - Record clean build identities, output hashes, archive inventory, documentation result, browser result and consumer trial result.
      - [x] 5.3.2.2 Subtask - List mandatory, manual, CI, deployment and post-deployment gates with explicit passed, failed, pending or not-applicable states.
      - [x] 5.3.2.3 Subtask - Block qualification on any failed or pending mandatory pre-publication gate and preserve exact diagnostic evidence.

  - [x] 5.4 Section - Phase 5 Integration Tests.

    Verify clean reproducibility, package contents, real consumer use and truthful internal-candidate status end to end.

    - [x] 5.4.1 Task - Run clean build and consumer acceptance.

      Automation must start without source-tree dependencies and inspect the actual candidate artifact.

      - [x] 5.4.1.1 Subtask - Execute two disposable clean builds and fail byte or inventory differences not explicitly identified as excluded nondeterministic output.
      - [x] 5.4.1.2 Subtask - Run the isolated consumer's compile, controller render, stylesheet, theme, public import and representative browser checks.
      - [x] 5.4.1.3 Subtask - Remove disposable fixtures after recording hashes/results and prove no generated consumer or dependency output enters Git or the archive.

    - [x] 5.4.2 Task - Run candidate-wide release gates.

      Candidate acceptance must retain every earlier package, gallery and compatibility guarantee.

      - [x] 5.4.2.1 Subtask - Run package/demo precommit, warning-free ExDoc, CSS checks, deterministic export, provenance/license audit, all A-F tests and actual archive inspection.
      - [x] 5.4.2.2 Subtask - Run SpecLed main/HEAD and git diff --check, recording known infrastructure failures without disabling commands or marking them passed.
      - [x] 5.4.2.3 Subtask - Update the candidate record, commit four sections and open one Phase 5 PR without publishing or tagging.

## Execution record

- Two clean builds of `1b553a2d2e0de5a591690bdc5b761044c808be09`
  compared equivalent: archive SHA-256
  `51febcd463bf9cb7f9106857a688bacea4fc3e48c6f090d8f778c4175441fbaa`,
  CSS SHA-256
  `d2128dd4b653375bab27d6bc070e1ef2c0ca11dd39a183ce6ab9e63eaf8047d8`,
  643 gallery files, 139 documentation files and 62 archive entries.
- Clean candidate automation passed 393 package tests, 89 demo tests,
  warnings-as-errors documentation, CSS identity, static export/smoke, archive
  allowlisting and provenance/license checks. ExDoc HTML and Markdown are in
  the deterministic boundary; ExDoc's UUID-bearing EPUB is explicitly excluded.
- The isolated archive consumer compiled with no path dependency, passed three
  ExUnit tests and passed its Chromium controller, stylesheet, focus, form and
  native-dialog interaction trial.
- Historical Milestone A-F browser suites passed across their configured locked
  engines. One first-run Firefox context-close protocol error in Milestone E
  Phase 6 did not recur; the complete 24-test rerun passed, followed by all 15
  Milestone F tests.
- `mix spec.check --base main` and `mix spec.check --base HEAD` remain failed at
  4 errors and 145 warnings because nested verification shells select Elixir
  1.18.0; the directly pinned Elixir 1.20.3 precommit gates pass. The SpecLed
  commands remain enabled and are not marked passed.
- Manual accessibility review and final-revision CI remain pending, so the
  internal candidate stays blocked. No publication, public tag, marketplace
  listing, certification or upstream-affiliation claim was made.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge without a later request.
