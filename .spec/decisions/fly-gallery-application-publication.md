---
id: shadcn_ui.fly_gallery_publication
status: accepted
date: 2026-09-01
supersedes:
  - shadcn_ui.gallery_static_publication
  - shadcn_ui.versioned_gallery_publication
affects:
  - shadcn_ui.gallery
  - shadcn_ui.gallery_presentation
  - shadcn_ui.public_documentation
  - shadcn_ui.release_publication
---

# Publish The Stateless Gallery Application On Fly.io

## Context

The reviewed GitHub Pages workflow proved the deterministic exporter but the
repository is owned by the maintainer's personal GitHub account, while the
accepted Pages canonical origin named a retired organization. Its first
deployment therefore could not pass the
canonical smoke. The maintainers now choose Fly.io as the actual demo host and
want to publish the controller-rendered Phoenix application rather than make a
static host the public runtime.

## Decision

The canonical gallery is the stateless Phoenix demo deployed as an immutable
OTP release on Fly.io.

- `demo/fly.toml` owns non-secret Fly application, region, Machine, service and
  HTTP health-check configuration. Fly secrets own `SECRET_KEY_BASE`; neither
  credentials nor generated secret values enter source or build arguments.
- The Docker build uses the repository root so the demo's `path: ".."`
  ShadcnUI dependency is real. It compiles only the package and demo release,
  builds deterministic local gallery assets, and copies only the release into
  the runtime image.
- The canonical HTTPS origin and full source revision are explicit validated
  build inputs. `PHX_HOST`, `PORT`, `PHX_SERVER` and private DNS are non-secret
  runtime configuration. No release shell discovers Git or remote identity.
- The demo remains controller-rendered and stateless: no Ecto, LiveView, Dstar,
  Datastar, Ash, authentication, persistent volume or application worker is
  added. Fly may stop the single Machine while idle and start it on demand.
- `/healthz` exposes only the non-secret immutable build identity needed for
  service routing and post-deploy verification. It does not imply package or
  application state health beyond the running gallery release.
- The deterministic static export, manifests and browser-subpath suites remain
  checked evidence and a portable fallback. They are no longer the canonical
  public hosting mechanism.
- Local verification, source commit, Fly image build, Machine rollout, health
  checks and canonical smoke remain separate states. Rollback selects an
  already deployed, smoke-verified Fly release; an image build alone is not a
  successful publication.
- For bounded remediation evidence, the release owner may explicitly authorize
  deployment of an exact pull-request revision whose CI is green. That
  operational authorization does not supply independent source approval,
  final-evidence-revision CI, merge, manual accessibility acceptance, or
  candidate qualification; each remains separately recorded. A retained Fly
  release is eligible for rollback claims only when its reviewed source and
  successful smoke were recorded.

## Consequences

The public site exercises the same separate Phoenix consumer used locally and
can later demonstrate server-owned examples without changing the ShadcnUI
package. Publication now has a small on-demand Fly runtime cost and an explicit
secret/configuration boundary. Static export determinism remains valuable proof
without dictating the hosting platform.
