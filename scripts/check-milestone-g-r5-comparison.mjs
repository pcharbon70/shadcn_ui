import {createHash} from "node:crypto";
import {readFileSync, readdirSync} from "node:fs";
import {basename, dirname, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const evidencePath = resolve(
  root,
  "demo/priv/reference/milestone_g/remediation-r5-comparison-evidence.json",
);
const evidence = JSON.parse(readFileSync(evidencePath, "utf8"));
const reference = JSON.parse(
  readFileSync(resolve(root, "demo/priv/reference/milestone_g/pinned-reference/manifest.json"), "utf8"),
);

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

function verifyPng(record) {
  const bytes = readFileSync(resolve(root, record.file));
  assert(bytes.subarray(0, 8).toString("hex") === "89504e470d0a1a0a", `not PNG: ${record.file}`);
  assert(createHash("sha256").update(bytes).digest("hex") === record.sha256, `hash drift: ${record.file}`);
  assert(bytes.readUInt32BE(16) === record.viewport.width, `width drift: ${record.file}`);
  assert(bytes.readUInt32BE(20) === record.viewport.height, `height drift: ${record.file}`);
  return basename(record.file);
}

assert(evidence.status === "passed-reviewed-r5.2", "R5.2 comparison is not accepted");
assert(evidence.upstreamCommit === reference.upstream.commit, "comparison pin drifted");
assert(evidence.networkRequiredForVerification === false, "comparison requires network");
assert(evidence.movingPublicSiteAuthoritative === false, "moving site became authoritative");
assert(evidence.routes.reference === "/components/accordion/", "reference route drifted");
assert(evidence.routes.local === "/components/disclosure/accordion", "local route drifted");
assert(evidence.routes.foundationCategory === "/components/foundation", "Foundation route drifted");
assert(evidence.states.length === 8, "expected eight comparison states");
assert(evidence.foundationCategoryCaptures.length === 4, "expected four Foundation captures");
assert(evidence.reviewedExceptions.length === 5, "comparison exceptions are incomplete");

const recordedFiles = [];
for (const state of evidence.states) {
  assert(state.accordionRegion.reviewedDifferenceRatio <= state.accordionRegion.maximumDifferenceRatio,
    `unaccepted Accordion delta: ${state.id}`);
  recordedFiles.push(verifyPng({...state.reference, viewport: state.viewport}));
  recordedFiles.push(verifyPng({...state.local, viewport: state.viewport}));
}
for (const capture of evidence.foundationCategoryCaptures) recordedFiles.push(verifyPng(capture));

const snapshots = resolve(root, "test/browser/milestone-g-remediation-r5.spec.mjs-snapshots");
const actualFiles = readdirSync(snapshots).filter((file) => file.endsWith(".png")).sort();
assert(JSON.stringify(actualFiles) === JSON.stringify(recordedFiles.sort()), "R5 snapshot inventory drifted");
console.log(`Verified ${recordedFiles.length} reviewed R5 comparison captures.`);
