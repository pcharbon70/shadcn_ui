# Gallery deployment

## Milestone E candidate

The closed inventory now includes all six Media/Motion leaves plus media-browser,
image-gallery, motion-preferences and motion-media-capabilities compositions.
Publication smoke visits these and A–D, checking local src/srcset media; the
intentional missing image must return 404. Export contains 634 variants, three
code/style assets and three manifest-selected original SVGs. No remote runtime
loads are permitted.

Before publishing, run all E and earlier browser suites, then the demo commands
`npm run export:determinism`, `npm run export:check`, `npm run export:smoke`.
Candidate and manual-review status live in `docs/milestone-e-acceptance.md` at
repository root. CI and post-deploy HTTPS results must be recorded separately.

After a reviewed merge, use the existing Pages workflow. Set
`SHADCN_UI_GALLERY_URL` to `https://leco-industries-inc.github.io/shadcn_ui/`
and run `npm run smoke` from demo. Verify direct routes, canonical metadata and
media at that subpath. On failure redeploy a prior reviewed artifact or revert
the change and rerun its matching inventory. Never mutate deployed files.
Package publication is independent; Milestone F remains separately planned.

## Deployment policy and earlier evidence

- Host: GitHub Pages for `Leco-Industries-Inc/shadcn_ui`.
- Canonical URL: `https://leco-industries-inc.github.io/shadcn_ui/`.
- Repository environment: `github-pages`, owned by the ShadcnUI maintainers.
- Credentials: none stored by the project. GitHub's short-lived `id-token` and
  Pages deployment token are requested by the workflow with least privilege.
- Retention: the uploaded Pages artifact follows repository artifact retention;
  no mutable logs or user data are part of the export.
- Concurrency: one `pages` deployment runs at a time; newer runs do not cancel an
  in-progress production deployment.
- Rollback: rerun the Pages job for a previously reviewed commit or revert the
  gallery change on `main`; never edit the published artifact in place.

Repository administrators must enable GitHub Pages with GitHub Actions as its
source and protect the `github-pages` environment before the first deployment.
The workflow builds and verifies the exact static artifact, including every
Foundation, Forms, Disclosure, Navigation, Content Surfaces, Overlays, and
Interactive Surfaces route, all controller-rendered forms, Milestone C and D
compositions, the overlay capability matrix, and the
generated sitemap before deployment and
uploads it as the repository site's exact root artifact without modifying its
contents. It then smoke-tests the canonical HTTPS routes and all three local
fingerprinted assets afterward.

Milestone D adds five Overlays leaves, two Interactive Surfaces leaves, and
`/examples/overlay-capabilities`, `/examples/settings-confirmation`,
`/examples/responsive-drawers`, `/examples/anchored-actions`, and
`/examples/supplemental-help`. The closed catalogue supplies 51 routes plus three
form routes; export contains 208 HTML variants including a nonreflecting 404.
Canonical metadata and sitemap use unthemed canonical paths, not request input.
Ordinary authoritative links are permitted; remote runtime assets are not.

Before publication, compare deterministic export bytes and run all locked native
overlay suites plus the live gallery accessibility/interaction suite. The
reviewed feature record under `priv/compatibility` is demo evidence only: update
it with the root recorder when browser locks change and review behavior tests
separately. A detected API does not certify every behavior or authorize interest
invokers. No demo helper enters the package archive.

`npm run export:smoke` serves only the exported manifest on an ephemeral local
loopback port and checks every HTML variant and its three selected assets under
`/shadcn_ui/`, independently of Phoenix. This does not replace the post-deploy
HTTPS smoke check. Old copied build assets are excluded by the closed manifest.

After publication, smoke-test every added direct route at the canonical base
URL. Do not report a successful local export as a successful deployment. For
rollback, redeploy the exact prior reviewed artifact or revert the gallery
commit and let CI rebuild; then rerun smoke checks against that artifact's
inventory. Package rollback is independent, and never changes user data.
