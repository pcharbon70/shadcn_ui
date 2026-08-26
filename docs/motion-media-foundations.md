# Motion and media foundations

Phase 1 provides internal contracts and evidence, not six finished components.
Public Carousel, Marquee, Stagger, Scroll Indicator, Cover Flow and Image Gallery
arrive in the following phases. No new public import or component runtime ships.

## Capability review

The normative manifest and closed JSON schema are in
[priv/compatibility](../priv/compatibility/motion_media.json). The demo-only
[observations](../demo/priv/compatibility/motion_media_evidence.json) record exact
executed engines, declaration support and separate behavior probes. Probe
success is not component acceptance or accessibility certification.

Run `node scripts/record-motion-media-capabilities.mjs --check` and
`npm run browser:milestone-e-phase1`. To refresh, maintainers review source,
lock and fallback changes before running the recorder without `--check`.
The same native and disabled-feature fixtures run in all three engines.
Origin-aware geometry is deliberately unproven until Phase 5. Generated
controls remain deferred even when a declaration parses.

## Pinned upstream review — 2026-08-26

Repository: https://github.com/timoransky/unscripted-ui
Revision: `bd8f403030c8d1f46804da6eda733fde7e908e63`.
Paths below are relative to that revision. Existing MIT notices remain intact.
This phase independently authors policy, validators and probes, not copied
component source. Record actual component/CSS adaptation mappings when they land.

| Pattern | Reviewed paths | Local decision |
| --- | --- | --- |
| Carousel | `src/demos/carousel/basic.html`, `markers.css` | Retain native list/scroll; add real item links, visible scrolling and named focusable region; defer generated controls |
| Marquee | `src/demos/marquee/basic.html`, `loop.css` | Replace endless hover-paused loop with static default, finite native-controlled preview and inert noninteractive duplication |
| Stagger | `src/demos/stagger/basic.html` | Replace hide/toggle replay and unbounded sibling delays with optional bounded entrance and immediate focused/excess content |
| Scroll Indicator | `src/demos/scroll-indicator/basic.html`, `progress.css` | Keep decoration tied to its scroller; never describe it as proof of reading or completion; jointly gate required features |
| Cover Flow | `src/demos/cover-flow/basic.html`, `flow.css` | Compose Carousel; keep transformations off meaningful text and controls; flat fallback; no reflection requirement |
| Gallery | `src/demos/gallery/basic.html` | Reuse our Dialog with explicit close, complete destinations and caller image metadata; no hotlinked artwork; origin geometry requires new evidence |

The ADR-linked HTML and CSS source review is policy input, not a browser-version
support guarantee. The extracted library has no Electron or OS target.

## Internal normalization contract

MediaContract accepts atom-keyed image maps: a nonblank string key, root-relative
or HTTP(S) src, explicit alt intent and positive intrinsic width/height.
Decorative images require empty alt and an independent nonblank name.
Optional caption, href and full-size metadata remain caller-owned. Loading is
lazy/eager (lazy default); decoding is auto/sync/async (async default).

Responsive srcset input is a nonempty list of %{src: url, width: integer}
candidates with distinct positive widths and a nonblank sizes string. It emits
native width descriptors, not a package image service. Raw srcset strings,
density descriptors, credentials in URLs and unsupported schemes are rejected.
Sizes grammar and the truth of image dimensions/alt remain the caller's duty.
Full-size records contain their own source and dimensions. Metadata normalization
does not fetch images or promise request timing, privacy or authorization.

IDs encode both instance and key, so punctuation and Unicode cannot collide or
become selectors. Identity-bearing and media/motion globals are stripped before
required attributes are rendered; unrelated classes and framework globals remain.
Text is not converted to safe HTML: HEEx escapes it at the rendering boundary.

MotionContract accepts only :system/:none. Finite Marquee presets are :brief
(2500 ms) and :default (5000 ms). Stagger :quick/:default presets bound every
delay plus duration to 1000 ms; excess items receive an immediate static result.
The duration helpers do not introduce a timer or detect visibility.

Native scrolling, checkbox and Dialog state may reset on DOM replacement.
Applications own patch boundaries and restoration. Internal helpers are not
imported by use ShadcnUI and are not a public animation or media API.
