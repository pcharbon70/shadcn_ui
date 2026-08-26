# Image Gallery and native lightboxes

`Media.ImageGallery.image_gallery/1` is imported by `use ShadcnUI`. Supply a
unique `id`, exactly one `accessible_label` or `labelledby` (existing heading
IDs), and nonempty `images`. An optional escaped `description` names its own
derived description node. `class` and unrelated globals survive; required
identities and semantics cannot be overridden.

Each atom-keyed record has a unique string `key`, safe `src`, explicit `alt`,
and positive integer `width`/`height`. Optional fields: `name`, escaped `caption`,
`href`, width-candidate `srcset` plus `sizes`, `loading: :lazy | :eager` (lazy),
`decoding: :async | :sync | :auto` (async). Decorative records require
`decorative: true`, empty alt and an independent name. Full metadata is optional:
`full: %{src: ..., width: ..., height: ..., srcset: [...], sizes: ...}`.
Full presentation otherwise reuses the supplied thumbnail source and metadata.
No source, dimensions, alternative text or responsive candidates are inferred.

Closed values are `columns: :two | :three | :four` (three),
`density: :compact | :comfortable` (comfortable), `fit: :cover | :contain`
(cover, thumbnails only), `motion: :system | :none` (system), and
`lightbox: :dialog | :none` (dialog). Narrow containers collapse to one column.
Full images always contain within the viewport; captions remain complete in
the existing Dialog's native scroll container with its sticky close footer.

Optional repeated `caption` slots require an existing unique image `key` and
override the plain caption. Trusted presentation-only HEEx receives
`%{key: key, context: :thumbnail | :full}`. It renders in both places; scope IDs
with the context and do not include controls, dialogs, scripts or stateful content.
The library cannot sanitize or infer the meaning of trusted HEEx.

Every dialog is initially closed and has a derived instance/item base ID, native
show-modal invoker, visible title, description and explicit `close_label` (Close
image). `initial_focus: :auto | :content | :close` and
`dismissal: :close_request | :none | :any` retain the existing Dialog contract.
Declare `context: :dialog` when inside a modal; only `lightbox: :none` is accepted
there. The library cannot discover an ancestor modal from a function component.
The thumbnail image is hidden from the button's accessible name, which uses the
visible “Enlarge name” text; the complete image retains the meaningful alt.

The browser owns modality, inertness, Tab/Escape, close and focus restoration.
Keyboard activation restores the previously focused invoker. Pointer focus
differs by platform: a browser that does not focus a clicked button may restore
the previous focus instead. Tab can visit browser chrome without entering the
inert page. No package focus trap, listeners or client state are installed.

The separate visible ordinary link uses `href`, then `full.src`, then `src`.
It remains usable without native commands, scripts or CSS. A broken image keeps
alt, name, caption and destination; no loader claims success or failure.
Native loading and decoding are hints, **not guaranteed deferred fetching**.
Applications own media rights, privacy, CSP/origin policy, URL authorization,
destinations, responsive accuracy and restoration/reinvocation after replacement.
There are no uploads, transforms, remote galleries, slideshow state, next/previous,
swipe, zoom, pan, image fetching services or server integration.

## Origin-effect decision

The optional upstream-style thumbnail-origin effect is **deferred** for this
release. `scripts/record-gallery-origin.mjs --check` and the Phase 5 browser suite
probe scoped anchors and discrete transitions on actual generated thumbnail /
Dialog pairs, not just `CSS.supports`. The locked Chromium starts at the thumbnail;
Firefox and WebKit parse anchor/discrete declarations but produce no origin
transition in this experiment. The demo-only `image_gallery_evidence.json`
records exact versions and observations. All three use the existing native snap
Dialog in the shipped package. No experiment CSS, measured-coordinate assignment
or view-transition JavaScript is distributed. Revisit only with joint opening,
closing, interruption, accessibility and motion-suppression evidence.

Reviewed upstream `gallery.mdx` / `gallery/basic.html` at
`bd8f403030c8d1f46804da6eda733fde7e908e63`; the full MIT notice is retained.
This adaptation adds semantic figures, validated metadata, captions, explicit
close and destinations, and rejects remote site artwork and optional command
shims. Demo images remain the original hash-pinned local fixture manifest, with
its existing rights notices. Only prefixed static utilities and existing Dialog
CSS ship; no new authored CSS exception is necessary.

References: [CSS anchor positioning](https://drafts.csswg.org/css-anchor-position-1/)
and [native Dialog](https://html.spec.whatwg.org/multipage/interactive-elements.html#the-dialog-element).
