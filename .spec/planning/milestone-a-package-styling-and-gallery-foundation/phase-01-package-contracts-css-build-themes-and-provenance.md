# Phase 1 - Package Contracts, CSS Build, Themes, and Provenance

Back to wave: [README](./README.md)

- [ ] 1 Phase - Establish the runtime boundary, public component infrastructure,
  isolated asset pipeline, token contract, and provenance evidence required by
  every Milestone A component.

  This phase implements the cross-cutting contracts before component markup is
  added. Its outcome is a reproducible package artifact and tested public
  foundation that later phases can extend without changing consumer tooling.

  - [x] 1.1 Section - Independent package and public import boundary.

    This section turns the initialized Mix project into a deliberate runtime and
    release surface while keeping HEEX infrastructure separate from the LiveView
    application model.

    - [x] 1.1.1 Task - Implement the ShadcnUI package entry point.

      The entry module should expose stable package helpers and import defining
      component modules without hiding Phoenix compile-time metadata.

      - [x] 1.1.1.1 Subtask - Add `stylesheet_path/0` using `Application.app_dir/2` with documentation that consumers own copying, bundling, and serving.
      - [x] 1.1.1.2 Subtask - Add the `__using__/1` import surface and an initial category module structure that can accept all six foundation components.
      - [x] 1.1.1.3 Subtask - Document that `phoenix_live_view` supplies HEEX infrastructure only and add no route, socket, process, hook, or navigation.
      - [x] 1.1.1.4 Subtask - Replace scaffold-only tests with package-boundary and compile-time metadata fixtures.

    - [x] 1.1.2 Task - Lock the runtime and release manifests.

      The dependency graph and package file allowlist should make excluded
      application, build, demo, and mutable artifacts mechanically inspectable.

      - [x] 1.1.2.1 Subtask - Keep runtime dependencies limited to Phoenix HTML and component infrastructure and development dependencies explicitly non-runtime.
      - [x] 1.1.2.2 Subtask - Add the exact runtime, stylesheet, notice, README, changelog, and Mix metadata release allowlist.
      - [x] 1.1.2.3 Subtask - Add audits rejecting Dstar, Datastar, Ash, Electron, controllers, endpoints, processes, and application frameworks from runtime sources and dependencies.
      - [x] 1.1.2.4 Subtask - Add clean archive-content verification that excludes demo, tests, Node modules, generated docs, build output, and static export output.

  - [x] 1.2 Section - Shared HEEX API conventions.

    This section implements the internal fixed mappings and caller composition
    rules that keep every public function predictable and safe.

    - [x] 1.2.1 Task - Implement closed class and state mappings.

      Internal helpers should return complete statically discoverable prefixed
      classes without turning arbitrary caller values into CSS or atoms.

      - [x] 1.2.1.1 Subtask - Add fixed mappings for shared variants, sizes, radii, focus treatment, disabled presentation, and motion classes used by Milestone A.
      - [x] 1.2.1.2 Subtask - Return fixed class lists or `nil` only and reject arbitrary modifier interpolation.
      - [x] 1.2.1.3 Subtask - Test unknown values, atom-count stability, deterministic class order, and static Tailwind source discovery.

    - [x] 1.2.2 Task - Standardize globals, slots, and protected semantics.

      Public functions should compose caller attributes and trusted HEEX while
      retaining the native and accessibility semantics promised by the package.

      - [x] 1.2.2.1 Subtask - Define consistent caller `class` merging and documented native, `aria-*`, `data-*`, `phx-*`, and `data-on-*` pass-through.
      - [x] 1.2.2.2 Subtask - Protect mandatory types, disabled state, roles, accessible names, hidden treatment, and deterministic relationships from conflicting globals.
      - [x] 1.2.2.3 Subtask - Use `inner_block` for primary content and named slots only for semantically distinct regions.
      - [x] 1.2.2.4 Subtask - Add escaping and raw-HTML rejection tests using real HEEX caller fixtures.

  - [x] 1.3 Section - Isolated Tailwind build and compiled stylesheet.

    This section creates the package-local authoring toolchain and the ordinary
    CSS artifact consumed by Phoenix applications.

    - [x] 1.3.1 Task - Configure the pinned CSS build.

      The build should scan explicit package sources, generate only `sui`-
      prefixed utilities, and never rely on a consumer Tailwind configuration.

      - [x] 1.3.1.1 Subtask - Add a package npm manifest and lockfile with exact Tailwind CSS v4 and CLI/build dependencies.
      - [x] 1.3.1.2 Subtask - Add authored asset entrypoints with explicit source registration and the fixed Tailwind prefix.
      - [x] 1.3.1.3 Subtask - Exclude unrestricted Preflight and author only the bounded element and pseudo-element foundation required by documented components.
      - [x] 1.3.1.4 Subtask - Add deterministic `assets:build` and `assets:check` commands that write and compare `priv/static/shadcn_ui.css`.

    - [x] 1.3.2 Task - Audit CSS isolation and runtime safety.

      The canonical artifact should coexist with BulmaUI and contain no hidden
      network, script, or consumer build dependency.

      - [x] 1.3.2.1 Subtask - Assert every generated utility and Tailwind-owned variable is prefixed and reject known unprefixed utility selectors.
      - [x] 1.3.2.2 Subtask - Reject unrestricted resets, remote imports, remote fonts, script syntax, and runtime URLs.
      - [x] 1.3.2.3 Subtask - Add a mixed BulmaUI/ShadcnUI fixture proving common native elements and Bulma classes are not globally restyled.
      - [x] 1.3.2.4 Subtask - Prove a consumer fixture renders correctly using only the compiled artifact and no Node installation in its build path.

  - [x] 1.4 Section - Semantic tokens, themes, and motion baseline.

    This section supplies the namespaced shadcn-style design vocabulary shared
    by all Milestone A component classes.

    - [x] 1.4.1 Task - Implement light and dark semantic tokens.

      The token layer should cover required semantic roles without leaking
      generic variable names or global color-mode selectors.

      - [x] 1.4.1.1 Subtask - Define complete light `--shadcn-ui-*` surface, foreground, card, popover, primary, secondary, muted, accent, destructive, border, input, ring, radius, and timing tokens.
      - [x] 1.4.1.2 Subtask - Define paired dark values only beneath `[data-shadcn-theme="dark"]` and explicit light values beneath `[data-shadcn-theme="light"]`.
      - [x] 1.4.1.3 Subtask - Map prefixed Tailwind theme variables to public semantic tokens and avoid hard-coded theme colors in component utilities.
      - [x] 1.4.1.4 Subtask - Test missing and invalid theme values, nested consumer overrides, foreground pairing, and mixed design-system pages.

    - [x] 1.4.2 Task - Implement the progressive and reduced-motion floor.

      Shared CSS should retain content, state, and focus when enhancement or
      motion is unavailable.

      - [x] 1.4.2.1 Subtask - Add consistent visible focus treatment that does not depend on color theme alone.
      - [x] 1.4.2.2 Subtask - Add `prefers-reduced-motion` treatment for all current and reserved Milestone A transitions and animations.
      - [x] 1.4.2.3 Subtask - Document the semantic baseline, enhancement, and fallback vocabulary used by component pages and future specs.

  - [ ] 1.5 Section - Upstream provenance and legal boundary.

    This section makes every substantially adapted source fragment auditable
    without turning unscripted/ui into a package dependency.

    - [ ] 1.5.1 Task - Publish the provenance records.

      The package should identify the exact reviewed source and preserve the
      required license notice in both human- and machine-inspectable forms.

      - [ ] 1.5.1.1 Subtask - Add `THIRD_PARTY_NOTICES.md` with the complete unscripted/ui MIT notice and independent-project wording.
      - [ ] 1.5.1.2 Subtask - Add the provenance manifest with repository URL, pinned commit, component source paths, CSS source paths, and local-change summaries.
      - [ ] 1.5.1.3 Subtask - Add schema and completeness tests tying every Milestone A component to a reviewed provenance entry.

    - [ ] 1.5.2 Task - Enforce source and asset exclusions.

      Release evidence should reject upstream site infrastructure and automatic
      synchronization mechanisms that are outside the adaptation contract.

      - [ ] 1.5.2.1 Subtask - Reject an unscripted/ui Git dependency, submodule, vendored repository, registry, or generated source-copy directory.
      - [ ] 1.5.2.2 Subtask - Reject remote demo images, fonts, analytics, documentation scripts, and other site-only files from release contents.
      - [ ] 1.5.2.3 Subtask - Document the explicit review workflow for adopting a later upstream revision.

  - [ ] 1.6 Section - Phase 1 Integration Tests.

    This section proves the independent package, public HEEX boundary, compiled
    CSS, theme system, and provenance contract before components depend on them.

    - [ ] 1.6.1 Task - Run package and component-foundation integration tests.

      Tests should compile a real consumer fixture and audit dependency and
      release surfaces rather than relying on source descriptions alone.

      - [ ] 1.6.1.1 Subtask - Compile a fixture using `use ShadcnUI` and assert public metadata, escaped content, globals, and deterministic classes.
      - [ ] 1.6.1.2 Subtask - Audit runtime dependencies, source modules, release files, and absent application frameworks.
      - [ ] 1.6.1.3 Subtask - Build an archive and verify only approved files and notices are included.

    - [ ] 1.6.2 Task - Run CSS, theme, and provenance integration tests.

      The tests should rebuild the artifact and prove isolation and attribution
      from a clean locked dependency state.

      - [ ] 1.6.2.1 Subtask - Run locked npm installation, deterministic asset rebuild, byte comparison, prefix audit, reset audit, and remote-URL audit.
      - [ ] 1.6.2.2 Subtask - Render light, dark, invalid-theme, reduced-motion, consumer-override, and BulmaUI coexistence fixtures.
      - [ ] 1.6.2.3 Subtask - Validate provenance completeness, exact source pin, required MIT notice, and excluded site assets.
      - [ ] 1.6.2.4 Subtask - Run `mix precommit`, `mix spec.check --base main`, and `git diff --check`.
