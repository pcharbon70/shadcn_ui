# Milestone A - Package, Styling, and Gallery Foundation

This implementation wave turns the initialized ShadcnUI Mix project into an
independently consumable HEEX component package with isolated compiled CSS, six
foundation components, pinned upstream provenance, and a controller-rendered
gallery published as a deterministic static site.

## Historical checklist status

The open Phase 2-5 browser and publication boxes preserve what was not executed
in those original phase-local runs. Later Milestones F and G provide broad
cross-engine, deterministic-export, SpecLed, and gallery evidence, but they do
not retroactively prove every exact Foundation scenario or turn the original
static-host deployment into the current Fly.io publication. The boxes therefore
remain open as historical evidence rather than current implementation tasks.

## Request alignment

- Milestone A implements Button, Badge, Alert, Card, Avatar, and Skeleton.
- Each component has its own section even when two components share a phase.
- Tailwind CSS v4 is package-local build tooling; consumers receive ordinary
  compiled CSS and need no Tailwind or Node.js installation.
- Generated utilities use the `sui` prefix, unrestricted Preflight is excluded,
  and public tokens use the `--shadcn-ui-*` namespace.
- Light is the safe default and dark is selected through
  `data-shadcn-theme="dark"`.
- The demo is a separate controller-rendered Phoenix consumer and its verified
  closed route inventory is exported for online static publication.
- Plans are non-normative. Accepted ADRs and active specifications remain the
  source of required behavior.

## Phase order

1. [Phase 1 - Package Contracts, CSS Build, Themes, and Provenance](./phase-01-package-contracts-css-build-themes-and-provenance.md)
2. [Phase 2 - Button and Badge Foundations](./phase-02-button-and-badge-foundations.md)
3. [Phase 3 - Alert and Card Foundations](./phase-03-alert-and-card-foundations.md)
4. [Phase 4 - Avatar and Skeleton Foundations](./phase-04-avatar-and-skeleton-foundations.md)
5. [Phase 5 - Online Gallery, Documentation, and Milestone Acceptance](./phase-05-online-gallery-documentation-and-milestone-acceptance.md)

## Shared conventions

- Checklist numbering uses `N`, `N.M`, `N.M.K`, and `N.M.K.L` for phases,
  sections, tasks, and subtasks.
- Every phase, section, and task is immediately followed by a description of
  its intent and expected outcome.
- Every phase ends with a dedicated `Phase N Integration Tests` section.
- Boxes remain unchecked until implementation and its verification land
  together.
- Components are stateless Phoenix function components with closed values,
  semantic HTML, escaped text, explicit slots, protected accessibility
  attributes, and caller-owned behavior.
- Tests use rendered HEEX and public package surfaces rather than treating
  private class helpers as the product API.
- Every section should be committed separately when this wave is implemented,
  with one pull request for the complete phase as requested by the normal
  repository workflow.

## Non-goals

- Milestone B forms and `Phoenix.HTML.FormField` integration.
- Milestone C navigation, disclosure, and application composition.
- Milestone D overlays or a compatibility runtime.
- Milestone E motion and media components.
- Dstar, Datastar, LiveView application processes, Ash, Electron APIs, Ecto,
  authentication, or application workflows.
- A public Hex release, theme marketplace, source-copy CLI, automatic upstream
  synchronization, or remote runtime assets.

## Exit criteria

- `use ShadcnUI` exposes all six components with compile-time metadata intact.
- A consumer loads `priv/static/shadcn_ui.css` without Tailwind, Node.js, or a
  component script and can override documented semantic tokens.
- Light, dark, reduced-motion, CSS isolation, reproducibility, and provenance
  contracts have automated evidence.
- The separate gallery provides one stable page per component, exports the
  closed route catalogue, and is published at a verified canonical HTTPS URL.
- Package precommit, locked asset checks, demo tests, browser tests, static
  export checks, documentation, package-content audit, SpecLed validation, and
  `git diff --check` pass.
