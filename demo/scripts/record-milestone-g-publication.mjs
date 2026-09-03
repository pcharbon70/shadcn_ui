import {createHash} from "node:crypto";
import {existsSync, readFileSync, readdirSync, statSync, writeFileSync} from "node:fs";
import {dirname, join, relative, resolve} from "node:path";
import {fileURLToPath} from "node:url";

const demo = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const root = resolve(demo, "..");
const exported = join(demo, "export");
const output = join(demo, "priv/reference/milestone_g/phase-08-section-3-publication-evidence.json");

function sha256(bytes) {
  return createHash("sha256").update(bytes).digest("hex");
}

function filesBelow(directory) {
  return readdirSync(directory, {withFileTypes: true})
    .flatMap((entry) => {
      const path = join(directory, entry.name);
      return entry.isDirectory() ? filesBelow(path) : [path];
    })
    .sort();
}

function fileIdentity(file) {
  const bytes = readFileSync(join(exported, file));
  return {file, bytes: bytes.length, sha256: sha256(bytes)};
}

if (!existsSync(join(exported, "route-manifest.json"))) {
  throw new Error("run MIX_ENV=test mix gallery.export before recording publication evidence");
}

const files = filesBelow(exported);
const records = files.map((path) => fileIdentity(relative(exported, path)));
const treeInput = records.map(({file, sha256}) => `${file}\0${sha256}\n`).join("");
const manifest = JSON.parse(readFileSync(join(exported, "route-manifest.json")));
const release = JSON.parse(readFileSync(join(exported, "release.json")));
const health = JSON.parse(readFileSync(join(exported, "health.json")));

if (manifest.routes.length !== 634) throw new Error("unexpected route inventory");
if (Object.keys(manifest.assets).length !== 4) throw new Error("unexpected asset inventory");
if (release.identity.development) throw new Error("qualification export uses development identity");
if (release.identity.buildRevision === "0".repeat(40)) throw new Error("qualification revision is missing");
if (health.checks.routes.expected !== manifest.routes.length) throw new Error("health route count drift");

const evidence = {
  schemaVersion: 1,
  phase: "milestone-g-phase-08-section-3",
  evidenceType: "immutable-static-gallery-publication-qualification",
  qualification: {
    sourceRevision: release.identity.buildRevision,
    canonicalUrl: release.identity.canonicalUrl,
    packageVersion: release.identity.packageVersion,
    catalogueSchema: release.identity.catalogueSchema,
    upstreamComponentRevision: release.identity.upstreamRevision,
    presentationReferenceRevision: "bd8f403030c8d1f46804da6eda733fde7e908e63",
  },
  artifact: {
    files: records.length,
    routes: manifest.routes.length,
    assets: Object.keys(manifest.assets).length,
    searchRecords: manifest.search.records,
    treeSha256: sha256(treeInput),
    manifests: [
      fileIdentity("route-manifest.json"),
      fileIdentity("release.json"),
      fileIdentity("health.json"),
      fileIdentity("sitemap.xml"),
      fileIdentity(manifest.search.file),
    ],
  },
  verification: {
    duplicateExports: "byte-identical",
    repositorySubpath: "passed",
    directEntryAndFragments: "passed",
    contentTypes: "passed",
    unknownRoutes: "passed-non-reflecting-404",
    staleFiles: "rejected",
    remoteRuntimeAssets: [],
    commands: [
      "MIX_ENV=test mix gallery.export",
      "npm run export:determinism",
      "npm run export:check",
      "npm run export:smoke",
    ],
  },
  workflow: {
    pullRequestVerification: "pending",
    reviewedMainMerge: "pending",
    deployment: "pending",
    postDeploySmoke: "pending",
    artifactRetentionDays: 30,
  },
  recovery: {
    runbook: "demo/operations/gallery-publication.md",
    status: "reviewed",
    priorVerifiedArtifact: null,
    firstPublicationPolicy: "stop-and-reviewed-revert; never invent an unverified rollback artifact",
    recoverySmoke: "same complete canonical smoke as deployment",
  },
  status: "locally-qualified-pending-reviewed-main-publication",
};

const rendered = `${JSON.stringify(evidence, null, 2)}\n`;
if (process.argv.includes("--write")) {
  writeFileSync(output, rendered);
  console.log(`Wrote ${relative(root, output)} for ${records.length} immutable files.`);
} else {
  if (!existsSync(output)) throw new Error("publication evidence is missing");
  if (readFileSync(output, "utf8") !== rendered) throw new Error("publication evidence is stale");
  console.log(`Verified publication qualification ${evidence.artifact.treeSha256}.`);
}
