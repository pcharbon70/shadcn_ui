---
id: shadcn_ui.progressive_enhancement_baseline
status: accepted
date: 2026-08-24
affects:
  - shadcn_ui.component_contract
  - shadcn_ui.foundation_components
  - shadcn_ui.stylesheet
  - shadcn_ui.gallery
---

# Adopt Progressive Enhancement With Explicit Fallback Evidence

## Context

The design basis intentionally explores modern HTML and CSS. A zero-component-
JavaScript claim is only useful when unsupported features leave semantic content
and native controls available. Browser support changes over time and the Electron
renderer has a separately pinned Chromium version.

## Decision

Each component documents a semantic baseline, optional enhancements, supported
browser assumptions, and exact fallback behavior.

- Native HTML semantics and content availability are the acceptance floor.
- CSS feature queries guard enhancements when an unsupported declaration could
  otherwise hide content or remove required feedback.
- A visual enhancement may disappear, snap instead of animate, or use native
  presentation, but required content and operations may not become unreachable.
- Reduced-motion preferences disable or shorten nonessential animation without
  removing state, status, or focus visibility.
- Browser claims are verified from authoritative compatibility sources when a
  component is specified and are exercised in the gallery's locked browser
  matrix and supported Electron Chromium build.
- The gallery distinguishes native behavior, package CSS enhancement, fallback,
  and demo-only behavior. It does not label demo shims as package capability.
- Milestone A foundation components must work without JavaScript and without
  leading-edge platform features.

## Consequences

Modern CSS can improve presentation without becoming an undisclosed functional
dependency. Later milestones must add feature-specific requirements and tests
rather than inheriting a vague “modern browser” promise.
