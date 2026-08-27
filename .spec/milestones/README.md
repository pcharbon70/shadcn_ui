# ShadcnUI milestones

These milestones define the proposed delivery sequence for ShadcnUI. They turn
the package from an empty Mix library into an independently consumable HEEx
component system with a public online gallery.

The milestones are ordered because later interaction and visual work depends on
the package, form, semantic, compatibility, and gallery foundations established
earlier. The gallery begins in Milestone A and grows with every milestone rather
than appearing only at the end.

1. [Milestone A - Package, Styling, and Gallery Foundation](./milestone-a-package-styling-and-gallery-foundation.md)
2. [Milestone B - Native Forms and Validation](./milestone-b-native-forms-and-validation.md)
3. [Milestone C - Disclosure, Navigation, and Content Surfaces](./milestone-c-disclosure-navigation-and-content-surfaces.md)
4. [Milestone D - Native Overlays and Interactive Surfaces](./milestone-d-native-overlays-and-interactive-surfaces.md)
5. [Milestone E - Motion, Media, and Advanced CSS](./milestone-e-motion-media-and-advanced-css.md)
6. [Milestone F - Online Gallery, Documentation, and Release Acceptance](./milestone-f-online-gallery-documentation-and-release-acceptance.md)
7. [Milestone G - Unscripted-Style Gallery Presentation Parity](./milestone-g-unscripted-style-gallery-presentation-parity.md)

## Shared boundaries

- ShadcnUI renders semantic HEEx and owns component attributes, slots, class
  mappings, package CSS, and documented accessibility behavior.
- Applications own domain state, authorization, routes, requests, navigation,
  persistence, and business commands.
- Dstar, Datastar, LiveView application processes, Ash, and Electron APIs remain
  outside the package.
- Tailwind CSS is a package-local build tool, not a consumer runtime dependency.
- The released package should ship compiled, isolated CSS and no component
  JavaScript unless an accepted later decision introduces a small optional
  compatibility module.
- New platform features must have an explicit supported-browser contract and an
  honest fallback.
- Substantially adapted upstream source retains the required MIT notice and a
  pinned provenance record.

## From milestones to implementation plans

Before a milestone is implemented, its unresolved decisions and current-truth
specifications must be authored. A separate phased plan can then divide the
milestone into phases, sections, tasks, subtasks, and phase-ending integration
tests. Creating that plan does not itself complete the milestone.
