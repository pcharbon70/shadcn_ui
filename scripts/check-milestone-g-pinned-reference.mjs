import {createHash} from "node:crypto";
import {readFileSync, readdirSync, statSync} from "node:fs";
import {dirname, join, relative, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const referenceRoot = join(root, "demo/priv/reference/milestone_g/pinned-reference");
const manifest = JSON.parse(readFileSync(join(referenceRoot, "manifest.json"), "utf8"));
const presentation = JSON.parse(
  readFileSync(join(root, "demo/priv/reference/milestone_g/presentation-reference.json"), "utf8"),
);

function sha256(bytes) {
  return createHash("sha256").update(bytes).digest("hex");
}

function walk(directory) {
  return readdirSync(directory, {withFileTypes: true}).flatMap((entry) => {
    const path = join(directory, entry.name);
    return entry.isDirectory() ? walk(path) : [path];
  });
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

assert(manifest.schemaVersion === 1, "unexpected pinned-reference schema");
assert(manifest.status === "passed-rendered-and-reviewed-r5.2", "pinned-reference review is not closed");
assert(manifest.comparisonStatus === "passed-reviewed-r5.2", "pinned comparison is not accepted");
assert(
  manifest.upstream.commit === presentation.upstream.commit,
  "pinned-reference commit differs from presentation reference",
);
assert(
  manifest.buildReproduction.result === "passed-identical-builds-and-current-npm-cross-check",
  "upstream build is not closed",
);
assert(manifest.buildReproduction.cleanBuilds === 2, "two clean upstream builds were not recorded");
assert(
  manifest.buildReproduction.priorLimitation.reproduction ===
    "not-reproduced-on-linux-with-the-same-npm-version",
  "historical npm limitation was not diagnosed",
);
assert(manifest.harness.networkRequiredForVerification === false, "reference verification requires network");
assert(manifest.harness.movingPublicSiteAuthoritative === false, "moving site became authoritative");
assert(manifest.captureContract.states === presentation.states.length, "capture state count drifted");
assert(manifest.captureContract.motion === "reduced", "reference motion is not suppressed");
assert(
  sha256(readFileSync(join(root, manifest.captureContract.manifest))) ===
    manifest.captureContract.manifestSha256,
  "capture contract manifest drifted",
);

const sourceIdentity = presentation.upstream.inputs
  .map(({path, sha256: digest, bytes}) => `${digest}  ${bytes}  ${path}\n`)
  .join("");
assert(
  sha256(sourceIdentity) === manifest.upstream.sourceIdentitySha256,
  "pinned upstream source identity drifted",
);

const actualFiles = walk(referenceRoot)
  .map((path) => relative(referenceRoot, path))
  .filter((path) => path !== "manifest.json")
  .sort();
const recordedFiles = manifest.harness.files.map(({path}) => path).sort();
assert(JSON.stringify(actualFiles) === JSON.stringify(recordedFiles), "pinned-reference inventory drifted");

for (const recorded of manifest.harness.files) {
  const path = join(referenceRoot, recorded.path);
  const bytes = readFileSync(path);
  assert(statSync(path).size === recorded.bytes, `byte count drifted: ${recorded.path}`);
  assert(sha256(bytes) === recorded.sha256, `hash drifted: ${recorded.path}`);
}

const lock = JSON.parse(readFileSync(join(referenceRoot, "build-inputs/package-lock.json"), "utf8"));
assert(lock.lockfileVersion === manifest.buildReproduction.lockfileVersion, "lockfile version drifted");
assert(
  lock.packages["node_modules/astro"].version === manifest.buildReproduction.toolchain.astro,
  "Astro version drifted",
);
assert(
  lock.packages["node_modules/tailwindcss"].version === manifest.buildReproduction.toolchain.tailwindcss,
  "Tailwind version drifted",
);

const html = readFileSync(join(referenceRoot, "site/components/accordion/index.html"), "utf8");
assert(!/\bsrc=["']https?:\/\//i.test(html), "reference page contains a remote runtime source");
assert(!/static\.cloudflareinsights\.com/i.test(html), "reference page retains analytics runtime");
assert(html.includes('href="/_astro/_astro_content.C2KQ5fLA.css"'), "reference stylesheet changed");
assert(html.includes("Exclusive open, animated height auto"), "reference Accordion content changed");

const mit = readFileSync(join(referenceRoot, "LICENSE.unscripted-ui.txt"), "utf8");
const ofl = readFileSync(join(root, manifest.licenses.font), "utf8");
assert(mit.includes("Copyright (c) 2026 Ján Timoranský"), "upstream MIT notice missing");
assert(ofl.includes("SIL OPEN FONT LICENSE Version 1.1"), "font OFL notice missing");

console.log(`Verified ${recordedFiles.length} files in the renderable pinned reference.`);
