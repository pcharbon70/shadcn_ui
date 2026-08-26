import { chromium, firefox, webkit } from "../demo/node_modules/@playwright/test/index.mjs";
import { readFileSync, writeFileSync } from "node:fs";

const manifest = JSON.parse(readFileSync(new URL("../priv/compatibility/native_overlays.json", import.meta.url), "utf8"));
const evidence = { schemaVersion: 1, reviewedOn: "2026-08-26", sourceReview: "HTML Living Standard dialog and Popover; CSS Anchor Positioning Level 1", engines: {} };
for (const [name, engine] of Object.entries({ chromium, firefox, webkit })) {
  const browser = await engine.launch({ headless: true });
  try {
    if (browser.version() !== manifest.verificationEvidence.engines[name].version) throw new Error(`Update authored browser review before recording ${name}`);
    const page = await browser.newPage();
    await page.setContent("<!doctype html><button>Invoker</button><dialog></dialog><div></div>");
    const capabilities = await page.evaluate(() => ({
      dialog: typeof HTMLDialogElement.prototype.showModal === "function",
      dialogInvokerCommands: "commandForElement" in HTMLButtonElement.prototype,
      dialogClosedBy: "closedBy" in HTMLDialogElement.prototype,
      popover: "popover" in HTMLElement.prototype,
      popoverTarget: "popoverTargetElement" in HTMLButtonElement.prototype,
      anchorPositioning: CSS.supports("anchor-name: --shadcn-ui-test"),
      positionFallbacks: CSS.supports("position-try-fallbacks: flip-block"),
      discreteTransitions: CSS.supports("transition-behavior: allow-discrete"),
      interestInvokers: "interestForElement" in HTMLButtonElement.prototype
    }));
    evidence.engines[name] = { version: browser.version(), capabilities };
  } finally { await browser.close(); }
}
const output = JSON.stringify(evidence, null, 2) + "\n";
const target = new URL("../demo/priv/compatibility/native_overlay_evidence.json", import.meta.url);
if (process.argv.includes("--check")) {
  if (readFileSync(target, "utf8").replaceAll("\r\n", "\n") !== output) throw new Error("Capability evidence is stale; review the locked matrix before regenerating it");
  console.log("Three-engine capability evidence matches the authored record.");
} else {
  writeFileSync(target, output);
}
