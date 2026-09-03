import {createHash} from "node:crypto";
import {readFileSync, readdirSync} from "node:fs";
import {dirname, join, relative, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const evidence = readJson("demo/priv/reference/milestone_g/remediation-r5-integration-evidence.json");
const presentation = readJson("demo/priv/reference/milestone_g/presentation-reference.json");
const phase5 = readJson("demo/priv/reference/milestone_g/phase-05-accordion-evidence.json");
const pinned = readJson(evidence.referenceManifest);
const comparison = readJson(evidence.comparisonEvidence);

function readJson(path) {
  return JSON.parse(readFileSync(join(root, path), "utf8"));
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function snapshotSetDigest() {
  const directory = join(root, "test/browser/milestone-g-remediation-r5.spec.mjs-snapshots");
  const lines = readdirSync(directory)
    .filter((file) => file.endsWith(".png"))
    .sort()
    .map((file) => {
      const digest = createHash("sha256").update(readFileSync(join(directory, file))).digest("hex");
      return `${file}\0${digest}\n`;
    })
    .join("");
  return createHash("sha256").update(lines).digest("hex");
}

assert(evidence.status === "passed-remediation-r5-complete", "R5 integration is not complete");
assert(evidence.movingPublicSiteAuthoritative === false, "moving site became authoritative");
assert(evidence.networkRequiredForVerification === false, "R5 verification requires network");
assert(evidence.upstreamCommit === pinned.upstream.commit, "R5 integration pin drifted");
assert(pinned.status === "passed-rendered-and-reviewed-r5.2", "pinned reference is not reviewed");
assert(comparison.status === "passed-reviewed-r5.2", "comparison is not reviewed");
assert(evidence.determinism.captureRuns === 2, "two capture runs were not recorded");
assert(evidence.determinism.snapshotCount === 20, "unexpected R5 snapshot count");
assert(snapshotSetDigest() === evidence.determinism.snapshotSetSha256, "R5 snapshot-set hash drifted");
assert(evidence.determinism.exportRuns === 2, "two export runs were not recorded");
assert(presentation.capturePolicy.pinnedBuildStatus === "passed-rendered-and-reviewed-r5", "presentation reference remains unavailable");
assert(presentation.capturePolicy.renderedReference === evidence.referenceManifest, "rendered reference link drifted");
assert(presentation.capturePolicy.comparisonEvidence === evidence.comparisonEvidence, "comparison evidence link drifted");
assert(phase5.states.upstreamRenderedComparison === "passed-reviewed-r5.2-eight-state-pinned-comparison", "Accordion comparison remains unavailable");
assert(evidence.distribution.archiveEntries === 63, "archive audit count drifted");
assert(evidence.distribution.exportRoutes === 634, "export route count drifted");
assert(evidence.distribution.exportAssets === 4, "export asset count drifted");
assert(evidence.specLed.errors === 0 && evidence.specLed.warnings === 0, "SpecLed is not clean");

const mix = readFileSync(join(root, "mix.exs"), "utf8");
const archiveAudit = readFileSync(join(root, "scripts/check-release-archive.exs"), "utf8");
const packageFiles = mix.match(/files:\s*\[(.*?)\n\s*\]/s)?.[1];
assert(packageFiles, "package file allowlist was not found");
for (const excluded of ["demo/", ".spec/"]) {
  assert(archiveAudit.includes(`"${excluded}"`), `archive audit does not exclude ${excluded}`);
}
for (const excluded of evidence.distribution.excludedEvidenceRoots) {
  assert(!packageFiles.includes(`"${excluded.replace(/\/$/, "")}"`), `${excluded} entered the package allowlist`);
}

console.log(`Verified deterministic R5 integration at ${relative(root, join(root, evidence.referenceManifest))}.`);
