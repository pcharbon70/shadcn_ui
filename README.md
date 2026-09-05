# ShadcnUI

ShadcnUI is a transport-neutral library of Phoenix function components built
with semantic HEEX, native HTML behavior, and package-owned shadcn-style CSS.
It provides 41 components without installing routes, controllers, LiveViews,
hooks, processes, or application state.

- [Live demo on Fly.io](https://pcharbon70-shadcn-ui-demo.fly.dev/)
- [Hex package](https://hex.pm/packages/shadcn_ui)
- [API documentation](https://shadcn-ui.hexdocs.pm/1.0.0/)
- [Bundled Phoenix demo](https://github.com/pcharbon70/shadcn_ui/blob/main/demo/README.md)
- [Component index](https://shadcn-ui.hexdocs.pm/1.0.0/components.html)
- [Installation guide](https://shadcn-ui.hexdocs.pm/1.0.0/installation.html)
- [Compatibility policy](https://shadcn-ui.hexdocs.pm/1.0.0/compatibility.html)

The repository includes a Phoenix demo application under `demo/` that
exercises every component category and provides the source for the online
gallery. It is a reference consumer and is not included in the Hex package
runtime.

> **Release status**
>
> Version `1.0.0` is the first public Hex release and is available from Hex with
> generated documentation on HexDocs.

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

Add ShadcnUI to your dependencies:

```elixir
defp deps do
  [
    {:shadcn_ui, "~> 1.0"}
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

See the [installation guide](https://shadcn-ui.hexdocs.pm/1.0.0/installation.html)
for asset-pipeline and CSP details.

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
| Foundation | Button, Badge, Alert, Card, Avatar, Skeleton | [Foundation](https://shadcn-ui.hexdocs.pm/1.0.0/foundation.html) |
| Forms | Field, Label, Help, Field Errors, Error Summary, Input, Textarea, Checkbox, Radio Group, Switch, Native Select, Enhanced Select, Slider, Progress, Meter | [Forms](https://shadcn-ui.hexdocs.pm/1.0.0/forms.html) |
| Disclosure | Accordion | [Disclosure](https://shadcn-ui.hexdocs.pm/1.0.0/disclosure.html) |
| Navigation | Navigation Menu, Header, Section Header | [Navigation](https://shadcn-ui.hexdocs.pm/1.0.0/navigation.html) |
| Content Surfaces | Scroll Area, Separator, Radio Panels | [Content Surfaces](https://shadcn-ui.hexdocs.pm/1.0.0/content-surfaces.html) |
| Overlays | Dialog, Alert Dialog, Drawer, Popover, Dropdown Actions | [Overlays](https://shadcn-ui.hexdocs.pm/1.0.0/overlays.html) |
| Interactive Surfaces | Tooltip, Hover Card | [Interactive Surfaces](https://shadcn-ui.hexdocs.pm/1.0.0/interactive-surfaces.html) |
| Media | Carousel, Cover Flow, Image Gallery | [Media](https://shadcn-ui.hexdocs.pm/1.0.0/media.html) |
| Motion | Marquee, Stagger, Scroll Indicator | [Motion](https://shadcn-ui.hexdocs.pm/1.0.0/motion.html) |

The [component index](https://shadcn-ui.hexdocs.pm/1.0.0/components.html) lists
the defining modules and public functions. Generated API documentation is the
source of truth for attributes, slots, defaults, closed values, and accepted
global attributes.

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
[integration guide](https://shadcn-ui.hexdocs.pm/1.0.0/integrations.html).

## Compatibility and accessibility

Support is defined by documented native HTML and CSS capability bundles rather
than by browser brand, operating system, or embedded-renderer identity. When an
optional enhancement is unavailable, components retain their documented native
content and operation.

Applications must test their actual browser or embedded environment, content,
CSP, transport, zoom behavior, keyboard flow, forced colors, and assistive
technology requirements. ShadcnUI does not replace server-side parsing,
validation, authentication, or authorization.

Read the
[compatibility and fallback policy](https://shadcn-ui.hexdocs.pm/1.0.0/compatibility.html)
and the component-specific accessibility guidance before adopting a component.

## Documentation

- [Installation, assets, themes, and CSP](https://shadcn-ui.hexdocs.pm/1.0.0/installation.html)
- [Component API and gallery index](https://shadcn-ui.hexdocs.pm/1.0.0/components.html)
- [Category guides](https://shadcn-ui.hexdocs.pm/1.0.0/foundation.html)
- [Phoenix, Dstar, and LiveView integration](https://shadcn-ui.hexdocs.pm/1.0.0/integrations.html)
- [Compatibility and fallbacks](https://shadcn-ui.hexdocs.pm/1.0.0/compatibility.html)
- [Versioning and upgrading](https://shadcn-ui.hexdocs.pm/1.0.0/upgrading.html)
- [Image Gallery](https://shadcn-ui.hexdocs.pm/1.0.0/image-gallery.html)
- [Motion and media](https://shadcn-ui.hexdocs.pm/1.0.0/motion-media-guide.html)
- [Provenance and project identity](https://shadcn-ui.hexdocs.pm/1.0.0/provenance.html)

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

ShadcnUI is available under the
[MIT License](https://shadcn-ui.hexdocs.pm/1.0.0/license.html). It is an
independent Phoenix adaptation informed by
[unscripted/ui](https://unscripted.janci.dev/) and is not an official shadcn/ui
or unscripted/ui package.

Substantially adapted source is mapped to a pinned upstream revision in
`priv/provenance/unscripted_ui.json`. Required upstream notices are retained in
[THIRD_PARTY_NOTICES.md](https://shadcn-ui.hexdocs.pm/1.0.0/third_party_notices.html).
See the [provenance guide](https://shadcn-ui.hexdocs.pm/1.0.0/provenance.html)
for the review and update policy.
