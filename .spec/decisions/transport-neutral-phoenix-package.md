---
id: shadcn_ui.transport_neutral_phoenix_package
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.package
  - shadcn_ui.component_contract
  - shadcn_ui.gallery
---

# Keep ShadcnUI an Independent Transport-Neutral Phoenix Package

## Context

ShadcnUI must be usable by ordinary controller-rendered Phoenix pages and by
applications that independently choose Dstar, LiveView, or another transport.
Putting routes, processes, domain state, or event handling in the package would
duplicate application ownership and violate the monorepo architecture.

Phoenix distributes `Phoenix.Component`, HEEx, typed attributes, and slots
through `phoenix_live_view`, even when an application does not use the LiveView
application model.

## Decision

ShadcnUI is an independent Mix project in its standalone repository.

- Public UI elements are stateless Phoenix function components implemented in
  one defining module per component under functional category namespaces.
- `use ShadcnUI` imports public defining modules directly so their compile-time
  attribute and slot metadata remains available to callers.
- `phoenix_live_view` supplies HEEx component infrastructure only. ShadcnUI
  defines no LiveView route, socket, process, hook, navigation, or state sync.
- The runtime package contains no controller, endpoint, Dstar, Datastar, Ash,
  Electron, database, request, authorization, or application dependency.
- Applications own state transitions, requests, navigation, business commands,
  persistence, authorization, and native capabilities.
- Release contents use an explicit allowlist and exclude the demo, build tools,
  installed dependencies, generated documentation, tests, and mutable output.

## Consequences

Consumers can use the same components from controller HEEx, Dstar patches, or
LiveView without ShadcnUI selecting their application model. Component APIs must
represent rendered state explicitly, and demonstrations of application behavior
must remain outside the runtime package.
