import {createHash} from "node:crypto";
import {readFile} from "node:fs/promises";
import {chromium, firefox, webkit} from "../demo/node_modules/playwright/index.mjs";

const root = new URL("../", import.meta.url);
const evidence = JSON.parse(await readFile(new URL("demo/priv/compatibility/milestone_f_engine_evidence.json", root)));
const lock = await readFile(new URL("demo/package-lock.json", root));
const lockHash = createHash("sha256").update(lock).digest("hex");
if (lockHash !== evidence.lock.packageLockSha256) throw new Error("demo package lock identity changed");

for (const [name, type] of Object.entries({chromium, firefox, webkit})) {
  const browser = await type.launch({headless: true});
  try {
    const version = browser.version();
    if (version !== evidence.engines[name].version) {
      throw new Error(`${name} version mismatch: ${version}`);
    }
    const revision = type.executablePath().match(new RegExp(`${name === "chromium" ? "chromium" : name}-(\\d+)`))?.[1];
    if (revision !== evidence.engines[name].revision) {
      throw new Error(`${name} revision mismatch: ${revision}`);
    }
  } finally {
    await browser.close();
  }
}

console.log("Exact locked compatibility evidence identity verified");
