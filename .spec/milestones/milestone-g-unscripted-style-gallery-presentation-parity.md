# Milestone G - Unscripted-Style Gallery Presentation Parity

## Description

Milestone G turns the complete ShadcnUI demo from a functionally complete
component catalogue into a deliberately designed public documentation site. It
adapts the presentation grammar of the pinned unscripted/ui documentation site:
a compact product header, constrained documentation grid, persistent catalogue
navigation, clear display typography, paired preview and source specimens,
capability badges, explanatory prose and browser-fallback evidence.

This milestone changes how the separate demo presents existing work. It does
not replace the package component contracts, add application state or make the
upstream documentation site a runtime or build dependency. ShadcnUI branding,
Phoenix HEEx examples and locally accepted semantics remain authoritative where
they intentionally differ from unscripted/ui.

## Intended outcomes

- The public gallery has high-fidelity visual and structural parity with one
  pinned unscripted/ui documentation revision at explicit desktop and mobile
  reference viewports in light and dark themes.
- A compact sticky header, centered documentation grid, sticky independently
  scrolling desktop sidebar and complete mobile navigation replace the current
  catalogue-like shell without changing stable component destinations.
- Gallery-only typography, prose, navigation, capability, specimen, code,
  support-table and metadata patterns form one reusable presentation system.
- Every component page leads with a concise title and value proposition, then
  pairs its rendered preview with its compile-checked HEEx source before deeper
  implementation, accessibility, fallback, ownership and provenance guidance.
- The Accordion page proves the complete target system before the remaining
  catalogue and composition pages migrate in ordered waves.
- Visual comparison joins semantic, keyboard, responsive, no-script,
  reduced-motion, forced-colors, static-export and package-boundary acceptance.

## Presentation parity scope

- Pin the reviewed unscripted/ui repository revision, documentation paths and
  reference captures rather than treating the moving public site as truth.
- Define reference widths, theme states, typography, shell dimensions, spacing,
  radii, borders, code treatment and specimen geometry with bounded tolerances.
- Preserve ShadcnUI identity and truthful package claims. The header must not
  claim that the demo ships zero JavaScript when optional demo tooling is
  present.
- Keep all fonts, icons and other presentation assets local, deterministic,
  licensed and excluded from package release contents when they are demo-only.
- Adapt substantially reused upstream documentation markup or CSS deliberately,
  recording its pinned provenance and preserving required MIT notices.
- Do not copy upstream analytics, remote runtime imports, branding, deployment
  assumptions or site-only behavior that is not part of the local goal.

## Gallery shell scope

- Replace the tall multi-row masthead with a compact sticky product header that
  exposes branding, primary documentation destinations, repository access,
  theme selection and a native mobile navigation entry point.
- Constrain the complete desktop layout to an authored maximum width with a
  fixed catalogue column, deliberate inter-column gap and min-width-safe main
  content.
- Keep the desktop catalogue sticky and independently scrollable, with compact
  category labels, muted destinations and an obvious current-page surface.
- Relocate progressive component search into the catalogue experience so it no
  longer dominates the global header.
- Move package version, full build revision, catalogue schema, upstream
  revision and publication evidence to a truthful secondary metadata surface.
- Preserve the skip link, named navigation, breadcrumb, one main landmark,
  visible focus, ordinary destinations, stable routes and complete no-script
  navigation required by existing gallery contracts.

## Documentation presentation scope

- Introduce a local display face only after license and deterministic-asset
  review, with a system fallback that preserves layout and readability.
- Give headings, descriptions, prose, inline code, lists, tables, captions and
  secondary metadata one consistent hierarchy and bounded line length.
- Add reusable capability badges whose labels and support meaning come from
  closed authored catalogue data or deterministic evidence, never visitor
  detection disguised as policy.
- Present preview and HEEx source as two honest views of one specimen. A native
  radio or disclosure contract may provide the view selection, but it must not
  claim an ARIA tab contract the demo does not implement.
- Keep source selectable and addressable without JavaScript; optional copy
  feedback remains demo-only and cannot become component behavior.
- Present browser support and exact fallback close to each example while
  retaining plain-language application ownership, accessibility and provenance.
- Retain stable component and example fragments even when visible section
  ordering and labels change.

## Component and catalogue scope

- Extend the closed documentation catalogue with concise introductions,
  capability identities, how-it-works points, support rows, exact fallbacks,
  named specimens and explicit upstream or local-exception identities.
- Keep request, fragment and search text inert. New metadata must not create
  atoms, modules, functions, templates, callbacks, asset paths or executable
  code dynamically.
- Use Accordion as the complete vertical pilot, covering independent and
  exclusive modes, progressive height animation, source presentation,
  accessibility, support and fallback evidence.
- Migrate Foundation and Disclosure, Forms, Navigation and Content Surfaces,
  Overlays and Interactive Surfaces, then Media and Motion before completing
  landing, category, composition and documentation pages.
- Compare each adapted component page to its pinned upstream counterpart when
  one exists. ShadcnUI-only components use the same presentation grammar.
- Record intentional semantic differences instead of changing package behavior
  merely to make screenshots resemble a richer or different widget contract.
- Change package-owned component CSS only when an audited difference belongs to
  the reusable component rather than the demo specimen or documentation shell.

## Architecture work required

- Accept a durable decision defining pinned presentation parity, visual
  tolerances, local asset licensing, upstream adaptation and semantic exception
  policy.
- Add current-truth gallery and documentation requirements for the shell,
  specimen system, catalogue metadata, visual evidence and migration coverage.
- Decide the exact no-script mobile navigation and Preview/Code contracts before
  styling them, including browser fallback and focus behavior.
- Decide whether deterministic syntax highlighting is authored at build time or
  server render time without introducing remote assets or package runtime code.
- Define checked reference-capture ownership, update policy and review rules so
  a later upstream change cannot silently rewrite accepted local presentation.
- Replace cosmetic-class test dependencies with stable semantic or
  `data-gallery-*` hooks before large-scale markup migration.

## Verification expectations

- Reference captures and local golden images cover the accepted viewports,
  themes and representative long, narrow, overflow and interactive states.
- Bounded visual comparison checks shell geometry, typography, navigation,
  specimen frames, code surfaces, tables and responsive reflow without remote
  network access during verification.
- Controller and browser tests cover every catalogue route, stable fragment,
  canonical identity, breadcrumb, current-page state, search result and 404.
- Keyboard, visible focus, pinned axe, 200 percent zoom, narrow width,
  forced-colors, reduced-motion and JavaScript-disabled acceptance remain green.
- Preview/source selection, copy feedback and theme persistence remain optional
  demo behavior; all authored content and ordinary destinations remain usable
  without them.
- Two exports from identical inputs remain byte-identical, local and
  repository-subpath safe, with no new package release contents.
- Provenance, font licensing, third-party notices and actual archive exclusions
  are audited before publication.
- Local, CI, merge, deployment, post-deployment and rollback evidence remain
  separate states and are reported truthfully.

## Exit criteria

Milestone G is complete when the Accordion pilot and every catalogue,
composition, landing and documentation route use the accepted presentation
system; the locked light/dark desktop/mobile visual matrix passes within its
documented tolerances; all existing package, semantics, accessibility,
no-script, deterministic-export and publication contracts remain satisfied; and
the redesigned immutable gallery is published with current provenance, smoke
and rollback evidence.

Visual resemblance alone cannot complete the milestone. Missing component
coverage, misleading semantics, unlicensed assets, stale reference captures,
package leakage or an unverified deployment remains a blocking failure.

## Existing contracts and implementation plan

Milestone G preserves the accepted package, stylesheet, theme, provenance,
gallery, catalogue, documentation, compatibility and publication decisions and
current-truth specifications from Milestones A-F. Phase 1 must author and accept
the additional presentation-parity decision and specification changes before
implementation proceeds.

- [Milestone decisions](../decisions/README.md)
- [Current-truth specifications](../specs/README.md)
- [Phased implementation plan](../planning/milestone-g-unscripted-style-gallery-presentation-parity/README.md)

## Deferred work

A new component family, a general documentation framework, consumer Tailwind
configuration, package JavaScript, remote search, live visitor capability
analytics, automatic upstream synchronization, multiple branded gallery themes,
public Hex publication and changes to intentionally different widget semantics
require separate accepted work.
