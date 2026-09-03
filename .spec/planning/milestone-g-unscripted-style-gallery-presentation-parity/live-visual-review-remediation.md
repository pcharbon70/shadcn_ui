# Milestone G Supplemental Plan - Live Visual Review Remediation

Back to wave: [README](./README.md)

## Status and purpose

This open supplemental plan addresses the desktop, narrow-width, interaction
and evidence defects found during the 2026-09-02 live visual review. It does not
rewrite the completed implementation history of Phases 1 through 7 or claim
that Phase 8 publication and manual acceptance are complete.

The stable comparison is the local Accordion route
`/components/disclosure/accordion` against the accepted pinned unscripted/ui
revision `bd8f403030c8d1f46804da6eda733fde7e908e63`. The moving public site is a
diagnostic aid only. `/components/foundation` remains the stable Foundation
category route and is not an Accordion comparison target.

## Boundaries preserved

- Keep native `details` and `summary`, exclusive `name` grouping, ordinary
  anchors, native radio Preview/Code selection and deterministic Phoenix IDs.
- Keep the mobile catalogue as a native disclosure. Do not add dialog, menu,
  focus-trap or background-inert claims merely to imitate the upstream mobile
  presentation.
- Keep ShadcnUI branding, compile-checked HEEx, the independent Accordion
  specimen and authored capability evidence.
- Keep package CSS prefixed and scoped, with no unrestricted reset, consumer
  Tailwind requirement or package JavaScript.
- Keep demo-only theme, search, fragment synchronization and copy helpers out
  of component behavior and package release contents.
- Update an accepted decision or current-truth subject before implementation
  only if pinned evidence requires a durable boundary change.
- Do not merge, deploy, tag, replace reviewed evidence or close Phase 8 without
  the corresponding authorization and recorded proof.

## Review issue map

| ID | Review finding | Planned owner | R6 disposition |
| --- | --- | --- | --- |
| VR-01 | Foundation category was used as the Accordion comparison route | R1, R5 | Fixed |
| VR-02 | Mobile navigation clips its final destination and can focus it offscreen | R3 | Fixed |
| VR-03 | Accordion summaries overflow their item boxes by about 31px | R2 | Fixed |
| VR-04 | Accordion has no visible closed/open chevron | R2 | Fixed |
| VR-05 | A direct Code fragment can leave Preview announced as selected | R3 | Fixed |
| VR-06 | The explicit demo reduced-motion mode does not suppress Accordion motion | R2, R3 | Fixed |
| VR-07 | Row borders, gaps, padding, answer color, hover treatment and timing differ from the pinned target | R1, R2, R4 | Fixed with reviewed exceptions |
| VR-08 | Mobile shell density delays the primary specimen by several viewports | R4 | Fixed |
| VR-09 | Heading, description measure, specimen treatment and primary FAQ copy contain undocumented drift | R1, R4 | Fixed with reviewed exceptions |
| VR-10 | Local goldens do not provide a rendered pinned-upstream comparison | R5 | Fixed |
| VR-11 | Manual accessibility remains pending under a scoped risk acceptance; reviewed deployment evidence remains open | R6 | Manual risk accepted for R6 progression; reviewed deployment blocking |

## Ordered remediation phases

| Phase | Delivery | Dependency |
| --- | --- | --- |
| R1 - Baseline And Ownership | Reconcile every observation with pinned source, classify package versus gallery ownership and add failing proof for confirmed defects. | Current branch evidence |
| R2 - Accordion Package Correctness | Fix summary geometry, disclosure affordance and motion without changing native semantics or CSS isolation. | R1 |
| R3 - Gallery Navigation And Specimen State | Fix mobile destination reachability, fragment/radio consistency and the demo motion control. | R1; may proceed alongside R2 |
| R4 - Pinned Presentation Alignment | Align the primary Accordion article, specimen and responsive shell while recording intentional exceptions. | R2 and R3 |
| R5 - Deterministic Visual Evidence | Establish a real pinned-reference comparison and harden route, geometry and visual regressions. | R4 |
| R6 - Accessibility And Fly Requalification | Complete manual review, full regression, reviewed merge/deployment and post-deploy evidence. | R5 |

## R1 - Baseline And Ownership

- [x] R1 Phase - Reconcile the live review with accepted pinned truth.

  Convert observations into reproducible local defects and explicit decisions
  before changing shared package or gallery presentation.

  - [x] R1.1 Section - Freeze the remediation comparison matrix.

    Use the pinned source, existing manifest and accepted semantic exceptions
    rather than treating current upstream pixels as a new specification.

    - [x] R1.1.1 Task - Record the correct routes, states and measurements.

      Make every later comparison repeatable and prevent category/component
      route confusion.

      - [x] R1.1.1.1 Subtask - Identify `/components/disclosure/accordion` as the Accordion target and retain `/components/foundation` as a category route.
      - [x] R1.1.1.2 Subtask - Record expected light/dark states at 1440x1200, 1024x1366, 390x844 and 320x568 with scale 1, reduced motion and deterministic assets.
      - [x] R1.1.1.3 Subtask - Capture pre-fix geometry for header, mobile panel, final navigation link, article introduction, specimen, details item, summary and focus outline.

    - [x] R1.1.2 Task - Classify each difference by ownership.

      Shared component defects belong to package code; shell and documentation
      defects remain gallery-only; semantic differences remain documented.

      - [x] R1.1.2.1 Subtask - Classify summary sizing, focus containment, chevron and component motion as package-owned unless fixture evidence disproves reuse.
      - [x] R1.1.2.2 Subtask - Classify mobile navigation, search placement, article density, specimen controls, fragment state and documentation copy as gallery-owned.
      - [x] R1.1.2.3 Subtask - Decide whether flat divided rows are the package default or a primary-specimen presentation modifier, and record the reason.
      - [x] R1.1.2.4 Subtask - Align the primary FAQ copy with the pinned component-focused example unless an explicit local content exception is accepted.

  - [x] R1.2 Section - Add defect-first regression coverage.

    New assertions must fail for the reviewed reason before implementation and
    must use stable semantic or `data-*` hooks rather than cosmetic classes.

    - [x] R1.2.1 Task - Add geometry and reachability regressions.

      Lock the user-visible failures without prematurely blessing replacement
      screenshots.

      - [x] R1.2.1.1 Subtask - Assert each summary border box and scroll width remain within its details item at 320px, 390px, desktop and 200 percent zoom.
      - [x] R1.2.1.2 Subtask - Assert the mobile panel's final ordinary destination can be scrolled fully into the visual viewport and remains visible when keyboard-focused.
      - [x] R1.2.1.3 Subtask - Assert focus outlines are not clipped by the details item, specimen or mobile panel.

    - [x] R1.2.2 Task - Add state and preference regressions.

      Direct addressing and inspection preferences need explicit outcomes in
      addition to screenshot coverage.

      - [x] R1.2.2.1 Subtask - Assert direct Preview and Code fragments never expose a contradictory selected radio state when demo scripting is available.
      - [x] R1.2.2.2 Subtask - Assert fragment destinations and both authored regions remain reachable with JavaScript and presentation CSS disabled.
      - [x] R1.2.2.3 Subtask - Assert OS reduced motion and the explicit `data-shadcn-motion="reduce"` inspection state suppress Accordion transitions while preserving open state and content.

  - [x] R1.3 Section - R1 Integration Tests.

    Confirm the baseline is reproducible and that no normative contract was
    changed by planning or test scaffolding.

    - [x] R1.3.1 Task - Review the failing proof and SpecLed impact.

      Baseline tests should fail narrowly and all unrelated suites should stay
      green.

      - [x] R1.3.1.1 Subtask - Run the focused Accordion, shell, specimen and narrow-width browser tests and retain the expected pre-fix failures.
      - [x] R1.3.1.2 Subtask - Run `mix spec.next` and update a decision or current-truth subject only if the ownership audit reveals a real contract change.
      - [x] R1.3.1.3 Subtask - Review the diff for accidental golden replacement, moving-site dependence or changes to completed milestone checkboxes.

## R2 - Accordion Package Correctness

- [x] R2 Phase - Correct reusable Accordion geometry and visual affordance.

  Fix the package-level defects using scoped styles and native disclosure state,
  without adding a second interaction model.

  - [x] R2.1 Section - Contain summary and focus geometry.

    Width utilities and padding must resolve inside the item border even when
    no consumer reset supplies global `border-box` sizing.

    - [x] R2.1.1 Task - Apply component-scoped border-box sizing.

      Preserve the no-global-reset and BulmaUI coexistence contract.

      - [x] R2.1.1.1 Subtask - Add a prefixed utility or exact Accordion selector so summary width includes its inline padding and border.
      - [x] R2.1.1.2 Subtask - Verify long summaries wrap without inline overflow in LTR and RTL.
      - [x] R2.1.1.3 Subtask - Verify focus outlines remain fully visible at narrow width, 200 percent zoom and forced colors.

  - [x] R2.2 Section - Restore the disclosure affordance and accepted motion.

    The visual indicator is decorative; native expanded state and activation
    remain authoritative.

    - [x] R2.2.1 Task - Add an open-state chevron.

      Match the pinned shape, position and rotation without adding hidden text,
      duplicate controls or scripted state.

      - [x] R2.2.1.1 Subtask - Render a CSS-generated logical-end chevron with sufficient contrast in light, dark and forced-colors modes.
      - [x] R2.2.1.2 Subtask - Rotate it from closed to open using the native `[open]` state and keep it out of the accessibility tree.
      - [x] R2.2.1.3 Subtask - Remove or retain native marker styling only where it has a visible fallback purpose; do not produce duplicate indicators.

    - [x] R2.2.2 Task - Reconcile component transition behavior.

      Pinned timing may be adapted through component-scoped values, but reduced
      motion must always win.

      - [x] R2.2.2.1 Subtask - Align reveal, opacity and chevron timing/easing with the R1 pinned measurement or record the token-based exception.
      - [x] R2.2.2.2 Subtask - Make the Accordion a recognized motion root or add an exact ancestor suppression rule for explicit none/reduce states.
      - [x] R2.2.2.3 Subtask - Preserve instant native disclosure when animation capabilities are missing.

  - [x] R2.3 Section - Align reusable row presentation where approved.

    Apply only the R1 package-owned portion of borders, spacing, hover and text
    treatment; leave article-specific composition in R4.

    - [x] R2.3.1 Task - Implement the accepted default or modifier contract.

      Avoid a gallery override that accidentally changes every consumer, and
      avoid retaining unexplained drift in the primary example.

      - [x] R2.3.1.1 Subtask - Implement the accepted contiguous dividers or preserve rounded items behind an explicit documented presentation choice.
      - [x] R2.3.1.2 Subtask - Align summary padding, minimum target size, answer foreground and hover underline without relying on color alone.
      - [x] R2.3.1.3 Subtask - Verify caller classes, themes and consumer token overrides remain effective.

  - [x] R2.4 Section - R2 Integration Tests.

    Prove the component fix through package fixtures, compiled CSS and real
    gallery rendering.

    - [x] R2.4.1 Task - Run package and browser acceptance.

      The generated asset and semantic contract must remain deterministic.

      - [x] R2.4.1.1 Subtask - Run Accordion rendering tests, stylesheet tests, the native fixture suite and Milestone C acceptance.
      - [x] R2.4.1.2 Subtask - Run narrow, zoom, RTL, forced-colors, reduced-motion, CSS-disabled and no-script Accordion browser states in both themes.
      - [x] R2.4.1.3 Subtask - Run the locked asset build/check, package archive audit and BulmaUI coexistence coverage.
      - [x] R2.4.1.4 Subtask - Run `mix spec.next`, `mix spec.check --base HEAD` and `git diff --check` before section delivery.

## R3 - Gallery Navigation And Specimen State

- [x] R3 Phase - Correct gallery-only responsive navigation and view state.

  Keep native disclosure and radio semantics while removing clipped content and
  contradictory presentation state.

  - [x] R3.1 Section - Make mobile navigation fully reachable.

    The panel must use the actual wrapped header and dynamic viewport rather
    than a fixed assumed header height.

    - [x] R3.1.1 Task - Bound the panel to remaining viewport space.

      Safe-area padding, browser chrome changes and zoom must not conceal the
      final destination.

      - [x] R3.1.1.1 Subtask - Replace the fixed 4.5rem viewport reservation with layout derived from the header's actual block size or an equivalent robust containment strategy.
      - [x] R3.1.1.2 Subtask - Preserve internal scrolling, overscroll containment and visible focus at 320px, 390px, 200 percent zoom and wrapped-theme-control states.
      - [x] R3.1.1.3 Subtask - Verify every destination, including the final composition link, can be completely revealed by pointer, touch and keyboard navigation.
      - [x] R3.1.1.4 Subtask - Retain non-modal native disclosure semantics and document the intentional accessibility-tree difference from upstream's dialog.

  - [x] R3.2 Section - Make direct specimen fragments and radios agree.

    A URL-addressed panel must not coexist with a contradictory announced
    selection, while no-script and CSS-disabled access remain complete.

    - [x] R3.2.1 Task - Implement one authoritative gallery view-state bridge.

      Use only demo presentation behavior and do not turn it into component
      state or a client router.

      - [x] R3.2.1.1 Subtask - On initial load and `hashchange`, synchronize a recognized specimen Preview/Code fragment with its native radio or suppress the contradictory selector while the target is authoritative.
      - [x] R3.2.1.2 Subtask - Define how radio changes clear or replace an incompatible fragment without breaking history, focus or direct links.
      - [x] R3.2.1.3 Subtask - Keep unknown fragments inert and restrict lookup to closed authored specimen identities.
      - [x] R3.2.1.4 Subtask - Verify no-script direct fragments expose the addressed content and never depend on JavaScript for reachability.

  - [x] R3.3 Section - Connect the explicit motion inspection state.

    The demo's Reduce control must exercise the same component outcome promised
    by OS reduced motion.

    - [x] R3.3.1 Task - Apply the authored motion preference to Accordion.

      Keep the preference declarative and ancestor-scoped.

      - [x] R3.3.1.1 Subtask - Verify `data-shadcn-motion="reduce"`, package motion-none and `prefers-reduced-motion` all remove Accordion reveal and chevron transitions.
      - [x] R3.3.1.2 Subtask - Verify returning to system motion restores only capability-gated presentation and never changes open state.
      - [x] R3.3.1.3 Subtask - Add exact computed-style assertions instead of relying only on screenshots.

  - [x] R3.4 Section - R3 Integration Tests.

    Exercise responsive navigation and specimen state across progressive
    enhancement boundaries.

    - [x] R3.4.1 Task - Run shell and gallery interaction acceptance.

      Component semantics must remain independent of gallery helpers.

      - [x] R3.4.1.1 Subtask - Run mobile navigation, keyboard, focus, zoom, axe, theme, search, direct-fragment and source-view browser suites.
      - [x] R3.4.1.2 Subtask - Run JavaScript-disabled, CSS-disabled, print and unknown-fragment states.
      - [x] R3.4.1.3 Subtask - Verify demo helpers remain excluded from the package archive and deterministic static export.
      - [x] R3.4.1.4 Subtask - Run `mix spec.next`, `mix spec.check --base HEAD` and `git diff --check`.

## R4 - Pinned Presentation Alignment

- [x] R4 Phase - Align the Accordion article and shell with pinned presentation.

  Resolve the remaining visual drift after correctness fixes, using the pinned
  source rather than measurements from a later public-site revision.

  - [x] R4.1 Section - Align the primary Accordion specimen.

    The exclusive example should resemble the accepted reference while the
    independent example continues to document the additional local contract.

    - [x] R4.1.1 Task - Tune rows, content and specimen treatment.

      Use the R1 ownership decision to avoid leaking article-only styling into
      unrelated consumers.

      - [x] R4.1.1.1 Subtask - Match accepted row grouping, separators, radii, gaps, padding, summary weight, muted answers, hover treatment and open-state color.
      - [x] R4.1.1.2 Subtask - Match accepted specimen measure, preview padding, toolbar treatment and source surface while retaining HEEx and native radios.
      - [x] R4.1.1.3 Subtask - Replace the undocumented primary FAQ copy with pinned component-focused questions or record an approved content exception.
      - [x] R4.1.1.4 Subtask - Keep the independent multi-open specimen clearly secondary and semantically unchanged.

  - [x] R4.2 Section - Align typography and first-viewport density.

    Compact presentation must not remove required content, ordinary links or
    capability truth.

    - [x] R4.2.1 Task - Restore pinned article metrics.

      Lock exact wrapping in the deterministic reference environment.

      - [x] R4.2.1.1 Subtask - Apply the 60ch component-description measure and reconcile title, lead, body, heading and code typography with pinned metrics.
      - [x] R4.2.1.2 Subtask - Reconcile article, specimen and sidebar widths, gaps and padding at desktop and tablet breakpoints.
      - [x] R4.2.1.3 Subtask - Retain local support, ownership and provenance content below the primary experience without treating the longer article as a component defect.

    - [x] R4.2.2 Task - Reduce narrow-width discovery delay.

      The title and primary specimen should appear promptly without deleting
      search, breadcrumb, capability or navigation access.

      - [x] R4.2.2.1 Subtask - Move or collapse mobile search into the native catalogue disclosure so a closed menu does not consume the article's first viewport.
      - [x] R4.2.2.2 Subtask - Compact wrapped header controls, breadcrumb and introductory capability presentation at 320px and 390px.
      - [x] R4.2.2.3 Subtask - Set pinned bounds for title and first-item vertical positions and verify them in both themes.
      - [x] R4.2.2.4 Subtask - Ensure the current component is discoverable in desktop and mobile catalogue navigation without adding a client router.

  - [x] R4.3 Section - Review visible exceptions.

    Presentation may align closely while policy and component semantics remain
    truthfully local.

    - [x] R4.3.1 Task - Preserve and document intentional differences.

      Do not erase local identity to improve a screenshot score.

      - [x] R4.3.1.1 Subtask - Retain ShadcnUI branding, HEEx source, native mobile disclosure, native radio semantics and authored capability policy.
      - [x] R4.3.1.2 Subtask - Style capability and source surfaces consistently without copying live visitor support claims or upstream zero-JavaScript branding.
      - [x] R4.3.1.3 Subtask - Update the exception ledger only for reviewed differences with a semantic, content, accessibility or branding reason.

  - [x] R4.4 Section - R4 Integration Tests.

    Lock the adjusted presentation without conflating moving-site similarity
    with accepted pinned parity.

    - [x] R4.4.1 Task - Run article and responsive acceptance.

      Stable geometry and wrapping assertions precede golden refreshes.

      - [x] R4.4.1.1 Subtask - Run Accordion article, specimen, catalogue, shell and complete-migration tests.
      - [x] R4.4.1.2 Subtask - Run light/dark desktop, tablet, 390px and 320px geometry assertions with motion suppressed.
      - [x] R4.4.1.3 Subtask - Run keyboard, axe, zoom, forced-colors, print, CSS-disabled and no-script checks before reviewing visual diffs.
      - [x] R4.4.1.4 Subtask - Run deterministic export, `mix spec.next`, `mix spec.check --base HEAD` and `git diff --check`.

## R5 - Deterministic Visual Evidence

- [x] R5 Phase - Replace self-referential confidence with pinned comparison evidence.

  Keep local goldens for regression, but add a reproducible representation of
  the accepted upstream state so local drift cannot approve itself.

  - [x] R5.1 Section - Establish a renderable pinned reference.

    Resolve the previously blocked upstream build without making verification
    depend on network access or a moving deployment.

    - [x] R5.1.1 Task - Produce the smallest licensed deterministic reference harness.

      Prefer the pinned upstream build when reproducible; otherwise render the
      reviewed shell and Accordion fixture from checked pinned inputs.

      - [x] R5.1.1.1 Subtask - Reproduce and diagnose the recorded npm exit-handler failure using the pinned toolchain and immutable dependency inputs.
      - [x] R5.1.1.2 Subtask - If the full build remains unavailable, create a checked reference-only fixture from the reviewed pinned files with preserved MIT/OFL notices and no runtime dependency.
      - [x] R5.1.1.3 Subtask - Hash source identity, assets, tool versions, fonts, viewport, theme, motion, open state and scroll position in the reference manifest.
      - [x] R5.1.1.4 Subtask - Keep reference-only code, fonts and captures outside the package archive.

  - [x] R5.2 Section - Capture and compare the accepted matrix.

    Remote public pages may be inspected manually but never become automated
    test inputs.

    - [x] R5.2.1 Task - Generate reference and local visual evidence.

      Geometry and focus invariants complement bounded pixel comparison.

      - [x] R5.2.1.1 Subtask - Capture reference and local states at 1440x1200, 1024x1366, 390x844 and 320x568 in light and dark with motion suppressed.
      - [x] R5.2.1.2 Subtask - Compare shell, current navigation, title, description, specimen frame, Accordion rows, chevrons, focus, code and responsive reflow within accepted tolerances.
      - [x] R5.2.1.3 Subtask - Review every over-tolerance diff and either fix it or attach a specific accepted exception; reject unexplained bulk golden replacement.

    - [x] R5.2.2 Task - Close route and coverage gaps.

      Visual evidence must identify category pages and component pages
      separately.

      - [x] R5.2.2.1 Subtask - Add a dedicated Foundation category state instead of treating its representative Button page as category coverage.
      - [x] R5.2.2.2 Subtask - Assert the Accordion comparison and pilot evidence always use `/components/disclosure/accordion`.
      - [x] R5.2.2.3 Subtask - Add direct find-in-page coverage for open and closed Accordion content without introducing scripted disclosure ownership.

  - [x] R5.3 Section - R5 Integration Tests.

    Prove the evidence itself is deterministic, licensed and reviewable.

    - [x] R5.3.1 Task - Re-run visual and distribution gates.

      Two identical inputs must produce identical reference metadata, local
      assets and export output.

      - [x] R5.3.1.1 Subtask - Regenerate representative captures twice and verify stable hashes or documented platform-bounded raster variance.
      - [x] R5.3.1.2 Subtask - Run full Milestone G visual, functional, catalogue, provenance, asset-license, archive and deterministic-export suites.
      - [x] R5.3.1.3 Subtask - Update evidence state from unavailable only after the rendered pinned comparison exists and has been reviewed.
      - [x] R5.3.1.4 Subtask - Run `mix spec.next`, `mix spec.check --base HEAD` and `git diff --check`.

## R6 - Accessibility And Fly Requalification

- [ ] R6 Phase - Resolve accessibility disposition and requalify the corrected deployment.

  Automated parity and accessibility evidence supplement rather than replace
  bounded manual review, reviewed merge and deployed smoke. The release owner
  accepted the risk of deferring manual review for R6 progression on 2026-09-03;
  the waiver does not complete that gate or qualify the candidate.

  - [x] R6.1 Section - Record the scoped manual-accessibility risk acceptance.

    Preserve the unexecuted status of every scenario and the separate final
    qualification gate while allowing the owner-authorized remediation work to
    continue.

    - [x] R6.1.1 Task - Document the bypass without promoting evidence.

      Record the missing human environments, affected workflows, scope of the
      accepted risk and the claims that remain blocked.

      - [x] R6.1.1.1 Subtask - Record that Accordion keyboard and desktop screen-reader review was not executed and remains pending.
      - [x] R6.1.1.2 Subtask - Record that 320px and 390px mobile navigation review with representative mobile assistive technology was not executed and remains pending.
      - [x] R6.1.1.3 Subtask - Record that announced-state review for Preview/Code controls, direct fragments, copy feedback and headings was not executed and remains pending.
      - [x] R6.1.1.4 Subtask - Record that human review of 200 percent zoom, forced colors, reduced motion, no-script and CSS-disabled fallbacks in both themes was not executed and remains pending.

  - [x] R6.2 Section - Run complete release regression.

    A presentation repair must not weaken package, consumer, catalogue,
    provenance or publication contracts.

    - [x] R6.2.1 Task - Execute all local qualification gates.

      Retain complete diagnostics and resolve failures rather than updating
      evidence around them.

      - [x] R6.2.1.1 Subtask - Run package and demo precommit suites, all A-G tests, locked browser engines, visual comparisons and pinned axe.
      - [x] R6.2.1.2 Subtask - Run deterministic CSS, package archive, clean-consumer, two-export, route, fragment, sitemap and release-evidence checks.
      - [x] R6.2.1.3 Subtask - Run `mix spec.next`, `mix spec.check --base HEAD`, formatting checks and `git diff --check` with zero errors.
      - [x] R6.2.1.4 Subtask - Reconcile the issue map so every VR item is fixed, explicitly accepted or still reported as blocking.

  - [ ] R6.3 Section - Review, publish and smoke the corrected gallery.

    Deployment remains separate from local success and uses the existing Fly
    publication and rollback policy.

    - [ ] R6.3.1 Task - Complete reviewed delivery.

      Do not promote unreviewed local output to public acceptance.

      - [ ] R6.3.1.1 Subtask - Commit coherent sections, open the reviewed remediation pull request and require green CI before authorized merge.
      - [ ] R6.3.1.2 Subtask - Deploy the reviewed revision through the accepted Fly workflow and retain the prior reviewed artifact for rollback.
      - [ ] R6.3.1.3 Subtask - Smoke the canonical Accordion route, Foundation category, mobile navigation, themes, direct Preview/Code fragments, assets, health, version and error handling on Fly.
      - [ ] R6.3.1.4 Subtask - Re-run the critical 320px navigation and Accordion geometry checks against the deployed revision and record content hashes.

  - [ ] R6.4 Section - R6 Integration And Acceptance.

    Close the supplemental plan and original Phase 8 only when evidence states
    support those claims independently.

    - [ ] R6.4.1 Task - Record final remediation truth.

      Planning completion alone cannot promote manual, CI, merge, deployment or
      rollback status.

      - [ ] R6.4.1.1 Subtask - Record fixed issue IDs, accepted exceptions, commands, revisions, hashes, visual results, manual observations, workflow run and deployed smoke.
      - [ ] R6.4.1.2 Subtask - Update original Phase 8 checkboxes and milestone status only for evidence that actually exists.
      - [ ] R6.4.1.3 Subtask - Leave any unresolved reachability, focus, semantic, reduced-motion or pinned-parity failure as an explicit deployment blocker.

## Completion criteria

This remediation plan is complete only when:

1. Every Accordion summary and focus outline is contained at all locked widths
   and zoom states.
2. Every mobile catalogue destination is fully reachable and visibly focused.
3. The Accordion has a clear, contrast-safe, reduced-motion-safe disclosure
   affordance while retaining native semantics.
4. Preview/Code fragments, selected state and no-script access are consistent.
5. The primary Accordion presentation matches pinned evidence within accepted
   tolerances or has a specific reviewed exception.
6. A rendered pinned-reference comparison exists alongside local regression
   goldens, including distinct category and component route coverage.
7. Package, browser, accessibility, deterministic-export, provenance and
   archive gates pass.
8. Manual accessibility, reviewed merge, Fly deployment and post-deploy smoke
   are recorded as separate evidence states. A scoped owner-approved waiver may
   allow remediation delivery to proceed, but it does not satisfy manual
   accessibility or final candidate qualification.

## Delivery rule

Complete and verify each remediation phase before beginning its dependent
phase. R2 and R3 may proceed in parallel after R1 because they own separate
package and gallery surfaces. Use one coherent commit per completed section and
one reviewed pull request for the complete remediation unless delivery is later
explicitly split. Do not merge or deploy without a separate authorized request.
