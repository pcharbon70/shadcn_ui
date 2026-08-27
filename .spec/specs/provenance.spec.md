# Upstream provenance and attribution

```spec-meta
id: shadcn_ui.provenance
kind: policy
status: active
summary: Auditable pinned provenance for substantially adapted unscripted/ui material.
decisions:
  - shadcn_ui.upstream_provenance
surface:
  - THIRD_PARTY_NOTICES.md
  - priv/provenance/unscripted_ui.json
  - README.md
  - test/shadcn_ui/provenance_test.exs
  - test/shadcn_ui/milestone_c_acceptance_test.exs
```

## Requirements

```spec-requirements
- id: shadcn_ui.provenance.pinned_revision
  statement: The package shall identify the reviewed unscripted/ui repository URL and exact source commit used for every released adaptation.
  priority: must
  stability: stable

- id: shadcn_ui.provenance.component_mapping
  statement: A machine-readable package-owned manifest shall map every substantially adapted component or CSS block in the current catalogue to its upstream source path, pinned commit, and concise local-change summary.
  priority: must
  stability: stable

- id: shadcn_ui.provenance.mit_notice
  statement: THIRD_PARTY_NOTICES.md shall preserve the complete required unscripted/ui MIT copyright and permission notice for copied or substantially adapted material.
  priority: must
  stability: stable

- id: shadcn_ui.provenance.no_upstream_runtime
  statement: Unscripted/ui shall not be a runtime or build Git dependency, submodule, vendored source tree, registry, or automatic synchronization target.
  priority: must
  stability: stable

- id: shadcn_ui.provenance.site_assets_excluded
  statement: Remote demo images, fonts, analytics, documentation-site scripts, and site-only content shall remain outside ShadcnUI release contents.
  priority: must
  stability: stable

- id: shadcn_ui.provenance.independent_identity
  statement: Public documentation shall describe ShadcnUI as an independent Phoenix adaptation and shall not imply official affiliation with shadcn or unscripted/ui.
  priority: must
  stability: stable
```

## Verification

Phase 6 audits all six existing E component mappings against the same exact pin,
without changing copied material or adding site assets. Final candidate tests
and the actual archive audit preserve normative manifests and full MIT notice
while excluding demo-only measured observations and media fixtures.

Phase 5 maps Media.ImageGallery to pinned gallery.mdx and gallery/basic.html.
Local changes add explicit close, semantic keyed figures, validated responsive
metadata, complete captions and separate ordinary destinations. Full images
contain; origin CSS is deliberately deferred. Only prefixed static utilities
and existing Dialog CSS ship. No upstream site artwork or command shim is copied;
the existing complete MIT notice and original local fixture rights remain intact.

Phase 4 maps Scroll Indicator and Cover Flow to pinned basic.html and respective
progress.css/flow.css sources. Local adaptations omit completion claims, scroll
containment, reflection, overlap and animated stacking; the native region/list
and independent captions/destinations remain authoritative. MIT notice retained.

Phase 3 maps Marquee to the same pinned basic.html/loop.css sources; the local
adaptation replaces endless travel with a native opt-in finite preview, a complete
wrapped list and an inert, ID-free duplicate. Existing MIT attribution is retained.
Stagger maps the reviewed basic.html to visible keyed trusted slots, closed
semantic wrappers and capped finite effects, omitting upstream toggle-to-hide
and unbounded sibling-index delays.

Milestone E Phase 2 maps Media.Carousel and carousel.css to the pinned native
list and reviewed marker sources. Local changes explicitly retain real index
links, visible scrollbars and focus while omitting generated controls. The
existing complete MIT notice remains unchanged.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/milestone_e_acceptance_test.exs
  covers:
    - shadcn_ui.provenance.component_mapping

- kind: test_file
  target: test/shadcn_ui/provenance_test.exs
  covers:
    - shadcn_ui.provenance.pinned_revision
    - shadcn_ui.provenance.component_mapping
    - shadcn_ui.provenance.mit_notice
    - shadcn_ui.provenance.no_upstream_runtime
    - shadcn_ui.provenance.site_assets_excluded
    - shadcn_ui.provenance.independent_identity

- kind: test_file
  target: test/shadcn_ui/milestone_a_acceptance_test.exs
  covers:
    - shadcn_ui.provenance.pinned_revision
    - shadcn_ui.provenance.component_mapping
    - shadcn_ui.provenance.mit_notice
    - shadcn_ui.provenance.no_upstream_runtime
    - shadcn_ui.provenance.site_assets_excluded
    - shadcn_ui.provenance.independent_identity

- kind: test_file
  target: test/shadcn_ui/milestone_c_acceptance_test.exs
  covers:
    - shadcn_ui.provenance.pinned_revision
    - shadcn_ui.provenance.component_mapping
    - shadcn_ui.provenance.mit_notice
    - shadcn_ui.provenance.no_upstream_runtime
    - shadcn_ui.provenance.site_assets_excluded
    - shadcn_ui.provenance.independent_identity
```
