# Stylesheet, token, and theme distribution

```spec-meta
id: shadcn_ui.stylesheet
kind: package
status: active
summary: Deterministic isolated CSS distribution and namespaced shadcn-style theme contract.
decisions:
  - shadcn_ui.isolated_compiled_css
  - shadcn_ui.scoped_theme_token_contract
  - shadcn_ui.progressive_enhancement_baseline
  - shadcn_ui.deterministic_form_accessibility
  - shadcn_ui.enhanced_select_boundary
  - shadcn_ui.native_disclosure_grouping
  - shadcn_ui.native_scroll_sticky_surfaces
  - shadcn_ui.radio_panels_not_tabs
  - shadcn_ui.native_overlay_platform_runtime
  - shadcn_ui.popover_positioning_actions
  - shadcn_ui.supplemental_surface_boundary
surface:
  - assets/**
  - test/fixtures/*.html
  - test/fixtures/coexistence.html
  - test/fixtures/accordion.html
  - test/fixtures/navigation_menu.html
  - test/fixtures/phase4_headers_radio_panels.html
  - package.json
  - package-lock.json
  - priv/static/shadcn_ui.css
  - lib/shadcn_ui.ex
  - README.md
  - test/shadcn_ui/stylesheet_test.exs
  - test/browser/accordion-foundations.spec.mjs
  - test/browser/navigation-menu-foundations.spec.mjs
  - test/browser/phase4-headers-radio-panels.spec.mjs
  - test/browser/milestone-d-*.spec.mjs
  - test/browser/milestone-d-drawers.spec.mjs
  - test/fixtures/milestone_d_drawers.html
  - test/browser/milestone-d-popovers.spec.mjs
  - test/fixtures/milestone_d_popovers.html
  - test/shadcn_ui/milestone_b_acceptance_test.exs
  - test/shadcn_ui/milestone_c_acceptance_test.exs
  - test/shadcn_ui/milestone_d_acceptance_test.exs
```

## Requirements

```spec-requirements
- id: shadcn_ui.stylesheet.canonical_asset
  statement: ShadcnUI shall distribute one deterministic minified CSS artifact at priv/static/shadcn_ui.css.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.pinned_build
  statement: The package-local npm manifest and lockfile shall pin Tailwind CSS v4 and every asset-build dependency used to produce the canonical artifact.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.explicit_sources
  statement: The CSS build shall scan only explicit ShadcnUI HEEX and asset sources, and every closed component value shall map to complete statically discoverable class strings.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.prefixed_isolation
  statement: Generated utilities and Tailwind-owned variables shall use the sui prefix, and the artifact shall not include unrestricted Tailwind Preflight or unprefixed utility selectors.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.semantic_tokens
  statement: Public semantic colors, foreground pairs, border, input, invalid, focus ring, radius, control sizing, and motion tokens shall use documented --shadcn-ui-* custom properties with complete light defaults.
  priority: must
  stability: evolving

- id: shadcn_ui.stylesheet.scoped_dark_theme
  statement: Dark token values shall activate only beneath data-shadcn-theme="dark", explicit light shall activate beneath data-shadcn-theme="light", and missing or invalid values shall retain light defaults.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.consumer_overrides
  statement: Consumers shall be able to override documented --shadcn-ui-* properties within their own scope without rebuilding the package stylesheet.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.asset_path
  statement: ShadcnUI.stylesheet_path/0 shall resolve the packaged artifact through Application.app_dir/2 without copying, serving, or injecting it.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.reduced_motion
  statement: The stylesheet shall preserve state and meaning while disabling or shortening nonessential component animation under prefers-reduced-motion.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.no_runtime_assets
  statement: The canonical artifact shall contain no remote import, remote font, data-fetching URL, script syntax, or consumer Tailwind requirement, and Milestones A through D shall ship no component JavaScript.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.reproducible_output
  statement: A clean locked asset build shall reproduce the committed canonical artifact byte-for-byte and fail when generated output is stale.
  priority: must
  stability: stable

- id: shadcn_ui.stylesheet.form_fallbacks
  statement: Textarea field-sizing content and customizable-select styling shall activate only inside capability queries, while fixed textarea sizing and classic native select presentation remain visible, operable, and semantically complete fallbacks.
  priority: must
  stability: evolving

- id: shadcn_ui.stylesheet.form_resilience
  statement: Form controls, labels, help, errors, focus, disabled state, checked or selected state, progress, and meter meaning shall remain distinguishable at narrow widths, 200 percent zoom, and in forced-colors mode without relying on color alone.
  priority: must
  stability: evolving

- id: shadcn_ui.stylesheet.content_fallbacks
  statement: Exclusive disclosure, sticky or anchor-positioned headers, scroll-edge affordances, and selected Radio Panels presentation shall use capability-aware CSS whose absence preserves independent native disclosure, normal document flow, native scrolling, and access to every panel.
  priority: must
  stability: evolving

- id: shadcn_ui.stylesheet.content_resilience
  statement: Disclosure, navigation, headings, separators, overflow content, current location, selected radio state, focus, and fragment targets shall remain perceivable and operable at narrow and wide widths, 200 percent zoom, forced colors, reduced motion, light and dark themes, and without color or decoration as the only cue.
  priority: must
  stability: evolving

- id: shadcn_ui.stylesheet.overlay_fallbacks
  statement: Dialog backdrops, Drawer placement, Popover anchors and position tries, Tooltip and Hover Card visibility, and discrete overlay transitions shall be capability-gated presentation whose absence preserves native invocation where supported, bounded readable placement, explicit exits, ordinary fallback destinations, and required page content.
  priority: must
  stability: evolving

- id: shadcn_ui.stylesheet.overlay_resilience
  statement: Overlay surfaces, invokers, close controls, focus indicators, long content, viewport edges, logical placement, backdrops, and supplemental relationships shall remain perceivable and operable at narrow widths, 200 percent zoom, forced colors, reduced motion, light and dark themes, RTL, coarse pointer, CSS-disabled, and no-script conditions.
  priority: must
  stability: evolving
```

## Verification

Milestone E Phase 5 uses only complete prefixed container/grid/image utilities
and unchanged existing Dialog styles. Enlarged images contain within 60dvb,
with native content scrolling and sticky close. No authored CSS exception is
added: the scoped-origin experiment stays test-only and the effect is deferred.
Browser tests cover responsive layout, themes, suppression, forced colors,
CSS-disabled fallback and bounded long captions.

Milestone E Phase 4 adds E-05 source-local width decoration and E-06 bounded
image-only depth. Joint timeline/range/scope gates have no document-clock fallback.
Cover Flow also requires 3D support, multiple images and a 40rem container.
Reduced/forced-color/unsupported paths stay neutral or flat. Captions and
destinations never transform; scoped tokens and E-01 suppression remain shared.

Phase 3 adds E-04 bounded Stagger keyframes behind animation/no-preference
queries. Only validated preset timings enter namespaced numeric properties.
The visible baseline, no fill/repeat and focus cancellation preserve caller
controls on interruption; E-01 disables nested and OS-suppressed effects.

Phase 3 adds E-03 finite Marquee CSS. Joint :has, :dir, transform and animation
queries expose its native checkbox and one-iteration travel only with system
motion permitted. The complete wrapped canonical list is the static baseline;
the inert duplicate is hidden before, after and on interruption. E-01 suppression
remains authoritative. No autoplay, infinite iteration or runtime is introduced.

Milestone E Phase 2 adds native Carousel inline layout in carousel.css (E-02).
Complete static snap/alignment utilities retain ordinary overflow when unsupported;
logical padding, bounded cards and real index links preserve focus and RTL order.
No scrollbar hiding, generated scroll controls or runtime is introduced.
Focused descendants suspend snap so mandatory points cannot pull oversized
content away from focus at zoom. Native scrolling and index links remain usable.

Milestone E Phase 1 adds the opt-in motion-media.css foundation and its authored
exception ledger. System reduced motion, an ancestor data-shadcn-motion=reduce,
and explicit none suppress only marked motion roots/parts, including nested
system roots. Opacity and focus stay visible; static clones remain hidden.
There are no new public motion components or animation keyframes in this phase.
The actual compiled artifact is exercised by milestone-e-foundations.spec.mjs.

Milestone D gallery accessibility acceptance checks both theme pairs, including
dark destructive foreground contrast. Drawer headers wrap their title and exit
at narrow/zoomed widths rather than shrinking the heading into an unusably tall
column. These are package CSS fixes verified against the real gallery as well
as the original native fixtures.

Supplemental surfaces default to non-overlapping normal flow. Wide fine-pointer
layouts may use viewport-bounded, scoped CSS anchors behind joint anchor-scope,
position-area and position-try-fallbacks queries. This is ordinary CSS stacking,
not the top layer. Narrow/coarse and RTL layouts retain flow content (scoped RTL
anchor coordinates differ in the locked matrix); reduced motion
removes transitions, and forced colors preserve explicit borders. The Phase 5
fixture is rendered from actual components and checked for deterministic output.

```spec-verification
- kind: command
  target: npm run assets:check
  execute: true
  covers:
    - shadcn_ui.stylesheet.canonical_asset
    - shadcn_ui.stylesheet.pinned_build
    - shadcn_ui.stylesheet.explicit_sources
    - shadcn_ui.stylesheet.prefixed_isolation
    - shadcn_ui.stylesheet.semantic_tokens
    - shadcn_ui.stylesheet.scoped_dark_theme
    - shadcn_ui.stylesheet.consumer_overrides
    - shadcn_ui.stylesheet.reduced_motion
    - shadcn_ui.stylesheet.no_runtime_assets
    - shadcn_ui.stylesheet.reproducible_output
    - shadcn_ui.stylesheet.form_fallbacks
    - shadcn_ui.stylesheet.form_resilience
    - shadcn_ui.stylesheet.content_fallbacks
    - shadcn_ui.stylesheet.content_resilience
    - shadcn_ui.stylesheet.overlay_fallbacks
    - shadcn_ui.stylesheet.overlay_resilience

- kind: test_file
  target: test/shadcn_ui/stylesheet_test.exs
  covers:
    - shadcn_ui.stylesheet.canonical_asset
    - shadcn_ui.stylesheet.pinned_build
    - shadcn_ui.stylesheet.explicit_sources
    - shadcn_ui.stylesheet.prefixed_isolation
    - shadcn_ui.stylesheet.semantic_tokens
    - shadcn_ui.stylesheet.scoped_dark_theme
    - shadcn_ui.stylesheet.consumer_overrides
    - shadcn_ui.stylesheet.asset_path
    - shadcn_ui.stylesheet.reduced_motion
    - shadcn_ui.stylesheet.no_runtime_assets
    - shadcn_ui.stylesheet.reproducible_output
    - shadcn_ui.stylesheet.form_fallbacks
    - shadcn_ui.stylesheet.form_resilience
    - shadcn_ui.stylesheet.content_fallbacks
    - shadcn_ui.stylesheet.content_resilience
    - shadcn_ui.stylesheet.overlay_fallbacks
    - shadcn_ui.stylesheet.overlay_resilience

- kind: test_file
  target: test/browser/accordion-foundations.spec.mjs
  covers:
    - shadcn_ui.stylesheet.content_fallbacks
    - shadcn_ui.stylesheet.content_resilience

- kind: test_file
  target: test/browser/phase4-headers-radio-panels.spec.mjs
  covers:
    - shadcn_ui.stylesheet.content_fallbacks
    - shadcn_ui.stylesheet.content_resilience

- kind: test_file
  target: test/shadcn_ui/milestone_a_acceptance_test.exs
  covers:
    - shadcn_ui.stylesheet.canonical_asset
    - shadcn_ui.stylesheet.prefixed_isolation
    - shadcn_ui.stylesheet.semantic_tokens
    - shadcn_ui.stylesheet.scoped_dark_theme
    - shadcn_ui.stylesheet.asset_path
    - shadcn_ui.stylesheet.no_runtime_assets
    - shadcn_ui.stylesheet.reproducible_output

- kind: test_file
  target: test/shadcn_ui/milestone_b_acceptance_test.exs
  covers:
    - shadcn_ui.stylesheet.semantic_tokens
    - shadcn_ui.stylesheet.reduced_motion
    - shadcn_ui.stylesheet.no_runtime_assets
    - shadcn_ui.stylesheet.form_fallbacks
    - shadcn_ui.stylesheet.form_resilience

- kind: test_file
  target: test/shadcn_ui/milestone_c_acceptance_test.exs
  covers:
    - shadcn_ui.stylesheet.semantic_tokens
    - shadcn_ui.stylesheet.scoped_dark_theme
    - shadcn_ui.stylesheet.reduced_motion
    - shadcn_ui.stylesheet.no_runtime_assets
    - shadcn_ui.stylesheet.content_fallbacks
    - shadcn_ui.stylesheet.content_resilience

- kind: test_file
  target: test/browser/milestone-d-popovers.spec.mjs
  covers:
    - shadcn_ui.stylesheet.overlay_fallbacks
    - shadcn_ui.stylesheet.overlay_resilience

- kind: test_file
  target: test/browser/milestone-d-supplemental-surfaces.spec.mjs
  covers:
    - shadcn_ui.stylesheet.overlay_fallbacks
    - shadcn_ui.stylesheet.overlay_resilience

- kind: test_file
  target: test/browser/milestone-d-drawers.spec.mjs
  covers:
    - shadcn_ui.stylesheet.overlay_fallbacks
    - shadcn_ui.stylesheet.overlay_resilience

- kind: test_file
  target: test/browser/milestone-d-overlay-contract.spec.mjs
  covers:
    - shadcn_ui.stylesheet.overlay_fallbacks
    - shadcn_ui.stylesheet.overlay_resilience

- kind: test_file
  target: test/shadcn_ui/milestone_d_acceptance_test.exs
  covers:
    - shadcn_ui.stylesheet.reduced_motion
    - shadcn_ui.stylesheet.no_runtime_assets
    - shadcn_ui.stylesheet.overlay_fallbacks
    - shadcn_ui.stylesheet.overlay_resilience
```
