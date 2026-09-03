# Motion and media: choosing, composing and verifying

ShadcnUI is an independent Phoenix adaptation, not an official shadcn or
unscripted/ui project. `use ShadcnUI` imports all six defining components;
their ExDoc function entries list Phoenix attrs, slots, defaults and closed
values. The package ships compiled isolated CSS, not a component runtime.

| Component | Native operation | Deliberately absent |
| --- | --- | --- |
| Carousel | Named scroll region, complete ordered list, real fragment index | Tabs, active slide, autoplay, generated controls |
| Cover Flow | Carousel with optional image-only depth | Selection, drag controller, transformed captions |
| Image Gallery | Figures, per-image Dialog and separate destinations | Slideshow, zoom/pan, nested modal, fetch-on-open |
| Marquee | Static list; checkbox enables one finite preview | Endless loop, playback status, arbitrary cloned HEEx |
| Stagger | Keyed content; optional finite render-time entrance | Observer, hidden waiting content, once-only state |
| Scroll Indicator | Block scroll region; decorative position track | Progress/Meter semantics, completion, external source |

## Compilable composition

This complete HEEx example uses all six imports. Its image path belongs to the
application; the package supplies no file or request. Acceptance tests compile
and render this exact fenced example.

```heex
<.carousel id="guide-carousel" accessible_label="Reading">
  <:item key="intro" label="Introduction"><a href="/reading/intro">Read introduction</a></:item>
</.carousel>
<.cover_flow id="guide-flow" accessible_label="Landscapes" images={[
  %{key: "ridge", src: "/media/ridge.svg", alt: "Mountain ridges", width: 640, height: 480, href: "/media/ridge.svg"}
]} />
<.image_gallery id="guide-gallery" accessible_label="Illustrations" images={[
  %{key: "ridge", src: "/media/ridge.svg", alt: "Mountain ridges", width: 640, height: 480, caption: "Original illustration", href: "/media/ridge.svg"}
]} />
<.marquee id="guide-marquee" accessible_label="Topics" mode={:preview}
  items={[%{key: "reading", text: "Reading at your pace"}]} />
<.stagger id="guide-stagger" as={:ul} effect={:rise}>
  <:item key="intro"><a href="/reading/intro">Read introduction</a></:item>
</.stagger>
<.scroll_indicator id="guide-scroll" accessible_label="Notes" size={:small}>
  <p :for={n <- 1..12}>Complete note {n}.</p>
</.scroll_indicator>
```

## Identity, composition and text

Supply a unique valid root `id` per instance and stable unique nonblank item
keys. Internal identities encode the instance and key without creating atoms.
Use rendered index/invoker relationships rather than constructing derived IDs.
Carousel, Cover Flow, Image Gallery and Scroll Indicator require exactly one
`accessible_label` or `labelledby` referencing existing headings. Marquee requires
its own label; Stagger preserves caller content semantics.

Root `class` and unrelated `rest` globals survive. Required native types, names,
relationships, semantics and protected timing cannot be replaced by globals.
Carousel/Stagger item slots accept documented class/rest options. Slots contain
trusted application HEEx, not untrusted HTML; plain labels, captions and record
text are escaped. Image Gallery caption slots must remain noninteractive and
scope caller IDs separately for thumbnail/full contexts.

## Native access and suppression

Tab reaches named scroll regions; native arrows, wheel and touch scroll them.
Index links target items without synchronized selection. Child focus suspends
Carousel snapping, including oversized content. Platform keyboard settings still
determine which native links/buttons enter Tab order.

Image Gallery retains Dialog naming, autofocus, explicit close, Escape/dismissal
and inertness. Keyboard invocation restores the previously focused invoker;
pointer focus follows platform policy. Ordinary image links remain available
when a dialog cannot open. The optional thumbnail-origin effect is deferred;
no anchor/transition fallback runtime ships. See [Image Gallery](image-gallery.md)
for all responsive records and modal options.

Marquee's canonical list remains authoritative. Its at-most-one presentation
clone is inert, aria-hidden, ID-free, action-free and hidden outside preview.
The initially unchecked nameless checkbox enables a preview; uncheck to persist
stop/reset, check again to replay. Checked means enabled, not playing. Marquee
finishes within five seconds; Stagger's delay plus duration fits within one
second. Excess Stagger items are immediate and focus cancels their effect.

`motion={:none}`, ancestor `data-shadcn-motion="reduce"`, and OS reduced motion
each suppress effects; nested system never overrides reduction. Without snap,
scroll normally; without joint timelines/range/scope, Cover Flow stays flat and
Scroll Indicator neutral. Without CSS, complete content remains in document
order. Forced colors preserves meaning and suppresses decorative depth/fill.
Finite effects can finish offscreen. Stationary scroll sources do not advance
scroll-driven decoration; there is no document-time substitute or polling.

## Images and application responsibility

Use atom-keyed records: stable `key`, safe `src`, explicit `alt`, positive integer
`width`/`height`; optional `caption`, `href`, `name`, width-candidate `srcset` plus
`sizes`, `loading` and `decoding`. Meaningful images need meaningful alt;
decorative intent requires `decorative: true`, empty alt and an independent name.
Defaults are lazy/async. Full records carry their own source and dimensions.
Loading/decoding are browser hints, never a network or authorization guarantee.

Only root-relative and HTTP(S) sources/destinations are accepted. Validation is
not an origin allowlist or CSP policy. Applications own rights, privacy,
bandwidth, responsive selection correctness, requests, permissions, names,
captions and navigation. Failed images retain text and destinations. No image
processing, download service, remote CSS assets or mutable data ships.

Checkbox, dialog and scroll state are browser-local snapshots. Replacement may
reset them or replay entrances; applications own patch boundaries and restoration.
No application state, listeners, observers, timers, framework hooks, dragging,
persistence, animation controller or media loading shim is included.

## Provenance and verification

All six mappings use reviewed unscripted/ui revision
`bd8f403030c8d1f46804da6eda733fde7e908e63`; the complete MIT notice remains in
`THIRD_PARTY_NOTICES.md`. `priv/provenance/unscripted_ui.json` records upstream
paths and local changes. Native composition, finite budgets and guards are local
adaptations, not a claim of identical upstream behavior. There is no automatic
upstream synchronization or runtime dependency.

The [CSS exception ledger](https://github.com/pcharbon70/shadcn_ui/blob/main/assets/engineering/motion-media-css-exceptions.md) covers five component
CSS files and shared suppression. Image Gallery reuses Dialog and static
utilities. The demo's three original SVGs have licenses, dimensions, bytes and
hashes in `demo/priv/media/fixtures.json`; they are not upstream artwork and are
excluded from the archive. No new CSS exception is added in Phase 6.

Exact-engine probes, HEEx fixtures, deterministic export and archive audits are
separate from manual screen-reader/physical-device review, CI and publication.
Versions record observations, not a brand-based support policy. See the repository
`release/records/milestone-e-acceptance.md` for candidate evidence. Milestone F remains
separate; this work does not authorize Hex publication.
