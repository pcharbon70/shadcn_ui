# Online component gallery

```spec-meta
id: shadcn_ui.gallery
kind: application
status: active
summary: Separate controller-rendered Phoenix consumer with deterministic static online publication.
decisions:
  - shadcn_ui.transport_neutral_phoenix_package
  - shadcn_ui.scoped_theme_token_contract
  - shadcn_ui.progressive_enhancement_baseline
  - shadcn_ui.gallery_static_publication
  - shadcn_ui.deterministic_form_accessibility
  - shadcn_ui.enhanced_select_boundary
  - shadcn_ui.native_disclosure_grouping
  - shadcn_ui.destination_navigation_landmarks
  - shadcn_ui.native_scroll_sticky_surfaces
  - shadcn_ui.radio_panels_not_tabs
  - shadcn_ui.native_overlay_platform_runtime
  - shadcn_ui.dialog_modality_focus_dismissal
  - shadcn_ui.popover_positioning_actions
  - shadcn_ui.supplemental_surface_boundary
surface:
  - demo/**
  - scripts/**
  - test/browser/milestone-a-gallery.spec.mjs
  - test/browser/milestone-b-forms.spec.mjs
  - test/browser/milestone-c-content-navigation.spec.mjs
  - test/browser/milestone-d-*.spec.mjs
  - test/shadcn_ui/milestone_a_acceptance_test.exs
  - test/shadcn_ui/milestone_b_acceptance_test.exs
  - test/shadcn_ui/milestone_c_acceptance_test.exs
  - test/shadcn_ui/milestone_d_acceptance_test.exs
  - README.md
```

## Requirements

```spec-requirements
- id: shadcn_ui.gallery.separate_application
  statement: The gallery shall be a separate Phoenix application under demo that consumes ShadcnUI through a path dependency.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.controller_rendered
  statement: Gallery source pages shall use ordinary controller-rendered HEEx without LiveView routes, sockets, hooks, processes, or state synchronization.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.no_application_frameworks
  statement: The gallery shall add no Ecto, Dstar, Datastar, Ash, authentication, Electron capability, or application behavior framework.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.closed_catalog
  statement: The gallery shall own one immutable ordered catalogue with stable Foundation, Forms, Disclosure, Navigation, Content Surfaces, Overlays, and Interactive Surfaces categories, appending Media and Motion incrementally with implemented leaves whose request slugs resolve only through closed strings to explicit render identities.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.safe_resolution
  statement: Request input shall never create atoms or select modules, functions, templates, callbacks, asset paths, or executable code dynamically, and unknown or mismatched routes shall return a deterministic non-reflecting 404.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.stable_routes
  statement: The gallery shall provide stable controller and exported routes for a categorized landing, every current category, and one page per current component with ordinary links and accurate current-page state.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.semantic_shell
  statement: Every page shall provide a skip link, named navigation before main content, breadcrumb, one main landmark and page heading, visible focus treatment, responsive stacking, and no menu, tab, tree, or client-router role overstatement.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.component_guidance
  statement: Each component page shall provide practical purpose, usage guidance, rendered variants and semantic states, HEEX source, application ownership, accessibility, theme behavior, progressive fallback, and provenance in plain English.
  priority: must
  stability: evolving

- id: shadcn_ui.gallery.theme_matrix
  statement: Every current component page shall render under explicit light and dark data-shadcn-theme scopes, default safely to light, preserve readable focus and content at narrow widths, and keep core content usable when demo-only scripting is disabled.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.demo_only_script
  statement: Optional theme persistence and source-copy behavior shall live in an explicit demo-only script, shall not implement component behavior, and shall be excluded from package release contents.
  priority: should
  stability: stable

- id: shadcn_ui.gallery.deterministic_assets
  statement: Gallery dependency and asset locks shall produce only local fingerprinted CSS, JavaScript, images, and fonts without remote runtime imports or globally installed tools.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.static_export
  statement: A deterministic command shall request the complete closed controller route inventory and write equivalent self-contained static HTML and local assets to ignored export output.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.online_publication
  statement: CI shall publish the verified static artifact to an approved HTTPS host, expose its canonical URL, run direct-route and asset smoke checks, and retain a documented rollback procedure without placing credentials in the repository.
  priority: must
  stability: evolving

- id: shadcn_ui.gallery.excluded_from_package
  statement: Demo source, dependencies, scripts, tests, generated assets, static export output, deployment configuration, and credentials shall remain outside the ShadcnUI release allowlist.
  priority: must
  stability: stable
```

## Verification

Milestone E Phase 3 appends only implemented Motion leaves, marquee and stagger,
plus the motion-preferences composition. Complete source compiles through public
imports. Canonical URLs, closed preferences, subpath export and local native
interaction remain shared with earlier pages; no demo motion runtime is added.

Milestone E Phase 1 adds /examples/motion-media-capabilities without publishing
unfinished component leaves. Closed system/reduce inspection links preserve
theme choices, with ordinary no-script theme alternatives. Static publication
adds concrete preference variants and manifest-selected local SVG media to the
existing three code/style assets. Src/srcset references and preference links
resolve under repository-site subpaths. Fixture paths, hashes, dimensions,
rights and inactive SVG content are validated before export; unlisted assets
and escaping symlinks are rejected. All A–D component routes remain unchanged.

```spec-verification
- kind: test_file
  target: demo/test/gallery_boundary_test.exs
  covers:
    - shadcn_ui.gallery.separate_application
    - shadcn_ui.gallery.controller_rendered
    - shadcn_ui.gallery.no_application_frameworks
    - shadcn_ui.gallery.demo_only_script
    - shadcn_ui.gallery.deterministic_assets
    - shadcn_ui.gallery.excluded_from_package

- kind: test_file
  target: demo/test/catalogue_test.exs
  covers:
    - shadcn_ui.gallery.closed_catalog
    - shadcn_ui.gallery.safe_resolution
    - shadcn_ui.gallery.stable_routes

- kind: test_file
  target: demo/test/shadcn_ui_demo_web/controllers/gallery_controller_test.exs
  covers:
    - shadcn_ui.gallery.safe_resolution
    - shadcn_ui.gallery.stable_routes
    - shadcn_ui.gallery.semantic_shell
    - shadcn_ui.gallery.component_guidance
    - shadcn_ui.gallery.theme_matrix

- kind: test_file
  target: demo/test/static_export_test.exs
  covers:
    - shadcn_ui.gallery.closed_catalog
    - shadcn_ui.gallery.deterministic_assets
    - shadcn_ui.gallery.static_export
    - shadcn_ui.gallery.excluded_from_package

- kind: test_file
  target: demo/test/browser/gallery.spec.mjs
  covers:
    - shadcn_ui.gallery.stable_routes
    - shadcn_ui.gallery.semantic_shell
    - shadcn_ui.gallery.component_guidance
    - shadcn_ui.gallery.theme_matrix
    - shadcn_ui.gallery.demo_only_script

- kind: command
  target: npm run gallery:smoke
  execute: true
  covers:
    - shadcn_ui.gallery.static_export
    - shadcn_ui.gallery.online_publication

- kind: test_file
  target: test/shadcn_ui/milestone_a_acceptance_test.exs
  covers:
    - shadcn_ui.gallery.separate_application
    - shadcn_ui.gallery.controller_rendered
    - shadcn_ui.gallery.no_application_frameworks
    - shadcn_ui.gallery.closed_catalog
    - shadcn_ui.gallery.safe_resolution
    - shadcn_ui.gallery.stable_routes
    - shadcn_ui.gallery.semantic_shell
    - shadcn_ui.gallery.component_guidance
    - shadcn_ui.gallery.theme_matrix
    - shadcn_ui.gallery.demo_only_script
    - shadcn_ui.gallery.deterministic_assets
    - shadcn_ui.gallery.static_export
    - shadcn_ui.gallery.online_publication
    - shadcn_ui.gallery.excluded_from_package

- kind: test_file
  target: test/shadcn_ui/milestone_b_acceptance_test.exs
  covers:
    - shadcn_ui.gallery.closed_catalog
    - shadcn_ui.gallery.safe_resolution
    - shadcn_ui.gallery.stable_routes
    - shadcn_ui.gallery.semantic_shell
    - shadcn_ui.gallery.component_guidance
    - shadcn_ui.gallery.theme_matrix
    - shadcn_ui.gallery.deterministic_assets
    - shadcn_ui.gallery.static_export
    - shadcn_ui.gallery.excluded_from_package

- kind: test_file
  target: test/browser/milestone-c-content-navigation.spec.mjs
  covers:
    - shadcn_ui.gallery.stable_routes
    - shadcn_ui.gallery.semantic_shell
    - shadcn_ui.gallery.component_guidance
    - shadcn_ui.gallery.theme_matrix

- kind: test_file
  target: test/shadcn_ui/milestone_c_acceptance_test.exs
  covers:
    - shadcn_ui.gallery.separate_application
    - shadcn_ui.gallery.controller_rendered
    - shadcn_ui.gallery.no_application_frameworks
    - shadcn_ui.gallery.closed_catalog
    - shadcn_ui.gallery.safe_resolution
    - shadcn_ui.gallery.stable_routes
    - shadcn_ui.gallery.semantic_shell
    - shadcn_ui.gallery.component_guidance
    - shadcn_ui.gallery.theme_matrix
    - shadcn_ui.gallery.demo_only_script
    - shadcn_ui.gallery.deterministic_assets
    - shadcn_ui.gallery.static_export
    - shadcn_ui.gallery.online_publication
    - shadcn_ui.gallery.excluded_from_package

- kind: test_file
  target: test/browser/milestone-d-gallery.spec.mjs
  covers:
    - shadcn_ui.gallery.stable_routes
    - shadcn_ui.gallery.semantic_shell
    - shadcn_ui.gallery.component_guidance
    - shadcn_ui.gallery.theme_matrix

- kind: test_file
  target: test/shadcn_ui/milestone_d_acceptance_test.exs
  covers:
    - shadcn_ui.gallery.separate_application
    - shadcn_ui.gallery.controller_rendered
    - shadcn_ui.gallery.no_application_frameworks
    - shadcn_ui.gallery.closed_catalog
    - shadcn_ui.gallery.safe_resolution
    - shadcn_ui.gallery.stable_routes
    - shadcn_ui.gallery.semantic_shell
    - shadcn_ui.gallery.component_guidance
    - shadcn_ui.gallery.theme_matrix
    - shadcn_ui.gallery.demo_only_script
    - shadcn_ui.gallery.deterministic_assets
    - shadcn_ui.gallery.static_export
    - shadcn_ui.gallery.online_publication
    - shadcn_ui.gallery.excluded_from_package
```
