# Overlays

Overlay controls use native Dialog, Popover, and declarative invoker capabilities to present focused or supplemental content. The browser owns their native focus and dismissal behavior; applications own authorization, validation, persistence, outcomes, and an ordinary fallback for platforms that lack the required capability.

## Dialog

Dialog presents a focused task in a native modal boundary. Give it a stable `id` and a title or `accessible_label`; choose `dismissal` from `none`, `close_request`, or `any`, `initial_focus` from `auto`, `content`, or `close`, `size` from `small`, `default`, `large`, or `full`, `alignment` from `start` or `center`, and `density` from `compact` or `comfortable`. Trigger, body, and close content are required; description and fallback are optional.

```heex
<.dialog id="preferences" initial_focus={:close} size={:large}>
  <:trigger>Open preferences</:trigger>
  <:title>Preferences</:title>
  <:description>Review your display preferences.</:description>
  <p>Caller-owned controls go here.</p>
  <:close>Close preferences</:close>
  <:fallback><a href="/preferences">Open preferences as a page</a></:fallback>
</.dialog>
```

## Alert Dialog

Alert Dialog is a native modal confirmation for a consequential choice. It always uses close-request dismissal and gives initial focus to the required safe cancel action. Supply a stable `id`, choose `size` from `small`, `default`, or `large`, and provide required trigger, title, description, cancel, and action slots; body and ordinary fallback content are optional. The action remains caller-owned and is not authorized or executed by the component.

```heex
<.alert_dialog id="confirm-discard" size={:small}>
  <:trigger>Discard draft</:trigger>
  <:title>Discard this draft?</:title>
  <:description>Your unsaved changes will be lost.</:description>
  <:cancel>Keep editing</:cancel>
  <:action><button type="submit" form="discard-form">Discard draft</button></:action>
  <:fallback><a href="/draft/discard">Review discard options</a></:fallback>
</.alert_dialog>
```

## Drawer

Drawer presents a native modal dialog at a logical viewport edge. Set `edge` to `start`, `end`, or `bottom`; `size` to `small`, `default`, or `large`; `dismissal` to `none`, `close_request`, or `any`; and `initial_focus` to `auto`, `content`, or `close`. It requires trigger, body, and close content and supports title, description, header, footer, `accessible_label`, and fallback content; it does not add dragging or swipe gestures.

```heex
<.drawer id="filters" edge={:end} initial_focus={:content}>
  <:trigger>Open filters</:trigger>
  <:title>Filters</:title>
  <p>Caller-owned filter controls go here.</p>
  <:footer><button type="submit" form="filters-form">Apply</button></:footer>
  <:close>Close filters</:close>
  <:fallback><a href="/filters">Open filters as a page</a></:fallback>
</.drawer>
```

## Popover

Popover is a native nonmodal surface for a small group of optional content or controls. `mode` is `auto` or `manual`, trigger `action` is `toggle`, `show`, or `hide`, and logical `placement` is `block_start`, `block_end`, `inline_start`, or `inline_end`. Name it with a title, `accessible_label`, or `labelledby`; trigger and body are required, while description, close, and fallback are optional. Manual mode needs an explicit hide path.

```heex
<.popover id="display-options" placement={:block_end} mode={:auto}>
  <:trigger>Display options</:trigger>
  <:title>Display options</:title>
  <label><input type="checkbox" name="compact" /> Compact rows</label>
  <:close>Close options</:close>
  <:fallback><a href="/display-options">Open display options</a></:fallback>
</.popover>
```

## Dropdown Actions

Dropdown Actions groups ordinary links and buttons in an auto popover; it is not an ARIA menu and does not add arrow-key navigation or typeahead. Supply `id`, `accessible_label`, a trigger, and keyed actions. `placement` uses the four logical values; each action has a `label`, optional `kind` of `link` or `button`, and the corresponding native destination, current-location, download, type, disabled, name/value, form, group, or destructive options. Optional group labels, separators, and fallback content organize the list.

```heex
<.dropdown_actions id="document-actions" accessible_label="Document actions">
  <:trigger>Document actions</:trigger>
  <:action key="read" kind={:link} destination="/document" label="Read document" />
  <:action key="archive" kind={:button} type="submit" form="archive-form" label="Archive" />
  <:fallback><a href="/document/actions">All document actions</a></:fallback>
</.dropdown_actions>
```
