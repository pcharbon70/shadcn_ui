# ShadcnUI package guidance

ShadcnUI is an independently buildable, transport-neutral Phoenix function-
component package. It renders semantic HEEx and distributes package-owned CSS
based on the shadcn token contract and carefully adapted unscripted/ui patterns.

- Do not add application state, routes, controllers, Dstar, Datastar, Ash, or
  Electron capabilities to this package.
- Prefer native HTML semantics and progressive CSS enhancement.
- Do not claim that a visual substitute has a richer ARIA widget contract.
- Keep Tailwind a package build-time concern; consumers receive compiled CSS.
- Prefix generated utilities and avoid an unrestricted global reset so the
  package can coexist with BulmaUI.
- Preserve required upstream notices for substantially adapted MIT-licensed
  source.
- Read `.spec/AGENTS.md` before changing specifications, decisions, milestones,
  or plans.
