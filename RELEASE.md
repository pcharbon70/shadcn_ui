# Internal release process

Milestones A and B produce an internal `0.1.0` candidate containing Foundation
and native Forms components. This process does not authorize or perform
publication to Hex.

## Candidate verification

From a clean checkout and `packages/shadcn_ui`:

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

For a Milestone B rollback, revert the reviewed Milestone B commits and rerun
the complete candidate verification. Never edit an archive or the deployed
gallery artifact in place. The package and gallery may be rolled back
independently because the demo is excluded from package contents.
