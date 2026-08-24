import { execFileSync } from "node:child_process";
import { readFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const before = await readFile(join(root, "priv", "static", "assets", "manifest.json"), "utf8");
execFileSync(process.execPath, [join(root, "scripts", "build-assets.mjs")], { stdio: "inherit" });
const after = await readFile(join(root, "priv", "static", "assets", "manifest.json"), "utf8");
if (before !== after) throw new Error("gallery asset manifest is stale");
