import {createHash} from "node:crypto";
import {readFileSync, readdirSync} from "node:fs";
import {dirname, join, relative, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const exported = join(root, "demo/export");
const evidence = readJson(
  "demo/priv/reference/milestone_g/remediation-r6-regression-evidence.json",
);
const consumer = readJson("release/consumer-trial-evidence.json");
const candidate = readJson("release/candidate-status.json");
const release = readJson("demo/export/release.json");
const routes = readJson("demo/export/route-manifest.json");

function readJson(path) {
  return JSON.parse(readFileSync(join(root, path), "utf8"));
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function filesBelow(directory) {
  return readdirSync(directory, {withFileTypes: true})
    .flatMap((entry) => {
      const path = join(directory, entry.name);
      return entry.isDirectory() ? filesBelow(path) : [path];
    })
    .sort();
}

function sha256(path) {
  return createHash("sha256").update(readFileSync(path)).digest("hex");
}

function exportTreeDigest() {
  const lines = filesBelow(exported)
    .map((path) => `${relative(exported, path)}\0${sha256(path)}\n`)
    .join("");
  return createHash("sha256").update(lines).digest("hex");
}

assert(
  evidence.status === "passed-local-regression-with-external-gates-pending",
  "R6.2 regression is not locally complete",
);
assert(evidence.exactSourceRevision === null, "working-tree evidence claims an exact revision");
assert(evidence.unitAndDocumentation.packagePrecommit.failures === 0, "package tests failed");
assert(evidence.unitAndDocumentation.demoPrecommit.failures === 0, "demo tests failed");
assert(evidence.browser.testInvocations === 552, "browser regression count drifted");
assert(evidence.browser.failures === 0, "browser regression failed");
assert(evidence.browser.engines.join(",") === "chromium,firefox,webkit", "engine matrix drifted");
assert(evidence.browser.lockedVisualSnapshots === 72, "visual snapshot inventory drifted");

const currentExport = evidence.distribution.currentExport;
assert(release.identity.development === false, "R6 export uses development identity");
assert(release.identity.canonicalUrl === currentExport.canonicalUrl, "export canonical URL drifted");
assert(routes.routes.length === currentExport.routes, "export route count drifted");
assert(Object.keys(routes.assets).length === currentExport.assets, "export asset count drifted");
assert(filesBelow(exported).length === currentExport.files, "export file count drifted");
assert(release.identity.buildRevision.match(/^[0-9a-f]{40}$/), "export revision is not immutable");
if (release.identity.buildRevision === currentExport.buildRevision) {
  assert(exportTreeDigest() === currentExport.treeSha256, "R6 export tree hash drifted");
  assert(sha256(join(exported, "route-manifest.json")) === currentExport.routeManifestSha256, "route manifest drifted");
  assert(sha256(join(exported, "release.json")) === currentExport.releaseManifestSha256, "release manifest drifted");
  assert(sha256(join(exported, "health.json")) === currentExport.healthManifestSha256, "health manifest drifted");
  assert(sha256(join(exported, "sitemap.xml")) === currentExport.sitemapSha256, "sitemap drifted");
}

assert(
  sha256(join(root, "priv/static/shadcn_ui.css")) === evidence.distribution.compiledCssSha256,
  "compiled CSS drifted",
);
// The recorded archive is working-tree evidence from the recorded local
// toolchain. CI deliberately uses a newer Beam toolchain and a synthetic PR
// merge revision, so its independently audited archive must not be compared to
// that local byte hash as though it were an exact clean-candidate build.
if (release.identity.buildRevision === currentExport.buildRevision) {
  assert(
    sha256(join(root, evidence.distribution.archive.file)) === evidence.distribution.archive.sha256,
    "candidate archive drifted",
  );
}
assert(consumer.candidate.sha256 === evidence.distribution.archive.sha256, "consumer archive drifted");
assert(consumer.consumer.testsPassed && consumer.consumer.browserPassed, "clean consumer failed");
assert(consumer.install.pathDependency === false, "clean consumer used a path dependency");

assert(Object.keys(evidence.reviewIssues).length === 11, "review issue inventory drifted");
assert(
  evidence.reviewIssues["VR-11"] ===
    "manual-risk-accepted-pending-and-reviewed-deployment-blocking",
  "VR-11 is not explicitly blocking",
);
assert(candidate.qualification.qualified === false, "candidate was incorrectly qualified");
assert(
  candidate.gates.find((gate) => gate.id === "manual-accessibility")?.status === "pending",
  "manual accessibility was incorrectly promoted",
);

const workflow = readFileSync(join(root, ".github/workflows/gallery.yml"), "utf8");
for (const gate of [
  "browser:milestone-b",
  "browser:milestone-f-phase4",
  "browser:milestone-g-remediation-r1",
  "browser:milestone-g-remediation-r4",
  "manual-risk:milestone-g:check",
]) {
  assert(workflow.includes(gate), `${gate} is absent from CI`);
}

const cleanConsumer = readFileSync(join(root, "scripts/run-clean-consumer.mjs"), "utf8");
assert(cleanConsumer.includes("findToolVersions"), "clean consumer does not preserve tool-version scope");

console.log(`Verified R6.2 local regression and export ${currentExport.treeSha256}.`);
