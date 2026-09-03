# Phase 6 - Gallery, Documentation, And Milestone Acceptance

Back to wave: [README](./README.md)

## Dependencies and contracts

Requires all six public components and their reference pages from Phases 2–5, plus Phase 1 evidence/fixture infrastructure.

- [motion_media_contract](../../specs/motion_media_contract.spec.md)
- [media_components](../../specs/media_components.spec.md)
- [motion_components](../../specs/motion_components.spec.md)
- [motion_media_gallery](../../specs/motion_media_gallery.spec.md)

- [x] 6 Phase - Gallery, Documentation, And Milestone Acceptance.

  Consolidate all Motion and Media references, complete compositions, capability and performance evidence, public documentation and release audits without deferring essential component demos until this phase.

  - [x] 6.1 Section - Complete catalogue, compositions and capability guidance.

    Bring all implemented pieces together while preserving prior milestone routes and honest native semantics.

    - [x] 6.1.1 Task - Audit every reference and complete the media compositions.

      The final catalogue should be navigable, consistent and genuinely interactive at its native boundary.

      - [x] 6.1.1.1 Subtask - Verify all Media/Motion leaves and prior A–D routes, breadcrumbs/current-page state, source blocks, canonical URLs, sitemap/export and nonreflecting unknown/mismatched routes.
      - [x] 6.1.1.2 Subtask - Finish media-browser, image-gallery and motion-preferences as complete pages with local fixtures and ordinary destinations; remove no-op controls and label authored snapshots plainly.
      - [x] 6.1.1.3 Subtask - Compare Carousel versus tabs/slideshow, Cover Flow versus selection, decorative Scroll Indicator versus Progress/Meter, and finite Marquee/Stagger versus application animation controllers.

    - [x] 6.1.2 Task - Finalize capability and motion inspection evidence.

      A support matrix must distinguish observations from policy and explain every unavailable visual effect.

      - [x] 6.1.2.1 Subtask - Regenerate source-reviewed exact-engine evidence and record supported behavior, fallback and deferred generated controls/origin transitions without changing the capability-based target.
      - [x] 6.1.2.2 Subtask - Verify system/reduce links preserve themes, invalid queries are safe and user reduced motion cannot be overridden; export deterministic combinations and no-script defaults.
      - [x] 6.1.2.3 Subtask - Explain static/no-snap/no-timeline/no-anchor/no-transition paths, failed images, native loading limits, finite offscreen work and replacement ownership on relevant pages.

  - [x] 6.2 Section - Public API, CSS, provenance and candidate documentation.

    Make the reusable library understandable independently of the demo and build tools.

    - [x] 6.2.1 Task - Complete all API and accessibility documentation.

      Users should not need to infer contracts from source or visual styling.

      - [x] 6.2.1.1 Subtask - Verify every defining function's attrs/slots/defaults/closed values, stable-key/ID derivations, globals, text escaping, image metadata and compilable HEEx examples in ExDoc.
      - [x] 6.2.1.2 Subtask - Document native keyboard/focus, real index links, dialog exits, canonical/clone distinction, persistent stop/reset, suppression hierarchy and exact fallback behavior.
      - [x] 6.2.1.3 Subtask - Describe media rights/privacy/CSP, loading hints, client-state replacement, performance budgets and deliberately excluded application/runtime features.

    - [x] 6.2.2 Task - Finalize provenance, asset exceptions and release records.

      Every distributed adaptation and every excluded demo asset must have an explicit audit trail.

      - [x] 6.2.2.1 Subtask - Audit all six component/CSS mappings at the reviewed upstream revision, full MIT notice, independent identity and no automatic sync; record newly authored versus adapted material honestly.
      - [x] 6.2.2.2 Subtask - Reconcile the authored CSS exception ledger and local fixture licenses/hashes with actual source, retaining no upstream site assets, remote runtime URLs or mutable data.
      - [x] 6.2.2.3 Subtask - Update README, changelog, package catalogue, release evidence and deployment/rollback runbook; distinguish local/CI/manual/deployed status and keep Milestone F separate.

  - [x] 6.3 Section - Cross-engine accessibility and bounded-work acceptance.

    Exercise the complete real gallery and quantify the intended motion/media limits without promising unmeasured performance.

    - [x] 6.3.1 Task - Run the complete semantic and fallback matrix.

      Native operation and content availability are required across the whole supported/fallback matrix.

      - [x] 6.3.1.1 Subtask - Run all Milestone E component fixtures and real gallery pages in exact locked Chromium/Firefox/WebKit builds with actual and deliberately disabled capabilities.
      - [x] 6.3.1.2 Subtask - Run pinned axe and explicit native keys/focus, lists, images/alt/captions, dialog names/exits, checkbox stop/reset, hidden nonfocusable clones, IDs and forbidden-role checks across both themes.
      - [x] 6.3.1.3 Subtask - Cover narrow/wide/200-percent zoom, RTL/long content, forced colors, reduced-motion changes, touch, CSS-disabled/no-script, image failure, independent instances, replacement and static subpath artifacts; record a bounded screen-reader/manual keyboard review separately.

    - [x] 6.3.2 Task - Measure and record motion and media budgets.

      Performance checks should inspect bounded work rather than rely on a generic fast-page claim.

      - [x] 6.3.2.1 Subtask - Use fixed 1/8/24-item fixtures and record DOM/clone counts, asset bytes and unique media requests against the fixture manifest; reject unbounded duplication or unlisted loads.
      - [x] 6.3.2.2 Subtask - Check Marquee ends within five seconds, Stagger within one second, excess items stay visible and static sources do not advance scroll-driven effects; confirm no perpetual offscreen animation or package listener/observer/polling.
      - [x] 6.3.2.3 Subtask - Record measured evidence and browser-specific gaps without universal frame-rate promises; do not use hidden content, missing accessibility or native behavior shims to satisfy timing.

  - [x] 6.4 Section - Phase 6 Integration Tests.

    Close the milestone with package, live gallery, static export, provenance and release-boundary proof while keeping unresolved infrastructure gates visible.

    - [x] 6.4.1 Task - Verify milestone-wide contracts and prior regressions.

      Acceptance should connect every requirement to an implemented test and an actual output.

      - [x] 6.4.1.1 Subtask - Add milestone_e_acceptance_test.exs and milestone-e-gallery.spec.mjs covering the specification IDs, public imports/metadata, closed catalogue, compositions, capability records and absent runtimes.
      - [x] 6.4.1.2 Subtask - Run all new and affected A–D rendering/browser suites, package/demo precommit and exact-engine E matrix, preserving existing acceptance tests instead of replacing them.
      - [x] 6.4.1.3 Subtask - Confirm every new reference is present in the real demo and exported artifact; separately record manual checks and unresolved limitations rather than claiming full certification from axe.

    - [x] 6.4.2 Task - Verify deterministic release and publication readiness.

      A milestone candidate must be independently reproducible and must not conflate merge with successful publication.

      - [x] 6.4.2.1 Subtask - Run locked npm/Mix setup, asset builds/checks, actual-HEEx fixture comparisons, two byte-identical exports, media/canonical/sitemap audits, static subpath smoke, ExDoc, provenance/MIT checks and actual Hex archive allowlist inspection.
      - [x] 6.4.2.2 Subtask - Run mix spec.next, mix spec.check --base main and --base HEAD, plus git diff --check; record any known local runner issue without disabling gates or marking failed checks passed.
      - [x] 6.4.2.3 Subtask - Record final evidence, implementation status and remaining CI/publication work; commit section by section and open one phase PR. Publish only through the reviewed deployment after merge and verify canonical direct routes/media then.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge that PR without a later request.
Keep all checkboxes unchecked until the corresponding implementation and proof
land. Update relevant specifications only after reading their full contracts.

## Execution record

2026-08-26, native Windows / Elixir 1.20.3 / OTP 29. PR #18 merged first;
local main fast-forwarded to a49af6e and matched origin before its Phase 5 branch
was deleted locally/remotely. Phase 6 uses four section commits and one PR.

- 6.1: A–E catalogue audit, real composition current links/breadcrumbs, native
  capability/fallback guidance and complete E publication smoke inventory.
  Twenty focused demo tests, exact-engine capability/origin reproduction and
  byte-identical exports passed. Commit 33eb0b0.
- 6.2: Six defining ExDoc groups, a compiled six-component HEEx guide, API and
  ownership guidance, candidate/deployment records. Nineteen focused package
  tests, warning-free ExDoc and actual 61-entry archive audit passed.
  Commit 63dd3da.
- 6.3: Fixed 1/8/24-item actual HEEx and measured DOM/media/finite-work evidence.
  Nine new cases reproduced all observations twice across locked engines;
  existing E Phases 1–5 passed 225 cases. Manual AT/physical-device review is
  explicitly pending in its separate checklist, not claimed by this checkbox.
  Commit f1dfa16.
- 6.4: Final package and live/static gallery acceptance, preserved A–D regressions,
  deterministic release audit and CI fixture/browser gates. Root precommit 369,
  demo 62, total distinct browser cases 469 (E 249, D 177, other A–C 43) passed.
  All eight generated fixture comparisons, locked npm/Mix setup, assets,
  ExDoc, 634-variant deterministic export, selected media/canonical/sitemap/subpath
  checks and actual archive audit passed. Final E6 rerun passed 24 cases after
  motion-link spacing correction. Existing Help selector is now exact and
  controller marker expectations account for new navigation/breadcrumbs.

Both required SpecLed bases report four existing nested-login-shell/rebar
dependency-compilation failures and 136 warnings (22 subjects / 214 requirements).
Direct equivalent commands pass; no gate was weakened. Broad shared-file
reconciliation does not warrant changing unrelated component contracts.
See [candidate evidence](../../../release/records/milestone-e-acceptance.md) for commands,
measurements and explicit pending NVDA/VoiceOver, physical touch, browser-UI zoom,
Linux symlink, CI and post-merge Pages checks. No Hex publication, deployed
success or accessibility certification is claimed. All E implementation phases
are delivered; release acceptance gates and Milestone F remain separate.
