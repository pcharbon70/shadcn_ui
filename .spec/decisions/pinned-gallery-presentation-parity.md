---
id: shadcn_ui.pinned_gallery_presentation_parity
status: accepted
date: 2026-08-28
affects:
  - shadcn_ui.gallery
  - shadcn_ui.gallery_presentation
  - shadcn_ui.content_navigation_gallery
  - shadcn_ui.documentation_catalogue
  - shadcn_ui.public_documentation
  - shadcn_ui.compatibility_accessibility
  - shadcn_ui.provenance
  - shadcn_ui.release_publication
---

# Pin Gallery Presentation Parity and Preserve Semantic Truth

## Context

The complete gallery is functionally authoritative but visually reads as a
catalogue assembled across milestones. The unscripted/ui documentation site has
a coherent presentation grammar that fits the intended public reference: a
compact header, constrained documentation grid, persistent catalogue, display
typography, paired preview and source specimens, capability badges and nearby
fallback evidence.

The moving public site cannot be a reproducible implementation input. Its
branding, analytics, live visitor detection, remote resources and some widget
claims also conflict with ShadcnUI's accepted Phoenix, semantic, accessibility
and package boundaries. Screenshot resemblance therefore cannot decide what
the gallery says or how a component behaves.

## Decision

Milestone G targets high-fidelity presentation parity with the reviewed
unscripted/ui commit
`bd8f403030c8d1f46804da6eda733fde7e908e63`, reviewed on 2026-08-28.
The repository is <https://github.com/timoransky/unscripted-ui>; the public
reference is <https://unscripted.janci.dev/>. The implementation inputs are the
pinned source, checked local evidence and manifest, not the moving public URL.

The reviewed documentation inputs are:

- `src/layouts/BaseLayout.astro` and `src/layouts/DocsLayout.astro`;
- `src/components/Header.astro`, `Sidebar.astro` and `MobileNav.astro`;
- `src/components/ComponentPreview.astro`, `CodeBlock.astro`,
  `SupportBadge.astro` and `SupportTable.astro`;
- `src/pages/components/[slug].astro`, `src/data/nav.ts` and
  `src/styles/global.css`;
- `src/content/components/accordion.mdx` and
  `src/demos/accordion/basic.html` for the vertical pilot.

Later upstream changes require a new reviewed commit, updated local evidence,
license and provenance review, and an explicit accepted change. No job or
dependency may synchronize the gallery automatically.

### Presentation target and tolerance

Reference evidence covers light and dark states at CSS-pixel viewports
1440x1200, 1024x1366, 390x844 and 320x568, device scale factor 1, with motion
suppressed and deterministic local assets. The 1440 state is the primary desktop
geometry reference; 1024 records the collapse boundary; 390 and 320 record the
complete narrow navigation and article reflow.

The pinned source establishes these initial authored metrics: a 56px header, a
1152px maximum shell, 20px inline page padding, a 220px desktop catalogue, a
40px desktop grid gap, an article measure no wider than 72ch, and a sticky
catalogue offset below the header. ShadcnUI may change a metric only when the
checked evidence records an intentional semantic, content, zoom, overflow or
branding exception.

Locked same-platform visual comparison uses both stable geometry assertions and
pixel evidence. Critical shell and focus geometry has a 2px tolerance; repeated
spacing, radii and type boxes have a 2px tolerance; the complete image may differ
in at most 0.75 percent of pixels at a per-channel threshold of 0.12. Text must
wrap identically in the locked reference environment. Cross-engine acceptance
checks semantics and reflow separately and does not pretend that font rasterizing
is pixel-identical across engines or operating systems.

### Local identity and semantic exceptions

ShadcnUI branding, Phoenix HEEx examples, closed catalogue data and accepted
native contracts remain authoritative. The gallery must not copy unscripted/ui
branding or claim that the demo ships zero JavaScript. Capability policy comes
from authored catalogue data and locked evidence; live CSS detection may only
supplement it and may not become a visitor-specific support promise.

Upstream `Tabs` presentation remains ShadcnUI Radio Panels. Dropdown Actions
remains ordinary links and buttons rather than an ARIA menu. Carousel and Cover
Flow remain named native scrollable lists rather than selection widgets.
Supplemental surfaces, overlays and every other intentionally different local
contract retain their accepted names, roles, keyboard behavior and fallbacks.
Differences are documented rather than concealed to improve screenshots.

The mobile catalogue uses a native `details` disclosure with an honest
"Navigation" name and complete ordinary links. CSS may present it as a bounded
panel whose available block size follows the actual wrapped header and dynamic
viewport, but no dialog, menu, focus trap or invoker-command claim is made. The
open disclosure remains in document order and operable without demo JavaScript.
Unlike the upstream dialog presentation, its accessibility tree intentionally
remains a native disclosure followed by ordinary named navigation landmarks.

Preview and Code use a labelled native radio group as presentation selection,
with no tablist, tab or tabpanel roles. Both addressable regions remain in source
order and become visible when the enhancement CSS is absent. Direct fragments,
printing and no-script access cannot depend on the selected radio snapshot.
A demo-only view-state bridge maps only the server-authored specimen region
identities: recognized Preview or Code fragments synchronize the corresponding
native radio without moving focus, and a conflicting radio change replaces only
that specimen's fragment in the current history entry. Unknown fragments remain
inert. This narrow reconciliation is neither package state nor a client router.
Documentation headings and view controls are gallery presentation, not component
API. Cross-milestone acceptance therefore targets stable article/specimen hooks
and scopes component-control assertions to the rendered preview; visible section
labels may evolve without weakening the underlying guidance or native contract.

The server-rendered motion inspection choice remains a declarative
`data-shadcn-motion` ancestor. Explicit Reduce, a component's package motion-none
scope and the operating-system preference all suppress Accordion reveal and
chevron transitions without changing native `open` state. System removes only
the explicit suppression and never promises or forces animation when the
platform capability or operating-system permission is absent.

Deterministic syntax highlighting, if used, runs only over closed authored HEEx
at the demo build or server-render boundary and emits escaped static markup.
There is no browser tokenizer, remote asset, dynamic evaluator or package
runtime. Optional source-copy feedback remains demo-only.

The accepted Accordion pilot applies this policy with two separately identified
specimens: the pinned-reference-style exclusive FAQ is primary, and an
independent group with multiple initially open items documents the additional
public mode. Its checked support rows distinguish native `details` operation,
exclusive `name` grouping, `::details-content` and `interpolate-size`; missing
grouping remains independent and missing or reduced animation remains instant.
The locked-engine run proves those outcomes for the recorded builds without
turning the builds into browser-brand support targets. This article, specimen,
support, ownership and provenance structure is accepted as the migration
template for later catalogue phases.

The Remediation R4 review accepts the pinned Accordion questions and support
copy as the primary specimen content, a 30px article title and compact 14px
introductory prose, and the pinned dark source surface in both gallery themes.
At narrow widths component search belongs inside the same native navigation
disclosure as its results, so the closed state does not add a separate search
control above the article. These are presentation and content decisions only:
the independent Accordion remains a separate local specimen, authored support
metadata remains authoritative, and no richer navigation or component widget
contract is introduced. The reviewed exception ledger and refreshed hashes for
all affected locked goldens are repository evidence for this accepted local
alignment.

### Assets, provenance and evidence ownership

Gallery fonts, icons, source highlighting and captures are local, hash-pinned,
licensed and excluded from the package archive. The reviewed upstream uses a
self-hosted Bricolage Grotesque variable font and identifies it as SIL Open Font
License 1.1. Phase 1 must retain the applicable OFL text and binary identity
before Phase 3 may add the font; otherwise the documented system fallback is
the accepted result. Icons are authored local SVG or semantic text and cannot
load from a remote runtime.

Substantially adapted upstream documentation markup or CSS is recorded against
the pinned commit and remains covered by the retained unscripted/ui MIT notice.
Analytics, upstream site scripts, branding, artwork, deployment assumptions and
remote imports are excluded.

Reference evidence belongs to this repository. Its manifest records the
upstream commit and paths, capture tool and version, viewport, scale, theme,
motion, font and asset hashes, open state, scroll position and content identity.
Reviewed evidence changes only with an explicit upstream review or an accepted
intentional local exception; timestamps and machine-specific paths do not enter
deterministic artifacts.

## Consequences

Milestone G can be reviewed against a stable visual target without outsourcing
component truth to screenshots or a live website. Presentation assets and
evidence add demo maintenance and license duties but cannot leak into the
package. The Accordion pilot may resemble the pinned source closely while still
demonstrating ShadcnUI's independent and exclusive native modes, HEEx API,
fallbacks and application ownership accurately.
