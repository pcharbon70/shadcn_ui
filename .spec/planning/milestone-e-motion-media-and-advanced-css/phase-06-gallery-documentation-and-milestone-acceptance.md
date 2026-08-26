# Phase 6 - Gallery, Documentation, And Milestone Acceptance

Back to wave: [README](./README.md)

## Dependencies and contracts

Requires all six public components and their reference pages from Phases 2–5, plus Phase 1 evidence/fixture infrastructure.

- [motion_media_contract](../../specs/motion_media_contract.spec.md)
- [media_components](../../specs/media_components.spec.md)
- [motion_components](../../specs/motion_components.spec.md)
- [motion_media_gallery](../../specs/motion_media_gallery.spec.md)

- [ ] 6 Phase - Gallery, Documentation, And Milestone Acceptance.

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

  - [ ] 6.2 Section - Public API, CSS, provenance and candidate documentation.

    Make the reusable library understandable independently of the demo and build tools.

    - [ ] 6.2.1 Task - Complete all API and accessibility documentation.

      Users should not need to infer contracts from source or visual styling.

      - [ ] 6.2.1.1 Subtask - Verify every defining function's attrs/slots/defaults/closed values, stable-key/ID derivations, globals, text escaping, image metadata and compilable HEEx examples in ExDoc.
      - [ ] 6.2.1.2 Subtask - Document native keyboard/focus, real index links, dialog exits, canonical/clone distinction, persistent stop/reset, suppression hierarchy and exact fallback behavior.
      - [ ] 6.2.1.3 Subtask - Describe media rights/privacy/CSP, loading hints, client-state replacement, performance budgets and deliberately excluded application/runtime features.

    - [ ] 6.2.2 Task - Finalize provenance, asset exceptions and release records.

      Every distributed adaptation and every excluded demo asset must have an explicit audit trail.

      - [ ] 6.2.2.1 Subtask - Audit all six component/CSS mappings at the reviewed upstream revision, full MIT notice, independent identity and no automatic sync; record newly authored versus adapted material honestly.
      - [ ] 6.2.2.2 Subtask - Reconcile the authored CSS exception ledger and local fixture licenses/hashes with actual source, retaining no upstream site assets, remote runtime URLs or mutable data.
      - [ ] 6.2.2.3 Subtask - Update README, changelog, package catalogue, release evidence and deployment/rollback runbook; distinguish local/CI/manual/deployed status and keep Milestone F separate.

  - [ ] 6.3 Section - Cross-engine accessibility and bounded-work acceptance.

    Exercise the complete real gallery and quantify the intended motion/media limits without promising unmeasured performance.

    - [ ] 6.3.1 Task - Run the complete semantic and fallback matrix.

      Native operation and content availability are required across the whole supported/fallback matrix.

      - [ ] 6.3.1.1 Subtask - Run all Milestone E component fixtures and real gallery pages in exact locked Chromium/Firefox/WebKit builds with actual and deliberately disabled capabilities.
      - [ ] 6.3.1.2 Subtask - Run pinned axe and explicit native keys/focus, lists, images/alt/captions, dialog names/exits, checkbox stop/reset, hidden nonfocusable clones, IDs and forbidden-role checks across both themes.
      - [ ] 6.3.1.3 Subtask - Cover narrow/wide/200-percent zoom, RTL/long content, forced colors, reduced-motion changes, touch, CSS-disabled/no-script, image failure, independent instances, replacement and static subpath artifacts; record a bounded screen-reader/manual keyboard review separately.

    - [ ] 6.3.2 Task - Measure and record motion and media budgets.

      Performance checks should inspect bounded work rather than rely on a generic fast-page claim.

      - [ ] 6.3.2.1 Subtask - Use fixed 1/8/24-item fixtures and record DOM/clone counts, asset bytes and unique media requests against the fixture manifest; reject unbounded duplication or unlisted loads.
      - [ ] 6.3.2.2 Subtask - Check Marquee ends within five seconds, Stagger within one second, excess items stay visible and static sources do not advance scroll-driven effects; confirm no perpetual offscreen animation or package listener/observer/polling.
      - [ ] 6.3.2.3 Subtask - Record measured evidence and browser-specific gaps without universal frame-rate promises; do not use hidden content, missing accessibility or native behavior shims to satisfy timing.

  - [ ] 6.4 Section - Phase 6 Integration Tests.

    Close the milestone with package, live gallery, static export, provenance and release-boundary proof while keeping unresolved infrastructure gates visible.

    - [ ] 6.4.1 Task - Verify milestone-wide contracts and prior regressions.

      Acceptance should connect every requirement to an implemented test and an actual output.

      - [ ] 6.4.1.1 Subtask - Add milestone_e_acceptance_test.exs and milestone-e-gallery.spec.mjs covering the specification IDs, public imports/metadata, closed catalogue, compositions, capability records and absent runtimes.
      - [ ] 6.4.1.2 Subtask - Run all new and affected A–D rendering/browser suites, package/demo precommit and exact-engine E matrix, preserving existing acceptance tests instead of replacing them.
      - [ ] 6.4.1.3 Subtask - Confirm every new reference is present in the real demo and exported artifact; separately record manual checks and unresolved limitations rather than claiming full certification from axe.

    - [ ] 6.4.2 Task - Verify deterministic release and publication readiness.

      A milestone candidate must be independently reproducible and must not conflate merge with successful publication.

      - [ ] 6.4.2.1 Subtask - Run locked npm/Mix setup, asset builds/checks, actual-HEEx fixture comparisons, two byte-identical exports, media/canonical/sitemap audits, static subpath smoke, ExDoc, provenance/MIT checks and actual Hex archive allowlist inspection.
      - [ ] 6.4.2.2 Subtask - Run mix spec.next, mix spec.check --base main and --base HEAD, plus git diff --check; record any known local runner issue without disabling gates or marking failed checks passed.
      - [ ] 6.4.2.3 Subtask - Record final evidence, implementation status and remaining CI/publication work; commit section by section and open one phase PR. Publish only through the reviewed deployment after merge and verify canonical direct routes/media then.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge that PR without a later request.
Keep all checkboxes unchecked until the corresponding implementation and proof
land. Update relevant specifications only after reading their full contracts.
