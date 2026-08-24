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
surface:
  - assets/**
  - package.json
  - package-lock.json
  - priv/static/shadcn_ui.css
  - lib/shadcn_ui.ex
  - README.md
  - test/shadcn_ui/stylesheet_test.exs
  - test/shadcn_ui/milestone_b_acceptance_test.exs
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
  statement: The canonical artifact shall contain no remote import, remote font, data-fetching URL, script syntax, or consumer Tailwind requirement, and Milestones A and B shall ship no component JavaScript.
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
```

## Verification

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
```
