# Public `1.0.0` Hex Release Execution Plan

This plan turns the accepted `1.0.0` release decision into an auditable Hex
publication. It is a follow-on release operation, not a rewrite of Milestone F
or G history. A checked planning box means that the named evidence exists; it
does not imply that a later gate passed.

## Status

**Ready to execute; publication remains blocked.**

The following prerequisites are already accepted or operationally proven:

- [x] `1.0.0` is the selected first public Hex version.
- [x] The six human accessibility scenarios remain visibly unassessed and are
  waived as a mandatory gate for `1.0.0` only.
- [x] Automated accessibility remains mandatory and has passing evidence.
- [x] The public Fly gallery serves version `1.0.0`, and its recorded health,
  canonical smoke, and deployed Chromium checks pass.
- [x] Hex publication does not imply a marketplace listing, platform
  certification, WCAG conformance, assistive-technology support, or upstream
  affiliation.

The remaining gates start unchecked. Historical `0.1.0` archives and consumer
trials, earlier working-tree `1.0.0` runs, a merged waiver PR, or a successful
Fly deployment do not satisfy them.

## Release invariant

One immutable commit, called `RELEASE_SHA` below, is the source of the public
archive and the `v1.0.0` tag. Its content is reviewed before merge, and its
exact merged revision passes CI, two clean builds, archive comparison, and the
isolated consumer trial. No tracked file may change between selecting
`RELEASE_SHA` and publishing from its detached clean checkout.

Build and consumer evidence is retained outside that checkout, for example in
a restricted release-evidence directory and as immutable CI artifacts. This
avoids changing the commit merely to record proof about that commit.

## Ordered phases

| Phase | Outcome | Hard exit gate |
| --- | --- | --- |
| [1 - Establish release authority and freeze inputs](#phase-1--establish-release-authority-and-freeze-inputs) | One reviewable release scope and an identified publication owner | Version, metadata, credentials, inputs, and remaining ledger state agree |
| [2 - Prove the candidate before merge](#phase-2--prove-the-candidate-before-merge) | Reviewable preliminary build, archive, consumer, and verification evidence | Qualification PR is complete and internally green |
| [3 - Review, merge, and select the immutable source](#phase-3--review-merge-and-select-the-immutable-source) | Independent approval and one exact merged `RELEASE_SHA` | Required review, merge, and CI on `RELEASE_SHA` pass |
| [4 - Reproduce and consume the exact release](#phase-4--reproduce-and-consume-the-exact-release) | Two equivalent builds and one isolated consumer result for `RELEASE_SHA` | All local mandatory gates pass with retained evidence |
| [5 - Authorize and publish](#phase-5--authorize-and-publish) | The exact candidate is published once to Hex | Explicit final authorization and successful Hex publication |
| [6 - Verify, tag, and reconcile](#phase-6--verify-tag-and-reconcile) | Public install/docs proof, exact tag, and truthful final ledgers | Public release is independently usable and all records agree |

## Contract coverage

| Current-truth contract | Planned proof |
| --- | --- |
| `shadcn_ui.release_publication.version_identity` | Frozen metadata, final archive inspection, Fly identity smoke, and public Hex/HexDocs version checks |
| `shadcn_ui.release_publication.deterministic_export` | Two pinned clean candidates and inventory comparison at `RELEASE_SHA` |
| `shadcn_ui.release_publication.deployment_workflow` | Reviewed source boundary plus conditional replacement deployment when gallery-affecting content changes |
| `shadcn_ui.release_publication.post_deploy_and_rollback` | Canonical smoke before publication and the existing independent Fly recovery procedure |
| `shadcn_ui.release_publication.clean_checkout` | Detached exact-revision builds, final dry run, CI, SpecLed, docs, package, and demo verification |
| `shadcn_ui.release_publication.clean_consumer_trial` | Local signed-repository trial and a second installation from public Hex |
| `shadcn_ui.release_publication.explicit_archive` | Allowlist audit of both final archives and checksum binding through consumption and publication |
| `shadcn_ui.release_publication.public_release_target` | `1.0.0` metadata, explicit publication authorization, public verification, and exact `v1.0.0` tag |
| `shadcn_ui.release_publication.truthful_gates` | Separate review, CI, merge, build, consumer, Fly, Hex, HexDocs, tag, and waiver evidence |

## Roles and evidence custody

- The **release owner** controls Hex credentials and gives the final explicit
  publication authorization.
- The **implementer** prepares the qualification PR and executes reproducible
  builds and consumer checks without self-approving the source gate.
- The **independent reviewer** approves the final qualification diff and its
  release boundary before merge.
- **CI** supplies the exact-main-revision status and retained build logs or
  artifacts.
- Generated archives and pre-publication evidence remain outside Git. The
  second PR records non-secret hashes, URLs, identities, and results after the
  public events can be observed.

## Phase 1 - Establish release authority and freeze inputs

- [ ] 1.1 Section - Synchronize and define the candidate boundary.

  - [ ] Start from a clean, synchronized `main` and create one `codex/`
    qualification branch.
  - [ ] Record the branch base, intended review method, publication owner, Hex
    account or organization, package name `shadcn_ui`, and target `1.0.0`.
  - [ ] Inventory all changes since the deployed gallery revision. If a change
    affects package runtime, public CSS, gallery output, or version identity,
    require a replacement Fly deployment and canonical smoke. Documentation-
    or evidence-only changes do not by themselves require redeployment.
  - [ ] Keep the working tree free of generated archives, docs, build output,
    credentials, and evidence secrets.

- [ ] 1.2 Section - Verify release metadata and authority.

  - [ ] Confirm `mix.exs`, package metadata, README, changelog, license, notices,
    provenance, links, and release documentation consistently describe
    `1.0.0` and the bounded accessibility waiver.
  - [ ] Confirm the configured Hex identity is authenticated and has permission
    to create or publish the `shadcn_ui` package; never commit the Hex API key.
  - [ ] Query public Hex immediately before qualification and record that
    `shadcn_ui 1.0.0` is not already published.
  - [ ] Run `node scripts/check-candidate-inputs.mjs` and compare the active
    Elixir/OTP, Mix, Hex, rebar3, Node, and npm identities with
    `release/candidate-inputs.json`. Any mismatch blocks the release.

- [ ] 1.3 Section - Reconcile the pre-publication ledger.

  - [ ] Update `release/candidate-status.json`, readable release records, and
    release guidance only for facts already proved at the branch revision.
  - [ ] Preserve the manual scenarios as `PENDING`, `mandatory: false`, and
    `waived`; do not convert the waiver into a pass.
  - [ ] Leave exact-build, consumer, independent review, final-revision CI,
    merge, Hex, and tag gates pending until their own evidence exists.
  - [ ] Run `mix spec.next`, `mix spec.check --base HEAD`, and
    `git diff --check` before Phase 2.

## Phase 2 - Prove the candidate before merge

- [ ] 2.1 Section - Produce preliminary clean candidate evidence.

  - [ ] From the qualification branch head, run two independent clean builds
    with the exact pinned toolchain and separate absolute output directories:

    ```console
    node scripts/run-clean-candidate.mjs --ref HEAD --output /absolute/evidence/premerge-a
    node scripts/run-clean-candidate.mjs --ref HEAD --output /absolute/evidence/premerge-b
    node scripts/compare-candidate-builds.mjs \
      --first /absolute/evidence/premerge-a \
      --second /absolute/evidence/premerge-b \
      --output /absolute/evidence/premerge-comparison.json
    ```

  - [ ] Require identical source, input, provenance, compiled CSS, gallery,
    documentation, and unpacked archive inventories. Investigate every outer
    archive difference; waive none silently.
  - [ ] Confirm both actual `shadcn_ui-1.0.0.tar` files pass the explicit
    archive allowlist and contain the required license, notices, documentation,
    compiled stylesheet, public modules, and Mix metadata only.

- [ ] 2.2 Section - Prove preliminary isolated consumption.

  - [ ] Install one preliminary archive through the harness's disposable signed
    Hex repository, never through a path dependency:

    ```console
    node scripts/run-clean-consumer.mjs \
      --archive /absolute/evidence/premerge-a/shadcn_ui-1.0.0.tar \
      --output /absolute/evidence/premerge-consumer
    ```

  - [ ] Require the external Phoenix consumer to compile representative public
    APIs and controller HEEx, serve the packaged stylesheet, pass its tests and
    browser interaction, and make no consumer Node, Tailwind, remote-asset, or
    package-JavaScript requirement.
  - [ ] Retain the archive checksum and `consumer-trial.json` together so the
    consumer result cannot be attributed to a different package.

- [ ] 2.3 Section - Complete the qualification PR.

  - [ ] Run package and demo precommit, warning-free docs, archive audit,
    automated accessibility/browser acceptance, SpecLed, and release-evidence
    checks required by the current repository.
  - [ ] Commit each completed plan section separately, then open one
    qualification PR containing all source and pre-publication record changes.
  - [ ] Attach or link the preliminary evidence without committing generated
    archives or secrets.
  - [ ] Do not publish, tag, or claim final exact-revision qualification from
    these preliminary results.

## Phase 3 - Review, merge, and select the immutable source

- [ ] 3.1 Section - Obtain independent source approval.

  - [ ] A reviewer other than the change author reviews the complete
    qualification diff, package boundary, metadata, archive inventory,
    accessibility limitation, and publication plan.
  - [ ] Record an approving GitHub review or equivalent signed approval tied to
    the qualification PR head. Comments without approval do not satisfy this
    gate.
  - [ ] Resolve every blocking review finding and rerun affected preliminary
    checks after the final change.

- [ ] 3.2 Section - Merge and identify `RELEASE_SHA`.

  - [ ] Require all qualification-PR checks to pass, then merge through the
    repository's normal protected-main path.
  - [ ] Synchronize local `main`, require a clean tree, and record the full
    merged commit as `RELEASE_SHA`.
  - [ ] Verify the merged tree content is the reviewed candidate content. The
    waiver PR's merge and prior Fly merge do not substitute for this release
    qualification merge.

- [ ] 3.3 Section - Require CI on the exact merged revision.

  - [ ] Require the configured main-branch CI workflow to pass for
    `RELEASE_SHA`, not merely for the pre-merge PR head.
  - [ ] Retain the workflow URL, run and job identifiers, source SHA, toolchain,
    and artifact retention location.
  - [ ] If CI or reviewed content changes, stop, create another reviewed PR,
    select a new `RELEASE_SHA`, and repeat Phases 2-3.

## Phase 4 - Reproduce and consume the exact release

- [ ] 4.1 Section - Build `RELEASE_SHA` twice from clean checkouts.

  - [ ] Use a clean controlling checkout and two new output directories; set
    `MIX_REBAR3` to the reviewed binary and activate every pinned tool version.
  - [ ] Run `scripts/run-clean-candidate.mjs` twice with
    `--ref "${RELEASE_SHA}"`, then run `scripts/compare-candidate-builds.mjs`.
  - [ ] Require equivalent records and actual archives, and record the final
    archive SHA-256, entry count, CSS hash, documentation inventory, gallery
    inventory, input-manifest hash, provenance hash, toolchain, and source SHA.
  - [ ] Audit the archive generated by each build rather than a copied or
    historical archive.

- [ ] 4.2 Section - Consume the final archive in isolation.

  - [ ] Run `scripts/run-clean-consumer.mjs` against the archive selected from
    the final comparison.
  - [ ] Require the recorded archive checksum to equal the selected final
    archive checksum and all compile, test, browser, stylesheet, metadata, and
    runtime-boundary assertions to pass.
  - [ ] Remove disposable consumers and worktrees while retaining only the
    required evidence outputs in their approved location.

- [ ] 4.3 Section - Make the final go/no-go packet.

  - [ ] Recheck the Fly gallery's public `1.0.0` identity and canonical smoke;
    redeploy only if Phase 1 identified a material gallery/package mismatch.
  - [ ] Assemble one immutable packet linking independent approval,
    `RELEASE_SHA` CI, both build records, comparison, archive audit, consumer
    record, gallery smoke, waiver, and public-Hex absence check.
  - [ ] Require every mandatory gate except Hex publication and the public tag
    to be passing. Any stale, missing, contradictory, or SHA-mismatched item is
    a no-go.

## Phase 5 - Authorize and publish

- [ ] 5.1 Section - Perform the final dry run.

  - [ ] Create a fresh detached clean checkout at `RELEASE_SHA`, activate the
    pinned toolchain, install locked dependencies, rebuild, and rerun the actual
    archive audit.
  - [ ] Run the installed Hex client's supported publish dry-run from that
    checkout and review the exact package name, version, organization/owner,
    files, dependencies, licenses, links, description, and documentation.
  - [ ] Recheck that `shadcn_ui 1.0.0` is absent from public Hex and that the
    archive checksum matches the approved final archive.
  - [ ] Make no tracked change in the detached checkout.

- [ ] 5.2 Section - Obtain irreversible-action authorization.

  - [ ] Present the go/no-go packet and exact `RELEASE_SHA` to the release owner.
  - [ ] Obtain explicit authorization to execute `mix hex.publish`; earlier
    authorization to prepare, deploy Fly, merge a PR, or write this plan is not
    publication authorization.
  - [ ] If authorization is declined or evidence has expired, stop without a
    public tag or Hex mutation.

- [ ] 5.3 Section - Publish exactly once.

  - [ ] Run `mix hex.publish` from the approved detached checkout, using the
    authenticated intended owner and no unreviewed environment override.
  - [ ] Capture the command result, package checksum, public release URL,
    timestamp, authenticated owner, and `RELEASE_SHA` without capturing the API
    key.
  - [ ] Do not retry an ambiguous result until public Hex is queried for
    `shadcn_ui 1.0.0`; never attempt to overwrite the version.

## Phase 6 - Verify, tag, and reconcile

- [ ] 6.1 Section - Verify the public consumer experience.

  - [ ] Verify the public Hex version page and package checksum.
  - [ ] Create a new disposable Phoenix project that installs
    `{:shadcn_ui, "~> 1.0"}` from the public Hex repository and rerun the
    representative compile, render, stylesheet, and no-consumer-toolchain
    checks.
  - [ ] Verify HexDocs completed and that the landing page, public modules,
    guides, source links, stylesheet guidance, license, and version are
    reachable. If docs fail, diagnose and use the supported same-version docs
    publication path; do not republish the package archive.

- [ ] 6.2 Section - Create the exact public tag.

  - [ ] Create annotated tag `v1.0.0` at `RELEASE_SHA` only after public package
    and documentation verification passes.
  - [ ] Verify the local tag target and push that single tag.
  - [ ] Verify the remote tag resolves to `RELEASE_SHA`; do not move a public
    version tag after publication.

- [ ] 6.3 Section - Reconcile post-publication truth.

  - [ ] In a new documentation-only branch, update
    `release/candidate-status.json`, release records, and milestone/planning
    status with the exact Hex, HexDocs, tag, CI, build, consumer, review, and
    publication evidence.
  - [ ] Keep the accessibility scenarios pending/waived and preserve all
    non-claims and historical hashes.
  - [ ] Run release-evidence checks, `mix spec.next`,
    `mix spec.check --base HEAD`, and `git diff --check`.
  - [ ] Open and merge a second, post-publication record PR. This PR is separate
    because publication success and public URLs cannot be recorded truthfully
    before the external event occurs; it is intentionally not part of the
    `v1.0.0` source tag.

## Stop and recovery rules

- Before publication, any failure stops the release. Fix through a reviewed PR,
  select a new `RELEASE_SHA`, and repeat every SHA-bound gate.
- A network timeout during publication is ambiguous, not an automatic retry.
  Query Hex first and escalate with the captured non-secret transaction result.
- A published Hex version is never replaced in place. If a material defect is
  found, record it, retire the affected release when appropriate, and prepare a
  new reviewed patch release such as `1.0.1`.
- Fly rollback is independent of Hex rollback. Only a gallery-affecting defect
  uses the documented Fly rollback procedure and recovery smoke.
- Never delete or edit retained evidence to make a failed gate appear passing.

## Completion criteria

The release is complete only when all of the following are true:

- [ ] Two clean pinned-toolchain builds of `RELEASE_SHA` are equivalent and
  both actual archives pass the allowlist audit.
- [ ] The selected archive passes the isolated local Hex-repository consumer
  trial and a fresh public-Hex consumer check.
- [ ] Independent source approval, qualification merge, and CI on
  `RELEASE_SHA` are recorded.
- [ ] The live gallery still reports the intended `1.0.0` identity and passes
  canonical smoke.
- [ ] The owner explicitly authorized publication and Hex exposes
  `shadcn_ui 1.0.0` with the approved checksum.
- [ ] HexDocs is available and `v1.0.0` resolves to `RELEASE_SHA` remotely.
- [ ] Post-publication ledgers are truthful, machine-readable, reviewed, green,
  and merged.

## Delivery model

Execution deliberately uses two PRs:

1. One independently reviewed qualification PR for all source and
   pre-publication record changes. Complete its sections with one commit per
   section where repository changes are needed.
2. One documentation-only reconciliation PR after Hex, HexDocs, and the tag are
   observable. It records external facts and does not change the tagged
   `1.0.0` source.

Hex publication and tag creation happen between those PRs only after the
explicit authorization gate.
