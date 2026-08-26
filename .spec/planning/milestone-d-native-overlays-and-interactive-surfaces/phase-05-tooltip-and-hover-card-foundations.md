# Phase 5 - Tooltip And Hover Card Foundations

Back to wave: [README](./README.md)

- [x] 5 Phase - Publish deliberately supplemental CSS-first Tooltip and Hover
  Card surfaces without claiming unavailable interest-invoker behavior.

  This phase provides useful focus and hover presentation while ensuring labels,
  instructions, destinations, task information, and actions remain complete
  when visual supplemental content is absent.

  - [x] 5.1 Section - Noninteractive Tooltip description.

    This section implements one deterministic accessible description and a
    nonfocusable visual bubble around an already complete native trigger.

    - [x] 5.1.1 Task - Implement Tooltip semantics and identity.

      Tooltip should supplement a focusable trigger without becoming its only
      accessible name, a required instruction, or an interactive container.

      - [x] 5.1.1.1 Subtask - Add a defining Overlays.Tooltip module with required stable ID, one natively focusable caller trigger, short escaped text content, and closed logical placement.
      - [x] 5.1.1.2 Subtask - Derive and protect aria-describedby identity, render one role tooltip bubble, keep it nonfocusable, and reject interactive descendants and raw HTML strings.
      - [x] 5.1.1.3 Subtask - Preserve the trigger's native accessible name, type or destination, disabled state, focus, activation, and caller application attributes unchanged.
      - [x] 5.1.1.4 Subtask - Validate nonblank supplemental text, relationship merging, duplicate references, conflicting globals, stable rerenders, caller classes, escaping, and invalid trigger content.

    - [x] 5.1.2 Task - Add CSS focus, hover, placement, and fallback behavior.

      Visual presentation should help compatible pointer and keyboard users while
      the accessible description remains the nonvisual semantic relationship.

      - [x] 5.1.2.1 Subtask - Add hover and focus-visible CSS presentation, bounded sizing, wrapping, logical placement, and capability-gated anchor positioning without event listeners or timers.
      - [x] 5.1.2.2 Subtask - Remove visual delay and transitions under reduced motion and preserve explicit boundaries, trigger focus, and description contrast in forced colors and themes.
      - [x] 5.1.2.3 Subtask - Verify CSS-disabled, no-hover, coarse-pointer, no-script, unsupported-anchor, narrow viewport, zoom, long translated text, RTL, and clipped-container behavior.
      - [x] 5.1.2.4 Subtask - Document that required labels, errors, instructions, status, and task information belong in visible components rather than Tooltip.

  - [x] 5.2 Section - Link-owned Hover Card preview.

    This section adds bounded preview presentation while leaving an ordinary link
    as the complete destination and coarse-pointer fallback.

    - [x] 5.2.1 Task - Implement Hover Card structure and link contract.

      Hover Card should enrich destination context without changing navigation,
      focus, authorization, or the information available from the link itself.

      - [x] 5.2.1.1 Subtask - Add a defining Overlays.HoverCard module with required stable ID, one caller-owned link trigger, trusted supplemental preview, and closed logical placement.
      - [x] 5.2.1.2 Subtask - Preserve link accessible name, href, target, rel, download, aria-current, focus, activation, context menu, and caller transport attributes.
      - [x] 5.2.1.3 Subtask - Reject required actions, forms, focusable controls, workflow state, authorization results, unique task information, and nested interactive preview content.
      - [x] 5.2.1.4 Subtask - Protect link and preview identities and relationships while forwarding unrelated documented classes and globals in deterministic order.

    - [x] 5.2.2 Task - Add bounded CSS preview and honest fallbacks.

      Hover and focus-within presentation should never intercept the underlying
      link or promise touch-interest behavior the package does not implement.

      - [x] 5.2.2.1 Subtask - Add hover and focus-within CSS visibility, bounded wrapping, logical placement, optional anchor positioning, and reduced-motion snap behavior.
      - [x] 5.2.2.2 Subtask - Keep the link fully usable when preview CSS, hover, focus-within, anchor positioning, or script is unavailable and treat coarse-pointer activation as ordinary navigation.
      - [x] 5.2.2.3 Subtask - Assert absence of interestfor, popover hint activation, timers, hover-intent algorithms, long-press emulation, focus movement, top-layer claims, and JavaScript.
      - [x] 5.2.2.4 Subtask - Document preview ownership, destination completeness, loading prohibition, privacy, analytics, replacement, content freshness, and future interest-invoker boundary.

  - [x] 5.3 Section - Phase 5 Integration Tests.

    This section verifies that supplemental surfaces improve presentation without
    becoming required, interactive, pointer-only, or runtime-driven interfaces.

    - [x] 5.3.1 Task - Verify Tooltip semantics and resilience.

      Tests should prove the description relationship remains valid even when
      the visual bubble cannot or should not appear.

      - [x] 5.3.1.1 Subtask - Test identity, describedby merging, role tooltip, escaped text, native trigger semantics, placement, caller globals, stable rerenders, and invalid or interactive content.
      - [x] 5.3.1.2 Subtask - Browser-test keyboard focus, pointer hover, pointer exit, trigger activation, visual nonfocusability, and accessible description retention.
      - [x] 5.3.1.3 Subtask - Test coarse pointer, CSS-disabled, no-hover, no-script, reduced motion, forced colors, zoom, narrow viewport, RTL, themes, long text, and unsupported anchor positioning.
      - [x] 5.3.1.4 Subtask - Audit examples and docs for required labels, errors, instructions, status, actions, or information hidden only in Tooltip.

    - [x] 5.3.2 Task - Verify Hover Card destination and fallback boundaries.

      Automated evidence should keep ordinary link navigation complete across
      every visual and input capability condition.

      - [x] 5.3.2.1 Subtask - Test link attributes, identity, trusted preview, placement, caller globals, escaping, forbidden interactive descendants, stable rerenders, and invalid values.
      - [x] 5.3.2.2 Subtask - Browser-test hover, keyboard focus, pointer transition within wrapper, ordinary Enter and click navigation, context menu, and focus order.
      - [x] 5.3.2.3 Subtask - Assert no interestfor, popover hint, timers, events, long press, focus movement, required preview content, client fetch, analytics, or package JavaScript.
      - [x] 5.3.2.4 Subtask - Run asset checks, package precommit, cross-engine supplemental suites, ExDoc, provenance and archive audits, `mix spec.check --base main`, and `git diff --check`.

## Phase 5 verification evidence

- Section 5.1 publishes Tooltip with a single structured text-labelled native
  button/link trigger, escaped description, stable deduplicated relationships,
  protected globals and CSS-only supplemental presentation.
- Section 5.2 publishes Hover Card with a complete ordinary link and trusted
  presentation-only HEEx preview. Its structural guard rejects interactive,
  focusable, fetching and stateful markup; content meaning, privacy, freshness
  and destination completeness remain explicit caller obligations.
- `mix precommit`: 317 package tests passed. The actual-component fixture passes
  `mix run scripts/render-supplemental-fixture.exs --check`.
- Phase 5: 36 browser checks passed in locked Chromium 151.0.7922.34, Firefox
  153.0 and WebKit 26.5. Prior Phase 1/2/3/4 regressions passed 21 + 21 + 30 + 30
  checks, for 138 total. Tests cover native names/descriptions, keyboard and
  pointer use, pointer transition/exit, context menu, activation, replacement,
  coarse pointer/no hover/no script, CSS-disabled/missing enhancement fallback,
  logical placement, themes, forced colors, motion, long text, zoom and RTL.
- Integration found and fixed preview interception of its own link, reduced-
  motion cascade precedence, and misleading ARIA globals. Scoped RTL anchor
  coordinates differ in the locked engines, so all RTL previews use the same
  readable normal-flow fallback without browser sniffing. Optional anchors are
  limited to wide LTR fine-pointer layouts; no top-layer claim is made.
- Deterministic CSS checks, ExDoc, Hex build, actual archive allowlist audit
  (51 entries), deterministic gallery export and whitespace checks passed.
  Tests, fixture generators, browser tooling and JavaScript stay out of releases.
- `mix spec.next --base main` and `mix spec.check --base main` were run. SpecLed
  still reports four nested command failures caused by the existing local
  Erlang/OTP 29 versus Elixir 1.18 rebar runner mismatch; the corresponding
  commands pass directly. Its 135 warnings concern historical coverage and
  future-phase references. This is not a clean SpecLed run. Relevant current
  supplemental/stylesheet subjects were reconciled; shared README surface
  matches do not change unrelated component contracts.
- Overlay gallery pages and final milestone acceptance remain Phase 6 work.
