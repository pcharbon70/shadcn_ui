# Phase 1 - Capability, Media, And Motion Foundations

Back to wave: [README](./README.md)

## Dependencies and contracts

Milestone D public native Dialog and gallery/export contracts are the baseline. Record its outstanding local SpecLed limitation separately; do not waive acceptance or mutate completed phase history.

- [motion_media_contract](../../specs/motion_media_contract.spec.md)
- [motion_media_gallery](../../specs/motion_media_gallery.spec.md)

- [ ] 1 Phase - Capability, Media, And Motion Foundations.

  Establish the shared native and CSS capability boundaries, image contracts, suppression rules, fixture inventory and proof harness before publishing concrete components.

  - [ ] 1.1 Section - Capability policy and cross-engine evidence.

    Turn variable platform support into explicit feature bundles and a reproducible evidence process that never makes one consumer or browser the package target.

    - [ ] 1.1.1 Task - Author the normative motion/media manifest and schema.

      The manifest should distinguish baseline content, eligible presentation and deliberately deferred native features.

      - [ ] 1.1.1.1 Subtask - Add motion_media.json and its schema with reviewed source links, date, required/optional/deferred status and component bundles for snap, :has, scroll/view timelines, ranges, scopes, transforms and inherited Dialog invocation; review all six upstream patterns at the existing provenance pin and record adaptation or independent implementation choices.
      - [ ] 1.1.1.2 Subtask - Inventory the existing locked Playwright engines and record their exact versions only after running them; add a separate demo observation record and deterministic recorder/check command.
      - [ ] 1.1.1.3 Subtask - Record generated scroll controls as deferred and origin-aware transition admission as evidence-dependent; document who reviews lock, source, CSS and fallback changes.

    - [ ] 1.1.2 Task - Create native and deliberately disabled-feature fixtures.

      The same semantic fixtures must run in each engine, including when individual optional features are removed.

      - [ ] 1.1.2.1 Subtask - Add test/browser/milestone-e-capabilities.spec.mjs and a locked three-engine configuration without user-agent or engine-name branching in package code.
      - [ ] 1.1.2.2 Subtask - Test each joint capability bundle and negative path rather than accepting one declaration check as proof of focus, accessibility or rendering.
      - [ ] 1.1.2.3 Subtask - Define source-review and behavior-result fields separately, retain exact versions and deterministic bytes, and exclude reports/recorders from the release.

  - [ ] 1.2 Section - Shared media identity and motion contracts.

    Implement reusable internal normalization so later components do not disagree about identity, image values, fallback or suppressed motion.

    - [ ] 1.2.1 Task - Normalize media records and protected native relationships.

      Image content and network policy remain caller-owned while malformed metadata and conflicting native semantics fail early.

      - [ ] 1.2.1.1 Subtask - Implement internal MediaContract normalization for stable unique keys, root-relative/HTTP(S) sources, explicit alternative-text intent, intrinsic dimensions and optional responsive/native loading fields.
      - [ ] 1.2.1.2 Subtask - Reject duplicate or blank identities, unsafe schemes, missing meaningful alternatives, malformed dimensions and conflicting required globals without fetching URLs or creating atoms.
      - [ ] 1.2.1.3 Subtask - Define deterministic item/invoker/dialog IDs, full-size image record rules, caller classes and safe unrelated globals; add focused unit and escaping tests.

    - [ ] 1.2.2 Task - Normalize bounded motion and document replacement.

      One suppression rule must override every new enhancement without pretending to manage browser-local state.

      - [ ] 1.2.2.1 Subtask - Implement internal MotionContract closed system/none values and a documented data-shadcn-motion=reduce ancestor scope that cannot be re-enabled by a nested component.
      - [ ] 1.2.2.2 Subtask - Define finite Marquee and Stagger budgets, clamped sequence windows and complete static output; record that offscreen finite effects may finish but never loop indefinitely.
      - [ ] 1.2.2.3 Subtask - Document native checkbox, scroll and dialog state loss after replacement; test invalid values, deterministic renders and no persistence, observer or restoration runtime.

  - [ ] 1.3 Section - Scoped CSS, demo fixtures and capability inspection.

    Prepare the minimal shared CSS and static media distribution needed by all later component pages.

    - [ ] 1.3.1 Task - Record authored CSS exceptions and suppression fallbacks.

      Every non-utility CSS block needs a narrow reason and a testable static path.

      - [ ] 1.3.1.1 Subtask - Create the authored exception ledger with scope, utility limitation, source pin, feature guard, fallback, motion behavior and test mapping; update it whenever new blocks land.
      - [ ] 1.3.1.2 Subtask - Add namespaced suppression, stable visible-content baselines, focus/forced-color treatment and instance isolation; preserve sRGB/light/dark tokens and no unrestricted reset.
      - [ ] 1.3.1.3 Subtask - Audit release boundaries and public imports for no new runtime; document the planned six defining modules without exporting unfinished APIs.

    - [ ] 1.3.2 Task - Add deterministic local fixture and gallery inspection infrastructure.

      The demo may display evidence and media without expanding the package payload or allowing request-selected assets.

      - [ ] 1.3.2.1 Subtask - Create a small demo-only licensed/authored image fixture set and manifest containing keys, files, MIME, dimensions, byte sizes, source/license and hashes; include intentionally failing image cases.
      - [ ] 1.3.2.2 Subtask - Extend the closed exporter from three style/script assets to three plus selected fixture media; reject traversal, escaping symlinks, unknown files, stale copies and remote build fetches.
      - [ ] 1.3.2.3 Subtask - Add the actual /examples/motion-media-capabilities page plus system/reduce inspection links, safe invalid values, theme preservation, canonical/sitemap rules and no-script export variants.

  - [ ] 1.4 Section - Phase 1 Integration Tests.

    Prove the shared contracts and distribution boundary before later phases depend on them.

    - [ ] 1.4.1 Task - Verify contracts, capability evidence and static paths.

      Positive and negative cases must establish a meaningful fallback rather than merely checking source strings.

      - [ ] 1.4.1.1 Subtask - Run shared normalization/schema tests for every accepted/rejected field, key, reference, source, dimension, motion value and global override; attach exact requirement IDs.
      - [ ] 1.4.1.2 Subtask - Execute identical native/disabled-capability fixtures in all locked engines, including missing :has, absent timelines, nested suppression, CSS-disabled, no-script and DOM replacement.
      - [ ] 1.4.1.3 Subtask - Verify closed capability routes, source links, safe query defaults, fixtures, media hashes, subpath resolution and two identical exports with no remote media requests.

    - [ ] 1.4.2 Task - Verify independent builds and retain milestone evidence.

      The foundation is complete only when its package and demo implications are checked and recorded.

      - [ ] 1.4.2.1 Subtask - Run package/demo precommit, locked asset builds and deterministic comparisons, CSS isolation, provenance/MIT audits, ExDoc and actual Hex archive allowlist inspection.
      - [ ] 1.4.2.2 Subtask - Run current A–D regressions affected by CSS, assets or gallery routing; prove fixture media, observations, scripts and harnesses remain excluded from releases.
      - [ ] 1.4.2.3 Subtask - Run mix spec.next, mix spec.check --base main and git diff --check; record commands, exact engines, limitations and results without treating planning as implementation.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge that PR without a later request.
Keep all checkboxes unchecked until the corresponding implementation and proof
land. Update relevant specifications only after reading their full contracts.
