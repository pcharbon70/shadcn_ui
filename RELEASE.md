# Internal release process

## Milestone F Phase 6 status

Version `1.0.0` is the first public Hex release target and establishes the
initial stable API. Selecting the version does not reuse or upgrade the earlier
`0.1.0` candidate evidence: the `1.0.0` archive, isolated consumer, exact-source
reproducibility, review, final-revision CI, merge, matching Fly gallery identity,
Hex publication, and public tag must be recorded independently. Manual
accessibility remains pending under the existing bounded waiver and is not a
conformance claim. Hex publication remains pending until the mandatory release
gates pass.

All 38 Milestone F requirements have an implementation/evidence entry in
`release/records/milestone-f-acceptance.md`. The deployed Fly release and
historical records below describe the earlier `0.1.0` package identity and do
not qualify or publish `1.0.0`.

## Historical Milestone F Phase 5 candidate status

The Phase 5 record proved its then-current committed-input build and archive
consumer. Its 62-entry archive and now-unretrievable source revision do not
qualify the current 63-entry archive. Current machine-readable status lives in
`release/candidate-status.json`; the readable interpretation is
`release/records/release-candidate.md`.

The candidate remains **blocked**, not qualified. Historical passing evidence
is retained below, but the current blockers in the Phase 6 status above take
precedence. No Hex publication, public tag, marketplace listing, platform
certification, or official upstream affiliation is authorized or implied.

## Milestone F Phase 3 documentation candidate

The repository describes an internal `0.1.0` candidate. This historical phase
made the component, installation, compatibility, controller, Dstar, LiveView,
migration, rollback, and provenance contracts reviewable; it does not prove the
later CI, deployment, manual-review, public-tag, or Hex publication gates.
See `docs/integrations.md`, `docs/upgrading.md`, and `docs/provenance.md`.
At that execution point, Phase 4, Phase 5 integration, and Milestone F Phase 6
remained pending; the current Phase 6 status above supersedes that snapshot.

## Milestone E Phase 6 candidate

Phase 6 consolidates all six Media/Motion APIs and ExDoc groups, complete gallery
references, bounded-work fixtures and release audits. See
`docs/motion-media-guide.md` and `release/records/milestone-e-acceptance.md` for current
evidence and outstanding manual, CI, and current-candidate checks. The SpecLed
runner problem recorded during E was repaired in Milestone G.
Historical phase results below do not substitute for final candidate gates.
Milestone F remains separate. No Hex publication is authorized.

## Earlier candidate records and common release procedure

The remaining Pages and phase-local gate statements below are dated execution
records. The accepted Fly.io decision and the current Phase 6 status above
supersede their hosting and current-blocker language without rewriting history.

Milestones A through D produce an internal `0.1.0` candidate containing
Foundation, native Forms, Disclosure, Navigation, Content Surfaces, Overlays,
and Interactive Surfaces
components. This process does not authorize or perform
publication to Hex.

## Candidate verification

Milestone E Phase 5 adds Media.ImageGallery, the reference at
`/components/media/image-gallery` and substantial `/examples/image-gallery`.
Run `mix run scripts/render-image-gallery-fixture.exs --check`,
`node scripts/record-gallery-origin.mjs --check` and
`npm run browser:milestone-e-phase5`. The archive requires ImageGallery and
excludes its probe, observations, fixtures and demo; the expected payload is
61 allowlisted entries. Full images use existing native Dialog, explicit close
and ordinary destinations. Optional origin CSS is deferred after the actual
three-engine probe; no new authored CSS exception or runtime is distributed.
Phase 6 milestone acceptance remains pending. See the Phase 5 execution record
for direct checks and outstanding environment/manual/deployment limitations.

Milestone E Phase 4 adds Motion.ScrollIndicator and Media.CoverFlow, their real
gallery references, source-local timelines and neutral/flat fallbacks. Run
`mix run scripts/render-scroll-media-fixture.exs --check` and
`npm run browser:milestone-e-phase4` alongside earlier regressions. The actual
archive audit requires both sources and verifies 60 allowlisted entries;
demo observations, images, tests and tooling remain excluded.

Phase 4 direct evidence: package precommit 356 tests, demo precommit 56,
48 new browser checks and 337 earlier browser regressions; deterministic export
and subpath smoke cover 614 variants, three code/style assets and three local
media fixtures. ExDoc, fixture reproduction, CSS/provenance and archive checks
pass. SpecLed still reports four existing nested-login-shell command failures
and 143 warnings; direct equivalents pass using PowerShell's Elixir 1.20.3.
No gate is disabled and no manual screen-reader or deployment claim is made.
See the Phase 4 execution record for exact matrix, commands and limitations.

Milestone E Phase 3 adds Motion.Marquee and Motion.Stagger to the same candidate.
Run `mix run scripts/render-motion-fixture.exs --check` and
`npm run browser:milestone-e-phase3` as well as earlier E and gallery regressions.
The audit requires both defining modules in the actual archive, with the same
exclusion of demo images, scripts, fixtures, observations and test harnesses.
No package JavaScript, autoplay, infinite animation or visibility observer ships.

The Phase 3 execution record distinguishes direct passing checks from the four
existing SpecLed nested-login-shell failures (Elixir 1.18.0 against the current
OTP installation). CI gates remain enabled. No manual assistive-technology
certification, successful Pages deployment or Hex publication is claimed here.

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

For a milestone rollback, revert the reviewed milestone commits and rerun
the complete candidate verification. Never edit an archive or the deployed
gallery artifact in place. The package and gallery may be rolled back
independently because the demo is excluded from package contents.

## Milestone D acceptance history

The following phase records describe their original scope. Phase 6 supersedes
their historical statements that public overlay gallery delivery is pending.

## Milestone D Phase 6 candidate evidence

The public catalogue now contains all seven native/supplemental components,
their complete visible alternatives, a capability matrix, and four realistic
local-only compositions. Settings confirmation uses native validation and
method-dialog forms; rejection/pending examples are authored snapshots, not
real requests. The exact observed feature record is dated 2026-08-26 and remains
outside package contents. The normative manifest remains the capability policy.

Section 6.3 verification rebuilt ExDoc, deterministic package/gallery CSS and
static export, checked all seven provenance mappings plus shared helpers and
the full MIT notice, and audited the actual 51-entry release payload. No upstream
revision changed, no upstream site assets were imported, and no runtime
JavaScript or client-specific target was introduced. Final integration results
are recorded in the Phase 6 plan with any environment limitations.

Final direct acceptance passed 320 package tests, 40 demo tests and 177 locked
Milestone D browser checks, including demo-only axe-core audits. Integration
corrected dark destructive contrast and narrow Drawer header wrapping. Static
subpath smoke verifies 208 HTML variants and exactly three selected assets;
stale Windows build assets no longer enter the export. SpecLed's local nested
runner still fails on its existing OTP/rebar mismatch; CI remains a required
gate, and this record does not claim an unconditional release approval.

Run `node scripts/record-overlay-capabilities.mjs --check` and
`npm run browser:milestone-d-gallery` in addition to phases 1 through 5. The live
suite tests the actual controller pages; static export and deployment smoke are
separate gates. Merge and successful GitHub Pages deployment are still required
to publish this candidate. No Hex publication is authorized by these checks.

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

## Milestone E Phase 1 acceptance record

This candidate adds internal media/motion contracts, normative capability data,
scoped suppression, original demo fixtures and the actual capability reference.
It does not export the six planned public components. The
[phase execution record](https://github.com/pcharbon70/shadcn_ui/blob/main/.spec/planning/milestone-e-motion-media-and-advanced-css/phase-01-capability-media-and-motion-foundations.md#execution-record)
contains the full commands, observations and outstanding checks.

Local verification on 2026-08-26 passed package precommit (330 tests), demo
precommit (47), Phase 1 three-engine browser coverage (60), affected A–D gallery
regressions (55), deterministic assets/export, subpath smoke, ExDoc and actual
Hex archive inspection (55 entries). Playwright 1.62.1 locks Chromium
151.0.7922.34/revision 1234, Firefox 153.0/revision 1538 and WebKit 26.5/revision
2336; those are observations, not package targets. The static artifact contains
524 route variants, three style/script assets and three selected media assets.
The Hex archive excludes demo media, observations and browser infrastructure.

SpecLed full checks still fail four nested commands because their login shell
selects Elixir 1.18 compiled for OTP 26 while direct PowerShell uses Elixir 1.20.3
with OTP 29. Direct equivalent checks pass; the gate remains outstanding.
SpecLed's broad shared-file reconciliation advice is not proof that all future
component requirements are implemented. Windows denied symlink creation in the
negative fixture test; Linux CI is required to execute that assertion. Neither
CI success, manual screen-reader acceptance, publication nor deployment is
claimed. No machine-wide toolchain settings or verification gates were changed.

## Milestone E Phase 2 acceptance record

Carousel is now a public defining component: a named native scroller, complete
ordered content and real item links, with no generated controls or runtime.
Its Media reference and media-browser composition ship with local fixtures.
Child focus takes precedence over snap, including oversized cards at zoom.
The gallery grid also retains narrow-page bounds.

Local checks on 2026-08-26 passed 337 package tests, 50 demo tests, 39 Carousel
browser cases, 60 foundation cases on final rerun and 55 A–D gallery regressions.
Playwright 1.62.1 uses Chromium 151.0.7922.34, Firefox 153.0 and WebKit 26.5.
Two initial Firefox foundation probe failures passed isolated and complete
reruns without changing their evidence; the phase record retains this observation.
Assets, generated fixture, deterministic 554-route export, subpath smoke, ExDoc
and the actual 56-entry archive audit pass. Demo media and browser tools remain
excluded from the package.

SpecLed still has four known nested-command toolchain failures (153 warnings);
direct checks pass. Windows symlink assertions require Linux CI. No publication,
manual assistive-technology acceptance or physical touch-swipe result is claimed.
See the [Phase 2 execution record](https://github.com/pcharbon70/shadcn_ui/blob/main/.spec/planning/milestone-e-motion-media-and-advanced-css/phase-02-native-carousel-and-reference-page.md#execution-record).
