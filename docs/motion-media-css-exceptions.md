# Motion/media authored CSS exception ledger

## E-04 — bounded Stagger entrance

Source: assets/stagger.css and Motion.Stagger. Reviewed pinned upstream
stagger/basic.html at bd8f403030c8d1f46804da6eda733fde7e908e63 (2026-08-26).
This local adaptation omits toggle-to-hide and unbounded sibling-index delays.
Namespaced fade/rise keyframes and direct-child focus cancellation need authored
CSS. Effects opt in behind animation support and no-preference; baseline opacity
is one, lowest animated opacity is 0.5. Fixed internal numeric timing properties
come only from closed validated presets. Delay plus duration never exceeds one
second, excess items do not animate. No fill, repeat, observer or viewport state.
Removing CSS or focusing an item restores opacity one and identity transform.
E-01 suppression overrides the rules and cannot be undone by nested system.
There are no colors or theme-specific declarations; native focus/forced colors
survive. Semantic wrappers and caller content are never cloned or reordered.
Tests: Stagger rendering and actual-HEEx three-engine motion assertions,
including focused inputs, interrupted CSS and fresh-render replay/reset.

## E-03 — finite Marquee preview

Source: assets/marquee.css and Motion.Marquee. Adapted from pinned upstream
marquee/basic.html and loop.css at bd8f403030c8d1f46804da6eda733fde7e908e63,
reviewed 2026-08-26; existing MIT notice retained. Complete static lists wrap.
The direct-child checkbox :has gate, clone lifecycle and namespaced keyframes
need authored CSS rather than repeated arbitrary utilities. Joint :has, :dir,
transform and animation queries plus no-preference expose the hidden native
control. Two closed presets are 2.5s and 5s, one iteration, no delay/fill/repeat.
Canonical travel and one inert, aria-hidden duplicate finish at identical content;
completion removes travel and duplicate visibility. Unchecking cancels both.
The duplicate has native hidden for CSS-disabled output and no interactive
content or IDs. Logical directions follow LTR/RTL; colors/borders/radius use
scoped tokens and native forced colors. E-01 suppression wins for every part.
Unsupported CSS retains all content and omits the unavailable preview control.
Tests: Marquee rendering, actual-HEEx motion fixture and locked three-engine
milestone-e-motion.spec.mjs; deterministic compiled asset checks.

## E-01 — visible baseline and suppression

Source: [assets/motion-media.css](../assets/motion-media.css).
Independently authored; upstream review pin and decisions are recorded in
[motion-media-foundations](./motion-media-foundations.md). No upstream site
assets or runtime are copied.

Utility composition cannot express the cross-component ancestor suppression
contract cleanly without repeating it in every component. Opt-in
data-shadcn-ui-motion and data-shadcn-ui-motion-part markers reserve this
boundary. Only marked motion presentation is affected, never arbitrary caller
content or document-wide defaults. A marked clone is hidden initially; future
Marquee may enable it only in its bounded preview gate. Native hidden plus inert
and aria-hidden are still required for clones without CSS.

Guard: static baseline needs no modern feature query. Operating-system reduced
motion, an ancestor data-shadcn-motion=reduce, or a motion root set to none
removes animation, transition, transform (including individual transforms) and
smooth scrolling. Nested system roots cannot opt back in. Content remains
opaque and clones remain hidden. Suppression is deliberately important so
enhancement utilities cannot override it. Future animation parts/pseudo-elements
must use this same suppression contract and receive dedicated tests.

Tokens: only --shadcn-ui-ring for visible focus, with a system-color fallback.
Existing light/dark and sRGB tokens are untouched. Forced colors uses Highlight.
There are no new keyframes, anchors, timelines, URLs or global resets. Future
blocks must add rationale, feature bundles, fallback, namespace, provenance and
test mapping here before distribution.

Verification: milestone-e-foundations browser tests exercise actual compiled
CSS, nested suppression, preference changes, independent instances, focus,
forced colors and CSS-disabled output; package asset checks reproduce bytes.

## E-02 — native Carousel layout

Source: [assets/carousel.css](../assets/carousel.css). Pinned adaptation:
unscripted/ui `src/demos/carousel/basic.html` at
`bd8f403030c8d1f46804da6eda733fde7e908e63`, reviewed 2026-08-26. The
`markers.css` source was reviewed but its generated controls are not copied.
Required MIT notice remains in THIRD_PARTY_NOTICES.md.

Snap/alignment and overflow use complete static prefixed utilities. The authored
family centralizes direct-child logical sizing, padding, index touch targets and
forced-color/focus treatment without repeated arbitrary-selector utilities.
Selectors are opt-in component markers, never global lists, links or resets.
Cards are bounded by default, but caller oversized content remains natively
scrollable; no block-size cap, clipping or scroll containment traps the user.
Sibling and nested roots do not inherit another instance's snap configuration.

No capability query is needed for baseline flex/overflow. Unsupported optional
scroll-snap declarations are ignored, preserving native scrolling. CSS-disabled
output retains its ordered list, focus targets and real links. Proximity is the
default; none and mandatory are explicit options. Child focus temporarily disables
snap so a focused control in an oversized card takes precedence over the card's
snap point. Smooth scrolling is suppressed
by E-01 under OS, ancestor or component reduction, without changing navigation.
No scrollbar hiding, generated controls, keyframes, timelines or runtime exists.
Card/foreground/border/ring/radius use scoped light/dark tokens; forced colors
retains native colors and visible outlines. Actual HEEx fixture, three-engine
Carousel tests, CSS isolation and deterministic asset checks provide proof.
