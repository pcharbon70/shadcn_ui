---
id: shadcn_ui.isolated_compiled_css
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.package
  - shadcn_ui.stylesheet
  - shadcn_ui.gallery
---

# Compile Isolated CSS as a Package-Owned Build Artifact

## Context

Unscripted/ui is zero-runtime-JavaScript HTML styled with Tailwind CSS v4
utilities. Requiring every Phoenix consumer to install Tailwind, discover
dependency source, and reproduce the library build would weaken ShadcnUI's
independent package boundary. Unprefixed utilities and global Preflight would
also risk collisions with BulmaUI and application CSS.

## Decision

Tailwind CSS v4 is a pinned package-local development build tool.

- Authored HEEX uses Tailwind v4's supported prefix syntax with the fixed `sui`
  prefix for generated utilities and Tailwind-owned variables.
- The build scans only explicit ShadcnUI source and asset inputs. Dynamic public
  values map to complete statically discoverable class strings.
- The build excludes unrestricted Tailwind Preflight. A small authored
  foundation layer may normalize only elements and pseudo-elements required by
  documented components.
- One deterministic minified artifact is published at
  `priv/static/shadcn_ui.css`; consumers do not need Node.js or Tailwind at
  runtime or during their own asset build.
- `ShadcnUI.stylesheet_path/0` resolves the packaged artifact with
  `Application.app_dir/2` but does not copy, serve, or inject it.
- The npm manifest and lockfile pin the builder. Tests rebuild and compare the
  artifact, audit prefixes and resets, and reject remote runtime imports.
- Milestone A ships no component JavaScript.

## Consequences

The package owns a Node-based authoring step but distributes ordinary CSS.
Consumers receive predictable assets and can load ShadcnUI alongside BulmaUI.
Any later supplemental handwritten CSS or optional JavaScript requires an
explicitly documented reason and acceptance coverage.
