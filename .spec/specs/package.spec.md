# ShadcnUI package

```spec-meta
id: shadcn_ui.package
kind: package
status: active
summary: Independently buildable transport-neutral Phoenix function-component package whose metadata links to the separately deployed Fly.io gallery.
decisions:
  - shadcn_ui.transport_neutral_phoenix_package
  - shadcn_ui.isolated_compiled_css
  - shadcn_ui.upstream_provenance
surface:
  - mix.exs
  - mix.lock
  - package.json
  - package-lock.json
  - lib/shadcn_ui.ex
  - lib/shadcn_ui/**/*.ex
  - priv/static/shadcn_ui.css
  - priv/compatibility/*.json
  - README.md
  - LICENSE
  - CHANGELOG.md
  - THIRD_PARTY_NOTICES.md
  - test/shadcn_ui/package_test.exs
  - test/shadcn_ui/release_readiness_test.exs
  - test/shadcn_ui/milestone_a_acceptance_test.exs
  - test/shadcn_ui/milestone_d_acceptance_test.exs
  - scripts/check-release-archive.exs
  - release/consumer-trial-evidence.json
```

## Requirements

```spec-requirements
- id: shadcn_ui.package.independent_mix_project
  statement: ShadcnUI shall compile, test, build documentation, and build its release archive as an independent Mix project.
  priority: must
  stability: stable

- id: shadcn_ui.package.heex_infrastructure_only
  statement: The phoenix_live_view dependency shall provide Phoenix.Component and HEEx infrastructure only; ShadcnUI shall define no LiveView route, socket, process, hook, navigation, or state synchronization.
  priority: must
  stability: stable

- id: shadcn_ui.package.transport_neutral
  statement: Runtime dependencies and release sources shall contain no controller, endpoint, Dstar, Datastar, Ash, Electron, persistence, authorization, request, or application-state implementation.
  priority: must
  stability: stable

- id: shadcn_ui.package.public_import_surface
  statement: use ShadcnUI shall import public defining component modules directly and preserve Phoenix compile-time attribute and slot metadata at caller sites.
  priority: must
  stability: stable

- id: shadcn_ui.package.explicit_release_files
  statement: The package shall use an explicit release-file allowlist containing runtime modules, the compiled stylesheet, required notices, README, changelog, and Mix metadata while excluding demo, tests, build tools, dependencies, generated documentation, and mutable output.
  priority: must
  stability: stable

- id: shadcn_ui.package.mit_license
  statement: ShadcnUI shall declare the standard SPDX MIT license identifier and include the complete root MIT license text in its release archive.
  priority: must
  stability: stable

- id: shadcn_ui.package.no_consumer_asset_toolchain
  statement: A package consumer shall receive component-scoped Accordion geometry, decorative affordance, row presentation, and reduced-motion behavior in the distributed stylesheet and use that stylesheet without installing Node.js, Tailwind CSS, or a ShadcnUI JavaScript runtime.
  priority: must
  stability: stable
```

## Verification

Verification files carry explicit `covers` annotations so declared proof remains
bidirectionally traceable without changing this subject's package contract.

The category-oriented user guides are ExDoc inputs only. They compile against
the public imports during documentation verification and remain outside the
explicit release-file allowlist, so they add no runtime module, dependency,
asset toolchain or generated documentation to the package archive.
Internal evidence, engineering records and gallery operations are not ExDoc
inputs and remain outside the package archive as well.

Milestone E Phase 6 groups all six defining Media/Motion APIs in ExDoc and
compiles the guide composition against the public imports and Phoenix metadata.
Documentation and test harnesses do not expand the actual release allowlist.

Milestone E Phase 5 directly imports Media.ImageGallery with defining attr/slot
metadata and requires it in the actual archive audit. Origin probe code, observed
evidence, fixture media and the gallery remain excluded. No new dependency,
component runtime or consumer asset toolchain is introduced.

Milestone E Phase 1 includes internal media/motion normalization and normative
capability JSON in the existing allowlist, without new public imports or runtime
dependencies. The actual archive audit requires both helpers and both manifest
files, and rejects demo fixtures and observed browser records.

Phase 2 directly imports the defining Media.Carousel module and requires it in
the actual archive audit. The generated browser fixture, demo reference/media
and test/export infrastructure remain excluded; no runtime dependency is added.

Phase 3 directly imports Motion.Marquee and Motion.Stagger with native Phoenix
attribute/slot metadata. The actual archive audit requires both sources and
retains the same explicit release exclusions; no animation runtime is added.

Phase 4 directly imports Motion.ScrollIndicator and Media.CoverFlow and requires
both in the actual archive audit. Its separate component-outcome record, local
images and actual-HEEx/browser harness remain excluded. The native timeline
presentation adds no package JS, runtime dependency or consumer toolchain.

The current archive audit and isolated-consumer record are working-tree
evidence for the explicit release boundary. They do not supply a committed
source identity or the release subject's required two-clean-build
qualification, which remains a separately recorded pending gate.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/milestone_e_acceptance_test.exs
  covers:
    - shadcn_ui.package.public_import_surface

- kind: command
  target: mix precommit
  execute: true
  covers:
    - shadcn_ui.package.independent_mix_project
    - shadcn_ui.package.heex_infrastructure_only
    - shadcn_ui.package.transport_neutral
    - shadcn_ui.package.public_import_surface
    - shadcn_ui.package.explicit_release_files
    - shadcn_ui.package.mit_license
    - shadcn_ui.package.no_consumer_asset_toolchain

- kind: test_file
  target: test/shadcn_ui/package_test.exs
  covers:
    - shadcn_ui.package.independent_mix_project
    - shadcn_ui.package.heex_infrastructure_only
    - shadcn_ui.package.transport_neutral
    - shadcn_ui.package.public_import_surface
    - shadcn_ui.package.explicit_release_files
    - shadcn_ui.package.mit_license
    - shadcn_ui.package.no_consumer_asset_toolchain

- kind: test_file
  target: test/shadcn_ui/milestone_d_acceptance_test.exs
  covers:
    - shadcn_ui.package.explicit_release_files
    - shadcn_ui.package.public_import_surface

- kind: test_file
  target: test/shadcn_ui/milestone_a_acceptance_test.exs
  covers:
    - shadcn_ui.package.independent_mix_project
    - shadcn_ui.package.heex_infrastructure_only
    - shadcn_ui.package.transport_neutral
    - shadcn_ui.package.public_import_surface
    - shadcn_ui.package.explicit_release_files
    - shadcn_ui.package.no_consumer_asset_toolchain
```
