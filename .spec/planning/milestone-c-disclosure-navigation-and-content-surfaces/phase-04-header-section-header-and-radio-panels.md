# Phase 4 - Header, Section Header, And Radio Panels

Back to wave: [README](./README.md)

- [ ] 4 Phase - Complete reusable page-heading compositions and the honestly
  named native radio-based panel-switching pattern.

  This phase builds larger surfaces from the earlier primitives. Headers preserve
  caller-authored landmarks and controls; Radio Panels deliberately retain radio-
  group semantics and do not claim the interaction contract of true tabs.

  - [ ] 4.1 Section - Header and Section Header compositions.

    This section provides responsive page and section structure while leaving
    heading hierarchy, navigation, forms, and commands with their native owners.

    - [ ] 4.1.1 Task - Implement the Header composition.

      Header should arrange common page regions without flattening the semantics
      of the caller content placed inside them.

      - [ ] 4.1.1.1 Subtask - Add a defining Navigation.Header module with optional brand, primary navigation, utilities, and actions slots.
      - [ ] 4.1.1.2 Subtask - Render a native header and preserve supplied links, buttons, forms, navigation landmarks, headings, and accessible names unchanged.
      - [ ] 4.1.1.3 Subtask - Add closed container width, density, wrapping, border, and static or sticky presentation values mapped to prefixed classes.
      - [ ] 4.1.1.4 Subtask - Protect structural markup while forwarding unrelated documented classes and globals to their declared regions.

    - [ ] 4.1.2 Task - Implement Section Header and sticky fallback.

      Section Header should preserve document order and caller heading levels in
      both enhanced sticky presentation and normal-flow fallback.

      - [ ] 4.1.2.1 Subtask - Add a defining Navigation.SectionHeader module with required heading content and optional description and actions slots.
      - [ ] 4.1.2.2 Subtask - Keep the caller-authored heading element and level intact and place related actions after descriptive content in document order.
      - [ ] 4.1.2.3 Subtask - Add closed static and sticky presentation, optional decorative anchor effects, and scroll margin or padding needed to preserve package-created fragment visibility.
      - [ ] 4.1.2.4 Subtask - Document multiple-header semantics, heading ownership, action behavior, sticky and anchor fallback, application responsibilities, and provenance.

  - [ ] 4.2 Section - Native Radio Panels semantics and fallback.

    This section adapts the upstream radio-based pattern under a name and API
    that match its actual native keyboard and form behavior.

    - [ ] 4.2.1 Task - Implement the Radio Panels structure and value snapshot.

      One native radio group should control presentation without creating tab
      roles, focus behavior, or a package-owned client state model.

      - [ ] 4.2.1.1 Subtask - Add a defining Content.RadioPanels module with required ID, name, legend, stable keyed options, explicit selected value, and trusted panel content.
      - [ ] 4.2.1.2 Subtask - Render one native fieldset and legend plus deterministic radio, label, and panel relationships for every option.
      - [ ] 4.2.1.3 Subtask - Preserve native radio Tab and arrow-key behavior, checked and disabled attributes, and ordinary browser form submission.
      - [ ] 4.2.1.4 Subtask - Protect group name, IDs, labels, checked value, disabled state, and relationships while forwarding unrelated documented globals.

    - [ ] 4.2.2 Task - Add selected-panel CSS and semantic guidance.

      Enhanced presentation may reduce visual density only when every panel stays
      reachable through the documented CSS-disabled fallback.

      - [ ] 4.2.2.1 Subtask - Add capability-gated CSS that emphasizes the selected label and panel using semantic tokens and visible native focus.
      - [ ] 4.2.2.2 Subtask - Ensure unsupported selectors or disabled CSS show every panel in readable source order with radios and labels intact.
      - [ ] 4.2.2.3 Subtask - Verify long labels, long panels, nested forms, narrow layout, zoom, forced colors, reduced motion, light/dark themes, and no script.
      - [ ] 4.2.2.4 Subtask - Document Radio Panels values, submission, caller-owned rerender and persistence, fallback, and concrete distinctions from navigation links and true tabs.

  - [ ] 4.3 Section - Phase 4 Integration Tests.

    This section verifies page-header and selection compositions with honest
    semantics, progressive styling, and no client-runtime expansion.

    - [ ] 4.3.1 Task - Verify Header and Section Header composition.

      Tests should confirm that layout wrappers do not change the semantics or
      ownership of headings, links, forms, navigation, and actions.

      - [ ] 4.3.1.1 Subtask - Test every Header slot, layout value, sticky snapshot, caller global, and invalid closed value.
      - [ ] 4.3.1.2 Subtask - Test Section Header heading preservation, description and action order, fragment visibility classes, static fallback, and nested use.
      - [ ] 4.3.1.3 Subtask - Compose both headers with Navigation Menu, Button, Badge, Separator, form controls, and Scroll Area and assert original child semantics.
      - [ ] 4.3.1.4 Subtask - Audit source for heading inference, command handling, responsive state, scroll observation, routing, authorization, and package JavaScript.

    - [ ] 4.3.2 Task - Verify Radio Panels semantics and fallback.

      Automated evidence should prove native radio behavior and explicitly reject
      the larger ARIA tabs contract.

      - [ ] 4.3.2.1 Subtask - Test deterministic fieldset, legend, radios, labels, panel IDs, selected value, disabled states, submission name, globals, escaping, and invalid input.
      - [ ] 4.3.2.2 Subtask - Assert absence of tablist, tab, tabpanel, roving tabindex, key handlers, focus movement, history, and package-owned selection state.
      - [ ] 4.3.2.3 Subtask - Browser-test native radio Tab and arrow keys, submitted value, server rerender snapshot, selected CSS, and all-panels-visible fallback.
      - [ ] 4.3.2.4 Subtask - Run asset checks, package precommit, ExDoc, provenance and archive audits, `mix spec.check --base main`, and `git diff --check`.
