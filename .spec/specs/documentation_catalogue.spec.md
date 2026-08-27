# Documentation catalogue, search, and information architecture

```spec-meta
id: shadcn_ui.documentation_catalogue
kind: application
status: active
summary: Closed documentation inventory driving stable gallery navigation, examples, search, and completeness proof without a package runtime registry.
decisions:
  - shadcn_ui.gallery_static_publication
  - shadcn_ui.catalogue_driven_documentation
surface:
  - demo/lib/shadcn_ui_demo/catalogue.ex
  - demo/lib/shadcn_ui_demo/documentation_catalogue.ex
  - demo/lib/shadcn_ui_demo_web/**
  - demo/assets/gallery.js
  - demo/test/documentation_catalogue_test.exs
  - demo/test/milestone_f_phase1_acceptance_test.exs
  - demo/test/static_export_test.exs
  - test/shadcn_ui/milestone_f_phase1_acceptance_test.exs
  - demo/test/browser/milestone-f-catalogue.spec.mjs
```

## Requirements

```spec-requirements
- id: shadcn_ui.documentation_catalogue.closed_schema
  statement: One immutable authored catalogue shall describe each public defining component through closed category, slug, module, function, route, example, documentation, provenance, and verification identities.
  priority: must
  stability: stable

- id: shadcn_ui.documentation_catalogue.public_api_parity
  statement: Catalogue validation shall prove a one-to-one mapping between public defining component functions and component pages without silently omitting or inventing a public API.
  priority: must
  stability: stable

- id: shadcn_ui.documentation_catalogue.stable_information_architecture
  statement: Existing categories, component routes, breadcrumbs, canonical URLs, current-page state, and sitemap entries shall remain stable while documentation metadata is added.
  priority: must
  stability: stable

- id: shadcn_ui.documentation_catalogue.stable_examples
  statement: Every authored example shall have a unique stable fragment, rendered preview, compile-checked HEEX source, and explicit component-page relationship.
  priority: must
  stability: evolving

- id: shadcn_ui.documentation_catalogue.safe_resolution
  statement: Route, fragment, and search input shall never create atoms or dynamically select modules, functions, templates, callbacks, asset paths, or executable code.
  priority: must
  stability: stable

- id: shadcn_ui.documentation_catalogue.progressive_navigation
  statement: Categorized desktop and mobile navigation shall expose every component through ordinary links and remain complete and usable without JavaScript.
  priority: must
  stability: stable

- id: shadcn_ui.documentation_catalogue.deterministic_search
  statement: Static export shall derive a deterministic local search document from the closed catalogue, with normalized searchable text and stable destination URLs but no rendered or executable user input.
  priority: must
  stability: stable

- id: shadcn_ui.documentation_catalogue.progressive_search
  statement: Demo-only JavaScript may filter and announce the complete server-rendered catalogue but shall not become a client router, fetch remote search data, or implement component behavior.
  priority: must
  stability: stable

- id: shadcn_ui.documentation_catalogue.completeness_report
  statement: A deterministic completeness audit shall connect every catalogue entry to its page, examples, public documentation, provenance, source compile test, browser route, and export artifact.
  priority: must
  stability: evolving

- id: shadcn_ui.documentation_catalogue.package_boundary
  statement: Documentation catalogue implementation, search data, demo scripts, previews, and generated completeness output shall remain outside package release contents.
  priority: must
  stability: stable
```

## Verification

These are planned Milestone F targets. Accepted requirements do not claim the
files, generated evidence, or browser results already exist.

```spec-verification
- kind: test_file
  target: demo/test/documentation_catalogue_test.exs
  covers:
    - shadcn_ui.documentation_catalogue.closed_schema
    - shadcn_ui.documentation_catalogue.public_api_parity
    - shadcn_ui.documentation_catalogue.stable_information_architecture
    - shadcn_ui.documentation_catalogue.stable_examples
    - shadcn_ui.documentation_catalogue.safe_resolution
    - shadcn_ui.documentation_catalogue.completeness_report

- kind: test_file
  target: demo/test/static_export_test.exs
  covers:
    - shadcn_ui.documentation_catalogue.deterministic_search
    - shadcn_ui.documentation_catalogue.package_boundary

- kind: test_file
  target: test/shadcn_ui/milestone_f_phase1_acceptance_test.exs
  covers:
    - shadcn_ui.documentation_catalogue.package_boundary

- kind: test_file
  target: demo/test/browser/milestone-f-catalogue.spec.mjs
  covers:
    - shadcn_ui.documentation_catalogue.stable_information_architecture
    - shadcn_ui.documentation_catalogue.stable_examples
    - shadcn_ui.documentation_catalogue.progressive_navigation
    - shadcn_ui.documentation_catalogue.progressive_search
```
