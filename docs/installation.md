# Installation, assets, themes, and CSP

ShadcnUI is a transport-neutral Phoenix function-component package. Version
`1.0.0` is the first public Hex release. Install it from Hex; sibling development
may use a path dependency.

```elixir
# Published package
{:shadcn_ui, "~> 1.0"}

# Sibling development only
{:shadcn_ui, path: "../shadcn_ui"}
```

Run `mix deps.get`, then import every defining component in a Phoenix component
module:

```elixir
defmodule MyAppWeb.CoreComponents do
  use Phoenix.Component
  use ShadcnUI
end
```

For a narrow import, import the defining module directly:

```elixir
import ShadcnUI.Components.Foundation.Button, only: [button: 1]
```

Both paths preserve Phoenix's compiled attribute and slot validation. ShadcnUI
does not install routes, controllers, sockets, processes, event handlers, or
application state.

## Serve the packaged stylesheet

`ShadcnUI.stylesheet_path/0` resolves the installed package artifact. The
application owns copying, fingerprinting, caching, and serving it. A simple
Phoenix endpoint can serve the containing directory at a local URL:

```elixir
plug Plug.Static,
  at: "/vendor/shadcn-ui",
  from: Path.dirname(ShadcnUI.stylesheet_path()),
  gzip: false,
  only: ["shadcn_ui.css"]
```

Reference that local asset after the application's reset or base stylesheet and
before narrower consumer overrides:

```heex
<link rel="stylesheet" href="/vendor/shadcn-ui/shadcn_ui.css" />
<link rel="stylesheet" href="/assets/app.css" />
```

An existing asset pipeline may instead copy `ShadcnUI.stylesheet_path()` into
its fingerprinted output. Do not link the gallery stylesheet, a CDN, the
upstream unscripted/ui repository, or a mutable branch.

Consumers need no Node, npm, Tailwind, remote runtime asset, hook, or ShadcnUI
JavaScript. Tailwind and Node are package-maintainer build tools only; the
archive contains the compiled `priv/static/shadcn_ui.css` file.

## Themes, tokens, and stylesheet order

The package owns only `--shadcn-ui-*` tokens and `sui:`-prefixed generated
utilities. It ships no unrestricted reset. This lets it coexist with Bulma or
another design system when each component keeps its own classes and token
scope.

Light is the default. Put `data-shadcn-theme="light"` or
`data-shadcn-theme="dark"` on a document or a narrow ancestor. Override tokens
after the package stylesheet and in the smallest practical scope:

```css
.billing-preview {
  --shadcn-ui-primary: #075985;
  --shadcn-ui-primary-foreground: #fff;
  --shadcn-ui-radius: 0.625rem;
}
```

Do not reuse unprefixed application tokens as an implicit bridge between design
systems. CSS order should be: consumer reset/base, package stylesheet, then
consumer overrides. If another library requires a different reset, test both
class families together and keep ShadcnUI within an explicit theme scope.

The package honors `prefers-reduced-motion` and explicit
`data-shadcn-motion="reduced"` scopes. Reduction removes or shortens optional
motion while preserving content, native state, destinations, and focus.

## Content Security Policy

ShadcnUI renders ordinary HEEX and requires only a local stylesheet. It needs no
`script-src` allowance, inline script, `unsafe-eval`, remote font, CDN, worker,
WebSocket, or network origin. Adopt the application's restrictive CSP and allow
the local asset origin in `style-src`. Consumer-authored inline styles, images,
fonts, LiveView, Dstar, analytics, and other transports have their own CSP
requirements outside this package.

The browser remains an untrusted client. Component constraints and presentation
do not replace server parsing, validation, authentication, or authorization.
