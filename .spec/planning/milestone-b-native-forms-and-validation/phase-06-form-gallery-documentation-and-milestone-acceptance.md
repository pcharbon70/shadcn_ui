# Phase 6 - Form Gallery, Documentation, And Milestone Acceptance

Back to wave: [README](./README.md)

- [ ] 6 Phase - Publish the complete Forms catalogue, realistic caller-owned
  compositions, native-submission evidence, documentation, and Milestone B acceptance.

  This phase turns the implemented controls into an understandable online
  reference and verifies the milestone as one coherent package. Examples remain
  controller-rendered, static-exportable, and explicit about application ownership.

  - [x] 6.1 Section - Forms catalogue and component pages.

    This section extends the closed gallery information architecture with one
    stable route per form component and complete semantic-state examples.

    - [x] 6.1.1 Task - Add the Forms category and closed route inventory.

      Gallery routing should remain deterministic and safe as the catalogue grows
      from Foundation into the complete Milestone B form set.

      - [x] 6.1.1.1 Subtask - Add stable leaves for Field, Label, Help, Field Errors, Error Summary, Input, Textarea, Checkbox, Radio Group, Switch, Native Select, Enhanced Select, Slider, Progress, and Meter.
      - [x] 6.1.1.2 Subtask - Resolve every slug through closed strings to explicit render identities and return non-reflecting 404s for unknown or mismatched routes.
      - [x] 6.1.1.3 Subtask - Extend navigation, breadcrumbs, landing, category pages, current-page state, static route inventory, and sitemap in deterministic order.
      - [x] 6.1.1.4 Subtask - Keep all new demo source, tests, scripts, dependencies, and export output outside package release contents.

    - [x] 6.1.2 Task - Build focused form component pages.

      Each page should answer what the control means, when to use it, what the
      package renders, and what the consuming application must still do.

      - [x] 6.1.2.1 Subtask - Show explicit-ID and FormField examples side by side for every applicable component.
      - [x] 6.1.2.2 Subtask - Show applicable pristine, used, valid, invalid, disabled, readonly, required, pending, checked, selected, multiple, determinate, indeterminate, and server-error snapshots.
      - [x] 6.1.2.3 Subtask - Include purpose, usage, native semantics, HEEX source, relationships, ownership, fallback, theme, and provenance guidance in plain language.
      - [x] 6.1.2.4 Subtask - Explain Checkbox versus Switch, Native versus Enhanced Select, and Progress versus Meter with concrete application examples.

  - [x] 6.2 Section - Complete forms and native submission evidence.

    This section demonstrates how package components compose into useful forms
    while making clear that demo data and responses are caller-owned fixtures.

    - [x] 6.2.1 Task - Build sign-in, profile, and settings compositions.

      Complete examples should exercise cross-component relationships and normal
      browser form behavior without adding persistence or domain operations.

      - [x] 6.2.1.1 Subtask - Build sign-in with email, password, remember-me Checkbox, errors, pending snapshot, and submit Button.
      - [x] 6.2.1.2 Subtask - Build profile with text fields, Textarea, Native Select, Radio Group, Slider, repeated errors, and Error Summary.
      - [x] 6.2.1.3 Subtask - Build settings with Switch, multiple Checkbox values, Enhanced Select, Progress, Meter, disabled and readonly states, and submit Button.
      - [x] 6.2.1.4 Subtask - Use deterministic caller-owned sample FormFields and explicit data with no authentication, persistence, authorization, or changeset mutation.

    - [x] 6.2.2 Task - Add a harmless native-submission fixture.

      The demo endpoint should provide inspectable evidence of received browser
      values without being mistaken for an application workflow.

      - [x] 6.2.2.1 Subtask - Add an ordinary controller endpoint that accepts only documented demo fields and performs no domain operation.
      - [x] 6.2.2.2 Subtask - Render escaped deterministic received values, including unchecked sentinels, repeated checkbox values, radio, single/multiple select, slider, input, and textarea data.
      - [x] 6.2.2.3 Subtask - Preserve Phoenix CSRF for source pages while keeping static-export pages explicitly non-submitting or directed to documented local demonstration behavior.
      - [x] 6.2.2.4 Subtask - Add controller tests rejecting unexpected reflection, executable data, persistence, authentication, authorization, and stateful side effects.

  - [ ] 6.3 Section - Public documentation, fallback evidence, and provenance.

    This section aligns package docs and upstream evidence with the full released
    form catalogue and gives consumers an honest browser support story.

    - [ ] 6.3.1 Task - Publish form API and ownership documentation.

      README and ExDoc should make the shared rules easy to apply without reading
      implementation code or assuming familiar-looking controls own behavior.

      - [ ] 6.3.1.1 Subtask - Document FormField and explicit precedence, identity requirements, error visibility, translation, pending state, protected globals, and native submission.
      - [ ] 6.3.1.2 Subtask - Document every component API, option structure, state, constraint, semantic token, HEEX example, and excluded behavior.
      - [ ] 6.3.1.3 Subtask - Document capability-based Textarea and Enhanced Select activation with exact fixed-textarea and classic-select fallback examples.
      - [ ] 6.3.1.4 Subtask - Document server validation and authorization as mandatory regardless of browser constraints or visual invalid state.

    - [ ] 6.3.2 Task - Complete provenance and release evidence.

      Every substantially adapted form component and CSS block should remain
      traceable to the reviewed upstream revision and absent from automatic sync.

      - [ ] 6.3.2.1 Subtask - Extend the provenance manifest with all Milestone B component and CSS source mappings and local-change summaries.
      - [ ] 6.3.2.2 Subtask - Verify the pinned upstream revision, complete MIT notice, independent-project wording, and exclusion of upstream site assets.
      - [ ] 6.3.2.3 Subtask - Rebuild the package archive and static gallery export and verify form source, tests, demo files, credentials, and mutable output remain excluded.
      - [ ] 6.3.2.4 Subtask - Update changelog, package catalogue, online URL, static smoke inventory, and documented rollback steps for Milestone B.

  - [ ] 6.4 Section - Phase 6 Integration Tests.

    This section verifies the complete native-form catalogue, gallery, fallback,
    accessibility, release, and documentation contract as Milestone B acceptance.

    - [ ] 6.4.1 Task - Run gallery and browser acceptance.

      Automated checks should cover real navigation, control operation, native
      values, and accessibility relationships across the full state matrix.

      - [ ] 6.4.1.1 Subtask - Test every Forms category route, page, breadcrumb, current-page state, direct static route, sitemap entry, source block, and unknown-route 404.
      - [ ] 6.4.1.2 Subtask - Browser-test Tab order, labels, checkbox and radio keys, select fallback, slider keys, native constraints, reset, submission, and received values.
      - [ ] 6.4.1.3 Subtask - Test long and translated content, repeated errors and groups, narrow layout, 200 percent zoom, forced colors, reduced motion, light/dark themes, and no-script core usage.
      - [ ] 6.4.1.4 Subtask - Run automated accessibility checks plus explicit native element, accessible-name, relationship, keyboard, and role assertions.

    - [ ] 6.4.2 Task - Run package and milestone acceptance.

      Final verification should prove the independently distributable package and
      online gallery satisfy every active Milestone B requirement together.

      - [ ] 6.4.2.1 Subtask - Run component, shared contract, native submission, CSS fallback, demo controller, static export, and Milestone B acceptance suites.
      - [ ] 6.4.2.2 Subtask - Run locked asset and gallery builds, deterministic byte checks, CSS isolation/capability audits, provenance audits, archive checks, and direct-route smoke tests.
      - [ ] 6.4.2.3 Subtask - Build ExDoc, verify every public function and current specification is represented, and audit deferred widgets and application behavior remain absent.
      - [ ] 6.4.2.4 Subtask - Run package and demo precommit commands, `mix spec.check --base main`, `git diff --check`, and record the Milestone B acceptance result.
