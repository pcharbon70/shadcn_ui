---
id: shadcn_ui.scoped_theme_token_contract
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.stylesheet
  - shadcn_ui.foundation_components
  - shadcn_ui.gallery
---

# Scope Semantic Tokens and Theme Selection

## Context

Shadcn's visual language is based on semantic surface, foreground, border,
accent, destructive, focus, and radius tokens. Reusing generic global token
names or a global `.dark` selector could collide with BulmaUI or application
themes on mixed pages.

## Decision

ShadcnUI exposes namespaced public CSS custom properties beginning with
`--shadcn-ui-` and maps Tailwind's prefixed internal theme variables to them.

- The default token set is light and is defined without changing document-wide
  element defaults.
- Dark tokens activate only beneath an ancestor with
  `data-shadcn-theme="dark"`; `data-shadcn-theme="light"` selects the explicit
  light scope. Missing or invalid values use light defaults.
- Tokens cover the shadcn semantic color roles required by the catalogue,
  foreground pairings, input/border/ring roles, radii, and shared motion timing.
- Components consume semantic variables and do not hard-code theme-specific
  light or dark colors.
- Consumers may override documented public tokens within their own scope. They
  may map another theme system onto these tokens, but ShadcnUI does not download
  themes or interpret arbitrary theme names.
- Reduced-motion rules preserve meaning and remove nonessential animation
  independently of color theme.

## Consequences

ShadcnUI retains the recognizable semantic token model while remaining safe on
pages that also load Bulma or another design system. Consumers must place the
theme attribute on the document or an appropriate component ancestor when they
want explicit dark mode.
