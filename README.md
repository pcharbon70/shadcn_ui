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

Contributors build the stylesheet with pinned package-local tooling:

```console
npm ci
npm run assets:build
npm run assets:check
```

Tailwind CSS is not a consumer dependency. The build scans only package source,
uses the fixed `sui` prefix, excludes unrestricted Preflight, and emits one
minified `priv/static/shadcn_ui.css` artifact. Milestone A ships no component
JavaScript.

## Component contract

Components use closed atom or string values declared through
`Phoenix.Component` metadata. Those values select complete `sui:`-prefixed
class strings; request strings are never converted into atoms or interpolated
into utility names. Caller classes follow required package classes in stable
order.

Primary trusted HEEx belongs in `inner_block`, while named slots represent only
distinct semantic regions. Text remains escaped and there is no raw-HTML string
API. Documented native, `aria-*`, `data-*`, `phx-*`, and `data-on-*` attributes
pass through unless they conflict with a component's required native or
accessibility semantics. Rendered state is a snapshot; applications continue to
own lifecycle, commands, navigation, and outcomes.
