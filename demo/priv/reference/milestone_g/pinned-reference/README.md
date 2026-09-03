# Renderable pinned reference

This directory contains the smallest checked, network-independent rendering
subset produced from unscripted/ui commit
`bd8f403030c8d1f46804da6eda733fde7e908e63`. It is reference evidence for the
separate demo and is excluded from the ShadcnUI package archive.

The exact upstream commit was installed from its committed npm lockfile and
built twice with identical 53-file output-tree hashes. The checked subset keeps
the generated Accordion page, generated stylesheet, local font and directly
referenced image assets. The only transformation removes the upstream
Cloudflare analytics comment and script; ordinary external documentation links
remain destinations and are never automated verification inputs.

`LICENSE.unscripted-ui.txt` retains the upstream MIT license. The Bricolage
Grotesque binary is the previously accepted exact binary and remains covered by
`../licenses/bricolage-grotesque-OFL.txt`.

Run `node scripts/check-milestone-g-pinned-reference.mjs` from the repository
root to validate the closed inventory, hashes, pin, lockfile, local-only runtime
and retained notices. Captures and comparison evidence are owned by the later
R5 sections, not by this build receipt.
