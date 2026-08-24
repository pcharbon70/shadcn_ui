# Phase 4 - Avatar and Skeleton Foundations

Back to wave: [README](./README.md)

- [ ] 4 Phase - Implement identity imagery and loading placeholders with
  meaningful fallbacks, honest accessibility, and reduced-motion behavior.

  This phase completes the foundation catalogue while avoiding image-event
  JavaScript, remote providers, and misleading loading announcements.

  - [ ] 4.1 Section - Avatar component.

    This section implements initials-first identity presentation with an optional
    caller-owned image layered as an enhancement.

    - [ ] 4.1.1 Task - Define the Avatar public API and fallback semantics.

      Avatar should keep an accessible text fallback in the DOM without relying
      on `onerror`, remote lookup, upload, or image-provider behavior.

      - [ ] 4.1.1.1 Subtask - Declare required escaped initials, optional image source and required nonblank alt when present, closed sizes, optional stack position, class, and supported globals.
      - [ ] 4.1.1.2 Subtask - Render initials as the stable baseline and layer the caller image without inline handlers or package image state.
      - [ ] 4.1.1.3 Subtask - Prevent duplicate accessible names between meaningful images, fallback text, and decorative stacked presentation.
      - [ ] 4.1.1.4 Subtask - Document caller ownership of image URLs, privacy, loading, failure policy, caching, upload, and identity records.

    - [ ] 4.1.2 Task - Implement Avatar presentation and tests.

      Fixed token-driven sizes and overlap should preserve circular cropping,
      focus-independent meaning, and fallback readability.

      - [ ] 4.1.2.1 Subtask - Implement initials, image overlay, closed size, ring, background, foreground, and bounded stack class mappings.
      - [ ] 4.1.2.2 Subtask - Test initials-only, image-enhanced, missing invalid combinations, escaped initials, meaningful alt, globals, sizes, and stack presentation.
      - [ ] 4.1.2.3 Subtask - Assert no onerror, remote provider, upload, random color, or package-owned image lifecycle enters markup or dependencies.
      - [ ] 4.1.2.4 Subtask - Add provenance coverage for the adapted upstream Avatar markup.

  - [ ] 4.2 Section - Skeleton component.

    This section implements a decorative placeholder that communicates shape
    visually without claiming to own or announce application loading state.

    - [ ] 4.2.1 Task - Define the Skeleton public API and accessibility boundary.

      Skeleton should remain hidden from assistive technology and require the
      caller to label any meaningful loading region separately.

      - [ ] 4.2.1.1 Subtask - Declare closed rectangle/circle/text shape guidance, bounded size guidance, pulse presentation, class, and passive supported globals.
      - [ ] 4.2.1.2 Subtask - Render deterministic `aria-hidden="true"` and reject caller role, live-region, label, and interactive semantics.
      - [ ] 4.2.1.3 Subtask - Document caller ownership of loading detection, announcements, replacement timing, errors, and content layout.

    - [ ] 4.2.2 Task - Implement Skeleton presentation and tests.

      Shape and pulse classes should use semantic muted tokens and become calm
      static blocks under reduced motion.

      - [ ] 4.2.2.1 Subtask - Implement fixed shape, size, radius, muted color, and pulse class mappings.
      - [ ] 4.2.2.2 Subtask - Add reduced-motion CSS that removes pulse without hiding the placeholder or changing its dimensions.
      - [ ] 4.2.2.3 Subtask - Test every shape and size, caller classes, protected hidden semantics, deterministic output, and absence of loading lifecycle behavior.
      - [ ] 4.2.2.4 Subtask - Add provenance coverage for the adapted upstream Skeleton markup.

  - [ ] 4.3 Section - Phase 4 Integration Tests.

    This section proves Avatar and Skeleton fallbacks and completes package-level
    integration coverage for all six foundation components.

    - [ ] 4.3.1 Task - Run identity-and-loading rendering integration tests.

      Fixtures should demonstrate meaningful identity, decorative stacking, and
      caller-labelled loading regions without component-owned behavior.

      - [ ] 4.3.1.1 Subtask - Render initials, image-enhanced, stacked, and content-loading compositions through `use ShadcnUI`.
      - [ ] 4.3.1.2 Subtask - Assert alt/fallback treatment, hidden Skeleton semantics, dimensions, globals, escaping, and caller-owned labels.
      - [ ] 4.3.1.3 Subtask - Run the complete six-component public import, metadata, dependency, provenance, and release-content audit.

    - [ ] 4.3.2 Task - Run identity-and-loading browser and asset integration tests.

      Browser evidence should verify broken or delayed imagery, contrast, motion
      preferences, responsive stacks, and stylesheet completeness.

      - [ ] 4.3.2.1 Subtask - Exercise image unavailable presentation, initials readability, stack overlap, light/dark themes, narrow widths, zoom, forced colors, and reduced motion.
      - [ ] 4.3.2.2 Subtask - Rebuild the stylesheet and verify Avatar and Skeleton classes, token references, and reduced-motion output.
      - [ ] 4.3.2.3 Subtask - Run `mix precommit`, the Phase 4 integration suite, `mix spec.check --base main`, and `git diff --check`.
