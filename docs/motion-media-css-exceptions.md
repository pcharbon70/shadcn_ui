# Motion/media authored CSS exception ledger

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
