# Gallery deployment

The canonical gallery is the separate, stateless Phoenix demo at
`https://pcharbon70-shadcn-ui-demo.fly.dev/`. It runs as an immutable OTP release on
Fly.io; it is not part of the ShadcnUI package archive and it does not add an
application runtime to package consumers.

The repository workflow verifies the package, demo, deterministic static
export, controller-rendered forms, Milestone C and D behavior, and browser
suites. It does not hold Fly credentials or deploy public infrastructure. A
maintainer deploys a reviewed revision explicitly with the root-context Docker
build in `demo/fly.toml`. `SECRET_KEY_BASE` is a Fly secret, never a source value
or Docker build argument.

From the repository root, follow
[`demo/operations/gallery-publication.md`](operations/gallery-publication.md) for config
validation, secret setup, immutable revision injection, `/healthz` checks,
canonical smoke, and Rollback. A local export, successful image build, healthy
Machine, and passing public smoke are separate states and must be recorded as
such.

The deterministic export remains a portable fallback and regression artifact.
It is not the canonical public runtime and must never be reported as a
successful Fly deployment.
