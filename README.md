# ShadcnUI

ShadcnUI is an independently buildable Phoenix function-component package for
semantic HEEx rendered with a shadcn-style token contract and package-owned CSS.

The design is informed by [unscripted/ui](https://unscripted.janci.dev/): native
HTML elements and modern CSS provide interaction wherever the supported browser
platform can do so reliably. The package remains transport-neutral and does not
own controllers, routes, application state, domain operations, Dstar, Datastar,
Ash, or Electron capabilities.

Milestone A is establishing the package boundary, stylesheet, foundation
components, and gallery. See [`.spec/milestones`](./.spec/milestones/README.md)
for the roadmap.

## Installation

During monorepo development, add the package as a path dependency:

```elixir
{:shadcn_ui, path: "../../packages/shadcn_ui"}
```

Import the package's public defining component modules with:

```elixir
use ShadcnUI
```

`phoenix_live_view` supplies `Phoenix.Component`, HEEx, attributes, and slots;
ShadcnUI does not install LiveView routes, sockets, processes, hooks, navigation,
or state synchronization. Applications own all behavior and transport choices.

`ShadcnUI.stylesheet_path/0` returns the absolute path to the compiled package
stylesheet. The consuming application owns copying, bundling, or serving that
file. This internal `0.x` package is not yet published to Hex.
