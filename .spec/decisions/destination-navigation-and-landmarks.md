---
id: shadcn_ui.destination_navigation_landmarks
status: accepted
date: 2026-08-25
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.navigation_components
  - shadcn_ui.content_navigation_gallery
---

# Keep Navigation Destination-Based And Landmarks Explicit

## Context

Navigation surfaces can look like menus, tabs, buttons, or application commands
while implementing only ordinary links. Incorrect menu or tab roles would create
keyboard and focus obligations that static HEEX cannot satisfy. Pages may also
contain several navigation and header regions, so accessible names and heading
structure cannot be inferred safely from visual placement.

## Decision

Milestone C navigation components render destinations and document landmarks;
they do not implement commands or a client router.

- Navigation Menu renders a named native `nav` containing a list of real
  anchors. Every item has a stable caller key, escaped or trusted label content,
  and a nonblank caller-owned destination.
- The component emits no `menu`, `menubar`, `tablist`, `menuitem`, or `tab` role
  and adds no roving tabindex, arrow-key model, popup state, command dispatch, or
  interception of native link activation.
- The caller explicitly supplies current-location state through closed native
  `aria-current` values. ShadcnUI never reads the request path, compares URLs,
  consults authorization, or chooses a current item; explicit item state is the
  only source of current-location markup.
- Required landmark names, link destinations, current state, and native anchor
  semantics take precedence over conflicting caller globals. Applications remain
  responsible for destination safety, route generation, access control, and
  deciding which destinations are visible.
- Header composes caller-owned brand, primary navigation, utilities, and actions
  while preserving their native links, buttons, headings, and forms. It does not
  introduce page heading levels or turn actions into links.
- Section Header preserves a caller-authored heading and related actions in
  document order. Sticky positioning and anchor-positioned decoration are
  optional CSS presentation; static flow, focus indication, and current-location
  text or shape remain complete fallbacks.

## Consequences

Keyboard behavior stays predictable because links remain links and buttons
remain buttons. Applications can use Phoenix routes, Dstar, or LiveView without
the package selecting navigation behavior. True menu, tab, or command semantics
remain unavailable until their complete interaction contracts are approved.
