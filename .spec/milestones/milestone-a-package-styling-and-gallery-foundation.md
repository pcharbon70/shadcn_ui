# Milestone A - Package, Styling, and Gallery Foundation

## Description

Milestone A establishes ShadcnUI as a real, independently buildable Phoenix
component package. It defines the transport-neutral HEEx contract, converts the
shadcn semantic token model into an isolated distributable stylesheet, proves a
small foundation component set, and launches the first controller-rendered
gallery shell. All later milestones depend on these boundaries.

## Intended outcomes

- A Phoenix consumer can add ShadcnUI as a Mix dependency and import its public
  components without configuring LiveView routes or a client framework.
- A package-local Tailwind CSS v4 build produces a deterministic
  `priv/static/shadcn_ui.css` artifact.
- Prefixed utilities, prefixed internal variables, and a bounded foundation
  layer permit ShadcnUI and BulmaUI to coexist without a global Tailwind reset.
- Light and dark themes use documented shadcn-style semantic tokens rather than
  component-specific hard-coded colors.
- The package records its unscripted/ui source revision, adaptation policy, and
  required MIT notice.
- A Phoenix demo application exposes a stable online gallery shell and one page
  per implemented component.

## Foundation component scope

- Button with a closed variant, size, type, disabled, and loading-presentation
  contract plus caller-owned leading and trailing content.
- Badge as a non-interactive label with closed visual variants.
- Alert with native alert or caller-selected non-live semantics, visible title,
  description, icon, and actions composition.
- Card with header, content, and footer composition but no application workflow.
- Avatar with initials-first fallback and caller-owned image content.
- Skeleton with reduced-motion-safe loading presentation and no implied loading
  lifecycle.

## Architecture work required

- Decide whether the public module hierarchy follows functional categories or
  one module per component, and define the `use ShadcnUI` import surface.
- Specify global attribute forwarding, caller class merging, protected semantic
  attributes, escaping, slots, closed variants, and deterministic IDs.
- Decide the exact Tailwind prefix, CSS layer order, token naming, source scan,
  build command, and generated-asset verification policy.
- Define whether theme selection is class-driven, attribute-driven, or supports
  both, including how it coexists with BulmaUI themes.
- Define provenance metadata and the process for reviewing later upstream
  changes rather than copying a moving website implicitly.

## Gallery scope

- Create a separate Phoenix demo application under the package.
- Use controller-rendered HEEx; do not require LiveView routes, sockets, hooks,
  Dstar, or Datastar to browse component documentation.
- Establish a responsive shell with categorized left navigation, a mobile
  navigation alternative, component titles, descriptions, previews, and HEEX
  usage examples.
- Add light and dark theme controls and persist them only within the demo's
  clearly separated behavior boundary.
- Establish an online deployment target, automated asset build, health check,
  and stable component URLs.
- Display the package version, upstream revision, browser assumptions, and
  progressive-enhancement policy.

## Verification expectations

- Component rendering tests cover semantics, escaping, closed variants, slots,
  class merging, and supported global attributes.
- Stylesheet tests prove the artifact is packaged, deterministic, prefixed, and
  free of an unrestricted Tailwind Preflight reset.
- Boundary tests prove no application framework, server transport, or Electron
  capability enters the runtime package.
- Browser tests cover keyboard focus, light/dark presentation, reduced motion,
  responsive navigation, and direct component URLs.
- Deployment smoke tests load the online gallery and its compiled assets.

## Exit criteria

Milestone A is complete when the six foundation components are public and
documented, a consumer can use the packaged stylesheet without running Tailwind,
package and browser checks pass, and the online gallery reliably presents every
Milestone A component in light and dark themes.

## Deferred work

Forms, composite navigation, overlays, advanced motion, application-specific
screens, theme marketplaces, a source-copy registry, and a general JavaScript
runtime remain outside Milestone A.
