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

The canonical gallery is
<https://leco-industries-inc.github.io/leco_apps/shadcn-ui/>. It is a separate
Phoenix reference consumer and is not part of the package runtime or archive.

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

For example, an application can copy that returned file into its own static
asset directory during its existing asset build and reference the resulting
local URL from its root layout. Consumers do not need Tailwind, Node, or
component JavaScript at runtime or build time; the package's maintainers use
Node only to reproduce the committed CSS artifact.

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

```css
.account-preview {
  --shadcn-ui-primary: #075985;
  --shadcn-ui-primary-foreground: #ffffff;
}
```

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

### Badge

Badge renders one passive `span` with `default`, `secondary`, `destructive`, and
`outline` variants. Its required text is the accessible status information, so
the component never relies on color alone.

```heex
<.badge variant={:secondary}>Pending review</.badge>
```

Badge deliberately rejects link, button, focus, and activation attributes. Use
application-owned link or button markup when the content navigates, selects,
dismisses, or performs an action.

### Alert

Alert renders visible feedback with optional icon and actions regions, visible
title and/or description text, and `default` or `destructive` presentation.
Announcement behavior is selected independently with `:none`, `:polite`, or
`:assertive`; destructive color never implies announcement urgency.

```heex
<.alert announcement={:polite} title="Draft saved">
  <:icon><.check_icon aria-hidden="true" /></:icon>
  <:actions><.button variant={:outline}>View draft</.button></:actions>
</.alert>
```

The application owns when the alert is inserted, its lifecycle, dismissal,
retry behavior, action handling, and command outcomes.

### Card

Card renders one neutral bordered surface with required primary content and
optional `header`, `title`, `description`, `actions`, and `footer` slots. Slot
content retains the caller's native headings, links, forms, and controls.

```heex
<.card>
  <:title><h3>Notifications</h3></:title>
  <:description>Choose what you want to hear about.</:description>
  <form id="notifications">...</form>
  <:footer><.button type="submit" form="notifications">Save</.button></:footer>
</.card>
```

Card does not infer a destination, click behavior, selection, loading state,
record model, or workflow role. Applications own data, navigation, submission,
commands, and outcomes.

### Avatar

Avatar keeps required initials in the DOM and may layer one caller-owned image
as an enhancement. Image source and nonblank alternative text must be supplied
together. Closed sizes and stack positions keep overlap bounded.

```heex
<.avatar initials="PC" image_src="/people/pascal.jpg" image_alt="Pascal Charbonneau" />
```

The application owns image URLs, privacy, loading and failure policy, caching,
uploads, and identity records. Avatar uses no inline failure handler, provider,
or package-owned image state.

### Skeleton

Skeleton renders a decorative `aria-hidden="true"` rectangle, circle, or text
shape with bounded size guidance. Pulse is a presentation snapshot and becomes
a static block when reduced motion is requested.

```heex
<section aria-busy="true" aria-label="Loading profile">
  <.skeleton shape={:circle} size={:large} />
  <.skeleton shape={:text} />
</section>
```

The caller labels meaningful loading regions and owns loading detection,
announcements, errors, replacement timing, and final content layout.

### Form field composition

Milestone B form primitives share one deterministic relationship contract.
`field` accepts either a `Phoenix.HTML.FormField` or explicit identity, value,
and error data. The caller owns the native control through the required control
slot and receives the normalized attributes through `:let`.

```heex
<.field field={@form[:email]} error_mode={:used_input} required>
  <:label>Email address</:label>
  <:control :let={field}>
    <input
      id={field.id}
      name={field.name}
      value={field.value}
      required={field.required}
      aria-describedby={field.aria_describedby}
      aria-invalid={field.aria_invalid}
    />
  </:control>
  <:help>Use the address associated with your account.</:help>
</.field>
```

`label`, `help`, and `field_errors` are also available as explicit fragments.
`error_summary` accepts form-level strings and `{control_id, message}` entries;
linked entries use ordinary fragments. It does not announce, focus, scroll, or
navigate by itself. Applications continue to own translation, validation,
submission, persistence, authorization, and request lifecycle.

### Input

Input composes the shared field relationships around one native `input`. Its
closed types are `text`, `email`, `password`, `search`, `tel`, `url`, `number`,
`date`, `datetime-local`, `month`, `week`, and `time`. Native constraints,
autofill, focus, keyboard entry, and ordinary form submission remain browser
behavior.

```heex
<.input
  field={@form[:email]}
  type="email"
  autocomplete="email"
  required
  error_mode={:used_input}
>
  <:label>Email address</:label>
  <:leading><span aria-hidden="true">@</span></:leading>
  <:help>Use the address associated with your account.</:help>
</.input>
```

`pending` changes only presentation and never disables the input, changes its
value, validates, submits, or prevents duplicate requests. Leading and trailing
slots are presentational regions and do not replace the native value or label.

### Textarea

Textarea composes the same field relationships around a native `textarea` and
renders the normalized value as escaped element content. Resize policy is a
closed choice of `:vertical`, `:horizontal`, `:both`, or `:fixed`.

```heex
<.textarea
  field={@form[:biography]}
  rows={5}
  maxlength={1_000}
  resize={:vertical}
  sizing={:content}
>
  <:label>Biography</:label>
  <:help>Briefly describe your role.</:help>
</.textarea>
```

The default `sizing={:fixed}` uses the native box and resize behavior with a
usable minimum height. `sizing={:content}` opts into `field-sizing: content`
only in browsers that support it; the same fixed-size fallback remains
otherwise. ShadcnUI provides no auto-grow script or measurement state. Any
dynamic sizing policy beyond that CSS enhancement belongs to the application.

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

## Maintainer workflows

From `packages/shadcn_ui`, install exactly the locked JavaScript dependencies
and verify the committed stylesheet with `npm ci`, `npm run assets:build`, and
`npm run assets:check`. Run `mix precommit`, `mix docs`, and
`mix hex.build` with locked Mix dependencies before accepting an internal
candidate. `mix hex.publish` is intentionally outside the Milestone A workflow.

The gallery is maintained independently under `demo`. From that directory,
run `mix deps.get --locked`, `npm ci`, `npm run assets:build`, `mix test`, and
`mix gallery.export`. `npm run export:check` audits the export and
`npm run smoke -- <base-url>` checks a deployed artifact. See the
[deployment runbook](https://github.com/Leco-Industries-Inc/leco_apps/blob/main/packages/shadcn_ui/demo/DEPLOYMENT.md)
for the approved GitHub Pages environment, retention, exact-artifact deployment,
and rollback procedure.
