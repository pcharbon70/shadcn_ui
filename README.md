# ShadcnUI

ShadcnUI is an independently buildable Phoenix function-component package for
semantic HEEx rendered with a shadcn-style token contract and package-owned CSS.

The design is informed by [unscripted/ui](https://unscripted.janci.dev/): native
HTML elements and modern CSS provide interaction wherever the supported browser
platform can do so reliably. The package remains transport-neutral and does not
own controllers, routes, application state, domain operations, Dstar, Datastar,
Ash, or Electron capabilities.

ShadcnUI is an independent Phoenix adaptation. It is not an official shadcn/ui
or unscripted/ui project and is not endorsed by either project.

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

The package metadata is proprietary and supports local archive verification;
it does not configure or authorize publication to Hex.

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

### Themes and progressive baseline

Light tokens are the safe default. Place `data-shadcn-theme="dark"` or
`data-shadcn-theme="light"` on the document or a component ancestor to create an
explicit scope. Missing and unsupported values inherit the light defaults.
Consumers may override documented `--shadcn-ui-*` properties in any narrower
scope without rebuilding the stylesheet.

The stylesheet provides an sRGB baseline and uses OKLCH only behind a feature
query. Native meaning and content remain the acceptance floor when optional CSS
is unavailable. Focus uses visible outline and ring geometry, and
`prefers-reduced-motion` shortens nonessential animation and transition timing
without hiding state or content.

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

### Button

Button renders one native `button` with `button`, `submit`, and `reset` types;
`default`, `secondary`, `destructive`, `outline`, `ghost`, and `link` variants;
and `small`, `default`, `large`, and `icon` sizes. Icon-only presentation
requires a nonblank `accessible_label`. Optional `leading` and `trailing` slots
accept trusted HEEX around the required primary content.

```heex
<.button type="submit" variant={:default}>
  Save changes
</.button>
```

`loading` is a busy presentation snapshot. It does not disable the native
button, prevent duplicate submission, authorize a command, or manage a request;
the consuming application owns all of those outcomes.

## Upstream provenance

Substantially adapted unscripted/ui material is mapped in
`priv/provenance/unscripted_ui.json` to the exact reviewed upstream commit,
source paths, local paths, and local-change summaries. The complete required MIT
notice is preserved in `THIRD_PARTY_NOTICES.md`. Unscripted/ui is not a runtime
or build dependency, vendored tree, submodule, registry, or generated source
feed.

### Reviewing a later upstream revision

ShadcnUI does not automatically synchronize with upstream. To adopt a later
revision, review the commit range and license, compare every mapped upstream
path, preserve the local HEEX and accessibility contracts, update the manifest
pin and change summaries, rebuild the stylesheet, and run provenance, package,
component, and integration tests in the same change.
