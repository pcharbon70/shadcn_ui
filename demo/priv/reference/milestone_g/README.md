# Milestone G pinned presentation reference

This directory is checked, demo-only evidence for the presentation target. It
does not vendor unscripted/ui and is excluded from the ShadcnUI package archive.

`presentation-reference.json` records exact upstream source hashes, authored
geometry and the light/dark viewport/open-state matrix derived from the pinned
revision. `presentation-reference.schema.json` validates that closed evidence.
The source-derived states are authoritative Phase 1 inputs because a moving
deployment cannot be deterministic. Later phases add reviewed local ShadcnUI
raster goldens without changing these upstream identities silently.

The pinned upstream build could not be rendered on the Phase 1 Windows host
because npm 10.9.2 terminated twice with `exit_handler_never_called`. That
environment limitation is recorded as a build status, not converted into a
passing visual claim. Exact source review and hashing completed independently.

The reviewed upstream font binary is not copied here. Its identity is retained
in the manifest, and the source project's OFL 1.1 notice is retained under
`licenses/`. Phase 3 may add a local font only after it reproduces or explicitly
maps the selected binary to that license and updates demo notices; otherwise it
must use the accepted system fallback.
