# Milestone C content surfaces

```spec-meta
id: shadcn_ui.content_surfaces
kind: package
status: active
summary: Scroll Area, Separator, and Radio Panels native semantic and fallback contracts.
decisions:
  - shadcn_ui.native_scroll_sticky_surfaces
  - shadcn_ui.radio_panels_not_tabs
  - shadcn_ui.semantic_component_api_and_accessibility
  - shadcn_ui.progressive_enhancement_baseline
surface:
  - lib/shadcn_ui/components/content/scroll_area.ex
  - lib/shadcn_ui/components/content/separator.ex
  - lib/shadcn_ui/components/content/*.ex
  - lib/shadcn_ui/components/content/**/*.ex
  - test/shadcn_ui/components/content/scroll_area_test.exs
  - test/shadcn_ui/components/content/separator_test.exs
  - test/shadcn_ui/components/content/*.exs
  - test/shadcn_ui/components/content/**/*.exs
  - test/shadcn_ui/content_surfaces_test.exs
  - test/shadcn_ui/milestone_c_acceptance_test.exs
  - README.md
```

## Requirements

```spec-requirements
- id: shadcn_ui.content.scroll_area
  statement: Scroll Area shall render one caller-sized native overflow container with closed axis and package sizing values, preserving caller content, native pointer, touch, wheel, keyboard, focus, and assistive-technology behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.content.scroll_focus
  statement: Scroll Area shall not add tabindex by default; an explicit focusable mode shall require a nonblank accessible name or relationship and shall protect the resulting focus semantics from conflicting caller globals.
  priority: must
  stability: stable

- id: shadcn_ui.content.scroll_ownership
  statement: Scroll Area shall not measure content, observe viewports, synchronize or restore position, virtualize children, implement custom scrollbar controls, load more data, or attach package-owned scroll handlers.
  priority: must
  stability: stable

- id: shadcn_ui.content.edge_fallback
  statement: Optional scroll-edge affordances shall be decorative CSS and shall never be the only indication of overflow; absent enhancement CSS shall retain a visible operable native scroll container and all caller content.
  priority: must
  stability: stable

- id: shadcn_ui.content.separator
  statement: Separator shall render a native hr in semantic mode and an aria-hidden nonsemantic element in explicit decorative mode, with closed horizontal and vertical presentation that does not manufacture structural meaning.
  priority: must
  stability: evolving

- id: shadcn_ui.content.radio_panels
  statement: Radio Panels shall render one native fieldset and required legend, stable keyed radio inputs with deterministic labels and panel relationships, one explicit scalar selected snapshot, and native radio keyboard and form behavior.
  priority: must
  stability: evolving

- id: shadcn_ui.content.radio_not_tabs
  statement: Radio Panels shall expose no tablist, tab, or tabpanel roles, roving tabindex, arrow-key emulation beyond native radios, automatic activation, focus movement, history integration, or package-owned selection state, and ShadcnUI shall not publish a Tab Group in Milestone C.
  priority: must
  stability: stable

- id: shadcn_ui.content.radio_fallback
  statement: Capability-gated Radio Panels CSS may emphasize the selected panel, but without required CSS selector support every panel shall remain present, visible, and readable in source order without script.
  priority: must
  stability: stable

- id: shadcn_ui.content.shared_contract
  statement: Scroll Area, Separator, and Radio Panels shall follow shared closed-value, slot, escaping, caller-global, protected-semantics, deterministic-identity, presentation-snapshot, theme, and progressive-floor requirements.
  priority: must
  stability: stable
```

## Verification

```spec-verification
- kind: test_file
  target: test/shadcn_ui/components/content/scroll_area_test.exs
  covers:
    - shadcn_ui.content.scroll_area
    - shadcn_ui.content.scroll_focus
    - shadcn_ui.content.scroll_ownership
    - shadcn_ui.content.edge_fallback
    - shadcn_ui.content.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/content/separator_test.exs
  covers:
    - shadcn_ui.content.separator
    - shadcn_ui.content.shared_contract

- kind: test_file
  target: test/shadcn_ui/components/content/radio_panels_test.exs
  covers:
    - shadcn_ui.content.radio_panels
    - shadcn_ui.content.radio_not_tabs
    - shadcn_ui.content.radio_fallback
    - shadcn_ui.content.shared_contract

- kind: test_file
  target: test/shadcn_ui/content_surfaces_test.exs
  covers:
    - shadcn_ui.content.scroll_area
    - shadcn_ui.content.scroll_focus
    - shadcn_ui.content.scroll_ownership
    - shadcn_ui.content.edge_fallback
    - shadcn_ui.content.separator
    - shadcn_ui.content.radio_panels
    - shadcn_ui.content.radio_not_tabs
    - shadcn_ui.content.radio_fallback
    - shadcn_ui.content.shared_contract

- kind: test_file
  target: test/shadcn_ui/milestone_c_acceptance_test.exs
  covers:
    - shadcn_ui.content.scroll_area
    - shadcn_ui.content.scroll_focus
    - shadcn_ui.content.scroll_ownership
    - shadcn_ui.content.edge_fallback
    - shadcn_ui.content.separator
    - shadcn_ui.content.radio_panels
    - shadcn_ui.content.radio_not_tabs
    - shadcn_ui.content.radio_fallback
    - shadcn_ui.content.shared_contract
```
