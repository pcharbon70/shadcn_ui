# Internal release process

Milestones A through C produce an internal `0.1.0` candidate containing
Foundation, native Forms, Disclosure, Navigation, and Content Surfaces
components. This process does not authorize or perform
publication to Hex.

## Candidate verification

From a clean checkout at the repository root:

1. Run `mix deps.get --locked` and `npm ci`.
2. Run `npm run assets:build` and `npm run assets:check`.
3. Run `mix precommit`, `mix docs`, and `mix hex.build`.
4. Run `mix run scripts/check-release-archive.exs` to inspect the actual payload
   against `package/0`'s explicit allowlist.
5. Verify the archive contains public modules, compiled CSS, README, changelog,
   provenance, notices, and Mix metadata only.

The archive must reject `.spec`, demo sources and exports, scripts, workflows,
tests, `_build`, `deps`, `doc`, `node_modules`, source maps, remote runtime
assets, credentials, and mutable user data. The checked-in lockfiles remain
repository verification inputs and are not package contents.

Gallery publication and rollback are independent of the package candidate and
are documented in `demo/DEPLOYMENT.md`.

For a Milestone C rollback, revert the reviewed Milestone C commits and rerun
the complete candidate verification. Never edit an archive or the deployed
gallery artifact in place. The package and gallery may be rolled back
independently because the demo is excluded from package contents.

## Milestone D Phase 1 acceptance record

The candidate includes the authored native overlay capability manifest and
schema as normative package data. Chromium 151.0.7922.34, Firefox 153.0, and
WebKit 26.5 are the exact Playwright 1.62.1 evidence locks, not package targets.
Acceptance runs the shared Dialog/Popover fixture in all three engines, including
CSS-disabled, no-script, disabled-feature, DOM-replacement, nested-Popover,
reduced-motion, and forced-color cases. The archive excludes Playwright,
fixtures, reports, demo helpers, and every package JavaScript runtime.

## Milestone D Phase 2 acceptance record

Dialog and Alert Dialog are public defining components backed by native modal
dialog, declarative invoker commands, explicit exits, and deterministic
relationships. Acceptance runs native focus containment, Escape, closedby
policies, light dismiss, form method dialog, nested Popover, long/RTL content,
CSS-disabled, no-script, replacement, Alert cancellation, pending, rejection,
and caller-owned action snapshots in the exact locked three-engine matrix. The
archive retains no modal runtime, consequence operation, browser harness, or
test fixture.

## Milestone D Phase 3 acceptance record

Drawer adds logical start/end/bottom presentation to native modal dialog,
bounded keyboard-accessible body scrolling, safe-area spacing, concise fixed
heading/exit/footer regions, and no gestures or scroll runtime. The three-engine
suite renders its fixture from actual HEEx and verifies RTL/orientation, all
sizes, zoom, themes, forced colors, reduced motion, focus, dismissal, native
validation and forms, nested Popover, long translated content, touch activation,
replacement, CSS-disabled/no-script behavior, disabled logical placement and
transitions, and an ordinary fallback destination. Unsupported overscroll
containment retains native scrolling; the locked Windows WebKit evidence uses
that fallback. Run `mix run scripts/render-drawer-fixture.exs --check` and
`npm run browser:milestone-d-phase3` alongside the prior overlay suites.

The release contains Drawer source, compiled CSS and pinned provenance; it
excludes fixture generation, Playwright, tests, gallery and JavaScript runtimes.
Public overlay gallery delivery remains Phase 6 work.

## Milestone D Phase 4 acceptance record

Popover and Dropdown Actions ship native nonmodal surfaces, declarative
invokers, deterministic names and keyed ordinary links/buttons. Placement and
ordered flips are optional CSS enhancements with a bounded centered fallback;
no toggle listener, focus manager, menu runtime, application command or package
JavaScript is shipped. Auto/manual behavior, native keyboard preferences,
scroll-region Tab stops, focus return, nested Popover in Dialog, all logical
edges, long text, zoom, RTL, themes, forced colors, replacement, touch, no-script,
CSS-disabled and deliberately unavailable capability paths are browser-tested.

Run `mix run scripts/render-popover-fixture.exs --check` and
`npm run browser:milestone-d-phase4` with prior overlay suites. Native form tests
submit to intercepted fixture URLs; they do not execute real application
operations. The actual archive audit requires both new defining modules and
excludes fixture generation, browser tooling and demo sources. Gallery pages
remain scheduled for Phase 6.

## Milestone D Phase 5 acceptance record

Tooltip and Hover Card provide supplemental CSS-first descriptions/previews,
not interest invokers or interactive overlays. Their text-labelled native
buttons/links, stable description IDs, escaping, protected globals and
presentation-only preview guard are verified without adding runtime dependencies.
Required instructions and complete destinations remain outside previews.

Run `mix run scripts/render-supplemental-fixture.exs --check` and
`npm run browser:milestone-d-phase5` with all prior overlay suites. Locked
Chromium, Firefox and WebKit exercise hidden accessible descriptions, keyboard
and pointer operation, native link activation/context menus, preview transitions,
replacement, scoped logical placement, no-script/touch, unsupported CSS,
themes, forced colors, reduced motion, zoom, long RTL text and clipped containers.
The archive audit requires both public modules and their shared helper while
excluding browser tooling, fixture generators, tests, demo and package JavaScript.
The optional preview may be clipped; it never becomes a required operation.
Public overlay gallery delivery and milestone acceptance remain Phase 6 work.

## Milestone C acceptance record

The candidate must include the seven Milestone C public components and their
compiled CSS/provenance mappings while excluding the gallery, browser fixtures,
static export, and demo dependencies. Acceptance requires package and demo
precommit, deterministic package and gallery assets, static-export comparison,
Milestone C Chromium coverage, ExDoc, archive allowlist inspection, provenance
and notice audits, SpecLed validation, and whitespace checks. Navigation must
remain destination-based; Radio Panels must remain native radios rather than a
tab contract; true tabs, menus, overlays, application behavior, and package
JavaScript remain absent.
