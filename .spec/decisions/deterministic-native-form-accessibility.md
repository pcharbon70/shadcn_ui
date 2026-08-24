---
id: shadcn_ui.deterministic_form_accessibility
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.form_contract
  - shadcn_ui.form_components
  - shadcn_ui.form_gallery
  - shadcn_ui.stylesheet
---

# Make Native Form Accessibility Relationships Deterministic

## Context

Accessible form markup is a relationship among a native control, label, help,
errors, group semantics, and optional form-level summary. If callers must rebuild
those relationships around styled fragments, IDs and ARIA references will drift
across server rerenders. Caller globals can also contradict derived invalid,
required, disabled, or descriptive state.

## Decision

Milestone B components own deterministic relationship markup while callers own
the data and its lifecycle.

- Every visible control uses a stable explicit or `FormField`-derived base ID.
  Labels use native `for` associations; help and error IDs use documented base-ID
  suffixes and stable ordinals for repeated errors.
- `aria-describedby` is assembled in documented order from non-conflicting caller
  references, visible help, and visible errors. Duplicate tokens are removed
  without reordering distinct references.
- Visible errors produce `aria-invalid="true"` and references to every rendered
  error. Hidden errors produce neither invalid state nor dangling references.
- Required, disabled, and readonly states use native attributes wherever the
  element supports them. Required indicators and visual states never replace
  native semantics.
- Checkbox and Switch labels target their real checkbox inputs. Radio Group uses
  a native `fieldset`, `legend`, and deterministic IDs for every native radio.
- Error Summary renders escaped messages and ordinary fragment links to explicit
  control IDs. It adds no alert role, focus target, scroll, or navigation
  behavior by default; callers choose announcement and focus policy.
- Mandatory IDs, label targets, group semantics, invalid state, and derived ARIA
  relationships take precedence over conflicting caller globals. Unrelated
  documented native, `aria-*`, `data-*`, `phx-*`, and `data-on-*` attributes pass
  through.
- Long labels, translated messages, repeated errors, narrow layouts, zoom, and
  forced-colors presentation are verification cases, not optional polish.

## Consequences

Server rerenders preserve stable relationships, and tests can assert semantics
instead of incidental wrapper structure. Explicit consumers remain responsible
for choosing unique base IDs when rendering the same control more than once.

Future custom widgets must define their own focus and keyboard contract rather
than inheriting native-control guarantees by appearance.
