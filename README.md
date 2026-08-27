# ShadcnUI

Transport-neutral Phoenix function components using native HTML and isolated,
shadcn-style CSS. The repository is qualifying an internal `0.1.0` candidate;
it is not publicly available on Hex and Milestone F acceptance is still pending.
Milestones A through E provide Foundation, Forms, Disclosure, Navigation,
Content Surfaces, Overlays, Interactive Surfaces, Media, and Motion.

Start with the [component index](docs/components.md),
[installation guide](docs/installation.md),
[integration guide](docs/integrations.md), and
[upgrade policy](docs/upgrading.md). Dstar and LiveView are documented as
consumer-owned transports around the same stateless HEEX API; neither is a
ShadcnUI application dependency or state owner.

The [gallery](https://leco-industries-inc.github.io/shadcn_ui/) is a separate
reference consumer. Milestone D adds seven component pages, four complete
compositions, and a [capability matrix](https://leco-industries-inc.github.io/shadcn_ui/examples/overlay-capabilities).
New pages become public when their reviewed change is merged and the Pages
deployment succeeds; a local acceptance run is not proof of publication.

Milestone E [motion/media foundations](https://github.com/Leco-Industries-Inc/shadcn_ui/blob/main/docs/motion-media-foundations.md) add
internal image and bounded-motion contracts, scoped motion suppression, local
demo fixtures and `/examples/motion-media-capabilities`. The gallery supports
ordinary system/reduced-motion links, including no-script static exports.
Phase 2 adds public Carousel, its reference page at `/components/media/carousel`
and `/examples/media-browser`. Phase 3 adds Marquee and Stagger at
`/components/motion/marquee` and `/components/motion/stagger`, plus
`/examples/motion-preferences`. Phase 4 adds `/components/motion/scroll-indicator`
and `/components/media/cover-flow`, expanding both compositions with actual
components. Phase 5 adds `/components/media/image-gallery` and the substantial
`/examples/image-gallery` composition. The Phase 6 candidate consolidates all six
components, gallery navigation and acceptance. See the
[motion/media guide](https://github.com/Leco-Industries-Inc/shadcn_ui/blob/main/docs/motion-media-guide.md)
and [acceptance record](https://github.com/Leco-Industries-Inc/shadcn_ui/blob/main/docs/milestone-e-acceptance.md)
for native semantics and distinct automated, manual, CI and publication status.
Milestone F remains separate; a local candidate does not establish publication.

## Image Gallery: responsive figures and native lightboxes

```heex
<.image_gallery id="landscapes" accessible_label="Local illustrations" images={[
  %{key: "ridge", src: "/media/ridge.svg", alt: "Mountain ridges beneath a sun",
    width: 640, height: 480, caption: "Original ridge", href: "/media/ridge.svg",
    full: %{src: "/media/ridge.svg", width: 640, height: 480}}
]} />
```

Each image has its own existing native Dialog, visible Enlarge/Close controls,
and a separate ordinary destination. Choose `lightbox={:none}` for nonmodal
browsing. Full images contain, long captions scroll, and failed images retain
meaning. The optional thumbnail-origin effect is deliberately deferred after
three-engine testing; no component JavaScript or slideshow state ships.
See the [complete Image Gallery API and ownership guide](https://github.com/Leco-Industries-Inc/shadcn_ui/blob/main/docs/image-gallery.md)
for metadata, keyed caption slots, native focus/dismissal, loading hints,
replacement, explicit nested-modal restrictions and provenance.

## Scroll Indicator and Cover Flow: native scroll decoration

```heex
<.scroll_indicator id="notes" accessible_label="Reading notes" size={:small}>
  <p :for={n <- 1..12}>Complete note {n}.</p>
</.scroll_indicator>

<.cover_flow id="illustrations" accessible_label="Illustrations"
  images={[
    %{key: "ridge", src: "/media/ridge.svg", alt: "Mountain ridges", width: 640, height: 480, caption: "A ridge", href: "/media/ridge.svg"},
    %{key: "grove", src: "/media/grove.svg", alt: "Evergreen trees", width: 480, height: 640, href: "/media/grove.svg"}
  ]} />
```

Both defining modules are imported directly by `use ShadcnUI`. Require a unique
`id` and exactly one `accessible_label` / `labelledby` (existing heading IDs).
Optional `description` is escaped; `class` and unrelated `rest` globals survive.
`motion=:system|:none` respects ancestor reduction and OS preferences.

Scroll Indicator accepts trusted `inner_block` and `size=:small|:default|:large`
(12/20/32rem maximum height). Native keys, links and forms remain authoritative.
Its external aria-hidden track is decoration, never a progressbar, reading
percentage, task result or synchronized value. Missing joint timeline/range/scope
support, nonoverflowing content, motion suppression or forced colors keeps a
neutral track. No external scroll selector, timer or fallback animation exists.

Cover Flow requires nonempty `images` with unique string `key`, `src`, explicit
`alt` and positive intrinsic `width`/`height`. Optional `name`, escaped `caption`,
`href`, width-candidate `srcset` plus `sizes`, `loading=:lazy|:eager` and
`decoding=:async|:sync|:auto` follow the shared media contract. Decorative images
need `decorative: true`, empty alt and an independent name. There are no slots.
`presentation=:enhanced|:flat` defaults to eligibility for enhancement, not a
promise. Multiple images, a container at least 40rem wide, joint view/range/scope/
3D support and allowed motion are required; forced colors stays flat.
`snap=:none|:proximity|:mandatory` and `alignment=:start|:center` reuse Carousel.
Images alone gain bounded depth; captions, real destinations and fragment index
remain native, untransformed and fully available, including image failure.

Neither component has selected-image state, autoplay, observers, listeners,
polling or runtime JS. Stationary scrolling does not advance either effect.
Removing CSS retains complete content. Replacing markup may reset native
position/focus; browsers may also restore document state. Applications own
restoration, meaningful text, image rights/privacy, sources and navigation.
See the [CSS exception ledger](https://github.com/Leco-Industries-Inc/shadcn_ui/blob/main/docs/motion-media-css-exceptions.md) for exact
gates and pinned provenance. Demo capability records distinguish parsing from
actual component behavior and do not detect the visiting browser.

## Marquee and Stagger: optional bounded motion

```heex
<.marquee id="topics" accessible_label="Topics" mode={:preview} duration={:brief}
  items={[%{key: "walks", text: "Mountain walks"}, %{key: "stories", text: "Harbor stories"}]} />

<.stagger id="reading" as={:ol} effect={:rise} preset={:quick}>
  <:item key="first"><a href="/reading/first">First reading</a></:item>
  <:item key="second"><label>Local note <input name="note" /></label></:item>
</.stagger>
```

`use ShadcnUI` imports both defining Motion modules directly. Marquee defaults
to a complete static list. Preview uses an initially unchecked, unnamed native
checkbox: check for one traversal, uncheck to stop/reset, then check to replay.
Checked means enabled, not playing. Duration is `:brief` (2.5s) or `:default`
(5s); direction is `:inline_start` or `:inline_end`. Structured items require
unique keys and escaped text, and accept optional validated image metadata;
never cloned arbitrary HEEx. Its one decorative duplicate is inert, aria-hidden,
ID-free and hidden outside the finite preview, including CSS-disabled output.

Stagger requires keyed trusted `item` slots; `as` is `:div` (default), `:ul` or
`:ol`. Effect is `:none` (default), `:fade` or `:rise`. Presets are `:quick`
(150ms duration, 50ms step) and `:default` (250ms, 75ms). Total delay+duration
is capped at one second, excess items appear immediately, and focus cancels
the item's effect. Content is never opacity zero. Root and item classes and
unrelated globals survive; generated identities, semantics and timing are protected.

Both obey `motion=:none`, ancestor `data-shadcn-motion="reduce"` and OS reduced
motion. System never overrides reduction. Missing CSS retains complete native
content; no JavaScript, infinite animation or visibility observer is shipped.
Finite effects may finish offscreen; replacement can reset native controls and
replay entrance effects. Applications own persistence, patch boundaries and actions.

## Carousel: native content browsing

```heex
<.carousel id="chapters" accessible_label="Chapters" snap={:proximity}>
  <:item key="overview" label="Overview">
    <h3>Overview</h3><a href="/overview">Read the overview</a>
  </:item>
  <:item key="details" label="Details">
    <h3>Details</h3><a href="/details">Read the details</a>
  </:item>
</.carousel>
```

`use ShadcnUI` imports `ShadcnUI.Components.Media.Carousel` directly. Supply a
unique `id`, exactly one `accessible_label` or `labelledby` (caller heading IDs),
and keyed, labelled `item` slots with trusted HEEx. Optional `description` is
escaped text; root/item `class` and unrelated `rest` globals remain caller-owned.
Snap accepts `:none`, `:proximity` (default) or `:mandatory`; `alignment` accepts
`:start` (default) or `:center`. `motion=:none`, ancestor reduction or system
reduced motion disables smooth scrolling. No option forces animation.
Child focus temporarily suspends snapping so oversized content stays reachable.

The named scroller is a Tab stop. Native keys, wheel, touch, fragment links and
child controls stay browser-owned, including keyboard preferences that skip
links. Every item remains available; no slide state, autoplay, clone, fake
previous/next control, generated CSS control or runtime exists. Missing snap
keeps scrolling; CSS-disabled output is a complete ordered list. Applications
own destinations, child accessibility and restoration after replacement.

## Tooltip: optional descriptions

```heex
<.tooltip id="save-tip" text="A local copy is also retained." describedby="save-help">
  <:trigger label="Save document" type="submit" form="editor" />
</.tooltip>
<p id="save-help">Save your edits before leaving this page.</p>
```

Use one self-closing `trigger` slot: a text `label`, `kind=:button` (default)
or `kind=:link`, and the appropriate native `type`, `disabled`, `name`, `value`,
`form` or `href`, `target`, `rel`, `download`, `current` attributes. `class` and
`rest` on the trigger forward application styling and unrelated globals. The
wrapper accepts globals; component `class` and `surface_rest` style the bubble.
Identity, role, focusability and description references cannot be overridden.
`describedby` merges existing whitespace-separated IDs, removing duplicates.
The caller must supply those external elements and unique component IDs.

The `text` attribute is escaped, never HTML. Labels, required instructions,
errors, status and task information must be visible outside the Tooltip. A
disabled button remains disabled and cannot be keyboard-focused. Do not rely on
its tooltip to explain how to proceed.

Keyboard focus and fine-pointer hover reveal the bubble without delays or
transitions. No-hover/coarse-pointer users retain the complete ordinary control
and its accessible description. Without CSS the description is ordinary text;
with CSS but no anchors, it appears in normal flow. `placement` accepts
`:block_start`, `:block_end` (default), `:inline_start`, `:inline_end`; logical
anchor placement is optional and scoped per instance on wide fine-pointer
layouts. Narrow and RTL layouts retain wrapping, non-overlapping normal flow.
Scoped RTL anchor coordinates differ in the locked browser matrix, so RTL uses
this same fallback across engines without browser sniffing.

This is not a top-layer or Escape-dismissable tooltip, and clipped containers
can clip its optional visual content. Avoid placing anchored previews over
required page content; use visible Help for anything essential. No script,
interest invoker, hover-intent timer or touch long-press behavior is provided.
Light/dark tokens, reduced-motion snap behavior and forced-color borders apply.
The Interactive Surfaces gallery includes this component and its complete fallback.

## Hover Card: optional destination previews

```heex
<.hover_card id="manual-preview">
  <:trigger label="Read the complete manual" href="/manual" />
  <h3>Manual overview</h3>
  <p>A short introduction, also available at the destination.</p>
</.hover_card>
```

The self-closing trigger slot represents one ordinary caller-owned link. Its
`label`, `href`, `target`, `rel`, `download`, `current`, `class` and `rest` preserve
native navigation, external-link policy and application attributes. There is no
extra click handler, focus step, activation interception or context-menu override.
`describedby` optionally merges external references with the preview ID.
The root is a `div`, so place it in flow content, not inside a paragraph.

The primary `inner_block` is trusted HEEx restricted to presentation tags:
`p`, `div`, `span`, `strong`, `em`, `small`, `b`, `i`, `br`, `ul`, `ol`, `li`,
`h3`, `h4`, `time`, with `class`, `lang`, `dir`, `datetime` attributes. This
composition guard rejects interactive descendants, arbitrary roles, focus
attributes, inline behavior, forms, raw HTML strings, scripts and fetching media.
It is not a sanitizer for untrusted HTML. Caller text interpolated in HEEx stays
escaped. `class` styles the preview; unrelated globals belong on the wrapper or
the trigger's `rest` map, not inside preview content.

Preview content must already exist at the complete destination. No required
actions, workflow state, authorization results, private data, unique task
information or loading indicators belong in it. These semantic restrictions
remain the caller's responsibility; markup cannot determine what information is
essential. Rendering a hidden preview is not a privacy boundary. The package
does not fetch data on hover, emit analytics, keep content fresh or track state;
the application owns safe content, freshness and replacement of the whole stable
ID subtree. Replacing it does not restore prior focus or pointer state.

Fine-pointer hover and `:focus-within` reveal the card, including while the
pointer crosses into its adjacent preview. Reduced motion has no delay or
transition. CSS-disabled presentation is ordinary flow content; missing anchor
support is normal-flow presentation; missing hover/focus support loses only the
optional preview. Coarse-pointer activation follows the ordinary link. Placement,
theme, zoom and clipping boundaries match Tooltip above. No `interestfor`,
`popover="hint"`, top-layer behavior, timers, long-press emulation, focus manager,
client fetch or package JavaScript is shipped. Interactive previews require a
different component; future interest-invoker support requires a new decision.

ShadcnUI is an independently buildable Phoenix function-component package for
semantic HEEx rendered with a shadcn-style token contract and package-owned CSS.

The design is informed by [unscripted/ui](https://unscripted.janci.dev/): native
HTML elements and modern CSS provide interaction wherever the supported browser
platform can do so reliably. The package remains transport-neutral and does not
own controllers, routes, application state, domain operations, Dstar, Datastar,
Ash, or Electron capabilities.

ShadcnUI is an independent Phoenix adaptation. It is not an official shadcn/ui
or unscripted/ui project and is not endorsed by either project.

Milestones A through D establish the package boundary, stylesheet, Foundation,
native Forms, Disclosure, Navigation, Content Surfaces, and overlay catalogues, gallery,
and acceptance evidence. See
[`.spec/milestones`](./.spec/milestones/README.md) for the roadmap.

The canonical gallery is
<https://leco-industries-inc.github.io/shadcn_ui/>. It is a separate
Phoenix reference consumer and is not part of the package runtime or archive.

## Native overlay capability contract

Milestone D targets web-platform capabilities, not a browser brand, operating
system, embedded runtime, or consuming product. The authored
[`native_overlays.json`](priv/compatibility/native_overlays.json) manifest
separates the capabilities required by each component family from the exact
Chromium, Firefox, and WebKit versions used as current Playwright evidence.

ShadcnUI ships no overlay JavaScript, invoker shim, focus trap, overlay stack,
positioning engine, custom element, hook, or client state process. A caller that
supports a browser below a component's native capability floor must provide an
ordinary destination, visible content, or non-overlay operation. Missing anchor
positioning or transition support must leave the native operation in a bounded,
readable position without animation.

Review the manifest and its authoritative sources whenever browser locks,
component capability sets, fallbacks, or the interest-invoker exclusion change.
Adding a package runtime requires a new accepted ADR. Capability reports and
test helpers belong to demo or test surfaces and are never package release files.

Native open state, toggles, close behavior, modal focus, page inertness, Escape,
and focus restoration are browser-local. Rendered `open` or action values are a
snapshot, not synchronized or persistent state. If ordinary controller
navigation, a Phoenix patch, Dstar, or LiveView replaces an open subtree, the
overlay may close and browser-local focus may be lost; the consuming application
owns patch boundaries, reinvocation, server state, and restoration policy.

Milestone D supports a root Dialog-family surface or Popover, plus at most one
native Popover inside a Dialog-family surface. Nested modals, arbitrary overlay
stacks, submenus, and virtual anchors are outside the contract.

## Installation

For a complete reproducible setup, including stylesheet delivery, CSP, theme
tokens, mixed-design-system isolation, and reduced motion, read the
[installation and assets guide](docs/installation.md). Compatibility is defined
by capabilities and documented fallbacks, not browser brands; see the
[compatibility and fallback policy](docs/compatibility.md).

For sibling development, add the package as a path dependency:

```elixir
{:shadcn_ui, path: "../shadcn_ui"}
```

Internal consumers may instead pin a reviewed Git revision from the standalone
repository:

```elixir
{:shadcn_ui, git: "https://github.com/Leco-Industries-Inc/shadcn_ui.git", ref: "<commit-sha>"}
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

Import one defining module when a narrow namespace is preferable:

```elixir
import ShadcnUI.Components.Foundation.Button, only: [button: 1]
```

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

## Milestone D native overlays

### Choosing a surface

| Need | Component and native behavior | Ordinary alternative |
| --- | --- | --- |
| Temporary modal task | Dialog: browser focus containment and page inertness | Full task page or visible form |
| Consequential confirmation | Alert Dialog: named warning, cancel receives focus | Confirmation page; server still authorizes the operation |
| Edge-aligned modal details | Drawer: Dialog behavior with a scrolling body | In-flow details and filters |
| Nonmodal controls | Popover: native auto/manual disclosure, no focus trap | Visible controls |
| Short action list | Dropdown Actions: ordinary links/buttons inside auto Popover | Visible action list; **not** an ARIA menu |
| Optional short explanation | Tooltip: CSS hover/focus description | Complete label plus visible Help for required instructions |
| Optional destination preview | Hover Card: ordinary link plus noninteractive preview | Complete destination page |

True menus need a separate keyboard/focus contract and are not implemented.
Interest invokers are deliberately excluded even where detected by a browser.

### API and identity reference

`mix docs` builds the full public API reference: every defining module lists its
function, attributes, defaults, closed values, slots, and slot attributes. All
seven functions are imported by `use ShadcnUI`. The examples below and in the
gallery use these public APIs directly, not demo-specific wrappers.

All components require a unique nonblank caller `id`; use stable keys, not list
positions. Reserve its derived `-invoker`, `-surface`, `-title`, `-description`,
`-close`, `-content`, and `-initial-focus` identities as applicable. Alert Dialog
uses `-close` for cancellation and `-action` for its action region. Dropdown
Actions additionally derives identities from unique action/group/separator keys.
External `labelledby`/`describedby` references must resolve to caller elements.

| API | Closed presentation and behavior | Slots |
| --- | --- | --- |
| `dialog/1` | size small/default/large/full; alignment start/center; density compact/comfortable; dismissal none/close_request/any; initial_focus auto/content/close | trigger, title or accessible_label, description, inner_block, close, fallback |
| `alert_dialog/1` | size small/default/large; fixed close-request dismissal and cancel autofocus | trigger, title, description, optional inner_block, cancel, action, fallback |
| `drawer/1` | edge start/end/bottom; size small/default/large; Dialog dismissal/focus choices | trigger, title or accessible_label, description, header, inner_block, footer, close, fallback |
| `popover/1` | mode auto/manual; action toggle/show/hide; four logical placements | trigger, title or accessible_label or labelledby, description, inner_block, close, fallback |
| `dropdown_actions/1` | auto Popover; four logical placements; required accessible_label | trigger, keyed action, group_label, separator, fallback |
| `tooltip/1` | four logical placements; required escaped text; optional describedby | one self-closing trigger, button or link |
| `hover_card/1` | four logical placements; optional describedby | one self-closing link trigger and constrained inner_block |

Placements are `block_start`, `block_end` (default), `inline_start`, `inline_end`.
Values above are atoms, not request-derived atoms. Slot cardinality, required
content and attribute types are checked by the defining modules. Slot markup
is trusted HEEx; interpolated user strings remain escaped.

`class` styles the surface, while the documented trigger/content/close/cancel
class attributes style those regions. `rest` belongs to the root; explicit
`trigger_rest`, `dialog_rest`, `surface_rest`, `content_rest`, `close_rest`,
`cancel_rest`, and `action_rest` maps exist only where listed by that component's
API. Unrelated native, ARIA, data and application globals pass through. Required
identity, role, invoker command/target, open state, focus intent, dismissal,
labelling and component markers are protected, not override extension points.
Alert cancellation cannot be disabled. There is no caller-owned `open` state API.

Overlay CSS consumes the existing `--shadcn-ui-*` semantic tokens: background,
foreground, popover and popover-foreground, muted and muted-foreground, primary
and primary-foreground, destructive, border, input, ring and radius. Override
tokens within a light/dark scope; native open state does not depend on color.

### Capability and fallback reference

| Environment | Exact boundary |
| --- | --- |
| Missing dialog/invoker/closedby support | Use the authored visible fallback or ordinary task page; no polyfill promises the requested modal policy |
| Missing Popover/invoker support | Use visible controls or an ordinary action destination; no simulated disclosure |
| No anchors or position tries | Popover is bounded and centered; supplemental content is normal flow |
| No discrete transitions / reduced motion | State changes without transition; operation and exits remain native |
| CSS disabled | Modal/Popover hiding still follows the browser; invoke natively where supported and keep the visible ordinary alternative; supplemental text is in flow |
| No script | Components continue natively; only demo theme persistence and source-copy convenience are lost |
| No hover / coarse pointer | Complete ordinary control/link remains; optional visual preview is not a required touch action |
| Forced colors | System colors, borders and outlines preserve boundaries; no color-only meaning |
| Zoom / narrow viewport / long text | Wrapping and bounded native scrolling; supplemental previews use normal flow on narrow layouts |
| RTL | Drawer uses logical edges; supplemental content uses normal flow across engines; no browser sniffing |
| DOM replacement | Native open/focus/pointer state may be lost; caller owns stable patch boundaries and any reinvocation/restoration |

Dialog `none` disables browser close requests, not the required explicit exit;
`close_request` permits Escape; `any` also permits native light dismiss. Alert
Dialog always uses close-request. Auto Popover supports light dismiss/Escape;
manual Popover requires explicit hide/toggle. Native focus restoration depends
on the surviving invoker, browser preferences and prior focus; no package
restoration manager is added. One nested Popover inside a modal is supported,
not arbitrary stacks or nested modals. Drawer body scrolling is native and
overscroll containment is optional; no body-lock script or gesture runtime exists.

The capability matrix distinguishes feature detection from interaction tests.
Choose supported browsers by verifying the manifest's capability sets and the
application's actual tasks. Update the locked browsers, rerun all native suites,
review authoritative sources, and regenerate demo evidence with
`node scripts/record-overlay-capabilities.mjs`; use `--check` to detect drift.
The observed record is demo-only and never a runtime browser gate.

### Dialog

`dialog` renders one native, initially closed modal surface, one declarative
`show-modal` invoker, deterministic title and description relationships, and a
visible declarative close control. Supply either a `title` slot or a nonblank
`accessible_label`. The `none`, `close_request`, and `any` dismissal values map
directly to native `closedby` behavior; `close_request` is the default.

```heex
<.dialog id="account-settings" initial_focus={:content} dismissal={:close_request}>
  <:trigger>Edit account</:trigger>
  <:title>Account settings</:title>
  <:description>Update the preferences saved with this account.</:description>

  <form method="dialog">
    <label for="display-name">Display name</label>
    <input id="display-name" name="display_name" />
    <button value="preview">Preview</button>
  </form>

  <:close>Close</:close>
  <:fallback><a href="/account/settings">Open the settings page</a></:fallback>
</.dialog>
```

`initial_focus={:auto}` leaves selection to the browser. `:content` focuses a
stable content region and `:close` focuses the explicit exit using native
`autofocus`; the component never adds a focus trap or `tabindex` to `dialog`.
The browser owns Tab containment, Shift+Tab, page inertness, Escape, allowed
light dismiss, and restoration. A `form method="dialog"` keeps its native close
and return-value behavior, while application forms, event attributes, CSRF,
commands, validation, and outcomes remain caller-owned.

Open state is browser-local. Controller navigation or replacement through
Phoenix, Dstar, or LiveView can close the surface and lose browser-local focus.
Applications choose patch boundaries, whether to avoid replacement, and any
reinvocation or state restoration. Callers supporting browsers below the native
invoker capability floor should render the `fallback` slot as an ordinary
destination, visible content, or non-overlay operation.

### Popover

`popover/1` renders a nonmodal native Popover and one declarative button invoker.
Supply a stable `id` and exactly one `title` slot, `accessible_label`, or
`labelledby` pointing at existing caller headings. Optional `description`,
`close`, and ordinary-destination `fallback` slots keep meaning explicit.

```heex
<.popover id="dimensions" placement={:block_end}>
  <:trigger>Dimensions</:trigger>
  <:title>Layout dimensions</:title>
  <label for="width">Width</label><input id="width" name="width" />
  <:close>Close</:close>
  <:fallback><a href="/layout/settings">Full settings page</a></:fallback>
</.popover>
```

`mode={:auto | :manual}` defaults to auto. Auto supports native light dismiss
and Escape; manual persists until a native hide/toggle operation and should
include an explicit close. `action={:toggle | :show | :hide}` maps directly to
the invoker action; a hide-only trigger requires a separate caller invoker to
open its surface. The browser supplies implicit expanded/details relationships,
native Tab order and focus return. ShadcnUI does not stamp a stale `aria-expanded`
value, autofocus content, trap focus, or observe toggle events.

Logical `:block_start`, `:block_end`, `:inline_start`, and `:inline_end` placement
uses the native implicit invoker anchor with ordered block/inline flips when
both anchor placement and position tries are supported. Otherwise a bounded
centered top-layer surface remains operable. CSS transitions are optional;
reduced motion removes them. Long content uses native overflow. Themes and RTL
follow the caller's ancestor scope. No coordinate or viewport state is stored.

`trigger_rest`, `surface_rest`, and `close_rest` forward unrelated native and
transport globals; mode, targets, action, identity, accessible naming and
placement remain protected. Trigger and close slots are trusted noninteractive
labels. One Popover inside a Dialog-family surface is supported; arbitrary
overlay stacks and submenus are not. DOM replacement may close the surface and
lose focus. The caller owns reinvocation, forms, authorization, CSRF, outcomes,
navigation and persistence. With CSS disabled native Popover still works; with
Popover support absent use the always-visible ordinary fallback link. There is
no package JavaScript, hook, event observer or positioning engine.

### Dropdown Actions

`dropdown_actions/1` groups ordinary native links and buttons in an auto Popover.
It is **not an ARIA menu**: use Tab/Shift+Tab to move between native controls,
Enter to activate links, Enter/Space for buttons, and Escape or light dismiss to
close. Disabled buttons are skipped by native Tab navigation. Focus return is
browser-owned and can differ between engines. There is no roving tabindex,
arrow-key/Home/End handling, typeahead, submenu or command registry.

Native keyboard preferences still apply: some browsers skip links unless full
keyboard access is enabled, and may add a stop for a scrollable surface. The
tests compare against ordinary native controls rather than installing a custom
Tab sequence. Links remain natively focusable and retain ordinary activation.

```heex
<.dropdown_actions id="record-actions" accessible_label="Record actions">
  <:trigger>Actions</:trigger>
  <:group_label key="record" label="Record tools" />
  <:action key="view" kind={:link} label="View record" destination="/records/42" group="record" />
  <:action key="download" kind={:link} label="Download" destination="/records/42.csv" download="record.csv" group="record" />
  <:separator after_key="download" />
  <:action key="save" label="Save draft" type="submit" form="record-form" name="intent" value="save" />
  <:action key="delete" label="Delete record" destructive rest={%{"phx-click" => "request_delete"}} />
  <:fallback><a href="/records/42/actions">Full actions page</a></:fallback>
</.dropdown_actions>
```

Each action requires a stable `key` and escaped text `label`. Slots are
self-closing: nested content is rejected, so an action cannot contain another
link, button or input. Default kind is `:button` and default type is `"button"`.
Links use `kind={:link}` and a required `destination`; `target`, `rel`, `download`
and `current` retain native meaning. Buttons retain `type`, `disabled`, `name`,
`value`, `form`, and unrelated transport attributes in `rest`. Conflicting native
globals, duplicate keys, unknown/noncontiguous groups and invalid destinations
are rejected. Destinations support relative paths, fragments, and explicit
HTTP(S), mailto or tel URLs—not script/data URLs or protocol-relative URLs.
Consumers must still authorize destinations and operations.

Optional `group_label` entries name contiguous actions through their `group` key;
labels are rendered before the first action and related deterministically.
Optional `separator` entries render after `after_key`; they are native thematic
breaks unless `decorative` removes their meaning. No action ordering is inferred.
Destructive styling conveys no authorization, confirmation, or command result.
Inert application buttons stay inert until the caller wires their behavior; the
package never dismisses automatically after an outcome. Forms, methods, CSRF,
pending/error snapshots, persistence and replacement remain caller-owned.

Choose Navigation Menu for persistent destinations, a Button group for always-
visible actions, native select for choosing a form value, or an application
toolbar for persistent tools. Full ARIA menus and command palettes need their
own interaction contracts. Keep an ordinary fallback route for browsers without
Popover. Public gallery rollout for these components remains Phase 6.

### Drawer

`drawer/1` is a native modal Dialog presented at `edge={:start | :end | :bottom}`,
not a navigation landmark or a gesture-driven bottom sheet. Logical start/end
follow the inherited LTR/RTL direction. `size={:small | :default | :large}` bounds
the side width or bottom height; the viewport always supplies the upper bound.

```heex
<.drawer id="filters" edge={:end} initial_focus={:content}>
  <:trigger>Filter results</:trigger>
  <:title>Filters</:title>
  <:description>Choose filters before applying them.</:description>
  <form id="filters-form" action="/results" method="get">
    <label for="query">Query</label><input id="query" name="q" />
  </form>
  <:footer><button type="submit" form="filters-form">Apply filters</button></:footer>
  <:close>Close</:close>
  <:fallback><a href="/filters">Use the full filter page</a></:fallback>
</.drawer>
```

Use one `title` or a nonblank `accessible_label`, never both. Optional
`description`, `header`, and `footer` slots preserve caller content order.
`initial_focus={:auto | :content | :close}` and
`dismissal={:none | :close_request | :any}` retain the Dialog contract; default
dismissal is `:close_request`. No script traps focus or restores the invoker.
`trigger_rest`, `dialog_rest`, `content_rest`, and `close_rest` forward unrelated
native/transport globals while mandatory semantics take precedence.

The caller selects edge and responsive policy in each rendered snapshot.
Orientation changes only affect CSS bounds. Replacing an open Drawer may close
it and lose browser-local focus/scroll state; the application decides whether
to preserve the subtree or render a new closed snapshot. There are no drag,
swipe, pointer-capture, viewport-observer, or responsive-state handlers.
Logical layout is capability-gated with a bounded ordinary modal fallback;
discrete fades are optional, reduced motion snaps, and no transform is required.
Without CSS the browser still supplies modal semantics. Without native invoker
support, use the always-visible caller fallback link; an inert trigger is not a
working Drawer. No package JavaScript is required or shipped.

#### Drawer scrolling and composition

The body is one named native overflow region with `tabindex="0"`, visible
focus and a native scrollbar. Its name follows the title or accessible label;
`:content` autofocus lands there. The header/title/close and optional footer
remain outside that region in source order. This avoids sticky controls hiding
focused fields. Safe-area padding belongs to the outer surface. Keep the header
and footer concise, especially in landscape or enlarged-text layouts; put long
translated text, help and validation messages in the body. Caller CSS or very
large fixed regions can defeat those bounds.

Overscroll containment and stable scrollbar gutters are CSS enhancements. When
unsupported, the native scroll region remains usable and boundary gestures stay
browser/OS-owned. The locked Windows WebKit build does not expose overscroll
containment; tests explicitly exercise that fallback without a scroll script.

Do not wrap the Drawer in a form: its trigger and explicit exit are buttons,
and caller body forms must remain independent. A footer submit button can use
`form="stable-form-id"` to target that body form. Native validation, server
errors, CSRF, pending snapshots, submission results, and persistence are caller-
owned. `method="dialog"` merely closes with a native return value; it does not
save data. A single nested native Popover is supported, not nested modal stacks.

Prefer ordinary content in the Drawer body. Scroll Area can hold a short or
horizontal subsection, but do not add another tall vertical scroller. Accordion,
separators, Radio Panels, native inputs, Alert, Card and Button retain their own
semantics. Keep inner Header/Section Header static to avoid obscuring fields.
There is no measurement, restoration, infinite loading, custom scrollbar,
scroll listener, observer, focus script, or package result handling.

Choose Drawer for contextual filters, record details, or compact edits. Choose
Dialog for a short centered interruption; Popover for a nonmodal transient
surface. Use a dedicated route for lengthy work, a normal sidebar for persistent
navigation, and application-specific behavior for gesture-driven bottom sheets.
Drawer is not a replacement for responsive page navigation.

```heex
<.drawer id="record-42" edge={:start} initial_focus={:close}>
  <:trigger>View record</:trigger>
  <:title>Record details</:title>
  <p>Caller-rendered record data.</p>
  <:close>Close</:close>
  <:fallback><a href="/records/42">Full record page</a></:fallback>
</.drawer>

<.drawer id="edit-42" edge={:bottom} size={:large}>
  <:trigger>Edit record</:trigger>
  <:title>Edit draft</:title>
  <form id="edit-42-form" action="/records/42" method="post">
    <!-- Include the application's own CSRF field and method policy. -->
    <label for="edit-42-name">Name</label><input id="edit-42-name" name="name" />
  </form>
  <:footer><button type="submit" form="edit-42-form">Save</button></:footer>
  <:close>Cancel</:close>
  <:fallback><a href="/records/42/edit">Full edit page</a></:fallback>
</.drawer>
```

The generated browser fixture (`mix run scripts/render-drawer-fixture.exs`)
uses real package components. Its tests include no-script, CSS-disabled,
no-transition, unsupported-invoker, long-content, coarse-pointer and ordinary
destination cases. These are package fixtures; the public gallery rollout is
scheduled for Milestone D Phase 6.

### Alert Dialog

`alert_dialog` is for a consequential choice that requires a title, an explicit
consequence description, a least-destructive cancel control, and a distinct
caller-owned action region. It always renders native `role="alertdialog"`,
`closedby="closerequest"`, and native `autofocus` on cancel; light dismiss and
ambiguous initial-focus options are intentionally absent.

```heex
<.alert_dialog id="delete-account">
  <:trigger>Delete account</:trigger>
  <:title>Delete account?</:title>
  <:description>This action cannot be undone.</:description>

  <p>Export anything you need before continuing.</p>

  <:cancel>Keep account</:cancel>
  <:action>
    <form method="post" action="/account">
      <input type="hidden" name="_csrf_token" value={@csrf_token} />
      <input type="hidden" name="_method" value="delete" />
      <.button type="submit" variant={:destructive}>Delete permanently</.button>
    </form>
  </:action>
  <:fallback><a href="/account/delete">Review account deletion</a></:fallback>
</.alert_dialog>
```

The action slot preserves caller button or form types, names, values, CSRF,
disabled and pending snapshots, and transport attributes. The component never
authorizes, submits, persists, retries, announces success, or infers an outcome.
Applications own cancellation policy, validation errors, server rejection,
pending and retry state, result announcements, and replacement behavior.

Use ordinary Dialog for general modal content. A destructive Button is only
visual/action styling and does not become a confirmation surface. Browser
`confirm()` cannot provide this composable, server-rendered contract and is not
used. Application-specific multi-step or identity-verification workflows remain
outside Alert Dialog and should use their own routes and server state. Safe
delete, discard, and irreversible-action examples in tests are inert snapshots;
they perform no domain operation.

## Milestone C content surfaces

### Navigation Menu

Navigation Menu is destination navigation: a named native `nav`, one list, and
one real anchor per item. Supply a stable string key and trusted caller-owned
destination for every item. Use `label` for escaped text or the item body for
trusted HEEx such as an external-link indicator.

```heex
<.navigation_menu accessible_name="Primary navigation" layout={:wrap}>
  <:item key="overview" destination={~p"/overview"} label="Overview" current={:page} />
  <:item key="reports" destination={~p"/reports"}>Reports <.badge>12</.badge></:item>
  <:item key="docs" destination="https://docs.example.test" target="_blank" rel="noopener">
    Documentation <span aria-hidden="true">↗</span>
  </:item>
</.navigation_menu>
```

`layout` accepts `:horizontal`, `:vertical`, and `:wrap`. `current` accepts
`:none`, `:page`, `:step`, `:location`, `:date`, `:time`, and `:true`, mapping
only explicit caller state to native `aria-current`. Long labels wrap, horizontal
navigation can overflow natively, and current location retains text decoration,
weight, and native semantics in light, dark, RTL, narrow, zoomed, and forced-
color presentation. Native anchors have no disabled state, so the component
does not publish a visually disabled-but-focusable destination.

This component is not a popup menu, command bar, tab group, Radio Panels group,
or client router. Use buttons for actions, Radio Panels for form selection, and
a separately approved tab implementation for in-page tab panels. Applications
own route generation, destination and external-link safety, authorization,
visibility, current-route selection, prefetching, analytics, history, and the
navigation outcome. ShadcnUI never reads the request path or intercepts native
Tab, Enter, context-menu, download, open-in-new-tab, or browser-history behavior.

### Header and Section Header

Header arranges optional caller-owned brand, primary navigation, utilities, and
actions inside a native `header`. Header does not create a page heading, name a
navigation landmark, convert links to commands, or change form and button
behavior.

```heex
<.header width={:contained} wrap={:responsive} presentation={:sticky}>
  <:brand><a href={~p"/"}>Northwind</a></:brand>
  <:primary_navigation>
    <.navigation_menu accessible_name="Primary navigation">
      <:item key="home" destination={~p"/"} label="Home" current={:page} />
    </.navigation_menu>
  </:primary_navigation>
  <:utilities><form action={~p"/search"}>...</form></:utilities>
  <:actions><.button type="button">New report</.button></:actions>
</.header>
```

Width accepts `:full`, `:contained`, and `:narrow`; density accepts `:compact`,
`:default`, and `:comfortable`; wrapping accepts `:wrap`, `:nowrap`, and
`:responsive`; border accepts `:none`, `:bottom`, and `:all`; presentation is
`:static` or `:sticky`. Sticky layout is presentation only. Without package CSS
or sticky support, every region remains in normal document flow in the same
order.

Section Header requires a heading slot containing the caller-authored `h2`,
`h3`, or other correct heading element. Optional description and actions follow
that heading in document order. Its presentation is `:static` or `:sticky`, and
the `:none`, `:offset`, or `:accent` anchor effect provides only scroll margin
and optional `:target` decoration.

```heex
<.section_header id="billing" presentation={:sticky} anchor_effect={:accent}>
  <:heading><h2>Billing</h2></:heading>
  <:description>Manage invoices and payment methods.</:description>
  <:actions><.button type="button">Add payment method</.button></:actions>
</.section_header>
```

Multiple page and section headers require application-authored landmark and
heading structure. Applications own action outcomes, navigation, authorization,
focus, scrolling, and any overlap compensation beyond the package scroll-margin
preset. ShadcnUI does not infer heading levels, observe scroll position, or add
client behavior. Forced colors removes translucent decoration while preserving
boundaries and target indication.

### Accordion

Accordion renders one native `details` and `summary` pair for each item. Its ID
and item keys are explicit stable strings so every details, summary, content,
and optional group relationship remains deterministic across server renders.

```heex
<.accordion id="account-help" mode={:exclusive}>
  <:item key="billing" summary="Billing" open>
    <p>Billing details remain ordinary trusted HEEx content.</p>
  </:item>
  <:item key="security" summary="Security">
    <a href={~p"/security"}>Review security settings</a>
  </:item>
</.accordion>
```

`mode` accepts `:independent` and `:exclusive`. Independent mode emits no
shared `name` and preserves every caller-supplied open snapshot. Exclusive mode
uses the deterministic `<accordion-id>-group` name and, if several items are
supplied open, renders only the first open item. Browsers without exclusive
details grouping still provide independently operable native disclosure; the
package does not polyfill the feature. Capability-gated CSS may animate content,
but unsupported CSS and reduced motion retain native snap-open behavior.

Summary text is escaped and panel slots contain trusted caller HEEx. Native
summary activation, keyboard focus, find-in-page behavior, and browser-owned
open state remain authoritative. Applications own persistence across server
replacement, authorization, routing, lazy loading, analytics, validation, and
URL synchronization. Native `details` has no disabled state, so Accordion does
not publish a visually disabled-but-operable item; applications should render
honest unavailable guidance or omit unauthorized content instead.

### Separator

Use semantic mode when the boundary separates topics or regions in the document.
It renders a native `hr`. Select decorative mode only when the line is visual;
that mode renders a nonsemantic element with protected `aria-hidden="true"`.

```heex
<.separator />
<.separator orientation={:vertical} mode={:decorative} class="consumer-divider" />
```

`mode` accepts `:semantic` and `:decorative`; `orientation` accepts
`:horizontal` and `:vertical`. Orientation changes presentation but does not
decide whether the boundary has meaning. Applications own that semantic choice,
the surrounding landmarks and headings, and any responsive layout. The package
uses the scoped border token in light and dark themes, remains visible in forced
colors, and leaves ordinary document content intact without CSS.

### Scroll Area

Scroll Area wraps required content in one native overflow container. It stays
out of the tab order by default; opt into keyboard focus only with a nonblank
accessible name or an existing labelling relationship.

```heex
<.scroll_area size={:small}>
  <ul>
    <li :for={event <- @events}>{event.title}</li>
  </ul>
</.scroll_area>

<.scroll_area
  axis={:horizontal}
  edge_affordance={:both}
  focusable
  accessible_label="Recent activity"
>
  <div class="consumer-wide-content">...</div>
</.scroll_area>
```

`axis` accepts `:vertical`, `:horizontal`, and `:both`; `size` accepts
`:small`, `:default`, and `:large`; `edge_affordance` accepts `:none`,
`:start`, `:end`, and `:both`. When `focusable` is true, provide exactly one of
`accessible_label` or `labelledby`. Edge affordances are decorative CSS masks:
content remains available when masks, package CSS, or forced-color presentation
are unavailable. Applications own dimensions beyond the closed presets, scroll
position and restoration, loading and virtualization, and all scroll-driven
behavior.

### Radio Panels

Radio Panels pairs one native radio group with trusted caller-authored content.
It requires an explicit stable `id`, submission `name`, legend, selected scalar
snapshot, and keyed options with nonblank values and escaped labels.

```heex
<.radio_panels id="account-view" name="account_view" selected={@account_view}>
  <:legend>Account view</:legend>
  <:option key="profile" value="profile" label="Profile">
    <.card><:title>Profile settings</:title>...</.card>
  </:option>
  <:option key="security" value="security" label="Security">
    <.card><:title>Security settings</:title>...</.card>
  </:option>
</.radio_panels>
```

Every option renders a real radio input, label, and deterministically related
panel. Native Tab, arrow-key, Space, reset, disabled, required, and ordinary
form-submission behavior remains authoritative. `selected` describes only the
server-rendered snapshot; the application owns rerendering, persistence,
validation, and any destination or deep-link meaning.

Radio Panels is not a Tab Group, navigation surface, or client-side view model.
It emits no `tablist`, `tab`, or `tabpanel` roles, roving tabindex, custom key
handlers, focus movement, automatic activation, history integration, or package
JavaScript. Use Navigation Menu for destinations. A true tab widget requires a
separately approved runtime and complete ARIA interaction contract.

Inside browsers that support `:has()`, package CSS emphasizes the checked label
and displays its related panel compactly. Without that selector, without package
CSS, or without JavaScript, every panel remains visible and readable in source
order beside its native radio and label. Long content wraps; forced colors keeps
the checked option distinguishable without relying on color alone. Applications
must avoid invalid nested forms and own all form boundaries.

### Choosing navigation and interaction semantics

| Surface | Native meaning | Use it for | Deliberately excluded |
| --- | --- | --- | --- |
| Navigation Menu | Named `nav`, list, and anchors | Changing destination | Commands, popup menus, route inference |
| Button | Native `button` | Caller-owned commands and submission | Destinations, authorization, outcomes |
| Radio Panels | Fieldset and native radios | Selecting one submitted value with related content | Tab roles, roving focus, history |
| True tabs | Deferred composite widget | A future in-page tab interface | Not published in Milestone C |
| Menus and menubars | Deferred composite widgets | A future command or application-menu interface | Not represented by ordinary links |

Use semantics according to the operation, not visual similarity. Links change
destination, buttons invoke caller-owned actions, and Radio Panels submit a
native form choice. True tabs, popup menus, command palettes, trees, interactive
grids, overlays, and application-specific sidebars remain deferred until their
complete keyboard, focus, state, and runtime contracts are accepted.

Milestone C requires no package JavaScript. With no CSS, disclosure remains
native, navigation remains linked, headers return to normal flow, scroll content
remains in document order, separators retain their HTML meaning, and every Radio
Panels panel is visible. Unsupported optional features degrade the same way.
Reduced motion removes nonessential transitions; forced colors preserves native
controls and explicit boundaries; light and dark themes change tokens only.

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

### Checkbox

Checkbox always renders a real native checkbox. Boolean mode emits Phoenix's
same-name hidden unchecked sentinel immediately before the visible control;
multiple mode appends `[]` to the name and emits no sentinel.

```heex
<.checkbox field={@form[:enabled]} mode={:boolean}>
  <:label>Enable reports</:label>
  <:help>This preference can be changed later.</:help>
</.checkbox>

<.checkbox
  id="feature-exports"
  name="settings[features]"
  mode={:multiple}
  value="exports"
  checked={"exports" in @selected_features}
>
  <:label>Exports</:label>
</.checkbox>
```

Boolean `checked_value` and `unchecked_value` default to `"true"` and
`"false"`. The sentinel mirrors `disabled` and `form`, so a disabled checkbox
does not submit either value. Multiple-value checkboxes require unique IDs and
an explicit nonblank option value. Validation, checked-state changes, reset,
submission, persistence, and pending lifecycle remain caller-owned.

### Radio Group

Radio Group renders one native `fieldset`, one required legend slot, and real
radio inputs. Every option is a plain map with explicit stable `key`, nonblank
string `value` and `label`, and optional boolean `disabled`. Keys and values
must be unique.

```heex
<.radio_group
  field={@form[:contact_method]}
  options={[
    %{key: "email", value: "email", label: "Email"},
    %{key: "phone", value: "phone", label: "Phone", disabled: true}
  ]}
  required
>
  <:legend>Preferred contact method</:legend>
  <:help>Choose one available method.</:help>
</.radio_group>
```

The group derives one scalar selected value from the FormField unless
`selected` is explicit. `disabled` applies native fieldset disabling;
option-local disabling applies only to that radio. Arrow-key movement, Space
selection, tab-stop behavior, reset, and scalar submission remain native.
There is intentionally no readonly radio state or package-owned selection.

### Switch

Switch is the same native boolean checkbox and hidden sentinel contract with a
track-and-thumb presentation. It does not use `role="switch"`, generic elements,
a mirrored checked value, or package-owned toggle state.

```heex
<.switch field={@form[:notifications]}>
  <:label>Email notifications</:label>
  <:help>Receive operational updates.</:help>
</.switch>
```

Labels are visible by default. For a deliberately visually hidden label, set
`label_visibility={:hidden}` and provide a separate nonblank
`accessible_label`; omission fails rather than rendering an unnamed control.
In forced-colors mode the presentation falls back to the platform's visible
native checkbox. Label activation, Space toggling, focus, reset, checked values,
and submission remain native and identical to Checkbox.

### Native Select

Native Select renders one classic native `select` with escaped caller-owned
option data. Each option is a plain map with a stable `key`, scalar `value`,
nonblank string `label`, and optional boolean `disabled`. An optgroup uses a
plain map with stable `key`, nonblank `label`, a nonempty `options` list, and an
optional group `disabled` state. Nested groups and executable structures are
rejected.

```heex
<.native_select
  field={@form[:country]}
  options={[
    %{key: :prompt, value: "", label: "Choose a country", disabled: true},
    %{
      key: :north_america,
      label: "North America",
      options: [
        %{key: :ca, value: "ca", label: "Canada"},
        %{key: :us, value: "us", label: "United States"}
      ]
    }
  ]}
  required
>
  <:label>Country</:label>
  <:help>Choose the country used for your account.</:help>
</.native_select>
```

Prompts are ordinary explicit options, so the application owns prompt wording,
disabled state, initial selection, and validation policy. Single selection
submits one scalar value. `multiple` requires a list value and normalizes the
name to one `[]` suffix so the browser submits repeated values. The component
adds no combobox/listbox roles, hidden mirror, option callback, parsing, event
handler, or package-owned selection state.

### Enhanced Select

Enhanced Select is a deliberate opt-in presentation of the same one native
`select`. It accepts the same identity, FormField, option, selected-value,
multiple, disabled, help, error, and form attributes as Native Select.

```heex
<.enhanced_select field={@form[:country]} options={@country_options}>
  <:label>Country</:label>
  <:help>Uses the enhanced picker only when the browser supports it.</:help>
</.enhanced_select>
```

For a single select, the markup includes the standards-based first-child
`button` and empty `selectedcontent` structure. Every enhanced picker selector
and `appearance: base-select` declaration is contained in one complete CSS
capability query. Browsers that do not support that query ignore the optional
structure and keep the same classic visible, focusable, operable select and all
of its option text. Multiple selection intentionally retains its native list
presentation because `selectedcontent` represents only one selected option.

Use Native Select as the recommended default when a classic platform picker is
the desired presentation. Migrating between the APIs changes only the HEEX
function name; values, names, options, errors, accessibility relationships,
reset, and submitted parameters remain identical. Enhanced Select adds no
hidden mirror, custom combobox/listbox role, filtering, remote loading, event
handler, focus manager, popup state, polyfill, or JavaScript runtime.

### Slider

Slider renders one native `input type="range"` through the shared field
contract. Native minimum, maximum, step, disabled, reset, keyboard, pointer,
constraint-validation, and submission behavior remain authoritative.

```heex
<.slider field={@form[:volume]} min={0} max={100} step={5}>
  <:label>Volume</:label>
  <:value_description>Choose a level from quiet to loud.</:value_description>
  <:help>The saved value is an integer percentage.</:help>
</.slider>
```

The optional value-description slot receives a deterministic relationship to
the input, but it is a render snapshot: ShadcnUI does not synchronize its text
when the thumb moves. The package adds no drag state, numeric domain parser,
event handler, hidden mirror, or value announcement behavior.

### Progress

Progress renders native task-completion semantics. Pass a numeric `value` and
positive `max` for a determinate snapshot, or omit `value` for the native
indeterminate state. A visible label or a nonblank `accessible_label` is
required.

```heex
<.progress id="report-progress" value={3} max={10} size={:large}>
  <:label>Generating report</:label>
  <:description>3 of 10 sections are available.</:description>
</.progress>
```

The closed presentation variants are `:default` and `:destructive`; they do not
infer status or trigger behavior. ShadcnUI does not poll, estimate, announce,
submit, or emit a completion event.

### Meter

Meter renders a native scalar measurement in a known range, not task progress.
It requires a numeric `value` and accepts native `min`, `max`, `low`, `high`,
and `optimum` numbers after validating their required ordering.

```heex
<.meter id="storage-use" value={72} min={0} max={100} low={60} high={85} optimum={40}>
  <:label>Storage use</:label>
  <:description>72 percent of available storage is used.</:description>
</.meter>
```

The browser determines the native threshold zone from those values. ShadcnUI
does not measure the domain, decide thresholds, poll, announce, or own a
lifecycle.

## Milestone B form contract reference

Every field-capable control accepts either a `Phoenix.HTML.FormField` or an
explicit nonblank `id` and `name`. Explicit `id`, `name`, `value`, and `errors`
take precedence when supplied. Error visibility is selected with
`:used_input`, `:always`, or `:hidden`; FormField error tuples may be translated
by a caller-supplied one-argument function. `pending` is presentation only and
never disables, submits, validates, focuses, or prevents duplicate work.

The shared contract protects native type and identity plus required label,
legend, `aria-describedby`, and `aria-invalid` relationships from conflicting
global attributes. Applications may still pass non-conflicting native,
`aria-*`, `data-*`, `phx-*`, and `data-on-*` attributes. Ordinary browser form
submission remains the value transport; ShadcnUI creates no changeset, request,
event, hidden value mirror, or client state model.

| Component | Native/API contract | Caller-owned or deliberately excluded |
| --- | --- | --- |
| Field, Label, Help, Field Errors | One labelled control with deterministic help and repeated-error IDs | Translation, validation timing, focus, and announcements |
| Error Summary | Escaped form strings and optional ordinary fragment links | Focus, scrolling, alert role, and navigation policy |
| Input | Closed text-like types, native autocomplete and constraints, optional leading/trailing presentation | Parsing, password reveal, counters, validation, and submission lifecycle |
| Textarea | Native rows and length constraints; closed resize policy; fixed or CSS content sizing | Measurement and JavaScript auto-grow |
| Checkbox | Boolean sentinel or repeated-value mode with native checked and disabled states | Checked-state transitions and domain meaning |
| Radio Group | Stable-key options in one native fieldset and scalar submitted value | Selection state, readonly fiction, and option fetching |
| Switch | Native boolean Checkbox contract with track-and-thumb presentation | A second switch role or state model |
| Native Select | Stable options and one-level optgroups; scalar or repeated-value mode | Prompt policy, filtering, remote loading, and custom popup state |
| Enhanced Select | The same native select contract behind a complete capability query | Polyfills, hidden mirrors, filtering, and focus management |
| Slider | Native range value with `min`, `max`, `step`, reset, keyboard, pointer, and form behavior | Domain parsing, drag state, synchronized output, and announcements |
| Progress | Positive `max`; omitted `value` is indeterminate; closed size and presentation | Polling, estimation, completion events, and request lifecycle |
| Meter | Validated `min`, `max`, `low`, `high`, and `optimum` scalar measurement | Task-progress meaning, measurement, and threshold decisions |

Textarea `sizing={:content}` activates only under `@supports (field-sizing:
content)`; otherwise the same control keeps its fixed native minimum height and
resize policy. Enhanced Select activates only when both `appearance:
base-select` and `::picker(select)` are supported; otherwise the same visible,
focusable classic select, options, name, value, reset, and submission remain.
Disabling CSS leaves the underlying native controls and authored content in
document order.

Browser constraints and visual invalid state are usability aids, never a trust
boundary. Every server operation must parse, validate, authenticate where
required, authorize, and safely handle submitted values regardless of what the
browser displayed. Datastar, LiveView, controller, Ash, or other consumers own
that policy outside this package.

Semantic presentation uses the documented `--shadcn-ui-*` token family for
background, foreground, card, popover, primary, secondary, muted, accent,
destructive, border, input, ring, radii, and motion. Override tokens in a
narrow theme scope; do not infer permissions, validity, completion, or domain
status from their colors.

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

From the repository root, install exactly the locked JavaScript dependencies
and verify the committed stylesheet with `npm ci`, `npm run assets:build`, and
`npm run assets:check`. Run `mix precommit`, `mix docs`, and
`mix hex.build` with locked Mix dependencies before accepting an internal
candidate. `mix hex.publish` is intentionally outside the Milestone A workflow.

The gallery is maintained independently under `demo`. From that directory,
run `mix deps.get --locked`, `npm ci`, `npm run assets:build`, `mix test`, and
`mix gallery.export`. `npm run export:check` audits the export and
`npm run smoke -- <base-url>` checks a deployed artifact. See the
[deployment runbook](https://github.com/Leco-Industries-Inc/shadcn_ui/blob/main/demo/DEPLOYMENT.md)
for the approved GitHub Pages environment, retention, exact-artifact deployment,
and rollback procedure.
