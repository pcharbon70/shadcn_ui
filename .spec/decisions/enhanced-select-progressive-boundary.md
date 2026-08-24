---
id: shadcn_ui.enhanced_select_boundary
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.form_components
  - shadcn_ui.form_gallery
  - shadcn_ui.stylesheet
---

# Enhance Select Through A Capability-Gated Native Fallback

## Context

Customizable select platform features can provide a richer visual treatment
without recreating a combobox, but support is not universal. A script widget or
duplicated hidden control would weaken the package's native and transport-neutral
boundaries and could submit a value different from the visible control.

## Decision

Enhanced Select is a progressive presentation of one native `select`.

- Native Select remains the recommended ordinary-choice default. Enhanced Select
  is a separate documented API so consumers deliberately opt into its browser-
  dependent presentation.
- The enhanced component renders one native `select` with the same name, options,
  selected values, disabled state, relationships, and submission semantics as
  Native Select. It renders no mirrored hidden control, custom listbox, or second
  state model.
- The classic native select is the default CSS floor. Enhanced presentation is
  activated only by feature queries that prove the required customizable-select
  capabilities; browser names and version guesses are not used as the contract.
- Unsupported or CSS-disabled browsers receive the visible, focusable, operable
  classic select with no hidden or duplicated value. Optional enhancement-only
  structure must be ignored safely without removing option text.
- The package ships no select JavaScript, popup state, option filtering, remote
  loading, focus management, or polyfill. Native keyboard and form behavior
  remain authoritative.
- Documentation and browser tests show both the enhanced path and exact classic
  fallback. A capability-regression test must fail if enhancement CSS escapes its
  feature gate.

## Consequences

Consumers gain a modern presentation where the platform supports it without
making that presentation a minimum browser requirement. Native Select remains a
stable escape hatch and comparison baseline.

A future combobox or scripted select would require a separate milestone,
accessibility decision, runtime boundary, and value-synchronization contract.
