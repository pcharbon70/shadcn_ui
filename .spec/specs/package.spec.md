# ShadcnUI package

```spec-meta
id: shadcn_ui.package
kind: package
status: active
summary: Independently buildable transport-neutral Phoenix function-component package.
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
  - CHANGELOG.md
  - THIRD_PARTY_NOTICES.md
  - test/shadcn_ui/package_test.exs
  - test/shadcn_ui/release_readiness_test.exs
  - test/shadcn_ui/milestone_a_acceptance_test.exs
  - test/shadcn_ui/milestone_d_acceptance_test.exs
  - scripts/check-release-archive.exs
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

- id: shadcn_ui.package.no_consumer_asset_toolchain
  statement: A package consumer shall use the distributed stylesheet without installing Node.js, Tailwind CSS, or a ShadcnUI JavaScript runtime.
  priority: must
  stability: stable
```

## Verification

Milestone E Phase 1 includes internal media/motion normalization and normative
capability JSON in the existing allowlist, without new public imports or runtime
dependencies. The actual archive audit requires both helpers and both manifest
files, and rejects demo fixtures and observed browser records.

```spec-verification
- kind: command
  target: mix precommit
  execute: true
  covers:
    - shadcn_ui.package.independent_mix_project
    - shadcn_ui.package.heex_infrastructure_only
    - shadcn_ui.package.transport_neutral
    - shadcn_ui.package.public_import_surface
    - shadcn_ui.package.explicit_release_files
    - shadcn_ui.package.no_consumer_asset_toolchain

- kind: test_file
  target: test/shadcn_ui/package_test.exs
  covers:
    - shadcn_ui.package.independent_mix_project
    - shadcn_ui.package.heex_infrastructure_only
    - shadcn_ui.package.transport_neutral
    - shadcn_ui.package.public_import_surface
    - shadcn_ui.package.explicit_release_files
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
