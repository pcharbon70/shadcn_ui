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
surface:
  - demo/**
  - scripts/**
  - test/browser/milestone-a-gallery.spec.mjs
  - test/shadcn_ui/milestone_a_acceptance_test.exs
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
  statement: The gallery shall own one immutable ordered catalogue with stable Foundation category and Button, Badge, Alert, Card, Avatar, and Skeleton leaves whose request slugs resolve only through closed strings to explicit render identities.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.safe_resolution
  statement: Request input shall never create atoms or select modules, functions, templates, callbacks, asset paths, or executable code dynamically, and unknown or mismatched routes shall return a deterministic non-reflecting 404.
  priority: must
  stability: stable

- id: shadcn_ui.gallery.stable_routes
  statement: The gallery shall provide stable controller and exported routes for a categorized landing, Foundation category, and one page per Milestone A component with ordinary links and accurate current-page state.
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
  statement: Every Milestone A page shall render under explicit light and dark data-shadcn-theme scopes, default safely to light, preserve readable focus and content at narrow widths, and keep core content usable when demo-only scripting is disabled.
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

```spec-verification
- kind: test_file
  target: demo/test/shadcn_ui_demo/boundary_test.exs
  covers:
    - shadcn_ui.gallery.separate_application
    - shadcn_ui.gallery.controller_rendered
    - shadcn_ui.gallery.no_application_frameworks
    - shadcn_ui.gallery.demo_only_script
    - shadcn_ui.gallery.deterministic_assets
    - shadcn_ui.gallery.excluded_from_package

- kind: test_file
  target: demo/test/shadcn_ui_demo/gallery_catalog_test.exs
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
  target: demo/test/shadcn_ui_demo/static_export_test.exs
  covers:
    - shadcn_ui.gallery.closed_catalog
    - shadcn_ui.gallery.deterministic_assets
    - shadcn_ui.gallery.static_export
    - shadcn_ui.gallery.excluded_from_package

- kind: test_file
  target: test/browser/milestone-a-gallery.spec.mjs
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
```
