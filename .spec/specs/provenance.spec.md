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
```

## Requirements

```spec-requirements
- id: shadcn_ui.provenance.pinned_revision
  statement: The package shall identify the reviewed unscripted/ui repository URL and exact source commit used for every Milestone A adaptation.
  priority: must
  stability: stable

- id: shadcn_ui.provenance.component_mapping
  statement: A machine-readable package-owned manifest shall map every substantially adapted component or CSS block to its upstream source path, pinned commit, and concise local-change summary.
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

```spec-verification
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
```
