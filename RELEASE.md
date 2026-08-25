# Internal release process

Milestones A through C produce an internal `0.1.0` candidate containing
Foundation, native Forms, Disclosure, Navigation, and Content Surfaces
components. This process does not authorize or perform
publication to Hex.

## Candidate verification

From a clean checkout at the repository root:

1. Run `mix deps.get --locked` and `npm ci`.
2. Run `npm run assets:build` and `npm run assets:check`.
3. Run `mix precommit`, `mix docs`, and `mix hex.build`.
4. Inspect the archive against `package/0`'s explicit allowlist.
5. Verify the archive contains public modules, compiled CSS, README, changelog,
   provenance, notices, and Mix metadata only.

The archive must reject `.spec`, demo sources and exports, scripts, workflows,
tests, `_build`, `deps`, `doc`, `node_modules`, source maps, remote runtime
assets, credentials, and mutable user data. The checked-in lockfiles remain
repository verification inputs and are not package contents.

Gallery publication and rollback are independent of the package candidate and
are documented in `demo/DEPLOYMENT.md`.

For a Milestone C rollback, revert the reviewed Milestone C commits and rerun
the complete candidate verification. Never edit an archive or the deployed
gallery artifact in place. The package and gallery may be rolled back
independently because the demo is excluded from package contents.

## Milestone C acceptance record

The candidate must include the seven Milestone C public components and their
compiled CSS/provenance mappings while excluding the gallery, browser fixtures,
static export, and demo dependencies. Acceptance requires package and demo
precommit, deterministic package and gallery assets, static-export comparison,
Milestone C Chromium coverage, ExDoc, archive allowlist inspection, provenance
and notice audits, SpecLed validation, and whitespace checks. Navigation must
remain destination-based; Radio Panels must remain native radios rather than a
tab contract; true tabs, menus, overlays, application behavior, and package
JavaScript remain absent.
