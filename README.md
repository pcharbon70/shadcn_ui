# ShadcnUI

ShadcnUI is an independently buildable Phoenix function-component package for
semantic HEEx rendered with a shadcn-style token contract and package-owned CSS.

The design is informed by [unscripted/ui](https://unscripted.janci.dev/): native
HTML elements and modern CSS provide interaction wherever the supported browser
platform can do so reliably. The package remains transport-neutral and does not
own controllers, routes, application state, domain operations, Dstar, Datastar,
Ash, or Electron capabilities.

The project is currently defining its architecture and implementation
milestones. See [`.spec/milestones`](./.spec/milestones/README.md) for the
roadmap.

## Installation

During monorepo development, add the package as a path dependency:

```elixir
{:shadcn_ui, path: "../../packages/shadcn_ui"}
```

Public components, asset installation, and `use ShadcnUI` guidance will be added
as their contracts are implemented. This internal `0.x` package is not yet
published to Hex.
