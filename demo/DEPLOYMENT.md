# Gallery deployment

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
Foundation, Forms, Disclosure, Navigation, and Content Surfaces route, all
controller-rendered form and Milestone C compositions, and the
generated sitemap before deployment and
uploads it as the repository site's exact root artifact without modifying its
contents. It then smoke-tests the canonical HTTPS routes and all three local
fingerprinted assets afterward.
