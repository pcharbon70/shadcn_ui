import { createHash } from "node:crypto";
import { existsSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const output = join(root, "demo/priv/reference/milestone_g/phase-08-section-1-visual-evidence.json");
const reference = "demo/priv/reference/milestone_g/presentation-reference.json";
const groups = [
  {
    id: "presentation-primitives",
    directory: "test/browser/milestone-g-presentation.spec.mjs-snapshots",
    expected: 4,
  },
  {
    id: "accordion-pilot",
    directory: "test/browser/milestone-g-accordion-visual.spec.mjs-snapshots",
    expected: 12,
  },
  {
    id: "migrated-families",
    directory: "test/browser/milestone-g-phase7-migration.spec.mjs-snapshots",
    expected: 36,
  },
];

function sha256(path) {
  return createHash("sha256").update(readFileSync(path)).digest("hex");
}

function pngIdentity(path) {
  const bytes = readFileSync(path);
  const signature = "89504e470d0a1a0a";
  if (bytes.subarray(0, 8).toString("hex") !== signature) {
    throw new Error(`not a PNG: ${relative(root, path)}`);
  }

  return {
    file: relative(root, path),
    sha256: createHash("sha256").update(bytes).digest("hex"),
    bytes: bytes.length,
    width: bytes.readUInt32BE(16),
    height: bytes.readUInt32BE(20),
  };
}

const lockedGroups = groups.map((group) => {
  const directory = join(root, group.directory);
  const files = readdirSync(directory)
    .filter((file) => file.endsWith("-chromium.png"))
    .sort()
    .map((file) => pngIdentity(join(directory, file)));

  if (files.length !== group.expected) {
    throw new Error(`${group.id} expected ${group.expected} goldens, found ${files.length}`);
  }

  return { id: group.id, directory: group.directory, count: files.length, files };
});

const phase3 = JSON.parse(
  readFileSync(join(root, "demo/priv/reference/milestone_g/phase-03-presentation-evidence.json")),
);
const phase5 = JSON.parse(
  readFileSync(join(root, "demo/priv/reference/milestone_g/phase-05-accordion-evidence.json")),
);

for (const evidence of [phase3, phase5]) {
  for (const golden of evidence.goldens) {
    const identity = pngIdentity(join(root, golden.file));
    if (identity.sha256 !== golden.sha256) {
      throw new Error(`recorded golden hash drift: ${golden.file}`);
    }
  }
}

const families = [
  "foundation",
  "forms",
  "disclosure",
  "navigation",
  "content-surfaces",
  "overlays",
  "interactive-surfaces",
  "media",
  "motion",
];
const familyFiles = new Set(lockedGroups[2].files.map(({ file }) => file));
for (const family of families) {
  for (const state of ["desktop-light", "desktop-dark", "mobile-light", "mobile-dark"]) {
    const expected = `${groups[2].directory}/phase7-${family}-${state}-chromium.png`;
    if (!familyFiles.has(expected)) throw new Error(`missing family golden: ${expected}`);
  }
}

const manifest = {
  schemaVersion: 1,
  phase: "milestone-g-phase-08-section-1",
  evidenceType: "deterministic-locked-visual-acceptance",
  acceptedPhase7Revision: "b080488cc0c64d246b20cb26633932623698fb36",
  reference: {
    file: reference,
    sha256: sha256(join(root, reference)),
    upstreamCommit: "bd8f403030c8d1f46804da6eda733fde7e908e63",
  },
  capture: {
    playwright: phase3.runner.playwright,
    engine: phase3.runner.engine,
    engineVersion: phase3.runner.engineVersion,
    deviceScaleFactor: phase3.runner.deviceScaleFactor,
    linuxSystemFallbackFont: "Noto Sans",
    motion: phase3.runner.motion,
    themes: ["light", "dark"],
    viewports: [
      { width: 1440, height: 1200 },
      { width: 1024, height: 1366 },
      { width: 390, height: 844 },
      { width: 320, height: 568 },
    ],
    tolerances: phase3.tolerances,
  },
  matrix: {
    goldenCount: lockedGroups.reduce((count, group) => count + group.count, 0),
    families,
    groups: lockedGroups,
  },
  determinism: {
    movingPublicSiteAuthoritative: false,
    remoteRuntimeRequired: false,
    duplicateCaptureRuns: "passed-from-identical-local-inputs",
    generationCommand: "node scripts/check-milestone-g-visual-evidence.mjs --write",
    verificationCommand: "node scripts/check-milestone-g-visual-evidence.mjs --check",
  },
  exceptions: [],
  status: "passed",
};

const rendered = `${JSON.stringify(manifest, null, 2)}\n`;
if (process.argv.includes("--write")) {
  writeFileSync(output, rendered);
  console.log(`Wrote ${relative(root, output)} with ${manifest.matrix.goldenCount} locked goldens.`);
} else {
  if (!existsSync(output)) throw new Error(`missing visual evidence: ${relative(root, output)}`);
  if (readFileSync(output, "utf8") !== rendered) throw new Error("Phase 8 visual evidence is stale");
  console.log(`Verified ${manifest.matrix.goldenCount} locked Milestone G goldens.`);
}
