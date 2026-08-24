# Milestone C - Disclosure, Navigation, and Content Surfaces

## Description

Milestone C adds the structures needed to compose substantial server-rendered
application pages. It favors native disclosure, links, lists, landmarks, and
scroll containers, and separates navigation patterns from composite widgets
whose ARIA contracts would require additional keyboard behavior.

## Intended outcomes

- Applications can assemble responsive content and navigation surfaces from
  semantic, stateless function components.
- Accordion behavior uses native `details` and `summary` elements with find-in-
  page and keyboard behavior preserved.
- Navigation components render real destinations and never reinterpret a link
  as a command.
- Advanced indicators, sticky effects, and animated disclosure remain
  progressive presentation rather than required behavior.

## Component scope

- Accordion with independent and exclusive grouping policies.
- Navigation Menu for link destinations with current-location semantics.
- Header and sticky section header compositions.
- Scroll Area with native scrolling and optional edge affordances.
- Separator and any small layout primitives proven necessary for coherent page
  composition.
- A deliberately named panel-switching component based on native radios, only
  if its radio-group semantics are acceptable.
- A true Tab Group only if a complete ARIA tablist, keyboard, activation, and
  focus contract is separately approved.

## Architecture work required

- Decide whether the upstream radio-based “Tabs” remains a radio-group pattern,
  is renamed, or is excluded in favor of a complete interactive implementation.
- Specify destination ownership, current-page precedence, landmark naming,
  heading preservation, and caller-owned navigation behavior.
- Define accordion group naming, default-open state, rerender behavior, and the
  fallback when exclusive `details name` or animated height is unsupported.
- Define scroll-container sizing and focus policy without inspecting viewport
  state or owning application data.
- Ensure anchor-positioned decoration never becomes the only hover, focus, or
  current-location indicator.

## Gallery scope

- Add Disclosure, Navigation, and Content Surfaces categories.
- Demonstrate realistic documentation, settings, and application-shell pages.
- Include narrow, wide, overflow, long-content, nested-content, and keyboard-
  only examples.
- Explain navigation tabs, radio panels, and true tab widgets as separate
  semantics rather than visually interchangeable variants.
- Show feature-enhanced and fallback header, accordion, and navigation states.

## Verification expectations

- Rendering tests assert native elements, landmarks, lists, links, headings,
  current-location semantics, and deterministic group identities.
- Browser tests cover keyboard navigation, focus visibility, native disclosure,
  find-in-page expectations, scrolling, responsive layout, and reduced motion.
- Integration tests compose Milestone A and B components into substantial pages
  without adding domain or transport behavior to the package.

## Exit criteria

Milestone C is complete when the package can compose representative application
pages, every visually similar navigation or selection pattern has honest
semantics, fallbacks retain access to all content and destinations, and the
online gallery makes those distinctions understandable.

## Deferred work

Command menus, modal workflows, tree navigation, interactive grids, client
routers, authorization-aware navigation, and application-specific sidebars
remain outside this milestone.
