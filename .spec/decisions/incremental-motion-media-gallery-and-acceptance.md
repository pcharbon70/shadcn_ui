---
id: shadcn_ui.motion_media_gallery_delivery
status: accepted
date: 2026-08-26
affects:
  - shadcn_ui.motion_media_gallery
---

# Deliver Each Motion And Media Component With Its Real Gallery Page

## Context

Waiting until the final phase to expose components makes native interaction and fallback failures harder to inspect. Milestone E adds image fixtures to an exporter that currently selects exactly three CSS/JavaScript assets.

## Decision

Each component phase adds its actual HEEx reference page, source, ownership explanation, fallback and route/export/smoke tests. Append Media and Motion categories to the existing closed catalogue; do not rename earlier routes. Media contains carousel, cover-flow, image-gallery; Motion contains marquee, stagger, scroll-indicator. The canonical substantial gallery composition is /examples/image-gallery; its component reference is /components/media/image-gallery.

The final phase consolidates /examples/motion-media-capabilities, /examples/media-browser and /examples/motion-preferences plus the image-gallery composition. It checks the complete Milestone A–E catalogue, not just new pages. Capability reporting is demo-only and distinguishes declarations, observed behavior, deferred effects and native fallback.

A closed motion query offers system (default) or reduce. Reduce disables effects through a documented caller suppression scope. System retains the browser's actual preference; there is no force-animation choice overriding reduced motion. Use ordinary links/GET routes and deterministic export variants, not component-runtime scripting. Invalid query values default safely and never select modules, assets or CSS code.

Extend export's explicit inventory to exactly the three current code/style assets plus the closed selected media fixture manifest. Audit every reference, hash, path, MIME type and asset count from that manifest; never export a directory scan of stale files. Emit canonical URLs/sitemap entries only for canonical unthemed, unmodified routes. Verify both live Phoenix pages and the actual static subpath artifact without network media dependencies.

Every phase ends with integration tests, includes package/demo checks in proportion to changes, updates provenance and public API docs, and commits one section at a time. One PR delivers one phase. The final gate includes locked cross-engine behavior, axe plus explicit semantics, reduced-motion/forced-colors/zoom/RTL/no-script/CSS-disabled/disabled-capability cases, deterministic output, archive and provenance audits.

Record manual assistive-technology checks separately from automation; axe and CSS.supports are not complete accessibility certification. Existing SpecLed local runner failures remain visible, not silently waived. No implementation, test result or publication is claimed by this planning change.

## Alternatives considered

- Delivering the gallery only in the final phase would hide integration gaps
  until all components exist; reference pages ship with each component.
- Remote stock-image fixtures would reduce repository assets but make exports
  network-dependent and complicate provenance; a closed local manifest is used.
- Browser-name support labels would be easy to display but obscure individual
  capability and fallback differences; the demo shows source and observed
  evidence separately.
- Passing placeholder tests would quiet planning warnings without proof; missing
  implementation targets remain visible until real assertions land.

## Consequences

The demo becomes the integration surface as work lands. Media additions require deliberate exporter allowlist changes, but no image service or package runtime dependency. The original Pages-hosting clause is superseded by `shadcn_ui.fly_gallery_publication`; deterministic static export remains evidence and a portable fallback, while Fly deployment and canonical smoke remain separate recorded states.

## Verification and delivery

The linked Milestone E subjects define normative requirements; the
[implementation plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
assigns proof and delivery phases. Accepted here means an approved design
contract, not an implemented or browser-verified feature.

## Reviewed platform sources

Review date: 2026-08-26. Draft specifications are design references, not evidence
that a shipping browser implements every feature. Recheck sources and actual
locked engines in Phase 1 and whenever an enhancement is admitted.

- <https://www.w3.org/WAI/WCAG22/Understanding/pause-stop-hide.html>
