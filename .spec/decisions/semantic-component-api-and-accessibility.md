---
id: shadcn_ui.semantic_component_api_and_accessibility
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.foundation_components
---

# Use Explicit Semantic Component APIs and Accessibility Contracts

## Context

The unscripted/ui examples are copyable HTML fragments. A reusable HEEX package
must turn those fragments into stable APIs without accepting arbitrary class
names as component variants or inferring accessibility meaning from visual
appearance. Caller globals must remain useful without overriding semantics that
the component contract guarantees.

## Decision

Every public component declares closed semantic attributes and explicit slots.

- Variants, sizes, element types, and semantic states map through fixed internal
  tables; caller strings are never converted into atoms or interpolated into
  generated utility names.
- Primary trusted HEEX content uses `inner_block`. Named slots exist only for
  semantically distinct regions such as leading content, actions, card header,
  or card footer.
- Caller text is escaped. No raw-HTML attribute or string-to-markup convenience
  API is provided.
- Components accept caller class values and documented native, `aria-*`,
  `data-*`, `phx-*`, and `data-on-*` globals while protecting mandatory element
  type, roles, names, disabled state, and accessibility relationships.
- Native elements carry their native meaning. Components do not add ARIA roles
  to make a visual pattern claim richer interaction than it implements.
- IDs are caller-supplied or deterministically derived only when relationships
  require them. No process-global or random ID generator is used during render.
- Loading, dismissal, image failure, and command outcomes remain caller-owned;
  component state attributes only determine the rendered snapshot.

## Consequences

The API is narrower than unconstrained source copying but can be compiled,
documented, and tested. Callers retain behavior-framework attributes and trusted
slot composition without being able to contradict the component's guaranteed
semantics.
