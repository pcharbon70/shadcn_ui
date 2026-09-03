# Gallery publication operations

The ShadcnUI maintainers own the Fly.io application `pcharbon70-shadcn-ui-demo` and
the canonical gallery at `https://pcharbon70-shadcn-ui-demo.fly.dev/`. The source
repository owns the non-secret Docker, Machine, service and health-check
configuration. Fly secrets own `SECRET_KEY_BASE`; no secret value belongs in
source, build arguments, artifacts, logs, or release records.

## State model

Local verification, source commit, Fly image build, Machine rollout, service
health, and post-deployment smoke are separate states. A passing local build
does not imply an image exists. An image does not imply rollout or health. A
healthy Machine does not imply the canonical smoke passed. Record each state,
revision, image identity and deployment identifier separately.

The first qualifying deployment must be explicit from a reviewed source
revision. From the repository root, validate the config, set the secret without
printing it, and deploy the immutable revision:

```text
flyctl config validate --strict -c demo/fly.toml
flyctl secrets set -a pcharbon70-shadcn-ui-demo SECRET_KEY_BASE=<generated-secret>
flyctl deploy . -c demo/fly.toml --ha=false --build-arg SHADCN_UI_BUILD_REVISION=<40-character revision>
```

Future automation must use a scoped Fly deploy token stored by the automation
platform, verify the same revision, and preserve the separation between build,
rollout, health and smoke. Static exports remain deterministic evidence and a
portable fallback; they are not the canonical Fly runtime.

## Post-deployment smoke

Prefer running the verifier from the deployed revision with both variables set:

```text
SHADCN_UI_GALLERY_URL=https://pcharbon70-shadcn-ui-demo.fly.dev/
SHADCN_UI_EXPECTED_REVISION=<40-character deployed revision>
npm --prefix demo run smoke:fly
```

The smoke verifies `/healthz`; package, source, catalogue, and upstream identity;
the canonical home; representative component and composition routes;
server-rendered search inventory; canonical links; local assets; and a
non-reflecting 404. Sitemap, search-data, release/health-manifest, route-manifest,
and repository-subpath checks remain deterministic static-export evidence rather
than Fly runtime routes. Record the Fly deployment and output; do not infer this
result from Machine health alone. If the verifier is strengthened after the
deployment, record its exact content SHA-256, path, working-tree base, and null
source revision separately. That binds the later verifier without implying it
was part of the deployed commit; a future reviewed release should carry and run
the verifier from its own source revision.

## Failure triage and rollback

1. Stop promotion and preserve the failed workflow URL, revision, release and
   health manifests, response status, headers, and smoke output. Never edit the
   deployed artifact in place.
2. Determine whether verification, image build, Machine rollout, service health,
   Fly proxy/certificate, or canonical smoke failed. Treat a revision mismatch
   as a stale deployment, not as an acceptable cache delay.
3. Select the most recent authorized Fly release whose source passed review and
   whose immutable image identity and post-deploy smoke both passed. Use
   `flyctl releases` to identify it and
   `flyctl releases rollback <version> -a pcharbon70-shadcn-ui-demo` to restore it. Do
   not rebuild an unrecorded working tree.
4. Confirm Fly reports the rollback Machine healthy. Run the complete canonical
   smoke with the selected 40-character revision.
5. Record rollback source release, new deployment identifier, image and source
   revisions, proxy observations, recovery smoke, owner, and time. Keep the
   incident open until `/healthz`, direct routes/assets, canonical links and 404
   behavior describe the same recovered revision.

Until the first reviewed Fly publication, no prior reviewed-and-smoke-verified
Fly release exists. Record that absence explicitly and stop or destroy the
failed Machine; never nominate the failed GitHub Pages artifact, a merely built
Fly image, or an unreviewed operational deployment as a rollback candidate. The
first source-reviewed and authorized Fly release whose canonical smoke passes
becomes the earliest eligible release. Package rollback and public Hex
publication remain separate and are not authorized by this runbook.
