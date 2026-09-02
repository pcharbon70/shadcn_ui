# Milestone G Requirement Coverage Map

This map assigns every additive presentation requirement to implementation and
concrete proof. All planned targets exist and final local evidence reports no
planning-only target, but the map does not promote local proof to CI, manual
review, reviewed merge, deployment, or post-deployment evidence.

| Requirement | Owning phase | Primary planned proof |
| --- | --- | --- |
| `gallery_presentation.pinned_reference` | 1 | checked decision, reference manifest and Phase 1 acceptance tests |
| `gallery_presentation.visual_evidence` | 1, 3, 5, 8 | reference-manifest validation, locked presentation comparisons and reviewed goldens |
| `gallery_presentation.local_assets` | 1, 3, 8 | OFL/provenance audit, deterministic asset tests and archive exclusion |
| `gallery_presentation.semantic_exceptions` | 1, 5, 7, 8 | decision audit, Accordion pilot assertions and final semantic acceptance |
| `gallery_presentation.shell` | 2 | `test/browser/milestone-g-shell.spec.mjs` geometry and responsive states |
| `gallery_presentation.progressive_navigation` | 2 | keyboard, no-script, mobile disclosure, search and route coverage |
| `gallery_presentation.presentation_system` | 3 | `test/browser/milestone-g-presentation.spec.mjs` and gallery selector/asset audit |
| `gallery_presentation.specimen_semantics` | 3, 4 | native radio, fragment, print, CSS-disabled and no-script specimen coverage |
| `gallery_presentation.article_hierarchy` | 4, 5, 7 | article schema tests, Accordion pilot and complete route migration audit |
| `gallery_presentation.catalogue_metadata` | 6 | `demo/test/milestone_g_catalogue_test.exs` closed-schema and completeness proof |
| `gallery_presentation.stable_identity` | 2, 4, 7 | controller/export route, canonical, breadcrumb and fragment regressions |
| `gallery_presentation.accessibility_matrix` | 2, 3, 5, 7, 8 | locked browser suites, pinned axe and explicit manual evidence states |
| `gallery_presentation.deterministic_distribution` | 1, 2, 3, 7, 8 | package archive audit, two exports, subpath smoke and final acceptance |
| `gallery_presentation.complete_migration` | 7, 8 | complete catalogue/route audit and `test/shadcn_ui/milestone_g_acceptance_test.exs` |

Every affected phase also reruns existing package, semantic, accessibility,
catalogue, deterministic-export, provenance and publication requirements from
Milestones A through F. Phase 8 alone owns final local reconciliation and may not
promote it to CI, deployment, post-deployment or manual completion without the
corresponding evidence.
