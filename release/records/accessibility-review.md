# Accessibility review record

This ledger is the bounded Milestone F accessibility review record for the
ShadcnUI package and gallery. It separates executable checks from observations
that require a human reviewer, assistive technology, or physical hardware.
Passing automation is not WCAG certification and does not complete the pending
human scenarios below.

## Automated evidence

| Field | Recorded value |
| --- | --- |
| Status | Passed |
| Date | 2026-08-27 |
| Environment | Windows 11 Pro, win32 x64, release 10.0.26200 |
| Engines | Chromium 151.0.7922.34, Firefox 153.0, WebKit 26.5 |
| Tool | axe-core 4.13.0, installed from the locked demo dependency graph |
| Scope | Representative light/dark pages, 640 px viewport, reduced motion, forced colors, failed images, native dialog closed/open states, focus entry and return |
| Rules | WCAG 2 A/AA and WCAG 2.1 A/AA axe tags |
| Result | No unresolved axe violations in the executed matrix; targeted semantic and keyboard assertions passed separately |
| Exclusions | Best-practice rules are outside this release gate. The axe color-contrast rule runs in ordinary rendering but is disabled only in forced-colors emulation because the tool reports authored colors rather than the user-agent substitutions; structural rules and explicit forced-color assertions still run there. CSS-disabled and no-script paths use explicit assertions because injecting axe would invalidate those conditions. |
| Native limitations | Axe does not prove native keyboard fidelity, reading order quality, zoom usability, platform accessibility-tree behavior, touch ergonomics, or screen-reader announcements. Those remain explicit or manual evidence. |

Reproduce the automated evidence with:

```console
npm run browser:milestone-f-phase4
```

The executable suite is
`test/browser/milestone-f-compatibility.spec.mjs`. The exact engine and lockfile
identity is recorded separately in
`demo/priv/compatibility/milestone_f_engine_evidence.json`.

## Manual review protocol

Every manual record must contain all of these fields: scenario identifier,
functional categories, reviewer, date, hardware, browser, assistive technology
or input device, reproducible steps, observations, defects, retest result, and
status. A reviewer must replace `Unassigned` and `Not run` when executing a
scenario. Screenshots may support an observation but cannot replace keyboard,
touch, or assistive-technology use.

Status values are `PENDING`, `BLOCKED`, `FAILED`, or `PASSED`. A mandatory
defect keeps the scenario `FAILED` until its recorded retest passes. An
unavailable platform or device stays `PENDING`; it is never inferred from a
different engine or automated run.

## R6 remediation risk acceptance

On 2026-09-03 the release owner explicitly accepted the risk of deferring this
manual matrix so Milestone G remediation R6 may continue through local
regression, review, and merge work. This is a scoped delivery waiver, not a
manual pass, accessibility conformance result, or WCAG certification. It does
not authorize a Fly deployment.

No human screen-reader or representative mobile-assistive-technology workflow
was executed for this waiver. Every scenario below remains `PENDING`, mandatory
candidate qualification remains blocked, and defects that only a human review
could expose remain unassessed. The machine-readable record is
`demo/priv/reference/milestone_g/remediation-r6-manual-risk-evidence.json`.

The release owner later supplied separate explicit authorization for the R6
Fly deployment. Release `rel_krm823exwop9zxw4` serves revision
`c08761f69429f88858a891584bc3962bd3109fe5` and passed automated canonical and
deployed-browser smoke. That operational result does not change any manual
scenario below, does not establish assistive-technology behavior, and does not
qualify the candidate.

The owner separately authorized the `1.0.0` gallery deployment on 2026-09-03.
Release `rel_76njzd0doog3yko3` serves revision
`8654f6a4500ce210682d7cae7453553d878a714c` and passed service health,
canonical smoke, and deployed Chromium checks. This later operational result
also leaves every manual scenario pending and makes no accessibility
conformance claim.

## 1.0.0 public release waiver

On 2026-09-04 the release owner explicitly decided not to execute any of the
six human scenarios for `1.0.0`. Their release gate is therefore `WAIVED` and
non-mandatory for this release only. Qualification and Hex publication may
proceed when every other mandatory gate passes.

Every scenario below remains `PENDING`: no human observation, defect
assessment, or passing retest is inferred. The waiver makes no WCAG
conformance, accessibility certification, physical-device, native
high-contrast, or assistive-technology support claim. Automated accessibility
and explicit browser checks remain mandatory, as does the unrelated isolated
Phoenix archive-consumer trial. A later release must record its own manual
accessibility disposition.

## Manual scenario ledger

### MAN-01 — Keyboard traversal and visible focus

- Functional categories: foundation, forms, disclosure, navigation, content surfaces
- Reviewer: Unassigned
- Date: Not run
- Hardware: Physical keyboard required; machine pending
- Browser: Native browser and version pending
- Assistive technology or device: Keyboard only
- Steps: Open representative pages in both themes; traverse forward and backward; activate buttons, links, form controls, summaries, navigation and skip links; confirm focus is never trapped, obscured, or lost.
- Observations: Not observed by a human reviewer. Automated keyboard and focus assertions passed on 2026-08-27.
- Defects: Not assessed manually
- Retest result: Not applicable
- Status: PENDING

### MAN-02 — Native overlays, dismissal, and focus return

- Functional categories: overlays, interactive surfaces
- Reviewer: Unassigned
- Date: Not run
- Hardware: Physical keyboard required; machine pending
- Browser: Native browser and version pending
- Assistive technology or device: Keyboard only, then a screen reader in MAN-06
- Steps: Open dialog, alert dialog, drawer, popover, dropdown actions, tooltip and hover-card examples; inspect initial focus, Escape behavior, cancellation, focus return, ordinary alternatives, and long content.
- Observations: Not observed by a human reviewer. Automated native interaction and fallback assertions passed on 2026-08-27.
- Defects: Not assessed manually
- Retest result: Not applicable
- Status: PENDING

### MAN-03 — Zoom, reflow, RTL, and long content

- Functional categories: all categories, with emphasis on navigation, content surfaces, overlays and media
- Reviewer: Unassigned
- Date: Not run
- Hardware: Desktop display and physical keyboard pending
- Browser: Native browser and version pending
- Assistive technology or device: Browser zoom at 200 percent; RTL preference
- Steps: Inspect representative pages at 200 percent zoom and narrow width in both themes; repeat with RTL; confirm text, controls, destinations and focus remain usable without clipped required content.
- Observations: Not observed by a human reviewer. Automated bounded-layout and RTL assertions passed on 2026-08-27.
- Defects: Not assessed manually
- Retest result: Not applicable
- Status: PENDING

### MAN-04 — Windows high contrast and reduced motion

- Functional categories: foundation, forms, overlays, motion, media
- Reviewer: Unassigned
- Date: Not run
- Hardware: Windows device and display pending
- Browser: Native Chromium- or Firefox-based browser and version pending
- Assistive technology or device: Windows Contrast Theme; operating-system reduced-motion preference
- Steps: Enable a Windows Contrast Theme and reduced motion; inspect focus, boundaries, selected/disabled states, overlay surfaces, motion alternatives and meaningful images in light and dark gallery themes.
- Observations: Not observed by a human reviewer. Browser-emulated forced-colors and reduced-motion checks passed on 2026-08-27 but are not promoted to native Windows observations.
- Defects: Not assessed manually
- Retest result: Not applicable
- Status: PENDING

### MAN-05 — Physical touch and coarse pointer

- Functional categories: navigation, forms, disclosure, overlays, interactive surfaces, media
- Reviewer: Unassigned
- Date: Not run
- Hardware: Touchscreen or mobile device pending
- Browser: Device browser and version pending
- Assistive technology or device: Physical touch and coarse pointer
- Steps: Activate representative targets without hover; scroll carousels and overflow surfaces; open and dismiss overlays; verify target spacing, accidental activation resistance, ordinary destinations and image alternatives.
- Observations: Not observed. Browser viewport simulation is not accepted as physical touch evidence.
- Defects: Not assessed manually
- Retest result: Not applicable
- Status: PENDING

### MAN-06 — Screen-reader names, relationships, order, and feedback

- Functional categories: forms, disclosure, navigation, content surfaces, overlays, media
- Reviewer: Unassigned
- Date: Not run
- Hardware: Machine and audio output pending
- Browser: Browser and version paired with the selected screen reader pending
- Assistive technology or device: NVDA or another identified desktop screen reader and version
- Steps: Navigate headings, landmarks, lists, links and form fields; inspect names, help and errors; operate disclosures and overlays; verify meaningful image alternatives, reading order, disabled explanations and feedback that the component contract actually defines.
- Observations: Not observed. DOM assertions and axe results do not substitute for screen-reader output.
- Defects: Not assessed manually
- Retest result: Not applicable
- Status: PENDING

## Qualification gate

The automated Milestone F accessibility gate currently passes. Human manual
review remains open because every `MAN-*` scenario is `PENDING`. For `1.0.0`
only, the explicit owner waiver above makes this gate non-mandatory, so it does
not block qualification. A release or publication record must not state
that manual accessibility acceptance or WCAG certification is complete.
Unexecuted platforms remain pending rather than being represented as failures
or successes.
