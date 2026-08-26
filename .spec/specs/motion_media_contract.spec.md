# Shared motion, media, and capability contract

```spec-meta
id: shadcn_ui.motion_media_contract
kind: policy
status: active
summary: Implemented Phase 1 capability and normalization foundations; component-specific acceptance follows in later phases.
decisions:
  - shadcn_ui.motion_media_capability_css
  - shadcn_ui.bounded_motion
  - shadcn_ui.responsive_media_lightbox
surface:
  - docs/image-gallery.md
  - scripts/record-gallery-origin.mjs
  - test/browser/support/gallery-origin-probe.mjs
  - test/shadcn_ui/image_gallery_integration_test.exs
  - test/browser/support/scroll-media-fallback.mjs
  - test/shadcn_ui/scroll_media_integration_test.exs
  - priv/compatibility/motion_media.json
  - priv/compatibility/motion_media.schema.json
  - docs/motion-media-foundations.md
  - docs/motion-media-css-exceptions.md
  - test/browser/support/motion-media-probe.mjs
  - test/browser/support/static-motion-media.mjs
  - test/shadcn_ui/motion_media_manifest_test.exs
  - test/shadcn_ui/motion_media_foundations_integration_test.exs
  - playwright.milestone-e-phase1.config.mjs
  - lib/shadcn_ui/components/media/media_contract.ex
  - lib/shadcn_ui/components/motion/motion_contract.ex
  - assets/shadcn_ui.css
  - test/shadcn_ui/motion_media_contract_test.exs
```

## Public boundary and delivery status

This is the accepted contract for planned Milestone E implementation, not a
claim that its APIs exist today. The six defining modules and their gallery
pages land in the linked phase plan. Existing A–D APIs remain compatible.

Phase 1 implements the capability manifest/schema, recorded platform probes,
and internal normalization. Phase 2 implements Carousel using these identities
and suppression rules. Phase 3 implements Marquee and Stagger using the closed
finite timing presets and suppression rules. Phase 4 implements source-local
Scroll Indicator and image-only Cover Flow using encoded scoped timelines;
Phase 5 implements responsive Image Gallery using existing native Dialog and
ordinary destinations, and defers optional origin CSS after actual-modal probes.
Actual component outcomes remain demo-only
and are recorded separately from declaration probes.
Responsive srcset input is a list of
src/positive-width maps with unique widths and a nonblank sizes string; density
descriptors and raw srcset strings are not accepted. Native loading defaults to
lazy and decoding to async. Protected globals are removed before required
component attributes are emitted; unrelated caller globals remain intact.

Internal MediaContract and MotionContract helpers normalize closed values,
stable keys and image metadata. Do not add a public generic animation engine or
image service. Functions remain Phoenix components with defining-module attr
and slot metadata; ordinary caller classes and safe unrelated globals survive.

## Shared values

Media entries use stable nonblank string keys; reject duplicate keys before
rendering. Image records contain src, explicit alt, positive integer width and
height, optional srcset/sizes, caption and destination. Full-size records carry
their own dimensions and source when different. Decorative intent must be
explicit and cannot remove the name of an enclosing link or button. Preserve
caller-requested loading (lazy/eager), decoding (auto/sync/async) and native
responsive selection without fetching or inferring values.

Motion preference is system (default) or none. The documented ancestor scope
data-shadcn-motion="reduce" suppresses effects, and prefers-reduced-motion always
wins. An inner component cannot re-enable motion beneath suppression. Validate
finite durations through closed presets, not arbitrary style strings. The
shared timeline/anchor namespace must prevent sibling instance interference.

## Capability and CSS evidence

The planned motion_media.json/schema separate required native capabilities,
optional CSS bundles and deferred features. Record scroll snap, :has control
gating, scroll()/view() timelines, animation-range/timeline-scope where used,
3D transforms, scoped anchor/origin features and inherited Dialog commands.
Generated buttons/markers are recorded as deferred. A true CSS.supports result
never automatically admits generated controls or certifies focus behavior.

The CSS exception ledger is authored beside the asset documentation and linked
to the specific source blocks. Consumers receive only the compiled isolated
CSS. Tests and demo observations are not release inputs.

## Requirements

```spec-requirements
- id: shadcn_ui.motion_media_contract.capability_manifest
  statement: An authored manifest and schema shall identify reviewed authoritative sources, date, component capability bundles, admission status, exact locked three-engine evidence versions and an explicit fallback for each optional feature.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_contract.runtime_boundary
  statement: Motion and media components shall ship no JavaScript, framework hook, listener, observer, timer, client state, image fetching service or consumer-specific target.
  priority: must
  stability: stable

- id: shadcn_ui.motion_media_contract.identity
  statement: Shared normalization shall reject blank or duplicate stable keys and invalid native relationship inputs, derive deterministic instance-scoped IDs, and never create atoms from caller strings.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_contract.media_values
  statement: Media normalization shall validate explicit alternative-text intent, nonblank sources, positive intrinsic dimensions, closed loading/decoding values and known responsive metadata while preserving caller ownership of all image content.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_contract.safe_sources
  statement: Media and destination fields shall reject executable, data and unsupported URL schemes and malformed known inputs without fetching URLs, accepting raw HTML or interpolating untrusted values into CSS.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_contract.protected_globals
  statement: Required identities, native element types, names, descriptions, cloning exclusions and motion suppression shall override conflicting globals while preserving unrelated documented caller attributes and classes.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_contract.motion_preference
  statement: System reduced motion, explicit motion=none and an ancestor data-shadcn-motion=reduce scope shall suppress nonessential animation, transforms and smooth scrolling without hiding content or disabling native operations.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_contract.css_exceptions
  statement: Every authored CSS exception shall document its rationale, scope, capability guard, fallback, tokens, motion behavior, provenance and tests, with namespaced selectors, keyframes, anchors and timelines and no global reset or remote asset.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_contract.replacement
  statement: Browser-local scroll, checkbox and dialog state shall remain unsynchronized snapshots that may reset after DOM replacement, with restoration and patch boundaries owned by applications.
  priority: must
  stability: evolving

- id: shadcn_ui.motion_media_contract.distribution
  statement: The release shall include component sources, compiled CSS and normative manifests but exclude demo images, fixture manifests, observations, harnesses, scripts, generated exports and application dependencies.
  priority: must
  stability: stable
```

## Verification

The manifest, normalization and foundation browser targets now exist; the final
milestone acceptance target remains planned. The [Milestone E plan](../planning/milestone-e-motion-media-and-advanced-css/README.md)
assigns their implementation phases. Missing targets remain visible in SpecLed
until implemented; no placeholder passing test or disabled gate substitutes for
actual proof. Add requirement references in each target as the tests land.

```spec-verification
- kind: test_file
  target: test/shadcn_ui/image_gallery_integration_test.exs
  covers:
    - shadcn_ui.motion_media_contract.runtime_boundary
    - shadcn_ui.motion_media_contract.css_exceptions
    - shadcn_ui.motion_media_contract.distribution

- kind: test_file
  target: test/shadcn_ui/scroll_media_integration_test.exs
  covers:
    - shadcn_ui.motion_media_contract.runtime_boundary
    - shadcn_ui.motion_media_contract.css_exceptions
    - shadcn_ui.motion_media_contract.distribution

- kind: test_file
  target: test/shadcn_ui/motion_media_manifest_test.exs
  covers:
    - shadcn_ui.motion_media_contract.capability_manifest

- kind: test_file
  target: test/shadcn_ui/motion_media_contract_test.exs
  covers:
    - shadcn_ui.motion_media_contract.identity
    - shadcn_ui.motion_media_contract.media_values
    - shadcn_ui.motion_media_contract.safe_sources
    - shadcn_ui.motion_media_contract.protected_globals
    - shadcn_ui.motion_media_contract.motion_preference
    - shadcn_ui.motion_media_contract.replacement

- kind: test_file
  target: test/shadcn_ui/milestone_e_acceptance_test.exs
  covers:
    - shadcn_ui.motion_media_contract.runtime_boundary
    - shadcn_ui.motion_media_contract.css_exceptions
    - shadcn_ui.motion_media_contract.distribution

- kind: test_file
  target: test/shadcn_ui/motion_media_foundations_integration_test.exs
  covers:
    - shadcn_ui.motion_media_contract.runtime_boundary
    - shadcn_ui.motion_media_contract.css_exceptions
    - shadcn_ui.motion_media_contract.distribution

- kind: test_file
  target: test/browser/milestone-e-capabilities.spec.mjs
  covers:
    - shadcn_ui.motion_media_contract.capability_manifest

- kind: test_file
  target: test/browser/milestone-e-foundations.spec.mjs
  covers:
    - shadcn_ui.motion_media_contract.motion_preference
    - shadcn_ui.motion_media_contract.css_exceptions
```
