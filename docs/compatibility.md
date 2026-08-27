# Compatibility and fallback policy

ShadcnUI supports declared HTML and CSS capability bundles, not a browser brand,
operating system, Electron release, or embedded renderer. Native semantics and
complete content are the floor. Optional CSS enhancement may improve layout or
presentation only when its whole capability gate passes.

## Component bundles

| Components | Native baseline | Optional package enhancement | Exact fallback |
| --- | --- | --- | --- |
| Button, Badge, Alert, Card, Avatar, Skeleton | Native button, text, document regions, and image alternatives | Scoped tokens, variants, focus, and reduced motion | Complete text, controls, and document order |
| Field, Label, Help, Field Errors, Error Summary, Input, Textarea, Checkbox, Radio Group, Switch, Native Select, Slider, Progress, Meter | Native form controls, labels, fieldsets, constraints, reset, and submission | Layout, error presentation, `field-sizing` when supported | Same visible native controls and values |
| Enhanced Select | The same native `select` and options | `appearance: base-select` only behind its complete picker query | Classic visible native select |
| Accordion | Native `details` and `summary` | Exclusive grouping and presentation where supported | Independently operable disclosures |
| Navigation Menu, Header, Section Header | Native landmarks, headings, lists, and anchors | Responsive/sticky presentation | Ordinary document flow and destinations |
| Scroll Area, Separator, Radio Panels | Native overflow, `hr`, fieldset, and radios | Edge cues and `:has()` panel emphasis | Scrollable/readable content; every panel visible |
| Dialog, Alert Dialog, Drawer | Native `dialog`, declarative commands, and explicit exits | Bounded layout and discrete transitions | Caller-authored ordinary destination or visible task |
| Popover, Dropdown Actions | Native Popover and invoker attributes | Anchored placement and optional transitions | Bounded native surface plus ordinary fallback |
| Tooltip, Hover Card | Native trigger or destination plus supplemental text | CSS-gated supplemental presentation | Required information remains at trigger/destination |
| Carousel | Native scrolling, figures/content, and real index links | Scroll snap | Complete native list and destinations |
| Marquee, Stagger | Visible canonical ordered content | Bounded decorative motion | Static content |
| Scroll Indicator | Native scrolling and aria-hidden decoration | Scroll timeline/range/scope | Neutral track; no progress claim |
| Cover Flow | Native scroller, figures, captions, and links | View timeline/range/scope and 3D image depth | Flat native scroller |
| Image Gallery | Native figures and ordinary full-image links | Existing native Dialog lightbox | Figures and full-image destinations |

The authoritative overlay and motion/media bundle data is distributed in
`priv/compatibility/native_overlays.json` and
`priv/compatibility/motion_media.json`. The complete 41-component mapping and
reviewed platform sources are in `priv/compatibility/catalogue.json`.

## Current reproducible evidence

The manifests were reviewed on 2026-08-25 (native overlays) and 2026-08-26
(motion/media). Playwright 1.62.1 locks Chromium 151.0.7922.34 revision 1234,
Firefox 153.0 revision 1538, and WebKit 26.5 revision 2336. Those exact engines
are test evidence, not normative targets or a promise about every browser with a
similar version number. Feature parsing alone is not proof of behavior.

The refreshed 2026-08-27 local record identifies Windows 11 Pro
`10.0.26200`/x64, the exact `demo/package-lock.json` SHA-256, each Playwright
browser revision, capability observations, component outcomes, and known gaps.
It lives under `demo/priv/compatibility` because evidence is not normative
package policy.

Section-specific package, semantic, browser, fallback, forced-colors, responsive,
and reduced-motion tests record observed behavior. Manual review and deployed
gallery review are separate gates and must not be inferred from a local pass.

## Evaluate a consumer environment

1. List the components the application uses and read their native requirements,
   optional enhancements, and fallback slots or routes.
2. Compare the consumer's pinned renderer against the relevant capability
   manifest. Do not use user-agent sniffing as a substitute.
3. Exercise real behavior: keyboard, focus, form submission, navigation,
   replacement, zoom, forced colors, reduced motion, narrow/wide layouts, and
   CSS-disabled or deliberately missing-capability fixtures.
4. Verify the application's CSP, transport, patch boundaries, server validation,
   and any embedded-shell policy independently.
5. Record the renderer build, date, fixture, result, and unresolved manual work.

ShadcnUI does not certify Electron or another embedded consumer. Such an
application owns validation of its renderer, native shell, CSP, navigation,
transport, and deployment environment.

## Change control and migration

Review compatibility whenever browser locks, capability bundles, package CSS,
fallback markup, or an upstream adaptation changes. To admit a feature:

1. identify an authoritative web-platform source;
2. define the smallest component bundle and exact semantic fallback;
3. add capability-missing and exact-engine behavior tests;
4. review keyboard, focus, accessibility, responsive, forced-colors, and
   reduced-motion behavior;
5. update the manifest, docs, evidence date, and migration notes together.

Raising a native capability floor or adding a package runtime is a contract
change. It requires an accepted ADR, specification update, changelog and
migration entry, compatibility evidence, and an explicit internal version
decision. Existing fallback behavior may not disappear silently.
