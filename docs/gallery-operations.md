# Gallery publication operations

The ShadcnUI maintainers own the `github-pages` environment and the canonical
gallery at `https://leco-industries-inc.github.io/shadcn_ui/`. Repository
administrators own branch and environment protection. GitHub Actions owns the
short-lived Pages identity; no deployment credential belongs in source,
artifacts, logs, or local release records.

## State model

Local verification, pull-request CI, merge, deployment, and post-deployment
smoke are independent states. A passing local build does not imply CI passed. A
merge does not imply deployment occurred. A successful deployment does not
imply the canonical smoke passed. Record each state and its workflow URL,
revision, and artifact identity separately.

Pull requests build and smoke one immutable Pages artifact but cannot deploy.
Only a push of reviewed `main` can enter the protected `github-pages`
environment. The artifact contains `release.json`, `health.json`,
`route-manifest.json`, and fingerprinted local assets. The workflow action SHAs,
Elixir/OTP, Node, lockfiles, canonical URL, and full source revision are reviewed
inputs.

## Post-deployment smoke

Run from the deployed revision with both variables set:

```text
SHADCN_UI_GALLERY_URL=https://leco-industries-inc.github.io/shadcn_ui/
SHADCN_UI_EXPECTED_REVISION=<40-character deployed revision>
npm --prefix demo run smoke
```

The smoke verifies the canonical home, every direct component and composition
route, canonical links, the exact version/revision, CSS, script, media, search,
sitemap, release and health documents, content types, asset hashes, and a
non-reflecting 404. Record the workflow run and the output; do not infer this
result from the deploy job.

## Failure triage and rollback

1. Stop promotion and preserve the failed workflow URL, revision, release and
   health manifests, response status, headers, and smoke output. Never edit the
   deployed artifact in place.
2. Determine whether verification, environment protection, Pages deployment,
   CDN/cache propagation, or canonical smoke failed. Treat a revision mismatch
   as a failed or stale deployment, not as an acceptable cache delay.
3. Select the most recent previously verified `main` workflow whose immutable
   artifact identity and post-deploy smoke both passed. Re-run that workflow at
   its original revision, or revert the bad change on `main` so the reviewed
   known-good tree is rebuilt. Do not rebuild an unrecorded working tree.
4. Confirm the protected environment approved the rollback deployment. Run the
   complete canonical smoke with the selected 40-character revision.
5. Record rollback source run, new deployment run, artifact revision, cache
   observations, recovery smoke, owner, and time. Keep the incident open until
   `release.json`, `health.json`, all direct routes/assets, and 404 behavior
   describe the same recovered revision.

GitHub artifact retention is 30 days. If the chosen run is outside retention,
use a reviewed revert on `main`; never fetch or reconstruct mutable site files.
Package rollback and public Hex publication are separate and are not authorized
by this runbook.
