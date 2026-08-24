# ShadcnUI gallery

This is a separate, controller-rendered Phoenix reference consumer for the
ShadcnUI package. It owns gallery routes, fixtures, theme persistence, source
copying, and publication; none of those concerns enter the component package.

From a clean checkout:

```console
mix deps.get --locked
npm ci
npm run assets:build
mix phx.server
```

Visit <http://localhost:4000/>. The package CSS and gallery shell assets are
local and fingerprinted. No remote font, image, script, analytics, or runtime
resource is required.

## Verification and export

```console
npm run assets:check
mix test
mix gallery.export
npm run export:check
npm run smoke -- http://localhost:4000
```

The export is written to ignored build output and includes a route and content
hash manifest. Deployment publishes that exact verified artifact. See
[`DEPLOYMENT.md`](./DEPLOYMENT.md) for the canonical URL, owner, permissions,
post-deployment smoke test, retention, and rollback procedure.
