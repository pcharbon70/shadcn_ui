# Milestone E requirement delivery map

Back to [wave overview](./README.md).

This map assigns all 38 accepted requirements to delivery and proof phases.
The listed targets now exist. Phase 6 reruns the complete suite, including
earlier requirements, and adds the compiled public guide, full catalogue audit
and fixed 1/8/24-item browser budget proof. Existence is not a passing result:
see the phase execution and candidate records for commands, outcomes and open
manual, CI and publication gates. The historical SpecLed runner failure was
repaired during Milestone G.

## Shared motion, media, and capability contract

Contract: [motion_media_contract](../../specs/motion_media_contract.spec.md).

| Requirement ID | Delivery/proof phases | Planned proof targets |
| --- | --- | --- |
| `shadcn_ui.motion_media_contract.capability_manifest` | 1 | `test/shadcn_ui/motion_media_contract_test.exs`; `test/browser/milestone-e-capabilities.spec.mjs` |
| `shadcn_ui.motion_media_contract.runtime_boundary` | 1, 6 | `test/shadcn_ui/milestone_e_acceptance_test.exs` |
| `shadcn_ui.motion_media_contract.identity` | 1 | `test/shadcn_ui/motion_media_contract_test.exs` |
| `shadcn_ui.motion_media_contract.media_values` | 1 | `test/shadcn_ui/motion_media_contract_test.exs` |
| `shadcn_ui.motion_media_contract.safe_sources` | 1 | `test/shadcn_ui/motion_media_contract_test.exs` |
| `shadcn_ui.motion_media_contract.protected_globals` | 1 | `test/shadcn_ui/motion_media_contract_test.exs` |
| `shadcn_ui.motion_media_contract.motion_preference` | 1, 3, 4, 5 | `test/shadcn_ui/motion_media_contract_test.exs`; `test/browser/milestone-e-capabilities.spec.mjs` |
| `shadcn_ui.motion_media_contract.css_exceptions` | 1, 6 | `test/shadcn_ui/milestone_e_acceptance_test.exs` |
| `shadcn_ui.motion_media_contract.replacement` | 1, 3, 5 | `test/shadcn_ui/motion_media_contract_test.exs` |
| `shadcn_ui.motion_media_contract.distribution` | 1, 6 | `test/shadcn_ui/milestone_e_acceptance_test.exs` |

## Carousel, Cover Flow, and Image Gallery

Contract: [media_components](../../specs/media_components.spec.md).

| Requirement ID | Delivery/proof phases | Planned proof targets |
| --- | --- | --- |
| `shadcn_ui.media_components.carousel_structure` | 2 | `test/shadcn_ui/components/media/carousel_test.exs`; `test/browser/milestone-e-carousel.spec.mjs` |
| `shadcn_ui.media_components.carousel_controls` | 2 | `test/shadcn_ui/components/media/carousel_test.exs`; `test/browser/milestone-e-carousel.spec.mjs` |
| `shadcn_ui.media_components.carousel_layout` | 2 | `test/shadcn_ui/components/media/carousel_test.exs`; `test/browser/milestone-e-carousel.spec.mjs` |
| `shadcn_ui.media_components.cover_flow_composition` | 4 | `test/shadcn_ui/components/media/cover_flow_test.exs` |
| `shadcn_ui.media_components.cover_flow_enhancement` | 4 | `test/shadcn_ui/components/media/cover_flow_test.exs`; `test/browser/milestone-e-cover-flow.spec.mjs` |
| `shadcn_ui.media_components.gallery_figures` | 5 | `test/shadcn_ui/components/media/image_gallery_test.exs` |
| `shadcn_ui.media_components.gallery_dialog` | 5 | `test/shadcn_ui/components/media/image_gallery_test.exs`; `test/browser/milestone-e-image-gallery.spec.mjs` |
| `shadcn_ui.media_components.gallery_origin` | 5 | `test/shadcn_ui/components/media/image_gallery_test.exs`; `test/browser/milestone-e-image-gallery.spec.mjs` |
| `shadcn_ui.media_components.media_failure` | 4, 5 | `test/shadcn_ui/components/media/image_gallery_test.exs`; `test/browser/milestone-e-image-gallery.spec.mjs` |
| `shadcn_ui.media_components.media_ownership` | 1, 5 | `test/shadcn_ui/components/media/image_gallery_test.exs` |

## Marquee, Stagger, and Scroll Indicator

Contract: [motion_components](../../specs/motion_components.spec.md).

| Requirement ID | Delivery/proof phases | Planned proof targets |
| --- | --- | --- |
| `shadcn_ui.motion_components.marquee_static` | 3 | `test/shadcn_ui/components/motion/marquee_test.exs` |
| `shadcn_ui.motion_components.marquee_control` | 3 | `test/shadcn_ui/components/motion/marquee_test.exs`; `test/browser/milestone-e-motion.spec.mjs` |
| `shadcn_ui.motion_components.marquee_duplicates` | 3 | `test/shadcn_ui/components/motion/marquee_test.exs`; `test/browser/milestone-e-motion.spec.mjs` |
| `shadcn_ui.motion_components.stagger` | 3 | `test/shadcn_ui/components/motion/stagger_test.exs`; `test/browser/milestone-e-motion.spec.mjs` |
| `shadcn_ui.motion_components.indicator` | 4 | `test/shadcn_ui/components/motion/scroll_indicator_test.exs`; `test/browser/milestone-e-scroll-indicator.spec.mjs` |
| `shadcn_ui.motion_components.timeline_fallback` | 4 | `test/shadcn_ui/components/motion/scroll_indicator_test.exs`; `test/browser/milestone-e-scroll-indicator.spec.mjs` |
| `shadcn_ui.motion_components.suppression` | 3, 4 | `test/shadcn_ui/components/motion/stagger_test.exs`; `test/browser/milestone-e-motion.spec.mjs` |
| `shadcn_ui.motion_components.work_budget` | 3, 4, 6 | `test/browser/milestone-e-motion.spec.mjs`; `test/browser/milestone-e-scroll-indicator.spec.mjs` |
| `shadcn_ui.motion_components.motion_replacement` | 3, 4 | `test/browser/milestone-e-motion.spec.mjs` |

## Incremental motion/media gallery and Milestone E acceptance

Contract: [motion_media_gallery](../../specs/motion_media_gallery.spec.md).

| Requirement ID | Delivery/proof phases | Planned proof targets |
| --- | --- | --- |
| `shadcn_ui.motion_media_gallery.incremental_catalog` | 2, 3, 4, 5, 6 | `demo/test/shadcn_ui_demo/motion_media_catalog_test.exs` |
| `shadcn_ui.motion_media_gallery.references` | 2, 3, 4, 5, 6 | `demo/test/shadcn_ui_demo/motion_media_catalog_test.exs`; `test/browser/milestone-e-gallery.spec.mjs` |
| `shadcn_ui.motion_media_gallery.compositions` | 2, 3, 4, 5, 6 | `demo/test/shadcn_ui_demo/motion_media_compositions_test.exs`; `test/browser/milestone-e-gallery.spec.mjs` |
| `shadcn_ui.motion_media_gallery.capability_evidence` | 1, 6 | `demo/test/shadcn_ui_demo/motion_media_compositions_test.exs`; `test/browser/milestone-e-gallery.spec.mjs` |
| `shadcn_ui.motion_media_gallery.motion_inspection` | 1, 3, 6 | `demo/test/shadcn_ui_demo/motion_media_catalog_test.exs`; `test/browser/milestone-e-gallery.spec.mjs` |
| `shadcn_ui.motion_media_gallery.fixture_manifest` | 1, 5 | `demo/test/shadcn_ui_demo/motion_media_compositions_test.exs`; `demo/test/motion_media_export_test.exs` |
| `shadcn_ui.motion_media_gallery.static_media` | 1, 5, 6 | `demo/test/motion_media_export_test.exs` |
| `shadcn_ui.motion_media_gallery.accessibility_matrix` | 2, 3, 4, 5, 6 | `test/browser/milestone-e-gallery.spec.mjs` |
| `shadcn_ui.motion_media_gallery.release_acceptance` | 6 | `test/shadcn_ui/milestone_e_acceptance_test.exs` |
