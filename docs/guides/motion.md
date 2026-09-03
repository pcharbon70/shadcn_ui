# Motion

Motion controls provide optional, bounded CSS presentation over complete native content. `motion={:system}` respects package, ancestor, and operating-system reduction policy, while `motion={:none}` disables the effect; motion never communicates loading, readiness, progress, or information that is unavailable in the static document.

## Marquee

Marquee renders one canonical named list and can offer a single finite scrolling preview rather than an endless ticker. Supply a stable `id`, `accessible_label`, and nonempty atom-keyed items with unique string `key`, escaped `text`, and an optional image map. `mode` is `static` or `preview`, logical `direction` is `inline_start` or `inline_end`, `duration` is `brief` or `default`, and `motion` is `system` or `none`.

```heex
<.marquee
  id="topics"
  accessible_label="Featured topics"
  mode={:preview}
  duration={:brief}
  items={[
    %{key: "mountains", text: "Mountain walks"},
    %{key: "harbors", text: "Harbor stories"},
    %{key: "gardens", text: "Garden journals"}
  ]}
/>
```

## Stagger

Stagger wraps complete keyed content with an optional short render-time entrance. Choose `as` from `div`, `ul`, or `ol`; `effect` from `none`, `fade`, or `rise`; `preset` from `quick` or `default`; and `motion` from `system` or `none`. Every item needs a stable key and remains present and usable even when the effect is unavailable or reduced.

```heex
<.stagger id="reading-list" as={:ol} effect={:rise} preset={:quick}>
  <:item key="setup"><a href="/guides/setup">Setup guide</a></:item>
  <:item key="components"><a href="/guides/components">Component guide</a></:item>
  <:item key="release"><a href="/releases/latest">Release notes</a></:item>
</.stagger>
```

## Scroll Indicator

Scroll Indicator creates a named native scroll region with an optional decorative position track outside its viewport. Supply `id`, exactly one of `accessible_label` or `labelledby`, and body content; `size` is `small`, `default`, or `large`, and `motion` is `system` or `none`. An optional description can explain the region. The track is not numeric progress and disappears safely when its complete CSS capability is unavailable.

```heex
<.scroll_indicator
  id="reading-notes"
  accessible_label="Reading notes"
  size={:small}
  description="Scroll to inspect all notes."
>
  <p :for={number <- 1..12}>Reading note {number}.</p>
</.scroll_indicator>
```
