# Milestone E candidate acceptance

Review date: 2026-08-26. This record separates implementation evidence from
manual accessibility review, CI and actual deployment. No Hex release is made.

## Section 6.1 — catalogue

All six references and three complete media/motion compositions are implemented.
Composition navigation now has current-page state and breadcrumbs. Twenty demo
tests pass for the A–E route audit, compiled references and E compositions.
Capability and origin recorders reproduce all three exact engine observations.
Two exports are byte-identical. No runtime or fixture image was added.

## Section 6.2 — documentation and provenance

Public Media/Motion groups and their guide are included in ExDoc. The defining
functions retain Phoenix attr/slot metadata; all six imports are exercised by
the guide's compiled example. The pinned provenance mappings, complete MIT
notice and CSS ledger remain unchanged. Demo SVG licenses/hashes remain in the
closed fixture manifest, excluded from the release alongside every observation,
test, script and generated export. No CSS exception is introduced here.

## Section 6.3 — measured work and accessibility

Playwright 1.62.1: Chromium 151.0.7922.34/revision 1234, Firefox 153.0/revision
1538, WebKit 26.5/revision 2336. All nine fixed-budget cases reproduce identical
measurements below. Every sample renders all six components using actual HEEx
and the 53,457-byte compiled CSS, with no component scripts. Each referenced
SVG response is checked against the closed manifest's bytes and SHA-256.

| Items per component | DOM elements | Images | Dialogs | Clone tracks/items | Unique media requests/bytes | Stagger max |
| --- | ---: | ---: | ---: | --- | --- | --- |
| 1 | 72 | 5 | 1 | 1 / 1 | 1 / 413 | 250ms |
| 8 | 338 | 40 | 8 | 1 / 8 | 3 / 1,290 | 775ms |
| 24 | 946 | 120 | 24 | 1 / 24 | 3 / 1,290 | 1,000ms |

DOM includes the fixture document, inline stylesheet and six component outputs.
Images include canonical/clone, thumbnail/full and Cover Flow; reuse means only
three unique image resources, not three image elements. Eager loading makes this
a deterministic measurement, not a lazy loading or fetch-on-open promise.
Marquee stops within its 5,000ms animation window, even offscreen; its one clone
is inert, aria-hidden, ID/control-free and hidden when finished. At 24 items only
11 Stagger entries animate; excess entries stay immediate. These are bounded
work checks, not universal frame-rate or renderer wall-clock guarantees.

`demo/priv/compatibility/motion_media_budget_evidence.json` records reproducible
observations; the browser test also attaches each measured sample. This record
and generated fixtures are excluded from the archive. Actual timeline behavior
remains enhanced/neutral or flat according to the separate Phase 4 record;
the optional origin effect and generated controls remain deferred.

Existing E suites cover actual and disabled capabilities, axe 4.13.0 and native
keys/focus, themes, narrow/wide layout, CSS 200% zoom, RTL, forced colors,
dynamic suppression, emulated touch activation, image failure, independent
instances, replacement and no-script static subpaths. Final rerun results are
recorded in Section 6.4; axe is not a screen-reader certification. Section 6.3
reran Phases 1–5 successfully: 60 + 39 + 45 + 48 + 33 = 225 browser cases,
plus nine measured-budget cases. The checked-in budget record passed a second
complete three-engine comparison.

### Bounded manual review record — pending, not performed

An operator must record reviewer, date, OS, exact browser/AT version and result
for each item; an automated accessibility tree or synthesized key event is not
manual evidence. No screen reader or physical-device operator was used here.

| Manual session | Procedure | Status |
| --- | --- | --- |
| NVDA + Chromium and Firefox | Browse all six reference headings/lists; announce meaningful alt/captions once; verify clone is absent, native index keys and scroll escape | Pending |
| NVDA + Chromium and Firefox | Open Image Gallery from keyboard; announce name/description, inert background; explicit close/Escape restore invoker; failure destination remains understandable | Pending |
| Keyboard only, all target platforms | Enable/stop/replay Marquee; focus Stagger content; native scroll regions and links at browser-UI 200% zoom, narrow layout, both themes and OS reduction | Pending |
| VoiceOver + Safari / physical touch | Repeat gallery names/exits and content order; verify actual swipe scrolling and tap targets without a gesture controller | Pending |

Manual findings must be triaged before making an accessibility certification or
broader release claim. Milestone F remains separate, not implied by this candidate.

## Section 6.4 — final integration

Final candidate commands and outcomes will be recorded after execution.

## Manual / CI / publication status

- Manual screen-reader, physical touch and browser-UI 200% zoom: not performed.
- CI: must pass on the reviewed PR; local commands do not establish CI status.
- Local SpecLed nested-login-shell toolchain failure remains a known open gate;
  direct commands and SpecLed results are recorded separately.
- Windows symlink rejection proof needs Linux CI privileges.
- Pages: not deployed or verified by this phase. Merge and successful reviewed
  deployment plus HTTPS smoke remain required. No Hex publication is authorized.
