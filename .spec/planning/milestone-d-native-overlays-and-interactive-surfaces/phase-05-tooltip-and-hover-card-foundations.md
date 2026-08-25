# Phase 5 - Tooltip And Hover Card Foundations

Back to wave: [README](./README.md)

- [ ] 5 Phase - Publish deliberately supplemental CSS-first Tooltip and Hover
  Card surfaces without claiming unavailable interest-invoker behavior.

  This phase provides useful focus and hover presentation while ensuring labels,
  instructions, destinations, task information, and actions remain complete
  when visual supplemental content is absent.

  - [ ] 5.1 Section - Noninteractive Tooltip description.

    This section implements one deterministic accessible description and a
    nonfocusable visual bubble around an already complete native trigger.

    - [ ] 5.1.1 Task - Implement Tooltip semantics and identity.

      Tooltip should supplement a focusable trigger without becoming its only
      accessible name, a required instruction, or an interactive container.

      - [ ] 5.1.1.1 Subtask - Add a defining Overlays.Tooltip module with required stable ID, one natively focusable caller trigger, short escaped text content, and closed logical placement.
      - [ ] 5.1.1.2 Subtask - Derive and protect aria-describedby identity, render one role tooltip bubble, keep it nonfocusable, and reject interactive descendants and raw HTML strings.
      - [ ] 5.1.1.3 Subtask - Preserve the trigger's native accessible name, type or destination, disabled state, focus, activation, and caller application attributes unchanged.
      - [ ] 5.1.1.4 Subtask - Validate nonblank supplemental text, relationship merging, duplicate references, conflicting globals, stable rerenders, caller classes, escaping, and invalid trigger content.

    - [ ] 5.1.2 Task - Add CSS focus, hover, placement, and fallback behavior.

      Visual presentation should help compatible pointer and keyboard users while
      the accessible description remains the nonvisual semantic relationship.

      - [ ] 5.1.2.1 Subtask - Add hover and focus-visible CSS presentation, bounded sizing, wrapping, logical placement, and capability-gated anchor positioning without event listeners or timers.
      - [ ] 5.1.2.2 Subtask - Remove visual delay and transitions under reduced motion and preserve explicit boundaries, trigger focus, and description contrast in forced colors and themes.
      - [ ] 5.1.2.3 Subtask - Verify CSS-disabled, no-hover, coarse-pointer, no-script, unsupported-anchor, narrow viewport, zoom, long translated text, RTL, and clipped-container behavior.
      - [ ] 5.1.2.4 Subtask - Document that required labels, errors, instructions, status, and task information belong in visible components rather than Tooltip.

  - [ ] 5.2 Section - Link-owned Hover Card preview.

    This section adds bounded preview presentation while leaving an ordinary link
    as the complete destination and coarse-pointer fallback.

    - [ ] 5.2.1 Task - Implement Hover Card structure and link contract.

      Hover Card should enrich destination context without changing navigation,
      focus, authorization, or the information available from the link itself.

      - [ ] 5.2.1.1 Subtask - Add a defining Overlays.HoverCard module with required stable ID, one caller-owned link trigger, trusted supplemental preview, and closed logical placement.
      - [ ] 5.2.1.2 Subtask - Preserve link accessible name, href, target, rel, download, aria-current, focus, activation, context menu, and caller transport attributes.
      - [ ] 5.2.1.3 Subtask - Reject required actions, forms, focusable controls, workflow state, authorization results, unique task information, and nested interactive preview content.
      - [ ] 5.2.1.4 Subtask - Protect link and preview identities and relationships while forwarding unrelated documented classes and globals in deterministic order.

    - [ ] 5.2.2 Task - Add bounded CSS preview and honest fallbacks.

      Hover and focus-within presentation should never intercept the underlying
      link or promise touch-interest behavior the package does not implement.

      - [ ] 5.2.2.1 Subtask - Add hover and focus-within CSS visibility, bounded wrapping, logical placement, optional anchor positioning, and reduced-motion snap behavior.
      - [ ] 5.2.2.2 Subtask - Keep the link fully usable when preview CSS, hover, focus-within, anchor positioning, or script is unavailable and treat coarse-pointer activation as ordinary navigation.
      - [ ] 5.2.2.3 Subtask - Assert absence of interestfor, popover hint activation, timers, hover-intent algorithms, long-press emulation, focus movement, top-layer claims, and JavaScript.
      - [ ] 5.2.2.4 Subtask - Document preview ownership, destination completeness, loading prohibition, privacy, analytics, replacement, content freshness, and future interest-invoker boundary.

  - [ ] 5.3 Section - Phase 5 Integration Tests.

    This section verifies that supplemental surfaces improve presentation without
    becoming required, interactive, pointer-only, or runtime-driven interfaces.

    - [ ] 5.3.1 Task - Verify Tooltip semantics and resilience.

      Tests should prove the description relationship remains valid even when
      the visual bubble cannot or should not appear.

      - [ ] 5.3.1.1 Subtask - Test identity, describedby merging, role tooltip, escaped text, native trigger semantics, placement, caller globals, stable rerenders, and invalid or interactive content.
      - [ ] 5.3.1.2 Subtask - Browser-test keyboard focus, pointer hover, pointer exit, trigger activation, visual nonfocusability, and accessible description retention.
      - [ ] 5.3.1.3 Subtask - Test coarse pointer, CSS-disabled, no-hover, no-script, reduced motion, forced colors, zoom, narrow viewport, RTL, themes, long text, and unsupported anchor positioning.
      - [ ] 5.3.1.4 Subtask - Audit examples and docs for required labels, errors, instructions, status, actions, or information hidden only in Tooltip.

    - [ ] 5.3.2 Task - Verify Hover Card destination and fallback boundaries.

      Automated evidence should keep ordinary link navigation complete across
      every visual and input capability condition.

      - [ ] 5.3.2.1 Subtask - Test link attributes, identity, trusted preview, placement, caller globals, escaping, forbidden interactive descendants, stable rerenders, and invalid values.
      - [ ] 5.3.2.2 Subtask - Browser-test hover, keyboard focus, pointer transition within wrapper, ordinary Enter and click navigation, context menu, and focus order.
      - [ ] 5.3.2.3 Subtask - Assert no interestfor, popover hint, timers, events, long press, focus movement, required preview content, client fetch, analytics, or package JavaScript.
      - [ ] 5.3.2.4 Subtask - Run asset checks, package precommit, cross-engine supplemental suites, ExDoc, provenance and archive audits, `mix spec.check --base main`, and `git diff --check`.
