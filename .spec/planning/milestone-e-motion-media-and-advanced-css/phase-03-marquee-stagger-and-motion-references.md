# Phase 3 - Marquee, Stagger, And Motion References

Back to wave: [README](./README.md)

## Dependencies and contracts

Requires Phase 1 suppression, finite budgets, structured media records and demo fixtures; retains Phase 2 catalogue additions.

- [motion_media_contract](../../specs/motion_media_contract.spec.md)
- [motion_components](../../specs/motion_components.spec.md)
- [motion_media_gallery](../../specs/motion_media_gallery.spec.md)

- [x] 3 Phase - Marquee, Stagger, And Motion References.

  Publish bounded decorative motion with static defaults, explicit native opt-in/stop controls and duplicate-content safety, together with real Motion reference pages.

  - [x] 3.1 Section - Static-first Marquee with finite native preview.

    Implement a deliberate finite-preview adaptation rather than an endless autoplay ticker.

    - [x] 3.1.1 Task - Implement the Marquee API and canonical content.

      Structured presentation inputs allow safe duplication without cloning arbitrary interactive HEEx.

      - [x] 3.1.1.1 Subtask - Add Motion.Marquee.marquee/1 with required id/name/items, static/preview modes, logical directions and closed duration presets capped at five seconds.
      - [x] 3.1.1.2 Subtask - Render one complete canonical list of escaped text and optional images; validate stable keys, image metadata and noninteractive content before rendering.
      - [x] 3.1.1.3 Subtask - In preview mode add a visible labelled unnamed native checkbox, initially unchecked, with complete stop/reset/replay instructions and no falsely synchronized playing indicator.

    - [x] 3.1.2 Task - Implement bounded preview and safe duplicate rendering.

      Decoration must not create extra accessible content or perpetual work.

      - [x] 3.1.2.1 Subtask - Use at most one aria-hidden inert duplicate track without IDs, links, actions, form fields or meaningful duplicate alt; keep it hidden by default and in CSS-disabled/static/reduced paths.
      - [x] 3.1.2.2 Subtask - Gate preview on the necessary native/CSS capabilities; unchecking restores static content, checking replays one finite traversal, and completion leaves the readable canonical list.
      - [x] 3.1.2.3 Subtask - Test explicit stop after focus leaves, interruption and suppression; do not substitute hover-only pause, automatic restart, infinite iteration or a visibility observer.

  - [x] 3.2 Section - Bounded Stagger with visible content baseline.

    Entrance presentation may decorate content but must not delay access to it or create viewport state.

    - [x] 3.2.1 Task - Implement keyed Stagger composition.

      The component should preserve caller semantics and arbitrary trusted item content without cloning it.

      - [x] 3.2.1.1 Subtask - Add Motion.Stagger.stagger/1 with keyed item slots and closed none/fade/rise effects; default to none and preserve explicit semantic wrapper choices.
      - [x] 3.2.1.2 Subtask - Map bounded interval/duration presets without arbitrary CSS input; cap the total sequence window to one second and show all excess items immediately.
      - [x] 3.2.1.3 Subtask - Preserve native links/forms and DOM order; reject invalid values and duplicate keys while forwarding unrelated safe globals and classes.

    - [x] 3.2.2 Task - Implement interruption, focus and suppression behavior.

      No unsupported or interrupted effect may leave a real control invisible.

      - [x] 3.2.2.1 Subtask - Start from fully visible content and add finite scoped animation only when opted in and motion is permitted; never wait for an observer or viewport-enter event.
      - [x] 3.2.2.2 Subtask - Ensure focus reveals an item immediately and styles removed mid-animation restore visible content; reject perpetual animations and auto-hiding final keyframes.
      - [x] 3.2.2.3 Subtask - Document render-time replay and replacement reset; record CSS exceptions and avoid claiming animation-once or offscreen pausing.

  - [x] 3.3 Section - Motion category, preferences composition and guidance.

    Expose both new controls and their motion safety boundaries in the actual demo.

    - [x] 3.3.1 Task - Publish Marquee and Stagger references.

      Users should be able to inspect static defaults and deliberately enable bounded effects.

      - [x] 3.3.1.1 Subtask - Append Motion to the closed catalogue and add /components/motion/marquee and /components/motion/stagger with complete routing/export/canonical/sitemap coverage.
      - [x] 3.3.1.2 Subtask - Demonstrate normal/long/translated text, optional local images, static/preview Marquee, stop/reset/replay, Stagger effects and interrupted/focused content.
      - [x] 3.3.1.3 Subtask - Create /examples/motion-preferences with native controls and system/reduce links preserving theme; explain that system still respects the operating-system preference.

    - [x] 3.3.2 Task - Document limits, API and provenance.

      Describe finite motion honestly instead of presenting a restricted adaptation as an endless ticker.

      - [x] 3.3.2.1 Subtask - Publish all attrs, slots, required labels, clone restrictions, finite budgets, CSS/no-script fallbacks and complete HEEx source.
      - [x] 3.3.2.2 Subtask - Explain reduced motion versus persistent stop, canonical versus decorative content, caller replacement ownership and the absence of state synchronization.
      - [x] 3.3.2.3 Subtask - Update capability observations only from tests, CSS exception entries, pinned adaptations and notices; keep all demonstration helpers outside the package.

  - [x] 3.4 Section - Phase 3 Integration Tests.

    Prove bounded motion, accessible duplication and visible content under all suppression and failure conditions.

    - [x] 3.4.1 Task - Verify native controls, timing and accessibility.

      Check real finite effects rather than inferring safety from an animation-duration string.

      - [x] 3.4.1.1 Subtask - Add Marquee/Stagger rendering tests for metadata, keys, finite presets, invalid inputs, escaping, globals, clone IDs/roles/focusables, one canonical accessible list and semantic item order.
      - [x] 3.4.1.2 Subtask - Add milestone-e-motion.spec.mjs for native checkbox opt-in/stop/reset/replay, no autoplay, completed/stopped/offscreen finite budgets, interruption, focused items and replacement.
      - [x] 3.4.1.3 Subtask - Use actual computed styles and bounded-time assertions; cover reduced motion, nested suppression, missing :has, CSS-disabled/no-script, themes, RTL, forced colors, zoom and axe plus explicit clone accessibility checks.

    - [x] 3.4.2 Task - Verify gallery, assets and regressions.

      The motion phase must not weaken earlier semantics or introduce a runtime.

      - [x] 3.4.2.1 Subtask - Run package/demo precommit, deterministic assets/fixtures/export, subpath smoke and current catalogue reference completeness checks.
      - [x] 3.4.2.2 Subtask - Audit no infinite keyframes or runtime code, no hidden required information, namespaced CSS, pinned provenance, ExDoc and actual archive exclusions.
      - [x] 3.4.2.3 Subtask - Run locked three-engine motion and prior affected suites, SpecLed and whitespace checks; record observed limits and commit each completed section.

## Section delivery rule

Complete and verify each section before committing it. Make one commit per
section and one PR for this phase; do not merge that PR without a later request.
Keep all checkboxes unchecked until the corresponding implementation and proof
land. Update relevant specifications only after reading their full contracts.

## Execution record

Implemented 2026-08-26 after merging PR #15, fast-forwarding main to
f18f9898d4f6057f2b2609587e9ba1cad2b996af and verifying main/origin synchronization
before deleting the old feature branch locally and remotely. Existing untracked
demo server logs were preserved. Delivery uses one commit per section.

- Section 3.1: static complete structured Marquee list, required name/identity,
  closed 2.5s/5s presets and logical directions. Native unchecked unnamed
  checkbox enables one traversal, unchecking stops/resets and checking replays.
  One inert aria-hidden duplicate contains no IDs/actions/controls and is hidden
  before/after/interrupted/suppressed/CSS-disabled previews. Verified with 341
  package tests and 12 initial three-engine motion checks before its commit.
- Section 3.2: keyed trusted Stagger slots, explicit div/ul/ol wrappers,
  none/fade/rise effects and fixed quick/default numeric timings. Total window
  is at most one second, excess content is immediate, focus cancels effects,
  interruption restores visible content and fresh render may replay. Verified
  with 345 package tests and 18 motion checks before its commit.
- Section 3.3: appended Motion category with only implemented Marquee/Stagger
  leaves, dedicated references and a real motion-preferences composition.
  Local images, native reset controls, translated/RTL and long content, complete
  compile-tested source, API/fallback/ownership guidance and theme-preserving
  system/reduce links ship together. Verified with 53 demo tests and deterministic
  export/subpath checks over 594 variants before its commit.
- Section 3.4: actual live and static-subpath integration, computed finite
  timing, active-clone accessibility exclusion, keyboard/touch, no-script,
  CSS-disabled and disabled-capability paths, RTL, nested/system suppression,
  focus, replacement, light/dark axe audits and narrow/200% CSS zoom coverage.
  Added CI and release-archive gates; visual review corrected Marquee's radius
  reference to the existing radius-md token and added a regression assertion.

Test-harness corrections are explicit: offscreen Chromium animation state is
sampled with computed styles at regular intervals; lazy images are scrolled
into view before loading assertions; no-script fixture CSS is loaded as markup,
not via the script-dependent style-injection helper. No retries, skipped tests,
capability-record edits or package runtime shims were used to conceal failures.
The generated motion fixture canonicalizes only Stagger opening-tag attribute
order because dynamic_tag serializes globals maps differently across compiler
builds. Every attribute/value and all component content are retained; repeated
dev/test generation is checked rather than treating map order as semantics.

Verification limits: exact engine locks are evidence, not consumer targets.
Touch coverage is native checkbox activation, not physical-device certification.
Zoom is CSS zoom at 200%, not browser-chrome zoom certification. Windows reports
eperm for symlink creation; the existing Linux CI rejection test remains required.
Automated axe/semantics and screenshot review do not replace manual screen-reader
testing. No Pages deployment or Hex publication is claimed by local verification.

SpecLed prime/next/check ran. The full check reports the same four nested-command
failures (component/form/package precommit and gallery smoke), with 149 warnings.
The login shell selects Elixir 1.18.0 instead of direct PowerShell Elixir 1.20.3;
dependency compilation fails under the existing OTP mismatch. Direct equivalents
pass. The generated state file is excluded from this change and no gate is waived.
Shared CSS/README coverage makes spec.next flag earlier subjects broadly; only
the motion, gallery, stylesheet, provenance and package contracts change.

Direct final verification:

- Package precommit: 347 tests; demo precommit: 53 tests.
- Motion browser suite: 45 checks; E foundations: 60; Carousel: 39;
  Milestone D gallery: 39; baseline/demo: 11; Milestone C gallery: 5.
- Exact three-engine capability evidence unchanged; package/demo asset checks
  pass, as do repeated dev/test fixture generation, two identical exports,
  export audits and static subpath smoke (594 route variants, three selected
  code/style assets and three manifest-listed media fixtures).
- ExDoc builds without warnings; actual Hex candidate audit verifies 58 entries,
  including both new defining modules and excluding all demo/test machinery.
- Whitespace checks pass. No dependencies, generated SpecLed state, build output
  or user logs are included in the phase commits.

Milestone E remains incomplete: Phase 4 (Scroll Indicator and Cover Flow), Phase 5
(Image Gallery) and Phase 6 (final acceptance) remain pending.
