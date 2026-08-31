import { createHash } from "node:crypto";
import { mkdir, readFile, rm, writeFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const output = join(root, "priv", "static", "assets");
const inputs = [
  ["shadcn", join(root, "..", "priv", "static", "shadcn_ui.css"), "css"],
  ["gallery", join(root, "assets", "gallery.css"), "css"],
  ["gallery", join(root, "assets", "gallery.js"), "js"],
  ["bricolage-grotesque-wght", join(root, "assets", "fonts", "bricolage-grotesque-wght.woff2"), "woff2"]
];

await mkdir(output, { recursive: true });
for (const entry of await (await import("node:fs/promises")).readdir(output)) {
  if (/^(?:shadcn|gallery|bricolage-grotesque-wght)-[a-f0-9]{16}\.(?:css|js|woff2)$/.test(entry)) await rm(join(output, entry));
}

const manifest = {};
for (const [name, input, extension] of inputs) {
  const content = await readFile(input);
  const hash = createHash("sha256").update(content).digest("hex").slice(0, 16);
  const file = `${name}-${hash}.${extension}`;
  await writeFile(join(output, file), content);
  manifest[`${name}.${extension}`] = `/assets/${file}`;
}

await writeFile(join(output, "manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
