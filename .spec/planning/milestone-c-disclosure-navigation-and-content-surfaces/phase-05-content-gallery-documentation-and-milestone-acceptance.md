# Phase 5 - Content Gallery, Documentation, And Milestone Acceptance

Back to wave: [README](./README.md)

- [ ] 5 Phase - Publish the complete Milestone C catalogue, substantial page
  compositions, fallback guidance, and milestone-wide acceptance evidence.

  This phase turns the new components into an understandable public reference,
  proves that Milestones A through C compose without application behavior, and
  verifies the package, gallery, browser, provenance, and release boundaries as
  one coherent milestone.

  - [x] 5.1 Section - Closed categories and component reference pages.

    This section extends the immutable gallery information architecture with
    stable routes and plain-language reference pages for every Milestone C leaf.

    - [x] 5.1.1 Task - Add Disclosure, Navigation, and Content Surfaces catalogues.

      Routing and navigation should remain deterministic as the gallery expands
      beyond Foundation and Forms.

      - [x] 5.1.1.1 Subtask - Add stable leaves for Accordion, Navigation Menu, Header, Section Header, Scroll Area, Separator, and Radio Panels in deterministic category order.
      - [x] 5.1.1.2 Subtask - Resolve every category and component through closed strings to explicit render identities and return non-reflecting 404s for unknown or mismatched routes.
      - [x] 5.1.1.3 Subtask - Extend landing, side navigation, breadcrumbs, current-page state, direct routes, static inventory, route manifest, and sitemap.
      - [x] 5.1.1.4 Subtask - Keep all Milestone C demo source, tests, scripts, dependencies, and generated output outside package release contents.

    - [x] 5.1.2 Task - Build focused semantic and fallback pages.

      Every page should state what the component means, how it behaves natively,
      what CSS may enhance, and what the consuming application still owns.

      - [x] 5.1.2.1 Subtask - Show applicable independent, exclusive, open, closed, current, static, sticky, overflow, focusable, semantic, decorative, selected, disabled, enhanced, and fallback states.
      - [x] 5.1.2.2 Subtask - Include purpose, usage, native markup, relationships, keyboard behavior, HEEX source, ownership, theme, fallback, and provenance guidance in plain English.
      - [x] 5.1.2.3 Subtask - Explain links versus commands, navigation links versus Radio Panels, Radio Panels versus true tabs, and task selection versus destination changes using concrete examples.
      - [x] 5.1.2.4 Subtask - Show exact CSS-disabled or unsupported-feature fallbacks for exclusive details, sticky headers, edge affordances, anchor decoration, and selected panels.

  - [ ] 5.2 Section - Substantial caller-owned page compositions.

    This section demonstrates useful cross-milestone pages while keeping routes,
    data, authorization, commands, and state in the demo application boundary.

    - [ ] 5.2.1 Task - Build documentation, settings, and application-shell pages.

      Complete examples should exercise landmarks, headings, disclosure,
      navigation, overflow, panels, forms, and foundation feedback together.

      - [ ] 5.2.1.1 Subtask - Build a documentation page with Header, Navigation Menu, sticky Section Headers, Accordion, Scroll Area, Separator, links, and fragment destinations.
      - [ ] 5.2.1.2 Subtask - Build a settings page with Header, Radio Panels, native form controls, Error Summary, Button, Alert, Card, and caller-owned selected and validation snapshots.
      - [ ] 5.2.1.3 Subtask - Build an application shell with named primary and secondary navigation, current destinations, badges, actions, content overflow, and responsive normal-flow fallback.
      - [ ] 5.2.1.4 Subtask - Use deterministic caller fixtures and ordinary controller rendering with no persistence, authentication, authorization, domain operations, routing inference, or package-owned state.

    - [ ] 5.2.2 Task - Add content-stress and fallback fixtures.

      The gallery should make accessibility and compatibility boundaries visible
      instead of treating them as unobservable implementation details.

      - [ ] 5.2.2.1 Subtask - Add narrow and wide, horizontal and vertical overflow, nested content, long and translated labels, repeated structures, and fragment-target fixtures.
      - [ ] 5.2.2.2 Subtask - Add light, dark, 200 percent zoom, forced-colors, reduced-motion, RTL, no-script, and CSS-disabled evidence.
      - [ ] 5.2.2.3 Subtask - Expose supported and fallback states deterministically without browser-name sniffing, viewport-derived application state, or demo shims labeled as package behavior.
      - [ ] 5.2.2.4 Subtask - Verify static export preserves all content, destinations, landmarks, source examples, and non-submitting caller-owned form fixtures.

  - [ ] 5.3 Section - Public documentation, provenance, and release evidence.

    This section aligns README, ExDoc, upstream traceability, and release
    guidance with the complete Milestone C public surface.

    - [ ] 5.3.1 Task - Publish component APIs and ownership boundaries.

      Consumers should be able to select and compose components without reading
      implementation code or assuming familiar visual patterns own behavior.

      - [ ] 5.3.1.1 Subtask - Document every new API, slot, closed value, identity rule, protected global, native behavior, semantic token, and HEEX example.
      - [ ] 5.3.1.2 Subtask - Document disclosure, destination, current-location, landmark, heading, scroll, sticky, radio selection, form submission, and fallback ownership.
      - [ ] 5.3.1.3 Subtask - Publish an explicit comparison table for Navigation Menu, Button actions, Radio Panels, true tabs, menus, and deferred composite widgets.
      - [ ] 5.3.1.4 Subtask - Document exact no-CSS, unsupported-feature, no-script, reduced-motion, forced-colors, and normal-flow behavior.

    - [ ] 5.3.2 Task - Complete provenance and candidate-release evidence.

      Every adapted component and CSS block should remain traceable and excluded
      demo material should stay outside the independently distributable package.

      - [ ] 5.3.2.1 Subtask - Extend the provenance manifest with every Milestone C component and CSS mapping, pinned source path, revision, and local-change summary.
      - [ ] 5.3.2.2 Subtask - Verify the MIT notice, independent-project wording, absence of automatic upstream synchronization, and exclusion of upstream site assets.
      - [ ] 5.3.2.3 Subtask - Rebuild ExDoc, package assets, the release archive, gallery assets, and static export and audit their exact allowlists.
      - [ ] 5.3.2.4 Subtask - Update changelog, package catalogue, canonical gallery URL, deployment smoke inventory, rollback guidance, and Milestone C acceptance record.

  - [ ] 5.4 Section - Phase 5 Integration Tests.

    This section verifies the complete Milestone C catalogue, compositions,
    semantics, fallbacks, documentation, and release boundary as milestone exit.

    - [ ] 5.4.1 Task - Run gallery and browser acceptance.

      Automated checks should cover real routes and native interactions across
      the complete content, navigation, accessibility, and fallback matrix.

      - [ ] 5.4.1.1 Subtask - Test every new category, component route, breadcrumb, current-page state, direct export route, sitemap entry, source block, composition route, and unknown-route 404.
      - [ ] 5.4.1.2 Subtask - Browser-test summary activation, exclusive and independent disclosure, find-in-page, Tab order, ordinary links, fragments, scrolling, focus policy, sticky fallback, and native radio keys and values.
      - [ ] 5.4.1.3 Subtask - Test narrow, wide, overflow, nested, long, translated, RTL, zoom, forced-colors, reduced-motion, light/dark, no-script, and CSS-disabled fixtures.
      - [ ] 5.4.1.4 Subtask - Run automated accessibility checks plus explicit landmark, heading, list, link, name, relationship, current-state, keyboard, native-element, and forbidden-role assertions.

    - [ ] 5.4.2 Task - Run package and Milestone C acceptance.

      Final verification should prove the independently distributable package
      and online gallery satisfy every active Milestone C requirement together.

      - [ ] 5.4.2.1 Subtask - Run component, shared-contract, stylesheet-fallback, composition, static-export, browser, and Milestone C acceptance suites.
      - [ ] 5.4.2.2 Subtask - Run locked asset and gallery builds, deterministic byte checks, CSS isolation and capability audits, provenance audits, archive checks, and direct-route smoke tests.
      - [ ] 5.4.2.3 Subtask - Build ExDoc, verify every public function and current specification is represented, and audit true tabs, menus, overlays, application behavior, and package JavaScript remain absent.
      - [ ] 5.4.2.4 Subtask - Run package and demo precommit commands, `mix spec.check --base main`, `git diff --check`, and record the Milestone C acceptance result.
