# Milestone G Phase 1 acceptance record

## Scope

Phase 1 accepts presentation architecture and checked reference inputs. It does
not implement the responsive shell, gallery presentation primitives, Accordion
pilot or complete migration, and it does not change a package component API,
stylesheet or runtime.

## Delivered evidence

- Decision `shadcn_ui.pinned_gallery_presentation_parity` pins unscripted/ui
  commit `bd8f403030c8d1f46804da6eda733fde7e908e63`, the reviewed source paths,
  semantic exceptions, local asset policy and later-update process.
- Specification `shadcn_ui.gallery_presentation` adds 14 requirements with one
  coverage-map phase owner and at least one concrete verification target each.
- The demo-only manifest records 14 exact source hashes, authored geometry,
  visual tolerances and 12 light/dark desktop/tablet/mobile reference states.
- The Bricolage Grotesque candidate binary is not copied. Its reviewed hash,
  pinned source-project revision, OFL 1.1 notice and Phase 3 reproduction gate
  are retained locally and remain outside package contents.

## Local verification

The Phase 1 delivery run uses Elixir 1.20.3, OTP 29, Playwright 1.62.1 where
applicable, and the repository's locked package and demo dependencies.

| Gate | Result |
| --- | --- |
| Focused Section 1.1 provenance/package tests | PASSED - 16 tests |
| Phase 1 demo reference tests | PASSED - 4 tests |
| Phase 1 package acceptance tests | PASSED - 4 tests |
| Package `mix precommit` | PASSED - 406 tests |
| Demo `mix precommit` | PASSED - 96 tests |
| Package and demo locked asset checks | PENDING final Section 1.3 run |
| Deterministic gallery export | PENDING final Section 1.3 run |
| Actual package archive exclusion | PENDING final Section 1.3 run |
| SpecLed prime/next/check and state reconciliation | PENDING final Section 1.3 run |
| `git diff --check` | PASSED for committed Phase 1 baseline; rerun before PR merge |

## Distinct limitations and external states

The exact upstream checkout and source audit succeeded. Two locked dependency
installation attempts for a temporary upstream render stopped in npm 10.9.2
with `exit_handler_never_called`, so Phase 1 makes no raster-capture or rendered
upstream-build claim. The checked source-derived states remain deterministic;
later local ShadcnUI raster goldens are still required by their owning phases.

CI, merge, deployment, post-deployment smoke and manual accessibility review are
not inferred from local Phase 1 results. This phase publishes no gallery, Hex
package, tag or marketplace artifact.
