# Phase 1 - Browser Capability And Shared Overlay Foundations

Back to wave: [README](./README.md)

- [ ] 1 Phase - Establish the reusable browser-capability contract and shared
  native overlay rules before publishing any concrete overlay component.

  This phase converts variable web-platform support into explicit testable
  capabilities, protects the package's no-runtime boundary, and defines common
  identity, invocation, focus, dismissal, replacement, and fallback behavior.

  - [x] 1.1 Section - Cross-engine capability matrix and runtime boundary.

    This section records what the package relies on and distinguishes normative
    feature requirements from the exact browser versions used as test evidence.

    - [x] 1.1.1 Task - Build the authored native overlay capability matrix.

      The matrix should make each feature assumption inspectable without
      declaring a consuming application or one browser engine as the target.

      - [x] 1.1.1.1 Subtask - Add an authored manifest for dialog, commandfor, closedby, Popover, popovertarget, anchor positioning, position fallbacks, discrete transitions, and interest-invoker exclusion.
      - [x] 1.1.1.2 Subtask - Record authoritative standard or browser-documentation sources, review date, required component capability sets, and exact locked Chromium, Firefox, and WebKit evidence versions.
      - [x] 1.1.1.3 Subtask - Separate normative capabilities from current test implementations and reject browser-name, operating-system, embedded-runtime, and consumer-product targeting.
      - [x] 1.1.1.4 Subtask - Define review and change-control rules for updating locks, support claims, fallbacks, or the interest-invoker exclusion.

    - [x] 1.1.2 Task - Preserve the zero-package-JavaScript boundary.

      Overlay support should rely on accepted native behavior without quietly
      introducing a polyfill, focus manager, or positioning framework.

      - [x] 1.1.2.1 Subtask - Audit Mix, npm, release, public-import, stylesheet, and provenance boundaries for new runtime or consumer asset dependencies.
      - [x] 1.1.2.2 Subtask - Add explicit rejection tests for package scripts, invoker shims, focus traps, overlay stacks, positioning engines, custom elements, hooks, and client state processes.
      - [x] 1.1.2.3 Subtask - Define the caller-owned ordinary destination, visible content, or non-overlay operation required when an HTML capability is unavailable.
      - [x] 1.1.2.4 Subtask - Keep capability display or test helpers in demo and test surfaces excluded from package release contents.

  - [ ] 1.2 Section - Shared identity, invocation, state, and fallback contract.

    This section provides reusable internal helpers and public rules so each
    component does not invent incompatible overlay relationships or ownership.

    - [ ] 1.2.1 Task - Implement deterministic overlay identity and native relationships.

      Invokers, surfaces, labels, descriptions, and explicit exits should share
      one validated derivation model with protected native semantics.

      - [ ] 1.2.1.1 Subtask - Add internal normalization for nonblank base IDs, stable keys, invoker IDs, surface IDs, title IDs, description IDs, close IDs, and initial-focus targets.
      - [ ] 1.2.1.2 Subtask - Add closed native dialog commands, Popover target actions, dismissal policies, modes, and logical placement values mapped without request-derived atoms.
      - [ ] 1.2.1.3 Subtask - Protect command targets, Popover targets, IDs, names, roles, native elements, open state, closedby, autofocus, and derived relationships from conflicting globals.
      - [ ] 1.2.1.4 Subtask - Preserve unrelated class, native, aria-*, data-*, phx-*, and data-on-* globals in deterministic order.

    - [ ] 1.2.2 Task - Define browser-local state and DOM-replacement ownership.

      The package should state exactly what a server-rendered snapshot means and
      what may be lost when an application replaces an open overlay subtree.

      - [ ] 1.2.2.1 Subtask - Document browser-local open state, native toggle and close behavior, caller-owned server state, and the absence of synchronization or persistence.
      - [ ] 1.2.2.2 Subtask - Define replacement outcomes for controller navigation, Phoenix patches, Dstar, and LiveView without importing any transport dependency.
      - [ ] 1.2.2.3 Subtask - Bound nesting to one native Popover inside a Dialog-family surface and reject nested modals, arbitrary stacks, submenus, and virtual anchors.
      - [ ] 1.2.2.4 Subtask - Add shared capability-gated CSS foundations for backdrops, top-layer sizing, anchor fallbacks, discrete transitions, reduced motion, forced colors, and safe bounded placement.

  - [ ] 1.3 Section - Phase 1 Integration Tests.

    This section verifies that later overlay components can rely on one honest,
    transport-neutral, cross-engine foundation without runtime expansion.

    - [ ] 1.3.1 Task - Verify capability and shared-contract evidence.

      Automated checks should prove the matrix, normalization, protected
      semantics, fallback rules, and cross-engine harness agree.

      - [ ] 1.3.1.1 Subtask - Test every accepted and rejected capability-manifest value, source field, review date, engine evidence field, and component capability mapping.
      - [ ] 1.3.1.2 Subtask - Test deterministic identity, invalid values, conflicting globals, escaping, caller classes, native command and Popover relationships, and stable rerenders.
      - [ ] 1.3.1.3 Subtask - Exercise supported and deliberately disabled-feature fixtures in locked Chromium, Firefox, and WebKit projects without browser-name branching.
      - [ ] 1.3.1.4 Subtask - Test replacement, explicit fallback destination, CSS-disabled, no-script, nested Popover, rejected nested modal, and absent-transition behavior.

    - [ ] 1.3.2 Task - Verify package, stylesheet, and release boundaries.

      The first phase should fail early if overlay foundations leak test or
      compatibility machinery into the independently distributable package.

      - [ ] 1.3.2.1 Subtask - Audit runtime dependencies and release allowlists for demo, browser harness, scripts, capability reports, remote assets, and JavaScript exclusions.
      - [ ] 1.3.2.2 Subtask - Rebuild the canonical CSS and verify prefixes, explicit sources, capability queries, deterministic bytes, no unrestricted reset, and no remote imports.
      - [ ] 1.3.2.3 Subtask - Run package precommit, locked asset checks, focused cross-engine tests, ExDoc, provenance and archive audits.
      - [ ] 1.3.2.4 Subtask - Run `mix spec.check --base main`, `git diff --check`, and record Phase 1 capability and package-boundary evidence.
