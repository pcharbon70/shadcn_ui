# Interactive Surfaces

Interactive-surface controls add optional context to an already complete native trigger or destination. Their content must remain supplemental: required instructions, errors, actions, and unique task information belong in visible page content.

## Tooltip

Tooltip attaches short escaped descriptive text to one structured button or link trigger. Supply `id` and `text`; `placement` is `block_start`, `block_end`, `inline_start`, or `inline_end`, and `describedby` merges existing description IDs. The trigger requires a visible `label` and `kind={:button | :link}`, then accepts the matching native button or link options. Hover and focus presentation is optional; the trigger stays complete without it.

```heex
<.tooltip id="manual-tip" text="Includes setup and deployment instructions.">
  <:trigger kind={:link} label="Read the complete manual" href="/manual" />
</.tooltip>
```

## Hover Card

Hover Card enriches one complete ordinary link with noninteractive preview content. Its trigger requires `label` and `href` and may use native `target`, `rel`, `download`, and current-location options; `placement` uses the same four logical values and `describedby` can merge external descriptions. The preview may contain trusted presentation markup, but not links, controls, forms, scripts, or unique information unavailable at the destination.

```heex
<.hover_card id="manual-card" placement={:inline_end}>
  <:trigger label="Read the complete manual" href="/manual" />
  <h3>Manual preview</h3>
  <p>Setup, component usage, and deployment guidance.</p>
</.hover_card>
```
