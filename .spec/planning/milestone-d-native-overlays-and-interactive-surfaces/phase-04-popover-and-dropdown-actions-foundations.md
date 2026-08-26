# Phase 4 - Popover And Dropdown Actions Foundations

Back to wave: [README](./README.md)

- [ ] 4 Phase - Publish native nonmodal Popover and a Dropdown Actions
  composition whose controls remain ordinary links and buttons.

  This phase uses browser top-layer, invoker, focus-order, light-dismiss, and
  anchor-positioning behavior while explicitly declining the richer ARIA menu
  keyboard and state contract.

  - [x] 4.1 Section - Native Popover invocation and bounded positioning.

    This section implements stable invoker relationships, auto and manual modes,
    native actions, logical placement, position tries, and fallback geometry.

    - [x] 4.1.1 Task - Implement Popover structure and native modes.

      Popover should provide a complete nonmodal relationship without observing
      browser toggle events or creating server-synchronized open state.

      - [x] 4.1.1.1 Subtask - Add a defining Overlays.Popover module with required ID, trigger, accessible name or relationship, trusted body, and optional explicit close content.
      - [x] 4.1.1.2 Subtask - Render one native button invoker, popovertarget relationship, closed auto or manual mode, and closed show, hide, or toggle action.
      - [x] 4.1.1.3 Subtask - Preserve browser-owned light dismiss, Escape, implicit aria-details and aria-expanded relationships, sequential focus order, focus return, and native nested-popover behavior.
      - [x] 4.1.1.4 Subtask - Protect mode, target, action, IDs, names, and required relationships while forwarding unrelated documented classes and globals.

    - [x] 4.1.2 Task - Implement anchor placement and viewport fallbacks.

      Placement should improve proximity without becoming a JavaScript collision
      engine or making anchored CSS a functional dependency.

      - [x] 4.1.2.1 Subtask - Add closed logical block-start, block-end, inline-start, and inline-end values through implicit or explicit anchor relationships and complete prefixed classes.
      - [x] 4.1.2.2 Subtask - Add capability-gated position-area and ordered position-try-fallbacks, bounded viewport sizing, native overflow, and no-transition reduced-motion rules.
      - [x] 4.1.2.3 Subtask - Preserve an operable readable top-layer default when anchor positioning, position tries, or discrete transitions are unavailable or CSS is disabled.
      - [x] 4.1.2.4 Subtask - Verify viewport edges, nested scroll containers, zoom, long translated content, RTL, forced colors, themes, coarse pointer, replacement, and ordinary fallback destination.

  - [ ] 4.2 Section - Dropdown Actions ordinary-control composition.

    This section groups common caller actions in an auto Popover without
    claiming menu semantics, keyboard behavior, authorization, or execution.

    - [ ] 4.2.1 Task - Implement Dropdown Actions structure.

      Every action should remain recognizable to browsers and assistive
      technology as its original native link or button.

      - [ ] 4.2.1.1 Subtask - Add a defining Overlays.DropdownActions module with required ID and trigger plus stable keyed caller action, optional group-label, and separator slots.
      - [ ] 4.2.1.2 Subtask - Compose one auto Popover with touch-sized native controls in document order, deterministic group identity, and semantic or decorative separators.
      - [ ] 4.2.1.3 Subtask - Preserve each link destination, target, download, rel and aria-current state and each button type, disabled state, name, value, form, and transport attributes.
      - [ ] 4.2.1.4 Subtask - Protect Popover and action relationships while rejecting nested interactive labels, contradictory globals, duplicate keys, invalid destinations, and generated application commands.

    - [ ] 4.2.2 Task - Enforce the non-menu and application boundary.

      Documentation and tests should prevent familiar styling from silently
      creating obligations the component does not implement.

      - [ ] 4.2.2.1 Subtask - Assert absence of menu, menubar and menuitem roles, roving tabindex, arrow-key handlers, Home, End, typeahead, submenus, command registry, and package-owned dismissal after outcomes.
      - [ ] 4.2.2.2 Subtask - Document native Tab and Shift+Tab order, ordinary link and button activation, Escape and light dismiss, focus return, and caller-owned command results.
      - [ ] 4.2.2.3 Subtask - Compare Dropdown Actions with Navigation Menu, Button groups, native select, future ARIA menus, command palettes, and application toolbars.
      - [ ] 4.2.2.4 Subtask - Add mixed links and buttons, disabled controls, long labels, translated groups, destructive styling, native forms, unsupported-Popover fallback links, and replacement fixtures.

  - [ ] 4.3 Section - Phase 4 Integration Tests.

    This section verifies native nonmodal behavior, bounded placement, ordinary
    action semantics, and explicit rejection of a full menu contract.

    - [ ] 4.3.1 Task - Verify Popover invocation and positioning.

      Automated evidence should distinguish native behavior from optional CSS
      and demonstrate usable fallbacks at every viewport edge.

      - [ ] 4.3.1.1 Subtask - Test every Popover slot, mode, action, placement, identity, accessible relationship, explicit close, caller global, escaping, stable rerender, and invalid value.
      - [ ] 4.3.1.2 Subtask - Browser-test toggle, show, hide, auto light dismiss, manual persistence, Escape, Tab order, focus return, nested Popover, and replacement behavior.
      - [ ] 4.3.1.3 Subtask - Test anchor positions and tries at every viewport edge, nested scroll, narrow and wide layouts, zoom, forced colors, reduced motion, RTL, CSS-disabled, no-script, and unsupported-feature fixtures.
      - [ ] 4.3.1.4 Subtask - Audit source for toggle listeners, coordinate calculations, observers, timers, focus movement, open-state synchronization, browser sniffing, and JavaScript.

    - [ ] 4.3.2 Task - Verify Dropdown Actions semantics and ownership.

      Tests should prove that a visual dropdown remains a collection of ordinary
      application-owned controls rather than a partial menu widget.

      - [ ] 4.3.2.1 Subtask - Test stable actions, groups, separators, links, buttons, disabled state, forms, targets, values, caller globals, escaping, and invalid nesting or keys.
      - [ ] 4.3.2.2 Subtask - Browser-test Tab and Shift+Tab, Enter and Space, link destination, native submission, light dismiss, Escape, focus restoration, touch target size, and fallback destinations.
      - [ ] 4.3.2.3 Subtask - Assert forbidden menu roles, roving focus, arrow keys, typeahead, submenus, authorization, command execution, automatic outcome dismissal, and package runtime remain absent.
      - [ ] 4.3.2.4 Subtask - Run asset checks, package precommit, cross-engine Popover suites, ExDoc, provenance and archive audits, `mix spec.check --base main`, and `git diff --check`.
