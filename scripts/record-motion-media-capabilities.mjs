import { chromium, firefox, webkit } from "../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync, writeFileSync } from "node:fs";
import { manifest, observe } from "../test/browser/support/motion-media-probe.mjs";
const lock = JSON.parse(readFileSync(new URL("../demo/node_modules/playwright-core/browsers.json", import.meta.url), "utf8"));
const version = JSON.parse(readFileSync(new URL("../demo/node_modules/@playwright/test/package.json", import.meta.url), "utf8")).version;
if (version !== manifest.verificationEvidence.implementationVersion) throw new Error("Review Playwright lock change");
const evidence = { schemaVersion: 1, reviewedOn: manifest.reviewedOn, scope: "Platform probes only; component acceptance belongs to later phases.", engines: {} };
for (const [name, engine] of Object.entries({ chromium, firefox, webkit })) {
  const browser = await engine.launch({ headless: true });
  try {
    const expected = manifest.verificationEvidence.engines[name];
    if (browser.version() !== expected.version || lock.browsers.find(b => b.name === name).revision !== expected.revision) throw new Error("Review engine lock change: " + name);
    const page = await browser.newPage();
    evidence.engines[name] = { version: browser.version(), revision: expected.revision, ...await observe(page) };
  } finally { await browser.close(); }
}
const bytes = JSON.stringify(evidence, null, 2) + "\n";
const target = new URL("../demo/priv/compatibility/motion_media_evidence.json", import.meta.url);
if (process.argv.includes("--check")) {
  if (readFileSync(target, "utf8").replaceAll("\r\n", "\n") !== bytes) throw new Error("Motion/media evidence drift; review before recording");
  console.log("Three-engine motion/media evidence matches.");
} else { writeFileSync(target, bytes); console.log(bytes); }
