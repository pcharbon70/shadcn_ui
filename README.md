# ShadcnUI

ShadcnUI is a transport-neutral library of Phoenix function components built
with semantic HEEX, native HTML behavior, and package-owned shadcn-style CSS.
It provides 41 components without installing routes, controllers, LiveViews,
hooks, processes, or application state.

- [Live demo on Fly.io](https://pcharbon70-shadcn-ui-demo.fly.dev/)
- [Bundled Phoenix demo](demo/README.md)
- [Component index](docs/components.md)
- [Installation guide](docs/installation.md)
- [Compatibility policy](docs/compatibility.md)

The repository includes a Phoenix demo application under `demo/` that
exercises every component category and provides the source for the online
gallery. It is a reference consumer and is not included in the Hex package
runtime.

> **Release status**
>
> Version `1.0.0` is being prepared as the first public Hex release and is not
> published yet. Install a reviewed Git revision until publication is
> explicitly announced.

## Features

- Semantic Phoenix function components with compile-time attribute and slot
  validation.
- Native forms, disclosure, navigation, dialogs, popovers, scrolling, and
  media behavior with progressive CSS enhancement.
- One compiled stylesheet with `sui:`-prefixed utilities, scoped
  `--shadcn-ui-*` tokens, and no unrestricted global reset.
- No package JavaScript runtime, client state, remote assets, consumer Tailwind
  build, or consumer Node dependency.
- Explicit light and dark themes, reduced-motion handling, forced-color
  resilience, and capability-based fallbacks.
- Caller-owned validation, authorization, persistence, navigation, transport,
  and request lifecycle.

## Installation

Add a reviewed revision to your dependencies:

```elixir
defp deps do
  [
    {:shadcn_ui,
     git: "https://github.com/pcharbon70/shadcn_ui.git",
     ref: "<reviewed-commit-sha>"}
  ]
end
```

Then fetch dependencies:

```console
mix deps.get
```

For sibling development, use a path dependency instead:

```elixir
{:shadcn_ui, path: "../shadcn_ui"}
```

See the [installation guide](docs/installation.md) for asset-pipeline and CSP
details.

## Usage

Import the public components from a shared Phoenix component module:

```elixir
defmodule MyAppWeb.CoreComponents do
  use Phoenix.Component
  use ShadcnUI
end
```

You can then use the components from HEEX:

```heex
<.card>
  <:title><h2>Account</h2></:title>
  <:description>Manage your profile and notification settings.</:description>

  <p>Your application owns the account data and update operation.</p>

  <:footer>
    <.button type="submit" form="account-form">Save changes</.button>
  </:footer>
</.card>
```

For a narrow import, import the defining component module directly:

```elixir
import ShadcnUI.Components.Foundation.Button, only: [button: 1]
```

Both import styles preserve Phoenix's compile-time component metadata.

## Stylesheet

ShadcnUI ships its compiled stylesheet at `priv/static/shadcn_ui.css`.
`ShadcnUI.stylesheet_path/0` returns its installed absolute path. Your
application owns copying, fingerprinting, caching, and serving the file.

A Phoenix endpoint can serve it directly:

```elixir
plug Plug.Static,
  at: "/vendor/shadcn-ui",
  from: Path.dirname(ShadcnUI.stylesheet_path()),
  gzip: false,
  only: ["shadcn_ui.css"]
```

Load the package stylesheet after your reset or base stylesheet and before
application-specific overrides:

```heex
<link rel="stylesheet" href="/vendor/shadcn-ui/shadcn_ui.css" />
<link rel="stylesheet" href="/assets/app.css" />
```

An existing asset pipeline may copy the file into its fingerprinted output
instead. Consumers do not need npm, Tailwind CSS, or ShadcnUI JavaScript.

## Themes and customization

Light theme values are the default. Set `data-shadcn-theme` on the document or
a smaller component ancestor:

```heex
<section data-shadcn-theme="dark">
  <.alert title="Deployment complete" description="The new release is available." />
</section>
```

Override documented tokens after the package stylesheet and in the narrowest
useful scope:

```css
.account-settings {
  --shadcn-ui-primary: #075985;
  --shadcn-ui-primary-foreground: #ffffff;
  --shadcn-ui-radius: 0.625rem;
}
```

Use `data-shadcn-motion="reduce"` to suppress optional component motion within
a subtree. The package also respects the operating system's reduced-motion
preference.

## Components

| Category | Components | Guide |
| --- | --- | --- |
| Foundation | Button, Badge, Alert, Card, Avatar, Skeleton | [Foundation](docs/guides/foundation.md) |
| Forms | Field, Label, Help, Field Errors, Error Summary, Input, Textarea, Checkbox, Radio Group, Switch, Native Select, Enhanced Select, Slider, Progress, Meter | [Forms](docs/guides/forms.md) |
| Disclosure | Accordion | [Disclosure](docs/guides/disclosure.md) |
| Navigation | Navigation Menu, Header, Section Header | [Navigation](docs/guides/navigation.md) |
| Content Surfaces | Scroll Area, Separator, Radio Panels | [Content Surfaces](docs/guides/content-surfaces.md) |
| Overlays | Dialog, Alert Dialog, Drawer, Popover, Dropdown Actions | [Overlays](docs/guides/overlays.md) |
| Interactive Surfaces | Tooltip, Hover Card | [Interactive Surfaces](docs/guides/interactive-surfaces.md) |
| Media | Carousel, Cover Flow, Image Gallery | [Media](docs/guides/media.md) |
| Motion | Marquee, Stagger, Scroll Indicator | [Motion](docs/guides/motion.md) |

The [component index](docs/components.md) lists the defining modules and public
functions. Generated API documentation is the source of truth for attributes,
slots, defaults, closed values, and accepted global attributes.

## Design and runtime boundaries

ShadcnUI renders server-owned snapshots. Native browser behavior remains
authoritative after rendering, while the consuming application owns:

- changesets, validation, error translation, and form submission;
- authorization, commands, persistence, loading, and outcomes;
- routes, destinations, current-location decisions, and navigation;
- patch boundaries, replacement, restoration, and transport integration;
- image sources, rights, privacy, alternative text, and responsive metadata.

The package deliberately does not add a JavaScript runtime, client-side state
model, router, focus manager, positioning engine, image service, or transport
adapter. Dstar and LiveView applications can render the same explicit component
snapshots without making either framework part of ShadcnUI. See the
[integration guide](docs/integrations.md).

## Compatibility and accessibility

Support is defined by documented native HTML and CSS capability bundles rather
than by browser brand, operating system, or embedded-renderer identity. When an
optional enhancement is unavailable, components retain their documented native
content and operation.

Applications must test their actual browser or embedded environment, content,
CSP, transport, zoom behavior, keyboard flow, forced colors, and assistive
technology requirements. ShadcnUI does not replace server-side parsing,
validation, authentication, or authorization.

Read the [compatibility and fallback policy](docs/compatibility.md) and the
component-specific accessibility guidance before adopting a component.

## Documentation

- [Installation, assets, themes, and CSP](docs/installation.md)
- [Component API and gallery index](docs/components.md)
- [Category guides](docs/guides/foundation.md)
- [Phoenix, Dstar, and LiveView integration](docs/integrations.md)
- [Compatibility and fallbacks](docs/compatibility.md)
- [Versioning and upgrading](docs/upgrading.md)
- [Image Gallery](docs/image-gallery.md)
- [Motion and media](docs/motion-media-guide.md)
- [Provenance and project identity](docs/provenance.md)

## Development

From a clean checkout:

```console
mix deps.get --locked
mix precommit
npm ci
npm run assets:check
mix docs --warnings-as-errors
mix hex.build
```

Node and Tailwind are package-maintainer tools used to reproduce the committed
stylesheet. They are not consumer requirements.

## License and provenance

ShadcnUI is available under the [MIT License](LICENSE). It is an independent
Phoenix adaptation informed by [unscripted/ui](https://unscripted.janci.dev/)
and is not an official shadcn/ui or unscripted/ui package.

Substantially adapted source is mapped to a pinned upstream revision in
`priv/provenance/unscripted_ui.json`. Required upstream notices are retained in
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). See the
[provenance guide](docs/provenance.md) for the review and update policy.
