# Phase 5 - Online Gallery, Documentation, and Milestone Acceptance

Back to wave: [README](./README.md)

- [ ] 5 Phase - Build the separate Phoenix reference consumer, publish its
  deterministic static export, complete package guidance, and accept Milestone A.

  This phase proves ShadcnUI from outside its runtime boundary. The outcome is a
  useful local and online reference with one page per component, verified themes
  and fallbacks, reproducible assets, and release-readiness evidence.

  - [ ] 5.1 Section - Controller-rendered gallery application and assets.

    This section creates the real Phoenix consumer and its deterministic local
    asset workflow without adding an application framework to ShadcnUI.

    - [ ] 5.1.1 Task - Scaffold the separate Phoenix demo application.

      The demo should depend on ShadcnUI through the public path interface and
      use ordinary controller-rendered HEEX only.

      - [ ] 5.1.1.1 Subtask - Generate `demo` as a minimal Phoenix 1.8 application with path dependency `{:shadcn_ui, path: ".."}` and no Ecto.
      - [ ] 5.1.1.2 Subtask - Remove or prohibit LiveView routes, sockets, hooks, processes, state synchronization, Dstar, Datastar, Ash, authentication, and Electron integration.
      - [ ] 5.1.1.3 Subtask - Add boundary tests that inspect demo dependencies, routes, configuration, sources, and the package release allowlist.
      - [ ] 5.1.1.4 Subtask - Keep installed dependencies, build output, logs, generated assets, and exported pages ignored.

    - [ ] 5.1.2 Task - Build deterministic local gallery assets.

      The gallery should load the committed package stylesheet and bounded
      consumer-shell assets without remote runtime resources.

      - [ ] 5.1.2.1 Subtask - Add locked demo asset dependencies and a build that copies or fingerprints `ShadcnUI.stylesheet_path/0` output plus demo-only shell CSS and script.
      - [ ] 5.1.2.2 Subtask - Add a local system-font policy and reject remote imports, fonts, scripts, images, analytics, and runtime URLs.
      - [ ] 5.1.2.3 Subtask - Keep optional theme persistence and source-copy behavior in one explicit demo-only module that implements no component behavior.
      - [ ] 5.1.2.4 Subtask - Add clean locked-build and generated-hash verification.

  - [ ] 5.2 Section - Closed catalogue, routes, and semantic shell.

    This section establishes stable information architecture and safe route
    resolution for the Foundation catalogue.

    - [ ] 5.2.1 Task - Implement the immutable gallery catalogue.

      Authored metadata should drive navigation and completeness checks without
      turning request values into executable runtime discovery.

      - [ ] 5.2.1.1 Subtask - Define the ordered Foundation category and Button, Badge, Alert, Card, Avatar, and Skeleton leaves with unique labels, slugs, paths, and explicit render identities.
      - [ ] 5.2.1.2 Subtask - Resolve route strings only through closed catalogue lookups and never create atoms or select modules, functions, templates, callbacks, or assets dynamically.
      - [ ] 5.2.1.3 Subtask - Add uniqueness, completeness, atom-growth, unknown-path, mismatched-category, and deterministic non-reflecting 404 tests.

    - [ ] 5.2.2 Task - Implement canonical controller routes.

      Every local and exported page should have a stable ordinary URL and
      accurate navigation state without a client router.

      - [ ] 5.2.2.1 Subtask - Add landing, category, component, and deterministic not-found controller actions and templates.
      - [ ] 5.2.2.2 Subtask - Use ordinary links for every destination and expose exactly one accurate current-page marker.
      - [ ] 5.2.2.3 Subtask - Test every route directly in light, dark, default, invalid-theme, and script-disabled conditions.

    - [ ] 5.2.3 Task - Implement the responsive semantic gallery shell.

      The shell should keep navigation before content in the DOM and remain
      understandable across keyboard, narrow viewport, and zoom conditions.

      - [ ] 5.2.3.1 Subtask - Add a skip link, named left navigation, breadcrumb, one main landmark, unique page heading, masthead, and version/provenance context.
      - [ ] 5.2.3.2 Subtask - Add consumer-only responsive CSS that stacks navigation before content without resize observation, DOM relocation, or widget roles.
      - [ ] 5.2.3.3 Subtask - Add explicit light/dark controls using `data-shadcn-theme`, safe light default, and visible focus treatment.
      - [ ] 5.2.3.4 Subtask - Test DOM order, landmarks, current links, focus order, long labels, overflow, and 200 percent zoom.

  - [ ] 5.3 Section - Foundation component reference pages.

    This section provides one practical, inspectable page for every Milestone A
    component using only public APIs and demo-owned fixtures.

    - [ ] 5.3.1 Task - Author complete component examples.

      Each page should demonstrate meaningful supported combinations rather than
      repeating generic internal headings or inert fake application controls.

      - [ ] 5.3.1.1 Subtask - Add Button and Badge pages covering all closed variants, sizes, disabled/loading snapshots, icon-only naming, passive semantics, caller globals, and long content.
      - [ ] 5.3.1.2 Subtask - Add Alert and Card pages covering announcement policies, destructive presentation, optional regions, nested native controls, sparse/dense composition, and ownership boundaries.
      - [ ] 5.3.1.3 Subtask - Add Avatar and Skeleton pages covering initials, image enhancement, stacks, unavailable imagery, shape/size guidance, caller-labelled loading regions, and reduced motion.
      - [ ] 5.3.1.4 Subtask - Render every example in English with local fixtures and no remote media, placeholder destination, package-private helper, or application workflow.

    - [ ] 5.3.2 Task - Publish practical guidance and HEEX source.

      Pages should explain what callers need to know without exposing internal
      verification taxonomy as user-facing documentation.

      - [ ] 5.3.2.1 Subtask - Add “What it is,” “When to use it,” “Examples,” “Application responsibilities,” “Accessibility,” “Themes,” “Fallback,” and “Provenance” content where relevant.
      - [ ] 5.3.2.2 Subtask - Store authored HEEX snippets beside explicit render fixtures and display escaped source without evaluating request-selected code.
      - [ ] 5.3.2.3 Subtask - Add copy controls only through the bounded demo script and keep source readable and selectable when script is disabled.
      - [ ] 5.3.2.4 Subtask - Add catalogue-to-public-import, example, guidance, source, provenance, and route completeness tests.

  - [ ] 5.4 Section - Deterministic static export and online publication.

    This section converts the verified controller-rendered route inventory into
    a portable online artifact and publishes it without expanding package runtime.

    - [ ] 5.4.1 Task - Implement the closed static export.

      Export should prove parity with controller responses and include only local
      fingerprinted assets and canonical routes.

      - [ ] 5.4.1.1 Subtask - Add an export command that starts or invokes the demo in a production-like environment and requests every closed landing, category, component, theme, and not-found fixture required for publication.
      - [ ] 5.4.1.2 Subtask - Rewrite or generate host-relative links deterministically, copy fingerprinted local assets, and emit a route manifest and content hashes.
      - [ ] 5.4.1.3 Subtask - Compare exported landmarks, headings, examples, source, theme markers, asset references, and status expectations with controller responses.
      - [ ] 5.4.1.4 Subtask - Reject unregistered pages, remote runtime URLs, source maps containing repository secrets, mutable timestamps, and files outside ignored export output.

    - [ ] 5.4.2 Task - Configure secure online publication.

      CI should publish only the verified artifact to an approved static host
      while keeping provider credentials and rollback outside package code.

      - [ ] 5.4.2.1 Subtask - Record the approved host, canonical HTTPS URL, repository environment, deployment owner, credential names, retention, and rollback procedure.
      - [ ] 5.4.2.2 Subtask - Add a path-filtered workflow that performs locked package, asset, demo, browser, and export checks before uploading the exact hashed artifact.
      - [ ] 5.4.2.3 Subtask - Use least-privilege deployment permissions, environment secrets, concurrency control, and immutable build provenance without committing credentials.
      - [ ] 5.4.2.4 Subtask - Add post-deployment smoke checks for the canonical landing, every direct component URL, local CSS and script assets, theme default, navigation, and displayed revision.

  - [ ] 5.5 Section - Package documentation and release readiness.

    This section completes the maintainer and consumer documentation and proves
    the initial internal release boundary.

    - [ ] 5.5.1 Task - Complete consumer and maintainer guidance.

      Documentation should explain installation, assets, themes, public APIs,
      ownership, browser fallbacks, provenance, and gallery workflows from a
      clean checkout.

      - [ ] 5.5.1.1 Subtask - Document path installation, `use ShadcnUI`, stylesheet copying/serving, token overrides, light/dark scoping, reduced motion, and no consumer Tailwind or JavaScript requirement.
      - [ ] 5.5.1.2 Subtask - Document all six components with closed attributes, slots, semantics, application ownership, and HEEX examples.
      - [ ] 5.5.1.3 Subtask - Document locked asset builds, provenance updates, demo startup, static export, online deployment, smoke checks, and rollback.
      - [ ] 5.5.1.4 Subtask - Update changelog, ExDoc configuration and groups, package metadata, notices, and the canonical online gallery link.

    - [ ] 5.5.2 Task - Audit Milestone A release contents and boundaries.

      The internal release candidate should contain exactly the documented
      runtime sources and assets and no gallery or tooling leakage.

      - [ ] 5.5.2.1 Subtask - Build docs and the package archive from clean locked Elixir and npm dependencies.
      - [ ] 5.5.2.2 Subtask - Verify the archive contains public modules, compiled CSS, README, changelog, provenance manifest, notices, and required Mix metadata only.
      - [ ] 5.5.2.3 Subtask - Reject demo sources, scripts, workflows, tests, Node modules, dependencies, generated docs, export output, remote assets, and credentials.
      - [ ] 5.5.2.4 Subtask - Record the package as an internal `0.1.0` candidate without publishing to Hex.

  - [ ] 5.6 Section - Phase 5 Integration Tests.

    This section accepts the complete package, catalogue, local gallery, static
    export, online deployment, documentation, and release boundary together.

    - [ ] 5.6.1 Task - Run complete package and gallery acceptance.

      Acceptance should enumerate the public surface and closed catalogue rather
      than relying on a hand-selected subset of pages or variants.

      - [ ] 5.6.1.1 Subtask - Enumerate public component metadata and require exactly one catalogue leaf, route, render fixture, HEEX source, guidance block, provenance entry, and component test for every public function.
      - [ ] 5.6.1.2 Subtask - Request every landing, category, and component route under light, dark, default, and invalid-theme inputs and prove deterministic not-found behavior.
      - [ ] 5.6.1.3 Subtask - Verify all component variants, sizes, semantic states, slots, globals, long content, narrow layout, and ownership guidance through public APIs.
      - [ ] 5.6.1.4 Subtask - Run package, demo, asset, provenance, documentation, release-file, dependency, and no-application-framework audits.

    - [ ] 5.6.2 Task - Run complete browser, export, and deployment acceptance.

      Real-browser and online evidence should prove the gallery remains useful
      across themes, accessibility settings, direct navigation, and script loss.

      - [ ] 5.6.2.1 Subtask - Exercise keyboard navigation, focus visibility, direct URLs, script-disabled content, source readability, light/dark themes, reduced motion, forced colors, narrow viewport, long English content, and 200 percent zoom.
      - [ ] 5.6.2.2 Subtask - Rebuild the static export twice and compare route manifests, asset hashes, HTML parity, remote-URL audits, and package exclusion.
      - [ ] 5.6.2.3 Subtask - Deploy the exact verified artifact and smoke-test the canonical HTTPS URL, all direct component URLs, local assets, displayed revision, and rollback metadata.
      - [ ] 5.6.2.4 Subtask - Run `mix precommit`, locked npm and demo checks, Playwright acceptance, ExDoc, package build, strict `mix spec.check --base main`, and `git diff --check`.
