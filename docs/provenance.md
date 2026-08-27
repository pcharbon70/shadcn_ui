# Provenance and independent project identity

ShadcnUI is an independent Phoenix/HEEX adaptation. It is not an official
shadcn/ui or unscripted/ui package and is not endorsed by either project.

`priv/provenance/unscripted_ui.json` maps every substantially adapted component
or CSS foundation to its local paths, reviewed upstream paths, and adaptation
summary. The manifest pins unscripted/ui commit
`bd8f403030c8d1f46804da6eda733fde7e908e63`; no mutable branch or remote runtime
asset participates in a build or rendered page. Every component gallery page
shows its manifest identity and the same pin.

`THIRD_PARTY_NOTICES.md` retains the complete upstream MIT notice. The ShadcnUI
package itself is internal proprietary software as declared in `mix.exs`; the
retained upstream notice does not imply official affiliation or change the
package's own identity.

To review a later upstream revision, compare the full commit range and license,
review every mapped path, preserve the local semantic/accessibility/fallback
contracts, update all affected manifest entries and local-change summaries,
rebuild CSS, and run provenance, package, gallery, browser, archive, and legal-
notice checks in the same reviewed change. Never copy upstream site branding,
fonts, analytics, documentation application code, images, or runtime scripts.
