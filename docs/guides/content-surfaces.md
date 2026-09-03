# Content Surfaces

Content-surface controls arrange bounded, separated, or selectable content while preserving native scrolling and form semantics. They add presentation and deterministic relationships, not remote loading, virtualization, or application selection state.

## Scroll Area

Scroll Area wraps content in one native overflow container. Choose `axis` from `vertical`, `horizontal`, or `both`; `size` from `small`, `default`, or `large`; and `edge_affordance` from `none`, `start`, `end`, or `both`. When `focusable` is true, provide exactly one useful `accessible_label` or `labelledby` value.

```heex
<.scroll_area axis={:vertical} size={:small} focusable accessible_label="Recent activity">
  <p :for={item <- 1..12}>Activity item {item}</p>
</.scroll_area>
```

## Separator

Separator draws a boundary between content. `mode={:semantic}` renders meaningful separation, while `mode={:decorative}` hides the boundary from the accessibility tree. Its `orientation` is `horizontal` or `vertical`; use vertical separators only where surrounding layout gives them a real block size.

```heex
<p>Account details</p>
<.separator mode={:semantic} orientation={:horizontal} />
<p>Notification preferences</p>
```

## Radio Panels

Radio Panels pairs a native radio group with caller-owned panel content. Provide stable `id`, form `name`, selected value, a legend, and keyed options with string `value` and `label`; choose a `vertical` or `horizontal` layout and optionally set `required`, `disabled`, or `form`. Without enhancement CSS all panel content remains available, so do not use it as a substitute for ARIA tabs.

```heex
<.radio_panels id="view" name="view" selected="summary" layout={:horizontal}>
  <:legend>View</:legend>
  <:option key="summary" value="summary" label="Summary">Summary content.</:option>
  <:option key="details" value="details" label="Details">Detailed content.</:option>
</.radio_panels>
```
