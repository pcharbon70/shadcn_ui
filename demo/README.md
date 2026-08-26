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

Visit <http://localhost:4010/>. The package CSS and gallery shell assets are
local and fingerprinted. No remote font, image, script, analytics, or runtime
resource is required.

The Forms category contains 15 component pages plus complete sign-in, profile,
and settings compositions. In the local controller demo those forms submit only
to an allowlisted inspection endpoint that escapes and displays received values;
it performs no authentication, persistence, authorization, or domain operation.
Static exports render the same compositions with submission disabled.

Milestone C adds Disclosure, Navigation, and Content Surfaces categories with
dedicated Accordion, Navigation Menu, Header, Section Header, Scroll Area,
Separator, and Radio Panels pages. The documentation, settings, and application-
shell example routes compose Milestones A through C from deterministic caller
fixtures. They add no persistence, authentication, authorization, route
inference, domain operation, or package-owned client state.

## Verification and export

```console
npm run assets:check
mix test
mix gallery.export
npm run export:check
npm run smoke -- http://localhost:4010
```

The export is written to ignored build output and includes a route and content
hash manifest. Deployment publishes that exact verified artifact. See
[`DEPLOYMENT.md`](./DEPLOYMENT.md) for the canonical URL, owner, permissions,
post-deployment smoke test, retention, and rollback procedure.
