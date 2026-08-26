import { createHash } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";
import { join } from "node:path";

const root = new URL("../export/", import.meta.url);
const manifest = JSON.parse(await readFile(new URL("route-manifest.json", root), "utf8"));
if (manifest.schemaVersion !== 1) throw new Error("unsupported route manifest");

for (const entry of manifest.routes) {
  const content = await readFile(new URL(entry.file, root));
  const hash = createHash("sha256").update(content).digest("hex");
  if (hash !== entry.sha256) throw new Error(`stale route hash: ${entry.file}`);
  const html = content.toString("utf8");
  if (!html.includes("<main") || (!html.includes("Component navigation") && !html.includes("data-demo-form"))) throw new Error(`missing landmarks: ${entry.file}`);
  const runtime = html.replace(/<a\b[^>]*>/gi, "").replace(/<link\s+rel="canonical"\s+href="https:\/\/leco-industries-inc\.github\.io\/shadcn_ui[^"]*"\s*\/?\s*>/gi, "");
  if (/(?:src|href|srcset)="(?:https?:)?\/\//i.test(runtime)) throw new Error(`remote runtime URL: ${entry.file}`);
}

const assets = await readdir(new URL("assets/", root));
for (const asset of assets) {
  const content = await readFile(new URL(`assets/${asset}`, root));
  const hash = createHash("sha256").update(content).digest("hex");
  if (manifest.assets[asset] !== hash) throw new Error(`stale asset hash: ${asset}`);
}
