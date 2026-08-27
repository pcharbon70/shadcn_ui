---
id: shadcn_ui.consumer_neutral_compatibility
status: accepted
date: 2026-08-27
affects:
  - shadcn_ui.compatibility_accessibility
  - shadcn_ui.public_documentation
  - shadcn_ui.package
---

# Keep Compatibility And Integration Guidance Consumer-Neutral

## Context

ShadcnUI is now an extracted reusable Phoenix package. Historical roadmap text
named Electron as a supported target, while the accepted overlay and
motion/media contracts define support through web-platform capabilities. The
documentation must also show controller, Dstar and LiveView consumption without
selecting a transport or adding application dependencies.

## Decision

Milestone F defines compatibility by declared HTML and CSS capability sets and
keeps all integration guidance transport-neutral.

- Exact locked Chromium, Firefox and WebKit builds are reproducible evidence,
  not normative product, operating-system, browser-brand or embedded-renderer
  targets.
- A component is supported when its declared native capability set is present.
  Otherwise its documented semantic, ordinary-navigation or in-flow fallback
  remains the contract.
- ShadcnUI does not claim support for Electron or another embedded consumer.
  Consumer applications own validation of their pinned renderer, CSP, transport,
  native shell and deployment environment.
- The gallery reports policy, observed evidence, missing-capability fixtures and
  manual review separately. Feature parsing alone is not behavioral proof.
- Controller-rendered Phoenix examples may be executable gallery or clean-
  consumer fixtures. Dstar and LiveView examples describe how applications
  render the same stateless HEEX snapshots; neither becomes a ShadcnUI runtime
  dependency, route, process, hook or state owner.
- Raising a component capability floor or adopting a package runtime requires an
  explicit contract change and migration guidance rather than user-agent
  sniffing or an undocumented minimum-version change.

## Consequences

The package can be reused by web and embedded consumers without promising a
platform it does not own. Compatibility claims remain measurable and current,
while application teams retain responsibility for their integration and native
environment.
